public without sharing class CardAccountInfoController {

    @AuraEnabled(cacheable=true)
    public static Account getAccountFromCase(Id caseId) {
        if (caseId == null) {
            return null;
        }
        
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('Você não tem permissão para acessar informações da conta.');
        } else if (!Schema.sObjectType.Case.isAccessible()) {
            throw new AuraHandledException('Você não tem permissão para acessar informações do caso.');
        } else {
            Case c = [
                SELECT Account.Id, Account.Name, Account.CA_TipoConta__c,
                    Account.CA_Whatsapp__c, Account.CA_Telefone__c, Account.CA_Telefonecomercial__c, Account.CA_Email__c,
                    Account.Owner.SmallPhotoUrl, Account.BillingAddress, Account.BillingCity
                FROM Case
                WHERE Id = :caseId
                LIMIT 1
            ];
            //System.debug('logLevel' + c.Account.BillingCity);
            return c.Account;
        }        
    }
}