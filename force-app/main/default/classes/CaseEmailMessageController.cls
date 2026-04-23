public with sharing class CaseEmailMessageController {

    @AuraEnabled(cacheable=true)
    public static List<EmailMessage> getEmails(Id caseId) {
        return [
            SELECT Id,
                   Subject,
                   FromAddress,
                   ToAddress,
                   CcAddress,
                   BccAddress,
                   TextBody,
                   HtmlBody,
                   Incoming,
                   MessageDate,
                   Status
            FROM EmailMessage
            WHERE ParentId = :caseId
            ORDER BY MessageDate DESC
        ];
    }
}