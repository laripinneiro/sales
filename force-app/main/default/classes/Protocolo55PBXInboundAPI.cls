@RestResource(urlMapping='/55pbx/protocolos/*') //convenção REST usar S no fim!!@
global with sharing class Protocolo55PBXInboundAPI {
    global class ProtocoloResponse{
        public String protocolNumber;
        public String idSalesforce;
        public Boolean sucess;
        public String responseMessage;
    }
    global class ProtocoloRequest{
        public String idCall;
        public String phone;
    }

    @HttpPost //aqui usa o verbo corretoo
    global static ProtocoloResponse createProtocol(){
        RestRequest req = RestContext.request;
        ProtocoloResponse res = new ProtocoloResponse();

        try{
            String jsonBody = req.requestBody.toString();
            ProtocoloRequest reqData = (ProtocoloRequest) JSON.deserialize(jsonBody, ProtocoloRequest.class);

            if (reqData == null){
                throw new CalloutException('Body vazio. Precisa enviar o idCall e phone');
            }
            
            Protocolo__c createdProtocol = Protocolo55PBXService.processInboundProtocol(reqData.idCall, reqData.phone);
            
            res.protocolNumber = createdProtocol.IdProtocolo__c;
            res.idSalesforce = createdProtocol.Id;
            res.sucess = true;

        }catch (Exception e){
            res.sucess = false;
            res.responseMessage = e.getMessage();
        }
        return res;
    }
}