/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/28/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_PostAccountTeam 
{
    //***** This class will be responsible for create / update / delete the account team members
	
	// *** create / update Account Team Members
	public static List<Monitoring_Log__c> createUpdateAccountTeam(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		List<Monitoring_Log__c> lstMonitoringLog;
		
		return lstMonitoringLog;
	}
	
	
	// *** delete existing & re-create Account Team Members
	public static List<Monitoring_Log__c> deleteExistingNRecreateAccountTeam(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		List<Monitoring_Log__c> lstMonitoringLog;
		
		return lstMonitoringLog;
	}
	
	// *** compare existing & to-be account team and determine DML operations
	private static Map<String, List<AccountTeamMember>> determineDMLOperation(Map<Id, List<AccountTeamMember>> currentAccountTeam, Map<Id, List<AccountTeamMember>> ruleDerivedAccountTeam)
	{
		Map<String, List<AccountTeamMember>> mapOperationNAccountTeamMembers = new Map<String, List<AccountTeamMember>>();
		
		mapOperationNAccountTeamMembers.put('upsert', new List<AccountTeamMember>());
		mapOperationNAccountTeamMembers.put('delete', new List<AccountTeamMember>());
		
		integer i = 0;
		
		if(currentAccountTeam != NULL && currentAccountTeam.size() > 0)
		{
			for(Id accountId : ruleDerivedAccountTeam.keySet())
			{
				for(AccountTeamMember objDerivedATM : ruleDerivedAccountTeam.get(accountId))
				{
					i = 0;
					for(AccountTeamMember objCurrentATM : currentAccountTeam.get(accountId))
					{	
						if(objDerivedATM.TeamMemberRole == objCurrentATM.TeamMemberRole)
						{
							if(objDerivedATM.UserId != objCurrentATM.UserId)
							{
								objDerivedATM.Id = objCurrentATM.Id;
								List<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('upsert');
								alreadyAddedATMs.add(objDerivedATM);
								mapOperationNAccountTeamMembers.put('upsert', alreadyAddedATMs);
								currentAccountTeam.get(accountId).remove(i);
								break;
							}
						} // end if
						i++;
					} // end for
					
					if(i == currentAccountTeam.get(accountId).size())
					{
						List<AccountTeamMember> alreadyAddedATMs = mapOperationNAccountTeamMembers.get('upsert');
						alreadyAddedATMs.add(objDerivedATM);
						mapOperationNAccountTeamMembers.put('upsert', alreadyAddedATMs);						
					}
				} // end for
			} //end for	
		}else{
			for(Id accountId : ruleDerivedAccountTeam.keySet())
			{
				if(mapOperationNAccountTeamMembers.containsKey('upsert'))
				{
					List<AccountTeamMember> lstAlreadyAddedAccountTeamMembers = mapOperationNAccountTeamMembers.get('upsert');
					lstAlreadyAddedAccountTeamMembers.addAll(ruleDerivedAccountTeam.get(accountId));
					mapOperationNAccountTeamMembers.put('upsert', lstAlreadyAddedAccountTeamMembers); 
				}else{
					List<AccountTeamMember> lstAccountTeamMember = ruleDerivedAccountTeam.get(accountId);
					mapOperationNAccountTeamMembers.put('upsert', lstAccountTeamMember);
				} // end if then else
			} //end for
		} // end if then else		
		
		System.debug('### : ' + mapOperationNAccountTeamMembers);
		
		return mapOperationNAccountTeamMembers;
	} 
}