/*
 * test class for TSM_CustomOpportunityLookupController class
 */
@isTest
public with sharing class TSM_CustomOppLookupControllerTest {
	// test data
    @testSetup static void dataPrep() {
    	
        // insert the new accounts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,2,2,true);
    }

    // test the Opportunity Search with a test string.
    @isTest static void testOppSearchwithSearchString() {

    	List<Account> acctList = [SELECT Id FROM Account];

    	List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity];

    	if(oppList != null && !oppList.isEmpty()){
    		Opportunity opp = oppList[0];
    		opp.name = 'sampleOpp';
    		update opp;
    	}
    	
    	Test.startTest();
			
			PageReference pageRefOne = Page.TSM_CustomOpportunityLookup;
	        pageRefOne.getParameters().put('relatedAccountId', acctList[0].Id);
	        pageRefOne.getParameters().put('lksrch', 'sampleOpp');
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomOpportunityLookupController lookupCon = new TSM_CustomOpportunityLookupController();

		Test.stopTest();
		System.assertEquals(1, lookupCon.results.size());
    }

    // test the Opportunity Search with a test string.
    @isTest static void testOppSearchwithoutSearchString() {

    	List<Account> acctList = [SELECT Id FROM Account];

    	Test.startTest();
			
			//when action = create new account and new contact
			PageReference pageRefOne = Page.TSM_CustomOpportunityLookup;
	        pageRefOne.getParameters().put('relatedAccountId', acctList[0].Id);
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomOpportunityLookupController lookupCon = new TSM_CustomOpportunityLookupController();
			lookupCon.search();
			String formTag = lookupCon.getFormTag();
			String textBox = lookupCon.getTextBox();

		Test.stopTest();
		System.assertEquals(2, lookupCon.results.size());
    }

}