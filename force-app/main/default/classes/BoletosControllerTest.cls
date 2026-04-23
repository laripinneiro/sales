@isTest
public class BoletosControllerTest {
    
    @isTest
    static void testConsultarBoletos() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockSuccess());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '12345678901';
        
        Test.startTest();
        List<BoletosController.BoletoResponse> responses = BoletosController.consultarBoletos(new List<BoletosController.BoletoRequest>{request});
        Test.stopTest();
    }
    
    @isTest
    static void testConsultarBoletosEmptyDocument() {
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '';
        
        Test.startTest();
        List<BoletosController.BoletoResponse> responses = BoletosController.consultarBoletos(new List<BoletosController.BoletoRequest>{request});
        Test.stopTest();
    }
    
    @isTest
    static void testConvertToBoletoItem() {
        BoletosDTO.BoletoData boletoData = new BoletosDTO.BoletoData();
        boletoData.descricao = 'Teste';
        boletoData.vencimento = '01/01/2024';
        boletoData.url = 'http://test.com';
        boletoData.LinhaDigitavel = '123456789';
        
        BoletoItem item = BoletosController.convertToBoletoItem(boletoData);
        System.assertEquals(Date.newInstance(2024, 1, 1), item.vencimento);
    }
    
    @isTest
    static void testBuildSuccessResponse() {
        List<BoletoItem> boletos = new List<BoletoItem>();
        BoletosController.BoletoResponse response = BoletosController.buildSuccessResponse(boletos, 1, true, false, 'Sucesso');
    }
    
    @isTest
    static void testBuildErrorResponse() {
        BoletosController.BoletoResponse response = BoletosController.buildErrorResponse('ERROR_CODE', 'Erro');
    }
    
    @isTest
    static void testConvertToBoletoItemList() {
        List<BoletosDTO.BoletoData> boletoDataList = new List<BoletosDTO.BoletoData>();
        BoletosDTO.BoletoData boletoData = new BoletosDTO.BoletoData();
        boletoData.descricao = 'Teste';
        boletoDataList.add(boletoData);
        
        List<BoletoItem> items = BoletosController.convertToBoletoItemList(boletoDataList);
    }
    
    @isTest
    static void testConvertToBoletoItemListNull() {
        List<BoletoItem> items = BoletosController.convertToBoletoItemList(null);
    }
    
    @isTest
    static void testBoletosServiceDocumento() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockSuccess());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '123.456.789-01';
        
        Test.startTest();
        BoletosController.BoletoResponse response = BoletosService.consultarBoletosPorDocumento(request);
        Test.stopTest();
    }
    
    @isTest
    static void testBoletosApiObterToken() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockSuccess());
        
        Test.startTest();
        String token = BoletosApi.obterToken();
        Test.stopTest();
    }
    
    @isTest
    static void testBoletosApiConsultarBoletos() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockSuccess());
        
        Test.startTest();
        BoletosDTO.ApiResponse response = BoletosApi.consultarBoletos('12345678901');
        Test.stopTest();
    }
    
    @isTest
    static void testBoletosDTOParseMethods() {
        String authResponseJson = '{"access_token":"test_token","expires_in":3600,"token_type":"Bearer"}';
        BoletosDTO.AuthResponse authResponse = BoletosDTO.parseAuthResponse(authResponseJson);
        
        String apiResponseJson = '{"Cobranca":{"Aluguel":true,"Condominio":false},"Boletos":[]}';
        BoletosDTO.ApiResponse apiResponse = BoletosDTO.parseBoletosResponse(apiResponseJson);
        
        List<BoletosDTO.BoletoData> boletos = new List<BoletosDTO.BoletoData>();
        String serializedBoletos = BoletosDTO.serializeBoletos(boletos);
        
        Date testDate = BoletosDTO.getVencimentoAsDate('18/09/2025');
        System.assertEquals(Date.newInstance(2025, 9, 18), testDate);
        
        Date nullDate = BoletosDTO.getVencimentoAsDate('');
        System.assertEquals(null, nullDate);
    }
    
    @isTest
    static void testConsultarBoletosWithValidData() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockSuccessWithData());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '12345678901';
        
        Test.startTest();
        List<BoletosController.BoletoResponse> responses = BoletosController.consultarBoletos(new List<BoletosController.BoletoRequest>{request});
        Test.stopTest();
    }
    
    @isTest
    static void testBoletosServiceNullApi() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockError());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '12345678901';
        
        Test.startTest();
        BoletosController.BoletoResponse response = BoletosService.consultarBoletosPorDocumento(request);
        Test.stopTest();
    }
    
    @isTest
    static void testBoletosServiceEmptyBoletos() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockEmpty());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '12345678901';
        
        Test.startTest();
        BoletosController.BoletoResponse response = BoletosService.consultarBoletosPorDocumento(request);
        Test.stopTest();
    }
    //ba
    @isTest
    static void testBoletosServiceTokenNulo() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockTokenInvalid());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '98765432100';
        
        Test.startTest();
        BoletosDTO.ApiResponse response = BoletosApi.consultarBoletos(request.cpfCnpj);
        Test.stopTest();
        
        System.assertEquals(null, response, 'A resposta deve ser nula quando o token é inválido');
    }
    
    
    @isTest
    static void testBoletosServiceApiSemRetorno() {
        Test.setMock(HttpCalloutMock.class, new BoletosApiMockTokenOkBoletoFail());
        
        BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
        request.cpfCnpj = '12345678901';
        
        Test.startTest();
        BoletosController.BoletoResponse response = BoletosService.consultarBoletosPorDocumento(request);
        Test.stopTest();
        
        System.assertEquals(false, response.success, 'A resposta n tem erro');
        System.assertEquals('API_ERROR', response.errorCode, 'Deve retornar erro de API');
    }
    
    //ba    
    public class BoletosApiMockSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('TokenBoletosAPI')) {
                res.setStatusCode(200);
                res.setBody('{"access_token":"test_token","expires_in":3600,"token_type":"Bearer"}');
            } else {
                res.setStatusCode(200);
                res.setBody('{"Cobranca":{"Aluguel":true,"Condominio":false},"Boletos":[{"descricao":"Boleto 1","vencimento":"01/01/2024","url":"http://test1.com","LinhaDigitavel":"123"},{"descricao":"Boleto 2","vencimento":"01/02/2024","url":"http://test2.com","LinhaDigitavel":"456"}]}');
            }
            return res;
        }
    }
    
    public class BoletosApiMockError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error":"Internal Server Error"}');
            return res;
        }
    }
    
    public class BoletosApiMockEmpty implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('TokenBoletosAPI')) {
                res.setStatusCode(200);
                res.setBody('{"access_token":"test_token","expires_in":3600,"token_type":"Bearer"}');
            } else {
                res.setStatusCode(200);
                res.setBody('{"Cobranca":{"Aluguel":false,"Condominio":false},"Boletos":[]}');
            }
            return res;
        }
    }
    
    public class BoletosApiMockSuccessWithData implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('TokenBoletosAPI')) {
                res.setStatusCode(200);
                res.setBody('{"access_token":"test_token","expires_in":3600,"token_type":"Bearer"}');
            } else {
                res.setStatusCode(200);
                res.setBody('{"Cobranca":{"Aluguel":true,"Condominio":true},"Boletos":[{"descricao":"Boleto Aluguel","vencimento":"15/01/2024","url":"http://boleto1.com","LinhaDigitavel":"12345678901234567890123456789012345678901234"},{"descricao":"Boleto Condominio","vencimento":"15/02/2024","url":"http://boleto2.com","LinhaDigitavel":"98765432109876543210987654321098765432109876"}]}');
            }
            return res;
        }
    }     
    
    //ba
	public class BoletosApiMockTokenInvalid implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('TokenBoletos')) {
                res.setStatusCode(400);
                res.setBody('{"error":"invalid_request"}');
            } else {
                res.setStatusCode(401);
                res.setBody('{"error":"Unauthorized"}');
            }
            return res;
        }
    }
    
    public class BoletosApiMockTokenOkBoletoFail implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            // token OK
            if (req.getEndpoint().contains('TokenBoletos')) {
                res.setStatusCode(200);
                res.setBody('{"access_token":"tokenValido","expires_in":3600,"token_type":"Bearer"}');
            } else {
                // falha no endpoint de boletos
                res.setStatusCode(500);
                res.setBody('{"error":"Erro no servidor de boletos"}');
            }
            return res;
        }
    }   
}