/*
 * test class for below components
 * 1. UpdateOpportunitySplit.trigger
 * 2. OpportunitySplitHandler.cls  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 05/01/2017 SHIVAJI           1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest (seeAllData = false)
public class TestOpportunitySplitHandler {

    static Schema.DescribeSObjectResult accountSchema = Account.sObjectType.getDescribe();
    static Map<String,Schema.RecordTypeInfo> accountRecordTypes = accountSchema.getRecordTypeInfosByName();
        
    // data preparation
    @testSetup static void testdataFactory() {
    
    /// here we need two accounts: the account to be inserted or updated and 
    /// the account that represents the Responsible channel partner....
    /// We also need a third account to act as the internal WK channel partner - Prosoft.
    	Trigger_Control__c config = new Trigger_Control__c();
    	config.Name = 'executeOpportunityTrigger';
    	config.isTriggerOff__c = false;
    	insert config;
    	
    	Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
   		List<User> userList = new List<User>();
   		User owner_1 = new User(Alias = 'newUser', Email = 'abc@example.com', EmailEncodingKey = 'UTF-8', LastName = 'lastName', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, DTN__c = '0001X', TimeZoneSidKey='America/Los_Angeles', UserName='abc@example.com.test', isActive = true);
        userList.add(owner_1); 
        User owner_2 = new User(Alias = 'newUser', Email='xyz@example.com', EmailEncodingKey = 'UTF-8', LastName = 'lastName', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, DTN__c = '0002X', TimeZoneSidKey='America/Los_Angeles', UserName='xyz@example.com.test', isActive = true);
        userList.add(owner_2);
        User owner_3 = new User(Alias = 'newUser', Email='pqr@example.com', EmailEncodingKey = 'UTF-8', LastName = 'lastName', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, DTN__c = '0003X', TimeZoneSidKey='America/Los_Angeles', UserName='pqr@example.com.test', isActive = true);
        userList.add(owner_3);
    	insert userList;
    	
    	List<Opportunity_Overlay_Split__c> lstOverlaySplits = new List<Opportunity_Overlay_Split__c>();
    	Opportunity_Overlay_Split__c overlaySplit0001X = new Opportunity_Overlay_Split__c();
    	overlaySplit0001X.Name = String.valueOf(owner_1.Id).subString(0,15);
    	overlaySplit0001X.Opportunity_Split_Assignee_Id__c = String.valueOf(owner_1.Id).subString(0,15);
    	lstOverlaySplits.add(overlaySplit0001X);
    	
    	Opportunity_Overlay_Split__c overlaySplit0002X = new Opportunity_Overlay_Split__c();
    	overlaySplit0002X.Name = String.valueOf(owner_2.Id).subString(0,15);
    	overlaySplit0002X.Opportunity_Split_Assignee_Id__c = String.valueOf(owner_1.Id).subString(0,15);
    	lstOverlaySplits.add(overlaySplit0002X);
    	insert lstOverlaySplits;
    	
    	TSM_TestDataUtil.createAccounts(1,1,1,true);
    }
    // Insert Scenarios ...

    // positive scenario 
    @isTest static void testInsertPositive() {
		User u = [SELECT Id FROM User WHERE Email = 'abc@example.com'];
		Account objAccount = [SELECT Id FROM Account LIMIT 1];
		Contact objContact = [SELECT Id FROM Contact LIMIT 1];
		System.runAs(u){
			Opportunity objOpportunity = new Opportunity();
			objOpportunity.Name = 'Test Oppty';
			objOpportunity.AccountId = objAccount.Id;
			objOpportunity.Primary_Contact_for_Proposal__c = objContact.Id;		
			objOpportunity.Type = 'New to Existing';
			objOpportunity.Product_Category__c = 'Corporate Software';
			objOpportunity.Product_Sub_Category__c = 'Compliance';
			objOpportunity.CloseDate = System.Today().addDays(30);
			objOpportunity.StageName = '2. Recognize Need';
			objOpportunity.Forecast_Type__c = 'Medium (50-90%)';
			objOpportunity.Amount = 12000.00;
			
			Test.startTest();
			insert objOpportunity;
			//Id overlayOpptySplitTypeId = [SELECT Id,DeveloperName FROM OpportunitySplitType WHERE OpportunitySplitType.DeveloperName = 'Overlay'].Id;
			OpportunitySplit opptySplit = [SELECT Id, SplitOwnerId, SplitType.DeveloperName FROM OpportunitySplit WHERE OpportunityId =: objOpportunity.Id LIMIT 1];
			System.Assert(u.Id == opptySplit.SplitOwnerId, 'Overlay split is created');
			Test.stopTest();
		}      
    }
	    
    // negative scenario 
    @isTest static void testInsertNegative() {
    	User u = [SELECT Id FROM User WHERE Email = 'pqr@example.com'];
		Account objAccount = [SELECT Id FROM Account LIMIT 1];
		Contact objContact = [SELECT Id FROM Contact LIMIT 1];
		System.runAs(u){
			Opportunity objOpportunity = new Opportunity();
			objOpportunity.Name = 'Test Oppty';
			objOpportunity.AccountId = objAccount.Id;
			objOpportunity.Primary_Contact_for_Proposal__c = objContact.Id;		
			objOpportunity.Type = 'New to Existing';
			objOpportunity.Product_Category__c = 'Corporate Software';
			objOpportunity.Product_Sub_Category__c = 'Compliance';
			objOpportunity.CloseDate = System.Today().addDays(30);
			objOpportunity.StageName = '2. Recognize Need';
			objOpportunity.Forecast_Type__c = 'Medium (50-90%)';
			objOpportunity.Amount = 12000.00;
			
			Test.startTest();
			insert objOpportunity;
			List<OpportunitySplit> lstOpptySplit = [SELECT Id, SplitOwnerId, SplitType.DeveloperName FROM OpportunitySplit WHERE OpportunityId =: objOpportunity.Id AND SplitType.DeveloperName = 'Overlay'];
			//System.debug('##: ' + lstOpptySplit);
			System.Assert(lstOpptySplit.size() == 0, 'No overlay split is created');
			Test.stopTest();
		}   
    }
    
    // bulk records handling 
    @isTest static void testInsertBulk() {
    	User u = [SELECT Id FROM User WHERE Email = 'abc@example.com'];
		Account objAccount = [SELECT Id FROM Account LIMIT 1];
		Contact objContact = [SELECT Id FROM Contact LIMIT 1];
		System.runAs(u){
			List<Opportunity> lstOpportunity = new List<Opportunity>();
			for(integer i = 0; i < 5; i++){
				Opportunity objOpportunity = new Opportunity();
				objOpportunity.Name = 'Test Oppty ' + i;
				objOpportunity.AccountId = objAccount.Id;
				objOpportunity.Primary_Contact_for_Proposal__c = objContact.Id;		
				objOpportunity.Type = 'New to Existing';
				objOpportunity.Product_Category__c = 'Corporate Software';
				objOpportunity.Product_Sub_Category__c = 'Compliance';
				objOpportunity.CloseDate = System.Today().addDays(30);
				objOpportunity.StageName = '2. Recognize Need';
				objOpportunity.Forecast_Type__c = 'Medium (50-90%)';
				objOpportunity.Amount = 12000.00;
				lstOpportunity.add(objOpportunity);
			}
			
			Test.startTest();
			insert lstOpportunity;
			
			Set<Id> setOpptyId = new Set<Id>();
			for(Opportunity objOppty : lstOpportunity){
				setOpptyId.add(objOppty.Id);
			}	
			
			List<OpportunitySplit> lstOpptySplit = [SELECT Id, SplitOwnerId, SplitType.DeveloperName FROM OpportunitySplit WHERE OpportunityId IN: setOpptyId];
			for(OpportunitySplit opptySplit : lstOpptySplit){
				System.Assert(u.Id == opptySplit.SplitOwnerId, 'Overlay split is created');
			}
			Test.stopTest();
		}
    }
    // Update Scenarios ...           

    // positive scenario 
    @isTest static void testUpdatePositive() {
        User u = [SELECT Id FROM User WHERE Email = 'abc@example.com'];
        User updateOwner = [SELECT Id FROM User WHERE Email = 'xyz@example.com'];
		Account objAccount = [SELECT Id FROM Account LIMIT 1];
		Contact objContact = [SELECT Id FROM Contact LIMIT 1];
		System.runAs(u){
			Opportunity objOpportunity = new Opportunity();
			objOpportunity.Name = 'Test Oppty';
			objOpportunity.AccountId = objAccount.Id;
			objOpportunity.Primary_Contact_for_Proposal__c = objContact.Id;		
			objOpportunity.Type = 'New to Existing';
			objOpportunity.Product_Category__c = 'Corporate Software';
			objOpportunity.Product_Sub_Category__c = 'Compliance';
			objOpportunity.CloseDate = System.Today().addDays(30);
			objOpportunity.StageName = '2. Recognize Need';
			objOpportunity.Forecast_Type__c = 'Medium (50-90%)';
			objOpportunity.Amount = 12000.00;
			objOpportunity.OwnerId = u.id;
			//Test.startTest();
			insert objOpportunity;
			//Id overlayOpptySplitTypeId = [SELECT Id,DeveloperName FROM OpportunitySplitType WHERE OpportunitySplitType.DeveloperName = 'Overlay'].Id;
			
			Test.startTest();
			objOpportunity.OwnerId = updateOwner.Id;
			update objOpportunity;
			OpportunitySplit opptySplit = [SELECT Id, SplitOwnerId, SplitType.DeveloperName FROM OpportunitySplit WHERE OpportunityId =: objOpportunity.Id AND SplitType.DeveloperName = 'Overlay' LIMIT 1];
			System.Assert(u.Id == opptySplit.SplitOwnerId, 'Overlay split is updated');
			Test.stopTest();
		} 
    }
    
    // negative scenario 
    @isTest static void testUpdateNegative() {
    	User u = [SELECT Id FROM User WHERE Email = 'abc@example.com'];
        User updateOwner = [SELECT Id FROM User WHERE Email = 'pqr@example.com'];
		Account objAccount = [SELECT Id FROM Account LIMIT 1];
		Contact objContact = [SELECT Id FROM Contact LIMIT 1];
		System.runAs(u){
			Opportunity objOpportunity = new Opportunity();
			objOpportunity.Name = 'Test Oppty';
			objOpportunity.AccountId = objAccount.Id;
			objOpportunity.Primary_Contact_for_Proposal__c = objContact.Id;		
			objOpportunity.Type = 'New to Existing';
			objOpportunity.Product_Category__c = 'Corporate Software';
			objOpportunity.Product_Sub_Category__c = 'Compliance';
			objOpportunity.CloseDate = System.Today().addDays(30);
			objOpportunity.StageName = '2. Recognize Need';
			objOpportunity.Forecast_Type__c = 'Medium (50-90%)';
			objOpportunity.Amount = 12000.00;
			objOpportunity.OwnerId = u.id;
			//Test.startTest();
			insert objOpportunity;
			//Id overlayOpptySplitTypeId = [SELECT Id,DeveloperName FROM OpportunitySplitType WHERE OpportunitySplitType.DeveloperName = 'Overlay'].Id;
			
			Test.startTest();
			objOpportunity.OwnerId = updateOwner.Id;
			update objOpportunity;
			OpportunitySplit opptySplit = [SELECT Id, SplitOwnerId, SplitType.DeveloperName FROM OpportunitySplit WHERE OpportunityId =: objOpportunity.Id AND SplitType.DeveloperName = 'Overlay'];
			System.Assert(updateOwner.Id == opptySplit.SplitOwnerId, 'No overlay split is created.');
			Test.stopTest();
		} 
    }
}