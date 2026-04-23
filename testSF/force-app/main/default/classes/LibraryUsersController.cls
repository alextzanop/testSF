public with sharing class LibraryUsersController {
    
    @AuraEnabled
    public static List<User> getLibraryUsers(String libraryId) {
        try {
            return [SELECT Id, Name, Email,Gender__c FROM User WHERE Id IN (SELECT User__c FROM Library_User__c WHERE Library__c = :libraryId) ORDER BY Name];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}