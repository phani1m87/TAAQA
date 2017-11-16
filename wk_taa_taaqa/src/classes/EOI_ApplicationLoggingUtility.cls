/*
 * Application Logging Utility for AOP
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 06/14/2017 SHIVAJI           1.0          AOP1.5 Changes
 * 08/24/2017 SHIVAJI           1.1          Create Case Requirement
 * ------------------------------------------------------------------------- */

public with sharing class EOI_ApplicationLoggingUtility 
{
	//***
	//*** This class interprets the response from the callout and the incoming request from the callback, translating 
	//*** the data into into the appropriate application message code which is then handed to the EOI_Logger_Utility.
	//*** These methods map the codes from the XML tags into our specific application logging codes defined in the WK_Constants class.*/

    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, String requestData, EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result, String ERPOrderName, Id ERPOrderId, String ErrorMessageIfIIBDown)
    {
        String messageForLog = '', messageCode = '', uuid = '';
        if(result != null)
        {
            if(result.uuidMetaDataRequest != NULL){
            	uuid = result.uuidMetaDataRequest.uuid;
            }
            
            if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SUCCESS_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_ORDER_SENT_TO_IIB_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SUCCESS_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //message =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY  + ' Request Status Description = ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_INTERNAL_SERVER_ERROR_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageForLog =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE ;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageForLog =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_PENDING_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageCode = WK_Constants.EOI_PENDING_STATUSCODE;
                //message =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGE;            
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED )
            {
                messageCode = WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                 
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == '1')
            {
                messageCode = 'EOI_FAILED_TO_LOAD_IN_IIB';
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + '1';
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + 'Failed to load in IIB';
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_ORDER_TO_IIB_RETRY_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_TO_IIB_RETRY_MESSAGE;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_Retry_LIMIT_EXCEED)
            {
                messageCode = WK_Constants.EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_Retry_LIMIT_EXCEED;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGE;
            }
            
            if(!String.isblank(ErrorMessageIfIIBDown)) //Add extra details if any
                messageForLog = messageForLog + ': details= '+   ErrorMessageIfIIBDown;
            if(result.errorMessages != null)
            {
                List<EOI_IIB_ERPOrderCallout_V7.ErrorMessageType> errorMessagesList = result.errorMessages.ErrorMesage;
                for(EOI_IIB_ERPOrderCallout_V7.ErrorMessageType errorMessage : errorMessagesList)
                {
                    messageForLog = messageForLog + ': Error Message Code =  '+errorMessage.customErrorMessageCode;
                    messageForLog = messageForLog + ': Error Message Description =   '+errorMessage.customErrorMessageDescription;
                }
            }
            Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(ApexClass__c=className, ApexMethod__c =methodName, Message__c=messageForLog, MessageCode__c=messageCode, RequestData__c= requestData, ResponseData__c=result.toString(), TransactionId__c = uuid, ERPOrder__c =ERPOrderId );
            return newApplicationLog;
        }
        else
        {
            messageCode = WK_Constants.EOI_EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE;
            messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
            messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + system.Now();
            messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
            messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE ;
            system.debug('Result is null');
            if(!String.isblank(ErrorMessageIfIIBDown))
            messageForLog = messageForLog + ': details = '+   ErrorMessageIfIIBDown;
            
            Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(ApexClass__c=className, ApexMethod__c =methodName, Message__c=messageForLog, MessageCode__c=messageCode, RequestData__c= requestData, ResponseData__c=ErrorMessageIfIIBDown, TransactionId__c= uuid, ERPOrder__c =ERPOrderId );
            return newApplicationLog;
        }
        //Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c();
        
    }
    
    /*
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, String requestData, EOI_IIB_ERPOrderCallout_V5.OrderSubmissionResponseType result, String ERPOrderName, Id ERPOrderId, String ErrorMessageIfIIBDown)
    {
       
        String messageForLog = '', messageCode = '';
        if(result != null)
        {
            if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SUCCESS_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_ORDER_SENT_TO_IIB_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SUCCESS_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //message =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY  + ' Request Status Description = ' + WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMITTED_SUCCESSFULLY;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_INTERNAL_SERVER_ERROR_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageForLog =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE ;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageForLog =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_PENDING_STATUSCODE )
            {
                messageCode = WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                //messageCode = WK_Constants.EOI_PENDING_STATUSCODE;
                //message =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_ORDER_SUBMISSION_PENDING_MESSAGE;            
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED )
            {
                messageCode = WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGE;
                //messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                 
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == '1')
            {
                messageCode = 'EOI_FAILED_TO_LOAD_IN_IIB';
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + '1';
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + 'Failed to load in IIB';
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE)
            {
                messageCode = WK_Constants.EOI_ORDER_TO_IIB_RETRY_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_TO_IIB_RETRY_MESSAGE;
            }
            else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_Retry_LIMIT_EXCEED)
            {
                messageCode = WK_Constants.EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGECODE;
                messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
                messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_Retry_LIMIT_EXCEED;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_ORDER_TO_IIB_RETRY_EXCEEDED_MESSAGE;
            }
            
            if(!String.isblank(ErrorMessageIfIIBDown)) //Add extra details if any
                messageForLog = messageForLog + ': details= '+   ErrorMessageIfIIBDown;
            if(result.errorMessages != null)
            {
                List<EOI_IIB_ERPOrderCallout_V5.ErrorMessageType> errorMessagesList = result.errorMessages.ErrorMesage;
                for(EOI_IIB_ERPOrderCallout_V5.ErrorMessageType errorMessage : errorMessagesList)
                {
                    messageForLog = messageForLog + ': Error Message Code =  '+errorMessage.customErrorMessageCode;
                    messageForLog = messageForLog + ': Error Message Description =   '+errorMessage.customErrorMessageDescription;
                }
            }
            Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(ApexClass__c=className, ApexMethod__c =methodName, Message__c=messageForLog, MessageCode__c=messageCode, RequestData__c= requestData, ResponseData__c=result.toString(), TransactionId__c='', ERPOrder__c =ERPOrderId );
            return newApplicationLog;
        }
        else
        {
            messageCode = WK_Constants.EOI_EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE;
            messageForLog = messageForLog + 'calloutResponse.sfdc_OrderIDKey= ' + ERPOrderName;
            messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + system.Now();
            messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
            messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE ;
            system.debug('Result is null');
            if(!String.isblank(ErrorMessageIfIIBDown))
            messageForLog = messageForLog + ': details= '+   ErrorMessageIfIIBDown;
            
            Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(ApexClass__c=className, ApexMethod__c =methodName, Message__c=messageForLog, MessageCode__c=messageCode, RequestData__c= requestData, ResponseData__c=ErrorMessageIfIIBDown, TransactionId__c='', ERPOrder__c =ERPOrderId );
            return newApplicationLog;
        }
        //Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c();
        
        return null;
    }
 	*/
	//---------------------------------------------------------------------------
	//----------------------------------------------------------------------------   
 
     public Static void ApplicationLogFromCallbackRequest_V2(
        EOI_SendOrderToERP_Callback_V2.callbackInfo callbackRequest,
        EOI_SendOrderToERP_Callback_V2.callbackInfoReturn callbackResponse,
        EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type callbackMessageId,
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type callbackSAPReturn,
        EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type callbackSalesDocuments) {
        
    //--- Processes the multiple structures passed in on the callback and determines the correct application Logging code and message to use from the WK_Constants class
        String InterfaceName = 'EOI_SendOrderToERP_Callback_V2';
        String messageForLog = '';
        String messagecodeForLog = '';
        //Boolean ChangeOrderStatusFlag = False;
        //String ORDER_SUBMISSION_STATUS = '';
        ID erpOrderID;      
        
        system.debug('*** ApplicationLogFromCallbackRequest Start ');
        system.debug('*** callbackRequest = ' + callbackRequest);
        system.debug('*** callbackResponse = ' + callbackResponse);
        system.debug('*** callbackMessageId = ' + callbackMessageId);
        system.debug('*** callbackSAPReturn = ' + callbackSAPReturn);
        system.debug('*** callbackSalesDocuments = ' + callbackSalesDocuments);
        
        
        //Step 1: We need the Correct Order ID to use for logging:
        if(!string.IsBlank(callbackRequest.sfdc_OrderIDKey)){
            List<ERP_Order__c> ERPOrderIdList = new List <ERP_Order__c>([Select Id from ERP_Order__c where Name = :callbackRequest.sfdc_OrderIDKey]);
            system.debug('*** ERPOrderIdList = ' + ERPOrderIdList);
            if(ERPOrderIdList.size() <> 1){   //Need to throw custom exception  - fix after test harness is working....
                WK_Exception wkexception = New WK_Exception('NO Matching order found for ' + callbackRequest.sfdc_OrderIDKey); 
                //wkException.setMessage(WK_Exception.EOI_EXCEPTION_CALLBACK_MISSING_SFDC_ORDERID);
                throw wkException;
            }else{
                erpOrderID = ERPOrderIdList[0].Id;
            }   
        } 
        
        system.debug('***erpOrderID= ' + erpOrderID);
        
        if(String.valueOf(callbackRequest.sfdc_OrderIDKey) == '' || String.valueOf(callbackRequest.sfdc_OrderIDKey) == NULL ||
            //SMS-879
            //String.valueOf(callbackRequest.erp_OrderIDKey) == '' || String.valueOf(callbackRequest.erp_OrderIDKey) == NULL ||
            String.valueOf(callbackRequest.UUID) == '' || String.valueofGMT(callbackRequest.responseDateTime) == '' ||
            String.valueOf(callbackRequest.statusCode) == '' || String.valueOf(callbackRequest.statusDescription) == '' ){        
            
            system.debug('***Missing Argument Block');
            
            messageForLog =  WK_Constants.EOI_INVALID_IIB_CALLBACK_DATA_RECEIVED_MESSAGE;
            messagecodeForLog = WK_Constants.EOI_INVALID_IIB_CALLBACK_DATA_RECEIVED_MESSAGECODE;
            messageForLog = messageForLog + '\n callbackRequest.sfdc_OrderIDKey= ' + callbackRequest.sfdc_OrderIDKey;
            messageForLog = messageForLog + '\n callbackRequest.UUID= ' + callbackRequest.UUID;
            //String convertdt = con
            messageForLog = messageForLog + '\n callbackRequest.responseDateTime= ' + string.valueOfGmt(callbackRequest.responseDateTime);
            messageForLog = messageForLog + '\n callbackRequest.statusCode= ' + callbackRequest.statusCode;
            messageForLog = messageForLog + '\n callbackRequest.statusDescription= ' + callbackRequest.statusDescription;
            messageForLog = messageForLog + '\n*** End Invalid Data Block Information *** ';
            // We could get the order submitted yet have an error on the callback request - we dont change the Order_Submission_Status-_c here.
            // Log this as a separate log entry.
            Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
                //Name = InterfaceName, 
                ApexClass__c =InterfaceName, 
                ApexMethod__c = 'ApplicationLogFromCallbackRequest', 
                Message__c = messageForLog, 
                MessageCode__c = messagecodeForLog, 
                RequestData__c = callbackRequest.ToString(), 
                ResponseData__c = callbackResponse.ToString(),
                ERPOrder__c = erpOrderID,
                TransactionId__c = callbackRequest.UUID
            );          
            insert newApplicationLog;
            return;
        }
        
        system.debug('***SAP Processing Block');
        
        if(callbackSAPReturn != NULL)
        {     
            if(String.valueOf(callbackSAPReturn.type) == 'E' || string.valueOf(callbackrequest.statuscode) == 'E') 
            {
                system.debug('***SAP Number Code Block');
                if(callbackSAPReturn.SAP_NUMBER == '028'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_028_MATERIAL_STATUS_NOT_PUBLISHED_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_028_MATERIAL_STATUS_NOT_PUBLISHED_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '219'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_219_SALES_DOCUMENT_NOT_CHANGED_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_219_SALES_DOCUMENT_NOT_CHANGED_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '248'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_248_ERROR_IN_SALES_ITEM_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_248_ERROR_IN_SALES_ITEM_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '336'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_336_ITEM_ALREADY_HAS_SCHEDULELINE_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_336_ITEM_ALREADY_HAS_SCHEDULELINE_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '401'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_401_UNAUTHORIZED_USER_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_401_UNAUTHORIZED_USER_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '406'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_406_NOT_ACCEPTABLE_MESSAGE;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_406_NOT_ACCEPTABLE_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '410'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_410_INVALID_ORDER_FOR_CONTRACT_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_410_INVALID_ORDER_FOR_CONTRACT_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '413'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_413_REQUEST_TOO_LARGE_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_413_REQUEST_TOO_LARGE_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '422'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_422_UNPROCESSABLE_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_422_UNPROCESSABLE_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '429'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_429_TOO_MANY_REQUESTS_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_429_TOO_MANY_REQUESTS_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '500'){ 
                    messageForLog =  WK_Constants.EOI_SAP_PI_EXCEPTION_500_INTERNAL_SERVER_ERROR_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_PI_EXCEPTION_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '501'){ 
                    messageForLog =  WK_Constants.EOI_SAP_PI_EXCEPTION_501_UNAUTHORIZED_FOR_SALES_DOCUMENT_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_PI_EXCEPTION_501_UNAUTHORIZED_FOR_SALES_DOCUMENT_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '503'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_503_MAINTENANCE_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_503_MAINTENANCE_MESSAGECODE;
                }else if(callbackSAPReturn.SAP_NUMBER == '504'){ 
                    messageForLog =  WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGE ;
                    messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGECODE;
                }                   
                system.debug('messagecodeForLog= ' + messagecodeForLog);
                system.debug('messageForLog= ' + messageForLog);
            } //End IF then elseif 
       
            system.debug('***SAP Past Processing Block');
            
            // *** AOP 2.0 Commented below condition since SAP Return Type might come as W even though order is SUCCESS 
            //if(String.valueOf(callbackSAPReturn.TYPE) == 'S' && String.valueOf(callbackRequest.statusCode) == 'S' && String.valueOf(callbackSAPReturn.SAP_NUMBER) == '311')
            if(String.valueOf(callbackRequest.statusCode) == 'S')
            { 
                messageForLog =  WK_Constants.EOI_SAP_SUCCESS_311_ORDER_CREATION_MESSAGE ;
                messagecodeForLog = WK_Constants.EOI_SAP_SUCCESS_311_ORDER_CREATION_MESSAGECODE;
            }
            
            if(callbackSAPReturn.TYPE == 'S')
            {
                if(callbackSalesDocuments != NULL){
                    messageForLog = messageForLog + '\n *** SAP SALES DOCUMENTS --> ';
                    messageForLog = messageForLog + '\n *** SOURCE_ORDER_ID:  ' + callbackSalesDocuments.SOURCE_ORDER_ID;
                    messageForLog = messageForLog + '\n *** SAP_DOC_ID --> ' + callbackSalesDocuments.SAP_DOC_ID;
                    messageForLog = messageForLog + '\n *** SAP_DOC_TYPE --> '+ callbackSalesDocuments.SAP_DOC_TYPE;  
                }            
            }  
            
            system.debug('***SAP Messages Processing Block');            
        
            if(callbackSAPReturn.TYPE <> ''){          
                messageForLog = messageForLog + '\n *** SAP Messages --> ';
                messageForLog = messageForLog + '\n *** TYPE(E=Error,W=Warning,S=Success):  ' + callbackSAPReturn.TYPE;
                messageForLog = messageForLog + '\n *** SAP_NUMBER:  ' + callbackSAPReturn.SAP_NUMBER;
                if(callbackRequest != NULL && callbackRequest.listOfSAPReturnResults != NULL && callbackRequest.listOfSAPReturnResults.size() > 0)
                {
                    for(EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objCallbackSAPReturn : callbackRequest.listOfSAPReturnResults)
                    {
                        messageForLog = messageForLog + '\n *** Message:  ' + objCallbackSAPReturn.MESSAGE;
                        messageForLog = messageForLog + '\n *** V1 Message --> ' + objCallbackSAPReturn.MESSAGE_V1;
                        messageForLog = messageForLog + '\n *** V2 Message --> '+ objCallbackSAPReturn.MESSAGE_V2;
                        messageForLog = messageForLog + '\n *** V3 Message --> '+ objCallbackSAPReturn.MESSAGE_V3;
                        messageForLog = messageForLog + '\n *** V4 Message --> '+ objCallbackSAPReturn.MESSAGE_V4;
                    }
                    
                    if(callbackRequest.listOfSAPReturnResults.size() > 1 && callbackRequest.statusCode != 'S'){
                    	messagecodeForLog = WK_Constants.EOI_SAP_EXCEPTION_MULTIPLE_ERRORS_MESSAGECODE;
                    }
                }
            }
        } //End if then test for callbackSapReturn != Null
        //test to see if we have a condition that is not allowed in the data or we dont handle explicitely
        if( messagecodeForLog == ''){
            messageForLog = WK_Constants.EOI_CALLBACK_UNHANDLED_LOG_CONDITION_MESSAGE + messageForLog;
            messagecodeForLog = WK_Constants.EOI_CALLBACK_UNHANDLED_LOG_CONDITION_MESSAGECODE;        
        }

        messageForLog = messageForLog + '\n callbackRequest.sfdc_OrderIDKey= ' + callbackRequest.sfdc_OrderIDKey;
        messageForLog = messageForLog + '\n callbackRequest.UUID= ' + callbackRequest.UUID;
        messageForLog = messageForLog + '\n callbackRequest.responseDateTime= ' + string.valueOfGMT(callbackRequest.responseDateTime);
        messageForLog = messageForLog + '\n callbackRequest.statusCode= ' + callbackRequest.statusCode;
        messageForLog = messageForLog + '\n callbackRequest.statusDescription= ' + callbackRequest.statusDescription;
       
       // add try catch block....
       
        Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
            //Name = InterfaceName, 
            ApexClass__c = interfaceName, 
            ApexMethod__c = 'ApplicationLogFromCallbackRequest', 
            Message__c = messageForLog, 
            MessageCode__c = messagecodeForLog, 
            RequestData__c = callbackRequest.ToString(), 
            ResponseData__c = callbackResponse.ToString(),
            ERPOrder__c = erpOrderID,
            TransactionId__c = callbackRequest.UUID
        );
        //Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(Name = 'Webservice callback', ApexClass__c ='EOI_ApplicationLoggingUtility', ApexMethod__c = 'ApplicationLogFromCallbackRequest', Message__c ='TEST MESSAGE', MessageCode__c = WK_Constants.EOI_SAP_SUCCESS_200_ORDER_CREATION_MESSAGECODE, RequestData__c = callbackRequest.ToString(), ResponseData__c = callbackResponse.ToString(), TransactionId__c=transactionId, ERPOrder__c =ERPOrderId );
        insert newApplicationLog;
    }
    
    //Log for TAA Service Site Create Case
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, IIB_TAAServiceSiteCreateCase_V4.CreateCaseRequestWrapper requestData, IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element result, String accountId)
    {
    	//ASSUME IT'S SUCCESS & ASSIGN SUCCESS CONSTANTS 
    	String messageForLog = WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGE;
    	String messagecodeForLog = WK_Constants.SVC_CREATECASE_SUCCESS_LOG_MESSAGECODE;
    	
    	if(result == NULL){
    		messageForLog = WK_Constants.SVC_EXCEPTION_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGE;
    		messagecodeForLog = WK_Constants.SVC_EXCEPTION_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE;
    	}else{
    		if(result != NULL && result.createCase != NULL && result.createCase.caseNumber != NULL)
        	{
        		//SUCCESS
        		messageForLog = WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGE;
        		messageForLog = messageForLog + ' Case # : ' + result.createCase.caseNumber;
        		messagecodeForLog = WK_Constants.SVC_CREATECASE_SUCCESS_LOG_MESSAGECODE;
    		}else if(result.errorMessages != NULL){
        		//FAILURE
        		if(result.errorMessages.ErrorMessage.customErrorMessageCode != NULL)
        		{
        			//SFDC SERVICE ORG ERROR
        			messagecodeForLog = WK_Constants.SVC_CREATECASE_FAILED_SFDC_VALIDATION_ERROR_MESSAGECODE;
        		}else if(result.errorMessages.ErrorMessage.errorMessageCode != NULL){
        			//IIB ERROR
        			messagecodeForLog = WK_Constants.SVC_CREATECASE_FAILED_IIB_VALIDATION_ERROR_MESSAGECODE;
        		}
        		messageForLog = result.errorMessages.ErrorMessage.customErrorMessageDescription;
        		//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));
        	}
        }
    	 
    	Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
	    	ApexClass__c = className, 
	        ApexMethod__c = methodName, 
	        Message__c = messageForLog, 
	        MessageCode__c = messagecodeForLog, 
	        RequestData__c = requestData.toString(), 
	        ResponseData__c = result != NULL ? result.toString() : '',
	        AccountId__c = accountId,
	        TransactionId__c = requestData.uuidMetaDataRequest.uuid
    	);
    	return newApplicationLog;
    }
    
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, HttpRequest requestData, HttpResponse result, String accountId)
    {
    	//ASSUME IT'S SUCCESS & ASSIGN SUCCESS CONSTANTS 
    	String messageForLog = WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGE;
    	String messagecodeForLog = WK_Constants.SVC_CREATECASE_SUCCESS_LOG_MESSAGECODE;
    	
		if(result != NULL && result.getStatusCode() == 201 || result.getStatusCode() == 200)
    	{
    		if(methodName == 'addNewCaseComment'){
    			messageForLog = WK_Constants.SVC_CREATECASE_ADD_NEW_CASECOMMENT_SUCCESS_MESSAGE;
    			messageForLog = messageForLog + ' result : ' + String.valueOf(result);
    			messagecodeForLog = WK_Constants.SVC_CREATECASE_ADD_NEW_CASECOMMENT_SUCCESS_MESSAGECODE;	
    		}else if(methodName == 'addNewCaseAttachment'){
    			messageForLog = WK_Constants.SVC_CREATECASE_ADD_NEW_ATTACHMENT_SUCCESS_MESSAGE;
    			messageForLog = messageForLog + ' result : ' + String.valueOf(result);
    			messagecodeForLog = WK_Constants.SVC_CREATECASE_ADD_NEW_ATTACHMENT_SUCCESS_MESSAGECODE;
    		}else if(methodName == 'escalateCase'){
    			messageForLog = WK_Constants.SVC_CREATECASE_ESCALATION_SUCCESS_MESSAGE;
    			messageForLog = messageForLog + ' result : ' + String.valueOf(result);
    			messagecodeForLog = WK_Constants.SVC_CREATECASE_ESCALATION_SUCCESS_MESSAGECODE;
    		}else{
    			messageForLog = messageForLog + ' result : ' + String.valueOf(result);
    			messagecodeForLog = WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGECODE;
    		}
    	}else{
    		messageForLog = WK_Constants.SVC_CREATECASE_OPERATION_FAILED_MESSAGECODE + '\nResponse=' +  String.valueOf(result);
    		messagecodeForLog = WK_Constants.SVC_CREATECASE_OPERATION_FAILED_MESSAGE;
    	}

    	String request = String.valueOf(requestData); //+ requestData != NULL ? String.valueOf(requestData.getBody()) : '';
    	if(methodName != 'addNewCaseAttachment' && requestData != NULL){
    		request = request + '\nRequest Body= ' + String.valueOf(requestData.getBody());	 
    	}
    	
    	String response = String.valueOf(result);
    	if(result != NULL){
    		response = response + '\nResponse Body= ' + String.valueOf(result.getBody());
    	}
    	 
    	Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
	    	ApexClass__c = className, 
	        ApexMethod__c = methodName, 
	        Message__c = messageForLog, 
	        MessageCode__c = messagecodeForLog, 
	        RequestData__c = request, 
	        ResponseData__c = response,
	        AccountId__c = accountId
	        //TransactionId__c = 'NO_UUID_SINCE_IT_IS_DIRECT_CALL'
    	);
    	return newApplicationLog;
    }
    /*
    //Log for AOP EOI GetAccountInfo
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoRequestWrapper requestData, EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element response, String quoteId)
    {
    	//ASSUME IT'S SUCCESS & ASSIGN SUCCESS CONSTANTS 
    	String messageForLog = WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGE;
    	String messagecodeForLog = WK_Constants.SVC_CREATECASE_SUCCESS_LOG_MESSAGECODE;
    	
    	if(response == NULL){
    		messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE;
    		messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGECODE;
    	}else{
    		if(response != NULL && response.accountInfoResponse != NULL && response.customerContacts != NULL)
        	{
        		//SUCCESS
        		messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_SUCCESS_MESSAGE;
        		messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_SUCCESS_MESSAGECODE;
    		}else if(response.errorMessages != NULL){
        		//FAILURE
        		System.debug('###: ' + response.errorMessages);
        		messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFOR_UNHANDLED_LOG_CONDITION_MESSAGECODE;
    			messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFOR_UNHANDLED_LOG_CONDITION_MESSAGE;
    			for(EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType objError : response.errorMessages.ErrorMessage)
    			{
	        		if(objError.errorMessageCode == WK_Constants.EOI_GETACCOUNTINFO_INSUFFICIENT_DATA_STATUSCODE){
	        			messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_100_MESSAGECODE;
	        			messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_100_MESSAGE;
	        		}
	        		if(objError.errorMessageCode == WK_Constants.EOI_GETACCOUNTINFO_ACCOUNTNUMBER_NOT_VALID_STATUSCODE){
	        			messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_200_MESSAGECODE;
	        			messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_200_MESSAGE;
	        		}
	        		if(objError.errorMessageCode == WK_Constants.EOI_GETACCOUNTINFO_INTERNAL_SERVER_ERROR_STATUSCODE){
	        			messageForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE;
	    				messagecodeForLog = WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGECODE;
	        		}
    			}
        	}
        }
    	 
    	Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
	    	ApexClass__c = className, 
	        ApexMethod__c = methodName, 
	        Message__c = messageForLog, 
	        MessageCode__c = messagecodeForLog, 
	        RequestData__c = requestData != NULL ? requestData.toString() : '', 
	        ResponseData__c = response != NULL ? response.toString() : '',
	        Quote_ProposalId__c = quoteId,
	        TransactionId__c = requestData.uuidMetaDataRequest.uuid
    	);
    	return newApplicationLog;
    }
    
    //Log for AOP DQ Address Validation
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, EOI_IIB_AddressValidationRequest.Record_element[] request, EOI_IIB_AddressValidationResponse.DataSet_element response, String quoteId)
    {
    	//ASSUME IT'S SUCCESS & ASSIGN SUCCESS CONSTANTS 
    	String messageForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_VALID_MESSAGE;
    	String messagecodeForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_VALID_MESSAGECODE;
    	
    	if(response == NULL){
    		messageForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGE;
    		messagecodeForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGECODE;
    	}else if(response.Record.size() > 0){
        		//RESPONSE RECEIVED BUT CHECK IF ANY OF THE ADDDRESS IS INVALID
        		for(EOI_IIB_AddressValidationResponse.Record_element objResponse : response.Record){
        			if(objResponse.STATUS_CODE != WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_SUCCESS_STATUSCODE){
        				messageForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_INVALID_MESSAGE;
    					messagecodeForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_INVALID_MESSAGECODE;
	        		}
        		}	
		}else{
    		messageForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGE;
			messagecodeForLog = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_FAILURE_MESSAGECODE;
    	}
    	 
    	Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
	    	ApexClass__c = className, 
	        ApexMethod__c = methodName, 
	        Message__c = messageForLog, 
	        MessageCode__c = messagecodeForLog, 
	        RequestData__c = request != NULL ? String.valueOf(request) : '', 
	        ResponseData__c = response != NULL ? String.valueOf(response) : '',
	        Quote_ProposalId__c = quoteId,
	        TransactionId__c = '' // because we SAP DQ Services doesn't accepts any uuid
    	);
    	return newApplicationLog;
    }
    */
    //Log method for exception conditions
    public static Application_Monitoring_Log__c ApplicationLogFromCalloutResponse(String className, String methodName, String request, String response, String recordId, String uuid)
    {
    	Application_Monitoring_Log__c newApplicationLog = new Application_Monitoring_Log__c(
	    	ApexClass__c = className, 
	        ApexMethod__c = methodName, 
	        Message__c = 'EXCEPTION OCCURRED IN : ' + className, 
	        MessageCode__c = !String.isBlank(methodName) ? methodName : 'TECHNICAL_EXCEPTION', 
	        RequestData__c = !String.isBlank(request) ? request : 'Exception', 
	        ResponseData__c = !String.isBlank(response) ? response : 'Exception',
	        TransactionId__c = uuid
    	);
    	
    	if(recordId.startsWith(Account.SobjectType.getDescribe().getKeyPrefix())){
    		newApplicationLog.AccountId__c = recordId;
    		//insert newApplicationLog;
    	}else if(recordId.startsWith(Apttus_Proposal__Proposal__c.SobjectType.getDescribe().getKeyPrefix())){
    		newApplicationLog.Quote_ProposalId__c = recordId; 
    	}else if(recordId.startsWith(ERP_Order__c.SobjectType.getDescribe().getKeyPrefix())){
    		newApplicationLog.ERPOrder__c = recordId;
    		//insert newApplicationLog;
    	}
    	return newApplicationLog;
    }
}