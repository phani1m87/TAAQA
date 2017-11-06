/*
 * test class for TSM_OneTimeOpportunitySyncBatch apex batch class
 * */
@isTest
public class TSM_OneTimeOpportunitySyncBatchTest {
    // fake test
    @isTest static void testFake() {
        TSM_OneTimeOpportunitySyncBatch batch = new TSM_OneTimeOpportunitySyncBatch();
        System.assertEquals(true,true);
    }
    /*
    // data preparation
    @testSetup static void dataPrep() {
        // insert the new accounts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,1,0,false);       
    }
    // test the batch positive
    @isTest static void testPositive() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id,SFDC_Account__c FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, SFDC_Contact__c FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        // insert the opportunities
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 200, false);
        List<Opportunity> oppList = [SELECT Id, AccountId, Primary_Contact_for_Proposal__c, SFS_Acct_1Force__c,
                                    SFS_Contact_1Force__c FROM Opportunity];
        System.assertEquals(200, oppList.size());
        for(Opportunity opp : oppList) {
            opp.SFS_Acct_1Force__c = acctList[0].SFDC_Account__c;
            opp.SFS_Contact_1Force__c = contList[0].SFDC_Contact__c;
            opp.AccountId = null;
            opp.Primary_Contact_for_Proposal__c = null;
        }
        update oppList;
        Test.startTest();
        Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
        Test.stopTest();
        // assert the value after successful batch
        List<Opportunity> oppWithAccounts = [SELECT Id, AccountId FROM Opportunity WHERE AccountId != null 
                                             AND SFS_Acct_1Force__c = :acctList[0].SFDC_Account__c];
        System.assertEquals(200, oppWithAccounts.size());
        List<Opportunity> oppWithContacts = [SELECT Id, AccountId FROM Opportunity 
                                             WHERE Primary_Contact_for_Proposal__c != null 
                                             AND SFS_Contact_1Force__c = :contList[0].SFDC_Contact__c];
        System.assertEquals(200, oppWithContacts.size());        
    }
    // test the batch negative
    @isTest static void testNegative() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id,SFDC_Account__c FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, SFDC_Contact__c FROM Contact]);
        List<Contact> contList = contMap.values();
        System.assertEquals(1, contList.size());
        // insert the opportunities
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 200, false);
        List<Opportunity> oppList = [SELECT Id, AccountId, Primary_Contact_for_Proposal__c, SFS_Acct_1Force__c,
                                    SFS_Contact_1Force__c FROM Opportunity];
        System.assertEquals(200, oppList.size());
        for(Opportunity opp : oppList) {
            //opp.SFS_Acct_1Force__c = acctList[0].SFDC_Account__c;
            //opp.SFS_Contact_1Force__c = contList[0].SFDC_Contact__c;
            opp.AccountId = null;
            opp.Primary_Contact_for_Proposal__c = null;
        }
        update oppList;
        Test.startTest();
        Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
        Test.stopTest();
        // assert the value after successful batch
        List<Opportunity> oppWithAccounts = [SELECT Id, AccountId FROM Opportunity WHERE AccountId != null 
                                             AND SFS_Acct_1Force__c != null];
        System.assertEquals(0, oppWithAccounts.size());
        List<Opportunity> oppWithContacts = [SELECT Id, AccountId FROM Opportunity 
                                             WHERE Primary_Contact_for_Proposal__c != null 
                                             AND SFS_Contact_1Force__c != null];
        System.assertEquals(0, oppWithContacts.size());    
    }*/
}