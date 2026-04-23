public with sharing class BoletosService {
    
    public static BoletosController.BoletoResponse consultarBoletosPorDocumento(BoletosController.BoletoRequest request) {
        String documento = request.cpfCnpj != null ? request.cpfCnpj.trim().replaceAll('[^0-9]', '') : '';
        
        if (String.isBlank(documento)) {
            return BoletosController.buildErrorResponse('DOCUMENTO_OBRIGATORIO', 'CPF ou CNPJ é obrigatório');
        }
        
        BoletosDTO.ApiResponse apiResponse = BoletosApi.consultarBoletos(documento);
        System.debug(apiResponse);
        if (apiResponse == null) {
            return BoletosController.buildErrorResponse('API_ERROR', 'Erro na comunicação com a API de boletos');
        }
        
        if (apiResponse.Boletos == null || apiResponse.Boletos.isEmpty()) {
            return BoletosController.buildSuccessResponse(
                new List<BoletoItem>(), 
                0, 
                false, 
                false, 
                'Nenhum boleto encontrado para o documento informado'
            );
        }
        
        List<BoletoItem> boletosApex = BoletosController.convertToBoletoItemList(apiResponse.Boletos);
        Integer quantidade = apiResponse.Boletos.size();
        Boolean aluguel = apiResponse.Cobranca.Aluguel;
        Boolean condominio = apiResponse.Cobranca.Condominio;
        
        String message = 'Boletos encontrados com sucesso';
        if (aluguel || condominio) {
            message += ' - Cliente possui boletos em atraso';
        }
        
        return BoletosController.buildSuccessResponse(boletosApex, quantidade, aluguel, condominio, message);
    }
}