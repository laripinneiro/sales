public with sharing class MessagingSessionSelector {
    
    public List<MessagingSession> selectByIds_withCases(Set<Id> sessionIds){
        if(sessionIds.isEmpty()){
            return new List<MessagingSession>();
        }

        List<MessagingSession> sessionById = [
            SELECT Id, CaseId, EndUserAccountId, OwnerId 
            FROM MessagingSession 
            WHERE Id IN :sessionIds AND CaseId != null
        ];
        return sessionById;
    }
}