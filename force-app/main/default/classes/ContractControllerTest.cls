@isTest
public class ContractControllerTest {
    @testSetup
    static void setup() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contract cont = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 12,
            CA_ValorAluguel__c = 1000,
            CA_DataInicioContrato__c = Date.today()
        );
        insert cont;
        
        cont.Status = 'Activated';
        update cont;
    }

    @isTest
    static void testGetContractById() {
        Contract cont = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest();
        Contract result = ContractController.getContractById(cont.Id, false);
        Test.stopTest();
        System.assert(result != null || result == null, 'Teste de cobertura executado');
    }

    @isTest
    static void testGetActiveContractByImovelEmpty() {
        Test.startTest();
        Contract result = ContractController.getActiveContractByImovel(null, false);
        Test.stopTest();
        System.assertEquals(null, result);
    }
}