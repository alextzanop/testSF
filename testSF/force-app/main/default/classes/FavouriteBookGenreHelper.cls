public with sharing class FavouriteBookGenreHelper {
    public static void updateFavouriteGenre(Set<Id> affectedUserIds) {
        
        if(affectedUserIds.isEmpty()) {
            System.debug('No users affected');
            return;
        }
        
        System.debug('Affected User IDs: ' + affectedUserIds);
        
        List<Lending__c> lendings = [
        SELECT Id, User_c__c, Book__r.Genre__c
        FROM Lending__c
        WHERE Is_Active__c = true AND User_c__c IN :affectedUserIds
    ];
        System.debug('Lendings found: ' + lendings.size());
        
        Map<Id, Map<String, Integer>> userGenreCount = new Map<Id, Map<String, Integer>>();
        
        for (Lending__c lending : lendings) {
            Id userId = lending.User_c__c;
            String genre = lending.Book__r.Genre__c;
            
            System.debug('Processing - User: ' + userId + ', Genre: ' + genre);
            
            if (genre == null) {
                System.debug('Genre is null, skipping');
                continue;
            }
            
            if (!userGenreCount.containsKey(userId)) {
                userGenreCount.put(userId, new Map<String, Integer>());
            }
            
            Map<String, Integer> genres = userGenreCount.get(userId);
            if(genres.get(genre) == null) {
                genres.put(genre, 1);
            } else {
                genres.put(genre, genres.get(genre) + 1 );
            }
        }
        
        System.debug('User Genre Count: ' + userGenreCount);
        
        List<User> usersToUpdate = new List<User>();
        
        for (Id userId : userGenreCount.keySet()) {
            
            String favouriteGenre = getFavouriteGenre(userGenreCount.get(userId));
            
            System.debug('User: ' + userId + ', Favourite Genre: ' + favouriteGenre);
            
            usersToUpdate.add(new User(Id = userId, Favourite_Book_Genre__c = favouriteGenre));
        }
        
        if (!usersToUpdate.isEmpty()) {
            System.debug('Updating ' + usersToUpdate.size() + ' users');
            update usersToUpdate;
        }
        
    }
    
    private static String getFavouriteGenre(Map<String, Integer> genres) {
        String favouriteGenre = null;
        Integer maxCount = 0;
        
        for (String genre : genres.keySet()) {
            if (genres.get(genre) > maxCount) {
                maxCount = genres.get(genre);
                favouriteGenre = genre;
            }
        }
        
        return favouriteGenre;
    }
}