/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/28/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_PostAccountTeam 
{
    //***** This class will be responsible for create / update / delete the account team members
    
    // *** Set this flag to decide if delete all & recreate or just create
    // isDeleteNRecreate = false : just create new ones and delete the ones which needed to be updated
    // isDeleteNRecreate = true : delete all existing which doesn't need to be there and recreate the ones which supposed to be there
    public static Boolean isDeleteNRecreate = false;  
	
	// *** create Account Team Members
	public static List<Monitoring_Log__c> constructAccountTeam(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		List<Monitoring_Log__c> lstMonitoringLog;
		
		Map<String, Set<AccountTeamMember>> mapOperationNAccountTeam = determineDMLOperation(currentAccountTeam, ruleDerivedAccountTeam);
		
		if(mapOperationNAccountTeam != NULL && mapOperationNAccountTeam.size() > 0)
		{
			//*** DELETE
			// since we cannot replace user on existing ATM record so delete the ones which supposed to be updated
			if(mapOperationNAccountTeam.containsKey('delete'))
			{
				Set<AccountTeamMember> deleteAccountTeam = mapOperationNAccountTeam.get('delete');
				
				if(deleteAccountTeam != NULL && deleteAccountTeam.size() > 0)
				{
					Database.DeleteResult[] memberslst = Database.delete(new List<AccountTeamMember>(deleteAccountTeam), false);
					
					//**** DML error handling ****//
				}
			}
			
			//*** INSERT
			// insert ATMs supposed to be there
			if(mapOperationNAccountTeam.containsKey('insert')){
				Set<AccountTeamMember> insertAccountTeam = mapOperationNAccountTeam.get('insert');
				
				if(insertAccountTeam != NULL && insertAccountTeam.size() > 0)
				{
					Database.SaveResult[] memberslst = Database.insert(new List<AccountTeamMember>(insertAccountTeam), false);
					
					//**** DML error handling ****//
				}
			}  
		}
		
		return lstMonitoringLog;
	}
	
	/*
	// *** delete existing & re-create Account Team Members
	public static List<Monitoring_Log__c> deleteExistingNRecreateAccountTeam(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		List<Monitoring_Log__c> lstMonitoringLog;
		
		Map<String, List<AccountTeamMember>> mapOperationNAccountTeamMembers = determineDMLOperation(currentAccountTeam, ruleDerivedAccountTeam);
		
		if(mapOperationNAccountTeamMembers != NULL && mapOperationNAccountTeamMembers.size() > 0)
		{
			//*** DELETE
			// delete the existing ones which doesn't matches with derived Account Team Roles
			if(mapOperationNAccountTeamMembers.containsKey('delete'))
			{
				List<AccountTeamMember> deleteAccountTeam = mapOperationNAccountTeamMembers.get('delete');
				
				if(deleteAccountTeam != NULL && deleteAccountTeam.size() > 0)
				{
					Database.DeleteResult[] memberslst = Database.delete(deleteAccountTeam, false);
					
					//**** DML error handling **** //
				}
			}
			
			//*** INSERT
			// insert ATMs supposed to be there
			if(mapOperationNAccountTeamMembers.containsKey('insert')){
				List<AccountTeamMember> insertAccountTeam = mapOperationNAccountTeamMembers.get('insert');
				
				if(insertAccountTeam != NULL && insertAccountTeam.size() > 0)
				{
					Database.SaveResult[] memberslst = Database.insert(insertAccountTeam, false);
					
					//**** DML error handling **** //
				}
			}  
		}
		
		return lstMonitoringLog;
	}
	*/
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
							break;
						}else if(objDerivedATM.TeamMemberRole == objCurrentATM.TeamMemberRole && objDerivedATM.UserId != objCurrentATM.UserId){
							// Role matches but user doesn't match so add it for update	
							System.debug('### : 1.0 ' + objDerivedATM.TeamMemberRole);
							System.debug('### : 1.1 ' + objCurrentATM.TeamMemberRole);
							
							System.debug('### : 1.2 ' + objDerivedATM.UserId);
							System.debug('### : 1.3 ' + objCurrentATM.UserId);
							System.debug('### : 1.4 ' + i);
							//objDerivedATM.Id = objCurrentATM.Id;
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
							break;
						} // end if
						i++;
					} // end for
					
					// *** INSERT
					// add ATM into map for insertion
					if(i == currentAccountTeam.get(accountId).size() && !isConsiderd)
					{
						Set<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('insert');
						alreadyAddedATMs.add(objDerivedATM);
						mapOperationNAccountTeamMembers.put('insert', alreadyAddedATMs);						
					} // end if
					
				} // end for
				
				// *** DELETE
				if(isDeleteNRecreate){
					// consider left over ATMs to add into delete operation element of the map				
					for(AccountTeamMember objCurrentATM : currentAccountTeam.get(accountId))
					{
						Set<AccountTeamMember> leftOverATMs = mapOperationNAccountTeamMembers.get('delete');
						leftOverATMs.addAll(currentAccountTeam.get(accountId));
						mapOperationNAccountTeamMembers.put('delete', leftOverATMs);
					} // end for
				}
				
			} //end for	
		}else{
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
			} //end for
		} // end if then else		
		
		System.debug('### : ' + mapOperationNAccountTeamMembers);
		
		return mapOperationNAccountTeamMembers;
	} 
}