/*
 * Callout class for AOP
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 06/14/2017 SHIVAJI           1.5          AOP1.5 Changes
 * 10/23/2017 SHIVAJI           2.0          AOP2.0 Changes SMS-900
 * ------------------------------------------------------------------------- */

public with sharing class EOI_OrderAutomation 
{
    //Schema.DescribeSObjectResult d = Schema.SObjectType.Apttus_Proposal__Proposal__c;
    //Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        @future(callout = true)
        public static void EOI_PlaceOrder(List<Id> ERPOrderIdList)
        {
            //List<ERP_Order__c> ERPOrderListWithLineItems = [SELECT Authentication_Type__c, Access_Type__c,Renewal_Type__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c WHERE Id in :ERPOrderIdList];
            //START: changes as part of AOP1.5 - Do not send component level items in XML i.e. Line_Type = Option
            List<ERP_Order__c> ERPOrderListWithLineItems = [SELECT Id, Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, 
            													Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, 
            													IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,
            													Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, 
            													Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, 
            													Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, 
            													Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, 
            													Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, 
            													Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, 
            													Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,
            													Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, 
            													SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,
            													MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,
            													MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, Bill_To_Contact_Name__c, Ship_To_Contact_Name__c,
            													Is_Create_New_Bill_To__c, Is_Create_New_Ship_To__c, Is_Update_Selected_Bill_To__c, Is_Update_Selected_Ship_To__c, 
            													(SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r WHERE Line_Type__c != 'Option') 
            													FROM ERP_ORDER__c 
            													WHERE Id IN: ERPOrderIdList];
            //END: changes as part of AOP1.5 - Do not send component level items in XML i.e. Line_Type = Option
            //List<Monitoring_Log__c> monitoringLogList = new List<Monitoring_Log__c>();
            Map<Id, ERP_Order__c> ERPOrderWithRetryLogMap = new Map<Id, ERP_Order__c>([SELECT Id,Name, Quote_Record_Type__c, (SELECT Id, ERPOrderId__c, RetrySequenceNumber__c FROM Webservice_Retry_Log__r) FROM ERP_Order__c WHERE Id in :ERPOrderIdList]);// DESC LIMIT 1];
            
            List<EOI_Retry_Log__c> webserviceRetryLogListToInsert = new List<EOI_Retry_Log__c>();
            List<sobject> logList = new List<sobject>();
            Map<Id, ERP_Order__c> orderListToUpdate = new Map<Id, ERP_Order__c>();
            
            EOI_Retry_Log__c newWebserviceRetryLog;
            for(ERP_Order__c currentERPOrder : ERPOrderListWithLineItems)
            {
                EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType newAccountOrderElement = getMapping(currentERPOrder, currentERPOrder.ERP_Order_Line_Items__r);
                //Validation if Order line Items exceeds max limit allowed
                if(currentERPOrder.ERP_Order_Line_Items__r != null && currentERPOrder.ERP_Order_Line_Items__r.size() > WK_Utility.ServiceIntegrations().MaxLineItemsAllowed__c)
                {
                    EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType dummyResult = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType();
                    EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType ackType= new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType();
                    ackType.StatusCode = WK_Constants.EOI_ORDER_MAXIMUM_ORDERLINES_EXCEEDED_STATUSCODE; 
                    dummyResult.orderSubmissionAcknowledgement = ackType;
                    EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType uuidResponse = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType();
                    uuidResponse.responseDateTime = system.now();
                    dummyResult.uuidMetaDataResponse = uuidResponse;
                    orderListToUpdate.put(currentERPOrder.Id, new ERP_Order__c(Id = currentERPOrder.Id, Order_Submission_Status__c = 'Order Submission Failed'));
                    logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse( 'EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),dummyResult, currentERPOrder.Name, currentERPOrder.Id, WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMISSION_FAILED ));
                }else{
                    EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result;
                    Long start = system.now().getTime();
                    try
                    {
                        EOI_IIB_ERPOrderCallout_V7.TAASalesOrderSubmissionSOAP  stub = new EOI_IIB_ERPOrderCallout_V7.TAASalesOrderSubmissionSOAP();
                        result = stub.TAAOrderSubmission(newAccountOrderElement.ORDER_HEADER,newAccountOrderElement.CONTRACT_PERIODS_PRICE,newAccountOrderElement.CREDIT_CARD,newAccountOrderElement.CUSTOMER_ADDRESS,newAccountOrderElement.CUSTOMER_HEADER,newAccountOrderElement.ORDER_ITEM,newAccountOrderElement.ORDER_TEXT,newAccountOrderElement.SPLIT_SALES,newAccountOrderElement.uuidMetaDataRequest);
                        system.debug('Order has been placed() :: '+result);
                        Long milliseconds = system.now().getTime() - start;
                        system.debug('Time required to make callout to IIB => '+milliseconds);
                        //#RefactorAbstraction done monitoring Log in sobject
                        
                        //logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('weservice callout', 'EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),result.toString(),'', result.orderSubmissionAcknowledgement.Status, result.orderSubmissionAcknowledgement.StatusDescription, currentERPOrder.Id));
                        logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),result, currentERPOrder.Name, currentERPOrder.Id,''));
                        if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_PENDING_STATUSCODE){
                            orderListToUpdate.put(currentERPOrder.Id, new ERP_Order__c(Id = currentERPOrder.Id, Order_Submission_Status__c = 'Pending ERP Submission'));
                        }else{
                            orderListToUpdate.put(currentERPOrder.Id, new ERP_Order__c(Id = currentERPOrder.Id, Order_Submission_Status__c = 'Order Submission Failed'));
                        }
                        system.debug('After Application Log created');
                        //mapOrderAndResult.put(currentERPOrder.Id, result);
                        newWebserviceRetryLog = EOIRetryLogFromCalloutResponse(result, currentERPOrder.Id, ERPOrderWithRetryLogMap);
                        if(newWebserviceRetryLog != null)
                            webserviceRetryLogListToInsert.add(newWebserviceRetryLog);
                    }catch(Exception ex){
                        system.debug('Inside EOI_OrderAutomation'+ex.getMessage());
                        //List<EOI_Retry_Log__c> webserviceLatestRetryLog = [SELECT Id, ERPOrderId__c, RetrySequenceNumber__c FROM EOI_Retry_Log__c  WHERE ERPOrderId__c = :currentERPOrder.Id ORDER BY RetrySequenceNumber__c DESC LIMIT 1];
                        if(result == null)
                        {
                            result = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType();
                            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType ackType= new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType();
                            ackType.StatusCode = WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE; 
                            result.orderSubmissionAcknowledgement = ackType;
                            EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType uuidResponse = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType();
                            uuidResponse.responseDateTime = system.now();
                            result.uuidMetaDataResponse = uuidResponse;
                        }   
                        logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse( 'EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),result, currentERPOrder.Name, currentERPOrder.Id, ex.getMessage()));
                        
                        newWebserviceRetryLog = EOIRetryLogFromCalloutResponse(result, currentERPOrder.Id, ERPOrderWithRetryLogMap);
                        if(newWebserviceRetryLog != null)
                        {
                            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType dummyResult = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType();
                            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType ackType= new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType();
                            ackType.StatusCode = WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE; 
                            dummyResult.orderSubmissionAcknowledgement = ackType;
                            
                            EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType uuidResponse = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType();
                            uuidResponse.responseDateTime = system.now();
                            dummyResult.uuidMetaDataResponse = uuidResponse;
                            //dummyResult.
                            webserviceRetryLogListToInsert.add(newWebserviceRetryLog);
                            orderListToUpdate.put(currentERPOrder.Id, new ERP_Order__c(Id = currentERPOrder.Id, Order_Submission_Status__c = 'Pending ERP Submission'));
                            logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse( 'EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),dummyResult, currentERPOrder.Name, currentERPOrder.Id, 'Order is in Retry to IIB.'));
                        }else{
                            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType dummyResult = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType();
                            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType ackType= new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType();
                            ackType.StatusCode = WK_Constants.EOI_Retry_LIMIT_EXCEED; 
                            dummyResult.orderSubmissionAcknowledgement = ackType;
                            EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType uuidResponse = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType();
                            uuidResponse.responseDateTime = system.now();
                            dummyResult.uuidMetaDataResponse = uuidResponse;
                            orderListToUpdate.put(currentERPOrder.Id, new ERP_Order__c(Id = currentERPOrder.Id, Order_Submission_Status__c = 'Order Submission Failed'));
                            logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse( 'EOI_OrderAutomation', 'EOI_PlaceOrder',newAccountOrderElement.toString(),dummyResult, currentERPOrder.Name, currentERPOrder.Id, WK_Constants.ORD_MONITORING_LOG_TYPE_ERP_ORDER_TRANSMISSION_FAILED ));
                        }
                        //#RefactorAbstraction Done Monitor log in sobject
                        system.debug('End time'+Limits.getCPUTime());  
                    }
            	}
            }	
            try
            {
                /*
                Map<Id, ERP_Order__c> mapOrders = new Map<Id, ERP_Order__c>([SELECT Id, Order_Submission_Status__c, LastModifiedById FROM ERP_Order__c WHERE Id IN: orderListToUpdate.keySet()]);
                for(Id orderId : orderListToUpdate.keySet())
                {
                  System.debug('## : ' + mapOrders.get(orderId).LastModifiedById);
                  System.debug('## : ' + UserInfo.getUserId());
                  System.debug('## : ' + mapOrders.get(orderId).Order_Submission_Status__c);
                  if(mapOrders != NULL && mapOrders.get(orderId).LastModifiedById != UserInfo.getUserId()){
                    orderListToUpdate.remove(orderId);
                  }
                }
                */
                if(!orderListToUpdate.isEmpty()){
                    update orderListToUpdate.values();
                }
                if(!logList.isEmpty()){
                    insert logList;
                }
                if(!webserviceRetryLogListToInsert.isEmpty()){
                    insert webserviceRetryLogListToInsert;
                }
            }catch(Exception ex){
                system.debug(''+ex.getMessage());
            }   
            system.debug('Monitoring Log created');
        }
        
        public static EOI_Retry_Log__c EOIRetryLogFromCalloutResponse(EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result, Id ERPOrderId, Map<Id, ERP_Order__c> ERPOrderWithRetryLogMap)
        {
            String messageForLog = '', messageCode = '';
            system.debug('Inside EOIRetryLogFromCalloutResponse');
            ERP_Order__c newERPOrder = ERPOrderWithRetryLogMap.get(ERPOrderId);
            if(result != null)
            {
                if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_INTERNAL_SERVER_ERROR_STATUSCODE || 
                result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE ||
                result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE ||
                result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED 
                //result.orderSubmissionAcknowledgement.StatusCode == '1'
                )
                {
                    
                    if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_INTERNAL_SERVER_ERROR_STATUSCODE )
                    {
                        messageCode = WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                        messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                        //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                        messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE;
                        messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE;
                        messageForLog = messageForLog + '*** End Invalid Data Block Information *** ';
                        //messageForLog =  'SFDCOrderName= ' + ERPOrderId+ ' Request Status = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGECODE + ' Request Status Description = ' + WK_Constants.EOI_IIB_500_INTERNAL_SERVER_ERROR_MESSAGE ;
                    }
                    else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE )
                    {
                        messageCode = WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE;
                        messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                        //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                        messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
                        messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
                    }
                    else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE)
                    {
                        messageCode = WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGECODE;
                        messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                        //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                        messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE;
                        messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_400_MISSING_DATA_MESSAGE;
                    }
                    else if(result.orderSubmissionAcknowledgement.StatusCode == WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED )
                    {
                        messageCode = WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGECODE;
                        messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                        //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                        messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED;
                        messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_SAP_EXCEPTION_504_EXTERNAL_GATEWAY_ERROR_MESSAGE;
                    }
                    else if(result.orderSubmissionAcknowledgement.StatusCode == '1')
                    {
                        messageCode = 'EOI_FAILED_TO_LOAD_IN_IIB';
                        messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        //messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                        messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                        //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.UUID;
                        messageForLog = messageForLog + ': calloutResponse.statusCode= ' + '1';
                        messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + 'Failed to load in IIB';
                    }
                    
                }
            }
            else
            {
                
                messageCode = WK_Constants.EOI_EXCEPTION_AOP_SFDC_IIB_503_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.sfdc_OrderIDKey= ' + newERPOrder.Name;
                //messageForLog = messageForLog + ': calloutResponse.responseDateTime= ' + string.valueOfGmt(result.uuidMetaDataResponse.responseDateTime);
                //messageForLog = messageForLog + ' : calloutResponse.UUID= ' + result.uuidMetaDataResponse.uuid;
                messageForLog = messageForLog + ': calloutResponse.statusCode= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGECODE;
                messageForLog = messageForLog + ': calloutResponse.statusDescription= ' + WK_Constants.EOI_IIB_503_SERVER_MAINTENANCE_MESSAGE;
            }
            if(!String.isBlank(messageCode) && !String.isBlank(messageForLog))
            {
                EOI_Retry_Log__c newEOIRetryLog;
                if(newERPOrder.Webservice_Retry_Log__r != null && newERPOrder.Webservice_Retry_Log__r.size() > 0)
                {
                    Integer retrySequence = 1;
                    for(EOI_Retry_Log__c currentRetryLog : newERPOrder.Webservice_Retry_Log__r)
                    {
                        if(Integer.valueOf(currentRetryLog.RetrySequenceNumber__c) > retrySequence)
                        {
                            retrySequence = Integer.valueOf(currentRetryLog.RetrySequenceNumber__c);
                        }
                    }
                    if(  retrySequence < WK_Utility.ServiceIntegrations().NoOfRetries__c)
                    {
                        newEOIRetryLog = new EOI_Retry_Log__c(ERPOrderId__c = ERPOrderId, RetrySequenceNumber__c = String.ValueOf(retrySequence+1), Detail__c = messageForLog, RetryReasonCode__c = messageCode,RetryInterval__c = String.valueOf(WK_Utility.ServiceIntegrations().RetryInterval_Timeout__c), LogEntryDateTime__c = System.now());
                    }
                }
                else
                {
                    newEOIRetryLog = new EOI_Retry_Log__c(ERPOrderId__c = ERPOrderId, RetrySequenceNumber__c = '1', Detail__c = messageForLog, RetryReasonCode__c = messageCode, RetryInterval__c=String.valueOf(WK_Utility.ServiceIntegrations().RetryInterval_Timeout__c),LogEntryDateTime__c = System.now());
                }
                return newEOIRetryLog;
            }
            return null;
        }
    
        
        
        private static EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType getMapping(ERP_Order__c orderDetailsObj, List<ERP_Order_Line_Item__c> orderLineItemList)
        {
            //ERP_Order__c orderDetailsObj = newERPOrder;
            //system.debug('ERP Order Id in save method'+newERPOrder);
            //EOI_IIB_ERPOrderCallout_V7.HTTPS_Port orderAutomationStub = new EOI_IIB_ERPOrderCallout_V7.HTTPS_Port();
            
            //#TechnicalDebt If this class throws an error, what happens?
            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType sfdc_acc_element = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType ();
            
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERArrayType  customer_Header_Element= new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERArrayType ();
            
            List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType> customer_Header_List = new List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType>();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType customer_Header = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType();
            //Need to reevaluate
            customer_Header.PARTNER_NUMBER = orderDetailsObj.Customer_X_Ref__r.ApplicationID__c;
            
            //*** AOP2.0 REQUEST_TYPE
            customer_Header.REQUEST_TYPE = WK_Constants.EOI_EXISTING;
            if(orderDetailsObj.Customer_X_Ref__c == NULL && orderDetailsObj.Is_Create_New_Bill_To__c && orderDetailsObj.Is_Create_New_Ship_To__c){
            	customer_Header.REQUEST_TYPE = WK_Constants.EOI_NEW;
            	customer_Header.PARTNER_NUMBER = WK_Constants.EOI_BLANK;
            }
            //*** AOP2.0 REQUEST_TYPE
            
            //customer_Header.ITEM_NUMBER = '1';
            customer_Header.PARTNER_TYPE = 'AG';
            customer_Header.COMPANYNAME = orderDetailsObj.SFDC_Account__r.Name;
            customer_Header.FIRSTNAME = orderDetailsObj.Primary_Contact__r.FirstName;
            customer_Header.LASTNAME = orderDetailsObj.Primary_Contact__r.LastName;
            customer_Header.IDTYPE = 'SFDC-TAA';
            customer_Header.IDNUMBER = orderDetailsObj.SFDC_Account__c;
            customer_Header.SALES_ORG = 'US10';
            customer_Header.DISTR_CHANNEL = '10';
            customer_Header.DIVISION = '10';
            //customer_Header.CUST_GROUP = 
            customer_Header.CUST_GROUP1 = orderDetailsObj.SFDC_Account__r.Market_Segment__c;
            customer_Header.CUST_GROUP2 = orderDetailsObj.SFDC_Account__r.Market_Sub_Segment__c;
            //customer_Header.CUST_GROUP5
            customer_Header.ACCESS_TYPE = (orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_All) ? '01'
                                            :(orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_All_Link) ? '02'
                                            :(orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_Limited) ? '03'
                                            :'';
            //customer_Header.USER_TYPE
            customer_Header.IDISSUED = string.valueOf(orderDetailsObj.IDs_to_be_issued__c);
            customer_Header.MAXUSER = string.valueOf(orderDetailsObj.Max_IDs_allowed__c);
            //customer_Header.concurrentUser = orderDetailsObj.Number_of_Concurrent_Users__c
            customer_Header.DA_FIRSTNAME = orderDetailsObj.IC_Admin_First_Name__c;
            customer_Header.DA_LASTNAME = orderDetailsObj.IC_Admin_Last_Name__c;
            customer_Header.DA_PHONE = orderDetailsObj.IC_Admin_Phone__c;
            customer_Header.DA_EMAIL = orderDetailsObj.IC_Admin_Email__c;
            
            customer_Header_List.add(customer_Header);
            customer_Header_Element.CUSTOMER_HEADERs = customer_Header_List;
            sfdc_acc_element.CUSTOMER_HEADER = customer_Header_Element;
            
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSArrayType customer_Address_Element = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSArrayType();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType[] customer_Address_List = new List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType>();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType customer_Address = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType();
            
            //*** AOP2.0 Send only Ship-To (RE) if both parties to be newly created and address is exactly same
            if(!(orderDetailsObj.Is_Create_New_Bill_To__c && orderDetailsObj.Is_Create_New_Ship_To__c 
            	&& orderDetailsObj.Ship_To_Street_1__c == orderDetailsObj.Bill_To_Street_1__c
            	&& orderDetailsObj.Ship_To_Street_2__c == orderDetailsObj.Bill_To_Street_2__c
            	&& orderDetailsObj.Ship_To_City__c == orderDetailsObj.Bill_To_City__c
            	&& orderDetailsObj.Ship_To_Postal_Code__c == orderDetailsObj.Bill_To_Postal_Code__c
            	&& orderDetailsObj.Ship_To_State__c == orderDetailsObj.Bill_To_State__c
            	&& orderDetailsObj.Ship_To_Country__c == orderDetailsObj.Bill_To_Country__c)){
		            //Need to reevaluate
		            customer_Address.PARTNER_NUMBER = orderDetailsObj.Bill_To_Partner_Number__c;
		            
		            //*** AOP2.0 REQUEST_TYPE, COMPANY_NAME, FIRST_NAME, LAST_NAME
		            customer_Address.REQUEST_TYPE = WK_Constants.EOI_EXISTING;
		            if(orderDetailsObj.Is_Create_New_Bill_To__c || orderDetailsObj.Is_Update_Selected_Bill_To__c){
		            	customer_Address.REQUEST_TYPE = WK_Constants.EOI_NEW;
		            	customer_Address.PARTNER_NUMBER = WK_Constants.EOI_BLANK;
		            }
		            
		            customer_Address.COMPANY_NAME = orderDetailsObj.SFDC_Account__r.Name;
		            String[] billToContactNames = orderDetailsObj.Bill_To_Contact_Name__c != NULL ? orderDetailsObj.Bill_To_Contact_Name__c.split(' ') : NULL;
		            if(billToContactNames != NULL && billToContactNames.size() > 0){  
		            	customer_Address.FIRST_NAME = billToContactNames[0];
		            }
		            
		            if(billToContactNames != NULL && billToContactNames.size() > 1){  
		            	customer_Address.LAST_NAME = billToContactNames[1];
		            }
		            //*** AOP2.0 REQUEST_TYPE, COMPANY_NAME, FIRST_NAME, LAST_NAME
		             
		            customer_Address.PARTNER_TYPE = 'RE';
		            //Need to reevaluate
		            customer_Address.ITEM_NUMBER = '000000';
		            customer_Address.STREET = orderDetailsObj.Bill_To_Street_1__c;
		            customer_Address.BUILDING = orderDetailsObj.Bill_To_Street_2__c; 
		            //customer_Address.FLOOR;
		            //customer_Address.ROOMNUMBER;
		            customer_Address.CITY = orderDetailsObj.Bill_To_City__c;
		            //customer_Address.DISTRICT;
		            customer_Address.CITY_PCODE = orderDetailsObj.Bill_To_Postal_Code__c;
		            customer_Address.STATE = orderDetailsObj.Bill_To_State__c;
		            customer_Address.COUNTRY = orderDetailsObj.Bill_To_Country__c;
		            //customer_Address.PO_BOX;
		            //customer_Address.PO_BOX_POSTAL_CODE;
		            //customer_Address.PO_BOX_CITY;
		            //customer_Address.PO_BOX_REGION;
		            customer_Address.TEL_NUMBER = orderDetailsObj.Bill_To_Phone__c;
		            //customer_Address.EXTENSION;
		            //customer_Address.EMAIL
		            customer_Address_List.add(customer_Address);
        	}
            customer_Address = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType();
            //Need to reevaluate
            customer_Address.PARTNER_NUMBER = orderDetailsObj.Ship_To_Partner_Number__c; 
            
            //*** AOP2.0 REQUEST_TYPE, COMPANY_NAME, FIRST_NAME, LAST_NAME
            customer_Address.REQUEST_TYPE = WK_Constants.EOI_EXISTING;
            if(orderDetailsObj.Is_Create_New_Ship_To__c || orderDetailsObj.Is_Update_Selected_Ship_To__c){
            	customer_Address.REQUEST_TYPE = WK_Constants.EOI_NEW;
            	customer_Address.PARTNER_NUMBER = WK_Constants.EOI_BLANK;
            }
            
            customer_Address.COMPANY_NAME = orderDetailsObj.SFDC_Account__r.Name;
            String[] shipToContactNames = orderDetailsObj.Ship_To_Contact_Name__c != NULL ? orderDetailsObj.Ship_To_Contact_Name__c.split(' ') : NULL;
            if(shipToContactNames != NULL && shipToContactNames.size() > 0){  
            	customer_Address.FIRST_NAME = shipToContactNames[0];
            }
            
            if(shipToContactNames != NULL && shipToContactNames.size() > 1){  
            	customer_Address.LAST_NAME = shipToContactNames[1];
            }
            //*** AOP2.0 REQUEST_TYPE, COMPANY_NAME, FIRST_NAME, LAST_NAME
            
            customer_Address.PARTNER_TYPE = 'WE';
            //Need to reevaluate
            customer_Address.ITEM_NUMBER = '000000';
            customer_Address.STREET = orderDetailsObj.Ship_To_Street_1__c;
            customer_Address.BUILDING = orderDetailsObj.Ship_To_Street_2__c; 
            //customer_Address.FLOOR;
            //customer_Address.ROOMNUMBER;
            customer_Address.CITY = orderDetailsObj.Ship_To_City__c;
            //customer_Address.DISTRICT;
            customer_Address.CITY_PCODE = orderDetailsObj.Ship_To_Postal_Code__c;
            customer_Address.STATE = orderDetailsObj.Ship_To_State__c;
            customer_Address.COUNTRY = orderDetailsObj.Ship_To_Country__c;
            //customer_Address.PO_BOX;
            //customer_Address.PO_BOX_POSTAL_CODE;
            //customer_Address.PO_BOX_CITY;
            //customer_Address.PO_BOX_REGION;
            customer_Address.TEL_NUMBER = orderDetailsObj.Ship_To_Phone__c;
            //customer_Address.EXTENSION;
            //customer_Address.EMAIL
            customer_Address_List.add(customer_Address);
            
            customer_Address = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType();
            customer_Address.PARTNER_NUMBER = orderDetailsObj.Selling_DTN__c; 
            customer_Address.PARTNER_TYPE = 'Z3';
            customer_Address.ITEM_NUMBER = '000000';
            customer_Address_List.add(customer_Address);
            
            customer_Address_Element.CUSTOMER_ADDRESSs = customer_Address_List;
            sfdc_acc_element.CUSTOMER_ADDRESS = customer_Address_Element;
            
            //EOI_IIB_ERPOrderCallout_V7.ZSSD_ORDER_HEADER[] order_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ORDER_HEADER_element>();
            EOI_IIB_ERPOrderCallout_V7.ORDER_HEADERType order_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_HEADERType();
            order_Element.DOC_TYPE =  (orderDetailsObj.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription && orderDetailsObj.ASA__c)?'ZASC':((orderDetailsObj.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books )?'ZS00':'ZC01');
            order_Element.FLAG = (orderDetailsObj.Stub_Flag__c == true)?'01':((orderDetailsObj.MYA__c)?'02':'');
            order_Element.SALES_ORG = 'US10';
            order_Element.DISTR_CHANNEL = '10';
            order_Element.DIVISION = '10';
            order_Element.CONTACT_CHANNEL='0004';
            order_Element.SALES_CHANNEL = '102020';
            order_Element.STARTDATE = (orderDetailsObj.Stub_Flag__c)?orderDetailsObj.Stub_Year_Start_Date__c:((orderDetailsObj.ASA__c)?orderDetailsObj.Advance_Start_Date__c:orderDetailsObj.Contract_Start_Date__c);//string.valueOf(orderDetailsObj.Contract_Start_Date__c);
            order_Element.ENDDATE = (orderDetailsObj.MYA__c)?orderDetailsObj.MYA_Term_End_Date__c:orderDetailsObj.Contract_End_Date__c;//orderDetailsObj.Contract_End_Date__c;//string.valueOf(orderDetailsObj.Contract_End_Date__c);
            //order_Element.ORDER_REASON = ;
            order_Element.YOUR_REFERENCE = orderDetailsObj.Name;
            order_Element.PAYMENT_TERM = orderDetailsObj.Payment_Term__c;
            order_Element.SHIP_COND = (orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_First_Class)?'01'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Ground_parcel)?'06'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_International_Air)?'07'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Next_Day_AM_Delivery)?'09'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Next_Day_PM_Delivery)?'10'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_2nd_Day_Delivery)?'03'
                                        :'';
            order_Element.AUTH_TYPE = (orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard)?'1'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_IP)?'3'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Refer)?'5'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard_IP)?'6'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Refer_IP)?'8'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard_Refer)?'7'
                                        :'';
            //order_Element.USER_TYPE;
            order_Element.IDISSUED = string.valueOf(orderDetailsObj.IDs_to_be_issued__c);
            order_Element.MAXUSER = string.valueOf(orderDetailsObj.Max_IDs_allowed__c);
            order_Element.CONCURRENCY = string.valueOf(orderDetailsObj.Number_of_Concurrent_Users__c);
            //order_ELement_List.add(order_Element);
            sfdc_acc_element.ORDER_HEADER = order_Element;
            
            
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTArrayType order_Element_Text = new EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTArrayType();
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType[] order_Text_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType>();
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType order_Text_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType();
            if(orderDetailsObj.One_Line_Invoice_Header__c != NULL){
            	order_Text_Element.TEXT_ID = 'Z002';
            }else{
            	order_Text_Element.TEXT_ID = '';
            }            
            //order_Text_Element.TEXT_OBJECT = '';
            order_Text_Element.HEADER_TEXT = orderDetailsObj.One_Line_Invoice_Header__c;
            order_Text_ELement_List.add(order_Text_Element);
            order_Element_Text.ORDER_TEXTs = order_Text_ELement_List;
            sfdc_acc_element.ORDER_TEXT = order_Element_Text;
            
            EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMArrayType order_Item_Ele =new EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMArrayType();
            EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType[] order_Item_ELement_List =new List<EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType>();
            
            EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType contract_Period_Price = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType();
            EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType[] contract_Period_PriceTypeList = new List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType>();
            //EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType contract_Period_Price; 
            system.debug('Iterate Line Items ');
            integer countLineItems = 1;
            for(ERP_Order_Line_Item__c newOrderLineItem : orderLineItemList)
            {
                system.debug('Order Item '+newOrderLineItem.Product_Code__c);
                EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType order_Item_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType();
                order_Item_Element.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                order_Item_Element.BUNDLE = newOrderLineItem.Parent_Product__r.ProductCode;
                order_Item_Element.MATERIAL= newOrderLineItem.Product_Code__c;
                order_Item_Element.QUANTITY = Integer.valueOf(newOrderLineItem.Quantity__c);
                order_Item_Element.STANDING_ORDER = (orderDetailsObj.Renewal_Type__c=='Opt-In (Standing Order)'?'Y':'N');
                order_Item_Element.DELIV_PRIORITY = (orderDetailsObj.Rush_Order__c)?'01':'02';
                order_Item_Element.RENEWALTYPE = (orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_In_OBR)?'02'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order)?'00'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_Out_CBR)?'01'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Exempt_Manual_Renewal)?'03'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Not_Applicable_TC)?'04'
                                                    :'';
                order_Item_Element.PROMOCODE = newOrderLineItem.Promo_Code__c;
                //order_Item_Element.BILLINGPLAN_TYPE = ;
                order_Item_Element.FV_DATE = (orderDetailsObj.ASA__c)?orderDetailsObj.Contract_Start_Date__c:null;//String.valueof(orderDetailsObj.Contract_Start_Date__c);
                order_Item_ELement_List.add(order_Item_Element);
                
                
                //Contract Value
                List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType> testList  = getContractPeriodPrice(orderDetailsObj, newOrderLineItem, countLineItems++);
                system.debug('TestList '+testList);
                contract_Period_PriceTypeList.addAll(testList);
                
            }
            system.debug('Final COntract value List :: '+contract_Period_PriceTypeList);
            order_Item_Ele.ORDER_ITEMs = order_Item_ELement_List;
            sfdc_acc_element.ORDER_ITEM = order_Item_Ele;
            
            contract_Period_Price.CONTRACT_PERIODS_PRICEs = contract_Period_PriceTypeList;
            sfdc_acc_element.CONTRACT_PERIODS_PRICE = contract_Period_Price;
            
            if(!String.isBlank(orderDetailsObj.Split_Commission__c) && orderDetailsObj.Split_Commission__c != '100% selling rep/0% inventory rep')
            {
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESArrayType split_Sales_ELe = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESArrayType();
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType[] split_Sales_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType>();
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType split_Sales_Element = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType();
                split_Sales_Element.ITEM_NUMBER = '000000';
                system.debug('Selling_DTN'+orderDetailsObj.Selling_DTN__c);
                split_Sales_Element.SALES_DTN = orderDetailsObj.Selling_DTN__c;
                split_Sales_Element.SALES_PERC = (orderDetailsObj.Split_Commission__c=='100% selling rep/0% inventory rep')?100
                                                :(orderDetailsObj.Split_Commission__c=='80% selling rep/20% inventory rep')?80
                                                :(orderDetailsObj.Split_Commission__c=='50% selling rep/50% inventory rep')?50
                                                :(orderDetailsObj.Split_Commission__c=='20% selling rep/80% inventory rep')?20
                                                :0;
                //orderDetailsObj.Inventory_DTN__c
                split_Sales_ELement_List.add(split_Sales_Element);
                split_Sales_Element = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType();
                split_Sales_Element.ITEM_NUMBER = '000000';
                split_Sales_Element.SALES_DTN = orderDetailsObj.Inventory_DTN__c;
                split_Sales_Element.SALES_PERC = (orderDetailsObj.Split_Commission__c=='100% selling rep/0% inventory rep')?0
                                                :(orderDetailsObj.Split_Commission__c=='80% selling rep/20% inventory rep')?20
                                                :(orderDetailsObj.Split_Commission__c=='50% selling rep/50% inventory rep')?50
                                                :(orderDetailsObj.Split_Commission__c=='20% selling rep/80% inventory rep')?80
                                                :0;
                                                
                split_Sales_ELement_List.add(split_Sales_Element);
                split_Sales_ELe.SPLIT_SALESs = split_Sales_ELement_List;
                sfdc_acc_element.SPLIT_SALES = split_Sales_ELe;
            }
            
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDArrayType credit_Card_Ele = new EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDArrayType(); 
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType[] credit_Card_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType>();
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType credit_Card_element = new EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType();
            credit_Card_element.CC_TYPE = (orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_American_Express)?'AMEX'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Discover)?'DISC'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Master_Card)?'MC'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Visa)?'VISA'
                                            :'';
            credit_Card_element.CC_NUMBER = orderDetailsObj.Credit_Card_Cyber_Source_Token__c;
            credit_Card_element.CC_VALID_T = orderDetailsObj.Credit_Card_Expiration__c;//string.valueOf(orderDetailsObj.Credit_Card_Expiration__c);
            credit_Card_element.CC_NAME = orderDetailsObj.Name_on_Card__c;
            credit_Card_ELement_List.add(credit_Card_element);
            credit_Card_Ele.CREDIT_CARDs = credit_Card_ELement_List;
            sfdc_acc_element.CREDIT_CARD = credit_Card_Ele;
            
            
            /*
            EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element[] item_Price_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element>();
            EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element item_Price_element = new EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element();
            item_Price_element.COND_TYPE = 'ZD03';
            //item_Price_element.COND_PERCEN = '10';//need to discuss
            //item_Price_element.COND_VALUE
            item_Price_ELement_List.add(item_Price_element);
            sfdc_acc_element.ITEM_PRICE = item_Price_ELement_List;
            
            /*EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element[] partner_Details_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element>();
            EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element partner_Detail_element = new EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element();
            //partner_Detail_element.ITEM_NUMBER;
            partner_Detail_element.PARTNER_TYPE = 'RE';
            partner_Detail_element.PARTNERNUMBER =  orderDetailsObj.Bill_To_Partner_Number__c;
            partner_Details_ELement_List.add(partner_Detail_element);
            sfdc_acc_element.PARTNER_DETAILS = partner_Details_ELement_List;
            * /
            EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element[] message_Id_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element>();
            EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element message_Id_Element = new EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element();
            //message_Id_Element.SFDC_ID ;
            //message_Id_Element.IIB_ID;
            //message_Id_Element.SAPPI_ID
            message_Id_ELement_List.add(message_Id_Element);
            sfdc_acc_element.MESSAGE_ID = message_Id_ELement_List;
            
            EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element []stub_Details_List = new List<EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element>();
            EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element stub_Details = new EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element();
            stub_Details.DOC_TYPE = '';
            stub_Details.VALID_FROM = '';
            stub_Details.VALID_TO = '';
            stub_Details.ITEM_NO = '';
            stub_Details.COND_TYPE = '';
            stub_Details.COND_PERCEN = '';
            stub_Details.COND_VALUE = '';
            stub_Details.PROMOCODE = '';
            stub_Details_List.add(stub_Details);
            sfdc_acc_element.STUB_DETAILS = stub_Details_List;
           
            
            */
            
            EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataRequestType newUUIDMetaDataRequestType = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataRequestType();
            newUUIDMetaDataRequestType.uuid = WK_Utility.UUID_Generator();
            newUUIDMetaDataRequestType.targetSystemName = 'IIB';
            newUUIDMetaDataRequestType.sourceSystemName = WK_Utility.ServiceIntegrations().SourceSystemName__c;
            newUUIDMetaDataRequestType.requestDateTime = Date.Today();
            //Need to verify with Jack
            newUUIDMetaDataRequestType.providingSystemName = WK_Utility.ServiceIntegrations().SourceSystemName__c;
            newUUIDMetaDataRequestType.uniqueCallingUserId = UserInfo.getName()+'_'+UserInfo.getUserId();
            newUUIDMetaDataRequestType.transactionMonitoringFlag = WK_Utility.ServiceIntegrations().TransactionMonitoringFlag__c;
            newUUIDMetaDataRequestType.loggingFlag = WK_Utility.ServiceIntegrations().LoggingFlag__c;
            newUUIDMetaDataRequestType.serviceVersion = WK_Utility.ServiceIntegrations().ServiceVersion__c;
            //newUUIDMetaDataRequestType.svcUsername;
            //newUUIDMetaDataRequestType.svcPassword;
            //newUUIDMetaDataRequestType.callingSystemBatchId;
            sfdc_acc_element.uuidMetaDataRequest = newUUIDMetaDataRequestType;
            
            return sfdc_acc_element;
        }
        
        private static List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType> getContractPeriodPrice(ERP_Order__c newERPOrder, ERP_Order_Line_Item__c newERPOrderLineItem, integer countLineItems)
        {
                EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType[] contract_Period_PriceTypeList = new List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType>();
                EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType contract_Period_PriceType;// = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType();
                
                system.debug('!newERPOrder.ASA__c'+!newERPOrder.ASA__c);
                system.debug('!newERPOrder.Stub_Flag__c'+!newERPOrder.Stub_Flag__c);
                system.debug('!newERPOrder.MYA__c'+!newERPOrder.MYA__c);
                system.debug('newERPOrder.Quote_Record_Type__c'+newERPOrder.Quote_Record_Type__c);
                system.debug('WK_Constants.EOI_QuoteRecordType_SAP_Subscription'+WK_Constants.EOI_QuoteRecordType_SAP_Subscription);
                if(!newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c)
                {
                    if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                    {
                        system.debug('Inside ASA=MYA__c=Stub_Flag__c=FLASE=>SAP_Subscription');
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPYM'; //NETP
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                        //END: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                    }
                    else if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books && !(newERPOrder.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order))
                    {
                        system.debug('Inside ASA=MYA__c=Stub_Flag__c=FLASE=>SAP_Books');
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZS00';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZP03';
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZS00';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                        //END: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZS00';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZP05';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                    }
                }
                
                if(!newERPOrder.ASA__c && newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                
                if(newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    system.debug('*******  Entered ASA Contract Period Price ******!newERPOrder.ASA__c'+!newERPOrder.ASA__c);
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                
                if(!newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 2)
                    {   
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    //************
                    if(newERPOrder.MYA_Term__c >= 3)
                    {
                        //START: changes as part of AOP1.5
                        /*                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                        //END: changes as part of AOP1.5

                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 4)
                    {
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 5)
                    {
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
						
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    //*****************
                }
                if(!newERPOrder.ASA__c && newERPOrder.Stub_Flag__c && newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    
                    //*************
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 2)
                    {   
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    //************
                    if(newERPOrder.MYA_Term__c >= 3)
                    {
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 4)
                    {
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 5)
                    {
                        //START: changes as part of AOP1.5
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
						*/
						//END: changes as part of AOP1.5
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        //START: changes as part of AOP1.5
                        //contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_TYPE = 'NETP';
                        //SAPRD-1368
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c;
                        //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c / newERPOrderLineItem.Quantity__c;
                        //END: changes as part of AOP1.5
                        //SAPRD-1368
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);

                    }
                    //*****************
                }
                
                if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books && newERPOrder.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    //START: changes as part of AOP1.5
                    //contract_Period_PriceType.COND_TYPE = 'ZP03';
                    //contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceType.COND_TYPE = 'NETP';
                    contract_Period_PriceType.COND_VALUE = newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN = newERPOrderLineItem.Net_Adjustment__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //END: changes as part of AOP1.5
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(countLineItems * 10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZP05';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                return contract_Period_PriceTypeList;
                //contract_Period_Price.CONTRACT_PERIODS_PRICEs = contract_Period_PriceTypeList;
                //sfdc_acc_element.CONTRACT_PERIODS_PRICE = contract_Period_Price;
        }
}