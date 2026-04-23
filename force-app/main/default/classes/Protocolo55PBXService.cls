public with sharing class Protocolo55PBXService {

    public static Protocolo__c processInboundProtocol(String idCall, String phone){
        Protocolo55PBXRepository repository = new Protocolo55PBXRepository();

        try{
            Protocolo__c newProtocol = new Protocolo__c();
            newProtocol.CallSourceId__c = idCall;
            newProtocol.CallSourcePhone__c = phone;
            newProtocol.ProtocolSource__c = 'Integração 55PBX';

            repository.save(newProtocol);

            Protocolo__c returnProtocol = repository.findById(newProtocol.Id);
            return returnProtocol;
        }catch(Exception e){
            throw new CalloutException(e.getMessage());
        }        
    }
}