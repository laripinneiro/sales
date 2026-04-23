public with sharing class EmailMessageTriggerHandler {
    private static final EmailMessageHelper emailMessageHelper = new EmailMessageHelper();
    public static Boolean skipTrigger = false;
    
    public static void onAfterInsert(List<EmailMessage> newEmailMessageList) {
        emailMessageHelper.forwardToGmail(newEmailMessageList);
        //emailMessageHelper.createActivityForIncoming(newEmailMessageList);
    }
}