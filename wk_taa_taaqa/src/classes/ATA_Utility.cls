public with sharing class ATA_Utility 
{
	// *** Utility class for ATA 2.0

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
}