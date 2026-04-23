@isTest
private class CaseAfterUpdateNotifyOwnerTest {

    @TestSetup
    static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' OR UserType = 'Standard' LIMIT 1];
        
        User u = new User(
            Alias = 'novousr',
            Email = 'novodono@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'NovoDono',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'novodono' + System.currentTimeMillis() + '@testorg.com'
        );
        insert u;

        Case c = new Case(
            Subject = 'Teste de Notificação',
            Status = 'New',
            OwnerId = UserInfo.getUserId() 
        );
        insert c;
    }

    @isTest
    static void testOwnerChangeNotification() {
        User newOwner = [SELECT Id FROM User WHERE Email = 'novodono@testorg.com' LIMIT 1];
        Case c = [SELECT Id, OwnerId FROM Case LIMIT 1];

        Test.startTest();
        
        c.OwnerId = newOwner.Id;
        update c;
        
        Test.stopTest();

        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :c.Id];
        System.assertEquals(newOwner.Id, updatedCase.OwnerId, 'O dono do caso deve ter sido atualizado com sucesso.');
      
    }
}