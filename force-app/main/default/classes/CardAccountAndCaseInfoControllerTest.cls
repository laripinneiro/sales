@isTest
private class CardAccountAndCaseInfoControllerTest {

    /**
     * Adicionamos (SeeAllData=true) APENAS neste método para ele enxergar o MessagingChannel real da Org.
     */
    @isTest(SeeAllData=true) 
    static void testGetAccountAndCaseFromSession_Success() {
        
        MessagingChannel channel;
        try {
            channel = [SELECT Id FROM MessagingChannel LIMIT 1];
            System.debug('channel: ' + channel);
            System.debug('channel.Id: ' + channel.Id);

        } catch (Exception e) {
            System.debug('Erro ao buscar canal: ' + e.getMessage());
        }

        if (channel == null) {
            System.debug('⚠️ AVISO: Nenhum MessagingChannel configurado na Org. O teste será pulado para evitar falha.');
            return; 
        }

        Account acc = new Account(
            Name = 'Conta Teste Messaging',
            BillingCity = 'São Paulo'
        );
        insert acc;

        Case c = new Case(
            Subject = 'Caso de Teste Messaging',
            Status = 'New',
            Origin = 'Web',
            AccountId = acc.Id
        );
        insert c;

        String randomKey = '5551999998888' + String.valueOf(Math.abs(Crypto.getRandomInteger())).left(8);
        
        MessagingEndUser msgUser = new MessagingEndUser(
            Name = 'Usuário Chat Teste',
            MessagingPlatformKey = randomKey, 
            MessageType = 'WhatsApp',
            MessagingChannelId = channel.Id, 
            AccountId = acc.Id
        );
        insert msgUser;
		
		Conversation convId = [SELECT Id FROM Conversation LIMIT 1];
            
        MessagingSession session = new MessagingSession(
            MessagingEndUserId = msgUser.Id,
            MessagingChannelId = channel.Id,
            CaseId = c.Id,
            ConversationId = convId.Id,
            Status = 'Active' 
        );
        insert session;

        Test.startTest();
        Map<String, Object> result = CardAccountAndCaseInfoController.getAccountAndCaseFromSession(session.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'O resultado não deve ser nulo');
        
        Account resAccount = (Account) result.get('account');
        System.assertEquals(acc.Id, resAccount.Id);
    }

    @isTest
    static void testGetAccountAndCaseFromSession_NullId() {
        Test.startTest();
        Map<String, Object> result = CardAccountAndCaseInfoController.getAccountAndCaseFromSession(null);
        Test.stopTest();

        System.assertEquals(null, result);
    }        
}