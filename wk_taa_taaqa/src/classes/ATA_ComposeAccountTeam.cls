/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/27/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_ComposeAccountTeam
{
    // ***** contains the logic to compute the Account Team for given Accounts
    
    static Map<Id, List<ATA_AccountRuleValue>> mapAccountIdNListATA_AccountRuleValue = new Map<Id, List<ATA_AccountRuleValue>>();
    static Map<String, User> mapUserDTNAndUser = new Map<String, User>();
    static Set<String> validAssignmentTypeSet = new Set<String>();
    static Map<Id, sObject> newMapAccounts = new Map<Id, Account>();
    static Map<Id, Account> oldMapAccounts = new Map<Id, Account>();
    static Map<Id, List<AccountTeamMember>> accountNAccountTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
    static Boolean terminateAccountTeamAssignment = false;
    public static List<Monitoring_Log__c> lstMonitoringLog = new List<Monitoring_Log__c>();
    static Set<String> setMandatoryRole = new Set<String>();
    
    //*** Constructor
    public ATA_ComposeAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
    {
        String accountFieldAPINames = '';
        Monitoring_Log__c objLog;
		Set<String> accountFields = Schema.SObjectType.Account.fields.getMap().keySet();
		
        // get list of valid users
        List<User> lstUsers = [SELECT Id, DTN__c, IsActive, Custodial_Rep__c FROM User WHERE DTN__c != NULL];
        
        for(User objUser : lstUsers){ // build map DTN and User
            mapUserDTNAndUser.put(objUser.DTN__c, objUser); 
        }           
        
        // query active ATA Rules
        List<ATA_Rule__c> lstATARules = [SELECT Id, Rule_Type__c, FieldSet__c, Field_API_Name__c 
                                            FROM ATA_Rule__c 
                                            WHERE Rule_Enabled__c = true];
                                            
        Map<String, Set<String>> mapFieldSetNFieldAPINames = new Map<String, Set<String>>();
        
        // loop through ATA Rules to build map of fieldSet and FieldAPINames
        for(ATA_Rule__c rule : lstATARules)
        {
            if(accountFields.contains(rule.Field_API_Name__c.toLowerCase()))
            {
	            if(mapFieldSetNFieldAPINames.containsKey(rule.FieldSet__c)){
	                Set<String> setFieldAPINames = mapFieldSetNFieldAPINames.get(rule.FieldSet__c);
	                setFieldAPINames.add(rule.Field_API_Name__c);
	                mapFieldSetNFieldAPINames.put(rule.FieldSet__c, setFieldAPINames);
	            }else{
	                mapFieldSetNFieldAPINames.put(rule.FieldSet__c, new Set<String>{rule.Field_API_Name__c});   
	            } // end if then else
	            accountFieldAPINames = accountFieldAPINames + ' ' + rule.Field_API_Name__c + ',';
            }else{
            	objLog = ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'ATA_ComposeAccountTeam', ATA_Constants.ATA_RULE_INCONSISTANCY_MESSAGE + ' Incorrect Field: ' + rule.Field_API_Name__c, null, ATA_Constants.ATA_RULE_INCONSISTANCY_CODE);
            	terminateAccountTeamAssignment = true;
            }
            //setFieldAPINames.add(rule.Field_API_Name__c);
        } // end for
        
        // STOP since some abrupt condition happened above
        if(terminateAccountTeamAssignment)
        {
			for(Id accountId : newMap.keySet())
			{
				objLog.Account__c = String.valueOf(accountId);
				lstMonitoringLog.add(objLog);		
			}        	
        }else{ 
	        accountFieldAPINames = accountFieldAPINames.subString(0, accountFieldAPINames.length() - 1);
	        
	        System.debug('###: ' + accountFieldAPINames);
	        System.debug('###: ' + mapFieldSetNFieldAPINames);
	        
	        Set<Id> keys = newMap.keySet();
	        String query = 'SELECT Id, Name, RecordTypeId, BillingPostalCode, BillingState, BillingCountry,' + accountFieldAPINames + ' FROM Account WHERE Id IN: keys';
	        System.debug('## : ' + query); 
	        //newMapAccounts = new Map<Id, Account>([SELECT Id, Name, BillingPostalCode, BillingState, BillingCountry, Market_Segment__c, Market_Sub_Segment__c, Named_Account_Type__c, Named_Account__c FROM Account WHERE Id IN: newMap.keySet()]); // keep new map preserved in the memory
	        newMapAccounts = new Map<Id, sObject>(Database.Query(query)); // query new map to be preserved in the memory
	        oldMapAccounts = oldMap; // keep old map preserved in the memory
	        
	        // loop through accounts to build structure of ATA_AccountRuleValue map     
	        for(Id accountId : newMapAccounts.keySet())
	        {
	            Boolean isChanged = false;                  // flag used to indicate if there is change\
	            Boolean isNew = false;
	            String ruleType;                            // ruleType
	            String logMessage = '';
	            ATA_AccountRuleValue newAccountRule = NULL; // ATA_AccountRuleValue
	            
	            // if oldMap not empty means its an Account Update event so check if there is a change
	            if(oldMapAccounts != NULL) 
	            {
	                // *** BillingPostalCode is not part of ATA_Rule__c but needs to check if it is changed to compute the AccountTeam
	                lstATARules.add(new ATA_Rule__c(Rule_Type__c = 'ATA', Field_API_Name__c = 'BillingPostalCode'));
	                
	                for(ATA_Rule__c rule : lstATARules) // loop through ATA Rules
	                {
	                    // compare rule fields
	                    if(newMapAccounts.get(accountId).get(rule.Field_API_Name__c) != oldMapAccounts.get(accountId).get(rule.Field_API_Name__c))
	                    {
	                        isChanged = true;               // set if there is a change
	                        ruleType = rule.Rule_Type__c;   // capture ruleType
	                        logMessage = logMessage + '\n Field Name: ' + rule.Field_API_Name__c + ' Old Value: ' + String.valueOf(oldMapAccounts.get(accountId).get(rule.Field_API_Name__c)) + ' New Value: ' + String.valueOf(newMapAccounts.get(accountId).get(rule.Field_API_Name__c));
	                        break;                          // break the loop since we know there is a change
	                    } // end if
	                } // end for
	            }else{ // oldMap is empty means its an Account Insert event
	                isChanged = true;                       // set if there is a change
	                isNew = true;
	                ruleType = lstATARules[0].Rule_Type__c; // capture ruleType
	            } // end if then else
	            
	            // isChanges = TRUE
	            if(isChanged)
	            {
	                // loop through the map of fielSet and fieldAPINames
	                for(String fieldSet : mapFieldSetNFieldAPINames.keySet())
	                {
	                    newAccountRule = new ATA_AccountRuleValue();  
	                    newAccountRule.ruleType = ruleType;             // assign ruleType
	                    newAccountRule.fieldset = fieldSet;             // assign fieldSet
	                    newAccountRule.fieldApiName_fieldValue_Map = new Map<String, String>();
	                    for(String fieldAPIName : mapFieldSetNFieldAPINames.get(fieldSet))
	                    {
	                        //if(newMapAccounts.get(accountId).get(fieldAPIName) != NULL)
	                        //{
		                        // collect the fieldAPINames & fieldValues
		                        newAccountRule.fieldApiName_fieldValue_Map.put(fieldAPIName, String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName)));
		                        if(isNew){
		                        	logMessage = logMessage + '\n Field Name: ' + fieldAPIName + ' Value: ' + String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName));
		                        }
	                        //}
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
	                System.debug('###: ' + lstMonitoringLog);
	                lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'ATA_ComposeAccountTeam', logMessage, String.valueOf(accountId), ATA_Constants.ATA_ACCOUNT_DATA_CHANGEDETECTED_CODE));
	            } // end if
	        } // end for
        }
        System.debug('###: ' + mapAccountIdNListATA_AccountRuleValue);
    }
    
    // *** just returns the map constructed by constructor 
    public static Map<Id, List<AccountTeamMember>> composeAccountTeam() 
    {
        Map<Id, Set<String>> validAssignmnentTypesMap;
        Map<Id, List<AccountTeamMember>> accountNRuleDerivedAccountTeamMap;
        
        // STOP since some abrupt condition in earlier stage
        if(!terminateAccountTeamAssignment)
        {
        	// **** get the valid assignment type (internally gets ATA_Rule__c, computes the assignment types and returns)
			validAssignmnentTypesMap = getAssignmentTypes(mapAccountIdNListATA_AccountRuleValue);
        }
        
        // STOP since some abrupt condition happened in earlier stage
        if(validAssignmnentTypesMap != NULL && !terminateAccountTeamAssignment)
        {
        	
        	if(ATA_Utility.ATACustomSettings() != NULL && !String.isBlank(ATA_Utility.ATACustomSettings().Terminate_Account_Team_Role_Names__c)){
        		setMandatoryRole = (Set<String>)System.JSON.deserialize(ATA_Utility.ATACustomSettings().Terminate_Account_Team_Role_Names__c, Set<String>.class);
        	}
        	
        	// **** get the map of AccountId and associated rule derived Account Teams (internally computes role and then forms the AccountTeamMember based on Geo / Non-geo mechanism)
			accountNRuleDerivedAccountTeamMap = getListAccountTeamMembers(validAssignmnentTypesMap);
        }
        return accountNRuleDerivedAccountTeamMap;
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
                
                if(lstAssignmentTypeMap != NULL && lstAssignmentTypeMap.size() > 0)
                {
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
                }/*
                else{
                	lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'ATA_ComposeAccountTeam', ATA_Constants.ATA_DATA_MISSING_ASSIGNMENTTYPE_MESSAGE, String.valueOf(accountId), ATA_Constants.ATA_DATA_MISSING_ASSIGNMENTTYPE_CODE));
                }*/
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
                
                // no roles for an account so log
                if(!(accountGeographicRoles.containsKey(accountId)) && !(accountNongeographicRoles.containsKey(accountId)))
                {
					lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'getListAccountTeamMembers', ATA_Constants.ATA_DATA_MISSING_ROLES_MESSAGE, String.valueOf(accountId), ATA_Constants.ATA_DATA_MISSING_ROLES_CODE));
                }
                
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
                    AccountTeamMember objATM = prepareAccountTeamMemberRecord(objATARoleAssignment.Role_Name__c, (Account)newMapAccounts.get(accountId), objATARoleAssignment.Assignment_Mechanism__c, objATARoleAssignment.Account_FieldName_Nongeographic__c);
                    
                    if(objATM != NULL) // it should not NULL to add in the collection
                    {
                        if(accountNAccountTeamMembersMap.containsKey(accountId))
                        {
                            List<AccountTeamMember> lstAlreadyAddedMembers = accountNAccountTeamMembersMap.get(accountId);
                            lstAlreadyAddedMembers.add(objATM); 
                            accountNAccountTeamMembersMap.put(accountId, lstAlreadyAddedMembers);
                        }else{
                            accountNAccountTeamMembersMap.put(accountId, new List<AccountTeamMember>{objATM});
                        } //end if then else 
                    }else if(terminateAccountTeamAssignment){
                    	// STOP since engine could not locate the user for mandatory role
                    	accountNAccountTeamMembersMap.remove(accountId);
                    	// set the flag to false so it should not affect other accounts
                    	terminateAccountTeamAssignment = false;
                    	break;
                    } // end if then else
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
            
            // Geographic mechanism
            if(String.isBlank(nonGeoFieldName))
            {
	            List<ATA_Geographic_Assignment__c> lstGeographicAssignment;
	            String logMessage;
	            //*** Geographic PostalCode mechanism
	            if(mechanism == 'Geographic PostalCode')
	            {
	                lstGeographicAssignment = [SELECT Id, DTN__c 
	                                            FROM ATA_Geographic_Assignment__c
	                                            WHERE Role_Name__c =: roleName
	                                            AND PostalCode__c =: objAccount.BillingPostalCode
	                                            AND Role_Name__c =: roleName];
	            	
	            	logMessage = 'Postal Code = ' + objAccount.BillingPostalCode;
	            }
	            
	            //*** Geographic County mechanism 
	            if(mechanism == 'Geographic County')
	            {
	                lstGeographicAssignment = [SELECT Id, DTN__c 
	                                            FROM ATA_Geographic_Assignment__c
	                                            WHERE Role_Name__c =: roleName
	                                            AND County__c =: objAccount.Billing_County__c
	                                            AND Role_Name__c =: roleName];
	            
	            	logMessage = 'County = ' + objAccount.Billing_County__c;
	            }
	            
	            //*** Geographic State mechanism
	            if(mechanism == 'Geographic State')
	            {
	                lstGeographicAssignment = [SELECT Id, DTN__c 
	                                            FROM ATA_Geographic_Assignment__c
	                                            WHERE Role_Name__c =: roleName
	                                            AND State__c =: objAccount.BillingState
	                                            AND Role_Name__c =: roleName];
	                
	            	logMessage = 'State = ' + objAccount.BillingState;
	            }
	            
	            //*** Geographic Region mechanism
	            if(mechanism == 'Geographic Region')
	            {
	                // Technical Debt: which field on Account address should be checked for region
	                /*
	                lstGeographicAssignment = [SELECT Id, DTN__c 
	                                            FROM ATA_Geographic_Assignment__c
	                                            WHERE Role_Name__c =: roleName
	                                            AND State__c =: objAccount.BillingState];
	                */
	            
	            }
	            
	            //*** Geographic Country mechanism
	            if(mechanism == 'Geographic Country')
	            {
	                lstGeographicAssignment = [SELECT Id, DTN__c 
	                                            FROM ATA_Geographic_Assignment__c
	                                            WHERE Role_Name__c =: roleName
	                                            AND Country__c =: objAccount.BillingCountry
	                                            AND Role_Name__c =: roleName];
	                
	            	logMessage = 'Country = ' + objAccount.BillingCountry;
	            }
	            
	            if(lstGeographicAssignment != NULL && lstGeographicAssignment.size() > 0){
	                dtn = lstGeographicAssignment[0].DTN__c;
	            }else{
                	lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_WARNING_MISSINGDTN_GEOGRAPHIC_ROLE_MESSAGE + roleName + ' for ' + logMessage, String.valueOf(objAccount.Id), ATA_Constants.ATA_WARNING_MISSINGDTN_GEOGRAPHIC_ROLE_CODE));
                } 
            }else{
	            //*** Non-geographic mechanism
                List<ATA_Non_Geographic_Assignment__c> lstNonGeographicAssignment = [SELECT Id, DTN__c 
                                                                                        FROM ATA_Non_Geographic_Assignment__c
                                                                                        WHERE Account_FieldName__c =: nonGeoFieldName
                                                                                        AND Account_FieldValue__c =: String.valueOf(objAccount.get(nonGeoFieldName))
                                                                                        AND RoleName__c =: roleName];
                if(lstNonGeographicAssignment.size() > 0){
                    dtn = lstNonGeographicAssignment[0].DTN__c;
                }else{
                	lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_MESSAGE + ' ' + nonGeoFieldName + ' = ' + String.valueOf(objAccount.get(nonGeoFieldName)), String.valueOf(objAccount.Id), ATA_Constants.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_CODE));
                	terminateAccountTeamAssignment = true;
                }                                   
            }
            
            if(!String.isBlank(dtn))
            {
	            if(!(mapUserDTNAndUser.containsKey(dtn)))
	            {
	            	Boolean isRoleMandatory = registerIndeterminantAssignment(roleName);
	            	if(isRoleMandatory){
	            		lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_ABORT_MISSINGUSER_MANDATORYROLE_MESSAGE + ' Role Name: ' + roleName + ' DTN: ' + dtn, String.valueOf(objAccount.Id), ATA_Constants.ATA_ABORT_MISSINGUSER_MANDATORYROLE_CODE));
	            		terminateAccountTeamAssignment = true;
	            	}else{
	            		lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_WARNING_MISSINGUSER_ROLE_MESSAGE + ' Role Name: ' + roleName + ' DTN: ' + dtn, String.valueOf(objAccount.Id), ATA_Constants.ATA_WARNING_MISSINGUSER_ROLE_CODE));
	            	}
	            }else{
		            //*** if we get the DTN and its valid then prepare AccountTeamMember
	                AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = roleName, UserId = mapUserDTNAndUser.get(dtn).Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
	                return objATM;                  
	            } 
            }  
        }
        return null;
    }
    
    private static Boolean registerIndeterminantAssignment(String roleName)
    {
    	Boolean isRoleMandatory = false;
    	
    	if(setMandatoryRole.size() > 0)
    	{
    		if(setMandatoryRole.contains(roleName)){
    			isRoleMandatory = true;
    		}	
    	}
    	
    	return isRoleMandatory;
    }
    
    private class ATA_AccountRuleValue 
    {
        String ruleType;                                 // ruleType
        String fieldset;                                 // fieldSet
        Map<String, String> fieldApiName_fieldValue_Map; // collection for fieldnames, fieldvalue pairs that go with the Fieldset
    }
}