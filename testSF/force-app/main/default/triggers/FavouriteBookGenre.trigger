trigger FavouriteBookGenre on Lending__c (after insert, after delete, after update) {
    Set<Id> affectedUserIds = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Lending__c lending : Trigger.new) {
            if (lending.User_c != null) {
                affectedUserIds.add(lending.User_c);
            }
        }
    }
    
    if (Trigger.isDelete || Trigger.isUpdate) {
        for (Lending__c lending : Trigger.old) {
            if (lending.User_c != null) {
                affectedUserIds.add(lending.User_c);
            }
        }
    }
    
    List<Lending__c> lendings = [
        SELECT Id, User_c, Book__r.Genre__c
        FROM Lending__c
        WHERE Is_Active__c = true AND User_c IN :affectedUserIds
    ];
    
    Map<Id, Map<String, Integer>> userGenreCount = new Map<Id, Map<String, Integer>>();
    
    for (Lending__c lending : lendings) {
        Id userId = lending.User_c;
        String genre = lending.Book__r.Genre__c;
        
        if (!userGenreCount.containsKey(userId)) {
            userGenreCount.put(userId, new Map<String, Integer>());
        }
        
        Map<String, Integer> genres = userGenreCount.get(userId);
        genres.put(genre, genres.containsKey(genre) ? genres.get(genre) + 1 : 1);
    }
    
    List<User__c> usersToUpdate = new List<User__c>();
    
    for (Id userId : userGenreCount.keySet()) {
        Map<String, Integer> genres = userGenreCount.get(userId);
        
        String favouriteGenre = null;
        Integer maxCount = 0;
        
        for (String genre : genres.keySet()) {
            if (genres.get(genre) > maxCount) {
                maxCount = genres.get(genre);
                favouriteGenre = genre;
            }
        }
        
        usersToUpdate.add(new User__c(Id = userId, Favourite_Genre__c = favouriteGenre));
    }
    
    if (!usersToUpdate.isEmpty()) {
        update usersToUpdate;
    }
}