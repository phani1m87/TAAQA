public with sharing class ATA_ComposeAccountTeam {
    
    // Contains the logic to create the Account Team for a given Account
   	static Map<Id, List<ATA_AccountRuleValue>> mapAccountIdNListATA_AccountRuleValue = new Map<Id, List<ATA_AccountRuleValue>>();
    static Set<String> setFieldAPINames = new Set<String>();
    static Set<String> setFieldValues = new Set<String>();
    static Map<String, User> userMap = new Map<String, User>();
    static Set<String> validAssignmentTypeSet = new Set<String>();
    static Map<Id, Account> mapAccounts = new Map<Id, Account>();
    
    public ATA_ComposeAccountTeam(List<Account> newAccountList, Map<Id, Account> oldMap)
    {
		List<User> lstUsers = [SELECT Id, DTN__c FROM User WHERE DTN__c != NULL];
		
		for(User objUser : lstUsers){
			userMap.put(objUser.DTN__c, objUser);	
		}	    	
    	
    	List<ATA_Rule__c> lstATARules = [SELECT Id, Rule_Type__c, FieldSet__c, Field_API_Name__c 
    										FROM ATA_Rule__c 
    										WHERE Rule_Enabled__c = true];
    										
    	Map<String, Set<String>> mapFieldSetNFieldAPINames = new Map<String, Set<String>>();
    	
    	for(ATA_Rule__c rule : lstATARules)
		{
			if(mapFieldSetNFieldAPINames.containsKey(rule.FieldSet__c)){
				Set<String> setFieldAPINames = mapFieldSetNFieldAPINames.get(rule.FieldSet__c);
				setFieldAPINames.add(rule.Field_API_Name__c);
				mapFieldSetNFieldAPINames.put(rule.FieldSet__c, setFieldAPINames);
			}else{
				mapFieldSetNFieldAPINames.put(rule.FieldSet__c, new Set<String>{rule.Field_API_Name__c});	
			}
			setFieldAPINames.add(rule.Field_API_Name__c);
		}
		
		System.debug('###: ' + mapFieldSetNFieldAPINames);
		
    	for(Account account : newAccountList)
    	{
    		Boolean isChanged = false;
    		String ruleType;
    		ATA_AccountRuleValue newAccountRule = NULL;
    		
    		if(oldMap != NULL)
    		{
	    		for(ATA_Rule__c rule : lstATARules)
	    		{
	    			if(account.get(rule.Field_API_Name__c) != oldMap.get(account.Id).get(rule.Field_API_Name__c))
	    			{
	    				isChanged = true;
	    				ruleType = rule.Rule_Type__c;
	    			}
	    		}
    		}else{
    			isChanged = true;
    			ruleType = lstATARules[0].Rule_Type__c;
    		}
    		
    		if(isChanged)
    		{
    			for(String fieldSet : mapFieldSetNFieldAPINames.keySet())
    			{
    				newAccountRule = new ATA_AccountRuleValue();
    				newAccountRule.ruleType = ruleType;
	    			newAccountRule.fieldset = fieldSet;
	    			newAccountRule.fieldApiName_fieldValue_Map = new Map<String, String>();
	    			for(String fieldAPIName : mapFieldSetNFieldAPINames.get(fieldSet))
	    			{
    					newAccountRule.fieldApiName_fieldValue_Map.put(fieldAPIName, String.valueOf(account.get(fieldAPIName)));
    					if(account.get(fieldAPIName) != NULL){
    						setFieldValues.add(String.valueOf(account.get(fieldAPIName)));
    					}
	    			}
	    			
	    			if(newAccountRule != NULL)
		    		{
		    			if(mapAccountIdNListATA_AccountRuleValue.containsKey(account.Id)){
		    				List<ATA_AccountRuleValue> lstAccountRule = mapAccountIdNListATA_AccountRuleValue.get(account.Id);
		    				lstAccountRule.add(newAccountRule);
		    				mapAccountIdNListATA_AccountRuleValue.put(account.Id, lstAccountRule);
		    			}else{
		    				mapAccountIdNListATA_AccountRuleValue.put(account.Id, new List<ATA_AccountRuleValue>{newAccountRule});
		    			}
		    		}
    			}
    		}
    	}
    	
    	System.debug('###: ' + mapAccountIdNListATA_AccountRuleValue);
    }
    
    public static Map<Id, List<ATA_AccountRuleValue>> createAccountRoleValueMap() 
    {
		return mapAccountIdNListATA_AccountRuleValue;
    }
    
    public static Map<Id, Set<String>> getAssignmentTypes(Map<Id, List<ATA_AccountRuleValue>> accountRuleValueMap) 
    {
		Map<Id, Set<String>> validAssignmnentTypesMap = new Map<Id, Set<String>>();

		for(Id accountId : accountRuleValueMap.keySet()) // loop over the account rule value map
		{
			for(ATA_AccountRuleValue objRuleValue : accountRuleValueMap.get(accountId)) // loop through each fielSet rule set for selected account 
			{
				
				//*** Technical debt SOQL in for loop
				
				//*** Query the Assignment Map for the specific fieldSet and fieldAPINames & values for that fieldSet
				List<AggregateResult> lstAssignmentTypeMap = [SELECT COUNT(Id) assignmentTypeCount, Assignment_Type__c, FieldSet__c 
																			FROM ATA_AssignmentType_Map__c
																			WHERE FieldSet__c =: objRuleValue.fieldset
																			AND Field_API_Name__c IN: objRuleValue.fieldApiName_fieldValue_Map.keySet()
																			AND Field_Value__c IN: objRuleValue.fieldApiName_fieldValue_Map.values()
																			GROUP BY Assignment_Type__c, FieldSet__c
																			HAVING COUNT(Id) =: objRuleValue.fieldApiName_fieldValue_Map.size()];
				
				for(AggregateResult objAssignmentType : lstAssignmentTypeMap) // loop through aggregate results to build map
				{
					// map of account id and associated assignment types
					if(validAssignmnentTypesMap.containsKey(accountId)){
						Set<String> setAssignmentTypes = validAssignmnentTypesMap.get(accountId);
						setAssignmentTypes.add(String.valueOf(objAssignmentType.get('Assignment_Type__c')));
						validAssignmnentTypesMap.put(accountId, setAssignmentTypes);
					}else{
						validAssignmnentTypesMap.put(accountId, new Set<String>{String.valueOf(objAssignmentType.get('Assignment_Type__c'))});
					}
					validAssignmentTypeSet.add(String.valueOf(objAssignmentType.get('Assignment_Type__c')));			
				}
			}
		} 
		System.debug('## : ' + validAssignmnentTypesMap);
		return validAssignmnentTypesMap;
    }

    public static Map<Id, List<AccountTeamMember>> getListAccountTeamMembers(Map<Id, Set<String>> accountAssignmentType) 
    {
    	Map<Id, List<AccountTeamMember>> accountNAccountTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
    	
    	mapAccounts = new Map<Id, Account>([SELECT Id, BillingPostalCode FROM Account WHERE Id IN: accountAssignmentType.keySet()]);
    	
    	if(accountAssignmentType != NULL)
    	{
	    	// *** get role assignments
	    	
	    	Map<Id, Set<ATA_Role_Assignment__c>> accountGeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
	    	Map<Id, Set<ATA_Role_Assignment__c>> accountNongeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
	    	
	    	List<ATA_Role_Assignment__c> lstRoleAssignments = [SELECT Id, Role_Name__c, Role_Assignment_Type__c, Assignment_Type__c, Assignment_Mechanism__c, Account_FieldName_Nongeographic__c
	    														FROM ATA_Role_Assignment__c
	    														WHERE Assignment_Type__c IN: validAssignmentTypeSet];
	    	
	    	for(Id accountId : accountAssignmentType.keySet())
	    	{
	    		for(ATA_Role_Assignment__c objRoleAssignment : lstRoleAssignments)
	    		{
	    			if(objRoleAssignment.Account_FieldName_Nongeographic__c == NULL)
	    			{
		    			if(accountAssignmentType.get(accountId).contains(objRoleAssignment.Assignment_Type__c))
		    			{
		    				if(accountGeographicRoles.containsKey(accountId))
		    				{
		    					Set<ATA_Role_Assignment__c> alreadyAddedRoles = accountGeographicRoles.get(accountId);
		    					alreadyAddedRoles.add(objRoleAssignment);
		    					accountGeographicRoles.put(accountId, alreadyAddedRoles);
		    				}else{
		    					accountGeographicRoles.put(accountId, new Set<ATA_Role_Assignment__c>{objRoleAssignment});
		    				}				
		    			}
	    			}else{
	    				if(accountAssignmentType.get(accountId).contains(objRoleAssignment.Assignment_Type__c))
		    			{
		    				if(accountNongeographicRoles.containsKey(accountId))
		    				{
		    					Set<ATA_Role_Assignment__c> alreadyAddedRoles = accountNongeographicRoles.get(accountId);
		    					alreadyAddedRoles.add(objRoleAssignment);
		    					accountNongeographicRoles.put(accountId, alreadyAddedRoles);
		    				}else{
		    					accountNongeographicRoles.put(accountId, new Set<ATA_Role_Assignment__c>{objRoleAssignment});
		    				}				
		    			}
	    			}
	    		}
	    	}
	    	
	    	// *** get Account Team Members based on geo & non-geo role assignments
	    	// geo
	    	if(accountGeographicRoles.size() > 0)
	    	{
	    		accountNAccountTeamMembersMap = computeAccountTeamUsingRoles(accountGeographicRoles);
	    	}
	    	
	    	// non-geo
			if(accountNongeographicRoles.size() > 0)
	    	{
	    		if(accountNAccountTeamMembersMap != NULL && accountNAccountTeamMembersMap.size() > 0){
	    			accountNAccountTeamMembersMap.putAll(computeAccountTeamUsingRoles(accountNongeographicRoles));
	    		}
	    	}
	    	
	    	System.debug('###: ' + accountNAccountTeamMembersMap);
	    	return accountNAccountTeamMembersMap;
    	}
    	
    	return null;	
    }
    
    public static Map<Id, List<AccountTeamMember>> computeAccountTeamUsingRoles(Map<Id, Set<ATA_Role_Assignment__c>> accountRoles)
    {
    	Map<Id, List<AccountTeamMember>> accountTeamMembers = new Map<Id, List<AccountTeamMember>>();
    	
    	if(accountRoles != NULL)
    	{
	    	for(Id accountId : accountRoles.keySet())
	    	{
	    		for(ATA_Role_Assignment__c objATARoleAssignment : accountRoles.get(accountId))
	    		{
	    			AccountTeamMember objATM = getAccountTeamMember(objATARoleAssignment.Role_Name__c, mapAccounts.get(accountId), objATARoleAssignment.Assignment_Mechanism__c, objATARoleAssignment.Account_FieldName_Nongeographic__c);
	    			if(objATM != NULL){
	    				if(accountTeamMembers.containsKey(accountId))
	    				{
	    					List<AccountTeamMember> lstAlreadyAddedMembers = accountTeamMembers.get(accountId);
	    					lstAlreadyAddedMembers.add(objATM); 
	    					accountTeamMembers.put(accountId, lstAlreadyAddedMembers);
	    				}else{
	    					accountTeamMembers.put(accountId, new List<AccountTeamMember>{objATM});
	    				}
	    			}
	    		}
	    	}
	    	
	    	return accountTeamMembers;
    	}
    	
    	return null;
    }

    public static AccountTeamMember getAccountTeamMember(String roleName, Account objAccount, String mechanism, String nonGeoFieldName)
    {
    	if(!String.isEmpty(roleName) && objAccount != NULL && !String.isEmpty(mechanism))
    	{
    		String dtn;
    		if(mechanism == 'Geographic PostalCode')
    		{
    			List<ATA_Geographic_Assignment__c> lstGeographicAssignment = [SELECT Id, DTN__c 
																				FROM ATA_Geographic_Assignment__c
																				WHERE Role_Name__c =: roleName
																				AND PostalCode__c =: objAccount.BillingPostalCode];
    			
    			dtn = lstGeographicAssignment[0].DTN__c;
    		
    		}
    		
    		// *** conditions for other geo fields *** //
    		
    		
    		if(mechanism == 'Name Match' && !String.isBlank(nonGeoFieldName))
    		{
    			List<ATA_Non_Geographic_Assignment__c> lstNonGeographicAssignment = [SELECT Id, DTN__c 
																						FROM ATA_Non_Geographic_Assignment__c
																						WHERE Account_FieldName__c =: nonGeoFieldName
																						AND Account_FieldValue__c =: String.valueOf(objAccount.get(nonGeoFieldName))];
												
				dtn = lstNonGeographicAssignment[0].DTN__c;								
    		}
    		
    		if(!String.isBlank(dtn))
    		{
				AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = roleName, UserId = userMap.get(dtn).Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
				
				return objATM;	    			
    		}	
    	}
    	return null;
    }
    
    private class ATA_AccountRuleValue 
    {
		String ruleType;								 // ruleType
		String fieldset;								 // fieldSet
		Map<String, String> fieldApiName_fieldValue_Map; // collection for fieldnames, fieldvalue pairs that go with the Fieldset
    }
}