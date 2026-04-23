@isTest
public class FlowSendEmailInvocableTest {

    @TestSetup
    static void setupData() {
        Case casoTeste = new Case(
            Subject = 'Caso Base para Testes',
            Status = 'New',
            Origin = 'WhatsApp'
        );
        insert casoTeste;
    }

    @isTest
    static void testSendEmailWithoutAttachment() {
        Case casoTeste = [SELECT Id FROM Case LIMIT 1];

        FlowSendEmailInvocable.EmailRequest request = new FlowSendEmailInvocable.EmailRequest();
        request.toAddresses = new List<String>{'cliente_sem_anexo@gmail.com'};
        request.subject = 'Teste Sem Anexo';
        request.htmlBody = '<p>Apenas texto.</p>';
        request.relatedRecordId = casoTeste.Id;
        request.contentDocumentIds = null; 

        List<FlowSendEmailInvocable.EmailRequest> listaRequests = new List<FlowSendEmailInvocable.EmailRequest>();
        listaRequests.add(request);

        Test.startTest();
        try {
            FlowSendEmailInvocable.sendEmail(listaRequests);
            
            Integer emailsEnviados = Limits.getEmailInvocations();
            System.assertEquals(1, emailsEnviados, 'Deveria enviar 1 email sem anexo.');
            
        } catch (System.EmailException e) {
            System.debug('Catch esperado (Ambiente sem OWEA): ' + e.getMessage());
        } catch (Exception e) {
            System.assert(false, 'Erro inesperado no fluxo sem anexo: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSendEmailWithAttachment() {
        Case casoTeste = [SELECT Id FROM Case LIMIT 1];

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Arquivo de Teste';
        cv.PathOnClient = 'Teste.pdf';
        cv.VersionData = Blob.valueOf('Conteúdo binário do arquivo');
        cv.IsMajorVersion = true;
        insert cv;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        FlowSendEmailInvocable.EmailRequest request = new FlowSendEmailInvocable.EmailRequest();
        request.toAddresses = new List<String>{'cliente_com_anexo@gmail.com'};
        request.subject = 'Teste Com Anexo';
        request.htmlBody = '<p>Texto com anexo.</p>';
        request.relatedRecordId = casoTeste.Id;
        
        request.contentDocumentIds = new List<String>{ contentDocumentId };

        List<FlowSendEmailInvocable.EmailRequest> listaRequests = new List<FlowSendEmailInvocable.EmailRequest>();
        listaRequests.add(request);

        Test.startTest();
        try {
            FlowSendEmailInvocable.sendEmail(listaRequests);

            Integer emailsEnviados = Limits.getEmailInvocations();
            System.assertEquals(1, emailsEnviados, 'Deveria enviar 1 email com anexo.');
        } catch (System.EmailException e) {
            System.debug('Catch esperado (Ambiente sem OWEA): ' + e.getMessage());
        } catch (Exception e) {
            System.assert(false, 'Erro na lógica de anexos: ' + e.getMessage());
        }
        Test.stopTest();

        EmailMessage emailSalvo = [
            SELECT Id, Subject 
            FROM EmailMessage 
            WHERE RelatedToId = :casoTeste.Id 
            AND Subject = 'Teste Com Anexo'
            LIMIT 1
        ];        
        System.assertNotEquals(null, emailSalvo, 'O registro de email deveria ter sido criado.');

        List<ContentDocumentLink> linksAnexo = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :emailSalvo.Id 
            AND ContentDocumentId = :contentDocumentId
        ];
        System.assertEquals(1, linksAnexo.size(), 'O arquivo deveria estar anexado ao registro de EmailMessage.');

    }
}