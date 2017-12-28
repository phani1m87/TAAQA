/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/27/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
@isTest
public class ATA_TestDateFactory 
{
	// *** test data factory class for ATA
	
    public static Account create_Account() 
    {
        // create Account
        Account acctObj = new Account(
            Name = 'ATA_TEST_ACCOUNT', 
            BillingStreet = '25 Upland Drive',
            BillingPostalCode = '94127',
            BillingCountry = 'USA',
            BillingCity = 'San Francisco',
            Market_Segment__c = 'Accounting Firms');
            
        return acctObj;
    }
	
   	public static AccountAutomationSetting__c create_ATACustomSetting()
    {
        // create ATA custom setting
        AccountAutomationSetting__c t = new AccountAutomationSetting__c( 
	        BatchJobAdmin__c = 'test@example.com',
	        ExcludedAccountRecordTypeForUpdate__c = 'Partner Account',
	        GeneralDataSizeInBatchJob__c = 200,
	        ATA_RuleType__c = 'ATA',
	        IsTriggerOff__c = false);
        
        insert t;
        
        return t;
    }
    
    public static ATA_Rule__c create_ATARule(String fieldAPIName) 
    {
        // create ATA Rule 
        ATA_Rule__c ruleObj = new ATA_Rule__c(
        	Rule_Type__c = 'ATA',
            FieldSet__c = fieldAPIName.replace('__c', ''), 
            Field_API_Name__c = fieldAPIName,
            Sobject__c = 'Account',
            Rule_Enabled__c = true);
            
        return ruleObj;
    }
    
    public static ATA_AssignmentType_Map__c create_ATAAssignmentType(String assignmentType, String ruleType, String fieldSet, String fieldAPIName, String fieldValue) 
    {
        // create ATA AssignmentType Map
        return null;
    }
    
    public static ATA_Role_Assignment__c create_ATARoleAssignment(String assignmentType, String roleAssignmentType, String roleName, String assignmentMechanism) 
    {
        // create ATA Role Assignment
        return null;
    }
    
    public static ATA_Geographic_Assignment__c create_ATAGeographicAssignment(String postalCode, String roleName, String dtn) 
    {
        // create ATA Geo Assignment
        return null;
    }
    
    public static ATA_Non_Geographic_Assignment__c create_ATANongeographicAssignment(String assignmentType, String fieldAPIName, String fieldValue, String roleName, String dtn, String roleAssignmentType) 
    {
        // create ATA Non geo Assignment
        return null;
    }
}