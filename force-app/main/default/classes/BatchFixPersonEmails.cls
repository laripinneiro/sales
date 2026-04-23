public with sharing class BatchFixPersonEmails implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, CA_Email__c, PersonEmail, PersonContactId, IsPersonAccount FROM Account WHERE CA_Email__c != null]);
    }

    public void execute(Database.BatchableContext BC,  List<Account> scope){
        List<Account> accsToUpdate = new List<Account>();
        Set<Id> businessAccountIds = new Set<Id>();
        Map<Id, String> accountIdToEmail = new Map<Id, String>();

        for(Account acc : scope){
            if(acc.IsPersonAccount){
                acc.PersonEmail = acc.CA_Email__c;
                accsToUpdate.add(acc);
            } else {
                businessAccountIds.add(acc.Id);
                accountIdToEmail.put(acc.Id, acc.CA_Email__c);
            }
        }

        if(!accsToUpdate.isEmpty()){
            Database.update(accsToUpdate, false);
        }
        if(!accountIdToEmail.isEmpty()){
            updateRelatedContacts(businessAccountIds, accountIdToEmail);
        }
    }

    private void updateRelatedContacts(Set<Id> accountIdSet, Map<Id,String> emailMap){
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Contact> contactsRelatedToAcc =  [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN :accountIdSet];

        for(Contact con : contactsRelatedToAcc){
            String email = emailMap.get(con.AccountId);

            if(con.Email == null){
                con.Email = email;
                contactsToUpdate.add(con);
            }
        }

        if(!contactsToUpdate.isEmpty()){
            Database.update(contactsToUpdate, false);
        }
    }

    public void finish(Database.BatchableContext BC){
        System.debug('Processamento de sincronização de e-mails concluído');
    }
}