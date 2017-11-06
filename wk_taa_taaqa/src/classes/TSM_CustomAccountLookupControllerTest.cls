/*
 * test class for TSM_CustomAccountLookupController class
 */
@isTest
public with sharing class TSM_CustomAccountLookupControllerTest {
	// test data
    @testSetup static void dataPrep() {
    	
        // insert the new accounts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(2,0,0,false);
    }

    // test the Account Search with a test string.
    @isTest static void testAcountSearchwithName() {

    	List<Account> acctList = [SELECT Id FROM Account];
    	
    	Test.startTest();
			
			PageReference pageRefOne = Page.TSM_CustomAccountLookup;
	        pageRefOne.getParameters().put('lksrch', 'Test');
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomAccountLookupController lookupCon = new TSM_CustomAccountLookupController();

		Test.stopTest();
		System.assertEquals(2, lookupCon.results.size());
    }

    // test the Account Search with a test string.
    @isTest static void testAccountSearchwithSFDCAccount() {

    	List<Account> acctList = [SELECT Id, SFDC_Account__c FROM Account];
    	String sfdcAccount =  acctList[0].SFDC_Account__c;
    	Test.startTest();
			
			PageReference pageRefOne = Page.TSM_CustomAccountLookup;
	        pageRefOne.getParameters().put('lksrch', sfdcAccount);
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomAccountLookupController lookupCon = new TSM_CustomAccountLookupController();
			lookupCon.search();
			String formTag = lookupCon.getFormTag();
			String textBox = lookupCon.getTextBox();

		Test.stopTest();
		System.assertEquals(1, lookupCon.results.size());
    }

}