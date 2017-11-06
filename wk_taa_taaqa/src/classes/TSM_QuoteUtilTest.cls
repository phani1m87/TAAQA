/*
 * test class for opportunity TSM_QuoteUtil class
 */
@isTest
public class TSM_QuoteUtilTest {
    // test data
    @testSetup static void dataPrep() {
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        config.SFS_Base_URL__c='https://wksfs--qa.cs61.my.salesforce.com';
        insert config;
        // insert the new accounts for data
        List<Account> accounts1 = TSM_TestDataUtil.createAccounts(1,1,0,true);
        //List<Account> accounts2 = TSM_TestDataUtil.createAccounts(1,1,1,false);
    }
    
    // test the QuoteUtil webservice method with steelbrick opportunity
    @isTest static void testQuoteUtilwithSteelbrick() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 1 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        List<Opportunity> opps = TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, true);
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity WHERE CPQ_Quote__c='Steelbrick'];
        Test.startTest();
        String result = TSM_QuoteUtil.loadOpportunity(oppsExt[0].Id);  
        Test.stopTest();
        // assert the label of returned message
        //System.assertEquals(System.Label.TSM_OpportunityProcessing, result);
    }
    // test the QuoteUtil webservice method without steelbrick opportunity    
    @isTest static void testQuoteUtilwithoutSteelbrick() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
       // System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 1 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        List<Opportunity> opps = TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, false);
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity WHERE CPQ_Quote__c != 'Steelbrick'];
        Test.startTest();
        String result = TSM_QuoteUtil.loadOpportunity(oppsExt[0].Id);  
        Test.stopTest();
        // assert the label of returned message
        //System.assertEquals(System.Label.TSM_SelectSteelbrick, result);
    }
    // test the webservice method with SFS opp Id
    @isTest static void testQuoteUtilwithSFSOppId() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 1 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        List<Opportunity> opps = TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, false);
        List<Opportunity> updOppList = new List<Opportunity>();
        for(Opportunity opp: [SELECT Id, CPQ_Quote__c, SFS_Opportunity_ID__c 
                              FROM Opportunity WHERE CPQ_Quote__c = 'Steelbrick']) {
            opp.CPQ_Quote__c ='SteelBrick'; // for testing the else scenario
            updOppList.add(opp);
        }        
        update updOppList;
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();        
        
        // assert the contact record is created
        List<Opportunity> oppsExt = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity];
        Test.startTest();
        String result = TSM_QuoteUtil.loadOpportunity(oppsExt[0].Id);        
        Test.stopTest();
        // assert the label of returned message        
        //System.assertEquals(false, result.contains(tsmCS.SFS_Base_URL__c)); // this scenario won't be possible with mock test
        //System.assertEquals(true, result.contains(oppsExt[0].SFS_Opportunity_ID__c));
    }    
    
}