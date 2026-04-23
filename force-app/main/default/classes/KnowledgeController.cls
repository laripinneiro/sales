public without sharing class KnowledgeController {
    
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getArticles() {
        // Busca artigos publicados, em português e visíveis no canal público
        return [
            SELECT Id, Title, Answer__c, UrlName 
            FROM Knowledge__kav
            WHERE PublishStatus = 'Online'
            AND IsVisibleInPkb = true
            ORDER BY Title ASC
            LIMIT 50
        ];
    }
}