/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/30/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public with sharing class ATA_Constants 
{
    //**** all constants related to ATA 2.0 functionality
    
    public static final String ATA_PROCESS_NAME			                           	= 'ACCOUNT TEAM AUTOMATION';
    
    public static final String ATA_MISSING_POSTAL_CODE                           	= 'ATA_MISSING_POSTALCODE';
    public static final String ATA_MISSING_POSTAL_MESSAGE                           = 'Postal code is missing.';
    public static final String ATA_MISSING_MARKETSEGMENT_SUBSEGMENT_CODE            = 'ATA_MISSING_MARKETSEGMENT_SUBSEGMENT';
    public static final String ATA_MISSING_MARKETSEGMENT_SUBSEGMENT_MESSAGE         = 'Market segment & sub-segment is missing.';

    public static final String ATA_MISSING_SIC_CODE                  				= 'ATA_MISSING_SIC';
    public static final String ATA_MISSING_SIC_MESSAGE                  			= 'SIC code is missing.';
    public static final String ATA_MISSING_NUNMBEROFEMPLOYEES_CODE   				= 'ATA_MISSING_NUNMBEROFEMPLOYEES';  
    public static final String ATA_MISSING_NUNMBEROFEMPLOYEES_MESSAGE   			= 'NumberOfEmployees is missing.';
    public static final String ATA_MISSING_ANNUALREVENUE_CODE        				= 'ATA_MISSING_ANNUALREVENUE';
    public static final String ATA_MISSING_ANNUALREVENUE_MESSAGE        			= 'AnnualRevenue is missing.';
    
    public static final String ATA_RULE_INCONSISTANCY_CODE                  		= 'ATA_RULE_INCONSISTANCY_DETECTED';
    public static final String ATA_RULE_INCONSISTANCY_MESSAGE                  		= 'Inconsistant rule detected in ATA_Rule__c.';
    
    public static final String ATA_DATA_MISSING_ASSIGNMENTTYPE_CODE                 = 'ATA_DATA_MISSING_ASSIGNMENTTYPE';
    public static final String ATA_DATA_MISSING_ASSIGNMENTTYPE_MESSAGE              = 'No AssignmentTypes in ATA_AssignmentType_Map__c.';
    
    public static final String ATA_DATA_MISSING_ROLES_CODE                 			= 'ATA_DATA_MISSING_ROLES';
	public static final String ATA_DATA_MISSING_ROLES_MESSAGE              			= 'No roles found from ATA_Role_Assignment__c.';
	
	public static final String ATA_ABORT_MISSINGUSER_MANDATORYROLE_CODE             = 'ATA_ABORT_MISSINGUSER_MANDATORYROLE';
	public static final String ATA_ABORT_MISSINGUSER_MANDATORYROLE_MESSAGE          = 'Not creating Account Team: No matching user found for mandatory role.';
	
	public static final String ATA_WARNING_MISSINGUSER_ROLE_CODE             		= 'ATA_WARNING_MISSINGUSER_ROLE';
	public static final String ATA_WARNING_MISSINGUSER_ROLE_MESSAGE            		= 'Could not find user for the role.';
	
	public static final String ATA_WARNING_MISSING_DRIVERDATA_CODE     				= 'ATA_WARNING_MISSING_DRIVERDATA';
	public static final String ATA_WARNING_MISSING_DRIVERDATA_MESSAGE  				= 'No entry in Assignment table for the role: ';
	
	public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_CODE 		= 'ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT';
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT_MESSAGE 	= 'Not creating Account Team: No matching data in ATA_Non_Geographic_Assignment__c table, attempted match was ';
    
    public static final String ATA_DATA_MISSING_POSTALCODE_CODE                 	= 'ATA_DATA_MISSING_POSTALCODE';
    public static final String ATA_DATA_MISSING_POSTALCODE_MESSAGE                 	= 'Postal Code is missing in ATA_Geographic_Assignment__c for geographic assignment.';
    
    public static final String ATA_DATA_MISSING_NAMEMATCH_CODE                 		= 'ATA_DATA_MISSING_NAMEMATCH';
    public static final String ATA_DATA_MISSING_NAMEMATCH_MESSAGE                 	= 'Account name is missing in ATA_Non_Geographic_Assignment__c for Named Account assignment.';
    
    public static final String ATA_ACCOUNT_DATA_CHANGEDETECTED_CODE	               	= 'ATA_ACCOUNT_DATA_CONSIDERED_FOR_ASSIGNMENT';
    
   	public static final String ATA_ACCOUNTTEAM_UPDATEBATCH_START_CODE	            = 'ATA_ACCOUNTTEAM_UPDATEBATCH_START';
   	
   	public static final String ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_SUCCESS_CODE	    = 'ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_SUCCESSFULLY';
   	
   	public static final String ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_FAILURE_CODE	    = 'ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_WITH_FAILURE';
    
    public static final String ATA_ZIPCODE_CHANGED                          		= 'Zipcode is changed';
    public static final String ATA_MARKET_SEGMENT_CHANGED                   		= 'Market segment is changed';
    public static final String ATA_MARKET_SUB_SEGMENT_CHANGED               		= 'Market sub-segment is changed';
    public static final String ATA_CUSTID_CHANGED                           		= 'Enterprise number is changed';
    public static final String ATA_NAMED_ACCOUNT_TYPE_CHANGED               		= 'Named account type is changed';
    public static final String ATA_NAMED_ACCOUNT_CHANGED                    		= 'Named account is changed';
    
    public static final String ATA_MISSING_ASSIGNMENTMATRIX                 = 'Appropriate data missing from assignment matrix table';
    public static final String ATA_MISSING_NAMED_ACCOUNT_TYPE               = 'There is no value for named account type.';
    public static final String ATA_UNCHECKED_NAMED_ACCOUNT                  = 'Named account check box is unchecked.';
    public static final String ATA_UNCHECKED_PROFESSIONAL_KEY_ACCOUNT       = 'Professional key account check box is unchecked.';
    public static final String ATA_UNCHECKED_SERVICE_SOURCE_ACCOUNT         = 'Service Source account check box is unchecked.';
    public static final String ATA_UNCHANGED_DTNS                           = 'There is no change on DTNs or Role.';
    
    public static final String ATA_MISSING_CUSTID                           = 'Enterprise number is missing';
    public static final String ATA_MISSING_NAMED_ACCOUNT                    = 'Named account is missing';
    public static final String ATA_MISSING_SERVIC_SOURCE                    = 'Service source is missing';
    public static final String ATA_USER_NOT_ACTIVE_OR_PRESENT               = 'User is not active or not present in the system.';
    public static final String ATA_NOT_PRESENT_SIC                          = 'Sic is not available in the Market Segment Mapping custom setting.';
    /*
    public static final String ATA_ZIPCODE_CHANGED                          = 'Zipcode is changed';
    public static final String ATA_MARKET_SEGMENT_CHANGED                   = 'Market segment is changed';
    public static final String ATA_MARKET_SUB_SEGMENT_CHANGED               = 'Market sub-segment is changed';
    public static final String ATA_CUSTID_CHANGED                           = 'Enterprise number is changed';
    public static final String ATA_NAMED_ACCOUNT_TYPE_CHANGED               = 'Named account type is changed';
    public static final String ATA_NAMED_ACCOUNT_CHANGED                    = 'Named account is changed';
    */
    public static final string ATA_SIC_CHANGED                              = 'Sic is changed';
    //Used if indicate that account data nesceaary to determine assignment matrix or role assignemnts is missing at account level
    
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM         = 'ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM';
    public static final String ATA_TEAM_MEMBER_CREATED_SUCCESS              = 'ATA_TEAM_MEMBER_CREATED/UPDATED_SUCCESS';
    public static final String ATA_TEAM_MEMBER_CREATED_WITH_ERROR           = 'ATA_TEAM_MEMBER_CREATED/UPDATED_WITH_ERROR';
    public static final String ATA_TEAM_MEMBER_CREATED_FOR_NAMED_ACCOUNT    = 'ATA_TEAM_MEMBER_CREATED/UPDATED_FOR_NAMED_ACCOUNT';
    public static final String ATA_CODE_ERROR                               = 'ATA_CODE_ERROR';
    public static final String ATA_TEAM_MEMBER_NOT_CREATED                  = 'ATA_TEAM_MEMBER_NOT_CREATED/UPDATED';
    public static final String ATA_TEAM_MEMBER_NOT_CREATED_FOR_NAMED_ACCOUNT= 'ATA_TEAM_MEMBER_NOT_CREATED/UPDATED_FOR_NAMED_ACCOUNT';
    public static final String ATA_USER_NOT_ACTIVE_OR_PRESENT_FOR_NAMED_ACCOUNT = 'ATA_USER_NOT_ACTIVE_OR_PRESENT_FOR_NAMED_ACCOUNT';
    public static final String ATA_SHARING_RULES_NOT_CREATED                = 'ATA_SHARING_RULES_NOT_CREATED';
    public static final String ATA_ZIPCODE_SET_TO_NULL                      = 'ATA_ZIPCODE_SET_TO_NULL';
    public static final String ATA_DTN_ROLE_NOT_CHANGED                     = 'ATA_DTN_ROLE_NOT_CHANGED';
    /*public static final String ATA_TEAM_MEMBER_CREATED = 'ATA_TEAM_MEMBER_CREATED';
    
    public static final String ATA_TEAM_MEMBER_NOT_CREATED = 'ATA_TEAM_MEMBER_NOT_CREATED';
    public static final String ATA_SHARING_RULES_NOT_CREATED = 'ATA_SHARING_RULES_NOT_CREATED';
    public static final String ATA_TEAM_MEMBER_DELETED = 'ATA_TEAM_MEMBER_DELETED';*/
    public static final String ATA_DTN_REASSIGNMENT='DTN Reassignment Across All Accounts';
    public static final String ATA_CUSTODIAL_ASSIGNMENT='Custodail Assignment Across ALL Accounts for DTN';
    public static final String ATA_CUSTODIAL_ACCESS_REMOVED= 'Custodial Access Removed Across All Accounts for DTN';
    public static final String ATA_CUSTODIAL_ACCOUNT_BATCH_JOB='Custodial Account Batch Result';
    public static final String ATA_CUSTODIAL_LEAD_BATCH_JOB='Custodial Lead Batch Result'; 
    public static final String ATA_RECORDS_NOT_EXISTS='Records do not exixt for the Object Type';
    public static final String ATA_CUSTODIAL_ASSIGNMENT_MATRIX_DATA='ATA_ROLE_IS_NO_LONGER_VALID_IN_THE_ASSIGNMENT_MATRIX'; 
    public static final String ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT='ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT';
    public static final String ATA_MISSING_ZIP_CODE_LEAD_ASSIGNMENT='ATA_MISSING_ZIP_CODE_LEAD_ASSIGNMENT'; 
    public static final String ATA_UNABLE_TO_DETERMINE_LEAD_OWNER_LEAD_ASSIGNMENT_RULE ='ATA_UNABLE_TO_DETERMINE_LEAD_OWNER_LEAD_ASSIGNMENT_RULE ';
    public static final String ATA_USER_IS_NOT_ACTIVE               = 'ATA_USER_IS_NOT_ACTIVE';
    public static final String ATA_USER_NOT_EXISTS_IN_THE_SYSTEM_FOR_DTN='ATA_USER_NOT_EXISTS_IN_THE_SYSTEM_FOR_DTN';
    public static final String ATA_LEAD_OWNER_IS_ASSIGNED_LEAD_ASSIGNMENT_RULE='ATA_LEAD_OWNER_IS_ASSIGNED_LEAD_ASSIGNMENT_RULE';
    public static final String ATA_INVALID_ZIP_CODE_LEAD_ASSIGNMENT='ATA_INVALID_ZIP_CODE_LEAD_ASSIGNMENT';
    public static final String ATA_MISSING_SALES_ALIGNMENT='ATA_MISSING_SALES_ALIGNMENT';
    public static final String ATA_CUSTODIAL_ACCESS_REVERT_FAILED='ATA_CUSTODIAL_ACCESS_REVERT_FAILED';
    public static final String ATA_LEAD_ASSIGNMENT_ACROSS_DTN ='ATA_LEAD_ASSIGNMENT_ACROSS_DTN';
    public static final String ATA_MISSING_SALES_REP_ROLE='ATA_MISSING_SALES_REP_ROLE';	//SMS 753
    public static final String ATA_MISSING_SALES_ALLIGNMENT='Missing ATA Sales Alignment';

    public static final String ATA_OPEN_TERRITORY_ASSIGNMENT='Open Territory Assignment Across ALL Accounts for DTN';
   
    public static final String ATA_EXCEPTION_MISSING_FIELD = 'ATM_Bad_Data';
    public static final String ATA_ACCOUNT_NAME_CHANGED = 'Account Name is changed';
    public static final String ATA_MISSING_POSTALCODE='ATA_MISSING_POSTALCODE';
   
    public static final String ATA_NULL_POSTALCODE_CHANGE='ATA_NULL_POSTALCODE_CHANGE';
   
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NATIONAL_STRATEGIC_ACCOUNT='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NATIONAL_STRATEGIC_NAMED_ACCOUNT';
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_PROFESSIONAL_SOFTWARE_ACCOUNT='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_PROFESSIONAL_SOFTWARE_NAMED_ACCOUNT';
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_RL_ACCOUNT='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_RL_NAMED_ACCOUNT';
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_SMALL_FIRM_ACCOUNT='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_SMALL_FIRM_NAMED_ACCOUNT';
    public static final String ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_CORPORATE_SOFTWARE_ACCOUNT='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_CORPORATE_SOFTWARE_NAMED_ACCOUNT';
   
    public static final String ATA_NATIONAL_STRATEGIC_NAMED_ACCOUNT_TYPE_CHANGED  = 'National and Strategic Named Account Changed';
    public static final String ATA_PROFESSIONAL_SOFTWARE_NAMED_ACCOUNT_TYPE_CHANGED = 'Professional Software Named Account Changed';
    public static final String ATA_RL_ACCOUNT_NAMED_ACCOUNT_TYPE_CHANGED  = 'R&L Named Account Changed';
    public static final String ATA_SMALL_FIRM_NAMED_ACCOUNT_TYPE_CHANGED  = 'Small Firm Named Account changed';
    public static final String ATA_CORPORATE_SOFTWARE_ACCOUNT_TYPE_CHANGED  = 'Corporate Software Named Account changed';
}