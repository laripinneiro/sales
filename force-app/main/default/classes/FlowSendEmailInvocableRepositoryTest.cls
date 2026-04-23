@IsTest
public with sharing class FlowSendEmailInvocableRepositoryTest {

    @IsTest
    static void testGetFileDetails_Success() {        
        ContentVersion cv1 = new ContentVersion(
            Title = 'Test Document 1',
            PathOnClient = 'TestDocument1.pdf',
            VersionData = Blob.valueOf('Test Content Data 1'),
            IsMajorVersion = true
        );
        
        ContentVersion cv2 = new ContentVersion(
            Title = 'Test Document 2',
            PathOnClient = 'TestDocument2.txt',
            VersionData = Blob.valueOf('Test Content Data 2'),
            IsMajorVersion = true
        );        
        insert new List<ContentVersion>{cv1, cv2};
        
        // precisa reconsultar porque o campo ContentDocumentId só é preenchido após o insert
        List<ContentVersion> insertedVersions = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id IN (:cv1.Id, :cv2.Id)
        ];
        
        List<String> docIdsToQuery = new List<String>();
        for(ContentVersion cv : insertedVersions) {
            docIdsToQuery.add(cv.ContentDocumentId);
        }

        Test.startTest();
        List<ContentVersion> results = FlowSendEmailInvocableRepository.getFileDetails(docIdsToQuery);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Deveria retornar 2 registros de ContentVersion.');
        
        Set<Id> returnedIds = new Set<Id>();
        for(ContentVersion cv : results) {
            returnedIds.add(cv.ContentDocumentId);
            System.assert(cv.Title.contains('Test Document'), 'O Título deve corresponder ao inserido.');
        }
        
        System.assert(returnedIds.contains(docIdsToQuery[0]), 'O primeiro documento deve estar na lista.');
        System.assert(returnedIds.contains(docIdsToQuery[1]), 'O segundo documento deve estar na lista.');
    }
   
    @IsTest
    static void testGetFileDetails_EmptyList() {
        Test.startTest();
        List<ContentVersion> results = FlowSendEmailInvocableRepository.getFileDetails(new List<String>());
        Test.stopTest();

        // 2. Verificações
        System.assertNotEquals(null, results, 'A lista retornada não deve ser nula.');
        System.assertEquals(0, results.size(), 'A lista deve estar vazia quando nenhum ID é passado.');
    }

}