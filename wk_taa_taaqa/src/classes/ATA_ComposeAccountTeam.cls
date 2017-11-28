public with sharing class ATA_ComposeAccountTeam {
    
    // Contains the logic to create the Account Team for a given Account
   	static Map<Id, List<ATA_AccountRuleValue>> mapAccountIdNListATA_AccountRuleValue = new Map<Id, List<ATA_AccountRuleValue>>();
    static Set<String> setFieldAPINames = new Set<String>();
    static Set<String> setFieldValues = new Set<String>();
    static Map<String, User> userMap = new Map<String, User>();
    static Set<String> validAssignmentTypeSet = new Set<String>();
    static Map<Id, Account> newMapAccounts = new Map<Id, Account>();
    static Map<Id, Account> oldMapAccounts = new Map<Id, Account>();
    static Map<Id, List<AccountTeamMember>> accountNAccountTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
    
    //*** Constructor
    public ATA_ComposeAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
    {
		newMapAccounts = new Map<Id, Account>([SELECT Id, Name, BillingPostalCode, BillingState, BillingCountry, Market_Segment__c, Market_Sub_Segment__c, Named_Account_Type__c, Named_Account__c FROM Account WHERE Id IN: newMap.keySet()]); // keep new map preserved in the memory
		oldMapAccounts = oldMap; // keep old map preserved in the memory
		
		// get list of valid users
		List<User> lstUsers = [SELECT Id, DTN__c FROM User WHERE DTN__c != NULL];
		
		for(User objUser : lstUsers){ // build map DTN and User
			userMap.put(objUser.DTN__c, objUser);	
		}	    	
    	
    	// query active ATA Rules
    	List<ATA_Rule__c> lstATARules = [SELECT Id, Rule_Type__c, FieldSet__c, Field_API_Name__c 
    										FROM ATA_Rule__c 
    										WHERE Rule_Enabled__c = true];
    										
    	Map<String, Set<String>> mapFieldSetNFieldAPINames = new Map<String, Set<String>>();
    	
    	// loop through ATA Rules to build map of fieldSet and FieldAPINames
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
		
		// loop through accounts to build structure of ATA_AccountRuleValue map		
    	for(Id accountId : newMap.keySet())
    	{
    		Boolean isChanged = false; 					// flag used to indicate if there is change
    		String ruleType;							// ruleType
    		ATA_AccountRuleValue newAccountRule = NULL; // ATA_AccountRuleValue
    		
    		// if oldMap not empty means its an Account Update event so check if there is a change
    		if(oldMap != NULL) 
    		{
	    		for(ATA_Rule__c rule : lstATARules) // loop through ATA Rules
	    		{
	    			// compare rule fields
	    			if(newMap.get(accountId).get(rule.Field_API_Name__c) != oldMap.get(accountId).get(rule.Field_API_Name__c))
	    			{
	    				isChanged = true; 				// set if there is a change
	    				ruleType = rule.Rule_Type__c;	// capture ruleType
	    				break;							// break the loop since we know there is a change
	    			}
	    		}
    		}else{ // oldMap is empty means its an Account Insert event
    			isChanged = true; 						// set if there is a change
    			ruleType = lstATARules[0].Rule_Type__c; // capture ruleType
    		}
    		
    		// isChanges = TRUE
    		if(isChanged)
    		{
    			// loop through the map of fielSet and fieldAPINames
    			for(String fieldSet : mapFieldSetNFieldAPINames.keySet())
    			{
    				newAccountRule = new ATA_AccountRuleValue();  
    				newAccountRule.ruleType = ruleType; 			// assign ruleType
	    			newAccountRule.fieldset = fieldSet;				// assign fieldSet
	    			newAccountRule.fieldApiName_fieldValue_Map = new Map<String, String>();
	    			for(String fieldAPIName : mapFieldSetNFieldAPINames.get(fieldSet))
	    			{
    					// collect the fieldAPINames & fieldValues
    					newAccountRule.fieldApiName_fieldValue_Map.put(fieldAPIName, String.valueOf(newMap.get(accountId).get(fieldAPIName)));
    					if(newMap.get(accountId).get(fieldAPIName) != NULL){
    						setFieldValues.add(String.valueOf(newMap.get(accountId).get(fieldAPIName)));
    					}
	    			} // end for
	    			
	    			// build a collection of ATA_AccountRule for an Account
	    			if(newAccountRule != NULL)
		    		{
		    			if(mapAccountIdNListATA_AccountRuleValue.containsKey(accountId)){
		    				List<ATA_AccountRuleValue> lstAccountRule = mapAccountIdNListATA_AccountRuleValue.get(accountId);
		    				lstAccountRule.add(newAccountRule);
		    				mapAccountIdNListATA_AccountRuleValue.put(accountId, lstAccountRule);
		    			}else{
		    				mapAccountIdNListATA_AccountRuleValue.put(accountId, new List<ATA_AccountRuleValue>{newAccountRule});
		    			} // end if then else
		    		} // end if
    			} // end for
    		} // end if
    	} // end for
    	
    	System.debug('###: ' + mapAccountIdNListATA_AccountRuleValue);
    }
    
    // *** just returns the map constructed by constructor 
    public static Map<Id, List<ATA_AccountRuleValue>> createAccountRoleValueMap() 
    {
		return mapAccountIdNListATA_AccountRuleValue;
    }
    
    // *** get assignment types based on ATA_AccountRuleValue map
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
		System.debug('## : ' + validAssignmentTypeSet);
		return validAssignmnentTypesMap;
    }
	
	// *** get role assignments and then prepare AccountTeamMembers for list of Accounts
    public static Map<Id, List<AccountTeamMember>> getListAccountTeamMembers(Map<Id, Set<String>> accountAssignmentType) 
    {
    	// input parameter is required
    	if(accountAssignmentType != NULL && accountAssignmentType.size() > 0)
    	{
	    	// *** get role assignments
	    	
	    	Map<Id, Set<ATA_Role_Assignment__c>> accountGeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
	    	Map<Id, Set<ATA_Role_Assignment__c>> accountNongeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
	    	
	    	// query ATA Role Assignment for valid assignment types 
	    	List<ATA_Role_Assignment__c> lstRoleAssignments = [SELECT Id, Role_Name__c, Role_Assignment_Type__c, Assignment_Type__c, Assignment_Mechanism__c, Account_FieldName_Nongeographic__c
	    														FROM ATA_Role_Assignment__c
	    														WHERE Assignment_Type__c IN: validAssignmentTypeSet];
	    	
	    	for(Id accountId : accountAssignmentType.keySet()) // loop through the accounts
	    	{ 
	    		for(ATA_Role_Assignment__c objRoleAssignment : lstRoleAssignments) // loop through the ATA Role Assignments
	    		{
	    			if(objRoleAssignment.Account_FieldName_Nongeographic__c == NULL) // check if it's geographic / non-geo
	    			{
		    			if(accountAssignmentType.get(accountId).contains(objRoleAssignment.Assignment_Type__c)) // filter out the ATA Role Assignments for valid assignment types
		    			{
		    				if(accountGeographicRoles.containsKey(accountId))
		    				{
		    					Set<ATA_Role_Assignment__c> alreadyAddedRoles = accountGeographicRoles.get(accountId);
		    					alreadyAddedRoles.add(objRoleAssignment);
		    					accountGeographicRoles.put(accountId, alreadyAddedRoles);
		    				}else{
		    					accountGeographicRoles.put(accountId, new Set<ATA_Role_Assignment__c>{objRoleAssignment});
		    				} // end if then else				
		    			} // end if
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
		    				} // end if then else				
		    			} // end if
	    			} // end if then else
	    		} // end for
	    	} // end for
	    	
	    	// *** get Account Team Members based on geo & non-geo role assignments
	    	// geo role computation
	    	if(accountGeographicRoles.size() > 0)
	    	{
	    		computeAccountTeamUsingRoles(accountGeographicRoles);
	    	} // end if
	    	
	    	System.debug('###: ' + accountNongeographicRoles);
	    	
	    	// non-geo role computation
			if(accountNongeographicRoles.size() > 0)
	    	{
				computeAccountTeamUsingRoles(accountNongeographicRoles);
	    	} // end if
	    	
	    	System.debug('###: ' + accountNAccountTeamMembersMap);
	    	return accountNAccountTeamMembersMap;
    	}
    	
    	return null;	
    }
    
    public static Map<Id, List<AccountTeamMember>> computeAccountTeamUsingRoles(Map<Id, Set<ATA_Role_Assignment__c>> accountRoles)
    {
    	//*** input parameter is required
    	if(accountRoles != NULL)
    	{
	    	for(Id accountId : accountRoles.keySet()) // loop through accounts to compute the AccountTeamMembers
	    	{
	    		for(ATA_Role_Assignment__c objATARoleAssignment : accountRoles.get(accountId)) // loop through Role Assignments for the Account
	    		{
	    			AccountTeamMember objATM = prepareAccountTeamMemberRecord(objATARoleAssignment.Role_Name__c, newMapAccounts.get(accountId), objATARoleAssignment.Assignment_Mechanism__c, objATARoleAssignment.Account_FieldName_Nongeographic__c);
	    			
	    			if(objATM != NULL){ // it should not NULL to add in the collection
	    				if(accountNAccountTeamMembersMap.containsKey(accountId))
	    				{
	    					List<AccountTeamMember> lstAlreadyAddedMembers = accountNAccountTeamMembersMap.get(accountId);
	    					lstAlreadyAddedMembers.add(objATM); 
	    					accountNAccountTeamMembersMap.put(accountId, lstAlreadyAddedMembers);
	    				}else{
	    					accountNAccountTeamMembersMap.put(accountId, new List<AccountTeamMember>{objATM});
	    				} //end if then else 
	    			} // end if
	    		} // end for
	    	} // end for
	    	
	    	return accountNAccountTeamMembersMap;
    	} // end if
    	
    	return null;
    }

    public static AccountTeamMember prepareAccountTeamMemberRecord(String roleName, Account objAccount, String mechanism, String nonGeoFieldName)
    {
    	//*** all parameters are required
    	if(!String.isEmpty(roleName) && objAccount != NULL && !String.isEmpty(mechanism))
    	{
    		String dtn;
    		
    		//*** Geographic PostalCode mechanism
    		if(mechanism == 'Geographic PostalCode')
    		{
    			List<ATA_Geographic_Assignment__c> lstGeographicAssignment = [SELECT Id, DTN__c 
																				FROM ATA_Geographic_Assignment__c
																				WHERE Role_Name__c =: roleName
																				AND PostalCode__c =: objAccount.BillingPostalCode];
    			
    			dtn = lstGeographicAssignment[0].DTN__c;
    		
    		}
    		
    		//*** Geographic State mechanism
    		if(mechanism == 'Geographic State')
    		{
    			List<ATA_Geographic_Assignment__c> lstGeographicAssignment = [SELECT Id, DTN__c 
																				FROM ATA_Geographic_Assignment__c
																				WHERE Role_Name__c =: roleName
																				AND State__c =: objAccount.BillingState];
    			
    			dtn = lstGeographicAssignment[0].DTN__c;
    		
    		}
    		
    		//*** Geographic Region mechanism
    		// Technical Debt: which field on Account address should be checked for region
    		
    		//*** Geographic County mechanism 
    		// Technical Debt: which field on Account address should be checked for county
    		
    		//*** Geographic Country mechanism
    		if(mechanism == 'Geographic Country')
    		{
    			List<ATA_Geographic_Assignment__c> lstGeographicAssignment = [SELECT Id, DTN__c 
																				FROM ATA_Geographic_Assignment__c
																				WHERE Role_Name__c =: roleName
																				AND Country__c =: objAccount.BillingCountry];
    			
    			dtn = lstGeographicAssignment[0].DTN__c;
    		
    		}
    		
    		
    		//*** Non-geographic 'Name Match' mechanism
    		if(mechanism == 'Name Match' && !String.isBlank(nonGeoFieldName))
    		{
    			List<ATA_Non_Geographic_Assignment__c> lstNonGeographicAssignment = [SELECT Id, DTN__c 
																						FROM ATA_Non_Geographic_Assignment__c
																						WHERE Account_FieldName__c =: nonGeoFieldName
																						AND Account_FieldValue__c =: String.valueOf(objAccount.get(nonGeoFieldName))];
												
				dtn = lstNonGeographicAssignment[0].DTN__c;								
    		}
    		
    		//*** if we get the DTN and its valid then prepare AccountTeamMember
    		if(!String.isBlank(dtn) && userMap.containsKey(dtn))
    		{
				AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = roleName, UserId = userMap.get(dtn).Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
				
				return objATM;	    			
    		}	
    	}
    	return null;
    }
    
   	//***** insert / update / delete DML operations on AccountTeamMember object
    public static List<Monitoring_Log__c> saveAccountTeamMembers(Map<Id, List<AccountTeamMember>> mapAccountNTeamMembers)
    {
    	List<Monitoring_Log__c> lstMonitoringLogs;
    	List<AccountTeamMember> lstAccountTeamMembers = new List<AccountTeamMember>();
    	
    	for(Id accountId : mapAccountNTeamMembers.keySet())
    	{
    		lstAccountTeamMembers.addAll(mapAccountNTeamMembers.get(accountId));
    	} 
    	
    	if(lstAccountTeamMembers.size() > 0)
    	{
    		Database.SaveResult[] memberslst = Database.insert(lstAccountTeamMembers,false);
    		
    		//**** perform DML error handling ******//
    	}
    	
    	return lstMonitoringLogs;
    }
    
    private class ATA_AccountRuleValue 
    {
		String ruleType;								 // ruleType
		String fieldset;								 // fieldSet
		Map<String, String> fieldApiName_fieldValue_Map; // collection for fieldnames, fieldvalue pairs that go with the Fieldset
    }
}