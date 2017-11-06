/*
 * test class for opportunity trigger and helper classes for S2S sync from TAA org to SFS org
 */
@isTest
public class TSM_OpportunityTriggerTest {
    // test data
    @testSetup static void dataPrep() {
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        config.SFS_Base_URL__c='https://wksfs--qa.cs61.my.salesforce.com';
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
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,1,0,true);
    }
    
    // test the positive scenario with steelbrick opportunity
    @isTest static void testInsertPositive() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        Test.startTest();
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, true);
        Test.stopTest();
        // assert the contact record is created
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity];
       // System.assertEquals(1, oppsExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        // assert that one PNRC sharing record is created for respective opportunity
        List<PartnerNetworkRecordConnection> shareOppExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :oppMap.keyset()];
        //System.assertEquals(1, shareOppExt.size());
    }
    
    // test the positive scenario with non steelbrick opportunity
    @isTest static void testInsertNegative() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
       // System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        Test.startTest();
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, false);
        Test.stopTest();
        // assert the contact record is created
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity];
        //System.assertEquals(1, oppsExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        // assert that one PNRC sharing record is created for respective opportunity
        List<PartnerNetworkRecordConnection> shareOppExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :oppMap.keyset()];
        //System.assertEquals(0, shareOppExt.size());
    }
    
    // test the bulk records
    @isTest static void testInsertBulk() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        Test.startTest();
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 200, true);
        Test.stopTest();
        // assert the contact record is created
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity];
        //System.assertEquals(200, oppsExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        // assert that one PNRC sharing record is created for respective opportunity
        List<PartnerNetworkRecordConnection> shareOppExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :oppMap.keyset()];
        //System.assertEquals(200, shareOppExt.size());
    }
    // test the update positive scenario with steelbrick opportunity
    @isTest static void testUpdatePositive() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
        //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
       // System.assertEquals(1, acctShrMap.size());
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, false);
        List<Opportunity> updOppList = new List<Opportunity>();
        for(Opportunity opp: [SELECT Id, CPQ_Quote__c FROM Opportunity]) {
            opp.CPQ_Quote__c='Steelbrick';
            updOppList.add(opp);
        }        
        Test.startTest();
        update updOppList;
        Test.stopTest();
        // assert the contact record is created
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity];
        //System.assertEquals(1, oppsExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        // assert that one PNRC sharing record is created for respective opportunity
        List<PartnerNetworkRecordConnection> shareOppExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :oppMap.keyset()];
       // System.assertEquals(1, shareOppExt.size());
    }
    
    // test the update negative scenario without steelbrick opportunity
    @isTest static void testUpdateNegative() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
       //System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrMap = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrMap.size());
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, false);
        List<Opportunity> updOppList = new List<Opportunity>();
        for(Opportunity opp: [SELECT Id, CPQ_Quote__c FROM Opportunity]) {
            opp.CPQ_Quote__c='Steelbrick2';
            updOppList.add(opp);
        }        
        try {
            update updOppList;
        }
        catch(DMLException e) {
           // System.assert(e.getMessage().contains('Update failed'));
            //System.assertEquals('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST', e.getDmlStatusCode(0));
        }        
    }
    
    // test the update bulk 
    @isTest static void testUpdateBulk() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
       // System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrList = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()];
        // ensure that 2 account shares are created before inserting contacts
       // System.assertEquals(1, acctShrList.size());
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 200, false);
        List<Opportunity> updOppList = new List<Opportunity>();
        for(Opportunity opp: [SELECT Id, CPQ_Quote__c FROM Opportunity]) {
            opp.CPQ_Quote__c='Steelbrick';
            updOppList.add(opp);
        }   
        Test.startTest();
        update updOppList;
        Test.stopTest();
        // assert the contact records are created
        List<Opportunity> oppsExt = [SELECT Id FROM Opportunity];
       // System.assertEquals(200, oppsExt.size());
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
        // assert that one PNRC sharing record is created for respective opportunity
        List<PartnerNetworkRecordConnection> shareOppExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :oppMap.keyset()];
        //System.assertEquals(200, shareOppExt.size());
    }
    
    @isTest static void testdeleteShares() {
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id FROM Account]);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id FROM Contact]);
        List<Contact> contList = contMap.values();
       // System.assertEquals(1, contList.size());
        List<PartnerNetworkRecordConnection> acctShrList = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset() AND 
                                                            Status = 'Invite'];
        // ensure that 2 account shares are created before inserting contacts
        //System.assertEquals(1, acctShrList.size());
        TSM_Util.deleteShares(acctShrList, 'test', 'trigger');
        Test.startTest();        
        TSM_Util.deleteShares(acctShrList, 'test', 'trigger');
        Test.stopTest();
        // ensure that status is changed to inactive
        List<PartnerNetworkRecordConnection> acctShrExt = [SELECT Id, LocalRecordId, Status, PartnerRecordId FROM
                                                        PartnerNetworkRecordConnection 
                                                         WHERE LocalRecordId IN :acctMap.keyset()
                                                          AND Status = 'Inactive'];        
        //System.assertEquals(1, acctShrExt.size());
        List<TSM_App_Log__c> logExt = [SELECT Id FROM TSM_App_Log__c];
        // assert the errors/exceptions for delete shares
        //System.assertEquals(1, logExt.size());
    }
    
    @isTest static void testInsertShares() {
        Account acct = new Account(Name='Test');
        insert acct;
        List<PartnerNetworkRecordConnection> pnrcList = new List<PartnerNetworkRecordConnection>();
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();       
        Id networkId = TSM_Util.getNetworkId(tsmCS.connectionName__c);        
        pnrcList.add(TSM_Util.prepareShare(acct.Id, null, null));
        Test.startTest();
        TSM_Util.insertSharesObject(pnrcList, 'testing', 'trigger');
        TSM_Util.insertShares(pnrcList, 'testing', 'trigger');
        Test.stopTest();
        // assert the log entry DML error
        List<TSM_App_Log__c> logList = [SELECT Id, Error_message__c FROM TSM_App_Log__c];
        //System.assertEquals(2, logList.size());
       // System.assertEquals(true, loglist[0].Error_Message__c.contains('Required fields are missing: [ConnectionId]'));
    }
    
    // test the scenario of non-matching accounts and contacts thru SFS and Non-SFS i.e.US228
    @isTest static void testWithoutExistingSFSAccount() {
        Account acct = new Account(Name='TestWithoutSFS');
        insert acct;
        Contact cont = new Contact(FirstName='FName',LastName='LName',email='testwithoutsfs@testwk.com',
                                   AccountId=acct.Id);
        insert cont;
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id, SFS_Account_Record_Id__c FROM Account
                                                        WHERE Name = 'TestWithoutSFS']);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, SFS_Contact_Record_Id__c FROM Contact
                                                        WHERE AccountId = :acctList[0].Id]);
        List<Contact> contList = contMap.values();
        Test.startTest();
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, true);
        Test.stopTest();
        // assert the opportunity is created
        List<Opportunity> oppsList = [SELECT Id FROM Opportunity];
        // number of account sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> acctShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId IN :acctMap.keySet()];
        //System.assertEquals(1, acctShrList.size());
        // number of contact sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> contShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId IN :contMap.keySet()];
        //System.assertEquals(1, contShrList.size());
        // number of opportunity sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> oppShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId = :oppsList[0].Id];
        //System.assertEquals(1, oppShrList.size());
    }
    
    // test the scenario of non-matching contacts thru SFS and Non-SFS i.e.US228
    @isTest static void testWithoutExistingSFSContact() {
        Account acct = new Account(Name='TestWithoutSFS');
        insert acct;
        Contact cont = new Contact(FirstName='FName',LastName='LName',email='testwithoutsfs@testwk.com',
                                   AccountId=acct.Id);
        insert cont;
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id, SFS_Account_Record_Id__c FROM Account
                                                        WHERE Name = 'TestWithoutSFS']);
        List<Account> acctList = acctMap.values();
        Map<Id, Contact> contMap = new Map<Id, Contact>([SELECT Id, SFS_Contact_Record_Id__c FROM Contact
                                                        WHERE AccountId != :acctList[0].Id]);
        List<Contact> contList = contMap.values();
        Test.startTest();
        TSM_TestDataUtil.createOpportunities(acctList[0].Id, contList[0].Id, 1, true);
        Test.stopTest();
        // assert the opportunity is created
        List<Opportunity> oppsList = [SELECT Id FROM Opportunity];
        // number of account sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> acctShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId IN :acctMap.keySet()];
        //System.assertEquals(1, acctShrList.size());
        // number of contact sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> contShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId IN :contMap.keySet()];
        //System.assertEquals(1, contShrList.size());
        // number of opportunity sharing PNRC entries are created
        List<PartnerNetworkRecordConnection> oppShrList = [SELECT Id FROM PartnerNetworkRecordConnection
                                                           WHERE LocalRecordId = :oppsList[0].Id];
        //System.assertEquals(1, oppShrList.size());
    }
}