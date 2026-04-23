public with sharing class CompletedLendingsMondayBatch implements Database.Batchable<SObject> , Schedulable, Database.AllowsCallouts{
    
    public static String CRON_EXP = '0 0 2 ? * MON *';
    
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id FROM Lending__c WHERE Is_Active__c = False',
        AccessLevel.SYSTEM_MODE
            );
    }
    
    public void execute(Database.BatchableContext bc, List<Lending__c> lendings){
        System.debug(' EXECUTE CALLED - Records: ' + lendings.size());
        
        if(!lendings.isEmpty()){
            System.debug(' Processing ' + lendings.size() + ' lendings');
            
            String jsonBody = JSON.serialize(lendings);
            System.debug(' JSON Body: ' + jsonBody);
            
            
            HttpRequest request = makePostCallout(jsonBody);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug(' Callout Status: ' + response.getStatusCode());
            
            
            if (response.getStatusCode() == 200) {
                System.debug(' Callout successful: ' + response.getBody());
                delete lendings ;
            } else {
                System.debug(' Callout failed: ' + response.getStatusCode());
                System.debug('Error: ' + response.getBody());
            }
            
        } else {
            System.debug(' No lendings to process.');
        }
        
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CompletedLendingsMondayBatch(), 200);
    }
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
    
    public static HttpRequest makePostCallout(String jsonBody){
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://webhook.site/67f45ada-18e7-4fcb-92a3-3fd765c0a859');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonBody);
        request.setTimeout(30000);
        
        return request;
    }
    
}