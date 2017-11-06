/*
 * One time batch process to establish the lookup relationship for replicated opportunities from SFS to TAA
 * Prerequisite: SFS batch must be completed before TAA batch run. 
 * Please ensure the same batch is completed in SFS org.
 * START Batch: using Developer Console - Execute anonymous: 
 *                      Database.executeBatch(new TSM_OneTimeOpportunitySyncBatch());
 * 
 * */
public class TSM_OneTimeOpportunitySyncBatch { /*
public class TSM_OneTimeOpportunitySyncBatch implements Database.Batchable<sObject> { 
    public TSM_OneTimeOpportunitySyncBatch() {
        
    }
    // need to fetch the respective opportunities which must be replicated from SFS to TAA
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // unable to test the scenario using mock data for PNRC related fields i.e.ConnectionReceivedId
        if(Test.isRunningTest()) 
            return Database.getQueryLocator([SELECT Id, AccountId, Primary_Contact_for_Proposal__c, SFS_Acct_1Force__c,
                                             SFS_Contact_1Force__c FROM Opportunity]);
        else
            return Database.getQueryLocator([SELECT Id, AccountId, Primary_Contact_for_Proposal__c, SFS_Acct_1Force__c,
                                             SFS_Contact_1Force__c FROM Opportunity 
                                             WHERE ConnectionReceivedId != null AND
                                            AccountId = null AND Primary_Contact_for_Proposal__c = null]);        
    }   

    // process the selected opportunities
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        Set<String> acct1ForceIds = new Set<String>();
        Set<String> cont1ForceIds = new Set<String>();
        Map<String, Account> acctMap = new Map<String, Account>();
        Map<String, Contact> contMap = new Map<String, Contact>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Opportunity> oppBatch = (List<Opportunity>) scope;
        // identify the respective text account and contact ids from SFS opportunity
        for(Opportunity opp: oppBatch) {
            if(opp.AccountId == null && opp.SFS_Acct_1Force__c != null) { 
                // need to identify the SHARED accounts
                acct1ForceIds.add(opp.SFS_Acct_1Force__c);
            }
            if(opp.Primary_Contact_for_Proposal__c == null && opp.SFS_Contact_1Force__c != null) { 
                // need to add && other field to identify the SHARED conts
                cont1ForceIds.add(opp.SFS_Contact_1Force__c);    
            }
        }
        // fetch the accounts with 1force/sfdc #
        for(Account acct: [SELECT Id, SFDC_Account__c FROM Account 
                           WHERE SFDC_Account__c IN : acct1ForceIds]) {
            acctMap.put(acct.SFDC_Account__c, acct);    
        }
        // fetch the contacts with 1force/sfdc#
        for(Contact cont: [SELECT Id, SFDC_Contact__c FROM Contact 
                           WHERE SFDC_Contact__c IN : cont1ForceIds]) {
            contMap.put(cont.SFDC_Contact__c, cont);    
        }
        // remap the lookup fields for the matched accounts and contacts
        for(Opportunity opp: oppBatch) {
            if(opp.AccountId == null && opp.SFS_Acct_1Force__c != null) { 
                // fetch the account id by using the respective oppty 1force/sfdc field
                if(acctMap.containsKey(opp.SFS_Acct_1Force__c)) 
                    opp.AccountId = acctMap.get(opp.SFS_Acct_1Force__c).Id;
            }
            if(opp.Primary_Contact_for_Proposal__c == null && opp.SFS_Contact_1Force__c != null) { 
                // fetch the contact id by using the respective oppty 1force/sfdc field
                if(contMap.containsKey(opp.SFS_Contact_1Force__c)) 
                    opp.Primary_Contact_for_Proposal__c = contMap.get(opp.SFS_Contact_1Force__c).Id;
            }
            oppsToUpdate.add(opp);
        }
        if(!oppsToUpdate.isEmpty())
            Database.update(oppsToUpdate, false);
    }
    
    public void finish(Database.BatchableContext bc) {
        // finish to start the next batch               
    }  */      
}