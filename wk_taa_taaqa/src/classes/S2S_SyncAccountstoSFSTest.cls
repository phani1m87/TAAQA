/*
    **************************************************************************
    Name    :   S2S_SyncAccountstoSFSTest 
    
    Used for  :   Test class for S2S_SyncAccountstoSFS .
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          05-Sep-2017  
    
   
    
    ***************************************************************************
*/
@isTest 
private class S2S_SyncAccountstoSFSTest {
    
    // test data
    @testSetup static void dataPrep() {
      
        List<S2S_Trigger_Control__c> controlList = new List<S2S_Trigger_Control__c>();
        controlList.add(new S2S_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='CampaignMember',TriggerOff__c=false));            
        insert controlList;        
            
        insert new Oauth_settings__c(Name = 'Credentials',ClientId__c= '541255441');
        insert new Oauth_settings__c(Name = 'Credentials',ClientSecret__c= 'f4544155d5d44sd55fd4d5d');
        insert new Oauth_settings__c(Name = 'Credentials',Username__c= 'test@name.com');
        insert new Oauth_settings__c(Name = 'Credentials',Password__c= 'password');
        insert new Oauth_settings__c(Name = 'Credentials',URL__c= 'http://fakeurl.com');
             
        // insert the new accounts for data
        List<Account> accounts = S2S_TestDataUtil.createAccounts(1,1,1,true);
    }
    
    static testMethod void synctest() {
      
          Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        
        Map<Id, Opportunity> OpportunityMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Opportunity> OpportunityList = OpportunityMap.values();
        System.assertEquals(1, OpportunityList.size());
        
         
       
          Test.StartTest();   
          
          Test.setMock(HttpCalloutMock.class, new OauthUtilMockHttpResponseGenerator());
          S2S_SyncAccountstoSFS.pushaccount(OpportunityList[0].id);
           
         
          
          Test.StopTest();
        
         }
      
      
       static testMethod void syncnegative() {
      
          Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        
        Map<Id, Opportunity> OpportunityMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Opportunity> OpportunityList = OpportunityMap.values();
        System.assertEquals(1, OpportunityList.size());
        
         
       
          Test.StartTest();   
          
          
          S2S_SyncAccountstoSFS.pushaccount(OpportunityList[0].id);
           
         
          
          Test.StopTest();
        
         }
         
          static testMethod void syncexception() {
      
          Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        
        Map<Id, Opportunity> OpportunityMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Opportunity> OpportunityList = OpportunityMap.values();
        System.assertEquals(1, OpportunityList.size());
        
         
       
          Test.StartTest();   
          
          Test.setMock(HttpCalloutMock.class, new S2S_NegativeMockHttpResponseGenerator ());
          S2S_SyncAccountstoSFS.pushaccount(OpportunityList[0].id);
           
         
          
          Test.StopTest();
        
         }
         
          static testMethod void Syncexcep() {
      
          Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        
        Map<Id, Opportunity> OpportunityMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        List<Opportunity> OpportunityList = OpportunityMap.values();
        System.assertEquals(1, OpportunityList.size());
        
         
       
          Test.StartTest();   
          
          Test.setMock(HttpCalloutMock.class, new OauthUtilMockHttpResponseGenerator());
          Test.setMock(HttpCalloutMock.class, new S2S_NegativeMockHttpResponseGenerator ()); 
          S2S_SyncAccountstoSFS.pushaccount(OpportunityList[0].id);
           
         
          
          Test.StopTest();
        
         }   
       
}