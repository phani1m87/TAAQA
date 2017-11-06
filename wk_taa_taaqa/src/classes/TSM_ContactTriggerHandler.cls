/*
 * trigger handler class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj				1.0			Initial draft
 * ------------------------------------------------------------------------- */
public class TSM_ContactTriggerHandler {
    public static void onAfterInsert(List<Contact> newRecords) {
        TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();		
        Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
        List<PartnerNetworkRecordConnection> newContShrList = new List<PartnerNetworkRecordConnection>();
		Map<Id, PartnerNetworkRecordConnection> acctShrMap = new Map<Id, PartnerNetworkRecordConnection>();                
        Map<Id, PartnerNetworkRecordConnection> contShrMap = new Map<Id, PartnerNetworkRecordConnection>();                
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Set<Id> acctIds = new Set<Id>();
        Map<Id, Account> acctMap = new Map<Id, Account>();
        // preparing the list of account ids
        for(Contact con: newRecords) {
            if(con.ConnectionReceivedId == null && con.SFS_Contact_Record_Id__c == null && con.AccountId != null) {
            	acctIds.add(con.AccountId);
            }
        }
        // fetch the parent accounts of SFS by using account segment and subsegment attributes
        for(Account acct: [SELECT Id, Market_Segment__c, Market_Sub_Segment__c FROM Account WHERE Id IN :acctIds
                          AND Market_Segment__c IN :TSM_Util.getAccountSegments().keySet()]) {
            if(acct.Market_Segment__c == 'Legal Professionals' && acct.Market_Sub_Segment__c != null &&
                      (acct.Market_Sub_Segment__c == 'Law Firm 1-3 Attorneys' || acct.Market_Sub_Segment__c == 'Law Firms (Size TBD)')) {
                    	acctMap.put(acct.Id, acct);   
            } else if (acct.Market_Segment__c != 'Legal Professionals' && acct.Market_Sub_Segment__c != null && 
                       // for segment = other 3 types
                       (acct.Market_Sub_Segment__c == 'Sole Proprietor' || 
                        acct.Market_Sub_Segment__c == '2-4 Total Employees' || 
                        acct.Market_Sub_Segment__c == 'Size TBD')) {
                        acctMap.put(acct.Id, acct);
            }
        }
        // for identifying the contacts which must be replicated thru SFS
        for(Contact con: newRecords) {
            if(con.ConnectionReceivedId == null && con.SFS_Contact_Record_Id__c == null &&
               con.AccountId != null && acctMap.containsKey(con.AccountId)) {
            	contactMap.put(con.Id, con);
            }
        }
        // for fetching the existing shares of respective contacts
        contShrMap = TSM_Util.fetchExistingShares(contactMap.keySet(), networkId); 
        // for fetching the existing shares of respective accounts
        //acctShrMap = TSM_Util.fetchExistingShares(acctMap.keySet(), networkId);
        // for comparing the share entries with new contacts
        for(Contact con: contactMap.values()) {
            if(!contShrMap.containsKey(con.Id)) {
                newContShrList.add(TSM_Util.prepareShare(con.Id, networkId, null));
                /*
                if(con.AccountId != null  && acctShrMap.containsKey(con.AccountId)) 
                    // for respective account PNRC entries are active
                	newContShrList.add(TSM_Util.prepareShare(con.Id, networkId, con.AccountId)); 
                else 
                    // for respective account PNRC entries are inactive
                    newContShrList.add(TSM_Util.prepareShare(con.Id, networkId, null));
				*/
            } 
        }
        
        // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
        //TSM_Util.insertShares(newContShrList, 'TSM_ContactTrigger','Trigger');
        
        // insert the new shares bulk
        // SMS - 752 :InsertShares method is replaced by insertSharesObject which is Returning IDs of pertnerNetworkRecordConnection.
        List<String> contactShareObjectListIds = TSM_Util.insertSharesObject(newContShrList, 'TSM_OpportunityTrigger', 'Trigger');
        if(contactShareObjectListIds.size()>0){
        	TSM_Util.insertReplicationMonitoringLog(contactShareObjectListIds,'Contact');
        } 
        //SMS -752 :End
    }
}