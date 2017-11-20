public with sharing class ATA_Utility {
// Methods for determing AssignmentType, gathering the role collection per AssignmentType, gathering the 
// collection of users using the RoleAssignmentType and the UserTerritoryRole mapping in the org, 
// and finally to update the AccountTeamMemberTable from the final collection of User, AccountTeamRoleName, and Sharing settings - through the 
// AccountTeamMember Table.


    private static AccountAutomationSetting__c customSettings;
    
    public static AccountAutomationSetting__c ATACustomSettings()
    {
    		// Usage: ATACustomSettings.IsTriggerOff__c
        customSettings = AccountAutomationSetting__c.getInstance();
        if(customSettings == null){
            customSettings = AccountAutomationSetting__c.getOrgDefaults();
        }
        return customSettings;
	}
	
	public static list<ErrorMessagesType> catchedException = new list<ErrorMessagesType>();
	
	public class ErrorMessagesType {
        String errorMessageCode{get;set;}
        String errorMessageDescription{get;set;}
    }
    
	public static void ATAListOfException(String errorMsg, String errorCode){
        system.debug('ATA Exception Occured  '+errorMsg);
        ErrorMessagesType tmpExceptionObject = new ErrorMessagesType();
        tmpExceptionObject.errorMessageCode = errorCode;
        tmpExceptionObject.errorMessageDescription = errorMsg;
        catchedException.add(tmpExceptionObject);
    }
	
	public List<string> valid_ATA_AssignmentTypes;
	
	//public List<string> getActiveATARuleFieldSet(String ruleType) { 

		// returns the list of Field api names which are active for the given ruleType.
	
	//}
	
	//public List<ATA_Assignment_Type__c> getValidAssignmentTypes( string valid_ATA_AssignmentTypes) {
		
		
	//}
	
	//public 

}