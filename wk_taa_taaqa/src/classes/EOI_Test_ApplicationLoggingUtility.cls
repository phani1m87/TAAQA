@isTest
private class EOI_Test_ApplicationLoggingUtility 
{
    @testsetup static void startup() 
    {
        EOI_Test_QuoteProposalTriggerHandler.myUnitTest();
    }
        
    static testMethod void testApplicationLogFromCalloutResponse_500() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_503() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_SERVER_IS_DOWN_FOR_MAINTENANCE_STATUSCODE;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_200() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_SUCCESS_STATUSCODE;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_0() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_PENDING_STATUSCODE;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_400() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_BAD_MISSING_XML_DATA_STATUSCODE;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_504() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_GATEWAY_TIMEOUT_REQUEST_EXPIRED;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_102() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_PROCESSING_RETRYING_REQUEST_STATUSCODE;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, 'DOWN');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_104() 
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = EOI_Test_OrderAutomation.createOrderSubmissionResponseType();
        result.orderSubmissionAcknowledgement.StatusCode = WK_Constants.EOI_Retry_LIMIT_EXCEED;
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, '');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_resultNULL() 
    {
        Test.startTest();
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType result = NULL;
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TestClass', 'TestMethod', 'TestRequest', result, objERPOrder.Name, objERPOrder.Id, 'DOWN');
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCallbackRequest_V2()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_SendOrderToERP_Callback_V2.callbackInfo objCallbackReq = new EOI_SendOrderToERP_Callback_V2.callbackInfo();
        objCallbackReq.statusCode = 'E';
        objCallbackReq.statusDescription = 'TEST';
        objCallbackReq.sfdc_OrderIDKey = objERPOrder.Name;
        objCallbackReq.erp_OrderIDKey = 'Test';
        objCallbackReq.providerSystemName = 'Test';
        objCallbackReq.responseDateTime = System.Now();
        objCallbackReq.esbHostName = 'Test';
        objCallbackReq.esbBrokerName = 'Test';
        objCallbackReq.UUID = 'Test';
        
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objSAP = new EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type();
        objSAP.Type = 'E';
        objSAP.ID = 'TestId';
        objSAP.SAP_NUMBER = '400';
        objSAP.MESSAGE = 'ERROR';
        
        EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type objSales = new EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type();
        objSales.SOURCE_ORDER_ID = '123456789012';
        objSales.SAP_DOC_ID = 'DOC01';
        objSales.SAP_DOC_TYPE = 'Test';
        
        EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type objMessage = new EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type();
        objMessage.SFDC_ID = '123456789012';
        objMessage.IIB_ID = '123456789012';
        objMessage.SAPPI_ID = '123456789012';
        
        EOI_SendOrderToERP_Callback_V2.callbackInfoReturn objCallBackResponse = new EOI_SendOrderToERP_Callback_V2.callbackInfoReturn();
        objCallBackResponse.statusCode = '0';
        objCallBackResponse.statusDescription = 'TestDescription';
        objCallBackResponse.monitorLogID = 'XX01';
        objCallBackResponse.UUID = 'XXX001';
        objCallBackResponse.sfdc_orderURL = 'https://abc.example.com/order/001';
        
        List<EOI_SendOrderToERP_Callback_V2.ErrorMessagesType> lstErrors = new List<EOI_SendOrderToERP_Callback_V2.ErrorMessagesType>(); 
        EOI_SendOrderToERP_Callback_V2.ErrorMessagesType objErrorType = new EOI_SendOrderToERP_Callback_V2.ErrorMessagesType();
        objErrorType.errorMessageCode = 'E001';
        objErrorType.errorMessageDescription = 'Error';
        lstErrors.add(objErrorType);
        
        objCallBackResponse.listOfException = lstErrors;
        
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test1';    
        objSAP.SAP_NUMBER = '401';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test2';
        objSAP.SAP_NUMBER = '406';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test3';
        objSAP.SAP_NUMBER = '410';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test4';
        objSAP.SAP_NUMBER = '413';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test5';
        objSAP.SAP_NUMBER = '422';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test6';
        objSAP.SAP_NUMBER = '429';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test7';
        objSAP.SAP_NUMBER = '500';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test8';
        objSAP.SAP_NUMBER = '501';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test9';
        objSAP.SAP_NUMBER = '503';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test10';
        objSAP.SAP_NUMBER = '504';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test13';
        objSAP.SAP_NUMBER = '028';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test14';
        objSAP.SAP_NUMBER = '028';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test15';
        objSAP.SAP_NUMBER = '219';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test16';
        objSAP.SAP_NUMBER = '248';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objSAP1 = new EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type();
        objSAP1.Type = 'E';
        objSAP1.ID = 'TestId';
        objSAP1.SAP_NUMBER = '336';
        objSAP1.MESSAGE = 'ERROR';
        
        objCallbackReq.UUID = 'Test17';
        objCallbackReq.listOfSAPReturnResults = new List<EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type>{objSAP, objSAP1};
        objSAP.SAP_NUMBER = '336';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test11';
        objSAP.TYPE = 'S';
        objCallbackReq.StatusCode = 'S';
        objSAP.SAP_NUMBER = '200';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test12';
        objSAP.SAP_NUMBER = '311';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        try{
            objCallbackReq.sfdc_OrderIDKey = 'DUMMY ORDER NAME';
            EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
            objSAP.SAP_NUMBER = '###';
            EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        }catch(WK_Exception e){
            System.assert(e.getMessage().contains('NO Matching order found for DUMMY ORDER NAME'));
        }
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCallbackRequest()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Id, Name FROM ERP_ORDER__c LIMIT 1];
        EOI_SendOrderToERP_Callback_V2.callbackInfo objCallbackReq = new EOI_SendOrderToERP_Callback_V2.callbackInfo();
        objCallbackReq.statusCode = 'E';
        objCallbackReq.statusDescription = '';
        objCallbackReq.sfdc_OrderIDKey = objERPOrder.Name;
        objCallbackReq.erp_OrderIDKey = 'Test';
        objCallbackReq.providerSystemName = 'Test';
        objCallbackReq.responseDateTime = System.Now();
        objCallbackReq.esbHostName = 'Test';
        objCallbackReq.esbBrokerName = 'Test';
        objCallbackReq.UUID = 'Test';
        
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objSAP = new EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type();
        objSAP.Type = 'E';
        objSAP.ID = 'TestId';
        objSAP.SAP_NUMBER = '400';
        objSAP.MESSAGE = 'ERROR';
        
        EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type objSales = new EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type();
        objSales.SOURCE_ORDER_ID = '123456789012';
        objSales.SAP_DOC_ID = 'DOC01';
        objSales.SAP_DOC_TYPE = 'Test';
        
        EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type objMessage = new EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type();
        objMessage.SFDC_ID = '123456789012';
        objMessage.IIB_ID = '123456789012';
        objMessage.SAPPI_ID = '123456789012';
        
        EOI_SendOrderToERP_Callback_V2.callbackInfoReturn objCallBackResponse = new EOI_SendOrderToERP_Callback_V2.callbackInfoReturn();
        objCallBackResponse.statusCode = '0';
        objCallBackResponse.statusDescription = 'TestDescription';
        objCallBackResponse.monitorLogID = 'XX01';
        objCallBackResponse.UUID = 'XXX001';
        objCallBackResponse.sfdc_orderURL = 'https://abc.example.com/order/001';
        
        List<EOI_SendOrderToERP_Callback_V2.ErrorMessagesType> lstErrors = new List<EOI_SendOrderToERP_Callback_V2.ErrorMessagesType>(); 
        EOI_SendOrderToERP_Callback_V2.ErrorMessagesType objErrorType = new EOI_SendOrderToERP_Callback_V2.ErrorMessagesType();
        objErrorType.errorMessageCode = 'E001';
        objErrorType.errorMessageDescription = 'Error';
        lstErrors.add(objErrorType);
        
        objCallBackResponse.listOfException = lstErrors;
        
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
            
        objCallbackReq.UUID = 'Test1';
        objSAP.SAP_NUMBER = '401';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test2';
        objSAP.SAP_NUMBER = '406';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test3';
        objSAP.SAP_NUMBER = '410';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test4';
        objSAP.SAP_NUMBER = '413';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test5';
        objSAP.SAP_NUMBER = '422';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test6';
        objSAP.SAP_NUMBER = '429';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test7';
        objSAP.SAP_NUMBER = '500';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test8';
        objSAP.SAP_NUMBER = '501';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test9';
        objSAP.SAP_NUMBER = '503';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test10';
        objSAP.SAP_NUMBER = '504';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        
        objCallbackReq.UUID = 'Test11';
        objSAP.TYPE = 'S';
        objCallbackReq.StatusCode = 'S';
        objSAP.SAP_NUMBER = '200';
        EOI_ApplicationLoggingUtility.ApplicationLogFromCallbackRequest_V2(objCallbackReq,objCallBackResponse,objMessage,objSAP,objSales);
        Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_CreateCase()
    {
    	Account objAccount = [SELECT Id FROM Account LIMIT 1];
    	String className = 'EOI_Test_ApplicationLoggingUtility';
    	String methodName = 'testApplicationLogFromCalloutResponse_CreateCase';
    	String accountId = objAccount.Id;
		
		Test.startTest();
		//NULL TEST CASE    	
    	IIB_TAAServiceSiteCreateCase_V4.CreateCaseRequestWrapper requestData = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseRequestWrapper();
    	requestData.uuidMetaDataRequest = new IIB_TAAServiceSiteCreateCase_V4.UUIDMetaDataRequestType();
    	requestData.uuidMetaDataRequest.uuid = WK_Utility.UUID_Generator();
    	IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element response;
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, requestData, response, accountId);
    	
    	//POSITIVE TEST CASE
    	response = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element();
    	response.createCase = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseRespType();
    	response.createCase.caseNumber = '1234567';
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, requestData, response, accountId);
    	
    	//NEGATIVE TEST CASE FOR SFDC FAILURE
    	response.createCase = null;
    	response.errorMessages = new IIB_TAAServiceSiteCreateCase_V4.ErrorMessagesType();
    	response.errorMessages.ErrorMessage = new IIB_TAAServiceSiteCreateCase_V4.ErrorMessageType();
    	response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK;
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, requestData, response, accountId);
    	
    	//NEGATIVE TEST CASE FOR IIB FAILURE
    	response.errorMessages.ErrorMessage.customErrorMessageCode = null;
    	response.errorMessages.ErrorMessage.errorMessageCode = WK_Constants.SVC_INTERNAL_SERVER_ERRORCODE;
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, requestData, response, accountId);
    	Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_HttpRequestNResponse()
    {
    	Account objAccount = [SELECT Id FROM Account LIMIT 1];
    	String className = 'TAA_ServiceOverviewController';
    	String methodName = 'addNewCaseComment';
    	String accountId = objAccount.Id;
		
		Test.startTest();
    	HttpRequest req = new HttpRequest();
    	HttpResponse res = new HttpResponse();
    	res.setStatusCode(200);
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, req, res, accountId);
    	
    	methodName = 'addNewCaseAttachment';
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, req, res, accountId);
    	
    	methodName = 'escalateCase';
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, req, res, accountId);
    	
    	methodName = 'updateCase';
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, req, res, accountId);
    	
    	res.setStatusCode(500);
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, req, res, accountId);
    	Test.stopTest();
    }
    
    static testMethod void testApplicationLogFromCalloutResponse_Exception()
    {
    	Account objAccount = [SELECT Id FROM Account LIMIT 1];
    	String className = 'TAA_ServiceOverviewController';
    	String methodName = 'addNewCaseComment';
		
		Test.startTest();
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, '', '', objAccount.Id, null);
		
		ERP_Order__c objOrder = [SELECT Id FROM ERP_Order__c LIMIT 1];    	
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, '', '', objOrder.Id, null);
    	
    	Apttus_Proposal__Proposal__c objQuote = [SELECT Id FROM Apttus_Proposal__Proposal__c LIMIT 1];
    	EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse(className, methodName, '', '', objQuote.Id, null);
    	Test.stopTest();
    }
}