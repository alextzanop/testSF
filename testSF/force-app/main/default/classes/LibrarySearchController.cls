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
            String trimedSearchTerm = searchTerm != null ? searchTerm.trim() : '';
            System.debug('Search Term: ' + trimedSearchTerm);
            
            if (String.isBlank(trimedSearchTerm)) {
                return new DataWrapper(new List<Book__c>(), new List<User>());
            }
            
            Boolean isNumeric = isNumericValue(trimedSearchTerm);
            System.debug('Is Numeric: ' + isNumeric);
            
            List<Book__c> books = new List<Book__c>();
            List<User> users = new List<User>();
            
            if (isNumeric) {
                System.debug('Numeric search');
                
                Decimal numericValue = Decimal.valueOf(trimedSearchTerm);
                
                books = [
                    SELECT Id, Name, Total_Number_of_Copies__c, Availables_copies__c
                    FROM Book__c
                    WHERE Total_Number_of_Copies__c = :numericValue
                       OR Availables_copies__c = :numericValue
                    LIMIT 100
                ];
                
                System.debug('Books found (numeric): ' + books.size());
                
            } else {
                System.debug('Text search');
                
                String searchPattern = '%' + trimedSearchTerm + '%';
                
                books = [
                    SELECT Id, Name, Total_Number_of_Copies__c, Availables_copies__c
                    FROM Book__c
                    WHERE Name LIKE :searchPattern 
                    LIMIT 100
                ];
                
                System.debug('Books found (text): ' + books.size());
                
                users = [
                    SELECT Id, Name, Email, Gender__c
                    FROM User
                    WHERE Name LIKE :searchPattern
                       OR Email LIKE :searchPattern
                       OR Gender__c LIKE :searchPattern
                    LIMIT 100
                ];
                
                System.debug('Users found (text): ' + users.size());
            }
            
            DataWrapper wrapper = new DataWrapper(books, users);
            return wrapper;
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
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