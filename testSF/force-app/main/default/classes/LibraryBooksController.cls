public with sharing class LibraryBooksController {
    
    
    @AuraEnabled
    public static List<Book__c> getBooksForLibrary(String libraryId) {
        try {
            return [SELECT Id, Name, Total_Number_of_Copies__c, Availables_copies__c FROM Book__c WHERE Library__c = :libraryId ORDER BY Name];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}