@isTest
global class OauthUtilMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://fakeurl.com/services/oauth2/token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"00D0j0000000UDd!AQoAQEtWtKhwjeTE9xlgoghHK7tqoA6IIzRhuhv4w1Zsql7ZaSmVdx.8HtuhYze_WNaFZHG1o9Lc6_.zrNYI.kpzfrM4mLfR","instance_url":"https://wksfs--QA.cs53.my.salesforce.com","id":"https://test.salesforce.com/id/00D0j0000000UDdEAM/005E0000007XMd5IAG","token_type":"Bearer","issued_at":"1506434064430","signature":"DvjG6Q6uvH/raptiGLadfug2QQ4UQWh0hfviv5Q3dNs="}');
        res.setStatusCode(200);
        return res;
    }
}