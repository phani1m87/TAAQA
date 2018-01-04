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
            BillingPostalCode = '94127-1007',
            BillingCountry = 'USA',
            BillingCity = 'San Francisco');
            
        return acctObj;
    }
   
    public static User create_NewUser(String dtn, Integer i)
    {
        //create user
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
         
        User u = new User();
        u.Alias = 'standt' + i;
        u.Email = i + 'standarduser@test.com'; 
        u.EmailEncodingKey = 'UTF-8'; 
        u.LastName = 'Testing'+i; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id; 
        u.TimeZoneSidKey = 'America/Los_Angeles'; 
        u.UserName = i + 'standarduser@testorg.com';
        u.DTN__c = dtn; 
        u.High_Level_Division__c = 'Research and Learning';
        u.Division__c = 'Northeast';
        u.License_Charge_To__c = 'Sales';
        u.CostCenter__c = '1110';
        insert u;
        
        return u;
    }
	
   	public static AccountAutomationSetting__c create_ATACustomSetting()
    {
        // create ATA custom setting
        AccountAutomationSetting__c t = new AccountAutomationSetting__c( 
	        ATA_RuleType__c = 'ATA',
	        BatchJobAdmin__c = 'test@example.com',
	        ATA_ExcludeAccountRecordType__c = 'Partner Account',
	        GeneralDataSizeInBatchJob__c = 200,
	        Terminate_Account_Team_Role_Names__c = '["National Solution Consultant","Strategic Solution Consultant"]',
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
            
        insert ruleObj;
        
        return ruleObj;
    }
    
    public static ATA_AssignmentType_Map__c create_ATAAssignmentType(String assignmentType, String ruleType, String fieldSet, String fieldAPIName, String fieldValue) 
    {
        // create ATA AssignmentType Map
        ATA_AssignmentType_Map__c objAssignmentType = new ATA_AssignmentType_Map__c(
        	Assignment_Type__c = assignmentType,
            Rule_Type__c = ruleType,
            FieldSet__c = fieldSet,
            Field_API_Name__c = fieldAPIName,
            Field_Value__c = fieldValue);
            
        insert objAssignmentType;
        
        return objAssignmentType;
    }
    
    public static ATA_Role_Assignment__c create_ATARoleAssignment(String assignmentType, String roleAssignmentType, String roleName, String assignmentMechanism) 
    {
        // create ATA Role Assignment
        ATA_Role_Assignment__c objRoleAssignment = new ATA_Role_Assignment__c(
        	Assignment_Type__c = assignmentType,
            Role_Assignment_Type__c = roleAssignmentType,
            Role_Name__c = roleName,
            Assignment_Mechanism__c = assignmentMechanism);
            
        insert objRoleAssignment;
        
        return objRoleAssignment;
    }
    
    public static ATA_Geographic_Assignment__c create_ATAGeographicAssignment(String postalCode, String roleName, String dtn) 
    {
        // create ATA Geo Assignment
        ATA_Geographic_Assignment__c objGeoAssignment = new ATA_Geographic_Assignment__c(
        	PostalCode__c = postalCode,
            Role_Name__c = roleName,
            DTN__c = dtn);
            
        insert objGeoAssignment;
        
        return objGeoAssignment;
    }
    
    public static ATA_Non_Geographic_Assignment__c create_ATANongeographicAssignment(String assignmentType, String fieldAPIName, String fieldValue, String roleName, String dtn, String roleAssignmentType) 
    {
        // create ATA Non geo Assignment
        ATA_Non_Geographic_Assignment__c objNongeoAssignment = new ATA_Non_Geographic_Assignment__c(
        	Type__c = assignmentType,
        	FieldName__c = fieldAPIName,
        	FieldValue__c = fieldValue,
        	RoleName__c = roleName,
        	DTN__c = dtn,
        	Role_Assignment_Type__c = roleAssignmentType);
            
        insert objNongeoAssignment;
        
        return objNongeoAssignment;
    }
}