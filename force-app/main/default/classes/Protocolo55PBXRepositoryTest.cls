@isTest
private class Protocolo55PBXRepositoryTest {
    
    @isTest
    static void testSaveAndFind() {
        Protocolo55PBXRepository repo = new Protocolo55PBXRepository();
        Protocolo__c proto = new Protocolo__c(
            CallSourceId__c = 'TEST-REPO-001', 
            CallSourcePhone__c = '11999990000',
            ProtocolSource__c = 'Integração 55PBX'
        );

        Test.startTest();
        repo.save(proto);
        Test.stopTest();

        System.assertNotEquals(null, proto.Id, 'O registro deveria ter um ID após salvar.');

        Protocolo__c retrieved = repo.findById(proto.Id);

        System.assertEquals('TEST-REPO-001', retrieved.CallSourceId__c);
    }

    @isTest
    static void testFindByIdNull() {
        Protocolo55PBXRepository repo = new Protocolo55PBXRepository();
        try {
            repo.findById(null);
            System.assert(false, 'Deveria ter lançado exceção');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Não retornou salesforceId'));
        }
    }
}