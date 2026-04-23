@isTest
private class CardCasePropertyInfoControllerTest {

    @isTest
    static void testGetPropertyOwnerFromCaseWithValidId() {
        Account owner = new Account(
            Name = 'Proprietário',
            Type = 'Pessoa Física',
            Phone = '51999999999',
            CA_Email__c = 'proprietario@auxi.com'
        );
        insert owner;

        CA_Imovel__c imovel = new CA_Imovel__c(
            Name = 'Imóvel Teste',
            CA_ProprietarioImovel__c = owner.Id
        );
        insert imovel;

        Case c = new Case(
            Subject = 'Caso Teste',
            CA_Imovel__c = imovel.Id
        );
        insert c;

        Test.startTest();
        Account result = CardCasePropertyInfoController.getPropertyOwnerFromCase(c.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(owner.Id, result.Id);
        System.assertEquals('Proprietário', result.Name);
    }

    @isTest
    static void testGetPropertyOwnerFromCaseWithNullId() {
        Test.startTest();
        Account result = CardCasePropertyInfoController.getPropertyOwnerFromCase(null);
        Test.stopTest();

        System.assertEquals(null, result);
    }
}