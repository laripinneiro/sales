@RestResource(urlMapping='/55pbx/boletos/*')
global with sharing class Boletos55PBXAPI {
    
    @HttpGet
    global static void getInvoices() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        res.addHeader('Content-Type', 'application/json');
        
        try {
            String taxIdFromUrl = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            BoletosController.BoletoRequest request = new BoletosController.BoletoRequest();
            request.cpfCnpj = taxIdFromUrl;
            
            List<BoletosController.BoletoRequest> requestList = new List<BoletosController.BoletoRequest>();
            requestList.add(request);
            
            List<BoletosController.BoletoResponse> serviceResponses = BoletosController.consultarBoletos(requestList);            
            
            BoletosController.BoletoResponse itemResponse = (serviceResponses != null && !serviceResponses.isEmpty()) ? serviceResponses[0] : null;

            String jsonBody;        
            if (itemResponse != null && itemResponse.boletos != null && !itemResponse.boletos.isEmpty()) {                
                jsonBody = JSON.serialize(itemResponse);
                res.statusCode = 200; 
                
            } else {                
                BoletosController.BoletoResponse emptyError = BoletosController.buildErrorResponse('NOT_FOUND', 'Nenhum boleto encontrado para este documento.');
                jsonBody = JSON.serialize(emptyError);
                res.statusCode = 404; 
            }
            
            
            res.responseBody = Blob.valueOf(jsonBody);
            
        } catch (Exception e) {
            BoletosController.BoletoResponse exceptionError = BoletosController.buildErrorResponse('EXCEPTION', e.getMessage());
            res.responseBody = Blob.valueOf(JSON.serialize(exceptionError));
            res.statusCode = 500; 
        }
    }
}