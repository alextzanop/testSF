@isTest
public with sharing class TestCompletedLendingsMondayBatch {
    
    
    @testSetup
    static void setup() {
        Library__c lib= new Library__c(Name = 'TestLibrary');
        insert lib;
        Book__c book = new Book__c(Name = 'TesterBook', Library__c = lib.Id );
        insert book;
        
    }
    
    @isTest static void testLendindsIsActiveEqualToFalse(){
        List<Lending__c> lendings = new List<Lending__c>();
        Book__c book = [SELECT Id FROM Book__c WHERE Name = 'TesterBook' LIMIT 1];
        for(Integer i=0; i<5; i++){
            Lending__c lending = new Lending__c( Book__c = book.Id, Is_Active__c = false, Start_date__c = Date.today());
            lendings.add(lending);
        }
        insert lendings;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        CompletedLendingsMondayBatch batch = new CompletedLendingsMondayBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        List<Lending__c> updatedLendings = [SELECT Id, Is_Active__c FROM Lending__c WHERE Id IN :lendings];
        for(Lending__c lending : updatedLendings){
            System.assertEquals(0, updatedLendings.size(), 'All test lendings should be deleted');
        }
    }
    
    // @isTest static void testLendindsIsActiveEqualToNull(){
        //     List<Lending__c> lendings = new List<Lending__c>();
        //     Book__c book = [SELECT Id FROM Book__c WHERE Name = 'TesterBook' LIMIT 1];
        //     for(Integer i=0; i<5; i++){
            //         Lending__c lending = new Lending__c( Book__c = book.Id, Is_Active__c = null);
            //         lendings.add(lending);
        //     }
        //     insert lendings;
        
        //     Test.startTest();
        //     CompletedLendingsMondayBatch batch = new CompletedLendingsMondayBatch();
        //     Database.executeBatch(batch);
        //     Test.stopTest();
        
        //     List<Lending__c> updatedLendings = [SELECT Id, Is_Active__c FROM Lending__c WHERE Name LIKE 'TestLending%'];
        //     for(Lending__c lending : updatedLendings){
            //         System.assertEquals(0, updatedLendings.size(), 'All test lendings should not be deleted');
        //     }
    // }
    
    // @isTest static void testLendindsIsActiveEqualToTrue(){
        //     List<Lending__c> lendings = new List<Lending__c>();
        //     Book__c book = [SELECT Id FROM Book__c WHERE Name = 'TesterBook' LIMIT 1];
        //     for(Integer i=0; i<5; i++){
            //         Lending__c lending = new Lending__c( Book__c = book.Id, Is_Active__c = true);
            //         lendings.add(lending);
        //     }
        //     insert lendings;
        
        //     Test.startTest();
        //     CompletedLendingsMondayBatch batch = new CompletedLendingsMondayBatch();
        //     Database.executeBatch(batch);
        //     Test.stopTest();
        
        //     List<Lending__c> updatedLendings = [SELECT Id, Is_Active__c FROM Lending__c WHERE Name LIKE 'TestLending%'];
        //     for(Lending__c lending : updatedLendings){
            //         System.assertEquals(5, updatedLendings.size(), 'The lendings should not delete');
        //     }
    // }
    
    // @isTest static void testNoExistingLendinds(){
        //     List<Lending__c> lendings = new List<Lending__c>();
        //     for(Integer i=0; i<5; i++){
            //         Lending__c lending = new Lending__c(Name = 'TestLending'+i, Book__c = [SELECT Id FROM Book__c WHERE Name = 'TesterBook' LIMIT 1].Id, IsActive__c = null);
            //         lendings.add(lending);
        //     }
        //     insert lendings;
        
        //     Test.startTest();
        //     CompletedLendingsMondayBatch batch = new CompletedLendingsMondayBatch();
        //     Database.executeBatch(batch);
        //     Test.stopTest();
        
        //     List<Lending__c> updatedLendings = [SELECT Id, IsActive__c FROM Lending__c WHERE Name LIKE 'TestLending%'];
        //     for(Lending__c lending : updatedLendings){
            //         System.assertEquals(false, lending.IsActive__c, 'The lending should be inactive');
        //     }
    // }
    
    
    
    
}