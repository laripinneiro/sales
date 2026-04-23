@isTest
private class CaseEmailMessageControllerTest {

    /**
     * Configuração inicial dos dados para o teste.
     * Cria um Caso e alguns EmailMessages vinculados a ele.
     */
    @TestSetup
    static void setup() {
        Case testCase = new Case(
            Subject = 'Caso de Teste para Emails',
            Status = 'New',
            Origin = 'Web'
        );
        insert testCase;

        List<EmailMessage> emailsToInsert = new List<EmailMessage>();
        
        emailsToInsert.add(new EmailMessage(
            ParentId = testCase.Id,
            Subject = 'Email Antigo',
            FromAddress = 'cliente@exemplo.com',
            ToAddress = 'suporte@empresa.com',
            TextBody = 'Este é um email antigo.',
            Incoming = true,
            MessageDate = System.now().addDays(-2),
            Status = '0' // 0 = New
        ));

        emailsToInsert.add(new EmailMessage(
            ParentId = testCase.Id,
            Subject = 'Email Recente',
            FromAddress = 'suporte@empresa.com',
            ToAddress = 'cliente@exemplo.com',
            TextBody = 'Esta é uma resposta recente.',
            Incoming = false,
            MessageDate = System.now(), // Agora
            Status = '3' // 3 = Sent
        ));

        insert emailsToInsert;
    }

    /**
     * Cenário Positivo: Verifica se os emails são retornados corretamente
     * e se a ordenação (DESC) está funcionando.
     */
    @isTest
    static void testGetEmailsSuccess() {
        Case c = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();
        List<EmailMessage> results = CaseEmailMessageController.getEmails(c.Id);
        Test.stopTest();

        System.assertNotEquals(null, results, 'A lista não deve ser nula');
        System.assertEquals(2, results.size(), 'Deveria retornar 2 emails');
        
        System.assertNotEquals(null, results[0].FromAddress, 'O campo FromAddress deve vir preenchido');
        System.assertNotEquals(null, results[0].Subject, 'O campo Subject deve vir preenchido');
       
        System.assertEquals('Email Recente', results[0].Subject, 'O primeiro email deve ser o mais recente');
    }

    /**
     * Cenário Negativo/Vazio: Verifica o comportamento quando o Caso não tem emails.
     */
    @isTest
    static void testGetEmailsEmpty() {
        Case emptyCase = new Case(Subject = 'Caso Vazio');
        insert emptyCase;

        Test.startTest();
        List<EmailMessage> results = CaseEmailMessageController.getEmails(emptyCase.Id);
        Test.stopTest();

        System.assertNotEquals(null, results, 'A lista não deve ser nula');
        System.assertEquals(0, results.size(), 'A lista deve estar vazia');
    }
}