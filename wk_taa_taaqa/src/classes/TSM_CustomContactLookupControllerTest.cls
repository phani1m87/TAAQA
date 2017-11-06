/*
 * test class for TSM_CustomContactLookupController class
 */
@isTest
public with sharing class TSM_CustomContactLookupControllerTest {
	// test data
    @testSetup static void dataPrep() {
    	
        // insert the new accounts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,2,0,false);
    }

    // test the Contact Search with a test string.
    @isTest static void testConSearchwithSearchString() {

    	List<Account> acctList = [SELECT Id FROM Account];

    	List<Contact> cList = [SELECT Id, Name FROM Contact];

    	if(cList != null && !cList.isEmpty()){
    		Contact c = cList[0];
    		c.LastName = 'SampleLastName';
    		update c;
    	}
    	
    	Test.startTest();
			
			PageReference pageRefOne = Page.TSM_CustomContactLookup;
	        pageRefOne.getParameters().put('relatedAccountId', acctList[0].Id);
	        pageRefOne.getParameters().put('lksrch', 'SampleLastName');
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomContactLookupController lookupCon = new TSM_CustomContactLookupController();

		Test.stopTest();
		System.assertEquals(1, lookupCon.results.size());
    }

    // test the Contact Search with a test string.
    @isTest static void testConSearchwithoutSearchString() {

    	List<Account> acctList = [SELECT Id FROM Account];
    	Test.startTest();
			
			PageReference pageRefOne = Page.TSM_CustomContactLookup;
	        pageRefOne.getParameters().put('relatedAccountId', acctList[0].Id);
	        Test.setCurrentPage(pageRefOne);
	          
			TSM_CustomContactLookupController lookupCon = new TSM_CustomContactLookupController();
			lookupCon.search();
			String formTag = lookupCon.getFormTag();
			String textBox = lookupCon.getTextBox();

		Test.stopTest();
		System.assertEquals(2, lookupCon.results.size());
    }

}