@isTest
global class EOI_OrderAutomationMock implements WebServiceMock {
   global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) 
   {
       	EOI_IIB_ERPOrderCallout_V6.UUIDMetaDataRequestType UUIDRequest = new EOI_IIB_ERPOrderCallout_V6.UUIDMetaDataRequestType();
        EOI_IIB_ERPOrderCallout_V6.UUIDMetaDataResponseType UUIDResponse = new EOI_IIB_ERPOrderCallout_V6.UUIDMetaDataResponseType();
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionAcknowledgementType orderSubmissionAccResponse = new EOI_IIB_ERPOrderCallout_V6.OrderSubmissionAcknowledgementType();
        orderSubmissionAccResponse.StatusCode = '1';
        EOI_IIB_ERPOrderCallout_V6.ErrorMessagesType errMessage = new EOI_IIB_ERPOrderCallout_V6.ErrorMessagesType();
        EOI_IIB_ERPOrderCallout_V6.ErrorMessageType[] ErrorMesageList = new List<EOI_IIB_ERPOrderCallout_V6.ErrorMessageType>();
        EOI_IIB_ERPOrderCallout_V6.ErrorMessageType newErrorMessage = new EOI_IIB_ERPOrderCallout_V6.ErrorMessageType();
        ErrorMesageList.add(newErrorMessage);
        errMessage.ErrorMesage = ErrorMesageList;
        
        EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType orderSubmissionResponse = new EOI_IIB_ERPOrderCallout_V6.OrderSubmissionResponseType();
        orderSubmissionResponse.uuidMetaDataRequest = UUIDRequest;
    	orderSubmissionResponse.uuidMetaDataResponse = UUIDResponse;
    	orderSubmissionResponse.orderSubmissionAcknowledgement = orderSubmissionAccResponse;
    	orderSubmissionResponse.errorMessages = errMessage;
    	
    	response.put('response_x', orderSubmissionResponse);
   }
}