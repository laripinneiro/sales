@isTest
public with sharing class EmailMessageTriggerHandlerTest {

    @isTest(SeeAllData=true)
    static void testAfterInsertTrigger() {
        /*EmailRoutingAddress routeAddr;
        try {
            routeAddr = [SELECT Id FROM EmailRoutingAddress WHERE PersonalName = 'Fale Conosco' LIMIT 1];
        } catch (Exception e) {
            System.debug('AVISO: EmailRoutingAddress necessário não encontrado.');
            return;
        }*/

        Case c = new Case(
            Subject = 'Teste Trigger Caso',
            Origin = 'Email'
        );
        insert c;

        EmailMessage em = new EmailMessage();
        em.FromAddress = 'trigger@teste.com';
        em.FromName = 'Trigger Teste';
        em.Subject = 'Teste Trigger';
        em.TextBody = 'Teste via insert DML.';
        em.Incoming = false;
        em.ParentId = c.Id;
        //em.EmailRoutingAddressId = routeAddr.Id;

        Test.startTest();
        insert em;
        Integer emailsSent = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(1, emailsSent, 'A trigger deveria ter disparado o envio de e-mail ao inserir um EmailMessage válido.');
    }
}