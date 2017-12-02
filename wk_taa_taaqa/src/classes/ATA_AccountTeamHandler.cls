/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
global with sharing class ATA_AccountTeamHandler 
{
	//***** This class works as delegator for Account Team Automation functionality
	public static List<Monitoring_Log__c> lstGlobalMonitoringLog = new List<Monitoring_Log__c>();
	
	public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap, Boolean isDeleteExistingNRecreate)
	{
		String excludeRecordTypeId; 	// recordTypeId to exclude
		
		// read record type to be exluded and find recordTypeId
		if(ATA_Utility.ATACustomSettings() != NULL && String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
		{
        	if(String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
			{
				excludeRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c).getRecordTypeId();
			} // end if
      	} // end if
		
		// filter out the accounts with record type to be excluded
		if(String.isNotBlank(excludeRecordTypeId))
		{      	
			for(Id accountId : newMap.keySet())
			{
				if(newMap.get(accountId).RecordTypeId == excludeRecordTypeId){
					newMap.remove(accountId);
					// check if it is also in oldMap and remove
					if(oldMap != NULL && oldMap.containsKey(accountId)){
						oldMap.remove(accountId);
					} // end if
				} // end if	
			} // end for
		} // end if
		
		// #### COMPOSE ACCOUNT TEAM
		// **** pass the newMap and oldMap to ATA_ComposeAccountTeam		
		ATA_ComposeAccountTeam obj = new ATA_ComposeAccountTeam(newMap, oldMap);
		
		// **** this method delegates the tasks and gathers returned information
		Map<Id, List<AccountTeamMember>> accountNRuleDerivedAccountTeamMap = ATA_ComposeAccountTeam.composeAccountTeam();
		
		// **** read all monitoring logs that accumulated during compose account team		
		lstGlobalMonitoringLog.addAll(ATA_ComposeAccountTeam.lstMonitoringLog);
		ATA_ComposeAccountTeam.lstMonitoringLog.clear();
		
		if(accountNRuleDerivedAccountTeamMap != NULL && accountNRuleDerivedAccountTeamMap.size() > 0)
		{
			// #### CURRENT ACCOUNT TEAM
			// **** gets the current / existing Account Teams for the accounts
			Map<Id, List<AccountTeamMember>> accountNCurrentAccountTeamMap = ATA_CurrentAccountTeam.getCurrentAccountTeam(newMap.keySet());
			
			// #### POST ACCOUNT TEAM
			// **** set flag if delete all & recreate
			ATA_PostAccountTeam.isDeleteExistingNRecreate = isDeleteExistingNRecreate;
			
			// **** compare existing and derived account team and perform appropriate DML (insert / delete)
			List<Monitoring_Log__c> lstMonitoringLog = ATA_PostAccountTeam.constructAccountTeam(accountNCurrentAccountTeamMap, accountNRuleDerivedAccountTeamMap);
			
			if(lstMonitoringLog != NULL){
				lstGlobalMonitoringLog.addAll(lstMonitoringLog);
			}
		}
		
		if(lstGlobalMonitoringLog.size() > 0)
		{
			Database.SaveResult[] saveResults = Database.insert(lstGlobalMonitoringLog, false);
			
			// **** DML error handling ***** //
		}
	}
	
	webservice static void reCreateAccountTeamInteractive(String accountId)
	{
		Map<Id, Account> mapAccountIdNAccount = new Map<Id, Account>([SELECT Id, RecordTypeId FROM Account WHERE Id =: accountId]);
		
		if(mapAccountIdNAccount != NULL && mapAccountIdNAccount.size() > 0){
			generateAccountTeam(mapAccountIdNAccount, null, true);	
		}
	}    
}