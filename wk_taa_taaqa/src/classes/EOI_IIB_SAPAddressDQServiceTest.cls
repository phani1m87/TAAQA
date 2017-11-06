/*
 * Test class for below components
 * 1. EOI_IIB_SAPAddressDQService.cls
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 10/04/2017 SHIVAJI           1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest (seeAllData = false)
public class EOI_IIB_SAPAddressDQServiceTest
{
    private class SAP_DQServiceMock implements WebServiceMock
    {
    	public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof EOI_IIB_AddressValidationRequest.DataSet_element){
            	response.put('response_x', new EOI_IIB_AddressValidationResponse.DataSet_element());
            }	
            	
            if(request instanceof EOI_IIB_AddressSuggestionRequest.DataSet_element){
            	response.put('response_x', new EOI_IIB_AddressSuggestionResponse.DataSet_element());
            }	
            return;
        }
    }
    
    private class AsyncSAP_DQServiceMock implements WebServiceMock
    {
    	public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof EOI_IIB_AddressValidationRequest.DataSet_element){
            	response.put('response_x', new AsyncEOI_IIB_AddressValidationResponse.DataSet_elementFuture());
            	//response.put('response_x', new EOI_IIB_AddressValidationResponse.DataSet_element());
            }	
            	
            if(request instanceof EOI_IIB_AddressSuggestionRequest.DataSet_element){
            	response.put('response_x', new AsyncEOI_IIB_AddressSuggestionResponse.DataSet_elementFuture());
            	//response.put('response_x', new EOI_IIB_AddressSuggestionResponse.DataSet_element());
            }	
            return;
        }
    }
    
    public static testMethod void testSyncVersions() 
    {
    	Test.setMock(WebServiceMock.class, new SAP_DQServiceMock());
    	EOI_IIB_SAPAddressDQService.Real_time_Services objStubController = new EOI_IIB_SAPAddressDQService.Real_time_Services();
    	Test.startTest();
    	objStubController.Service_Realtime_DQ_SAP_Address_Cleanse(new EOI_IIB_AddressValidationRequest.Record_element[]{}, new EOI_IIB_AddressValidationRequest.UUIDMetaDataRequestDataType());
    	objStubController.Service_Realtime_DQ_SAP_Address_Cleanse_Suggestions(new EOI_IIB_AddressSuggestionRequest.Record_element[]{}, new EOI_IIB_AddressSuggestionRequest.UUIDMetaDataRequestDataType());
    	Test.stopTest();
    }
    
    public static testMethod void testAsyncVersions() 
    {
    	Test.setMock(WebServiceMock.class, new AsyncSAP_DQServiceMock());
    	AsyncEOI_IIB_SAPAddressDQService.AsyncReal_time_Services objStubController = new AsyncEOI_IIB_SAPAddressDQService.AsyncReal_time_Services();
    	Test.startTest();
    	try{
	    	AsyncEOI_IIB_AddressSuggestionResponse.DataSet_elementFuture objSuggestionDataFuture = objStubController.beginService_Realtime_DQ_SAP_Address_Cleanse_Suggestions(new Continuation(20), new EOI_IIB_AddressSuggestionRequest.Record_element[]{}, new EOI_IIB_AddressSuggestionRequest.UUIDMetaDataRequestDataType());
	    	objSuggestionDataFuture.getValue();
	    	
    	}catch(Exception ex){}
    	
    	try{
    		AsyncEOI_IIB_AddressValidationResponse.DataSet_elementFuture objValidationDataFuture = objStubController.beginService_Realtime_DQ_SAP_Address_Cleanse(new Continuation(20), new EOI_IIB_AddressValidationRequest.Record_element[]{}, new EOI_IIB_AddressValidationRequest.UUIDMetaDataRequestDataType()); 
	    	objValidationDataFuture.getValue();
    	}catch(Exception ex){}
    	Test.stopTest();
    }
    
    public static testMethod void testEOI_IIB_AddressValidationRequest() 
    {
    	EOI_IIB_AddressValidationRequest.DataSet_element objData = new EOI_IIB_AddressValidationRequest.DataSet_element();
   		EOI_IIB_AddressValidationRequest.Record_element objRecord = new EOI_IIB_AddressValidationRequest.Record_element();  
   		EOI_IIB_AddressValidationRequest.OperationalInfoType objOperationalType = new EOI_IIB_AddressValidationRequest.OperationalInfoType();
    }
    
    public static testMethod void testEOI_IIB_AddressValidationResponse() 
    {
   		EOI_IIB_AddressValidationResponse.DataSet_element  objData = new EOI_IIB_AddressValidationResponse.DataSet_element ();  
   		EOI_IIB_AddressValidationResponse.Record_element objRecord = new EOI_IIB_AddressValidationResponse.Record_element();
   		EOI_IIB_AddressValidationResponse.UUIDMetaDataRequestDataType objUUIDReq = new EOI_IIB_AddressValidationResponse.UUIDMetaDataRequestDataType(); 
   		EOI_IIB_AddressValidationResponse.ErrorMessagesType objErrorMessages = new EOI_IIB_AddressValidationResponse.ErrorMessagesType();
   		EOI_IIB_AddressValidationResponse.ErrorMessageType objErrorMessage = new EOI_IIB_AddressValidationResponse.ErrorMessageType(); 
   		EOI_IIB_AddressValidationResponse.UUIDMetaDataResponseType objUUIRes = new EOI_IIB_AddressValidationResponse.UUIDMetaDataResponseType();
   		EOI_IIB_AddressValidationResponse.OperationalInfoType objOperationType = new EOI_IIB_AddressValidationResponse.OperationalInfoType();
    }

    public static testMethod void testEOI_IIB_AddressSuggestionRequest() 
    {
    	EOI_IIB_AddressSuggestionRequest.DataSet_element objData = new EOI_IIB_AddressSuggestionRequest.DataSet_element();
   		EOI_IIB_AddressSuggestionRequest.Record_element objRecord = new EOI_IIB_AddressSuggestionRequest.Record_element();
   		EOI_IIB_AddressSuggestionRequest.OperationalInfoType objOperationalType = new EOI_IIB_AddressSuggestionRequest.OperationalInfoType();   
    }
    
    public static testMethod void testEOI_IIB_AddressSuggestionResponse() 
    {
    	EOI_IIB_AddressSuggestionResponse.ENTRY_element objEntry = new EOI_IIB_AddressSuggestionResponse.ENTRY_element();
   		EOI_IIB_AddressSuggestionResponse.DataSet_element  objData = new EOI_IIB_AddressSuggestionResponse.DataSet_element ();  
   		EOI_IIB_AddressSuggestionResponse.Record_element objRecord = new EOI_IIB_AddressSuggestionResponse.Record_element();
   		EOI_IIB_AddressSuggestionResponse.SUGGESTION_element objSuggestion = new EOI_IIB_AddressSuggestionResponse.SUGGESTION_element();
   		EOI_IIB_AddressSuggestionResponse.UUIDMetaDataRequestDataType objUUIDReq = new EOI_IIB_AddressSuggestionResponse.UUIDMetaDataRequestDataType(); 
   		EOI_IIB_AddressSuggestionResponse.ErrorMessagesType objErrorMessages = new EOI_IIB_AddressSuggestionResponse.ErrorMessagesType();
   		EOI_IIB_AddressSuggestionResponse.ErrorMessageType objErrorMessage = new EOI_IIB_AddressSuggestionResponse.ErrorMessageType(); 
   		EOI_IIB_AddressSuggestionResponse.UUIDMetaDataResponseType objUUIRes = new EOI_IIB_AddressSuggestionResponse.UUIDMetaDataResponseType();
   		EOI_IIB_AddressSuggestionResponse.OperationalInfoType objOperationType = new EOI_IIB_AddressSuggestionResponse.OperationalInfoType(); 
    }
}