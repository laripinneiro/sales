global class BoletoItem {
    @InvocableVariable(label='Descrição do Boleto')
    @AuraEnabled
    global String descricao;
    
    @InvocableVariable(label='Data de Vencimento')
    @AuraEnabled
    global Date vencimento;
    
    @InvocableVariable(label='URL da Segunda Via')
    @AuraEnabled
    global String url;
    
    @InvocableVariable(label='Linha Digitável')
    @AuraEnabled
    global String linhaDigitavel;
}