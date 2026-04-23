global class MessagingSessionTimeoutScheduler implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new MessagingSessionTimeoutBatch(), 100);
    }
    
    public static void scheduleJob() {
        // Limpar jobs existentes para evitar duplicidade
        unscheduleAllJobs();
        
        String jobName = 'MessagingSession Timeout Checker';
        
        // agendar para cada 5 minutos - como CRON não suporta diretamente,
        // usamos múltiplos schedules
        for (Integer i = 0; i < 60; i += 5) {
            String cronExp = '0 ' + i + ' * * * ?';
            String uniqueJobName = jobName + ' - ' + i;
            System.schedule(uniqueJobName, cronExp, new MessagingSessionTimeoutScheduler());
        }
    }
    
    public static void unscheduleAllJobs() {
        List<CronTrigger> jobs = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name LIKE 'MessagingSession Timeout Checker%'
        ];
        
        for (CronTrigger job : jobs) {
            System.abortJob(job.Id);
        }
    }
}