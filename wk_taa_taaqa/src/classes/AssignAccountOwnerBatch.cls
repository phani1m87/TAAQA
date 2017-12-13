/*
 * Batch class to assign account owner fields. The logic will refer Custom Setting to get role, 
 * account owner field and assignment order. Account fields to be updated: Software Owner, R&L Owner,
 * R&L Retention Owner, Indirect Owner, Small Firm Owner.
 * Account Owner Fields Assignment: SMS-858  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 07/05/2017 PIYUSH            1.0          Initial draft
 * ------------------------------------------------------------------------- */
global class AssignAccountOwnerBatch implements database.Batchable<SObject>
{
    //Query locator will get Account Team Members created/updated since the last batch execution.
    global Database.queryLocator start(Database.BatchableContext bc)
    {
        String query;
        Datetime lastJobExecuteDate = System.today();
        List<AsyncApexJob> asyncApexJobList = [SELECT CompletedDate, Status, ApexClass.Name 
        										FROM AsyncApexJob 
        										WHERE ApexClass.Name = 'AssignAccountOwnerBatch' 
        										AND Status = 'Completed' 
        										ORDER BY CompletedDate DESC LIMIT 1];
        
        if(asyncApexJobList.size() > 0) 
        {
           for(AsyncApexJob asyncJob : asyncApexJobList)
           {
				lastJobExecuteDate = asyncJob.CompletedDate;
             	system.debug('Last AssignAccountOwnerBatch****' + lastJobExecuteDate);
           }
		}       
       	String lastExceutedBatchDate = lastJobExecuteDate.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');
       	query = 'SELECT Id, AccountId, User.DTN__c FROM AccountTeamMember WHERE LastModifiedDate >=' + lastExceutedBatchDate;
       	//query = 'SELECT Id, AccountId, User.DTN__c FROM AccountTeamMember WHERE AccountId = \'0011100001Pp4Oy\'';
        System.debug('query ' + query);
        return Database.getQueryLocator(query);
    }

    //Execute method logic will get all Account Team Members, refer the custom setting to get Owner field and 
    //assignment order logic.
    global void execute(Database.BatchableContext bc, List<sObject> scope) 
    {
        try{
	        List<Account>accountToUpdate = new List<Account>();
	        List<AccountTeamMember>accountTeamsList = (List<AccountTeamMember>)scope;
	        System.debug('accountTeamsList '+accountTeamsList);
	        Set<Id>accountIdSet = new Set<Id>();
	        Set<String> dtnSet= new Set<String>();
	        Map<Id,AccountTeamMember> atmMap = new Map<Id,AccountTeamMember>();
	        Map<Id,Account> updatedAcctMap = new Map<Id,Account>();
	        Map<Id,Map<String,AccountTeamMember>> accountAtmMap = new Map<Id,Map<String,AccountTeamMember>>(); 
	        List<account_owner_mapping__c> ownerFieldMappingList = [SELECT Id, Name, DisplayOrder__c, RoleField__c, Owner__c FROM account_owner_mapping__c ORDER BY Name, DisplayOrder__c];
	        Map<String, User>userMap = new Map<String, User>();
	        User softwareOwner;
	        User r_l_owner;
	        User r_l_ret_owner;
	        User indirectOwner;
	        User rc_small_firm;
	        String dtn = '';
	        
	        for(AccountTeamMember atm : accountTeamsList) 
	        {
	            accountIdSet.add(atm.AccountId);
	        }
	        
	        System.debug('accountIdSet '+accountIdSet);
	        for(AccountTeamMember atm : [SELECT Id,AccountId, TeamMemberRole, User.DTN__c, UserId FROM AccountTeamMember WHERE AccountId IN: accountIdSet]) 
	        {
	            if(String.isNotBlank(atm.User.DTN__c)) 
	            {
	                if(accountAtmMap.containsKey(atm.AccountId)) 
	                {
	                    if(!accountAtmMap.get(atm.accountId).containsKey(atm.TeamMemberRole)) 
	                    {
							accountAtmMap.get(atm.accountId).put(atm.TeamMemberRole,atm);
						}
	                }else{
	                    accountAtmMap.put(atm.accountId, new map<String,AccountTeamMember>{atm.TeamMemberRole => atm});
	                }
	                dtnSet.add(atm.User.DTN__c);
	            }
	        }
	        System.debug('accountAtmMap '+accountAtmMap);
	        accountToUpdate = [SELECT Id, Software_Owner__c,R_L_Owner__c, R_L_Retention_Owner__c, Indirect_Owner__c, RC_Small_Firm__c FROM Account WHERE Id IN: accountIdSet];
	        
	        for(User u : [SELECT Id, DTN__c FROM User WHERE DTN__c IN: dtnSet]) 
	        {
	            userMap.put(u.dtn__c, u);
	        }
	        
	        //Only those accounts will be updated where Role with higher assignment order, as per custom setting, is present in Account Team
	        for(Account acc : accountToUpdate) 
	        {
	            softwareOwner = null;
	            r_l_owner = null;
	            r_l_ret_owner = null;
	            indirectOwner = null;
	            for(account_owner_mapping__c m : ownerFieldMappingList) 
	            {
	                System.debug('m '+m+' '+accountAtmMap.get(acc.Id));
	                if(m.name.contains('R&L Owner') && accountAtmMap.get(acc.Id) != null && accountAtmMap.get(acc.Id).containsKey(m.RoleField__c) && r_l_owner == null) 
	                {
	                    System.debug('Inside 1');
	                    dtn = accountAtmMap.get(acc.Id).get(m.RoleField__c).User.DTN__c;
	                    if(userMap.get(dtn) != null) {
	                        r_l_owner = userMap.get(dtn);
	                        if(acc.get(m.Owner__c) != r_l_owner.Id) {
	                            acc.put((String)m.Owner__c,r_l_owner.Id);
	                            updatedAcctMap.put(acc.Id,acc);
	                        }
	                    }
	                }
	                if(m.name.contains('Software Owner') && accountAtmMap.get(acc.Id)!= null && accountAtmMap.get(acc.Id).containsKey(m.RoleField__c) && softwareOwner == null) 
	                {
	                    System.debug('Inside 2');
	                    dtn = accountAtmMap.get(acc.Id).get(m.RoleField__c).User.DTN__c;
	                    if(userMap.get(dtn) != null) {
	                        softwareOwner = userMap.get(dtn);
	                        if(acc.get(m.Owner__c) != softwareOwner.Id) {
	                            acc.put((String)m.Owner__c,softwareOwner.Id);
	                            updatedAcctMap.put(acc.Id,acc);
	                        }
	                    }
	                }
	                if(m.name.contains('R&L Ret Owner') && accountAtmMap.get(acc.Id)!= null && accountAtmMap.get(acc.Id).containsKey(m.RoleField__c) && r_l_ret_owner == null) 
	                {
	                    System.debug('Inside 3');
	                    dtn = accountAtmMap.get(acc.Id).get(m.RoleField__c).User.DTN__c;
	                    if(userMap.get(dtn) != null) {
	                        r_l_ret_owner = userMap.get(dtn);
	                        if(acc.get(m.Owner__c) != r_l_ret_owner.Id) {
	                            acc.put((String)m.Owner__c,r_l_ret_owner.Id);
	                            updatedAcctMap.put(acc.Id,acc);
	                        }
	                    }   
	                }
	                if(m.name.contains('Indirect Owner') && accountAtmMap.get(acc.Id)!= null && accountAtmMap.get(acc.Id).containsKey(m.RoleField__c) && indirectOwner == null) 
	                {
	                    System.debug('Inside 4');
	                    dtn = accountAtmMap.get(acc.Id).get(m.RoleField__c).User.DTN__c;
	                    if(userMap.get(dtn) != null) {
	                        indirectOwner = userMap.get(dtn);
	                        if(acc.get(m.Owner__c) != indirectOwner.Id) {
	                            acc.put((String)m.Owner__c,indirectOwner.Id);
	                            updatedAcctMap.put(acc.Id,acc);
	                        }
	                    }   
	                }
	                if(m.name.contains('RC Small Firm') && accountAtmMap.get(acc.Id)!= null && accountAtmMap.get(acc.Id).containsKey(m.RoleField__c) && rc_small_firm == null) 
	                {
	                    System.debug('Inside 5');
	                    dtn = accountAtmMap.get(acc.Id).get(m.RoleField__c).User.DTN__c;
	                    if(userMap.get(dtn) != null) {
	                        rc_small_firm = userMap.get(dtn);
	                        if(acc.get(m.Owner__c) != rc_small_firm.Id) {
	                            acc.put((String)m.Owner__c,rc_small_firm.Id);
	                            updatedAcctMap.put(acc.Id,acc);
	                        }   
	                    }   
	                }
	            }
	        }
	        System.debug('updatedAcctMap '+updatedAcctMap);
	        if(updatedAcctMap.size() > 0) 
	        {
	            Database.SaveResult [] UpdateResult = Database.update(updatedAcctMap.values(),false);
	        }
	    }catch (Exception ex){
	        System.debug(ex.getTypeName()+'::line no::'+ex.getLineNumber()+'::Error message::'+ex.getMessage());
	    }
    }
    global void finish(Database.BatchableContext bc){}
}