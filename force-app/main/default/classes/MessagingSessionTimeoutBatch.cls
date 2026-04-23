global class MessagingSessionTimeoutBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private static final String WARNING_MESSAGE = '👋 Olá! Você ainda está por aí?  Para continuarmos o atendimento, por favor, me envie uma mensagem.  Caso contrário, a conversa será encerrada automaticamente em 10 minutos.';
    private static final String CLOSE_MESSAGE = '💬 Como não recebemos resposta, este atendimento está sendo encerrado. Mas não se preocupe! 😊 Se precisar de algo, é só me chamar.  A Auxiliadora Predial agradece seu contato. 💚';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime warningThreshold = DateTime.now().addMinutes(-10);
        
        return Database.getQueryLocator([
            SELECT Id, Status, UltimaAtividadeCliente__c, AvisoEnviado__c, 
                   StatusTimeoutSessao__c, ConversationId
            FROM MessagingSession
            WHERE Status = 'Active'
            AND UltimaAtividadeCliente__c != null
            AND UltimaAtividadeCliente__c <= :warningThreshold
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<MessagingSession> scope) {
        DateTime warningThreshold = DateTime.now().addMinutes(-10);
        DateTime closeThreshold = DateTime.now().addMinutes(-20);
        
        List<MessagingSession> toUpdate = new List<MessagingSession>();
        
        for (MessagingSession session : scope) {
            // sessão inativa há mais de 20 min E aviso já enviado -> encerrar
            if (session.UltimaAtividadeCliente__c <= closeThreshold 
                && session.AvisoEnviado__c == true) {
                sendMessage(session.Id, CLOSE_MESSAGE);
                session.Status = 'Ended';
                session.StatusTimeoutSessao__c = 'Closed';
                toUpdate.add(session);
            } 
            // sessão inativa há mais de 10 min E aviso ainda não enviado -> enviar aviso
            else if (session.UltimaAtividadeCliente__c <= warningThreshold 
                     && session.AvisoEnviado__c == false) {
                sendMessage(session.Id, WARNING_MESSAGE);
                session.AvisoEnviado__c = true;
                session.StatusTimeoutSessao__c = 'Warned';
                toUpdate.add(session);
            }
        }
        
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('MessagingSessionTimeoutBatch finished');
    }
    
    private void sendMessage(Id sessionId, String messageText) {
        if (sessionId == null) {
            System.debug('SessionId is null, cannot send message');
            return;
        }
        
        try {
            // Publicar evento de plataforma para o Flow enviar a mensagem
            // Isso evita dependência de métodos Apex que podem não estar disponíveis
            // e segue a recomendação de Salesforce para Enhanced Messaging
            BotTimeoutEvent__e event = new BotTimeoutEvent__e();
            event.MessagingSessionId__c = sessionId;
            event.MessageText__c = messageText;
            
            EventBus.publish(event);
            System.debug('Event published for Session: ' + sessionId);
        } catch (Exception e) {
            System.debug('Error publishing event: ' + e.getMessage());
        }
    }
}