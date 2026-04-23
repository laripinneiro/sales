public with sharing class EmailMessageHelper {

    public void forwardToGmail(List<EmailMessage> outcomingEmails) {
        if (EmailMessageTriggerHandler.skipTrigger){
            return;
        } else if(outcomingEmails.isEmpty()){
            return;
        }

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        EmailRoutingAddress gmailToReply = [SELECT Address FROM EmailRoutingAddress WHERE PersonalName = 'Fale Conosco' LIMIT 1];
        System.debug('gmailToReply:' + gmailToReply);
        OrgWideEmailAddress owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Fale Conosco - Auxiliadora Predial' LIMIT 1];       
        System.debug('owea:' + owea);
        System.debug('em.FromAddress: ' + outcomingEmails[0].FromAddress);

        for (EmailMessage em : outcomingEmails) {
            if (em.Incoming == false && 
            (em.Subject == null || !em.Subject.contains('[Encaminhado do Salesforce]')) &&            
            em.FromAddress != owea.Address &&
            em.ParentId != null && 
            String.valueOf(em.ParentId).startsWith('500')) {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(new List<String>{gmailToReply.Address});                
                mail.setSubject('[Encaminhado do Salesforce] ' + em.Subject);
                
                String body = 'Uma nova resposta chegou no Caso.\n\n';
                body += 'De: ' + em.FromAddress + '\n';
                body += 'Nome: ' + em.FromName + '\n\n';
                body += '--- Mensagem ---\n';
                body += em.TextBody;

                mail.setOrgWideEmailAddressId(owea.Id);
                mail.setPlainTextBody(body);                
                //mail.setReplyTo(em.FromAddress);

                emailsToSend.add(mail);
            }
        }

        if (!emailsToSend.isEmpty()) {
            EmailMessageTriggerHandler.skipTrigger = true;
            Messaging.sendEmail(emailsToSend, false);
            System.debug('EmailMessageHelper: End');
        }
    }

    public void createActivityForIncoming(List<EmailMessage> emails) {
        List<Task> tasksToInsert = new List<Task>();
        List<EmailMessage> emailsToUpdate = new List<EmailMessage>(); 

        for (EmailMessage em : emails) {
            if (em.Incoming == true /*&& em.ParentId != null && String.valueOf(em.ParentId).startsWith('500')*/) { // COMENTADO: criar atividade para e-mails de entrada que tenham um Caso pai
                
                Task newTask = new Task();
                newTask.Subject = 'E-mail Recebido: ' + em.Subject;
                newTask.Description = em.TextBody; 
                newTask.Status = 'Completed'; 
                newTask.Priority = 'Normal';
                newTask.TaskSubtype = 'Email';
                newTask.ActivityDate = Date.today();
                
                newTask.WhatId = em.ParentId;
                
                // associa contato:
                // newTask.WhoId = blablbla; 

                tasksToInsert.add(newTask);
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;                      
        }
    }
}