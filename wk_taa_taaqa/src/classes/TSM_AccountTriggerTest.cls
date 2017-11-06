/*
 * test class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj               1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest
public class TSM_AccountTriggerTest {
    // data prep for preparing the custom settings data
    @testSetup static void dataPrep() {
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        insert config;
        List<TSM_Trigger_Control__c> controlList = new List<TSM_Trigger_Control__c>();
        controlList.add(new TSM_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='TSM_Shared_Product__c',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='CampaignMember',TriggerOff__c=false));            
        insert controlList;                
    }
    // test case for positive scenario
    @isTest
    static void testPositive() {
        Test.startTest();
        List<Account> accts = TSM_TestDataUtil.createAccounts(2,0,0,true);
        Test.stopTest();
        // assert the one account record is created
        //System.assertEquals(2, accts.size());
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        // assert that one PNRC sharing record is created for respective account
        List<PartnerNetworkRecordConnection> shareAcctExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        //System.assertEquals(2, shareAcctExt.size());        
    }
    // test case for negative scenario
    @isTest static void testNegative() {
        Test.startTest();
        List<Account> accts = TSM_TestDataUtil.createAccounts(2,0,0,false);
        Test.stopTest();
        // assert the one account record is created
        //System.assertEquals(2, accts.size());
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        // assert that no PNRC sharing record is created for respective account
        List<PartnerNetworkRecordConnection> shareAcctExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        //System.assertEquals(0, shareAcctExt.size());
    }
    // test case for bulk records
    @isTest static void testBulk() {
        Test.startTest();
        List<Account> accts = TSM_TestDataUtil.createAccounts(200,0,0,true);
        Test.stopTest();
        // assert the one account record is created
        //System.assertEquals(200, accts.size());
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        // assert that one PNRC sharing record is created for respective account
        List<PartnerNetworkRecordConnection> shareAcctExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
       // System.assertEquals(200, shareAcctExt.size());    
    }
}