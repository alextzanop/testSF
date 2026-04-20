@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://webhook.site/67f45ada-18e7-4fcb-92a3-3fd765c0a859', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}