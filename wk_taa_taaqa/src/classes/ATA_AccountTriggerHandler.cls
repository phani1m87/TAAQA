/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_AccountTriggerHandler 
{
	// **** Logic to create/update the account team for given accounts
	
	public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
	{
		// *** invoke delegator method to generate Account Team
		// * trigger newMap 
		// * trigger oldMap 
		// * boolean : decides whether delete all and recreate or just insert / update 
		
		Map<Id, Account> filteredNewMap = new Map<Id, Account>();
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
				// exclude the accounts based on record type filters & exclude account automation flag
				if(newMap.get(accountId).RecordTypeId != excludeRecordTypeId && newMap.get(accountId).Exclude_Account_Automation__c == false)
				{
					filteredNewMap.put(accountId, newMap.get(accountId));
				} // end if	
			} // end for
		} // end if
		
		if(filteredNewMap.size() > 0)
		{
			ATA_AccountTeamHandler.generateAccountTeam(filteredNewMap, oldMap, true);
		}	
	}
}