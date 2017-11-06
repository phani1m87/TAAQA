/*Description: Constants Driven from Code
*/
public with sharing class WK_Constants 
{
    //Account Team automation constants
    public static final String ATA_MISSING_ZIPCODE              ='ATA_MISSING_ZIPCODE';
    public static final String ATA_MISSING_MARKET_SEGMENT       = 'ATA_MISSING_MARKET_SEGMENT';
    public static final String ATA_MISSING_MARKET_SUB_SEGMENT   = 'ATA_MISSING_MARKET_SUB_SEGMENT';
    public static final String ATA_USER_NOT_ACTIVE_OR_PRESENT   = 'ATA_USER_NOT_ACTIVE_OR_PRESENT';
    public static final String ATA_ASSIGNMENT_MATRIX_MISSING    = 'ATA_ASSIGNMENT_MATRIX_MISSING';
    public static final String ATA_CODE_ERROR                   = 'ATA_CODE_ERROR';
    public static final String ATA_TEAM_MEMBER_CREATED          = 'ATA_TEAM_MEMBER_CREATED';
    public static final String ATA_TEAM_MEMBER_NOT_CREATED      = 'ATA_TEAM_MEMBER_NOT_CREATED';
    public static final String ATA_SHARING_RULES_NOT_CREATED    = 'ATA_SHARING_RULES_NOT_CREATED';
    public static final String ATA_TEAM_MEMBER_DELETED          = 'ATA_TEAM_MEMBER_DELETED';
    public static final String ATA_MISSING_CUSTID               = 'ATA_MISSING_CUSTID';
    public static final String ATA_MISSING_NAMED_Account        ='ATA_MISSING_NAMED_Account';
    
    //*** ERP Order Automation Constants *******************************************************************************
    //*** The following Codes are to be used in the Message_Code__c field of the Application_Monitoring_Log__c object, 
    //*** and as part of the Message__c data.
    //*** Usage Example: 
    //*** 
    //*** String MessageData = WK_Constants.EOI_ORDER_SENT_TO_IIB_MESSAGE + ... Addtional data ..either OrderSubmissionAcknowledgementType or ErrotMessageType data etc. 
    //*** String Message_Code = WK_Constants.EOI_ORDER_SENT_TO_IIB_MESSAGECODE;
    //*** 
    //*** Take these strings and write MessageData to the Message__c and Message_Code to the Message_Code__c fields.
    //
    
    //*** Message and Message Codes used by the initial callout to post Order Message to IIB SOA Broker
    //
    public static final String EOI_ORDER_SENT_TO_IIB_MESSAGECODE = 'EOI_ORDER_SENT_TO_IIB';
    public static final String EOI_ORDER_SENT_TO_IIB_MESSAGE = 'ORDER ACCEPTED SUCCESSFULLY BY IIB';
    
    public static final String EOI_ORDER_TO_IIB_ERROR_MESSAGECODE = 'EOI_ORDER_TO_IIB_ERROR';
    public static final String EOI_ORDER_TO_IIB_ERROR_MESSAGE = 'Callout Received an Error Message on sending order to IIB';
    
    public static final String EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE = 'EOI_IIB_500_INTERNAL_SERVER_ERROR';
    public static final String EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE = 'Callout Received 500 Internal Server Error from IIB Server';
    
    public static final String EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE = 'EOI_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE';
    public static final String EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE = 'Callout Received Maintenace Response from IIB server';
    
    public static final String EOI_ORDER_TO_IIB_RETRY_MESSAGECODE = 'EOI_IIB_RETRY_ORDER_MESSAGE_TRANSMISSION';
    public static final String EOI_ORDER_TO_IIB_RETRY_MESSAGE = 'Retrying Callout Order Message to IIB';
    
    public static final String EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGECODE = 'EOI_ORDER_TO_IIB_RETRY_EXCEEDED';
    public static final String EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGE = 'SFDC To IIB Maximum Retry Limit Exceeded';
    
    public static final String EOI_ORDER_MAXIMUM_ORDERLINES_EXCEEDED_MESSAGECODE = 'EOI_ORDER_MAXIMUM_ORDERLINES_EXCEEDED';
    public static final String EOI_ORDER_MAXIMUM_ORDERLINES_EXCEEDED_MESSAGE = 'Number Of Order Lines Exceeds Maximum Allowed for Automated Order Processing';  
    
    public static final String EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE = 'EOI_ORDER_SUBMISSION_PENDING';
    public static final String EOI_ORDER_SUBMISSION_PENDING_MESSAGE = 'Order queued in IIB to submit to SAP';
    
    //----------------------------------------------------------------------------------------------//
    //*** Message and Message Codes used in processing callback from IIB SOA Message broker
    //
    
    public static final String EOI_CALLBACK_UNHANDLED_LOG_CONDITION_MESSAGECODE = 'EOI_CALLBACK_UNHANDLED_LOG_CONDITION';
    public static final String EOI_CALLBACK_UNHANDLED_LOG_CONDITION_MESSAGE = 'Unhandled Log Condition detected in Callback Service';  
    
    public static final String EOI_CALLBACK_RECEIVED_INVALID_XML_MESSAGECODE = 'EOI_CALLBACK_RECEIVED_INVALID_XML';
    public static final String EOI_CALLBACK_RECEIVED_INVALID_XML_MESSAGE = 'CallBack Received Invalid XML Document Versus Schema - Missing Following Items:';  
    
    public static final String EOI_INVALID_IIB_CALLBACK_DATA_RECEIVED_MESSAGECODE = 'EOI_INVALID_IIB_CALLBACK_DATA_RECEIVED';
    public static final String EOI_INVALID_IIB_CALLBACK_DATA_RECEIVED_MESSAGE = 'CallBack Request missing required data';    
    
    public static final String EOI_SAP_SUCCESS_200_ORDER_CREATION_MESSAGECODE = 'EOI_SAP_SUCCESS_200_ORDER_CREATION';
    public static final String EOI_SAP_SUCCESS_200_ORDER_CREATION_MESSAGE = 'Order Accepted and Created Successfully in SAP';    
    
    public static final String EOI_SAP_SUCCESS_311_ORDER_CREATION_MESSAGECODE = 'EOI_SAP_SUCCESS_311_ORDER_CREATION';
    public static final String EOI_SAP_SUCCESS_311_ORDER_CREATION_MESSAGE = 'Order Accepted and Created Successfully in SAP';     
    
    public static final String EOI_IIB_TO_SAP_102_RETRY_MESSAGECODE = 'EOI_IIB_TO_SAP_102_RETRY';
    public static final String EOI_IIB_TO_SAP_102_RETRY_MESSAGE = 'IIB Retrying Order Message to SAP';
    
    public static final String EOI_IIB_TO_SAP_RETRY_EXCEEDED_MESSAGECODE = 'EOI_IIB_TO_SAP_RETRY_EXCEEDED';
    public static final String EOI_IIB_TO_SAP_RETRY_EXCEEDED_MESSAGE = 'IIB to SAP Maximum Retry Limit Exceeded';

    public static final String EOI_SAP_EXCEPTION_401_UNAUTHORIZED_USER_MESSAGECODE = 'EOI_SAP_EXCEPTION_401_UNAUTHORIZED_USER'; //SAP 401 Error
    public static final String EOI_SAP_EXCEPTION_401_UNAUTHORIZED_USER_MESSAGE = 'IIB to SAP_PI Unauthoized user for request';    

    public static final String EOI_SAP_EXCEPTION_028_MATERIAL_STATUS_NOT_PUBLISHED_MESSAGECODE = 'EOI_SAP_EXCEPTION_028_MATERIAL_STATUS_NOT_PUBLISHED'; //SAP 400 error
    public static final String EOI_SAP_EXCEPTION_028_MATERIAL_STATUS_NOT_PUBLISHED_MESSAGE = 'Material status is: Not Published.';
    
    public static final String EOI_SAP_EXCEPTION_MULTIPLE_ERRORS_MESSAGECODE = 'EOI_SAP_EXCEPTION_MULTIPLE_ERRORS'; //SAP 400 error
    
    public static final String EOI_SAP_EXCEPTION_219_SALES_DOCUMENT_NOT_CHANGED_MESSAGECODE = 'EOI_SAP_EXCEPTION_219_SALES_DOCUMENT_NOT_CHANGED'; //SAP 400 error
    public static final String EOI_SAP_EXCEPTION_219_SALES_DOCUMENT_NOT_CHANGED_MESSAGE = 'Sales document was not changed.';
    
    public static final String EOI_SAP_EXCEPTION_248_ERROR_IN_SALES_ITEM_MESSAGECODE = 'EOI_SAP_EXCEPTION_248_ERROR_IN_SALES_ITEM'; //SAP 400 error
    public static final String EOI_SAP_EXCEPTION_248_ERROR_IN_SALES_ITEM_MESSAGE = 'Error in SALES_ITEM.';
    
    public static final String EOI_SAP_EXCEPTION_336_ITEM_ALREADY_HAS_SCHEDULELINE_MESSAGECODE = 'EOI_SAP_EXCEPTION_336_ITEM_ALREADY_HAS_SCHEDULELINE'; //SAP 400 error
    public static final String EOI_SAP_EXCEPTION_336_ITEM_ALREADY_HAS_SCHEDULELINE_MESSAGE = 'Item has already a schedule line.';
    
    public static final String EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGECODE = 'EOI_SAP_EXCEPTION_400_MISSING_DATA'; //SAP 400 error
    public static final String EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGE = 'IIB to SAP XML Request Missing Data';

    public static final String EOI_SAP_EXCEPTION_406_NOT_ACCEPTABLE_MESSAGECODE = 'EOI_SAP_EXCEPTION_406_NOT_ACCEPTABLE'; //SAP 406 Errors
    public static final String EOI_SAP_EXCEPTION_406_NOT_ACCEPTABLE_MESSAGE = 'SAP Order Creation Failed due to rules violation';            
    
    public static final String EOI_SAP_EXCEPTION_410_INVALID_ORDER_FOR_CONTRACT_MESSAGECODE = 'EOI_SAP_EXCEPTION_410_INVALID_ORDER_FOR_CONTRACT'; //SAP 410 Errors
    public static final String EOI_SAP_EXCEPTION_410_INVALID_ORDER_FOR_CONTRACT_MESSAGE = 'SAP Order Creation Failed due to Order Header type versus contract rules violation';    
    
    public static final String EOI_SAP_EXCEPTION_422_UNPROCESSABLE_MESSAGECODE = 'EOI_SAP_EXCEPTION_422_UNPROCESSABLE'; //SAP 422 Error
    public static final String EOI_SAP_EXCEPTION_422_UNPROCESSABLE_MESSAGE = 'SAP received invalid syntax/XML or dupliciate order';     

    public static final String EOI_SAP_EXCEPTION_413_REQUEST_TOO_LARGE_MESSAGECODE = 'EOI_SAP_EXCEPTION_413_REQUEST_TOO_LARGE'; //SAP 413 Error
    public static final String EOI_SAP_EXCEPTION_413_REQUEST_TOO_LARGE_MESSAGE = 'SAP PI request received exceeds maximum XML document size';
    
    public static final String EOI_SAP_EXCEPTION_429_TOO_MANY_REQUESTS_MESSAGECODE = 'EOI_SAP_EXCEPTION_429_TOO_MANY_REQUESTS'; //SAP 429 Error
    public static final String EOI_SAP_EXCEPTION_429_TOO_MANY_REQUESTS_MESSAGE = 'SAP or SAP_PI has exceeded the maximum number simultaneous requests';
    
    public static final String EOI_SAP_PI_EXCEPTION_500_INTERNAL_SERVER_ERROR_MESSAGECODE = 'EOI_SAP-PI_EXCEPTION_500_INTERNAL_SERVER_ERROR'; //SAP 500 Error
    public static final String EOI_SAP_PI_EXCEPTION_500_INTERNAL_SERVER_ERROR_MESSAGE = 'Technical Error in SAP_PI';

    public static final String EOI_SAP_PI_EXCEPTION_501_UNAUTHORIZED_FOR_SALES_DOCUMENT_MESSAGECODE = 'EOI_SAP_PI_EXCEPTION_501_UNAUTHORIZED_FOR_SALES_DOCUMENT'; //SAP 500 Error
    public static final String EOI_SAP_PI_EXCEPTION_501_UNAUTHORIZED_FOR_SALES_DOCUMENT_MESSAGE = 'No Authorization to create the sales document';
    
    public static final String EOI_SAP_EXCEPTION_503_MAINTENANCE_MESSAGECODE = 'EOI_SAP_EXCEPTION_503_MAINTENANCE'; //SAP 503 Error
    public static final String EOI_SAP_EXCEPTION_503_MAINTENANCE_MESSAGE = 'SAP Server is Down for Maintenance';             

    public static final String EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGECODE = 'EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR'; //SAP 504 Error
    public static final String EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGE = 'External gateway error for Tax, Credit Card, or other external gateway';
    
    public static final String EOI_EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE = 'EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE';
    public static final String EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGE = 'IIB is down/maintenance or doesn\'t take any requests now';
    
    //*** ERP Order Automation Constants *****************************************************/
    public static final String ORD_MONITORING_LOG_TYPE_ERP_ORDER_SENT = 'ERP ORDER SENT';
    public static final String ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY = 'ERP ORDER TRANSMITTED SUCCESSFULLY';
    public static final String ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMISSION_FAILED = 'ERP ORDER TRANSMISSION FAILED';
    public static final String EOI_SUCCESS_STATUSCODE = '200'; 
    public static final String EOI_INTERNAL_SERVER_ERROR_STATUSCODE = '500';
    public static final String EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE = '503';
    public static final String EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE = '102';
    public static final String EOI_Retry_LIMIT_EXCEED = '104';
    public static final String EOI_BAD_MISSING_XML_DATA_STATUSCODE = '400';
    public static final String EOI_PENDING_STATUSCODE = '0';
    public static final String EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED = '504';
    public static final String EOI_ORDER_MAXIMUM_ORDERLINES_EXCEEDED_STATUSCODE = '999';
    
    //*** AOP2.0 Constants *****************************************************/
    
    public static final String EOI_NEW = 'NEW';
    public static final String EOI_EXISTING = 'EXISTING';
    public static final String EOI_BLANK = '';
     
    //*** AOP Get Account Info Constants *****************************************************/
    public static final String EOI_GETACCOUNTINFO_INSUFFICIENT_DATA_STATUSCODE = '100';
    public static final String EOI_GETACCOUNTINFO_ACCOUNTNUMBER_NOT_VALID_STATUSCODE = '200';
    public static final String EOI_GETACCOUNTINFO_INTERNAL_SERVER_ERROR_STATUSCODE = '500';
    
    public static final String EOI_SAP_GETACCOUNTINFO_SUCCESS_MESSAGECODE = 'EOI_GETACCOUNTINFO_SUCCESS';
    public static final String EOI_SAP_GETACCOUNTINFO_SUCCESS_MESSAGE = 'Business partners were successfully fetched from SAP.';
    
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_100_MESSAGECODE = 'EOI_GETACCOUNTINFO_INSUFFICIENT_DATA';
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_100_MESSAGE = 'Insufficient Mandatory Data provided to Service.';
    
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_200_MESSAGECODE = 'EOI_GETACCOUNTINFO_ERROR_ACCOUNTNUMBER_INVALID';
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_200_MESSAGE = 'Account number is invalid.';
    
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGECODE = 'EOI_GETACCOUNTINFO_INTERNAL_SERVER_ERROR';
    public static final String EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE = 'Technical error occurred, contact System Administrator with the screen shot.';
    
    public static final String EOI_SAP_GETACCOUNTINFOR_UNHANDLED_LOG_CONDITION_MESSAGECODE = 'EOI_GETACCOUNTINFO_UNHANDLED_LOG_CONDITION';
    public static final String EOI_SAP_GETACCOUNTINFOR_UNHANDLED_LOG_CONDITION_MESSAGE = 'Unhandled Log Condition detected in GetAccountInfo response.';
    //*** AOP Get Account Info Constants *****************************************************/
    
    //*** AOP DQ Address Validation Constants *****************************************************/
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_SUCCESS_STATUSCODE = 'S2000';
    
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_VALID_MESSAGECODE = 'EOI_SAP_DQ_ADDRESS_VALID';
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_VALID_MESSAGE = 'New business partner address successfully validated.';
    
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_INVALID_MESSAGECODE = 'EOI_SAP_DQ_ADDRESS_INVALID';
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_INVALID_MESSAGE = 'New business partner address is not valid.';
    
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGECODE = 'EOI_SAP_DQ_ADDRESS_VALIDATION_FAILED';
    public static final String EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGE = 'New business partner address couldn\'t be validated.';
    //*** AOP DQ Address Validation Constants *****************************************************/
     
    //*** EOI Order Mapping Constants
    public static final String EOI_QuoteRecordType_SAP_Subscription = 'SAP Subscription'; 
    public static final String EOI_QuoteRecordType_SAP_Books = 'SAP Books';
    public static final String EOI_ShippigMethod_First_Class = 'First Class';
    public static final String EOI_ShippigMethod_2nd_Day_Delivery = '2nd Day Delivery';
    public static final String EOI_ShippigMethod_Ground_parcel = 'Ground Parcel';
    public static final String EOI_ShippigMethod_International_Air = 'International Air';
    public static final String EOI_ShippigMethod_Next_Day_AM_Delivery = 'Next Day-AM Delivery';
    public static final String EOI_ShippigMethod_Next_Day_PM_Delivery = 'Next Day-PM Delivery';
    public static final String EOI_ShippigMethod_Shipping_Account = 'Shipping Account';
    public static final String EOI_ShippigMethod_FedEx = 'FedEx';
    
    public static final String EOI_Authentication_type_Standard = 'Standard';
    public static final String EOI_Authentication_type_IP = 'IP';
    public static final String EOI_Authentication_type_Refer = 'Refer';
    public static final String EOI_Authentication_type_Standard_IP = 'Standard+IP';
    public static final String EOI_Authentication_type_Refer_IP = 'Refer+IP';
    public static final String EOI_Authentication_type_Standard_Refer = 'Standard+Refer';
    
    public static final String EOI_CCType_American_Express = 'American Express';
    public static final String EOI_CCType_Discover = 'Discover';
    public static final String EOI_CCType_Master_Card = 'Master Card';
    public static final String EOI_CCType_Visa = 'Visa';
    
    public static final String EOI_Opt_In_OBR = 'Opt-In (OBR)';
    public static final String EOI_Opt_In_Standing_Order = 'Opt-In (Standing Order)';
    public static final String EOI_Opt_Out_CBR = 'Opt-Out (CBR)';
    public static final String EOI_Exempt_Manual_Renewal = 'Exempt (Manual Renewal)';
    public static final String EOI_Not_Applicable_TC = 'Not Applicable (T&C or Non-Sub ONLY)';

    public static final String EOI_Access_Type_All = 'All';
    public static final String EOI_Access_Type_All_Link = 'All - Link';
    public static final String EOI_Access_Type_Limited = 'Limited';
	
	//*** SALES TO SERVICE INTEGRATION CODES **************************************************************************
    //*** The following Codes are to be used in the Message_Code__c field of the Application_Monitoring_Log__c object, 
    //*** and as part of the Message__c data.
    //*** Usage Example: 
    //*** 
    //*** 
    //*** Take these strings and write MessageData to the Message__c and Message_Code to the Message_Code__c fields.    
    
    //*** Message and Message Codes used by the CreateCase flow to post Create Case Message to IIB SOA Broker
    
    public static final String SVC_CREATECASE_SUCCESS_STATUSCODE = '200';
    public static final String SVC_CREATECASE_SUCCESS_MESSAGE = 'Case is successfully created.';
    
    public static final String SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK = '101';
    public static final String SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK_MESSAGE = 'Account number is blank or null.';
    
    public static final String SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_NOT_PRESENT = '201';
    public static final String SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_NOT_PRESENT_MESSAGE = 'Account number does not exist in service org.';
    
    public static final String SVC_CREATECASE_FAILED_EMAIL_BLANK = '103';
    public static final String SVC_CREATECASE_FAILED_EMAIL_BLANK_MESSAGE = 'Contact email is blank or null.';
    
    public static final String SVC_CREATECASE_FAILED_FIRSTNAME_BLANK = '104';
    public static final String SVC_CREATECASE_FAILED_FIRSTNAME_BLANK_MESSAGE = 'Contact first name is required.';
    
    public static final String SVC_CREATECASE_FAILED_LASTNAME_BLANK = '105';
    public static final String SVC_CREATECASE_FAILED_LASTNAME_BLANK_MESSAGE = 'Contact last name is required.';
    
    public static final String SVC_CREATECASE_FAILED_PRODUCT_NOT_PRESENT = '202';
    public static final String SVC_CREATECASE_FAILED_PRODUCT_NOT_PRESENT_MESSAGE = 'Product does not exist in service org.';
    
    public static final String SVC_CREATECASE_FAILED_PRODUCTFAMILY_NOT_PRESENT = '203';
    public static final String SVC_CREATECASE_FAILED_PRODUCTFAMILY_NOT_PRESENT_MESSAGE = 'Product family does not exist in service org.';
    
    public static final String SVC_INTERNAL_SERVER_ERRORCODE = '500';
    public static final String SVC_INTERNAL_SERVER_ERROR_MESSAGE = 'Technical error, please contact System Administrator with the screen shot.';
    
    public static final String SVC_IIB_DATA_MISSING = '100';
    public static final String SVC_IIB_DATA_MISSING_MESSAGE = 'Required header data is missing, please contact System Administrator with the screen shot.';
    
    public static final String SVC_IIB_DATA_INVALID = '300';
    public static final String SVC_IIB_DATA_INVALID_MESSAGE = 'Account number does not exist in service org.';
    
    public static final String SVC_EXCEPTION_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE = 'SVC_EXCEPTION_CREATECASE_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE';
    public static final String SVC_EXCEPTION_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGE = 'IIB is down/maintenance or doesn\'t take any requests now.';
    
    public static final String SVC_CREATECASE_SUCCESS_LOG_MESSAGECODE = 'SVC_CREATECASE_CASECREATED_SUCCESS';
    public static final String SVC_CREATECASE_FAILED_SFDC_VALIDATION_ERROR_MESSAGECODE = 'SVC_SERVICECLOUD_VALIDATION_ERROR';
    public static final String SVC_CREATECASE_FAILED_IIB_VALIDATION_ERROR_MESSAGECODE = 'SVC_IIB_VALIDATION_ERROR';
    
    public static final String SVC_CREATECASE_ADD_NEW_CASECOMMENT_EXCEPTION_MESSAGE = 'Exception thrown in addNewCaseComment.';
    public static final String SVC_CREATECASE_ADD_NEW_CASECOMMENT_EXCEPTION_MESSAGECODE = 'SVC_CREATECASE_ADDNEWCASECOMMENT_EXCEPTION';
    
    public static final String SVC_CREATECASE_ADD_NEW_ATTACHMENT_EXCEPTION_MESSAGE = 'Exception thrown in addNewAttachment.';
    public static final String SVC_CREATECASE_ADD_NEW_ATTACHMENT_EXCEPTION_MESSAGECODE = 'SVC_CREATECASE_ADDNEWATTACHMENT_EXCEPTION';
    
    public static final String SVC_CREATECASE_EXCEPTION_MESSAGECODE = 'SVC_CREATECASE_EXCEPTION';
    
    public static final String SVC_CREATECASE_ADD_NEW_CASECOMMENT_SUCCESS_MESSAGE = 'SUCCESS ADD NEW CASE COMMENT';
    public static final String SVC_CREATECASE_ADD_NEW_CASECOMMENT_SUCCESS_MESSAGECODE = 'SVC_CREATECASE_ADDNEWCASECOMMENT_SUCCESS';
    
    public static final String SVC_CREATECASE_OPERATION_FAILED_MESSAGE = 'FAILED';
    public static final String SVC_CREATECASE_OPERATION_FAILED_MESSAGECODE = 'SVC_CREATECASE_OPERATION_FAILED';
    
    public static final String SVC_CREATECASE_ADD_NEW_ATTACHMENT_SUCCESS_MESSAGE = 'SUCCESS ADD NEW CASE ATTACHMENT';
    public static final String SVC_CREATECASE_ADD_NEW_ATTACHMENT_SUCCESS_MESSAGECODE = 'SVC_CREATECASE_ADDNEWATTACHMENT_SUCCESS';
    
    public static final String SVC_CREATECASE_ESCALATION_SUCCESS_MESSAGE = 'CASE ESCALATION SUCCESS';
    public static final String SVC_CREATECASE_ESCALATION_SUCCESS_MESSAGECODE = 'SVC_CREATECASE_ESCALATION_SUCCESS';
    
    public static final String SVC_CREATECASE_SUCCESS_MESSAGECODE = 'SVC_CREATECASE_UNKNOWN_SUCCESS';
    
}