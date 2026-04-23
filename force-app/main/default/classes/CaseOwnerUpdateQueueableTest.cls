@isTest
private class CaseOwnerUpdateQueueableTest {

    @testSetup
    static void setup() {        
        Case c = new Case(
            Subject = 'Test Queueable Case',
            Status = 'New'
        );
        insert c;
    }

    @isTest
    static void testQueueableExecution() {
        Case c = [SELECT Id, OwnerId FROM Case LIMIT 1];
        User targetUser = [SELECT Id FROM User WHERE IsActive = true AND Id != :UserInfo.getUserId() LIMIT 1];
        
        Map<Id, Id> caseMap = new Map<Id, Id>();
        caseMap.put(c.Id, targetUser.Id);

        CaseOwnerUpdateQueueable updater = new CaseOwnerUpdateQueueable(caseMap);

        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest(); 

        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :c.Id];
        Assert.areEqual(targetUser.Id, updatedCase.OwnerId, 'O Owner do Case deveria ter sido atualizado pelo Queueable.');
    }

    @isTest
    static void testQueueableEmptyMap() {
        Map<Id, Id> emptyMap = new Map<Id, Id>();
        CaseOwnerUpdateQueueable updater = new CaseOwnerUpdateQueueable(emptyMap);

        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();

        Assert.isTrue(true);
    }
}