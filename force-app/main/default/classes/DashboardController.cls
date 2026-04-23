public with sharing class DashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardNumbers(String range) {

        Id userId = UserInfo.getUserId();
        Date startDate;

        if (range == 'today') {
            startDate = Date.today();
        } 
        else if (range == 'month') {
            startDate = Date.today().toStartOfMonth();
        }
        else {
            startDate = Date.today().addDays(-7); 
        }

        Map<String, Object> r = new Map<String, Object>();

        r.put('casesAbertos', [
            SELECT COUNT() FROM Case 
            WHERE OwnerId = :userId AND isClosed = false AND CreatedDate >= :startDate
        ]);

         Integer casosCriados = [
        SELECT COUNT() FROM Case 
        WHERE OwnerId = :userId
        AND CreatedDate >= :startDate
        ];
        r.put('casesCriados', casosCriados);

      /*  Integer casesAtraso = [
            SELECT COUNT() FROM Case 
            WHERE OwnerId = :userId AND isClosed = false 
        ];
        r.put('casesAtraso', casesAtraso); */

        Integer casesAtraso = [
             SELECT COUNT() FROM Case WHERE OwnerId = :userId AND isClosed = false  AND Id IN 
             (SELECT CaseId FROM CaseMilestone WHERE IsViolated = true)];
        r.put('casesAtraso', casesAtraso);

     /*   Integer closedViolations = 0;
        for (Case c : [SELECT SlaExitDate, ClosedDate FROM Case WHERE OwnerId = :userId  AND isClosed = true AND ClosedDate >= :startDate]) {
            if (c.SlaExitDate != null && c.ClosedDate > c.SlaExitDate) {
                closedViolations++; 
            }
        }
        r.put('slaViolado', casesAtraso + closedViolations);
    */
    // Conta casos fechados no período que possuem pelo menos uma violação de marco
        Integer closedViolations = [
            SELECT COUNT() 
            FROM Case 
            WHERE OwnerId = :userId 
            AND Id IN (SELECT CaseId FROM CaseMilestone WHERE IsViolated = true)
        ];

    r.put('slaViolado', casesAtraso + closedViolations);

        r.put('mensagensAbertas', [
            SELECT COUNT() FROM MessagingSession
            WHERE OwnerId = :userId AND EndTime = null AND StartTime >= :startDate
        ]);

        r.put('tarefasFechadas', [
            SELECT COUNT() FROM Task 
            WHERE OwnerId = :userId AND isClosed = true AND CreatedDate >= :startDate
        ]);

        r.put('casosFechados', [
            SELECT COUNT() FROM Case 
            WHERE OwnerId = :userId AND isClosed = true AND ClosedDate >= :startDate
        ]);

        r.put('sessoesEncerradas', [
            SELECT COUNT() FROM MessagingSession 
            WHERE OwnerId = :userId AND EndTime >= :startDate
        ]);

        
        AggregateResult caseAvg = [
            SELECT AVG(TME_Casos__c) avg FROM Case
            WHERE OwnerId = :userId AND isClosed = true AND ClosedDate >= :startDate
        ];
        r.put('tmaCasos', (Decimal) caseAvg.get('avg'));

        
        AggregateResult msgAvg = [
            SELECT AVG(TME_Mensagens__c) avg FROM MessagingSession
            WHERE OwnerId = :userId AND EndTime >= :startDate
        ];
        r.put('tmaMensagens', (Decimal) msgAvg.get('avg'));

        r.put('tmeAtendimento', 3.2); 

        return r;
    }

   @AuraEnabled
   public static Map<String, String> getUserStatus() {

    Map<String, String> r = new Map<String, String>();

    // Foto do usuário
    User u = [
        SELECT SmallPhotoUrl
        FROM User
        WHERE Id = :UserInfo.getUserId()
        LIMIT 1
    ];
    r.put('photoUrl', u.SmallPhotoUrl);

    // Status atual do Omni-Channel
    List<UserServicePresence> presences = [
        SELECT ServicePresenceStatus.MasterLabel, StatusStartDate
        FROM UserServicePresence
        WHERE UserId = :UserInfo.getUserId()
        AND IsCurrentState = true
        LIMIT 1
    ];

    if (!presences.isEmpty()) {
        UserServicePresence usp = presences[0];

        r.put('status', usp.ServicePresenceStatus.MasterLabel);
        r.put(
            'since',
            usp.StatusStartDate != null
                ? usp.StatusStartDate.format('dd/MM/yyyy')
                : null
        );
    } else {
        r.put('status', 'Offline');
        r.put('since', null);
    }

    return r;
}

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getReportIds() {
        Map<String, String> reportMap = new Map<String, String>();
        Set<String> reportNames = new Set<String>{
            'TiposDeClienteHoje', 
            'TiposDeClienteEssaSemana', 
            'TiposDeClienteEsseMes',
            'TiposDeAtendimentoHoje', 
            'TiposDeAtendimentoEssaSemana', 
            'TiposDeAtendimentoEsseMes'
        };

        for (Report r : [SELECT Id, DeveloperName FROM Report WHERE DeveloperName IN :reportNames]) {
            reportMap.put(r.DeveloperName, r.Id);
        }
        return reportMap;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getReportData(String reportId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        if (String.isBlank(reportId)) return result;

        try {
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
            Reports.Dimension dim = results.getGroupingsDown();
            
            if (dim != null) {
                List<Reports.GroupingValue> groupings = dim.getGroupings();
                Map<String, Reports.ReportFact> factMap = results.getFactMap();
                
                for (Reports.GroupingValue g : groupings) {
                    String key = g.getKey() + '!T';
                    Reports.ReportFact fact = factMap.get(key);
                    if (fact != null) {
                        List<Reports.SummaryValue> aggregates = fact.getAggregates();
                        if (!aggregates.isEmpty()) {
                            Object val = aggregates[0].getValue();
                            Double numVal = 0;
                            if (val instanceof Decimal) {
                                numVal = ((Decimal)val).doubleValue();
                            } else if (val instanceof Integer) {
                                numVal = (Double)((Integer)val);
                            } else if (val instanceof Double) {
                                numVal = (Double)val;
                            }

                            result.add(new Map<String, Object>{
                                'label' => g.getLabel(),
                                'value' => numVal
                            });
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Error running report: ' + e.getMessage());
        }
        return result;
    }
}