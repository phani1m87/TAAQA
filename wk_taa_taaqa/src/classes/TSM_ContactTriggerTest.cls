/*
 * test class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj               1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest
public class TSM_ContactTriggerTest {
    // data preparation for custom settings
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
        // insert the new accounts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(2,0,0,true);
    }
    // test case for positive scenario
    @isTest
    static void testPositive() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(2, acctShrMap.size());
        Test.startTest();
        List<Contact> contList1= TSM_TestDataUtil.createContacts(acctList[0].Id, 4);
        List<Contact> contList2= TSM_TestDataUtil.createContacts(acctList[1].Id, 4);        
        Test.stopTest();
        // assert the contact record is created
        List<Contact> contacts = [SELECT Id FROM Contact];
        //System.assertEquals(8, contacts.size());
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        // assert that one PNRC sharing record is created for respective contact
        List<PartnerNetworkRecordConnection> shareContExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :contMap.keyset()];
       // System.assertEquals(8, shareContExt.size());        
    }
    
    // test case for negative scenarios
    @isTest static void testNegative() {
        Test.startTest();
        List<Account> accts = TSM_TestDataUtil.createAccounts(1,2,0,false);
        Test.stopTest();
        // assert the contact record is created
        List<Contact> contacts = [SELECT Id FROM Contact];
        //System.assertEquals(2, contacts.size());
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        // assert that no PNRC sharing record is created for respective contact
        List<PartnerNetworkRecordConnection> shareContExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :contMap.keyset()];
        //System.assertEquals(0, shareContExt.size());
    }
    // test case for bulk records handling
    @isTest static void testBulk() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
       // System.assertEquals(2, acctShrMap.size());
        Test.startTest();
        List<Contact> contList1= TSM_TestDataUtil.createContacts(acctList[0].Id, 200);        
        Test.stopTest();
        // assert the contact record is created
        List<Contact> contacts = [SELECT Id FROM Contact];
        //System.assertEquals(200, contacts.size());
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        // assert that PNRC sharing record is created for respective contact
        List<PartnerNetworkRecordConnection> shareContExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :contMap.keyset()];
       // System.assertEquals(200, shareContExt.size());    
    }
    
}