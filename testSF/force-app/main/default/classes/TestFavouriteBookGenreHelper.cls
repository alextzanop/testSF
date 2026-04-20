@IsTest
public with sharing class TestFavouriteBookGenreHelper {
    
    @testSetup
    static void setup() {
        Library__c lib= new Library__c(Name = 'TestLibrary');
        insert lib;
        Book__c book1 = new Book__c(Name = 'TesterBook1', Genre__c = 'Science Fiction', Library__c = lib.Id );
        Book__c book2 = new Book__c(Name = 'TesterBook2', Genre__c = 'Science Fiction', Library__c = lib.Id );
        Book__c book3 = new Book__c(Name = 'TesterBook3', Genre__c = 'Textbook', Library__c = lib.Id );
        insert new List<Book__c>{book1, book2, book3};
        User user1 = new User(
            Username = 'test.user.xariskaramf.exercise2@example.com',
        Email = 'test.user.xariskaramf.exercise2@example.com',
        LastName = 'User',
        Alias = 'testuser',
        TimeZoneSidKey = 'Europe/Athens',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
            );
        insert user1;
    }
    
    @IsTest static void testUpdateFavouriteGenreWithNullGenre() {
        User user = [SELECT Id FROM User WHERE Username = 'test.user.xariskaramf.exercise2@example.com' LIMIT 1];
        Book__c book = [SELECT Id FROM Book__c WHERE Name = 'TesterBook1'];
        Lending__c lending = new Lending__c(User_c__c = user.Id, Book__c = book.Id, Is_Active__c = true,Start_date__c = Date.today());
        insert lending;
        Test.startTest();
        FavouriteBookGenreHelper.updateFavouriteGenre(new Set<Id>{user.Id});
        Test.stopTest();
        user = [SELECT Favourite_Book_Genre__c FROM User WHERE Id = :user.Id];
        System.assertEquals('Science Fiction', user.Favourite_Book_Genre__c, 'Favourite genre should be Science Fiction');
    }
    
    
    
    
    
    
    
    @IsTest static void testNoAffectedUsers() {
        Test.startTest();
        FavouriteBookGenreHelper.updateFavouriteGenre(new Set<Id>());
        Test.stopTest();
        System.assert(true, 'Method should exit gracefully with no affected users');
    }
    
}