@IsTest
public class OauthUtilTest{
    
    

    static testMethod void testCallout() {
       
          insert new Oauth_settings__c(Name = 'Credentials',ClientId__c= '541255441');
             insert new Oauth_settings__c(Name = 'Credentials',ClientSecret__c= 'f4544155d5d44sd55fd4d5d');
             insert new Oauth_settings__c(Name = 'Credentials',Username__c= 'test@name.com');
             insert new Oauth_settings__c(Name = 'Credentials',Password__c= 'password');
             insert new Oauth_settings__c(Name = 'Credentials',URL__c= 'http://fakeurl.com');
     
        // Set mock callout class 
        Test.StartTest();   
        Test.setMock(HttpCalloutMock.class, new OauthUtilMockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = OauthUtil.Authenticate('Credentials');
        system.debug('Response***'+res);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"access_token":"00D0j0000000UDd!AQoAQEtWtKhwjeTE9xlgoghHK7tqoA6IIzRhuhv4w1Zsql7ZaSmVdx.8HtuhYze_WNaFZHG1o9Lc6_.zrNYI.kpzfrM4mLfR","instance_url":"https://wksfs--QA.cs53.my.salesforce.com","id":"https://test.salesforce.com/id/00D0j0000000UDdEAM/005E0000007XMd5IAG","token_type":"Bearer","issued_at":"1506434064430","signature":"DvjG6Q6uvH/raptiGLadfug2QQ4UQWh0hfviv5Q3dNs="}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
         OauthUtil.OAuth2 objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(res.getbody(), OauthUtil.OAuth2.class);
        
      Test.StopTest();
    }  
   
   static testMethod void ExceptionCallout() {
       
          insert new Oauth_settings__c(Name = 'Credentials',ClientId__c= '541255441');
             insert new Oauth_settings__c(Name = 'Credentials',ClientSecret__c= 'f4544155d5d44sd55fd4d5d');
             insert new Oauth_settings__c(Name = 'Credentials',Username__c= 'test@name.com');
             insert new Oauth_settings__c(Name = 'Credentials',Password__c= 'password');
             //insert new Oauth_settings__c(Name = 'Credentials',URL__c= 'http://fakeurl.com');
     
        // Set mock callout class 
        Test.StartTest();   
        
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = OauthUtil.Authenticate('Credentials');
        
        
        
        
      Test.StopTest();
    }  
   

}