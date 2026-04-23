@isTest
private class BatchFixPersonEmailsTest {

    @testSetup
    static void setup() {
        Id personAccountRecordTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

        Account personAcc = new Account(
            FirstName = 'Teste',
            LastName = 'Person',
            CA_Email__c = 'person@teste.com',
            RecordTypeId = personAccountRecordTypeId
        );
        insert personAcc;

        Account bizAcc = new Account(
            Name = 'Empresa Teste',
            CA_Email__c = 'business@teste.com'
        );
        insert bizAcc;

        Contact con = new Contact(
            FirstName = 'Contato',
            LastName = 'Teste',
            AccountId = bizAcc.Id,
            Email = null 
        );
        insert con;
    }

    @isTest
    static void testBatchEmailSync() {
        Test.startTest();
        BatchFixPersonEmails batch = new BatchFixPersonEmails();
        Database.executeBatch(batch);
        Test.stopTest();

        Account updatedPersonAcc = [SELECT PersonEmail, CA_Email__c FROM Account WHERE LastName = 'Person' LIMIT 1];
        System.assertEquals(updatedPersonAcc.CA_Email__c, updatedPersonAcc.PersonEmail, 
            'O PersonEmail deveria ter sido sincronizado com o CA_Email__c');

        Contact updatedContact = [SELECT Email FROM Contact WHERE LastName = 'Teste' LIMIT 1];
        System.assertEquals('business@teste.com', updatedContact.Email, 
            'O e-mail do Contato deveria ter sido preenchido com o CA_Email__c da conta pai');
    }

    @isTest
    static void testBatchWithNoChanges() {
        Contact con = [SELECT Id, Email FROM Contact WHERE LastName = 'Teste' LIMIT 1];
        
        con.Email = 'business@teste.com';
        update con;

        Test.startTest();
        BatchFixPersonEmails batch = new BatchFixPersonEmails();
        Database.executeBatch(batch);
        Test.stopTest();

        Contact finalContact = [SELECT Email FROM Contact WHERE Id = :con.Id];
        System.assertEquals('business@teste.com', finalContact.Email, 'O e-mail não deveria ter mudado');
    }
}