public with sharing class ATA_ComposeAccountTeam {
    // Contains the logic to create the Account Team for a given Account
    Map<Id, List<ATA_AccountRuleValue>> mapAccountIdNListATA_AccountRuleValue = new Map<Id, List<ATA_AccountRuleValue>>();
    public ATA_ComposeAccountTeam(List<Account> newAccountList, Map<Id, Account> oldMap)
    {
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
		}
		
    	for(Account account : newAccountList)
    	{
    		Boolean isChanged = false;
    		String ruleType;
    		ATA_AccountRuleValue newAccountRule = NULL;
    		for(ATA_Rule__c rule : lstATARules)
    		{
    			if(account.get(rule.Field_API_Name__c) != oldMap.get(account.Id).get(rule.Field_API_Name__c))
    			{
    				isChanged = true;
    				ruleType = rule.Rule_Type__c;
    			}
    		}
    		
    		if(isChanged)
    		{
    			newAccountRule = new ATA_AccountRuleValue();
    			newAccountRule.ruleType = ruleType;
    			for(String fieldSet : mapFieldSetNFieldAPINames.keySet())
    			{
	    			newAccountRule.fieldset = fieldSet;
	    			newAccountRule.fieldApiName_fieldValue_Map = new Map<String, String>();
	    			for(String fieldAPIName : mapFieldSetNFieldAPINames.get(fieldSet))
	    			{
	    				if(account.get(fieldAPIName) != NULL){
	    					newAccountRule.fieldApiName_fieldValue_Map.put(fieldAPIName, String.valueOf(account.get(fieldAPIName)));
	    				}
	    			}
    			}
    		}
    		
    		if(newAccountRule != NULL)
    		{
    			if(mapAccountIdNListATA_AccountRuleValue.containsKey(account.Id)){
    				//mapAccountIdNListATA_AccountRuleValue.put(account.Id, mapAccountIdNListATA_AccountRuleValue.get(account.Id).add(newAccountRule));
    			}else{
    				//mapAccountIdNListATA_AccountRuleValue.put(account.Id, new List<ATA_AccountRuleValue>{newAccountRule});
    			}
    		}
    	}
    }
    
    
    private class ATA_AccountRuleValue {
    		string ruleType;
    		string fieldset;
    		map <string, string> fieldApiName_fieldValue_Map; // collection for fieldnames, fieldvalue pairs that go with the Fieldset
    }
    
    
    public static map <string, ATA_AccountRuleValue> createAccountRoleValueMap () {
    	
    		map <string, ATA_AccountRuleValue> ATA_AccountRuleValueMap;
    		
    		return ATA_AccountRuleValueMap;
    	
    }
    
    public static map<string, List<string>> getAssignmentTypes( map <string, ATA_AccountRuleValue> AccountRuleValueMaop) {
    	
    		map<string, List<string>> validAssignmnentTypesMap;
    		
    		return validAssignmnentTypesMap;
    }
    
    
    
}