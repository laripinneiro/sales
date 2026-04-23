public with sharing class MessagingSessionService {

    public static void resetTimeoutTracking(MessagingSession session) {
        session.UltimaAtividadeCliente__c = DateTime.now();
        session.AvisoEnviado__c = false;
        session.StatusTimeoutSessao__c = 'Active';
    }

    /**
     * Isto precisa ser refatorado!!!
     * por Bárbara, em 10/03,26
     */
    public static Boolean hasCustomerActivity(MessagingSession newSession, MessagingSession oldSession) {
        if (oldSession.StatusTimeoutSessao__c == 'Warned' && 
            newSession.StatusTimeoutSessao__c == 'Active') {
            return true;
        }

        if (newSession.AcceptTime != oldSession.AcceptTime) {
            return true;
        }

        try {
            Object newCount = newSession.get('MessageCount');
            Object oldCount = oldSession.get('MessageCount');
            if (newCount != null && oldCount != null && newCount != oldCount) {
                 return true;
            }
        } catch (Exception e) {
        }

        try {
             Object newEndCount = newSession.get('EndUserMessageCount');
             Object oldEndCount = oldSession.get('EndUserMessageCount');
             if (newEndCount != null && oldEndCount != null && newEndCount != oldEndCount) {
                 return true;
             }
        } catch (Exception e) {
        }

        if (oldSession.Status != 'Active' && newSession.Status == 'Active') {
            return true;
        }
        
        return false;
    }

    public static void initializeTimeoutFields(MessagingSession session) {
        session.UltimaAtividadeCliente__c = DateTime.now();
        session.AvisoEnviado__c = false;
        session.StatusTimeoutSessao__c = 'Active';
    }

    public static void handleCaseOwnerSync(MessagingSession session, MessagingSession oldSession, Map<Id, Id> casesToSync) {
        System.debug('[handleCaseOwnerSync]' + session.OwnerId + ' | ' + oldSession.OwnerId);
        
        if (session.Status != oldSession.Status && String.valueOf(session.OwnerId).startsWith('005') && session.CaseId != null) {
            System.debug('[antes] casesToSync = ' + casesToSync);
            casesToSync.put(session.CaseId, session.OwnerId);
            System.debug('[depois] casesToSync = ' + casesToSync);
        }              
    }
}