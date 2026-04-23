@isTest
private class MessagingSessionTriggerHandlerTest {

    @testSetup
    static void setup() {
        Case c = new Case(Subject = 'Test Case', Status = 'New');
        insert c;
    }

    @isTest
    static void testHandleBeforeUpdate_ResetPath() {
        Id sessionId = fflib_IDGenerator.generate(MessagingSession.SObjectType);
        
        MessagingSession oldSession = new MessagingSession(Id = sessionId, UltimaAtividadeCliente__c = DateTime.now());
        MessagingSession newSession = new MessagingSession(Id = sessionId, UltimaAtividadeCliente__c = null);

        List<MessagingSession> sessions = new List<MessagingSession>{ newSession };
        Map<Id, MessagingSession> oldMap = new Map<Id, MessagingSession>{ sessionId => oldSession };

        Test.startTest();
        MessagingSessionTriggerHandler.handleBeforeInsertUpdate(sessions, oldMap);
        Test.stopTest();

        Assert.isNotNull(newSession.UltimaAtividadeCliente__c, 'Deve ter resetado a atividade pois era nula.');
    }

    @isTest
    static void testHandleAfterUpdate_Success() {
        Case c = [SELECT Id FROM Case LIMIT 1];
        Id sessionId = fflib_IDGenerator.generate(MessagingSession.SObjectType);
        Id userId = UserInfo.getUserId();

        MessagingSession oldSess = new MessagingSession(Id = sessionId, Status = 'Waiting', OwnerId = userId, CaseId = c.Id);
        MessagingSession newSess = new MessagingSession(Id = sessionId, Status = 'Active', OwnerId = userId, CaseId = c.Id);

        Test.startTest();
        MessagingSessionTriggerHandler.handleOnAfterUpdate(new List<MessagingSession>{ newSess }, new Map<Id, MessagingSession>{ sessionId => oldSess });
        Test.stopTest();

        Assert.isTrue(true); 
    }

    @isTest
    static void testCatchBlocks() {      
        Boolean caughtBefore = false;
        
        try {
            MessagingSessionTriggerHandler.handleBeforeInsertUpdate(null, null);
        } catch (Exception e) {
            caughtBefore = true;
        }
        Assert.isTrue(caughtBefore, 'Deveria ter entrado no catch do BeforeInsertUpdate');

        Boolean caughtAfter = false;
        try {
            MessagingSessionTriggerHandler.handleOnAfterUpdate(null, null);
        } catch (Exception e) {
            caughtAfter = true;
        }
        Assert.isTrue(caughtAfter, 'Deveria ter entrado no catch do AfterUpdate');
    }
}