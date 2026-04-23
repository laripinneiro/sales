public with sharing class FlowSendEmailInvocableRepository {
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getFileDetails(List<String> contentDocumentIds) {
        System.debug('entrou na getFileDetails: '  + contentDocumentIds);
        return [
            SELECT ContentDocumentId, ContentSize, Title, FileExtension 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocumentIds 
            AND IsLatest = true
        ];
    }
}