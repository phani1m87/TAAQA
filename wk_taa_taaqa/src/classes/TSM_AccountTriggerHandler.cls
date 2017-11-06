/*
 * trigger handler class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj				1.0			Initial draft
 * ------------------------------------------------------------------------- */
public class TSM_AccountTriggerHandler {
	// for after insert operation
    public static void onAfterInsert(List<Account> newRecords) {
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();		
        Id networkId = TSM_Util.getNetworkId(tsmCS.ConnectionName__c);        
        List<PartnerNetworkRecordConnection> newAcctShrList = new List<PartnerNetworkRecordConnection>();
		Map<Id, PartnerNetworkRecordConnection> acctShrMap = new Map<Id, PartnerNetworkRecordConnection>();                
        Map<Id, Account> acctMap = new Map<Id, Account>();
        Map<String, String> segmentMap = TSM_Util.getAccountSegments();
		// identify the accounts by using segment and sub segment for SFS sharing        
        for(Account acct: newRecords) {
            if(acct.ConnectionReceivedId == null && acct.SFS_Account_Record_Id__c == null &&
               acct.Market_Segment__c != null &&
              	segmentMap.containsKey(acct.Market_Segment__c)) {
                    // for segment=legal professional 
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
        }
        // fetch the existing shares
        acctShrMap = TSM_Util.fetchExistingShares(acctMap.keySet(), networkId);  
        // compare them with the existing shares for preparing new shares
        for(Account a: acctMap.values()) {
            if(!acctShrMap.containsKey(a.Id)) {
                newAcctShrList.add(TSM_Util.prepareShare(a.Id, networkId, null));                
            }
        }
        
   
        // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
        //TSM_Util.insertShares(newAcctShrList,'TSM_AccountTrigger','Trigger');
        
        // insert the new shares bulk
        // SMS - 752 :InsertShares method is replaced by insertSharesObject which is Returning IDs of pertnerNetworkRecordConnection.
        List<String> accountShareObjectListIds = TSM_Util.insertSharesObject(newAcctShrList,'TSM_AccountTrigger','Trigger');
        if(accountShareObjectListIds.size()>0){
        	TSM_Util.insertReplicationMonitoringLog(accountShareObjectListIds,'Account');
        } 
       
        
        // below logic to unshare the record after successful completion of sharing.
        //updateAccountShares(acctMap.keySet(), networkId);
    }
    
}