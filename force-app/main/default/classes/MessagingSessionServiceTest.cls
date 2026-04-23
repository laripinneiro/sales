@isTest
private class MessagingSessionServiceTest {

    @isTest
    static void testResetTimeoutTracking() {
        MessagingSession session = new MessagingSession();
        
        Test.startTest();
        MessagingSessionService.resetTimeoutTracking(session);
        Test.stopTest();
        
        Assert.isNotNull(session.UltimaAtividadeCliente__c, 'A data de última atividade deve ser preenchida.');
        Assert.isFalse(session.AvisoEnviado__c, 'O aviso enviado deve ser resetado para falso.');
        Assert.areEqual('Active', session.StatusTimeoutSessao__c, 'O status de timeout deve ser Active.');
    }

    @isTest
    static void testHasCustomerActivity_StatusChange() {
        MessagingSession oldSess = new MessagingSession(StatusTimeoutSessao__c = 'Warned');
        MessagingSession newSess = new MessagingSession(StatusTimeoutSessao__c = 'Active');

        Boolean result = MessagingSessionService.hasCustomerActivity(newSess, oldSess);
        
        Assert.isTrue(result, 'Deve retornar true quando o status muda de Warned para Active');
    }

    @isTest
    static void testHasCustomerActivity_AcceptTimeChange() {
        Datetime now = Datetime.now();
        MessagingSession oldSess = new MessagingSession(AcceptTime = now);
        MessagingSession newSess = new MessagingSession(AcceptTime = now.addMinutes(1));

        Boolean result = MessagingSessionService.hasCustomerActivity(newSess, oldSess);
        
        Assert.isTrue(result, 'Deve retornar true quando o AcceptTime é alterado');
    }

    @isTest
    static void testHasCustomerActivity_NoActivity() {
        MessagingSession oldSess = new MessagingSession(StatusTimeoutSessao__c = 'Active', Status = 'Active');
        MessagingSession newSess = new MessagingSession(StatusTimeoutSessao__c = 'Active', Status = 'Active');

        Boolean result = MessagingSessionService.hasCustomerActivity(newSess, oldSess);
        
        Assert.isFalse(result, 'Deve retornar false quando não houver alterações relevantes');
    }

    @isTest
    static void testInitializeTimeoutFields() {
        MessagingSession session = new MessagingSession();

        Test.startTest();
        MessagingSessionService.initializeTimeoutFields(session);
        Test.stopTest();

        Assert.areEqual('Active', session.StatusTimeoutSessao__c);
        Assert.isFalse(session.AvisoEnviado__c);
    }

    @isTest
    static void testHandleCaseOwnerSync_Success() {
        
        Id userId = fflib_IDGenerator.generate(User.SObjectType); 
        Id caseId = '500000000000001AAA'; 
        Id agentId = '005000000000001AAA';

        MessagingSession oldSess = new MessagingSession(Status = 'Waiting', OwnerId = agentId);
        MessagingSession newSess = new MessagingSession(Status = 'Active', OwnerId = agentId, CaseId = caseId);
        
        Map<Id, Id> casesToSync = new Map<Id, Id>();

        Test.startTest();
        MessagingSessionService.handleCaseOwnerSync(newSess, oldSess, casesToSync);
        Test.stopTest();

        Assert.isTrue(casesToSync.containsKey(caseId), 'O mapa deve conter o CaseId');
        Assert.areEqual(agentId, casesToSync.get(caseId), 'O Owner do Case deve ser o mesmo da Sessão');
    }

    @isTest
    static void testHandleCaseOwnerSync_NoStatusChange() {
        Id caseId = '500000000000001AAA';
        Id agentId = '005000000000001AAA';

        MessagingSession oldSess = new MessagingSession(Status = 'Active', OwnerId = agentId);
        MessagingSession newSess = new MessagingSession(Status = 'Active', OwnerId = agentId, CaseId = caseId);
        
        Map<Id, Id> casesToSync = new Map<Id, Id>();

        MessagingSessionService.handleCaseOwnerSync(newSess, oldSess, casesToSync);

        Assert.isTrue(casesToSync.isEmpty(), 'O mapa deve estar vazio pois o status não mudou');
    }
}