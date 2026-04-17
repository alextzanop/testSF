public with sharing class CompletedLendingsMondayBatch implements Database.Batchable<SObject> , Schedulable, Database.AllowsCallouts{
    
    public static String CRON_EXP = '0 2 ? * MON *';
    
    
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Lending__c WHERE Is_Active__c  = False', AccessLevel.USER_MODE);
    }
    
    public void execute(Database.BatchableContext bc, List<Lending__c> lendings){
        if(!lendings.isEmpty()){
            
            String jsonBody = JSON.serialize(lendings);
            
            HttpRequest request = makePostCallout(jsonBody);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                System.debug(' Callout successful: ' + response.getBody());
                delete lendings ;
            } else {
                System.debug(' Callout failed: ' + response.getStatusCode());
                System.debug('Error: ' + response.getBody());
            }
            
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