public with sharing class FlowSendEmailInvocable {

    @InvocableMethod(
        label='Enviar Email (Dinâmico)'
        description='Envia email buscando o OrgWideEmailAddress pelo nome, sem ID fixo.'
    )
    public static void sendEmail(List<EmailRequest> requests) {

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        EmailRoutingAddress e2case = [SELECT Address, EmailServicesAddressId, PersonalName FROM EmailRoutingAddress WHERE PersonalName = 'Fale Conosco' LIMIT 1];
        System.debug('e2case:' + e2case);
        
        String maskedReplyTo = '';
        if(e2case != null){
            EmailServicesAddress emailRouting = [SELECT Id, LocalPart, EmailDomainName FROM EmailServicesAddress WHERE Id = :e2case.EmailServicesAddressId LIMIT 1];
            System.debug('emailRouting:' + emailRouting);

            if(emailRouting != null){
                String formatedSfEmailRouting = emailRouting.LocalPart + '@' + emailRouting.EmailDomainName;
                System.debug('formatedSfEmailRouting:' + formatedSfEmailRouting);

                maskedReplyTo = '"' + e2case.PersonalName + '" <' + formatedSfEmailRouting + '>';
            }
        }

        OrgWideEmailAddress owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Fale Conosco - Auxiliadora Predial' LIMIT 1];       
        System.debug('owea:' + owea);

        for (EmailRequest req : requests) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(req.toAddresses);
            email.setSubject(req.subject);
            email.setHtmlBody(req.htmlBody);
            email.setReplyTo(maskedReplyTo);
            email.setOrgWideEmailAddressId(owea.Id);

            /*if (String.isNotBlank(req.fromAddress) && mapEmailToId.containsKey(req.fromAddress)) {
                email.setOrgWideEmailAddressId(mapEmailToId.get(req.fromAddress));
            }
            */
            if (req.relatedRecordId != null) {
                email.setWhatId(req.relatedRecordId);
                email.setSaveAsActivity(true); 
            }
            
            System.debug('logreq.contentDocumentIds: ' + req.contentDocumentIds);
            if(req.contentDocumentIds != null && !req.contentDocumentIds.isEmpty()){
                List<ContentVersion> contentVersionList = [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN :req.contentDocumentIds AND IsLatest = true];

                List<Id> versionIds = new List<Id>();
                for (ContentVersion cv : contentVersionList){
                    versionIds.add(cv.Id);
                }
                if(!versionIds.isEmpty()){
                    email.setEntityAttachments(versionIds);
                    System.debug('logreq.contentDocumentIds: ' + req.contentDocumentIds);
                }                
            }

            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    public class EmailRequest {
        @InvocableVariable(required=true label='Lista de destinatários (e-mails)')
        public List<String> toAddresses;

        @InvocableVariable(required=true label='Assunto')
        public String subject;

        @InvocableVariable(required=true label='HTML do Email')
        public String htmlBody;

        @InvocableVariable(label='Registro relacionado (Case ID)')
        public Id relatedRecordId;

        @InvocableVariable(label='IDs dos Arquivos (ContentDocumentIds)')
        public List<String> contentDocumentIds;
    }
}