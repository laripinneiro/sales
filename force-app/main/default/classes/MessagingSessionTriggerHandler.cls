public class MessagingSessionTriggerHandler {
    
    public static void handleBeforeInsertUpdate(List<MessagingSession> newSessions, Map<Id, MessagingSession> oldMap) {
        try {
            for (MessagingSession session : newSessions) {
                if (oldMap == null || !oldMap.containsKey(session.Id)) {
                    MessagingSessionService.initializeTimeoutFields(session);
                } else {
                    MessagingSession oldSession = oldMap.get(session.Id);
                    
                    if (session.UltimaAtividadeCliente__c == null) {
                        MessagingSessionService.resetTimeoutTracking(session);
                    } 
                    else if (MessagingSessionService.hasCustomerActivity(session, oldSession)) {
                        MessagingSessionService.resetTimeoutTracking(session);
                    }                    
                }
            }           
        } catch (Exception e){
            throw e;
        }
    }    
    
    public static void handleOnAfterUpdate(List<MessagingSession> newSessions, Map<Id, MessagingSession> oldMap){
        Map<Id, Id> casesToSync = new Map<Id, Id>();

        try{
           for (MessagingSession session : newSessions) {
                MessagingSession oldSession = oldMap.get(session.Id);               

                MessagingSessionService.handleCaseOwnerSync(session, oldSession, casesToSync);     
            }
            if(!casesToSync.isEmpty()){
                System.enqueueJob(new CaseOwnerUpdateQueueable(casesToSync));            
            }
        } catch(Exception e){
            throw e;
        }
    }
}