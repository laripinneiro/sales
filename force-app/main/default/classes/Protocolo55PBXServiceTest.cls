@isTest
private class Protocolo55PBXServiceTest {

    @isTest
    static void testProcessInboundProtocol() {
        String idCall = 'TEST-SERV-123';
        String phone = '11888887777';

        Test.startTest();
        Protocolo__c result = Protocolo55PBXService.processInboundProtocol(idCall, phone);
        Test.stopTest();

        System.assertNotEquals(null, result, 'O serviço não deveria retornar nulo');
        System.assertNotEquals(null, result.Id, 'O registro deveria ter sido persistido');
        System.assertEquals(idCall, result.CallSourceId__c);
        
        Protocolo__c stored = [SELECT ProtocolSource__c FROM Protocolo__c WHERE Id = :result.Id];
        System.assertEquals('Integração 55PBX', stored.ProtocolSource__c);
    }
    
    @isTest
    static void testUpsertLogic() {
        String idCall = 'DUPLICATE-TEST';
        
        Test.startTest();
        Protocolo55PBXService.processInboundProtocol(idCall, '11999999999');
        Protocolo55PBXService.processInboundProtocol(idCall, '11999999999'); // Segunda chamada
        Test.stopTest();
        
        Integer count = [SELECT Count() FROM Protocolo__c WHERE CallSourceId__c = :idCall];
        System.assertEquals(1, count, 'Deveria haver apenas 1 registro devido ao Upsert');
    }
}