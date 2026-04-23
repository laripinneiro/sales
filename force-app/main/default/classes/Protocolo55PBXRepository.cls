public with sharing class Protocolo55PBXRepository {
    public void save(Protocolo__c protocolo) {
        upsert protocolo CallSourceId__c;
    }

    public Protocolo__c findById(Id salesforceId){
        if(salesforceId != null){
            return [SELECT Id, IdProtocolo__c, ProtocolSource__c, CallSourceId__c, CallSourcePhone__c
                FROM Protocolo__c
                WHERE Id = :salesforceId
            ];
        } else {
            throw new CalloutException('Não retornou salesforceId');
        }      
    }
}