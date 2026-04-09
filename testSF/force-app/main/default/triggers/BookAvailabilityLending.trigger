trigger BookAvailabilityLending on Lending__c (after insert , after update, after undelete , after delete){
    
    Set<Id> bookIds = new Set<Id>();
    
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        
        for (Lending__c lending : Trigger.new){
            if(lending.Book__c != null){
                bookIds.add(lending.Book__c);
            }
        }
    }
    
    if( Trigger.isDelete){
        for (Lending__c lending : Trigger.old){
            if(lending.Book__c != null){
                bookIds.add(lending.Book__c);
            }
        }
    }
    
    
    if (!bookIds.isEmpty()) {
        
        List<Book__c> books = [SELECT Id, Active_Lendings__c, 
            (SELECT Id FROM Lendings1__r WHERE Is_Active__c = TRUE) 
            FROM Book__c 
            WHERE Id IN :bookIds];
        
        
        for (Book__c book : books) {
            book.Active_Lendings__c = book.Lendings1__r.size();
        }
        
        
        update books;
        
    }
}