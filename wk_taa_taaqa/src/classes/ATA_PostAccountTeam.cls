/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/28/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_PostAccountTeam 
{
    //***** This class will be responsible for create / update / delete the account team members
    
    // *** Set this flag to decide if delete all & recreate or just create
    // isDeleteExistingNRecreate = false : just create new ones and delete the ones which needed to be updated
    // isDeleteExistingNRecreate = true : delete all existing which doesn't need to be there and recreate the ones which supposed to be there
    public static Boolean isDeleteExistingNRecreate = false;  
    public static List<Monitoring_Log__c> lstMonitoringLog = new List<Monitoring_Log__c>();
    static Map<Id, User> mapUserIdAndUser = new Map<Id, User>();
    static Map<Id, Account> mapAccountIdNAccountToUpdate = new Map<Id, Account>();
    static Map<Id, sObject> newMapAccounts = new Map<Id, Account>();
    static List<ATA_Role_to_DTN_Field_Mapping__c> lstRoleToDTNFieldMapping = ATA_Role_to_DTN_Field_Mapping__c.getAll().values();
	
	// *** create Account Team Members
	public static List<Monitoring_Log__c> constructAccountTeam(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam, Map<Id, sObject> newTriggerMap)
	{
		newMapAccounts = newTriggerMap;
		mapUserIdAndUser = new Map<Id, User>([SELECT Id, DTN__c, Name, IsActive, Custodial_Rep__c FROM User]);
		
		Map<String, Set<AccountTeamMember>> mapOperationNAccountTeam = determineDMLOperation(currentAccountTeam, ruleDerivedAccountTeam);
		
		if(mapOperationNAccountTeam != NULL && mapOperationNAccountTeam.size() > 0)
		{
			//*** DELETE Account Team Members
			// since we cannot replace user on existing ATM record so delete the ones which supposed to be updated
			if(mapOperationNAccountTeam.containsKey('delete'))
			{
				Set<AccountTeamMember> deleteAccountTeam = mapOperationNAccountTeam.get('delete');
				List<AccountTeamMember> lstAccountTeamMembersToDelete = new List<AccountTeamMember>(deleteAccountTeam);
				if(lstAccountTeamMembersToDelete != NULL && lstAccountTeamMembersToDelete.size() > 0)
				{
					Database.DeleteResult[] deleteResults = Database.delete(lstAccountTeamMembersToDelete, false);
					
					//**** DML results handling ****//
					
					for(integer i = 0; i < deleteResults.size(); i++)
					{
						if(deleteResults[i].isSuccess())
						{
							assignOwnerNDTN(lstAccountTeamMembersToDelete[i], true);	
						}	
					}
				}
			}
			
			//*** INSERT Account Team Members
			// insert ATMs supposed to be there
			if(mapOperationNAccountTeam.containsKey('insert'))
			{
				Set<AccountTeamMember> insertAccountTeam = mapOperationNAccountTeam.get('insert');
				List<AccountTeamMember> lstAccountTeamMembersToInsert = new List<AccountTeamMember>(insertAccountTeam);
				if(lstAccountTeamMembersToInsert != NULL && lstAccountTeamMembersToInsert.size() > 0)
				{
					Database.SaveResult[] insertResults = Database.insert(lstAccountTeamMembersToInsert, false);
					
					//**** DML results handling ****//
					
					for(integer i = 0; i < insertResults.size(); i++)
					{
						if(insertResults[i].isSuccess())
						{
							assignOwnerNDTN(lstAccountTeamMembersToInsert[i], false);	
						}	
					}
				}
			}
			System.debug('###: ' + mapAccountIdNAccountToUpdate);
			//*** UPDATE Accounts with Owner & DTN fields
			if(mapAccountIdNAccountToUpdate.size() > 0)
			{
				Database.SaveResult[] updateResults = Database.update(mapAccountIdNAccountToUpdate.values(), false);
				
				//**** DML results handling ****//
			}	
		}
		
		return lstMonitoringLog;
	}
	
	// *** compare existing & to-be account team and determine DML operations
	public static Map<String, Set<AccountTeamMember>> determineDMLOperation(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		Map<String, Set<AccountTeamMember>> mapOperationNAccountTeamMembers = new Map<String, Set<AccountTeamMember>>();
		
		mapOperationNAccountTeamMembers.put('insert', new Set<AccountTeamMember>());
		mapOperationNAccountTeamMembers.put('delete', new Set<AccountTeamMember>());
		
		integer i = 0;
		
		// if currentAccountTeam is not NULL then do comparison to find which one to insert / update / delete 
		if(currentAccountTeam != NULL && currentAccountTeam.size() > 0)
		{
			for(Id accountId : ruleDerivedAccountTeam.keySet())
			{
				String logMessage = '';
				for(AccountTeamMember objDerivedATM : ruleDerivedAccountTeam.get(accountId))
				{
					i = 0;
					Boolean isConsiderd = false;
					System.debug('### : 0.0 ' + objDerivedATM.TeamMemberRole);
					for(AccountTeamMember objCurrentATM : currentAccountTeam.get(accountId))
					{	
						System.debug('### : 0.1 ' + objDerivedATM.TeamMemberRole);
						// *** UPDATE
						// Role & User both matches so no need to change anything
						if(objDerivedATM.TeamMemberRole == objCurrentATM.TeamMemberRole && objDerivedATM.UserId == objCurrentATM.UserId)
						{
							currentAccountTeam.get(accountId).remove(i);
							i++;
							isConsiderd = true;
							
							logMessage = logMessage + '\n No change for the role: ' + objDerivedATM.TeamMemberRole + ' User: ' + mapUserIdAndUser.get(objDerivedATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objDerivedATM.UserId).DTN__c + ')';
							
							break;
						}else if(objDerivedATM.TeamMemberRole == objCurrentATM.TeamMemberRole && objDerivedATM.UserId != objCurrentATM.UserId){
							// Role matches but user doesn't match so add it for update	
							Set<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('insert');
							alreadyAddedATMs.add(objDerivedATM);
							mapOperationNAccountTeamMembers.put('insert', alreadyAddedATMs);
							
							// since we cannot replace user on existing ATM so delete existing one and recreate new
							Set<AccountTeamMember> leftOverATMs = mapOperationNAccountTeamMembers.get('delete');
							leftOverATMs.add(objCurrentATM);
							mapOperationNAccountTeamMembers.put('delete', leftOverATMs);
							
							currentAccountTeam.get(accountId).remove(i);
							i++;
							isConsiderd = true;
							
							logMessage = logMessage + '\n Change for the role: ' + objDerivedATM.TeamMemberRole + ' from the old user: ' + mapUserIdAndUser.get(objCurrentATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objCurrentATM.UserId).DTN__c + ')'
																												+ ' to the new user: ' + mapUserIdAndUser.get(objDerivedATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objDerivedATM.UserId).DTN__c + ')';
							
							break;
						}else if(objDerivedATM.TeamMemberRole != objCurrentATM.TeamMemberRole && objDerivedATM.UserId == objCurrentATM.UserId){
							// Role matches but user doesn't match so add it for update	
							Set<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('insert');
							alreadyAddedATMs.add(objDerivedATM);
							mapOperationNAccountTeamMembers.put('insert', alreadyAddedATMs);
							
							// since we cannot replace user on existing ATM so delete existing one and recreate new
							Set<AccountTeamMember> leftOverATMs = mapOperationNAccountTeamMembers.get('delete');
							leftOverATMs.add(objCurrentATM);
							mapOperationNAccountTeamMembers.put('delete', leftOverATMs);
							
							currentAccountTeam.get(accountId).remove(i);
							i++;
							isConsiderd = true;
							
							logMessage = logMessage + '\n Change the role for the user: ' + mapUserIdAndUser.get(objDerivedATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objDerivedATM.UserId).DTN__c + ')' 
																												+ '	from the old role: ' + objCurrentATM.TeamMemberRole 
																												+ ' to the new role: ' + objDerivedATM.TeamMemberRole;
							
							break;
						} // end if then else
						i++;
					} // end for
					
					// *** INSERT
					// add ATM into map for insertion
					if(i == currentAccountTeam.get(accountId).size() && !isConsiderd)
					{
						Set<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('insert');
						alreadyAddedATMs.add(objDerivedATM);
						mapOperationNAccountTeamMembers.put('insert', alreadyAddedATMs);
						
						logMessage = logMessage + '\n Added the role: ' + objDerivedATM.TeamMemberRole + ' with the user: ' + mapUserIdAndUser.get(objDerivedATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objDerivedATM.UserId).DTN__c + ')';
												
					} // end if
					
				} // end for
				
				// *** DELETE
				if(isDeleteExistingNRecreate)
				{
					// consider left over ATMs to add into delete operation element of the map				
					for(AccountTeamMember objCurrentATM : currentAccountTeam.get(accountId))
					{
						Set<AccountTeamMember> leftOverATMs = mapOperationNAccountTeamMembers.get('delete');
						leftOverATMs.addAll(currentAccountTeam.get(accountId));
						mapOperationNAccountTeamMembers.put('delete', leftOverATMs);
						
						logMessage = logMessage + '\n Deleted the role: ' + objCurrentATM.TeamMemberRole + ' with the user: ' + mapUserIdAndUser.get(objCurrentATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objCurrentATM.UserId).DTN__c + ')'; 
					} // end for
				} // end if
				lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_PostAccountTeam', 'determineDMLOperation', logMessage, String.valueOf(accountId), ATA_Constants.ATA_TEAM_MEMBER_CREATED));
			} //end for	
		}else if(ruleDerivedAccountTeam != NULL){
			// if currentAccountTeam is NULL it means all ATMs needs to be inserted
			for(Id accountId : ruleDerivedAccountTeam.keySet())
			{
				if(mapOperationNAccountTeamMembers.containsKey('insert'))
				{
					Set<AccountTeamMember> alreadyAddedAccountTeam = mapOperationNAccountTeamMembers.get('insert');
					alreadyAddedAccountTeam.addAll(ruleDerivedAccountTeam.get(accountId));
					mapOperationNAccountTeamMembers.put('insert', alreadyAddedAccountTeam); 
				}else{
					List<AccountTeamMember> accountTeam = ruleDerivedAccountTeam.get(accountId);
					mapOperationNAccountTeamMembers.put('insert', new Set<AccountTeamMember>(accountTeam));
				} // end if then else
				String logMessage = '';
				for(AccountTeamMember objDerivedATM : ruleDerivedAccountTeam.get(accountId))
				{
					logMessage = logMessage + '\n Added the role: ' + objDerivedATM.TeamMemberRole + ' with the user: ' + mapUserIdAndUser.get(objDerivedATM.UserId).Name + '(DTN: ' + mapUserIdAndUser.get(objDerivedATM.UserId).DTN__c + ')';
				} // end for
				lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_PostAccountTeam', 'determineDMLOperation', logMessage, String.valueOf(accountId), ATA_Constants.ATA_TEAM_MEMBER_CREATED));
			} //end for
		} // end if then else		
		
		System.debug('### : ' + mapOperationNAccountTeamMembers);
		
		return mapOperationNAccountTeamMembers;
	}
	
	// *** assign owner and DTN fields on Account
	public static void assignOwnerNDTN(AccountTeamMember atmRecord, Boolean isDeleted)
	{
		if(atmRecord != NULL && atmRecord.TeamMemberRole != NULL && atmRecord.AccountId != NULL)
		{
			for(ATA_Role_to_DTN_Field_Mapping__c roleToDTNMapping : lstRoleToDTNFieldMapping)
			{
				if((!isDeleted && atmRecord.TeamMemberRole == roleToDTNMapping.ATA_Role_Name__c) 
						|| (isDeleted && atmRecord.TeamMemberRole == roleToDTNMapping.ATA_Role_Name__c && mapUserIdAndUser.get(atmRecord.UserId).DTN__c == newMapAccounts.get(atmRecord.AccountId).get(roleToDTNMapping.Account_DTN_Field_API_Name__c))) // match role
				{
					String DTN = mapUserIdAndUser.get(atmRecord.UserId).DTN__c;
					// if team member is deleted then reset DTN to BLANK 
					if(isDeleted){
						DTN = '';
					} // end if
					
					// assign DTN to field
					if(mapAccountIdNAccountToUpdate.containsKey(atmRecord.AccountId))
					{
						mapAccountIdNAccountToUpdate.get(atmRecord.AccountId).put(roleToDTNMapping.Account_DTN_Field_API_Name__c, DTN);
					}else{
						Account objAccount = new Account(Id = atmRecord.AccountId);
						objAccount.put(roleToDTNMapping.Account_DTN_Field_API_Name__c, DTN);
						mapAccountIdNAccountToUpdate.put(atmRecord.AccountId, objAccount);
					} // end if then else
					
					// Change Account Owner
		            if(String.isNotBlank(ATA_Utility.ATACustomSettings().Default_Account_UserId__c)){
						mapAccountIdNAccountToUpdate.get(atmRecord.AccountId).put('OwnerId', ATA_Utility.ATACustomSettings().Default_Account_UserId__c);
		            } // end if
					
					// Set IsMassUpdated__c to FALSE so if it was TRUE by batch then this sets to FALSE
					mapAccountIdNAccountToUpdate.get(atmRecord.AccountId).put('IsMassUpdated__c', false);
				} // end if	
			} // end for	
		} // end if
	} 
}