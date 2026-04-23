public with sharing class LibraryController {
    
    @AuraEnabled(cacheable=true)
    public static List<Library__c> getLibraries(){
        try {
            return [SELECT Id, Name FROM Library__c ORDER BY Name];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}