public with sharing class CaseOwnerUpdateQueueable implements Queueable{
    private Map<Id, Id> caseIdToOwnerIdMap;

    public CaseOwnerUpdateQueueable(Map<Id, Id> caseIdToOwnerIdMap) {
        this.caseIdToOwnerIdMap = caseIdToOwnerIdMap;
    }

    public void execute(QueueableContext context) {
        List<Case> casesToUpdate = new List<Case>();
        for (Id caseId : caseIdToOwnerIdMap.keySet()) {
            Case c = new Case(
                Id = caseId,
                OwnerId = caseIdToOwnerIdMap.get(caseId)
            );
            casesToUpdate.add(c);
            System.debug('[CaseOwnerUpdateQueueable] c ' + c);
        }
        
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}