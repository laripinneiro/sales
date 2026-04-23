@isTest
private class Boletos55PBXAPITest {
    
    private class BoletoHttpMock implements HttpCalloutMock {
        private Boolean returnSuccess;
        
        public BoletoHttpMock(Boolean success) {
            this.returnSuccess = success;
        }
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            if (req.getEndpoint().contains('TokenBoletos') || req.getBody().contains('client_id')) {
                res.setBody('{"access_token": "fake_token_123", "expires_in": 3600, "token_type": "Bearer"}');
                return res;
            }
            
            if (this.returnSuccess) {
                String jsonSucesso = '{' +
                    '"Cobranca": { "Aluguel": true, "Condominio": false }, ' +
                    '"Boletos": [' +
                        '{ "descricao": "Aluguel Jan", "vencimento": "20/01/2026", "url": "http://boleto", "LinhaDigitavel": "123456" }' +
                    ']' +
                '}';
                res.setBody(jsonSucesso);
            } else {
                String jsonVazio = '{ "Cobranca": { "Aluguel": false }, "Boletos": [] }';
                res.setBody(jsonVazio);
            }
            
            return res;
        }
    }

    @isTest 
    static void testGetInvoicesSuccess() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/telefonia/boletos/12345678900';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse(); 

        Test.setMock(HttpCalloutMock.class, new BoletoHttpMock(true));

        Test.startTest();
        Boletos55PBXAPI.getInvoices();
        Test.stopTest();

        RestResponse res = RestContext.response;
        
        System.assertEquals(200, res.statusCode, 'O status deveria ser 200 (OK)');
        System.assert(res.responseBody.toString().contains('Aluguel Jan'), 'O JSON de resposta deveria conter o boleto');
    }

    
    @isTest 
    static void testGetInvoicesEmpty() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/telefonia/boletos/00000000000'; // CPF sem dívida
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.setMock(HttpCalloutMock.class, new BoletoHttpMock(false));

        Test.startTest();
        Boletos55PBXAPI.getInvoices();
        Test.stopTest();

        RestResponse res = RestContext.response;
        
        System.assertEquals(404, res.statusCode, 'O status deveria ser 404 quando não há boletos');
        System.assert(res.responseBody.toString().contains('NOT_FOUND'), 'Deveria retornar a mensagem de erro padrão');
    }
    
    @isTest 
    static void testGetInvoicesException() {
        RestRequest req = new RestRequest();
        req.requestURI = null; // Isso vai gerar NullPointerException na linha do substring
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        //mock não será chamado, mas é boa prática ter
        Test.setMock(HttpCalloutMock.class, new BoletoHttpMock(true));

        Test.startTest();
        Boletos55PBXAPI.getInvoices();
        Test.stopTest();

        RestResponse res = RestContext.response;
        
        System.assertEquals(500, res.statusCode, 'Deveria retornar 500 em caso de Exception');
        System.assert(res.responseBody.toString().contains('EXCEPTION'), 'O corpo deve conter detalhes da exceção');
    }
}