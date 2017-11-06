global with sharing class EOI_SendOrderToERP_Callback_V2 {

    //comment:
    
    public static list<ErrorMessagesType> catchedException = new list<ErrorMessagesType>();
    
    global class callbackInfo{
        Webservice String statusCode{get;set;}
        Webservice String statusDescription{get;set;}
        Webservice String erp_OrderIDKey{get;set;}
        Webservice String sfdc_OrderIDKey{get;set;}
        Webservice String providerSystemName{get;set;}
        Webservice DateTime responseDateTime{get;set;}
        Webservice String esbHostName{get;set;}
        Webservice String esbBrokerName{get;set;}
        Webservice String UUID{get;set;}
        Webservice list<MESSAGE_ID_Type> listOfTransactionIDs{get;set;}
        Webservice list<SAP_RETURN_Type> listOfSAPReturnResults{get;set;}
        Webservice list<SALES_DOCUMENTS_Type> listOfSAPSalesDocuments{get;set;}
    }
    
    global class callbackInfoReturn{
        Webservice String statusCode{get;set;}
        Webservice String statusDescription{get;set;}
        Webservice String monitorLogID{get;set;}
        Webservice String UUID{get;set;}
        Webservice String sfdc_orderURL{get;set;}
        Webservice list<ErrorMessagesType> listOfException{get;set;}
    } 
    
    global class ErrorMessagesType {
        Webservice String errorMessageCode{get;set;}
        Webservice String errorMessageDescription{get;set;}
    }
    
    global class MESSAGE_ID_Type {
        Webservice String SFDC_ID{get;set;}  // SFDC Transaction ID SFDC generates this GUID to be carried
                                             // through all three tiers: SAP represents as CHAR 60
        Webservice String IIB_ID{get;set;}   // IIB Transaction ID: IIB Generates its own independent GUID. SAP represents as CHAR 60
        Webservice String SAPPI_ID{get;set;} // SAP PI Transaction ID: SAP Will generate its own independent GUID: SAP represents as CHAR 60
    }
    
    global class SAP_RETURN_Type{
        Webservice String TYPE{get;set;}        // Message Type in set {E, W, S } E=Error, W=Warning, S=Success
        Webservice String ID{get;set;}          // Designate the Source System - in this case SFDC or SFDC-TAA
        Webservice String SAP_NUMBER{get;set;}  // SAP Error Code (NUMBER is reserved: changed to SAP_NUMBER)
        Webservice String MESSAGE{get;set;}     // SAP Error Message
        Webservice String MESSAGE_V1{get;set;}  // Other Additional Details (optional) that noone from SAP team can fully explain.
        Webservice String MESSAGE_V2{get;set;}  // Other Additional Details (optional) that noone from SAP team can fully explain.
        Webservice String MESSAGE_V3{get;set;}  // Other Additional Details (optional) that noone from SAP team can fully explain.
        Webservice String MESSAGE_V4{get;set;}  // Other Additional Details (optional) that noone from SAP team can fully explain.
    }     
    
    global class SALES_DOCUMENTS_Type {
        Webservice String SOURCE_ORDER_ID{get;set;} // SFDC ORder ID:  SAP represents as CHAR 12
        Webservice String SAP_DOC_ID{get;set;}      // SAP Document ID
        Webservice String SAP_DOC_TYPE{get;set;}    // SAP Document Type:  Need Types.....
    }
    
    public static void FormListOfException(String errorMsg, String errorCode){
        system.debug('Exception Occured  '+errorMsg);
        ErrorMessagesType tmpExceptionObject = new ErrorMessagesType();
        tmpExceptionObject.errorMessageCode = errorCode;
        tmpExceptionObject.errorMessageDescription = errorMsg;
        catchedException.add(tmpExceptionObject);
    }
    
     webservice static callbackInfoReturn callbackOrderProcessingStatus(callbackInfo objExternalCallbackInfo){
        
        system.debug('***Start: callbackOrderProcessingStatus method ' + objExternalCallbackInfo);
        
        EOI_SendOrderToERP_Callback_V2.callbackInfoReturn returncallbackInfo = new EOI_SendOrderToERP_Callback_V2.callbackInfoReturn();
        //boolean isErrorOccur = false;
        //Custom Exceptions....
        //WK_Exception wkException = new WK_Exception();
        
        system.debug('***Before Try statement');
        
        try{
        
            SAP_RETURN_Type objSAP_RETURN_Type;
            MESSAGE_ID_Type objMESSAGE_ID_Type;
            SALES_DOCUMENTS_Type objSALES_DOCUMENTS_Type;
            
            List<SAP_RETURN_Type> objlistOfSAPReturnResults;
            List<MESSAGE_ID_Type> objlistOfTransactionIDs;    
            List<SALES_DOCUMENTS_Type> objlistOfSAPSalesDocuments;
            
            system.debug('***Before list nulltest statement');
            String returnWarningMessageDescription = 'Callback Message successfully processed with Errors: ';
            
            If (objExternalCallbackInfo.listOfSAPReturnResults == Null) {
                system.debug('***Null listOfSAPReturnResults');
                returnWarningMessageDescription = 'SAP return results are missing.';    
            } 
            else {
                objSAP_RETURN_Type = objExternalCallbackInfo.listOfSAPReturnResults[0];
                objlistOfSAPReturnResults = objExternalCallbackInfo.listOfSAPReturnResults;
                system.debug('*** Test of list objects: objSAP_RETURN_Type=' + objSAP_RETURN_Type + ' objlistOfSAPReturnResults= ' + objlistOfSAPReturnResults);
            }
            
            If (objExternalCallbackInfo.listOfTransactionIDs == Null) {
                system.debug('***Null listOfTransactionIDs');
                returnWarningMessageDescription = 'SAP return results are missing.';
            }
            else {
                objMESSAGE_ID_Type = objExternalCallbackInfo.listOfTransactionIDs[0];
                objlistOfTransactionIDs = objExternalCallbackInfo.listOfTransactionIDs;
                system.debug('*** Test of list objects: objMESSAGE_ID_Type=' + objMESSAGE_ID_Type + ' objlistOfTransactionIDs= ' + objlistOfTransactionIDs);
            }
            
            If (objExternalCallbackInfo.listOfSAPSalesDocuments == Null) {
                system.debug('***Null listOfSAPSalesDocuments');
                returnWarningMessageDescription = 'SAP return results are missing.';
            }
            else {
                objSALES_DOCUMENTS_Type = objExternalCallbackInfo.listOfSAPSalesDocuments[0];
                objlistOfSAPSalesDocuments = objExternalCallbackInfo.listOfSAPSalesDocuments;
                system.debug('*** Test of list objects: objSALES_DOCUMENTS_Type=' + objSALES_DOCUMENTS_Type + ' objlistOfSAPSalesDocuments= ' + objlistOfSAPSalesDocuments);
            }
               
            system.debug('***Before listsizetest statement');

            
            ID erpOrderID;
            String returnWarningMessageCode;
        
            system.debug('***Before List Assignment statement');
        
            List <ERP_Order__c> ERPOrderIdList = new List <ERP_Order__c>( [Select Id, Order_Submission_Status__c, ERP_System_Order_ID__c from ERP_Order__c where Name = :objExternalCallbackInfo.sfdc_OrderIDKey]);        
            
            system.debug('***ERPOrderIdList.Size()= ' + ERPOrderIdList.size());
            
            If (string.valueOf(objExternalCallbackInfo.erp_OrderIDKey) == '' || string.valueOf(objExternalCallbackInfo.erp_OrderIDKey) == NULL) {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' erp_OrderIDKey Missing ';
            }
            If (string.valueOf(objExternalCallbackInfo.sfdc_OrderIDKey) == '') {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' sfdc_OrderIDKey Missing ';
            }
            If (objExternalCallbackInfo.UUID == '') {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' UUID  Missing ';            
            }
            
            If (objExternalCallbackInfo.responseDateTime == Null) {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' responseDateTime  Missing ';            
            }

            If (objExternalCallbackInfo.statusCode == '') {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' statusCode  Missing ';            
            }
            
            
            If (objExternalCallbackInfo.statusDescription == '') {
                    returnWarningMessageCode = '201';
                    returnWarningMessageDescription = returnWarningMessageDescription + ' statusDescription  Missing ';            
            }
                                    

            //Step 1: We need the Correct Order ID to use for logging:
            

             if (ERPOrderIdList.size() == 1) {   
                 erpOrderID = ERPOrderIdList[0].Id;
             }   
                        
            system.debug('***erpOrderID= ' + erpOrderID);
            
            //The order Order_Submission_Status__c needs to be set to Status 
            // failure = Order Submission Failed
            // success = Finalized / Complete in ERP  
            // Also we need to set the ERP_System_Order_ID__c
            //
            system.debug('***objExternalCallbackInfo.sfdc_OrderIDKey= ' + objExternalCallbackInfo.sfdc_OrderIDKey + ' ERPOrderIdList.size()=' + ERPOrderIdList.size());
            
            //If( (! string.IsBlank(objExternalCallbackInfo.sfdc_OrderIDKey)) && ERPOrderIdList.size() == 1) {
            If(ERPOrderIdList.size() == 1) {
                for( ERP_Order__c updateorder: ERPOrderIdList) {
                
                    system.debug('***Test1 statement');
                    //system.debug('***Test1 - ListElementAccess: Type= ' + objExternalCallbackInfo.listOfSAPReturnResults.[0].Type + ' Entire Array= ' +objExternalCallbackInfo.listOfSAPReturnResults);
                    //system.debug('***objExternalCallbackInfo.statusCode= '+ objExternalCallbackInfo.statusCode + ' objSAP_RETURN_TYPE.Type= ' + objSAP_RETURN_TYPE.Type );
                    //if (objExternalCallbackInfo.statusCode == 'E' || objSAP_RETURN_TYPE.Type == 'E') {
                    if (objExternalCallbackInfo.statusCode == NULL || objExternalCallbackInfo.statusCode == '' || (objExternalCallbackInfo.statusCode == 'E' && objSAP_RETURN_TYPE.Type == 'E')) {
                    //if ( objExternalCallbackInfo.statusCode == 'E' && objExternalCallbackInfo.listOfSAPReturnResults.size() <> 0) {
                        updateorder.Order_Submission_Status__c = 'Order Submission Failed';
                        
                        update updateorder;
                    }
            
                    system.debug('***Test2 statement');
                    // *** AOP 2.0 Commented below condition since SAP Return Type might come as W even though order is SUCCESS                    
                    //if (objExternalCallbackInfo.statusCode == 'S' && objSAP_RETURN_TYPE.Type == 'S') {
                    //if (objExternalCallbackInfo.statusCode == 'S' && objExternalCallbackInfo.listOfSAPReturnResults.size() <> 0) {
                    if (objExternalCallbackInfo.statusCode == 'S') {
                        updateorder.Order_Submission_Status__c = 'Finalized / Complete in ERP';
                        updateorder.ERP_System_Order_ID__c = objExternalCallbackInfo.erp_OrderIDKey;
                        
                        update updateorder;
                    }
                    //update updateorder;
                } //END for              
                
            } //END if
            
            system.debug('***Before returncallbackInfo assignment statement');
            
            If (returnWarningMessageCode == Null) {
                returncallbackInfo.statusCode = '200';
                returncallbackInfo.statusDescription = 'Callback Message successfully processed';
            }
            Else {
                returncallbackInfo.statusCode = returnWarningMessageCode;
                returncallbackInfo.statusDescription = returnWarningMessageDescription;
            }
                        
            returncallbackInfo.monitorLogID = '';
            returncallbackInfo.UUID = objExternalCallbackInfo.UUID;
            String generatedID = string.valueof(erpOrderID);
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm()+'/'+generatedID;
            returncallbackInfo.sfdc_orderURL = sfdcBaseURL;
            
            //Explicit Exception Thrown - Remove after unit tests
            //wkException.setMessage(WK_Exception.ORD_EXCEPTION_CALLBACK_MISSING_ERP_ORDERIDKEY);
            //throw wkException;
            
            system.debug('***Before ApplicationLogFromCallbackRequest statement');
            system.debug('***objExternalCallbackInfo=' + objExternalCallbackInfo);
            system.debug('***objSAP_RETURN_TYPE=' + objSAP_RETURN_TYPE);
            system.debug('***objExternalCallbackInfo.listOfSAPReturnResults=' + objExternalCallbackInfo.listOfSAPReturnResults);
            system.debug('***objMESSAGE_ID_TYPE=' + objMESSAGE_ID_TYPE);
            system.debug('***objExternalCallbackInfo.listOfTransactionIDs =' + objExternalCallbackInfo.listOfTransactionIDs);            
            system.debug('***objSALES_DOCUMENTS_TYPE=' + objSALES_DOCUMENTS_TYPE);
            system.debug('***objExternalCallbackInfo.listOfSAPSalesDocuments =' + objExternalCallbackInfo.listOfSAPSalesDocuments);
            
            //change to V2 interface
            EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(
            objExternalCallbackInfo,
            returncallbackInfo,
            objMESSAGE_ID_TYPE,
            objSAP_RETURN_TYPE,
            objSALES_DOCUMENTS_TYPE);           
            
        }catch(Exception ex){
            FormListOfException('Error occured in Order CallBack Status and Logging process - '+ex.getMessage(),'501'); 
            returncallbackInfo.statusCode = '501';
            returncallbackInfo.statusDescription = 'Errors encountered in processing Callback Message';
        }finally{
            returncallbackInfo.listOfException = catchedException;
        }
        return returncallbackInfo;
    }
    
}