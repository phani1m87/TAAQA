/*
 * trigger handler class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj               1.0         Initial draft
 * 12/15/2016 Raj               1.1         updated for story US228 
 * ------------------------------------------------------------------------- */
public class TSM_OpportunityTriggerHandler {
    // processing logic for insert operation
    public static void onAfterInsert(List<Opportunity> newRecords) {
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        // identify the required opportunity records meet the criteria
        for(Opportunity opp: newRecords) {
        
        system.debug('Before if loop'+opp);
            if( opp.CPQ_Quote__c != null && opp.CPQ_Quote__c.equalsIgnoreCase('SteelBrick') &&
               opp.ConnectionReceivedId == null) {
                oppList.add(opp);
                oppMap.put(opp.id, opp);
                system.debug('After If loop'+opp);
            }
        }
        if(!oppList.isEmpty()) {
        
            system.debug('List is not empty'+oppList);
            TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();        
            Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);   
                 system.debug('ConnectionNetwork Id'+networkId );
            processRecords(networkId, oppMap, false);
        }
    }
    // processing logic for update operation
    public static void onAfterUpdate(List<Opportunity> newRecords, Map<Id, Opportunity> oldRecordsMap) {
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        // identify the required records meet criteria
        for(Opportunity opp: newRecords) {
            if(opp.CPQ_Quote__c != null &&
                opp.CPQ_Quote__c.equalsIgnoreCase('SteelBrick') &&
               oldRecordsMap.get(opp.Id).CPQ_Quote__c != opp.CPQ_Quote__c &&
               //!oldRecordsMap.get(opp.Id).CPQ_Quote__c.equalsIgnoreCase('SteelBrick') &&
               opp.ConnectionReceivedId == null) {
                    oppList.add(opp);    
                    oppMap.put(opp.id, opp);
               }               
        }
        if(!oppList.isEmpty()) {
            TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();        
            Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
            processRecords(networkId, oppMap, true);
        }
    }
    // processing logic to process the records for both insert and update operations
    public static void processRecords(Id networkId, Map<Id, Opportunity> oppMap, Boolean isUpdate) {
        Map<Id, PartnerNetworkRecordConnection> opptyShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        system.debug('===mapp==>'+opptyShrMap);
        List<Opportunity> oppList = new List<Opportunity>();
        if(isUpdate == true) {
            opptyShrMap = TSM_Util.fetchExistingShares(oppMap.keySet(), networkId);
            // compare the existing opportunity shares to prepare the list of opportunities for new sharing records
            for(Opportunity opp: oppMap.values()) {
                if(!opptyShrMap.containsKey(opp.Id))
                    oppList.add(opp);
            }
            processSelectedRecords(networkId, oppList);
        } else {
            processSelectedRecords(networkId, oppMap.values());
        }
    }     
    // the generic method to process selected records 
    public static void processSelectedRecords(Id networkId, List<Opportunity> objRecords) {
        Set<Id> acctIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        List<Opportunity> oppList = new List<Opportunity>(); 
        List<Opportunity> oppContactList = new List<Opportunity>();
        
         system.debug('Selected Records'+networkId+objRecords );
         
        for(Opportunity opp: objRecords) {
            if(opp.AccountId != null) {
                oppList.add(opp);
                acctIdSet.add(opp.AccountId);
            }   
            if(opp.Primary_Contact_for_Proposal__c != null) {
                contactIdSet.add(opp.Primary_Contact_for_Proposal__c);
                oppContactList.add(opp);
            }
        }
        // for preparing the list of accounts of respective contacts
        Map<Id, Id> contToAcctMap = new Map<Id, Id>();
        for(Contact con: [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIdSet]) {
            contToAcctMap.put(con.Id, con.AccountId);
            acctIdSet.add(con.AccountId);
        }
        // for capturing existing accounts shared thru SFS
        Map<Id, PartnerNetworkRecordConnection> acctShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        acctShrMap = TSM_Util.fetchExistingShares(acctIdset, networkId);
        // for capturing existing contacts shared thru SFS
        Map<Id, PartnerNetworkRecordConnection> contShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        contShrMap = TSM_Util.fetchExistingShares(contactIdSet, networkId);
        
        // for identifying the accounts which are shared between 2 orgs using Non-SFS
        Map<Id, Account> existingAcctsMap = new Map<Id, Account>([SELECT Id FROM Account 
                                                                  WHERE Id IN :acctIdset 
                                                                  //AND SFDC_Account__c != null
                                                                  AND SFS_Account_Record_Id__c != null 
                                                                 ]);
        // for identifying the contacts which are shared between 2 orgs using Non-SFS
        Map<Id, Contact> existingContsMap = new Map<Id, Contact>([SELECT Id FROM Contact 
                                                                  WHERE Id IN :contactIdset 
                                                                  //AND SFDC_Contact__c != null
                                                                  AND SFS_Contact_Record_Id__c != null
                                                                 ]);
        //to prepare the new list of sharing records
        List<PartnerNetworkRecordConnection> newOpptyShrList = new List<PartnerNetworkRecordConnection>();
        List<PartnerNetworkRecordConnection> newContShrList = new List<PartnerNetworkRecordConnection>();
        List<PartnerNetworkRecordConnection> newAcctShrList = new List<PartnerNetworkRecordConnection>();
        Map<Id, Id> addedShrMap = new Map<Id, Id>();
        //compare them to prepare the  opportunity and account sharing entries
        for(Opportunity opp: oppList) {
            // prepare the respective opportunity sharing record entry 
            //this is to resolve the invalid partner network status error by make the parentrecordid=null
            //Fix for SMS-717 
            if(acctShrMap.containsKey(opp.AccountId) /*&& 
                    (acctShrMap.get(opp.AccountId).status.equalsIgnoreCase('Sent') || acctShrMap.get(opp.AccountId).status.equalsIgnoreCase('Inactive'))*/) {
                //newOpptyShrList.add(TSM_Util.prepareShare(opp.Id, networkId, opp.AccountId)); 
                // Set ParentRecordId null to prevent Dups (Side-effect of stop sharing)  
                newOpptyShrList.add(TSM_Util.prepareShare(opp.Id, networkId, null));
            } else {
                // if the accounts are matched with existing matching thru  non SFS
                if(!existingAcctsMap.containsKey(opp.AccountId)){
                    // insert the account share entry because it was not shared thru non SFS and SFS
                    newAcctShrList.add(TSM_Util.prepareShare(opp.AccountId, networkId, null));
                    addedShrMap.put(opp.AccountId, opp.AccountId);
                }
                newOpptyShrList.add(TSM_Util.prepareShare(opp.Id, networkId, null));
            }            
        }
        
        // compare the existing contacts for creating new account & contact sharing entries
        for(Opportunity opp: oppContactList) {
            // compare it with existing contacts shared thru SFS and non-SFS
            if(!contShrMap.containsKey(opp.Primary_Contact_for_Proposal__c)) {
                // compare it with existing contacts shared thru non SFS
                if(!existingContsMap.containsKey(opp.Primary_Contact_for_Proposal__c)) {
                    newContShrList.add(TSM_Util.prepareShare(opp.Primary_Contact_for_Proposal__c, networkId, null));
                }
            }
            // compare with existing accounts (of contacts ) shared thru SFS and non-SFS
            Id accountId = contToAcctMap.get(opp.Primary_Contact_for_Proposal__c);
            if(!acctShrMap.containsKey(accountId)) {
                if(!existingAcctsMap.containsKey(accountId)) {
                    if(!addedShrMap.containsKey(accountId)) {
                        // prepare the respective account share of the contacts
                        newAcctShrList.add(TSM_Util.prepareShare(accountId, networkId, null));
                    }
                }
            }            
        } 
        
       
        // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
        // TSM_Util.insertShares(newAcctShrList, 'TSM_OpportunityTrigger', 'Trigger');
        
        // insert the account sharing records
        // SMS - 752 :InsertShares method is replaced by insertSharesObject which is Returning IDs of pertnerNetworkRecordConnection.
        List<String> accountShareObjectListIds = TSM_Util.insertSharesObject(newAcctShrList, 'TSM_OpportunityTrigger', 'Trigger');
        if(accountShareObjectListIds.size()>0){
            TSM_Util.insertReplicationMonitoringLog(accountShareObjectListIds,'Account');
        } 
        
        
        // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
        // TSM_Util.insertShares(newContShrList, 'TSM_OpportunityTrigger', 'Trigger');
        
        // insert the contact sharing records
        // SMS - 752 :InsertShares method is replaced by insertSharesObject which is Returning IDs of pertnerNetworkRecordConnection.
        List<String> contactShareObjectListIds = TSM_Util.insertSharesObject(newContShrList, 'TSM_OpportunityTrigger', 'Trigger');
        if(contactShareObjectListIds.size()>0){
            TSM_Util.insertReplicationMonitoringLog(contactShareObjectListIds,'Contact');
        } 
        
       
       // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
       // TSM_Util.insertShares(newOpptyShrList, 'TSM_OpportunityTrigger','Trigger');
       
        // insert the new opportunity sharing records
        // SMS - 752 :InsertShares method is replaced by insertSharesObject which is Returning IDs of pertnerNetworkRecordConnection.
        List<String> oppShareObjectListIds = TSM_Util.insertSharesObject(newOpptyShrList, 'TSM_OpportunityTrigger','Trigger');
        if(oppShareObjectListIds.size()>0){
            TSM_Util.insertReplicationMonitoringLog(oppShareObjectListIds,'Opportunity'); 
        }   
    }    
}