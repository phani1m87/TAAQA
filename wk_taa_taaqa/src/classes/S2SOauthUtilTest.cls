@IsTest
public class S2SOauthUtilTest{
    
    

    static testMethod void testCallout() {
       
          insert new Oauth_settings__c(Name = 'Credentials',ClientId__c= '541255441');
             insert new Oauth_settings__c(Name = 'Credentials',ClientSecret__c= 'f4544155d5d44sd55fd4d5d');
             insert new Oauth_settings__c(Name = 'Credentials',Username__c= 'test@name.com');
             insert new Oauth_settings__c(Name = 'Credentials',Password__c= 'password');
             insert new Oauth_settings__c(Name = 'Credentials',URL__c= 'http://fakeurl.com');
     
        // Set mock callout class 
        Test.StartTest();   
        Test.setMock(HttpCalloutMock.class, new S2S_OauthUtilMockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = OauthUtil.Authenticate();
        system.debug('Response***'+res);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
        
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
        HttpResponse res = OauthUtil.Authenticate();
        
        
        
        
      Test.StopTest();
    }  
   

}