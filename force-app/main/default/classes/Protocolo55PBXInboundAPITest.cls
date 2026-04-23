@isTest
private class Protocolo55PBXInboundAPITest {

    @isTest
    static void testCreateProtocolSuccess() {
        Protocolo55PBXInboundAPI.ProtocoloRequest reqData = new Protocolo55PBXInboundAPI.ProtocoloRequest();
        reqData.idCall = 'API-TEST-001';
        reqData.phone = '1155554444';
        String jsonBody = JSON.serialize(reqData);

        RestRequest req = new RestRequest();
        req.requestURI = '/55pbx/protocolos/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        Protocolo55PBXInboundAPI.ProtocoloResponse res = Protocolo55PBXInboundAPI.createProtocol();
        Test.stopTest();

        System.assertEquals(true, res.sucess);
        System.assertNotEquals(null, res.protocolNumber);
        System.assertNotEquals(null, res.idSalesforce);
    }

    @isTest
    static void testCreateProtocolError() {
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{}'); 
        RestContext.request = req;

        Test.startTest();
        Protocolo55PBXInboundAPI.ProtocoloResponse res = Protocolo55PBXInboundAPI.createProtocol();
        Test.stopTest();

        System.assertEquals(false, res.sucess);
        System.assert(res.responseMessage != null); 
    }
}