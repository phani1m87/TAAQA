public class PopulateAccountOwnerFields {
	@InvocableMethod 
	public static void assignOwnerFields(List<Account> AccountList) {
		Set<Id> acctIdset = new Set<Id>();
	for(Account acct:AccountList){
			acctIdset.add(acct.Id);
		}
	//	PopulateAccountOwnerFields.updateFields(acctIdset);
	//}
	//@future
	//public static void updateFields(Set<Id> acctIdSet) {
	/*	try{ 
		Set<String> dtnSet = new Set<String>(); 
		Map<String,User> userMap = new Map<String,User>();
		//Set<Id> acctIdSet = new Set<Id>();
//		List<account_owner_mapping__c> ownerFieldMappingList = [select Id, Name, DisplayOrder__c, Owner__c from account_owner_mapping__c order by Name,DisplayOrder__c];
		Set<String> AcctFieldsSet = new Set<String>();
		Map<Id,Account> acctMap = new Map<Id,Account>();
		Map<Id, Account> acctUpdateMap = new Map<Id, Account>();
		Map<Id,Map<Id,account_owner_mapping__c>> accountRoleOwnerMap = new Map<Id,Map<Id,account_owner_mapping__c>>(); 
		Map<Id,account_owner_mapping__c> RoleOwnerMap = new Map<Id,account_owner_mapping__c>();
		String accountQuery = '';
		Account act;
		List<account_owner_mapping__c> roleSettingList;
		String Sw_dtn='';
		//String Sw_owner_field='';
		String r_l_dtn = '';
		//String r_l_owner_field = '';
		String indirect_dtn = '';
		//String indirect_owner_field = '';
		String r_l_ret_dtn = '';
		//String r_l_ret_owner_field = '';
		for(account_owner_mapping__c m1: ownerFieldMappingList) {
 		    acctFieldsSet.add(m1.RoleField__c);
		    acctFieldsSet.add(m1.Owner__c);
		}
		/*for(Account acct: AccountList) {
			acctIdSet.add(acct.id);
		}*//*
		List<String> AcctFieldList = new List<String>(AcctFieldsSet);
		accountQuery = 'select Id, '+String.join(AcctFieldList,',')+' from Account where Id in :acctIdSet';
		for(Account acc: Database.query(accountQuery)) {
			for(account_owner_mapping__c m: ownerFieldMappingList){
				if(m.name.contains('R&L Owner') && acc.get(m.RoleField__c)!=null && String.isNotBlank(m.Owner__c) && String.isBlank(r_l_dtn)) {
        			r_l_dtn = (String)acc.get(m.RoleField__c);
					//r_l_owner_field = (String)acc.get(m.Owner__c);
					RoleOwnerMap.put(m.id,m);
        			dtnSet.add((String)acc.get(m.RoleField__c));
    			}
    			if(m.name.contains('Software Owner') && acc.get(m.RoleField__c)!=null && String.isNotBlank(m.Owner__c) && String.isBlank(Sw_dtn)) {
        			Sw_dtn = (String)acc.get(m.RoleField__c);
        			//Sw_owner_field = (String)acc.get(m.Owner__c);
        			RoleOwnerMap.put(m.id,m);
        			dtnSet.add((String)acc.get(m.RoleField__c));
    			}
    			if(m.name.contains('Indirect Owner') && acc.get(m.RoleField__c)!=null && String.isNotBlank(m.Owner__c) && String.isBlank(indirect_dtn)) {
        			indirect_dtn = (String)acc.get(m.RoleField__c);
        			//indirect_owner_field = (String)acc.get(m.Owner__c);
        			RoleOwnerMap.put(m.id,m);
        			dtnSet.add((String)acc.get(m.RoleField__c));
    			}
    			if(m.name.contains('R&L Ret Owner') && acc.get(m.RoleField__c)!=null && String.isNotBlank(m.Owner__c) && String.isBlank(r_l_ret_dtn)) {
        			r_l_ret_dtn = (String)acc.get(m.RoleField__c);
        			//r_l_ret_owner_field = (String)acc.get(m.Owner__c);
        			RoleOwnerMap.put(m.id,m);
        			dtnSet.add((String)acc.get(m.RoleField__c));
    			}
			}
			accountRoleOwnerMap.put(acc.id,RoleOwnerMap);
			acctMap.put(acc.id,acc);
		}
		System.debug('accountRoleOwnerMap '+accountRoleOwnerMap);
		System.debug('acctMap '+acctMap);
		for(User u: [select Id,dtn__c,IsActive from user where dtn__c in :dtnSet]) {
			userMap.put(u.dtn__c,u);
		}
		User uInst;
		String dtn;
		for(Id acctId : accountRoleOwnerMap.keySet()) {
			act = acctMap.get(acctId);
			roleSettingList = accountRoleOwnerMap.get(acctId).values();
			for(account_owner_mapping__c ownerMapping:roleSettingList ) {
					dtn = (String)act.get(ownerMapping.RoleField__c);
					if(userMap.get(dtn)!= null) {
						act.put(ownerMapping.Owner__c,userMap.get(dtn).Id);
				}
			}
			acctUpdateMap.put(act.Id,act);
		}
		System.debug('acctUpdateMap '+acctUpdateMap);
		if(acctUpdateMap.size()>0) {
			Database.SaveResult [] updateRes = Database.update(acctUpdateMap.values(),false);
		}
	}
	catch(Exception ex) {
		List<Monitoring_Log__c> monitoringLogslist = new List<Monitoring_Log__c>(); 
		Monitoring_Log__c m = new Monitoring_Log__c();
        m.Detail__c = ex.getTypeName()+'::line no::'+ex.getLineNumber()+'::Error message::'+ex.getMessage();
        m.Type__c = WK_Constants.ATA_CODE_ERROR;
        m.Class__c = 'PopulateAccountOwnerFields';
        m.Method__c = 'assignOwnerFields';
        monitoringLogslist.add(m);
        if(monitoringLogslist.size()>0){
                Database.SaveResult[] monitorslst = Database.insert(monitoringLogslist,false);
            }*/
	}
	//}
}