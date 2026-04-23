public with sharing class BoletosController {
    
    public class BoletoRequest {
        @InvocableVariable(label='CPF ou CNPJ' required=true)
        public String cpfCnpj;
    }
    
    public class BoletoResponse {
        @InvocableVariable(label='Sucesso')
        public Boolean success;
        
        @InvocableVariable(label='Mensagem')
        public String message;
        
        @InvocableVariable(label='Quantidade de Boletos')
        public Integer quantidade;
        
        @InvocableVariable(label='Boletos em Atraso - Aluguel')
        public Boolean aluguel;
        
        @InvocableVariable(label='Boletos em Atraso - Condomínio')
        public Boolean condominio;
        
        @InvocableVariable(label='Lista de Boletos')
        public List<BoletoItem> boletos;
        
        @InvocableVariable(label='Código de Erro')
        public String errorCode;
    }
    
    @InvocableMethod (
        label='Consultar Boletos Auxiliadora Predial'
        description='Consulta boletos na API da Auxiliadora Predial usando CPF ou CNPJ'
    )
    public static List<BoletoResponse> consultarBoletos(List<BoletoRequest> requests) {
        List<BoletoResponse> responses = new List<BoletoResponse>();
        
        for (BoletoRequest request : requests) {
            BoletoResponse response = BoletosService.consultarBoletosPorDocumento(request);
            System.debug(response);
            responses.add(response);
        }
        
        return responses;
    }
    
    public static BoletoResponse buildSuccessResponse(List<BoletoItem> boletos, Integer quantidade, Boolean aluguel, Boolean condominio, String message) {
        BoletoResponse response = new BoletoResponse();
        response.success = true;
        response.boletos = boletos;
        response.quantidade = quantidade;
        response.aluguel = aluguel;
        response.condominio = condominio;
        response.message = message;
        return response;
    }
    
    public static BoletoResponse buildErrorResponse(String errorCode, String message) {
        BoletoResponse response = new BoletoResponse();
        response.success = false;
        response.errorCode = errorCode;
        response.message = message;
        response.quantidade = 0;
        response.aluguel = false;
        response.condominio = false;
        response.boletos = new List<BoletoItem>();
        return response;
    }
    
    public static BoletoItem convertToBoletoItem(BoletosDTO.BoletoData boletoData) {
        System.debug('### RAW vencimento recebido da API: ' + boletoData.vencimento);
        Date venc = BoletosDTO.getVencimentoAsDate(boletoData.vencimento);
        System.debug('### Date convertido: ' + venc);

        BoletoItem item = new BoletoItem();
        item.descricao = boletoData.descricao;
        item.vencimento = BoletosDTO.getVencimentoAsDate(boletoData.vencimento);
        item.url = boletoData.url;
        item.linhaDigitavel = boletoData.LinhaDigitavel;
        return item;
    }
    
    public static List<BoletoItem> convertToBoletoItemList(List<BoletosDTO.BoletoData> boletoDataList) {
        List<BoletoItem> boletoItems = new List<BoletoItem>();
        if (boletoDataList != null) {
            for (BoletosDTO.BoletoData boletoData : boletoDataList) {
                boletoItems.add(convertToBoletoItem(boletoData));
            }
        }
        return boletoItems;
    }
}