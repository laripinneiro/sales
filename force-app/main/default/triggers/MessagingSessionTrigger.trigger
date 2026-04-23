trigger MessagingSessionTrigger on MessagingSession (before insert, before update, after update) {
    
    if (Trigger.isBefore){
        if (Trigger.isInsert){
            MessagingSessionTriggerHandler.handleBeforeInsertUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isUpdate){
            MessagingSessionTriggerHandler.handleBeforeInsertUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isUpdate){
            MessagingSessionTriggerHandler.handleOnAfterUpdate(Trigger.new,Trigger.oldMap);
        }        
    }
}