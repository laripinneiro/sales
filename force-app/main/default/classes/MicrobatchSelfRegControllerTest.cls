@IsTest
 public with sharing class MicrobatchSelfRegControllerTest {
      @IsTest(SeeAllData=true)
     public static void testMicrobatchSelfRegController() {
         User usuarioAdmin = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND Name LIKE '%Diorgenes%' LIMIT 1];
         
         System.runAs(usuarioAdmin){
         	MicrobatchSelfRegController controller = new MicrobatchSelfRegController();
         	controller.firstName = 'FirstName';
         	controller.lastName = 'LastName';
         	controller.email = 'test@force.com';
         	controller.communityNickname = 'test';

         	// registerUser will always return null when the page isn't accessed as a guest user
         	System.assert(controller.registerUser() == null);
         }
     }
 }