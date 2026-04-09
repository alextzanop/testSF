@isTest
public class testBookAvailabilityLending {
    
    @isTest
    static void testLendingInsert() {
        Library__c library = new Library__c(Name='Library');
        insert library;
        
        Book__c book = new Book__c(Name = 'Test Book', Library__c = library.Id, Total_Number_of_Copies__c = 10);
        insert book;
        
        Lending__c lending = new Lending__c(Book__c = book.Id,	Start_date__c=Date.today());
        insert lending;
        
        Book__c updatedBook = [SELECT Active_Lendings__c FROM Book__c WHERE Id = :book.Id];
        System.assertEquals(1, updatedBook.Active_Lendings__c);
    }
}