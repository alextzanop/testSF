public with sharing class LibrarySearchController {
    
    @AuraEnabled
    public static List<Book__c> searchBooks(String searchTerm) {
        try {
            String escapedSearchTerm = String.escapeSingleQuotes(searchTerm);
            
            System.debug(' Search Term: ' + searchTerm);
            
            List<List<SObject>> results = [
                FIND :escapedSearchTerm IN ALL FIELDS
                RETURNING Book__c(Id, Name, Total_Number_of_Copies__c, Availables_copies__c)
                ];
            
            List<Book__c> books = (List<Book__c>) results[0];
            
            System.debug(' Found ' + books.size() + ' books');
            
            return books;
        } catch (Exception e) {
            System.debug(' Error: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<User> searchUsers(String searchTerm) {
        try {
            String escapedSearchTerm = String.escapeSingleQuotes(searchTerm);
            
            System.debug(' Search Term: ' + searchTerm);
            
            List<List<SObject>> results = [
                FIND :escapedSearchTerm IN ALL FIELDS
                RETURNING User(Id, Name, Email, Gender__c)
                ];
            
            List<User> users = (List<User>) results[0];
            
            System.debug(' Found ' + users.size() + ' users');
            
            return users;
        } catch (Exception e) {
            System.debug(' Error: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}