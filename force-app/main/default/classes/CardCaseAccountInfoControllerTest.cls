@isTest
private class CardCaseAccountInfoControllerTest {

    @isTest
    static void testGetAccountFromCaseWithValidId() {
        Account acc = new Account(
            Name = 'Joana Auxi',
            Type = 'Customer',
            Phone = '123456789',
            CA_Email__c = 'joana@auxi.com'
        );
        insert acc;

        Case c = new Case(
            Subject = 'Case - Joana',
            AccountId = acc.Id
        );
        insert c;

        Test.startTest();
        Account result = CardAccountInfoController.getAccountFromCase(c.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Id);
        System.assertEquals('Joana Auxi', result.Name);
    }

    @isTest
    static void testGetAccountFromCaseWithNullId() {
        Test.startTest();
        Account result = CardAccountInfoController.getAccountFromCase(null);
        Test.stopTest();

        System.assertEquals(null, result);
    }
}