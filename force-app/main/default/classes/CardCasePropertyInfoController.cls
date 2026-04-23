public without sharing class CardCasePropertyInfoController {

    @AuraEnabled(cacheable=true)
    public static Account getPropertyOwnerFromCase(Id caseId) {
        if (caseId == null){
            return null;
        }

        Case c = [
            SELECT CA_Imovel__r.CA_ProprietarioImovel__r.Id,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Name,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Type,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Phone,
                    CA_Imovel__r.CA_ProprietarioImovel__r.CA_Whatsapp__c,
                    CA_Imovel__r.CA_ProprietarioImovel__r.CA_Telefone__c,
                    CA_Imovel__r.CA_ProprietarioImovel__r.CA_Telefonecomercial__c,
                    CA_Imovel__r.CA_ProprietarioImovel__r.CA_Email__c,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Owner.Id,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Owner.Name,
                    CA_Imovel__r.CA_ProprietarioImovel__r.Owner.SmallPhotoUrl
            FROM Case
            WHERE Id = :caseId
            LIMIT 1
        ];

        return c.CA_Imovel__r.CA_ProprietarioImovel__r;
    }
}