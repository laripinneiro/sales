@isTest
public class MessagingSessionTimeoutSchedulerTest {
    
    @isTest
    static void testSchedulerExecution() {
        Test.startTest();
        
        String jobId = System.schedule(
            'Test Timeout Scheduler',
            '0 0 * * * ?',
            new MessagingSessionTimeoutScheduler()
        );
        
        Test.stopTest();
        
        // Verify the job was scheduled
        CronTrigger ct = [
            SELECT Id, CronExpression, State
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertEquals('0 0 * * * ?', ct.CronExpression, 'Cron expression should match');
    }
    
    @isTest
    static void testScheduleJobMethod() {
        Test.startTest();
        MessagingSessionTimeoutScheduler.scheduleJob();
        Test.stopTest();
        
        // Verify jobs were scheduled (should be 12 jobs for every 5 minutes)
        List<CronTrigger> jobs = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name LIKE 'MessagingSession Timeout Checker%'
        ];
        
        System.assertEquals(12, jobs.size(), 'Should have 12 scheduled jobs (every 5 minutes)');
    }
    
    @isTest
    static void testUnscheduleAllJobs() {
        // First schedule jobs
        Test.startTest();
        MessagingSessionTimeoutScheduler.scheduleJob();
        
        // Then unschedule them
        MessagingSessionTimeoutScheduler.unscheduleAllJobs();
        Test.stopTest();
        
        // Verify jobs were removed
        List<CronTrigger> jobs = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name LIKE 'MessagingSession Timeout Checker%'
        ];
        
        System.assertEquals(0, jobs.size(), 'All jobs should be unscheduled');
    }
}