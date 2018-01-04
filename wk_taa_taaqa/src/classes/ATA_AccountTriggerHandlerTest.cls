/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/27/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
@isTest(seeAllData = false)
private class ATA_AccountTriggerHandlerTest 
{
    // *** test class for ATA_AccountTriggerHandler
    
    /**** data preparation ****/
    
    @testSetup static void testDataFactory() 
    {
		// create test account
		Account objAccount = ATA_TestDateFactory.create_Account();
		insert objAccount;
		
		// create ATA custom setting		
		ATA_TestDateFactory.create_ATACustomSetting();
		
		// ATA Rules
		ATA_TestDateFactory.create_ATARule('TAA_Software_New_Sales__c');
		ATA_TestDateFactory.create_ATARule('R_L_New_Sales__c');
		ATA_TestDateFactory.create_ATARule('R_L_Retention_Owner_ATA__c');
		
		// **** add rest of the driver fields into ATA Rule
		
		// ATA Assignment Types
		ATA_TestDateFactory.create_ATAAssignmentType('ATA1', 'ATA', 'TAA_Software_New_Sales', 'TAA_Software_New_Sales__c', 'National Accounts');
		ATA_TestDateFactory.create_ATAAssignmentType('ATA2', 'ATA', 'R_L_New_Sales', 'R_L_New_Sales__c', 'R&L Field Sales');
		ATA_TestDateFactory.create_ATAAssignmentType('ATA3', 'ATA', 'R_L_Retention_Owner_ATA', 'R_L_Retention_Owner_ATA__c', 'R&L Retention');
		
		// **** add rest of the driver fields into ATA Assignment Type
		
		// ATA Role Assignments
		ATA_TestDateFactory.create_ATARoleAssignment('ATA1', 'Named / National', 'National Solution Consultant', 'Name Match');
		ATA_TestDateFactory.create_ATARoleAssignment('ATA2', 'Segment SalesOwnership', 'RSC - R&L Field', 'Geographic PostalCode');
		ATA_TestDateFactory.create_ATARoleAssignment('ATA3', 'Segment SalesOwnership', 'RC - R&L Retention', 'Geographic PostalCode');
		// **** add rest of the roles
    }
	
	/**** Non Geo Assignment Tests ****/
	   
    // non geo assignment: test # 1 
    static testmethod void testNongeographicAssignment_Positive()
    {
		Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
		
		Test.startTest();
		ATA_TestDateFactory.create_ATANongeographicAssignment('AccountTeam', 'Name', objAccount.Name, 'National Solution Consultant', '9901', 'Named / National');
		
		objAccount.Named_Account_Type__c = 'National';
		objAccount.Named_Account__c = true;
		
		update objAccount;
		Test.stopTest();	
    }
    
    // non geo assignment: test # 2 
    static testmethod void testNongeographicAssignment_NoActiveUser()
    {
		Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
		
		Test.startTest();
		ATA_TestDateFactory.create_ATANongeographicAssignment('AccountTeam', 'Name', objAccount.Name, 'National Solution Consultant', '990A', 'Named / National');
		
		objAccount.Named_Account_Type__c = 'National';
		objAccount.Named_Account__c = true;
		
		update objAccount;
		Test.stopTest();	
    }
    
    // non geo assignment: test # 3 
    static testmethod void testNongeographicAssignment_MissingNongeoAssignment()
    {
		Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
    	
    	Test.startTest();
		objAccount.Named_Account_Type__c = 'National';
		objAccount.Named_Account__c = true;
		
		update objAccount;	
    	Test.stopTest();
    }
    
    // non geo assignment: test # 4 
    static testmethod void testNongeographicAssignment_NonMandatoryRole()
    {
    	Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
    	
    	Test.startTest();
		AccountAutomationSetting__c cust = AccountAutomationSetting__c.getOrgDefaults();
		cust.Terminate_Account_Team_Role_Names__c = '["Strategic Solution Consultant"]';
		update cust;
		
		objAccount.Named_Account_Type__c = 'National';
		objAccount.Named_Account__c = true;
		
		update objAccount;
    	Test.stopTest();
    }
    
    /**** Geo Assignment Tests ****/
    
    // geo assignment: test # 1 
    static testmethod void testGeographicAssignment_Positive()
    {
    	Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
    	
    	Test.startTest();
    	ATA_TestDateFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', '9909');
    	ATA_TestDateFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - R&L Field', '6102');
    	
    	objAccount.Name = 'ATA_TEST_ACCOUNT_1';
    	objAccount.Named_Account_Type__c = '';
		objAccount.Named_Account__c = false;
		
		update objAccount;
    	Test.stopTest();
    }
    
    /**** ATA Other ****/
    
    // ATA Other : test # 1 
    static testmethod void testATA_InvalidFieldRule()
    {
		Test.startTest();
		ATA_TestDateFactory.create_ATARule('TestField__c');
		
		Account objAccount = ATA_TestDateFactory.create_Account();
		insert objAccount;
    	Test.stopTest();
    }
    
    // ATA Other: test # 2 
    static testmethod void testATA_WebserviceMethod()
    {
    	Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
    	
    	Test.startTest();
    	ATA_AccountTeamHandler.reCreateAccountTeamInteractive(String.valueOf(objAccount.Id));
    	Test.stopTest();
    }
    
    // geo assignment: test # 4 
    static testmethod void testGeographicAssignment_NonMandatoryRole()
    {
    	Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
    	
    	Test.startTest();
    	
    	Test.stopTest();
    }
}