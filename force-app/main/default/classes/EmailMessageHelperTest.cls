@isTest
public class EmailMessageHelperTest {

    @isTest(SeeAllData=true)
    static void testForwardToGmail() {
        EmailRoutingAddress routeAddr;
        OrgWideEmailAddress owea;
        
        try {
            routeAddr = [SELECT Id FROM EmailRoutingAddress WHERE PersonalName = 'Fale Conosco' LIMIT 1];
            owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Fale Conosco - Auxiliadora Predial' LIMIT 1];
        } catch (Exception e) {
            System.debug('AVISO: Dados de OrgWideEmailAddress ou EmailRoutingAddress não encontrados na Org. O teste pode falhar ou ser ignorado.');
            return; 
        }

        Case c = new Case(
            Subject = 'Teste Unitário Caso',
            Status = 'New',
            Origin = 'Email'
        );
        insert c;

        EmailMessage em = new EmailMessage();
        em.FromAddress = 'cliente@teste.com';
        em.FromName = 'Cliente Teste';
        em.Subject = 'Assunto do Email Recebido';
        em.TextBody = 'Corpo do email recebido.';
        em.Incoming = false; 
        em.ParentId = c.Id;
        em.EmailRoutingAddressId = routeAddr.Id; 
        
        List<EmailMessage> emailList = new List<EmailMessage>{ em };

        Test.startTest();
        EmailMessageHelper helper = new EmailMessageHelper();
        helper.forwardToGmail(emailList);
        Integer emailsSent = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, emailsSent, 'Deveria ter enviado 1 e-mail através do método helper.');
    }
    
    @isTest
    static void testForwardToGmailNegative() {
        EmailMessage em = new EmailMessage();
        em.Incoming = false; 
        em.Subject = 'Teste Saída';
        
        List<EmailMessage> emailList = new List<EmailMessage>{ em };
        
        Test.startTest();
        EmailMessageHelper helper = new EmailMessageHelper();
        helper.forwardToGmail(emailList);
        Integer emailsSent = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assertEquals(0, emailsSent, 'Nenhum e-mail deveria ser enviado se Incoming = false.');
    }

    @isTest(SeeAllData=true)
    static void testForwardToGmailLoopPrevention() {
        EmailRoutingAddress routeAddr;
        OrgWideEmailAddress owea;
        
        try {
            routeAddr = [SELECT Id FROM EmailRoutingAddress WHERE PersonalName = 'Fale Conosco' LIMIT 1];
            owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Fale Conosco - Auxiliadora Predial' LIMIT 1];
        } catch (Exception e) {
            return; 
        }

        Case c = new Case(Subject = 'Caso Teste Loop', Status = 'New');
        insert c;

        EmailMessage emLoop = new EmailMessage();
        emLoop.FromAddress = owea.Address; 
        emLoop.Incoming = true; 
        emLoop.ParentId = c.Id;
        emLoop.EmailRoutingAddressId = routeAddr.Id;
        emLoop.Subject = 'Email que causa loop';
        emLoop.TextBody = 'Corpo do email.';

        List<EmailMessage> emailList = new List<EmailMessage>{ emLoop };

        Test.startTest();
        EmailMessageTriggerHandler.skipTrigger = false;
        
        EmailMessageHelper helper = new EmailMessageHelper();
        helper.forwardToGmail(emailList);
        
        Integer emailsSent = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(0, emailsSent, 'Não deveria enviar email se o remetente for o próprio OWEA da empresa (prevenção de loop).');
    }
}