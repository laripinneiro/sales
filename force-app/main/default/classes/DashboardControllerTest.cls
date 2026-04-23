@isTest

private class DashboardControllerTest {

    /**
     * TESTE 1: getDashboardNumbers
     * Cobre a lógica de Datas (Today/Month/Week) e contagem de registros.
     * Usa SeeAllData=true para tentar pegar o Canal de Mensagem se existir.
     */

    @isTest(SeeAllData=true)
    static void testGetDashboardNumbers() {               

        Case cToday = new Case(
            Subject = 'Case Hoje',
            Status = 'New',
            OwnerId = UserInfo.getUserId(),
            Origin = 'Phone'
        );

        insert cToday;

        Case cClosed = new Case(
            Subject = 'Case Fechado',
            Status = 'Closed',
            OwnerId = UserInfo.getUserId(),
            Origin = 'Web'
            // Nota: Campos TME_Casos__c geralmente são calculados, mas se for gravável:
            // TME_Casos__c = 10 

        );

        insert cClosed;

        Task t = new Task(
            Subject = 'Tarefa Teste',
            Status = 'Completed',
            OwnerId = UserInfo.getUserId(),
            Priority = 'Normal'
        );

        insert t;
        try {

            MessagingChannel channel = [SELECT Id FROM MessagingChannel LIMIT 1];
            if (channel != null) {

                // Mock do usuário e sessão
                MessagingEndUser msgUser = new MessagingEndUser(
                    Name = 'User Msg Test',
                    MessagingPlatformKey = 'whatsapp:+5511999990000',
                    MessageType = 'WhatsApp',
                    MessagingChannelId = channel.Id

                );

                insert msgUser;

                MessagingSession session = new MessagingSession(
                    MessagingEndUserId = msgUser.Id,
                    Status = 'Ended',
                    ConversationId = '0dw88000009DsVFAA0' //hardcoded porque esse campo é obrigatorio para criar a session
                );
                insert session;            
            }
        } catch (Exception e) {
            System.debug('Pular criação de MessagingSession: ' + e.getMessage());
        }
        Test.startTest();
        
        Map<String, Object> resultToday = DashboardController.getDashboardNumbers('today');
        System.assertNotEquals(null, resultToday);
        System.assert(resultToday.containsKey('casesAbertos'));       

        // Cenário B: Range = 'month'
        Map<String, Object> resultMonth = DashboardController.getDashboardNumbers('month');
        System.assertNotEquals(null, resultMonth);
        
        // Cenário C: Range = default (week)
        Map<String, Object> resultDefault = DashboardController.getDashboardNumbers('week');
        System.assertNotEquals(null, resultDefault);

        Test.stopTest();
    }
    /**
     * TESTE 2: getUserStatus
     * Tenta simular o Omni-Channel status.
     */

    @isTest(SeeAllData=true)
    static void testGetUserStatus() {
        List<ServicePresenceStatus> statuses = [SELECT Id, MasterLabel FROM ServicePresenceStatus LIMIT 1];     

        if (!statuses.isEmpty()) {
            try {
                UserServicePresence usp = new UserServicePresence(
                    UserId = UserInfo.getUserId(),
                    ServicePresenceStatusId = statuses[0].Id
                );

                insert usp;
            } catch (Exception e) {
                System.debug('Não foi possível inserir UserServicePresence (comum se o user não tiver permissão de Omni): ' + e.getMessage());
            }
        }
        Test.startTest();
        Map<String, String> statusMap = DashboardController.getUserStatus();
        Test.stopTest();

        System.assert(statusMap.containsKey('photoUrl'), 'Deve retornar a URL da foto');
        System.assert(statusMap.containsKey('status'), 'Deve retornar o status');

    }
    /**
     * TESTE 3: Relatórios (ReportIds e ReportData)
     * Este é tricky: Depende de relatórios reais existirem na Org.
     */

    @isTest(SeeAllData=true)
    static void testReportMethods() {
        Test.startTest();       

        Map<String, String> reportIds = DashboardController.getReportIds();
        System.assertNotEquals(null, reportIds);      

        String testReportId;
        if (!reportIds.isEmpty()) {
            testReportId = reportIds.values()[0];
        } else {
            testReportId = '00O000000000000FAKE'; // ID Falso
        }

        List<Map<String, Object>> reportData = DashboardController.getReportData(testReportId);       

        System.assertNotEquals(null, reportData, 'A lista de retorno não deve ser nula, mesmo vazia');

        List<Map<String, Object>> emptyData = DashboardController.getReportData(null);
        System.assertEquals(0, emptyData.size());
        Test.stopTest();
    }
}