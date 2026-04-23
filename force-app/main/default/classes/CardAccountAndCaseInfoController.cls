public with sharing class CardAccountAndCaseInfoController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAccountAndCaseFromSession(Id sessionId) {
        if (sessionId == null) {
            return null;
        }
        
        if (!Schema.sObjectType.MessagingSession.isAccessible()) {
            throw new AuraHandledException('Você não tem permissão para acessar informações da sessão de mensagens.');
        } else if (!Schema.sObjectType.Case.isAccessible()) {
            throw new AuraHandledException('Você não tem permissão para acessar informações do caso.');
        } else {
        MessagingSession mSession = [
                SELECT
                    EndUserAccount.Id,
                    EndUserAccount.Name,
                    EndUserAccount.CA_TipoConta__c,
                    EndUserAccount.CA_Whatsapp__c,                    
                    EndUserAccount.CA_Telefone__c,
                    EndUserAccount.CA_Telefonecomercial__c,
                    EndUserAccount.CA_Email__c,
                    EndUserAccount.Owner.SmallPhotoUrl,
                    EndUserAccount.BillingAddress,
                    EndUserAccount.BillingCity,

                    Case.Id,
                    Case.CaseNumber,
                    Case.Subject,
                    Case.Status,
                    Case.Priority,
                    Case.Type,
                    Case.Origin,
                    Case.Numero_de_Protocolo__c,
                    Case.RecordTypeId

                FROM MessagingSession
                WHERE Id = :sessionId
                LIMIT 1
            ];

            //System.debug('Billingciy: ' + mSession.EndUserAccount.BillingCity);
            Map<String, Object> result = new Map<String, Object>();
            result.put('account', mSession.EndUserAccount);
            result.put('caseData', mSession.Case);

            return result;
        }        
    }

    @AuraEnabled
    public static void updateCaseRecord(Case caseToUpdate) {
        try {
            if (!Schema.sObjectType.Case.isUpdateable()) {
                throw new AuraHandledException('Você não tem permissão para atualizar Casos.');
            }
            
            update caseToUpdate;
            System.debug('caso atualizado: ' + caseToUpdate);
            
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao atualizar: ' + e.getMessage());
        }
    }
}