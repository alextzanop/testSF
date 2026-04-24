public with sharing class LibrarySearchController {
    class DataWrapper {
        @AuraEnabled
        public List<Book__c> books { get{return books;} set{books = value;} }
        
        @AuraEnabled
        public List<User> users { get{return users;} set{users = value;} }
        
        public DataWrapper(List<Book__c> books, List<User> users) {
            this.books = books;
            this.users = users;
        }
        
        
    }
    
    @AuraEnabled
    public static DataWrapper search(String searchTerm) {
        try {
            // String escapedSearchTerm = String.escapeSingleQuotes('*' + searchTerm + '*');
            
            System.debug('=== SEARCH START ===');
            System.debug('Raw Input: ' + searchTerm);
            
            String trimedSearchTerm = searchTerm != null ? searchTerm.trim() : '';
            System.debug(' Search Term: ' + trimedSearchTerm);
            
            Boolean isNumeric = isNumericValue(trimedSearchTerm);
            System.debug('Is Numeric: ' + isNumeric);
            
            String finalSearchTerm = trimedSearchTerm;
            if (isNumeric) {
                finalSearchTerm = trimedSearchTerm + '*';
                System.debug('Numeric Search - Final Term: ' + finalSearchTerm);
            } else {
                System.debug('Text Search - Final Term: ' + finalSearchTerm);
            }
            
            System.debug('Executing SOSL with: ' + finalSearchTerm);
            List<List<SObject>> results = [
                FIND :finalSearchTerm IN ALL FIELDS
                RETURNING Book__c(Id, Name, Total_Number_of_Copies__c, Availables_copies__c),
            User(Id, Name, Email, Gender__c)
                ];
            
            
            System.debug('SOSL Results Count: ' + results.size());
            System.debug('Books Count: ' + (results.size() > 0 ? results[0].size() : 0));
            System.debug('Users Count: ' + (results.size() > 1 ? results[1].size() : 0));
            
            List<Book__c> books = new List<Book__c>();
            List<User> users = new List<User>();
            
            if (results.size() > 0 && results[0] != null && results[0].size() > 0) {
                books = (List<Book__c>) results[0];
                System.debug(' Found ' + books.size() + ' books');
            } else {
                System.debug(' No books found');
            }
            
            if (results.size() > 1 && results[1] != null && results[1].size() > 0) {
                users = (List<User>) results[1];
                System.debug(' Found ' + users.size() + ' users');
            } else {
                System.debug(' No users found');
            }
            System.debug('Creating DataWrapper with ' + books.size() + ' books and ' + users.size() + ' users');
            
            DataWrapper wrapper = new DataWrapper(books, users);
            return wrapper;
        } catch (Exception e) {
            System.debug(' Error: ' + e.getMessage());
            System.debug(' Stack: ' + e.getStackTraceString());
            
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static Boolean isNumericValue(String value) {
        if (String.isBlank(value)) {
            return false;
        }
        try {
            Decimal.valueOf(value);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    // @AuraEnabled
    // public static List<Book__c> searchBooks(String searchTerm) {
        //     try {
            //         String escapedSearchTerm = String.escapeSingleQuotes('*' + searchTerm + '*');
            
            //         System.debug(' Search Term: ' + searchTerm);
            
            //         List<List<SObject>> results = [
            //             FIND :escapedSearchTerm IN ALL FIELDS
            //             RETURNING Book__c(Id, Name, Total_Number_of_Copies__c, Availables_copies__c),
            //             ];
            
            //         List<Book__c> books = (List<Book__c>) results[0];
            
            //         System.debug(' Found ' + books.size() + ' books');
            
            //         return books;
        //     } catch (Exception e) {
            //         System.debug(' Error: ' + e.getMessage());
            //         throw new AuraHandledException(e.getMessage());
        //     }
    // }
    
    // @AuraEnabled
    // public static List<User> searchUsers(String searchTerm) {
        //     try {
            //         String escapedSearchTerm = String.escapeSingleQuotes('*' + searchTerm + '*');
            
            //         System.debug(' Search Term: ' + searchTerm);
            
            //         List<List<SObject>> results = [
            //             FIND :escapedSearchTerm IN ALL FIELDS
            //             RETURNING User(Id, Name, Email, Gender__c)
            //             ];
            
            //         List<User> users = (List<User>) results[0];
            
            //         System.debug(' Found ' + users.size() + ' users');
            
            //         return users;
        //     } catch (Exception e) {
            //         System.debug(' Error: ' + e.getMessage());
            //         throw new AuraHandledException(e.getMessage());
        //     }
    // }
    
}