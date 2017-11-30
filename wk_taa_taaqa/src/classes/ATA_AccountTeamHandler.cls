/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
global with sharing class ATA_AccountTeamHandler 
{
	//***** This class works as delegator for Account Team Automation functionality
	
	public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap, Boolean isDeleteExistingNRecreate)
	{
		String excludeRecordTypeId; 	// recordTypeId to exclude
		
		// read record type to be exluded and find recordTypeId
		if(UtilCustomSettings.TAACustomSetting() != NULL && String.isNotBlank(UtilCustomSettings.TAACustomSetting().ATA_ExcludeAccountRecordType__c))
		{
        	if(String.isNotBlank(UtilCustomSettings.TAACustomSetting().ATA_ExcludeAccountRecordType__c))
			{
				excludeRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilCustomSettings.TAACustomSetting().ATA_ExcludeAccountRecordType__c).getRecordTypeId();
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
		
		// **** this method delegates the tasks and gathers returned information
		ATA_ComposeAccountTeam obj = new ATA_ComposeAccountTeam(newMap, oldMap);
		
		// **** get the valid assignment type (internally gets ATA_Rule__c, computes the assignment types and returns)
		Map<Id, Set<String>> validAssignmnentTypesMap = ATA_ComposeAccountTeam.getAssignmentTypes(ATA_ComposeAccountTeam.createAccountRoleValueMap());
		
		// **** get the map of AccountId and associated rule derived Account Teams (internally computes role and then forms the AccountTeamMember based on Geo / Non-geo mechanism)
		Map<Id, List<AccountTeamMember>> accountNRuleDerivedAccountTeamMap = ATA_ComposeAccountTeam.getListAccountTeamMembers(validAssignmnentTypesMap);
		
		// **** gets the current / existing Account Teams for the accounts
		Map<Id, List<AccountTeamMember>> accountNCurrentAccountTeamMap = ATA_CurrentAccountTeam.getCurrentAccountTeam(newMap.keySet());
		
		ATA_PostAccountTeam.isDeleteExistingNRecreate = isDeleteExistingNRecreate;
		
		// **** compare existing and derived account team and perform appropriate DML (insert / delete)
		List<Monitoring_Log__c> lstMonitoringLog = ATA_PostAccountTeam.constructAccountTeam(accountNCurrentAccountTeamMap, accountNRuleDerivedAccountTeamMap);
		
		/****************** 
		
		*******************
		
		*logger delegation*
		
		*******************
		
		*******************/
	}
	
	webservice static void reCreateAccountTeamInteractive(String accountId)
	{
		Map<Id, Account> mapAccountIdNAccount = new Map<Id, Account>([SELECT Id, RecordTypeId FROM Account WHERE Id =: accountId]);
		
		if(mapAccountIdNAccount != NULL && mapAccountIdNAccount.size() > 0){
			generateAccountTeam(mapAccountIdNAccount, null, true);	
		}
	}    
}