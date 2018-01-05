/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/22/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_CurrentAccountTeam 
{
	//***** This class will be responsible for retriving the current account team members and return
	//***** collection holding AccountId with list of roles & team member 
	
	public static Map<Id, List<AccountTeamMember>> getCurrentAccountTeam(Set<Id> setAccountIds)
	{
		//*** map of accountid with list of roles & team member
		Map<Id, List<AccountTeamMember>> mapAccountIdNAccountTeamMembers;
		
		if(setAccountIds != NULL && setAccountIds.size() > 0) // check if input is not empty
		{
			mapAccountIdNAccountTeamMembers = new Map<Id, List<AccountTeamMember>>(); 
			System.debug('==setAccountIds ='+setAccountIds);
			//*** query AccountTeamMembers for the set of accounts
			List<AccountTeamMember> lstAccountTeamMembers = [SELECT Id, AccountId, Account.Name, TeamMemberRole, User.Id, User.DTN__c, User.Name 
																FROM AccountTeamMember
																WHERE accountId IN: setAccountIds];
			
			System.debug('==account team ='+lstAccountTeamMembers);
            if(lstAccountTeamMembers != NULL && lstAccountTeamMembers.size() > 0)
			{
				//*** build the map collection
				for(AccountTeamMember objATM : lstAccountTeamMembers)
				{
					//*** if account exists in the map
					if(mapAccountIdNAccountTeamMembers.containsKey(objATM.AccountId))
					{
						//*** get already added role & team members
						List<AccountTeamMember> lstAlreadyAddedRoleNAccountTeamMember = mapAccountIdNAccountTeamMembers.get(objATM.AccountId);
						
						//*** add new one to the already added list
						lstAlreadyAddedRoleNAccountTeamMember.add(objATM);
						
						//*** put it into the map
						mapAccountIdNAccountTeamMembers.put(objATM.AccountId, lstAlreadyAddedRoleNAccountTeamMember);
					}else{ //*** if account doesn't exists in the map then add
						mapAccountIdNAccountTeamMembers.put(objATM.AccountId, new List<AccountTeamMember>{objATM});
					} // end if then else
				} // end for
			} // end if
		}// end if
		
		//*** return map
		return mapAccountIdNAccountTeamMembers;
	}// end of getCurrentAccountTeam   
}// end of class