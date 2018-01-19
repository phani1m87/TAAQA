/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/27/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_ComposeAccountTeam
{
    // ***** contains the logic to compute the Account Team for given Accounts
    
    static Map<Id, List<ATA_AccountRuleValue>> mapAccountIdNListATA_AccountRuleValue;
    static Map<String, User> mapUserDTNAndUser = new Map<String, User>();
    //SMS-1012: Custodial Rep not being added
    static Map<String, User> mapUserIdandCustodialRep = new Map<String, User>();
    public static Map<Id, sObject> newMapAccounts = new Map<Id, Account>();
    static Map<Id, Account> oldMapAccounts = new Map<Id, Account>();
    static Map<Id, List<AccountTeamMember>> accountNAccountTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
    static Boolean terminateAccountTeamAssignment = false;
    static Set<String> setMandatoryRole = new Set<String>();
    static Set<String> validAssignmentTypeSet = new Set<String>();
    static Set<String> setValidFieldSets = new Set<String>();
    static Set<String> setValidFieldAPINames = new Set<String>();
    static Set<String> setValidValues = new Set<String>();
    static Map<String, ATA_Geographic_Assignment__c> mapGeoAssignments = new Map<String, ATA_Geographic_Assignment__c>();
    static Map<String, ATA_Non_Geographic_Assignment__c> mapNonGeoAssignments = new Map<String, ATA_Non_Geographic_Assignment__c>();
    
    public static List<Monitoring_Log__c> lstMonitoringLog = new List<Monitoring_Log__c>();
    
    //*** Constructor
    public ATA_ComposeAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
    {
        List<String> accountFieldAPINames = new List<String>(Account.SObjectType.getDescribe().fields.getMap().keySet());
        Monitoring_Log__c objLog;
        mapAccountIdNListATA_AccountRuleValue = new Map<Id, List<ATA_AccountRuleValue>>();
        Set<String> accountFields = Schema.SObjectType.Account.fields.getMap().keySet();
        
        // get list of valid users
        List<User> lstUsers = [SELECT Id, DTN__c,Name,IsActive, Custodial_Rep__c,Custodial_Rep__r.Name,Custodial_Rep__r.DTN__c FROM User WHERE DTN__c != NULL];
        
        for(User objUser : lstUsers){ // build map DTN and User
            mapUserDTNAndUser.put(objUser.DTN__c, objUser); 
            //SMS-1012: Custodial Rep not being added; create user id and its custodial rep map
            if(objUser.Custodial_Rep__c!=null){
                mapUserIdandCustodialRep.put(objUser.Id, objUser);
            } 
        }           
        // query active ATA Rules
        List<ATA_Rule__c> lstATARules = [SELECT Id, Rule_Type__c, FieldSet__c, Field_API_Name__c 
                                            FROM ATA_Rule__c 
                                            WHERE Rule_Enabled__c = true
                                            AND Rule_Type__c =: ATA_Utility.ATACustomSettings().ATA_RuleType__c];
                                            
                                            
        // query to see what fields changes needs to be considered for non-geo assignments
        List<ATA_Role_Assignment__c> lstNonGeoAssignments = [SELECT Id, Account_FieldName_Nongeographic__c
                                                     FROM ATA_Role_Assignment__c
                                                     WHERE Account_FieldName_Nongeographic__c != NULL];
        Set<String> setNonGeoFields = new Set<String>();
        for(ATA_Role_Assignment__c obj : lstNonGeoAssignments)
        {
            if(!setNonGeoFields.contains(obj.Account_FieldName_Nongeographic__c))
            {
                setNonGeoFields.add(obj.Account_FieldName_Nongeographic__c);
                lstATARules.add(new ATA_Rule__c(Rule_Type__c = 'ATA', Field_API_Name__c = obj.Account_FieldName_Nongeographic__c));
            } // end if
        } // end for
        setNonGeoFields.clear();
        
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
                
                setValidFieldSets.add(rule.FieldSet__c);
                setValidFieldAPINames.add(rule.Field_API_Name__c);
                
                //accountFieldAPINames = accountFieldAPINames + ' ' + rule.Field_API_Name__c + ',';
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
        }else if(lstATARules.size() > 0){ 
            //accountFieldAPINames = accountFieldAPINames.subString(0, accountFieldAPINames.length() - 1);
            
            System.debug('###: ' + accountFieldAPINames);
            System.debug('###: ' + mapFieldSetNFieldAPINames);
            
            Set<Id> keys = newMap.keySet();
            String query = 'SELECT ' + String.join(accountFieldAPINames, ',') + ' FROM Account WHERE Id IN: keys';
            System.debug('## : ' + query); 
            //newMapAccounts = new Map<Id, Account>([SELECT Id, Name, BillingPostalCode, BillingState, BillingCountry, Market_Segment__c, Market_Sub_Segment__c, Named_Account_Type__c, Named_Account__c FROM Account WHERE Id IN: newMap.keySet()]); // keep new map preserved in the memory
            newMapAccounts = new Map<Id, sObject>(Database.Query(query)); // query new map to be preserved in the memory
            oldMapAccounts = oldMap; // keep old map preserved in the memory
            
            System.debug('## : ' + newMapAccounts);
            
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
                            break;                          // break the loop since we know there is a change
                        } // end if
                    } // end for
                }else{ // oldMap is empty means its an Account Insert event
                    isChanged = true;                       // set if there is a change
                    isNew = true;                           // set isNew to TRUE since it is new account creation
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
                                if(isNew || String.valueOf(oldMapAccounts.get(accountId).get(fieldAPIName)) == String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName))){
                                    logMessage = logMessage + '\n Field Name: ' + fieldAPIName + ' Value: ' + String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName));
                                }else{
                                    if(String.valueOf(oldMapAccounts.get(accountId).get(fieldAPIName)) != String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName))){
                                        logMessage = logMessage + '\n Field Name: ' + fieldAPIName + ' Old Value: ' + String.valueOf(oldMapAccounts.get(accountId).get(fieldAPIName)) + ' New Value: ' + String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName));
                                    } // end if
                                } // end if then else
                                if(newMapAccounts.get(accountId).get(fieldAPIName) != NULL){
                                    setValidValues.add(String.valueOf(newMapAccounts.get(accountId).get(fieldAPIName)));
                                } // end if
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
                    if(String.isNotBlank(logMessage)){
                        lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'ATA_ComposeAccountTeam', logMessage, String.valueOf(accountId), ATA_Constants.ATA_ACCOUNT_DATA_CHANGEDETECTED_CODE));
                    }
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
        } // end if
        
        // STOP since some abrupt condition happened in earlier stage
        if(validAssignmnentTypesMap != NULL && !terminateAccountTeamAssignment)
        {
            
            if(ATA_Utility.ATACustomSettings() != NULL && !String.isBlank(ATA_Utility.ATACustomSettings().Terminate_Account_Team_Role_Names__c)){
                setMandatoryRole = (Set<String>)System.JSON.deserialize(ATA_Utility.ATACustomSettings().Terminate_Account_Team_Role_Names__c, Set<String>.class);
            } // end if
            
            // **** get the map of AccountId and associated rule derived Account Teams (internally computes role and then forms the AccountTeamMember based on Geo / Non-geo mechanism)
            accountNRuleDerivedAccountTeamMap = getListAccountTeamMembers(validAssignmnentTypesMap);
        } // end if
        return accountNRuleDerivedAccountTeamMap;
    }
    
    // *** get assignment types based on ATA_AccountRuleValue map
    public static Map<Id, Set<String>> getAssignmentTypes(Map<Id, List<ATA_AccountRuleValue>> accountRuleValueMap) 
    {
        Map<Id, Set<String>> validAssignmnentTypesMap = new Map<Id, Set<String>>();
        Set<String> assignmentTypeSet = new Set<String>();
        
        //*** Query the Assignment Map for the specific fieldSet and fieldAPINames & values for that fieldSet
        List<ATA_AssignmentType_Map__c> lstAssignmentTypeMap = [SELECT Assignment_Type__c, FieldSet__c, Field_API_Name__c, Field_Value__c
                                                                    FROM ATA_AssignmentType_Map__c
                                                                    WHERE FieldSet__c IN: setValidFieldSets
                                                                    AND Field_API_Name__c IN: setValidFieldAPINames
                                                                    AND Field_Value__c IN: setValidValues];
        
        if(lstAssignmentTypeMap.size() > 0)
        {
            for(Id accountId : accountRuleValueMap.keySet()) // loop over the account rule value map
            {
                for(ATA_AccountRuleValue objRuleValue : accountRuleValueMap.get(accountId)) // loop through each fielSet rule set for selected account 
                {
                    Set<String> tempAssignmentTypeSet = new Set<String>();
                    for(String fieldAPIName : objRuleValue.fieldApiName_fieldValue_Map.keySet()) // loop through each fielAPIName & Value map for the fieldSet
                    {
                        for(ATA_AssignmentType_Map__c objAssignmentType : lstAssignmentTypeMap) // loop through lstAssignmentTypeMap and find matching AssignmentType
                        {
                            if(objAssignmentType.Field_API_Name__c == fieldAPIName && objAssignmentType.Field_Value__c == objRuleValue.fieldApiName_fieldValue_Map.get(fieldAPIName)){
                                assignmentTypeSet.add(objAssignmentType.Assignment_Type__c);    
                            } // end if
                        } // end for 
                        
                        if(tempAssignmentTypeSet.size() == 0) // hold the set of AssignmentTypes matching first field in the map
                        {  
                            tempAssignmentTypeSet.addAll(assignmentTypeSet);
                            assignmentTypeSet.clear();
                        } // end if                     
                    }
                    
                    for(String assignmentType : tempAssignmentTypeSet) // loop through the assignment types to find match for combination of the fields
                    {
                        if(assignmentTypeSet.contains(assignmentType) || assignmentTypeSet.size() == 0)
                        {
                            // map of account id and associated assignment types
                            if(validAssignmnentTypesMap.containsKey(accountId)){
                                Set<String> setAssignmentTypes = validAssignmnentTypesMap.get(accountId);
                                setAssignmentTypes.add(assignmentType);
                                validAssignmnentTypesMap.put(accountId, setAssignmentTypes);
                            }else{
                                validAssignmnentTypesMap.put(accountId, new Set<String>{assignmentType});
                            } // end if then else
                            validAssignmentTypeSet.add(assignmentType);
                        } // end if   
                    } // end for
                } // end for
            } // end for        
        } // end if
        System.debug('## : ' + validAssignmnentTypesMap);
        System.debug('## : ' + validAssignmentTypeSet);
        return validAssignmnentTypesMap;
    }
    
    /*
    // *** get assignment types based on ATA_AccountRuleValue map
    public static Map<Id, Set<String>> deprecated_getAssignmentTypes(Map<Id, List<ATA_AccountRuleValue>> accountRuleValueMap) 
    {
        Map<Id, Set<String>> validAssignmnentTypesMap = new Map<Id, Set<String>>();

        for(Id accountId : accountRuleValueMap.keySet()) // loop over the account rule value map
        {
            for(ATA_AccountRuleValue objRuleValue : accountRuleValueMap.get(accountId)) // loop through each fielSet rule set for selected account 
            {
                
                //*** Technical debt SOQL in for loop
                //*** need to write the logging for different condition when work on matcher 
                
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
                        } // end if then else
                        validAssignmentTypeSet.add(String.valueOf(objAssignmentType.get('Assignment_Type__c')));            
                    } // end for
                } // end if
            } // end for
        } // end for
        System.debug('## : ' + validAssignmnentTypesMap);
        System.debug('## : ' + validAssignmentTypeSet);
        return validAssignmnentTypesMap;
    }
    */
    
    // *** get role assignments and then prepare AccountTeamMembers for list of Accounts
    public static Map<Id, List<AccountTeamMember>> getListAccountTeamMembers(Map<Id, Set<String>> accountAssignmentType) 
    {
        // input parameter is required
        if(accountAssignmentType != NULL && accountAssignmentType.size() > 0)
        {
            // *** get role assignments
            
            Map<Id, Set<ATA_Role_Assignment__c>> accountGeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
            Map<Id, Set<ATA_Role_Assignment__c>> accountNongeographicRoles = new Map<Id, Set<ATA_Role_Assignment__c>>();
            
            Set<String> geoGraphicExternalId = new Set<String>();
            Set<String> nonGeoAssignmentExternalId = new Set<String>();
            
            // query ATA Role Assignment for valid assignment types 
            List<ATA_Role_Assignment__c> lstRoleAssignments = [SELECT Id, Role_Name__c, Role_Assignment_Type__c, Assignment_Type__c, Assignment_Mechanism__c, Account_FieldName_Nongeographic__c
                                                                FROM ATA_Role_Assignment__c
                                                                WHERE Assignment_Type__c IN: validAssignmentTypeSet];
            
            for(Id accountId : accountAssignmentType.keySet()) // loop through the accounts
            { 
                // ** Get account 5 digit BillingPostalCode 
                // This will work only in case where territory assignment is done by 5 digit postal codes 
                String postalCode; 
                if(newMapAccounts.get(accountId).get('BillingPostalCode') != NULL)
                {
                    postalCode = String.valueOf(newMapAccounts.get(accountId).get('BillingPostalCode'));
                }
                if(!String.isBlank(postalCode) && postalCode.length() > 5)
                {
                    postalCode = postalCode.subString(0,5);
                }
                
                // loop through the ATA Role Assignments
                for(ATA_Role_Assignment__c objRoleAssignment : lstRoleAssignments) 
                {
                    if(objRoleAssignment.Account_FieldName_Nongeographic__c == NULL) // check if it's geographic / non-geo
                    {
                        // geo assignment
                        if(accountAssignmentType.get(accountId).contains(objRoleAssignment.Assignment_Type__c)) // filter out the ATA Role Assignments for valid assignment types
                        {
                            // add account and gepgrahic roles to the map
                            if(accountGeographicRoles.containsKey(accountId))
                            {
                                Set<ATA_Role_Assignment__c> alreadyAddedRoles = accountGeographicRoles.get(accountId);
                                alreadyAddedRoles.add(objRoleAssignment);
                                accountGeographicRoles.put(accountId, alreadyAddedRoles);
                            }else{
                                accountGeographicRoles.put(accountId, new Set<ATA_Role_Assignment__c>{objRoleAssignment});
                            } // end if then else
                            
                            // prepare geographic external id key 
                            if(String.isNotBlank(postalCode) && String.isNotBlank(objRoleAssignment.Role_Name__c) && !geoGraphicExternalId.contains(objRoleAssignment.Role_Name__c + postalCode))
                            {
                                geoGraphicExternalId.add(objRoleAssignment.Role_Name__c + postalCode);
                            }               
                        } // end if
                    }else{
                        // non - geo assignment
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
                            //nonGeoFieldName + String.valueOf(objAccount.get(nonGeoFieldName)) + roleName + 'AccountTeam';
                            nonGeoAssignmentExternalId.add(objRoleAssignment.Account_FieldName_Nongeographic__c + String.valueOf(newMapAccounts.get(accountId).get(objRoleAssignment.Account_FieldName_Nongeographic__c) + objRoleAssignment.Role_Name__c + 'AccountTeam'));             
                        } // end if
                    } // end if then else
                } // end for
                
                // no roles for an account so log
                if(!(accountGeographicRoles.containsKey(accountId)) && !(accountNongeographicRoles.containsKey(accountId)))
                {
                    lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'getListAccountTeamMembers', ATA_Constants.ATA_DATA_MISSING_ROLES_MESSAGE, String.valueOf(accountId), ATA_Constants.ATA_DATA_MISSING_ROLES_CODE));
                } // end if
                
            } // end for
            
            if(geoGraphicExternalId.size() > 0)
            {
                for(ATA_Geographic_Assignment__c objGeoAssignment : [SELECT Id, DTN__c, External_ID__c, Role_Name__c, PostalCode__c
                                                                            FROM ATA_Geographic_Assignment__c
                                                                            WHERE External_ID__c IN: geoGraphicExternalId])
                
                {
                    if(!mapGeoAssignments.containsKey(objGeoAssignment.External_ID__c))
                    {
                        mapGeoAssignments.put(objGeoAssignment.External_ID__c, objGeoAssignment);
                    }
                }
            }
            
            // *** get Account Team Members based on geo & non-geo role assignments
            // geo role computation
            if(accountGeographicRoles.size() > 0 && mapGeoAssignments.size() > 0)
            {
                computeAccountTeamUsingRoles(accountGeographicRoles);
            } // end if
            
            System.debug('###: ' + accountNongeographicRoles);
            
            if(nonGeoAssignmentExternalId.size() > 0)
            {
                for(ATA_Non_Geographic_Assignment__c objNonGeoAssignment : [SELECT Id, RoleName__c, DTN__c, External_ID__c, FieldName__c, FieldValue__c 
                                                                                        FROM ATA_Non_Geographic_Assignment__c
                                                                                        WHERE External_ID__c IN: nonGeoAssignmentExternalId])               
                {
                    if(!mapNonGeoAssignments.containsKey(objNonGeoAssignment.External_ID__c))
                    {
                        mapNonGeoAssignments.put(objNonGeoAssignment.External_ID__c, objNonGeoAssignment);
                    }
                }
            }
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
                String logMessage = '';
                for(ATA_Role_Assignment__c objATARoleAssignment : accountRoles.get(accountId)) // loop through Role Assignments for the Account
                {
                    AccountTeamMember objATM = prepareAccountTeamMemberRecord(objATARoleAssignment.Role_Name__c, (Account)newMapAccounts.get(accountId), objATARoleAssignment.Assignment_Mechanism__c, objATARoleAssignment.Account_FieldName_Nongeographic__c);
                    System.debug('###: ' + objATM);                    
                    if(objATM != NULL) // it should not NULL to add in the collection
                    {
                        //SMS-1012: Custodial Rep not being added
                        AccountTeamMember custodialAccountRep;
                        if(!mapUserIdandCustodialRep.IsEmpty() && mapUserIdandCustodialRep.containsKey(objATM.UserId) && mapUserIdandCustodialRep.get(objATM.UserId).Custodial_Rep__c != null){
                             System.debug('###: ' + objATM);
                             custodialAccountRep = addCustodialTeamMember(objATM);
                        }
                        if(!accountNAccountTeamMembersMap.containsKey(accountId))
                        {
                           accountNAccountTeamMembersMap.put(accountId, new List<AccountTeamMember>());
                        }
                        List<AccountTeamMember> lstAlreadyAddedMembers = accountNAccountTeamMembersMap.get(accountId);
                        lstAlreadyAddedMembers.add(objATM); 
                        //SMS-1012: Custodial Rep not being added
                        if(custodialAccountRep != null){
                            lstAlreadyAddedMembers.add(custodialAccountRep); 
                        }
                        accountNAccountTeamMembersMap.put(accountId, lstAlreadyAddedMembers);                     
                     }else{
                        logMessage = logMessage + ATA_Constants.ATA_WARNING_MISSING_DRIVERDATA_MESSAGE + objATARoleAssignment.Role_Name__c + ' for ' + objATARoleAssignment.Assignment_Mechanism__c + '\n';                    
                        if(terminateAccountTeamAssignment)
                        {
                            // STOP since engine could not locate the user for mandatory role
                            accountNAccountTeamMembersMap.remove(accountId);
                            // set the flag to false so it should not affect other accounts
                            terminateAccountTeamAssignment = false;
                            
                            break;
                        }   
                    } // end if then else
                } // end for
                
                if(String.isNotBlank(logMessage))
                {
                    lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', logMessage, String.valueOf(accountId), ATA_Constants.ATA_WARNING_MISSING_DRIVERDATA_CODE));
                }
            } // end for
            
            return accountNAccountTeamMembersMap;
        } // end if
        
        return null;
    }
    
    /**
    * Method Name: addCustodialTeamMember
    * Params: AccountTeamMember atmRec
    * Return Type: AccountTeamMember Custodial Account Team Member
    * This method is used to add custodial account rep to the account team
    * SMS-1012: Custodial Rep not being added
    */
    private static AccountTeamMember addCustodialTeamMember(AccountTeamMember atmRec){
        AccountTeamMember custodialAccountRep;
        if(mapUserIdandCustodialRep!=null && mapUserIdandCustodialRep.containsKey(atmRec.UserId) && mapUserIdandCustodialRep.get(atmRec.UserId).Custodial_Rep__c != null){
            //Create Custodial Rep
            String custodialRoleName = 'Cust-'+mapUserIdandCustodialRep.get(atmRec.UserId).DTN__c+'-'+atmRec.TeamMemberRole;
            custodialAccountRep = new AccountTeamMember(AccountId = atmRec.AccountId, TeamMemberRole = custodialRoleName, UserId = mapUserIdandCustodialRep.get(atmRec.UserId).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None' );
            return custodialAccountRep;    
        }
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
                    String postalCode = objAccount.BillingPostalCode;
                    if(!String.isBlank(postalCode) && postalCode.length() > 5)
                    {
                        postalCode = postalCode.subString(0,5);
                    }
                    System.debug('roleName: ' + roleName);
                    System.debug('postalCode: ' + postalCode);
                    String externalId = roleName + postalCode;
                    
                    if(mapGeoAssignments.containsKey(externalId))
                    {
                        dtn = mapGeoAssignments.get(externalId).DTN__c;
                    }
                    
                    logMessage = 'Postal Code = ' + postalCode;
                } // end if
                
                /*
                // ***** Other geo mechanism, need code change before using it
                //*** Geographic County mechanism 
                if(mechanism == 'Geographic County')
                {
                    lstGeographicAssignment = [SELECT Id, DTN__c 
                                                FROM ATA_Geographic_Assignment__c
                                                WHERE Role_Name__c =: roleName
                                                AND County__c =: objAccount.Billing_County__c];
                
                    logMessage = 'County = ' + objAccount.Billing_County__c;
                } // end if
                
                //*** Geographic State mechanism
                if(mechanism == 'Geographic State')
                {
                    lstGeographicAssignment = [SELECT Id, DTN__c 
                                                FROM ATA_Geographic_Assignment__c
                                                WHERE Role_Name__c =: roleName
                                                AND State__c =: objAccount.BillingState];
                    
                    logMessage = 'State = ' + objAccount.BillingState;
                } // end if
                
                //*** Geographic Region mechanism
                if(mechanism == 'Geographic Region')
                {
                    // Technical Debt: which field on Account address should be checked for region
                    lstGeographicAssignment = [SELECT Id, DTN__c 
                                                FROM ATA_Geographic_Assignment__c
                                                WHERE Role_Name__c =: roleName
                                                AND State__c =: objAccount.BillingState];
                } // end if
                
                //*** Geographic Country mechanism
                if(mechanism == 'Geographic Country')
                {
                    lstGeographicAssignment = [SELECT Id, DTN__c 
                                                FROM ATA_Geographic_Assignment__c
                                                WHERE Role_Name__c =: roleName
                                                AND Country__c =: objAccount.BillingCountry];
                    
                    logMessage = 'Country = ' + objAccount.BillingCountry;
                } // end if
                
                if(lstGeographicAssignment != NULL && lstGeographicAssignment.size() > 0){
                    dtn = lstGeographicAssignment[0].DTN__c;
                }
                */ 
            }else{
                //*** Non-geographic mechanism
                String externalId = nonGeoFieldName + String.valueOf(objAccount.get(nonGeoFieldName)) + roleName + 'AccountTeam';
                
                if(mapNonGeoAssignments.containsKey(externalId))
                {
                    dtn = mapNonGeoAssignments.get(externalId).DTN__c;
                }else{
                    Boolean isRoleMandatory = registerIndeterminantAssignment(roleName);
                    if(isRoleMandatory){
                        lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_ABORT_MISSINGUSER_MANDATORYROLE_MESSAGE + ' Role Name: ' + roleName + ' DTN: ' + dtn, String.valueOf(objAccount.Id), ATA_Constants.ATA_ABORT_MISSINGUSER_MANDATORYROLE_CODE));
                        terminateAccountTeamAssignment = true;
                    }else{
                        lstMonitoringLog.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_ComposeAccountTeam', 'prepareAccountTeamMemberRecord', ATA_Constants.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_MESSAGE + ' ' + nonGeoFieldName + ' = ' + String.valueOf(objAccount.get(nonGeoFieldName)), String.valueOf(objAccount.Id), ATA_Constants.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_CODE));
                    }
                    //Commenting this out as SMS-1020
                    //terminateAccountTeamAssignment = true;
                } // end if then else
            } // end if then else
            System.debug('###: ' + dtn);
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
                    } // end if then else
                }else{
                    //*** if we get the DTN and its valid then prepare AccountTeamMember
                    AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = roleName, UserId = mapUserDTNAndUser.get(dtn).Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
                    return objATM;                  
                } // end of then else 
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
            } // end if 
        } // end if
        
        return isRoleMandatory;
    }
    
    private class ATA_AccountRuleValue 
    {
        String ruleType;                                 // ruleType
        String fieldset;                                 // fieldSet
        Map<String, String> fieldApiName_fieldValue_Map; // collection for fieldnames, fieldvalue pairs that go with the Fieldset
    }
}