/*
 * Controller for EOI_BusinessPartner Page 
 *  - Callouts to SAP/PO to get business partners & to do address validation
 *	- Above mentioned page will be added to Quote/Proposal Page Layout for ONLY SAP type of quotes
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 08/28/2017 SHIVAJI           1.0          SMS-900
 * ------------------------------------------------------------------------- */
public with sharing class EOI_GetBusinessPartnersController 
{
	//Class variables
	public Apttus_Proposal__Proposal__c currentQuote {get; set;}
	
	//Switch varibles to control the rendering of the VF sections
	public Boolean showBPDropDowns {get; set;}
	public Boolean showNewBPForms {get; set;}
	public Boolean showBillToDetails {get; set;}
	public Boolean showBillToUpdateFlag {get; set;}
	public Boolean showShipToUpdateFlag {get; set;}
	public Boolean showShipToDetails {get; set;}
	public Boolean showNewBillToForm {get; set;}
	public Boolean showNewShipToForm {get; set;}
	
	//New Business Partners
	public Boolean isCreateNewBillToChecked {get; set;}
	public Boolean isCreateNewShipToChecked {get; set;}
	
	//Bill To
	public String newBillToContactName {get; set;}
	public String newBillToStreet1 {get; set;}
	public String newBillToStreet2 {get; set;}
	public String newBillToCity {get; set;}
	public String newBillToState {get; set;}
	public String newBillToPostalCode {get; set;}
	public String newBillToCountry {get; set;}
	public String newBillToPhone {get; set;}
	//Ship To
	public String newShipToContactName {get; set;}
	public String newShipToStreet1 {get; set;}
	public String newShipToStreet2 {get; set;}
	public String newShipToCity {get; set;}
	public String newShipToState {get; set;}
	public String newShipToPostalCode {get; set;}
	public String newShipToCountry {get; set;}
	public String newShipToPhone {get; set;}
	//New Business Partners
	
	//Update Selected Business Partner
	public Boolean isUpdateSelectedBillToChecked {get; set;}
	public Boolean isUpdateSelectedShipToChecked {get; set;}
	
	public Boolean isError {get; set;}
	public Boolean isCopyFromBillTo {get; set;}
	
	public String billToValue {get; set;}
	public String shipToValue {get; set;}
	
	public String selectedBillToNumber {get; set;}
	public String selectedShipToNumber {get; set;}
	public String erpAccountName {get; set;}
	
	public AutoCompleteListWrapper selectedBillTo {get; set;}
	public AutoCompleteListWrapper selectedShipTo {get; set;}
	
	public Map<String, AutoCompleteListWrapper> mapShipTos {get; set;}
	public Map<String, AutoCompleteListWrapper> mapBillTos {get; set;}
	
	public String serializedShipToList {get; private set;}
	public String serializedBillToList { get; private set; }
	
	//Log callouts round trip time in the debug logs
	public Long startTime;
	private Long totalTime;
	private List<sobject> logList;
	
	//Get Account Info
	private EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataRequestType uuidMetaDataRequest;
	private EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoType accountInfo;
	private AsyncEOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_elementFuture getAccountInfoResponse;
	public EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element response;
	private EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoRequestWrapper objRequest;
	
	//DQ Address Validation
	private EOI_IIB_AddressValidationRequest.Record_element[] Records;
	private EOI_IIB_AddressValidationRequest.UUIDMetaDataRequestDataType addressUUIDMetaDataRequest;
	private AsyncEOI_IIB_AddressValidationResponse.DataSet_elementFuture asyncAddressValidationResponse;
	public EOI_IIB_AddressValidationResponse.DataSet_element addressValidationResponse {get; set;}
	
	public Boolean isAddressInvalid {get; set;}
	
	public EOI_Order_Integration__c objOrderIntegration {
		get{
			if(objOrderIntegration == NULL){
				objOrderIntegration = WK_Utility.ServiceIntegrations();
			}
			return objOrderIntegration;
		} set;
	}
	
	//Test Harnes Page Constructor
	public EOI_GetBusinessPartnersController()
	{
		currentQuote = new Apttus_Proposal__Proposal__c();
		mapShipTos = new Map<String, AutoCompleteListWrapper>();
		mapBillTos = new Map<String, AutoCompleteListWrapper>();
		isUpdateSelectedShipToChecked = false;
		isUpdateSelectedBillToChecked = false;
		isCreateNewBillToChecked = false;
		isCreateNewShipToChecked = true;
	}
	
	//Live Page Constructor
	public EOI_GetBusinessPartnersController(ApexPages.StandardController stdController)
	{
		try{
			this.currentQuote = (Apttus_Proposal__Proposal__c) stdController.getRecord();
			currentQuote = [SELECT Id, ERP_Account__c, ERP_Account__r.Name, ERP_Account__r.Application__c, Is_Create_New_Bill_To__c, Is_Create_New_Ship_To__c, Is_Update_Selected_Bill_To__c, Is_Update_Selected_Ship_To__c, Bill_To_Account_Name__c, Ship_To_Account_Name__c, 
									New_Ship_To_Contact__c, New_Ship_To_Street_1__c, New_Ship_To_Street_2__c, New_Ship_To_City__c, New_Ship_To_State__c, New_Ship_To_Country__c, New_Ship_To_Zip_Postal_Code__c, New_Ship_To_Phone__c,
									New_Bill_To_Contact__c, New_Bill_To_Street_1__c, New_Bill_To_Street_2__c, New_Bill_To_City__c, New_Bill_To_State__c, New_Bill_To_Country__c, New_Bill_To_Zip_Postal_Code__c, New_Bill_To_Phone__c,
									SAP_Ship_To_Partner_Number__c, Ship_To_Contact_Name__c,Ship_To_Street_Line_1__c,Ship_To_Street_Line_2__c,Ship_To_City__c,Ship_To_State__c,Ship_To_Zip_Postal_Code__c,Ship_To_Country__c,
									SAP_Bill_To_Partner_Number__c, Bill_To_Contact_Name__c,Bill_To_Street_Line_1__c,Bill_To_Street_Line_2__c,Bill_To_City__c,Bill_To_State__c,Bill_To_Zip_Postal_Code__c,Bill_To_Country__c
							FROM Apttus_Proposal__Proposal__c 
							WHERE Id =: currentQuote.Id];
							
			//Check if ERP Account is selected from Account X Ref
			if(currentQuote != NULL && String.isBlank(currentQuote.ERP_Account__c)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'ERP Account is not selected on the quote, you can select the existing account on the quote or create a new customer.'));
			}
			
			isCopyFromBillTo = false;
			isError = false;
			showBPDropDowns = false;
			showNewBPForms = false;
			showBillToDetails = false;
			showShipToDetails = false;
			showNewBillToForm = false;
			showNewShipToForm = false;
			showBillToUpdateFlag = false;
			showShipToUpdateFlag = false;
			isAddressInvalid = false;
			
			isUpdateSelectedBillToChecked = currentQuote.Is_Update_Selected_Bill_To__c;
			isUpdateSelectedShipToChecked = currentQuote.Is_Update_Selected_Ship_To__c;
			isCreateNewBillToChecked = currentQuote.Is_Create_New_Bill_To__c;
			isCreateNewShipToChecked = currentQuote.Is_Create_New_Ship_To__c;
			
			if(isUpdateSelectedBillToChecked || isCreateNewBillToChecked){
				showNewBillToForm = true;
				showBillToUpdateFlag = true;
			}
			
			if(isUpdateSelectedShipToChecked || isCreateNewShipToChecked){
				showNewShipToForm = true;
				showShipToUpdateFlag = true;
			}
			
			mapShipTos = new Map<String, AutoCompleteListWrapper>();
			mapBillTos = new Map<String, AutoCompleteListWrapper>();
			
			//Populate BillTo & Ship Address which user had decided to override or create new in previous session
			newBillToContactName = currentQuote.New_Bill_To_Contact__c;
			newBillToStreet1 = currentQuote.New_Bill_To_Street_1__c;
			newBillToStreet2 = currentQuote.New_Bill_To_Street_2__c;
			newBillToCity = currentQuote.New_Bill_To_City__c;
			newBillToState = currentQuote.New_Bill_To_State__c;
			newBillToPostalCode = currentQuote.New_Bill_To_Zip_Postal_Code__c;
			newBillToCountry = currentQuote.New_Bill_To_Country__c;
			
			newShipToContactName = currentQuote.New_Ship_To_Contact__c;
			newShipToStreet1 = currentQuote.New_Ship_To_Street_1__c;
			newShipToStreet2 = currentQuote.New_Ship_To_Street_2__c;
			newShipToCity = currentQuote.New_Ship_To_City__c;
			newShipToState = currentQuote.New_Ship_To_State__c;
			newShipToPostalCode = currentQuote.New_Ship_To_Zip_Postal_Code__c;
			newShipToCountry = currentQuote.New_Ship_To_Country__c;
			
			//Populate BillTo & Ship Address from Account X Ref
			if(!String.isBlank(currentQuote.Bill_To_Account_Name__c)){
				showBillToDetails = true;
				erpAccountName = currentQuote.Bill_To_Account_Name__c;
				selectedBillTo = new AutoCompleteListWrapper(
								currentQuote.Bill_To_Contact_Name__c,
								currentQuote.SAP_Bill_To_Partner_Number__c,
								getAddress(currentQuote.Bill_To_Street_Line_1__c, currentQuote.Bill_To_Street_Line_2__c, currentQuote.Bill_To_City__c, currentQuote.Bill_To_State__c, currentQuote.Bill_To_Zip_Postal_Code__c, currentQuote.Bill_To_Country__c), null);	
			}
			if(!String.isBlank(currentQuote.Ship_To_Account_Name__c)){
				showShipToDetails = true;
				selectedShipTo = new AutoCompleteListWrapper(
								currentQuote.Ship_To_Contact_Name__c,
								currentQuote.SAP_Ship_To_Partner_Number__c,
								getAddress(currentQuote.Ship_To_Street_Line_1__c, currentQuote.Ship_To_Street_Line_2__c, currentQuote.Ship_To_City__c, currentQuote.Ship_To_State__c,currentQuote.Ship_To_Zip_Postal_Code__c, currentQuote.Ship_To_Country__c), null);
			}
		}catch(Exception ex){
			isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
		}
	}
	
	//Prepare request XML for GetAccountInfo IIB interface
	public Boolean prepareGetAccountInfoRequest()
    {
    	Boolean isError = false;
    	try{
    		//Check if service was already called and has data fetched
    		if(response != NULL && response.customerContacts != NULL){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Please start typing into the input boxes to see the lists.'));
    			return true;
    		}
    		
    		String accountNumber = '';
    		String providingSystemName = '';
    		
    		//No ERP Account is selected so error out
    		if(String.isBlank(currentQuote.ERP_Account__c)){
    			isError = true;
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select the ERP Account onto the quote record to fetch the business partners.'));
    			return isError;
    		//ERP Account is selected but Name or Application on X Ref is NULL / BLANK
    		}else if(String.isBlank(currentQuote.ERP_Account__r.Name) || String.isBlank(currentQuote.ERP_Account__r.Application__c)){
    			Account_X_Reference__c obj = [SELECT Name, Application__c FROM Account_X_Reference__c WHERE Id =: currentQuote.ERP_Account__c LIMIT 1]; 
    			accountNumber = obj.Name;
    			providingSystemName = obj.Application__c;
    		//ERP Account is selected and has required information from X Ref
    		}else{
    			accountNumber = currentQuote.ERP_Account__r.Name;
    			providingSystemName = currentQuote.ERP_Account__r.Application__c;
    		}
    		
    		if(String.isBlank(accountNumber) || String.isBlank(providingSystemName)){
    			isError = true;
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Selected ERP Account X Ref Name OR Application is NULL, please contact System Administrator.'));
    			return isError;
    		}
			
			//If error then don't prepare request XML but ask user to correct the error
			//Otherwise create request XML
    		if(!isError)
    		{	
		    	//No validation error so prepare request XML
		    	objRequest = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoRequestWrapper(); 
		    	
		    	//Prepare IIB UUID Meta Data
		    	uuidMetaDataRequest = new EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataRequestType();
		    	uuidMetaDataRequest.uuid = WK_Utility.UUID_Generator();
		        uuidMetaDataRequest.sourceSystemName = objOrderIntegration.SourceSystemName__c;
		        uuidMetaDataRequest.requestDateTime = Date.Today();
		        uuidMetaDataRequest.providingSystemName = providingSystemName;
		        uuidMetaDataRequest.uniqueCallingUserId = UserInfo.getName() + '_' + UserInfo.getUserId();
		        uuidMetaDataRequest.transactionMonitoringFlag = objOrderIntegration.TransactionMonitoringFlag__c == '1' ? 'Y' : 'N';
		        uuidMetaDataRequest.loggingFlag = objOrderIntegration.LoggingFlag__c == '1' ? 'Y' : 'N';
		        uuidMetaDataRequest.serviceVersion = objOrderIntegration.GetAccountInfoServiceVersion__c;
				
				//Prepare accountInfo
				accountInfo = new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoType();
				accountInfo.accountNumber = accountNumber;
				//accountInfo.accountNumber = currentQuote.ERP_Account__r.Name + 'x';
				
				objRequest.uuidMetaDataRequest = uuidMetaDataRequest;
				objRequest.accountInfo = accountInfo;
    		}
			return isError;
    	}catch(Exception ex){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
    		return true;
    	}
    }
	
	//Continuation Action for GetAccountInfo Callout 
	public Continuation startGetAccountInfoRequest()
    {    
       //Invoke prepareGetAccountInfoRequest to validate and prepare request XML
       Boolean isError = prepareGetAccountInfoRequest();
       try{
	       //If validation error then don't callout
	       if(!isError){
	       	   //Set continuation call timeout
	       	   //Integer TIMEOUT_INT_SECS = 20;
		       Integer TIMEOUT_INT_SECS = Integer.valueOf(objOrderIntegration.Continuation_Call_Timeout__c);  
		       Continuation objCont = new Continuation(TIMEOUT_INT_SECS);
		       
		       //Set continuation callback method, this will be called when the response is received from downstream service
		       objCont.continuationMethod = 'processGetAccountInfoResponse';
		
		       AsyncEOI_IIB_ERP_GetAccountInfo_V2.AsyncGetAccountInfoSOAP getAccountInfoRequest = new AsyncEOI_IIB_ERP_GetAccountInfo_V2.AsyncGetAccountInfoSOAP();
		       
		       //Log web service call-out time
		       startTime = System.now().getTime();
		       
		       //Begin Async GetAccountInfo callout
		       getAccountInfoResponse = getAccountInfoRequest.beginGetAccountInfo(objCont, uuidMetaDataRequest, accountInfo);
		       return objCont;
	       }else{
	       		//Validation error to show error message to user on the page
	       		return null;
	       }
       	}catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
			return null;				
       	}
    }
    
    //Call back method for GetAccountInfo continuation callout
    public Object processGetAccountInfoResponse()
    {
		logList = new List<sObject>();
		try{
	    	//If the callout was from test class then setup the mock response
	    	if(!Test.isRunningTest()){
	    		response = getAccountInfoResponse.getValue();
	    	}
	    	
	    	//Log total round trip time in debug logs
	    	totalTime = System.now().getTime() - startTime;
	        System.debug('Round Trip Time Required (to IIB) : ' + totalTime);
	        if(response != NULL)
	        {
	        	//Response is received
	        	//#TECHNICAL DEBT: since IIB GetAccountInfo service doesn't pass any STATUS CODE in the response so have to check if we got something in response 
	        	if(response != NULL && response.accountInfoResponse != NULL && response.customerContacts != NULL && response.customerContacts.CustomerContact != NULL && response.customerContacts.CustomerContact.size() > 0)
	        	{
	        		//SUCCESS
	        		erpAccountName = response.accountInfoResponse.accountName;
	        		
	        		//Filter the business partners into two lists (1) Bill To & (2) Ship To
	        		for(EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objBusinessPartner : response.customerContacts.CustomerContact)
	        		{
	        			String address = getAddress(objBusinessPartner);
	        			if(objBusinessPartner.customerContactTypeDescription == 'Bill-to party'){
	        				mapBillTos.put(objBusinessPartner.customerContactPersonUniqueId, new AutoCompleteListWrapper(objBusinessPartner.customerContactPersonFirstName, objBusinessPartner.customerContactPersonUniqueId, address, objBusinessPartner));
	        			}else if(objBusinessPartner.customerContactTypeDescription == 'Ship-to party'){
	        				mapShipTos.put(objBusinessPartner.customerContactPersonUniqueId, new AutoCompleteListWrapper(objBusinessPartner.customerContactPersonFirstName, objBusinessPartner.customerContactPersonUniqueId, address, objBusinessPartner));
	        			}
	        		}
	        		
	        		//Serialize Bill To & Ship To list so that it can be passed to auto-complete framework on VF
	        		if((mapShipTos != NULL && mapShipTos.size() > 0) || (mapBillTos != NULL && mapBillTos.size() > 0)){
	        			showBPDropDowns = true;
	        			serializedShipToList = JSON.serialize(mapShipTos.values());
	        			serializedBillToList = JSON.serialize(mapBillTos.values());
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Please start typing into the input boxes to see the lists.'));
	        		}
	        	}else if(response.errorMessages != NULL){
	        		//FAILURE
	        		if(response.errorMessages.ErrorMessage != NULL){
	        			for(EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType objError : response.errorMessages.ErrorMessage){
    						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, objError.customErrorMessageDescription));    							
    					}
	        		}
	        	}
	        	
	        }else{
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
	        }
	        //Override Application Logging Method to Log the response
	        if(currentQuote.Id != NULL){
	       		logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('EOI_GetBusinessPartnersController', 'processGetAccountInfoResponse', objRequest, response, currentQuote.Id));
	        }
        }catch(Exception ex){
        	//insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceCreateCase', 'processResponse', objRequest.toString(), response, currentAccount.Id);
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
        	if(ex instanceof CalloutException){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Downstream system to is not available.'));
        	}else if(ex instanceof DMLException){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'DML Exception occurred while logging the monitoring record.'));
        	}else{
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unhandled technical exception ocurred.'));
        	}
        	if(currentQuote.Id != NULL){
        		logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('EOI_GetBusinessPartnersController', 'processGetAccountInfoResponse', objRequest.toString(), ex.getMessage(), currentQuote.Id, objRequest.uuidMetaDataRequest.uuid));
        	}
        }finally{
        	//Create log in any situation on the quote record
        	if(logList.size() > 0){
	        	insert logList;
	        }
        }
        return null; 
    }
    
    //Method identifies the Bill-To and / or Ship-To user has selected from Auto-complete list
    public void populateBusinessPartnerDetails()
    {
    	String changedBusinessPartner = ApexPages.currentPage().getParameters().get('changedBusinessPartnerType');
    	
    	//User has selected Bill-To
    	if(changedBusinessPartner == 'BillTo' && !String.isBlank(selectedBillToNumber))
    	{
    		for(String key : mapBillTos.keySet()){
    			if(selectedBillToNumber == key){
    				selectedBillTo = mapBillTos.get(key);
    			}		
    		}
    		if(selectedBillTo != NULL){
    			showBillToDetails = true;
    			showBillToUpdateFlag = true;
    		}
    		isUpdateSelectedBillToChecked = false;
    	}
		
		//User has selected Ship-To
    	if(changedBusinessPartner == 'ShipTo' && !String.isBlank(selectedShipToNumber))
    	{
			for(String key : mapShipTos.keySet()){
    			if(selectedShipToNumber == key){
    				selectedShipTo = mapShipTos.get(key);
    			}		
    		}
    		if(selectedShipTo != NULL){
    			showShipToDetails = true;
    			showShipToUpdateFlag = true;
    		}
    		isUpdateSelectedShipToChecked = false;
    	}
    	
    	//if there is a change in any selection then update the details shown on screen
    	if(!String.isBlank(changedBusinessPartner)){
    		updateSelectedBusinessPartner();
    	}
    }
    
    //Initialize the variables to show new business partner form
    public void enableNewBusinessPartnerForm()
    {
    	String changedBusinessPartner = ApexPages.currentPage().getParameters().get('changedBusinessPartnerType');
    	
    	//User decided to create new Bill-To
    	if(changedBusinessPartner == 'BillTo')
		{
	    	if(isCreateNewBillToChecked)
	    	{
	    		isUpdateSelectedBillToChecked = false;
	    		newBillToContactName = '';
				newBillToStreet1 = '';
				newBillToStreet2 = '';
				newBillToCity = '';
				newBillToState = '';
				newBillToPostalCode = '';
				newBillToCountry = '';
				newBillToPhone = '';
	    		showNewBillToForm = true;
	    	}else if(!isUpdateSelectedBillToChecked){
	    		showNewBillToForm = false;
	    		if(selectedBillTo != NULL && selectedBillTo.objCustContact == NULL){
	    			showBillToUpdateFlag = false;	
	    		}
	    	}
		}
		
		//User decided to create new Ship-To
		if(changedBusinessPartner == 'ShipTo')
		{
	    	if(isCreateNewShipToChecked)
	    	{
	    		isUpdateSelectedShipToChecked = false;
	    		newShipToContactName = '';
				newShipToStreet1 = '';
				newShipToStreet2 = '';
				newShipToCity = '';
				newShipToState = '';
				newShipToPostalCode = '';
				newShipToCountry = '';
				newShipToPhone = '';
	    		showNewShipToForm = true;
	    	}else if(!isUpdateSelectedShipToChecked){
	    		showNewShipToForm = false;
	    		if(selectedShipTo != NULL && selectedShipTo.objCustContact == NULL){
	    			showShipToUpdateFlag = false;	
	    		}
	    	}
		}
    }
    
    //Method populates the binding variables when user change any selection on screen
    public void updateSelectedBusinessPartner()
	{
		String changedBusinessPartner = ApexPages.currentPage().getParameters().get('changedBusinessPartnerType');
		
		//User changed Bill-To selection
		if(changedBusinessPartner == 'BillTo')
		{
			if(isUpdateSelectedBillToChecked)
			{
				isCreateNewBillToChecked = false;
				if(selectedBillTo.objCustContact != NULL){
					newBillToContactName = selectedBillTo.objCustContact.customerContactPersonFirstName;
					newBillToStreet1 = selectedBillTo.objCustContact.customerContactPersonAddress.addressLine1;
					newBillToStreet2 = getStreet2(selectedBillTo.objCustContact.customerContactPersonAddress.room, selectedBillTo.objCustContact.customerContactPersonAddress.floor, selectedBillTo.objCustContact.customerContactPersonAddress.buildingCode);
					newBillToCity = selectedBillTo.objCustContact.customerContactPersonAddress.city;
					newBillToState = selectedBillTo.objCustContact.customerContactPersonAddress.stateCode;
					newBillToPostalCode = selectedBillTo.objCustContact.customerContactPersonAddress.zipPostalCode;
					newBillToCountry = selectedBillTo.objCustContact.customerContactPersonAddress.countryCode;
					if(selectedBillTo.objCustContact.customerContactPersonContact != NULL && selectedBillTo.objCustContact.customerContactPersonContact.Contact != NULL){
						for(EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactDetails : selectedBillTo.objCustContact.customerContactPersonContact.Contact){
							if(objContactDetails.contactType == 'PHONE' && !String.isBlank(objContactDetails.contactDetails)){
								newBillToPhone = objContactDetails.contactDetails;
							}
						}
					}else{
						newBillToPhone = '';
					}
				}
				showNewBillToForm = true;
			}else if(!isCreateNewBillToChecked){
				showNewBillToForm = false;
				if(selectedBillTo.objCustContact == NULL){
	    			showBillToUpdateFlag = false;	
	    		}
			}
		}
		
		//User changed Ship-To selection
		if(changedBusinessPartner == 'ShipTo')
		{
			if(isUpdateSelectedShipToChecked)
			{
				isCreateNewShipToChecked = false;
				if(selectedShipTo.objCustContact != NULL){
					newShipToContactName = selectedShipTo.objCustContact.customerContactPersonFirstName;
					newShipToStreet1 = selectedShipTo.objCustContact.customerContactPersonAddress.addressLine1;
					newShipToStreet2 = getStreet2(selectedShipTo.objCustContact.customerContactPersonAddress.room, selectedShipTo.objCustContact.customerContactPersonAddress.floor, selectedShipTo.objCustContact.customerContactPersonAddress.buildingCode);
					newShipToCity = selectedShipTo.objCustContact.customerContactPersonAddress.city;
					newShipToState = selectedShipTo.objCustContact.customerContactPersonAddress.stateCode;
					newShipToPostalCode = selectedShipTo.objCustContact.customerContactPersonAddress.zipPostalCode;
					newShipToCountry = selectedShipTo.objCustContact.customerContactPersonAddress.countryCode;
					//newBillToPhone = selectedBillTo.objCustContact.customerContactPersonAddress.floor;
					if(selectedShipTo.objCustContact.customerContactPersonContact != NULL && selectedShipTo.objCustContact.customerContactPersonContact.Contact != NULL){
						for(EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactDetails : selectedShipTo.objCustContact.customerContactPersonContact.Contact){
							if(objContactDetails.contactType == 'PHONE' && !String.isBlank(objContactDetails.contactDetails)){
								newShipToPhone = objContactDetails.contactDetails;
							}
						}
					}else{
						newBillToPhone = '';
					}
				}
				showNewShipToForm = true;
			}else if(!isCreateNewShipToChecked){
				showNewShipToForm = false;
				if(selectedShipTo.objCustContact == NULL){
	    			showShipToUpdateFlag = false;	
	    		}
			}
		}
	}
	
	//Copy Address from Bill-To to Sip-To
	public void copyFromBillTo()
	{
		//If copy checkbox is TRUE then set ship to address to bill to 
		if(isCopyFromBillTo){
			newShipToContactName = newBillToContactName;
			newShipToStreet1 = newBillToStreet1;
			newShipToStreet2 = newBillToStreet2;
			newShipToCity = newBillToCity;
			newShipToState = newBillToState;
			newShipToPostalCode = newBillToPostalCode;
			newShipToCountry = newBillToCountry;
			newShipToPhone = newBillToPhone;
		}else{
		//If copy checkbox is FALSE then reset it to blank
			newShipToContactName = '';
			newShipToStreet1 = '';
			newShipToStreet2 = '';
			newShipToCity = '';
			newShipToState = '';
			newShipToPostalCode = '';
			newShipToCountry = '';
			newShipToPhone = '';
		}
	}
	
	//This method updates the Quote record with final Bill-To & Ship-To changes user made on the page 
	public void save()
	{
		try{
			System.debug('## selectedBillTo : ' + selectedBillTo);
			//User decided to override selected Bill-To Name & Address OR Create new Bill-To
			if(isUpdateSelectedBillToChecked || isCreateNewBillToChecked)
			{
				currentQuote.Is_Update_Selected_Bill_To__c = isUpdateSelectedBillToChecked;
				currentQuote.Is_Create_New_Bill_To__c = isCreateNewBillToChecked;
				
				currentQuote.New_Bill_To_Account_Name__c = erpAccountName;
				if(isUpdateSelectedBillToChecked){
					currentQuote.SAP_Bill_To_Partner_Number__c = selectedBillTo.value;
				} 
				currentQuote.New_Bill_To_Contact__c = newBillToContactName;
				currentQuote.New_Bill_To_Street_1__c = newBillToStreet1;
				currentQuote.New_Bill_To_Street_2__c = newBillToStreet2;
				currentQuote.New_Bill_To_City__c = newBillToCity;
				currentQuote.New_Bill_To_State__c = newBillToState;
				currentQuote.New_Bill_To_Zip_Postal_Code__c = newBillToPostalCode;
				currentQuote.New_Bill_To_Country__c = newBillToCountry;
				currentQuote.New_Bill_To_Phone__c = newBillToPhone;
			}else{
				//User decided to use existing name & address
				currentQuote.Is_Update_Selected_Bill_To__c = false;
				currentQuote.Is_Create_New_Bill_To__c = false;
				
				currentQuote.New_Bill_To_Account_Name__c = '';
				//currentQuote.SAP_Bill_To_Partner_Number__c = '';
				currentQuote.New_Bill_To_Contact__c = '';
				currentQuote.New_Bill_To_Street_1__c = '';
				currentQuote.New_Bill_To_Street_2__c = '';
				currentQuote.New_Bill_To_City__c = '';
				currentQuote.New_Bill_To_State__c = '';
				currentQuote.New_Bill_To_Zip_Postal_Code__c = '';
				currentQuote.New_Bill_To_Country__c = '';
				currentQuote.New_Bill_To_Phone__c = '';
				
				if(selectedBillTo.objCustContact != NULL){
					currentQuote.ERP_Bill_To_Account_Name__c = erpAccountName;
					currentQuote.ERP_Bill_To_Contact_Name__c = selectedBillTo.label;
					currentQuote.SAP_Bill_To_Partner_Number__c = selectedBillTo.value;
					currentQuote.ERP_Bill_To_Street_1__c = selectedBillTo.objCustContact.customerContactPersonAddress.addressLine1;
					currentQuote.ERP_Bill_To_Street_2__c = getStreet2(selectedBillTo.objCustContact.customerContactPersonAddress.room, selectedBillTo.objCustContact.customerContactPersonAddress.floor, selectedBillTo.objCustContact.customerContactPersonAddress.buildingCode);
					currentQuote.ERP_Bill_To_City__c = selectedBillTo.objCustContact.customerContactPersonAddress.city;
					currentQuote.ERP_Bill_To_State__c = selectedBillTo.objCustContact.customerContactPersonAddress.stateCode;
					currentQuote.ERP_Bill_To_Zip_Postal_Code__c = selectedBillTo.objCustContact.customerContactPersonAddress.zipPostalCode;
					currentQuote.ERP_Bill_To_Country__c = selectedBillTo.objCustContact.customerContactPersonAddress.countryCode;
					Boolean isPhoneNumberReceived = false;
					if(selectedBillTo.objCustContact.customerContactPersonContact != NULL && selectedBillTo.objCustContact.customerContactPersonContact.Contact != NULL)
					{
						for(EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactDetails : selectedBillTo.objCustContact.customerContactPersonContact.Contact){
							if(objContactDetails.contactType == 'PHONE' && !String.isBlank(objContactDetails.contactDetails)){
								currentQuote.ERP_Bill_To_Phone__c = objContactDetails.contactDetails;
								isPhoneNumberReceived = true;
							}
						}
					}
					if(!isPhoneNumberReceived){
						currentQuote.ERP_Bill_To_Phone__c = '';
					}
				}
			}
			System.debug('## selectedShipTo : ' + selectedShipTo);
			//User decided to override selected Ship-To Name & Address OR Create new Ship-To
			if(isUpdateSelectedShipToChecked || isCreateNewShipToChecked)
			{
				currentQuote.Is_Update_Selected_Ship_To__c = isUpdateSelectedShipToChecked;
				currentQuote.Is_Create_New_Ship_To__c = isCreateNewShipToChecked;
				
				currentQuote.New_Ship_To_Account_Name__c = erpAccountName;
				if(isUpdateSelectedShipToChecked){
					currentQuote.SAP_Ship_To_Partner_Number__c = selectedShipTo.value;
				}
				currentQuote.New_Ship_To_Contact__c = newShipToContactName;
				currentQuote.New_Ship_To_Street_1__c = newShipToStreet1;
				currentQuote.New_Ship_To_Street_2__c = newShipToStreet2;
				currentQuote.New_Ship_To_City__c = newShipToCity;
				currentQuote.New_Ship_To_State__c = newShipToState;
				currentQuote.New_Ship_To_Zip_Postal_Code__c = newShipToPostalCode;
				currentQuote.New_Ship_To_Country__c = newShipToCountry;
				currentQuote.New_Ship_To_Phone__c = newShipToPhone;
			}else{
				//User decided to use existing name & address
				currentQuote.Is_Update_Selected_Ship_To__c = false;
				currentQuote.Is_Create_New_Ship_To__c = false;
				
				currentQuote.New_Ship_To_Account_Name__c = '';
				//currentQuote.SAP_Ship_To_Partner_Number__c = '';
				currentQuote.New_Ship_To_Contact__c = '';
				currentQuote.New_Ship_To_Street_1__c = '';
				currentQuote.New_Ship_To_Street_2__c = '';
				currentQuote.New_Ship_To_City__c = '';
				currentQuote.New_Ship_To_State__c = '';
				currentQuote.New_Ship_To_Zip_Postal_Code__c = '';
				currentQuote.New_Ship_To_Country__c = '';
				currentQuote.New_Ship_To_Phone__c = '';
				
				if(selectedShipTo.objCustContact != NULL){
					currentQuote.ERP_Ship_To_Account_Name__c = erpAccountName;
					currentQuote.ERP_Ship_To_Contact_Name__c = selectedShipTo.label;
					currentQuote.SAP_Ship_To_Partner_Number__c = selectedShipTo.value;
					currentQuote.ERP_Ship_To_Street_1__c = selectedShipTo.objCustContact.customerContactPersonAddress.addressLine1;
					currentQuote.ERP_Ship_To_Street_2__c = getStreet2(selectedShipTo.objCustContact.customerContactPersonAddress.room, selectedShipTo.objCustContact.customerContactPersonAddress.floor, selectedShipTo.objCustContact.customerContactPersonAddress.buildingCode);
					currentQuote.ERP_Ship_To_City__c = selectedShipTo.objCustContact.customerContactPersonAddress.city;
					currentQuote.ERP_Ship_To_State__c = selectedShipTo.objCustContact.customerContactPersonAddress.stateCode;
					currentQuote.ERP_Ship_To_Zip_Postal_Code__c = selectedShipTo.objCustContact.customerContactPersonAddress.zipPostalCode;
					currentQuote.ERP_Ship_To_Country__c = selectedShipTo.objCustContact.customerContactPersonAddress.countryCode;
					Boolean isPhoneNumberReceived = false;
					if(selectedShipTo.objCustContact.customerContactPersonContact != NULL && selectedShipTo.objCustContact.customerContactPersonContact.Contact != NULL)
					{
						for(EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactDetails : selectedShipTo.objCustContact.customerContactPersonContact.Contact){
							if(objContactDetails.contactType == 'PHONE' && !String.isBlank(objContactDetails.contactDetails)){
								currentQuote.ERP_Ship_To_Phone__c = objContactDetails.contactDetails;
								isPhoneNumberReceived = true;
							}
						}
					}
					if(isPhoneNumberReceived){
						currentQuote.ERP_Ship_To_Phone__c = '';
					}
				}
			}
			
			//Set address invalid flag
			//TRUE then the quote will be ineligible for order automation
			//FALSE then the quote will be eligible for order automation
			currentQuote.Is_New_Business_Party_Address_Invalid__c = isAddressInvalid;
			 
			if(currentQuote.Id != NULL)
			{
				//Perform DML operation to update the Quote
				Database.SaveResult saveResult = Database.update(currentQuote);
				if(saveResult.isSuccess()){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Changes has been saved !!'));
				}else{
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, saveResult.getErrors()[0].getMessage()));
				}
			}
		}catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
	}
	
	//Continuation action for DQ Address Validation Callout
	public Continuation validateAddress()
	{
		try{
			//Check if call to DQ is required
			if(isUpdateSelectedBillToChecked || isCreateNewBillToChecked || isUpdateSelectedShipToChecked || isCreateNewShipToChecked)
			{
				//Validate the form inputs & prepare request XML if all good
				Boolean isError = prepareAddressRequest();
				if(!isError)
				{
					//Set continuation call timeout
					//Integer TIMEOUT_INT_SECS = 20;
			       	Integer TIMEOUT_INT_SECS = Integer.valueOf(objOrderIntegration.Continuation_Call_Timeout__c);  
			       	Continuation objCont = new Continuation(TIMEOUT_INT_SECS);
			       	//Set continuation callback method, this will be called when the response is received from downstream service
			       	objCont.continuationMethod = 'processAddressValidationResponse';
					
					AsyncEOI_IIB_SAPAddressDQService.AsyncReal_time_Services addressValidationRequest = new AsyncEOI_IIB_SAPAddressDQService.AsyncReal_time_Services();
					
			       	//Log web service call-out time
			       	startTime = System.now().getTime();
			       	//Begin Async DQ Address Validation callout
			       	asyncAddressValidationResponse = addressValidationRequest.beginService_Realtime_DQ_SAP_Address_Cleanse(objCont, Records, addressUUIDMetaDataRequest);
			       	return objCont;
		       }
			}else{
				//Save addresses to the Quote in any outcome
		        if(currentQuote.Id != NULL){
		        	save();
		        }
			}
			
		}catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
			return null;				
       	}
       	return null;
	}
	
	//Call back method for DQ Address Validation Continuation callout
	public Object processAddressValidationResponse()
	{
		logList = new List<sObject>();
		try{
			//System.debug('##: ' + asyncAddressValidationResponse);
			//Assume that address is not invalid (meaning it is valid)
			isAddressInvalid = false;
			//If the callout was from test class then setup the mock response
	    	if(!Test.isRunningTest()){
	    		addressValidationResponse = asyncAddressValidationResponse.getValue();
	    	}
	    	//Log total round trip time in debug logs
	    	totalTime = System.now().getTime() - startTime;
	        System.debug('Round Trip Time Required (to DQ Address Validation) : ' + totalTime);
	        
	        if(addressValidationResponse != NULL && addressValidationResponse.Record != NULL && addressValidationResponse.Record.size() > 0)
	        {
	        	//Response is received
	        	for(EOI_IIB_AddressValidationResponse.Record_element objResponse : addressValidationResponse.Record)
	        	{
	        		//If it doesn't go inside the if then it means the address is valid
	        		//The condition is revered because no one knows all possible error codes
	        		if(objResponse.STATUS_CODE != WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_SUCCESS_STATUSCODE){
						isAddressInvalid = true;	        			
	        		}
	        	}
	        }else{
	        	//No or negative response so mark address invalid as we don't know what's the problem
	        	isAddressInvalid = true;
	        }
	        //Override Application Logging Method to Log the response
	        if(currentQuote.Id != NULL){
	       		logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('EOI_GetBusinessPartnersController', 'processAddressValidationResponse', Records, addressValidationResponse, currentQuote.Id));
	        }
        }catch(Exception ex){
        	isAddressInvalid = true;
        	//Show exception message when called through test harness page
        	if(currentQuote.Id == NULL){
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.EOI_SAP_GETACCOUNTINFO_ERROR_500_MESSAGE));
	        	if(ex instanceof CalloutException){
	        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Downstream system to validate the address is not available.'));
	        	}else if(ex instanceof DMLException){
	        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'DML Exception occurred while logging the monitoring record.'));
	        	}else{
	        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unhandled technical exception ocurred.'));
	        	}
        	}
        	if(currentQuote.Id != NULL){
        		logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('EOI_GetBusinessPartnersController', 'processAddressValidationResponse', String.valueOf(Records), ex.getMessage(), currentQuote.Id, ''));
        	}
        }finally{
        	//Save addresses to the Quote in any outcome
	        if(currentQuote.Id != NULL){
	        	save();
	        }
	        if(logList.size() > 0){
	        	insert logList;
	        }
        }
        return null;
	}
	
	//Validate form inputs & prepare DQ Address Validation Request XML 
	public Boolean prepareAddressRequest()
	{
		Boolean isError = false;
		//User decided to override the Bill-To or create new Bill-To
		if(isUpdateSelectedBillToChecked || isCreateNewBillToChecked)
		{
			isError = isSomethingReallyChanged('BillTo');
		}
		
		//User decided to override the Ship-To or create new Ship-To
		if(isUpdateSelectedShipToChecked || isCreateNewShipToChecked)
		{
			isError = isSomethingReallyChanged('ShipTo');
		}	
		System.debug('### : ' + isUpdateSelectedBillToChecked);
		System.debug('### : ' + isUpdateSelectedShipToChecked);
		if(!isError)
		{
			//No validation error so prepare request XML
			addressUUIDMetaDataRequest = new EOI_IIB_AddressValidationRequest.UUIDMetaDataRequestDataType();
	    	addressUUIDMetaDataRequest.uuid = WK_Utility.UUID_Generator();
	        addressUUIDMetaDataRequest.CallingSystemName = objOrderIntegration.SourceSystemName__c;
	        addressUUIDMetaDataRequest.RequestDateTime = Date.Today();
	        addressUUIDMetaDataRequest.TargetSystemName = 'SAP';
	        addressUUIDMetaDataRequest.UniqueCallingUserId = UserInfo.getName() + '_' + UserInfo.getUserId();
	        addressUUIDMetaDataRequest.TransactionMonitoringFlag = objOrderIntegration.TransactionMonitoringFlag__c == '1' ? 'Y' : 'N';
	        addressUUIDMetaDataRequest.LoggingFlag = objOrderIntegration.LoggingFlag__c == '1' ? 'Y' : 'N';
	        addressUUIDMetaDataRequest.ServiceVersion = objOrderIntegration.IIB_Address_DQM_Service_Version__c;
			
			Records = new EOI_IIB_AddressValidationRequest.Record_element[]{};
			
			if(isUpdateSelectedBillToChecked || isCreateNewBillToChecked)
			{
				//User decided to override Bill-To Address or Create new Bill-To so consider Bill-To Address for validation
				EOI_IIB_AddressValidationRequest.Record_element objRecord = new EOI_IIB_AddressValidationRequest.Record_element();
				objRecord.STREET = newBillToStreet1 + (String.isBlank(newBillToStreet2) ? '' : ' ' + newBillToStreet2);
				objRecord.CITY1 = newBillToCity;
				objRecord.REGION = newBillToState;
				//Pass only 5 digit postal code
				objRecord.POST_CODE1 = newBillToPostalCode.length() > 5 ? newBillToPostalCode.substring(0,5) : newBillToPostalCode;
				//Check country name since SAP Address DQM service doesn't like 'United States' as a full
				objRecord.COUNTRY = newBillToCountry.contains('United States') ? 'US' : newBillToCountry;
				Records.add(objRecord);
			}
			if(isUpdateSelectedShipToChecked || isCreateNewShipToChecked)
			{
				//User decided to override Ship-To Address or Create new Ship-To so consider Ship-To Address for validation
				EOI_IIB_AddressValidationRequest.Record_element objRecord = new EOI_IIB_AddressValidationRequest.Record_element();
				objRecord.STREET = newShipToStreet1 + (String.isBlank(newShipToStreet2) ? '' : ' ' + newShipToStreet2);
				objRecord.CITY1 = newShipToCity;
				objRecord.REGION = newShipToState;
				//Pass only 5 digit postal code
				objRecord.POST_CODE1 = newShipToPostalCode.length() > 5 ? newShipToPostalCode.subString(0,5) : newShipToPostalCode;
				//Check country name since SAP Address DQM service doesn't like 'United States' as a full 
				objRecord.COUNTRY = newShipToCountry.contains('United States') ? 'US' : newShipToCountry;
				Records.add(objRecord);
			}
				
		}
		return isError;
	}
	
	//This method checks if something is really changed or user has just checked the checkboxes
	public Boolean isSomethingReallyChanged(String partyType)
	{
		Boolean isChanged = false;
		isError = false;
		if(partyType == 'BillTo')
		{
			if(String.isBlank(newBillToContactName))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To Contact Name is required.'));
			}
			if(String.isBlank(newBillToStreet1))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To Street 1 is required.'));
			}
			if(String.isBlank(newBillToCity))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To City is required.'));
			}
			if(String.isBlank(newBillToState))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To State is required.'));
			}
			if(String.isBlank(newBillToPostalCode))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To Zip/Postal Code is required.'));
			}
			if(String.isBlank(newBillToCountry))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Bill To Country is required.'));
			}
			
			if(isUpdateSelectedBillToChecked && selectedBillTo.objCustContact != NULL)
			{
				if(newBillToContactName != selectedBillTo.objCustContact.customerContactPersonFirstName){
					isChanged = true;
				}else if(newBillToStreet1 != selectedBillTo.objCustContact.customerContactPersonAddress.addressLine1){
					isChanged = true;
				}else if(newBillToStreet2 != getStreet2(selectedBillTo.objCustContact.customerContactPersonAddress.room, selectedBillTo.objCustContact.customerContactPersonAddress.floor, selectedBillTo.objCustContact.customerContactPersonAddress.buildingCode)){
					isChanged = true;
				}else if(newBillToCity != selectedBillTo.objCustContact.customerContactPersonAddress.city){
					isChanged = true;
				}else if(newBillToState != selectedBillTo.objCustContact.customerContactPersonAddress.stateCode){
					isChanged = true;
				}else if(newBillToPostalCode != selectedBillTo.objCustContact.customerContactPersonAddress.zipPostalCode){
					isChanged = true;
				}else if(newBillToCountry != selectedBillTo.objCustContact.customerContactPersonAddress.countryCode){
					isChanged = true;
				}
				
				if(!isChanged){
					isUpdateSelectedBillToChecked = false;		
				}
			}
		}else{
			if(String.isBlank(newShipToContactName))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To Contact Name is required.'));
			}
			if(String.isBlank(newShipToStreet1))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To Street 1 is required.'));
			}
			if(String.isBlank(newShipToCity))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To City is required.'));
			}
			if(String.isBlank(newShipToState))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To State is required.'));
			}
			if(String.isBlank(newShipToPostalCode))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To Zip/Postal Code is required.'));
			}
			if(String.isBlank(newShipToCountry))
			{
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ship To Country is required.'));
			}
			
			if(isUpdateSelectedShipToChecked && selectedShipTo.objCustContact != NULL)
			{
				if(newShipToContactName != selectedShipTo.objCustContact.customerContactPersonFirstName){
					isChanged = true;
				}else if(newShipToStreet1 != selectedShipTo.objCustContact.customerContactPersonAddress.addressLine1){
					isChanged = true;
				}else if(newShipToStreet2 != getStreet2(selectedShipTo.objCustContact.customerContactPersonAddress.room, selectedShipTo.objCustContact.customerContactPersonAddress.floor, selectedShipTo.objCustContact.customerContactPersonAddress.buildingCode)){
					isChanged = true;
				}else if(newShipToCity != selectedShipTo.objCustContact.customerContactPersonAddress.city){
					isChanged = true;
				}else if(newShipToState != selectedShipTo.objCustContact.customerContactPersonAddress.stateCode){
					isChanged = true;
				}else if(newShipToPostalCode != selectedShipTo.objCustContact.customerContactPersonAddress.zipPostalCode){
					isChanged = true;
				}else if(newShipToCountry != selectedShipTo.objCustContact.customerContactPersonAddress.countryCode){
					isChanged = true;
				}
				
				if(!isChanged){
					isUpdateSelectedShipToChecked = false;		
				}
			}
		}
		
		return isError;
	}  
    
    //Get concatenated string for Street2
    public String getStreet2(String room, String floor, String buildingCode)
    {
    	String newStreet2 = '';
    	if(!String.isBlank(room)){
			newStreet2 = room;
		}
		if(!String.isBlank(floor)){
			if(String.isBlank(newStreet2)){
				newStreet2 = floor;
			}else{
				newStreet2 = newStreet2 + ' ' + floor;
			}
		}
		if(!String.isBlank(buildingCode)){
			if(String.isBlank(newStreet2)){
				newStreet2 = buildingCode;
			}else{
				newStreet2 = newStreet2 + ' ' + buildingCode;	
			}
		}
		return newStreet2;
    }
    
    //Get concatenated string for address from business partner response
    public String getAddress(EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objBusinessPartner)
    {
    	String address = '';
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.addressLine1)){
    		address = objBusinessPartner.customerContactPersonAddress.addressLine1;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.room)){
    		address = address + ' ' + objBusinessPartner.customerContactPersonAddress.room;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.floor)){
    		address = address + ' ' + objBusinessPartner.customerContactPersonAddress.floor;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.buildingCode)){
    		address = address + ' ' + objBusinessPartner.customerContactPersonAddress.buildingCode;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.city)){
    		address = address + ', ' + objBusinessPartner.customerContactPersonAddress.city;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.stateCode)){
    		address = address + ', ' + objBusinessPartner.customerContactPersonAddress.stateCode;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.zipPostalCode)){
    		address = address + ' ' + objBusinessPartner.customerContactPersonAddress.zipPostalCode;
    	}
    	if(!String.isBlank(objBusinessPartner.customerContactPersonAddress.countryCode)){
    		address = address + ', ' + objBusinessPartner.customerContactPersonAddress.countryCode;
    	}
    	return address;
    }
    
    //Get concatenated string for address all individual components
    public String getAddress(String street1, String street2, String city, String state, String zip, String country)
    {
    	String address = '';
    	if(!String.isBlank(street1)){
    		address = street1;
    	}
    	if(!String.isBlank(street2)){
    		address = address + ' ' + street2;
    	}
    	if(!String.isBlank(city)){
    		address = address + ', ' + city;
    	}
    	if(!String.isBlank(state)){
    		address = address + ', ' + state;
    	}
    	if(!String.isBlank(zip)){
    		address = address + ' ' + zip;
    	}
    	if(!String.isBlank(country)){
    		address = address + ', ' + country;
    	}
    	return address;
    }
    
    //Auto-complete wrapper
    public class AutoCompleteListWrapper
    {
    	public AutoCompleteListWrapper(String partyName, String partyNumber, String partyAddress, EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType obj)
    	{
    		this.label = partyName;
    		this.value = partyNumber;
    		this.address = partyAddress;
    		this.objCustContact = obj;
    	}
    	public String value {get; set;}
    	public String address {get; set;} 
    	public String label {get; set;}
    	public EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objCustContact {get; set;}
    }    
}