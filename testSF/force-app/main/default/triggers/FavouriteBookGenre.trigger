trigger FavouriteBookGenre on Lending__c (after insert, after delete, after update) {
    Set<Id> affectedUserIds = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Lending__c lending : Trigger.new) {
            if (lending.User_c__c != null) {
                affectedUserIds.add(lending.User_c__c);
            }
        }
    }
    
    if (Trigger.isDelete || Trigger.isUpdate) {
        for (Lending__c lending : Trigger.old) {
            if (lending.User_c__c != null) {
                affectedUserIds.add(lending.User_c__c);
            }
        }
    }
    
    FavouriteBookGenreHelper.updateFavouriteGenre(affectedUserIds);
}