/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/12/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_ManageBatchAccountTeamUpdates 
{
	// **** batch manager for ATA mass update
	
	static String logMessage = '';
		
	// *** pre-processor to find affected accounts and trigger batch
	public static void geographicPreprocess_MassUpdate(Boolean isDeleteExistingNRecreate)
	{
		Map<String, Set<String>> mapPostalCodeNRoles = new Map<String, Set<String>>();
		Map<String, Set<String>> mapRoleNameNPostalCode = new Map<String, Set<String>>();
		Set<String> setAffectedPostalCodes = new Set<String>();
		Set<String> setAffectedRoles = new Set<String>();
		List<Account> lstAffectedAccounts = new List<Account>(); 
		Boolean isUpdateFailed = false;
		
		String excludeRecordTypeId;
		
		// read record type to be exluded and find recordTypeId
		if(ATA_Utility.ATACustomSettings() != NULL && String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
		{
        	if(String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
			{
				excludeRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c).getRecordTypeId();
			} // end if
      	} // end if
      	
      	// query affected geographic assignment entries
      	List<ATA_Geographic_Assignment__c> lstAffectedGeographicAssignment = [SELECT Id, Role_Name__c, PostalCode__c, DTN__c 
										                                            FROM ATA_Geographic_Assignment__c
										                                            WHERE IsUpdated__c = true];
      	
      	// loop through & form collections
      	for(ATA_Geographic_Assignment__c geoAssignment : lstAffectedGeographicAssignment)
      	{
      		// map of postal code and affected roles
      		if(mapPostalCodeNRoles.containsKey(geoAssignment.PostalCode__c))
      		{
      			Set<String> setAlreadyAddedRoles = mapPostalCodeNRoles.get(geoAssignment.PostalCode__c);
      			setAlreadyAddedRoles.add(geoAssignment.Role_Name__c);
      			mapPostalCodeNRoles.put(geoAssignment.PostalCode__c, setAlreadyAddedRoles);
      		}else{
      			mapPostalCodeNRoles.put(geoAssignment.PostalCode__c, new Set<String>{geoAssignment.Role_Name__c});
      		} // end if then else
      		
      		// map of role name and affected postal code
      		if(mapRoleNameNPostalCode.containsKey(geoAssignment.Role_Name__c))
      		{
      			Set<String> setAlreadyAddedPostalCodes = mapPostalCodeNRoles.get(geoAssignment.Role_Name__c);
      			setAlreadyAddedPostalCodes.add(geoAssignment.PostalCode__c);
      			mapRoleNameNPostalCode.put(geoAssignment.Role_Name__c, setAlreadyAddedPostalCodes);
      		}else{
      			mapRoleNameNPostalCode.put(geoAssignment.Role_Name__c, new Set<String>{geoAssignment.PostalCode__c});
      		} // end if then else
      		
      		setAffectedPostalCodes.add(geoAssignment.PostalCode__c + '%');
      		setAffectedRoles.add(geoAssignment.Role_Name__c);
      		
      		// set the flag back to FALSE assuming everything will go fine
      		geoAssignment.IsUpdated__c = false;
      		
      	} // end for
      	
      	// query the accounts to find if they are really affected by matching roles
      	Map<Id, Account> mapAccountIdNAccount = new Map<Id, Account>([SELECT Id, BillingPostalCode FROM Account WHERE RecordTypeId !=: excludeRecordTypeId AND Exclude_Account_Automation__c = false AND BillingPostalCode LIKE: setAffectedPostalCodes]);
      	
      	if(mapAccountIdNAccount.size() > 0) // found accounts
      	{
      		// query AccountTeamMembers
      		for(AccountTeamMember objATM : [SELECT Id, AccountId, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN: mapAccountIdNAccount.keySet() AND TeamMemberRole IN: setAffectedRoles])
      		{
      			if(String.isNotBlank(mapAccountIdNAccount.get(objATM.AccountId).BillingPostalCode))
      			{
					// check if postal code is 5 digit if not then subString
					String postalCode = mapAccountIdNAccount.get(objATM.AccountId).BillingPostalCode;
					if(postalCode.length() > 5){
						postalCode = postalCode.subString(0,5);
					} // end if
					
					// find if account is really affected
					if(mapPostalCodeNRoles.containsKey(postalCode))
					{
						if(mapPostalCodeNRoles.get(postalCode).contains(objATM.TeamMemberRole))
						{
							mapAccountIdNAccount.get(objATM.AccountId).IsMassUpdated__c = true;
							lstAffectedAccounts.add(mapAccountIdNAccount.get(objATM.AccountId));	
						} // end if
					} // end if 	      				
      			} // end if
      		} // end for
      	} // end if
      	
      	// DML: update operation
      	if(lstAffectedAccounts.size() > 0)
      	{
      		isUpdateFailed = false;
      		
      		// DML: update affected accounts with IsMassUpdated__c = TRUE
      		Database.SaveResult[] updateAccountResults = Database.update(lstAffectedAccounts, true);
      		
      		for(integer i = 0; i < updateAccountResults.size(); i++)
      		{
				if(!updateAccountResults[i].isSuccess())
				{
					// if failure then set the flag to prevent batch execution
					isUpdateFailed = true;
				} // end if     			
      		} // end for
      		
      		// if update is not failed then trigger the batch
      		if(!isUpdateFailed)
      		{
      			// DML: update affected geo assignment records with IsUpdated__c = FALSE
      			Database.SaveResult[] updateGeoAssignmentResults = Database.update(lstAffectedGeographicAssignment, true);
      			
      			// prepare log message
      			logMessage = 'ATA_AccountTeamUpdateBatch was triggered to run to update below roles and affected postal codes.\n';
      			for(String RoleName : mapRoleNameNPostalCode.keySet())
      			{
      				logMessage = logMessage + '\nRole Name: ' + RoleName + ' affected postal codes: ' + mapRoleNameNPostalCode.get(RoleName);
      			} // end for
      			
      			massUpdate(isDeleteExistingNRecreate);
      		} // end if	
      	} // end if
	}
	
	// *** trigger the batch
	public static void massUpdate(Boolean isDeleteExistingNRecreate)
	{
		Monitoring_Log__c objLog = new Monitoring_Log__c();
		
		// cherck if logMessage is BLANK, if not blank means call came from pre-Processor
		if(String.isBlank(logMessage))
		{
			// find out affected account count to log
			Integer affectedAccounts = [SELECT count() FROM Account WHERE IsMassUpdated__c = true];
			logMessage = 'ATA_AccountTeamUpdateBatch was triggered to run on total ' + affectedAccounts + ' Accounts with IsMassUpdated__c = TRUE.';
		} // end if
		
		// prepare log message
		if(logMessage.length() > 32500){
			logMessage = logMessage.subString(0,32500);
			logMessage = logMessage + ' . . . . . ';
		}
		logMessage = logMessage + '\nBatch was run by ' + UserInfo.getName(); 
		
		// prepare monitoring log instance		 
		Monitoring_Log__c startLog = ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_AccountTeamUpdateBatch', 'start', logMessage, null, ATA_Constants.ATA_ACCOUNTTEAM_UPDATEBATCH_START_CODE);
		
		// find the batch size
		Integer batchSize = 200;
		if(ATA_Utility.ATACustomSettings().GeneralDataSizeInBatchJob__c != NULL){
			batchSize = Integer.valueOf(ATA_Utility.ATACustomSettings().GeneralDataSizeInBatchJob__c);
		}
		
		// trigger the batch apex		
		ATA_AccountTeamUpdateBatch massUpdateBatch = new ATA_AccountTeamUpdateBatch(isDeleteExistingNRecreate, startLog);
		database.executebatch(massUpdateBatch, batchSize);		
	}    
}