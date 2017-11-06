/*
 * Test class for below components
 * 1. EOI_GetBusinessPartnersController.cls
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/06/2017 SHIVAJI           1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest (seeAllData = false)
public class EOI_GetBusinessPartnersControllerTest 
{
    // data preparation
    @testSetup static void testdataFactory() 
    {
        //EOI_Test_QuoteProposalTriggerHandler.createCustomSettingForOrderAutomation();
        EOI_Order_Integration__c orderCustomSetting = new EOI_Order_Integration__c();
        orderCustomSetting.IsERPOrderIntegrationOn__c = true;
        orderCustomSetting.IsERPOrderCreationFromQuoteProposalOn__c = true;
        orderCustomSetting.LoggingFlag__c = '1';
        orderCustomSetting.NoOfRetries__c = 3;
        orderCustomSetting.RetryInterval_Timeout__c = 2;
        orderCustomSetting.ServiceVersion__c = 'V2';
        orderCustomSetting.SourceSystemName__c = 'SFDC TAAQA Sandbox';
        orderCustomSetting.TransactionMonitoringFlag__c = '1';
        orderCustomSetting.WK_URLOrderIntegration__c = 'https://taaqa.wkgbssvcs.com/TAA/OrderAutomation/v5';
        orderCustomSetting.Continuation_Call_Timeout__c = 20;
        orderCustomSetting.IIBURLGetAccountInfo__c = 'https://taaqa.wkgbssvcs.com/getAccountInfo/V1.2';
        orderCustomSetting.IIB_DQAddressValidationURL__c = 'https://taaqa.sap.com/DQAddress/V1.2';
        orderCustomSetting.GetAccountInfoServiceVersion__c = '1.2';
        insert orderCustomSetting;
        
        Account newAccount = EOI_Test_QuoteProposalTriggerHandler.createAccount();
        insert newAccount;
        
        Contact newContact = EOI_Test_QuoteProposalTriggerHandler.createContact(newAccount.Id);
        insert newContact;
        
        Opportunity newOpportunity = EOI_Test_QuoteProposalTriggerHandler.createOpportunity(newAccount.Id, newContact.Id);
        insert newOpportunity;
        
        Account_X_Reference__c accountRef = EOI_Test_QuoteProposalTriggerHandler.createAccountXReference(newAccount.Id);
        accountRef.ERP_Account_Name__c = 'Test Account';
        accountRef.Bill_To_Account_Name__c = 'Test Account';
        accountRef.Ship_To_Account_Name__c = 'Test Account';
        insert accountRef;
        
        Apttus_Config2__PriceList__c priceList = EOI_Test_QuoteProposalTriggerHandler.createPriceList('R&L Price List', 'tsting', Date.today(), Date.today()+90);
        
        Apttus_Proposal__Proposal__c newProposal = EOI_Test_QuoteProposalTriggerHandler.createProposal('', 'Standard+IP','','', '4001178291','123456', '12345', '','','','1234567891234567', '', newAccount.Id, newContact.Id, newOpportunity.Id, accountRef.Id, WK_Constants.EOI_QuoteRecordType_SAP_Subscription);
        newProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
        newProposal.SAP_Sales_Channel__c = 'Field Sales Rep';
        newProposal.SAP_Contact_Channel__c = 'Field Sales Rep';
        newProposal.ERP_Bill_To_Contact_Name__c = 'Test Contact';
        newProposal.ERP_Bill_To_Street_1__c = 'Street1';
        newProposal.ERP_Bill_To_Street_2__c = 'Street2';
        newProposal.ERP_Bill_To_City__c = 'City';
        newProposal.ERP_Bill_To_State__c = 'State';
        newProposal.ERP_Bill_To_Zip_Postal_Code__c = '12345';
        newProposal.ERP_Bill_To_Country__c = 'Country';
        insert newProposal;
        
        Apttus_Proposal__Proposal__c newProposalWithAllDetails = [SELECT ERP_Account__r.ApplicationID__c, ERP_Account__r.Application__c, Apttus_Proposal__Account__r.Named_Account__c, Apttus_Proposal__Account__r.Market_Segment__c, Apttus_QPConfig__PriceListId__r.Name, MYA__c, ASA__c, WK_Stub_Year__c, SAP_Drop_Shipment__c, SAP_IC_Trial_Account_Number__c, Shipping_Method__c, Shipping_Account__c, Has_PICK_Line_Item__c, Id, Name, Eligible_for_Order_Automation__c, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c, ERP_Address_Override__c, ERP_Contact_Override__c, MA_Year_1_Start_Date__c FROM Apttus_Proposal__Proposal__c WHERE Id =: newProposal.Id];
        
        Product2 optionproduct = EOI_Test_QuoteProposalTriggerHandler.createProduct('OptionProduct2','TestApttus4','TestApttus3','TestApttus3','Option','Each',true,Date.today(),Date.today().addMonths(12),'Training & Consulting');
        Product2 bundleProduct = EOI_Test_QuoteProposalTriggerHandler.createProduct('BundleProduct1','TestApttus','TEST Apttus','TestApttus','Bundle','Each',true,Date.today(),Date.today().addMonths(12),'Software');
        
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = EOI_Test_QuoteProposalTriggerHandler.createProposalLineItem(newProposalWithAllDetails.Id, bundleProduct.Id, optionproduct.Id,priceList.Id);
        insert proposalLineItemList;
        
        /*
        Apttus_Proposal__Proposal__c newProposalSAPBook = EOI_Test_QuoteProposalTriggerHandler.createProposal('', 'Standard+IP','','', '4001178291','123456', '12345', '','','','1234567891234567', '',newAccount.Id,newContact.Id, newOpportunity.Id, accountRef.Id, WK_Constants.EOI_QuoteRecordType_SAP_Books);
        newProposalSAPBook.Apttus_QPConfig__PriceListId__c = priceList.Id;
        newProposalSAPBook.SAP_Sales_Channel__c = 'Field Sales Rep';
        newProposalSAPBook.SAP_Contact_Channel__c = 'Field Sales Rep';
        insert newProposalSAPBook;
        */
    }
    
    public static testMethod void testConstructor() 
    {
        Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c 
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        quote.Is_Update_Selected_Bill_To__c = true;
        quote.Is_Update_Selected_Ship_To__c = true;
        update quote;
        
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        quote.ERP_Account__c = NULL;
        update quote;
        objController = new EOI_GetBusinessPartnersController(stdQuote);
        
        stdQuote = new ApexPages.StandardController(new Apttus_Proposal__Proposal__c());
        objController = new EOI_GetBusinessPartnersController(stdQuote);
        Test.stopTest();
    }
    
    public static testMethod void testGetAccountInfoRequest() 
    {
        Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        objController.startGetAccountInfoRequest();
        Test.stopTest();
    }
    
    public static testMethod void testGetAccountInfoResponsePositive() 
    {
        Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        objController.startGetAccountInfoRequest();
        
        //POSITIVE TEST CASE
        objController.response = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element();
        
        EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoResponseType objAccountResponse = new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoResponseType();
        objAccountResponse.accountName = 'Test Account';
        objController.response.accountInfoResponse = objAccountResponse;
        
        EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactsType objCustContactType = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactsType();
        
        EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objCustContactBillTo = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType();
        objCustContactBillTo.customerContactTypeDescription = 'Bill-to party';
        objCustContactBillTo.customerContactPersonUniqueId = '123';
        objCustContactBillTo.customerContactPersonFirstName = 'FIRST';
        
        EOI_IIB_ERP_GetAccountInfo_V2.AddressType billToAddress = new EOI_IIB_ERP_GetAccountInfo_V2.AddressType();
        billToAddress.addressLine1 = 'LINE1';
        billToAddress.room = 'ROOM';
        billToAddress.floor = 'FLOOR';
        billToAddress.buildingCode = 'BLDNG';
        billToAddress.city = 'CITY';
        billToAddress.stateCode = 'STATE';
        billToAddress.zipPostalCode = 'ZIP';
        billToAddress.countryCode = 'COUNTRY';
        
        objCustContactBillTo.customerContactPersonAddress = billToAddress;
        
        objCustContactBillTo.customerContactPersonContact = new EOI_IIB_ERP_GetAccountInfo_V2.ContactListType();
        EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactBillTo = new EOI_IIB_ERP_GetAccountInfo_V2.ContactType();
        objContactBillTo.contactType = 'PHONE';
        objContactBillTo.contactDetails = '123';
        objCustContactBillTo.customerContactPersonContact.Contact = new EOI_IIB_ERP_GetAccountInfo_V2.ContactType[]{objContactBillTo};
        
        EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objCustContactShipTo = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType();
        objCustContactShipTo.customerContactTypeDescription = 'Ship-to party';
        objCustContactShipTo.customerContactPersonUniqueId = '123';
        objCustContactShipTo.customerContactPersonFirstName = 'FIRST';
        
        EOI_IIB_ERP_GetAccountInfo_V2.AddressType shipToAddress = new EOI_IIB_ERP_GetAccountInfo_V2.AddressType();
        shipToAddress.addressLine1 = 'LINE1';
        shipToAddress.room = 'ROOM';
        shipToAddress.floor = 'FLOOR';
        shipToAddress.buildingCode = 'BLDNG';
        shipToAddress.city = 'CITY';
        shipToAddress.stateCode = 'STATE';
        shipToAddress.zipPostalCode = 'ZIP';
        shipToAddress.countryCode = 'COUNTRY';
        
        objCustContactShipTo.customerContactPersonAddress = shipToAddress;
        
        objCustContactShipTo.customerContactPersonContact = new EOI_IIB_ERP_GetAccountInfo_V2.ContactListType();
        EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactShipTo = new EOI_IIB_ERP_GetAccountInfo_V2.ContactType();
        objContactShipTo.contactType = 'PHONE';
        objContactShipTo.contactDetails = '123';
        objCustContactShipTo.customerContactPersonContact.Contact = new EOI_IIB_ERP_GetAccountInfo_V2.ContactType[]{objContactShipTo};
        
        objCustContactType.CustomerContact = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType[]{objCustContactBillTo, objCustContactShipTo};
        objController.response.customerContacts =  objCustContactType;
        
        objController.processGetAccountInfoResponse();
        PageReference currentPage = Page.EOI_BusinessPartnerPage;
        Test.setCurrentPage(currentPage);
        ApexPages.currentPage().getParameters().put('changedBusinessPartnerType', 'BillTo');
        objController.selectedBillToNumber = '123';
    	objController.populateBusinessPartnerDetails();
    	objController.isUpdateSelectedBillToChecked = true;
    	objController.updateSelectedBusinessPartner();
    	
    	ApexPages.currentPage().getParameters().put('changedBusinessPartnerType', 'ShipTo');
        objController.selectedShipToNumber = '123';
    	objController.populateBusinessPartnerDetails();
    	objController.isUpdateSelectedShipToChecked = true;
    	objController.updateSelectedBusinessPartner();
    	
    	objController.save();
    	
    	objController.isUpdateSelectedBillToChecked = false;
    	objController.isUpdateSelectedShipToChecked = false;
    	objController.isCreateNewBillToChecked = false;
    	objController.isCreateNewShipToChecked = false;
    	objController.save();
    	
    	objController.isCopyFromBillTo = true;
    	objController.copyFromBillTo();
    	
    	objController.isCopyFromBillTo = false;
    	objController.copyFromBillTo();
        Test.stopTest();
    }
    
    public static testMethod void testGetAccountInfoResponseNegative() 
    {
        Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        objController.startGetAccountInfoRequest();
        
        //NEGATIVE TEST CASE
        objController.response = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element();
        
        objController.response.accountInfoResponse = NULL;
        objController.response.errorMessages = new EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessagesType();
        
        EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType objError = new EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType();
        objError.customErrorMessageDescription = 'ERROR';
        
        objController.response.errorMessages.ErrorMessage = new EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType[]{objError}; 
        objController.processGetAccountInfoResponse();
        Test.stopTest();
    }
    
    public static testMethod void testEnableNewBusinessPartnerForm()
    {
    	Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        
        PageReference currentPage = Page.EOI_BusinessPartnerPage;
        Test.setCurrentPage(currentPage);
        ApexPages.currentPage().getParameters().put('changedBusinessPartnerType', 'BillTo');
        objController.isCreateNewBillToChecked = true;
        objController.isUpdateSelectedBillToChecked = false;
        objController.selectedBillTo = new EOI_GetBusinessPartnersController.AutoCompleteListWrapper('PARTYNAME', 'PARTYNUMBER', 'PARTYADDR', null);
        objController.enableNewBusinessPartnerForm();
        
        objController.isCreateNewBillToChecked = false;
        objController.isUpdateSelectedBillToChecked = false;
        objController.enableNewBusinessPartnerForm();
        
        ApexPages.currentPage().getParameters().put('changedBusinessPartnerType', 'ShipTo');
        objController.isCreateNewShipToChecked = true;
        objController.isUpdateSelectedShipToChecked = false;
        objController.selectedShipTo = new EOI_GetBusinessPartnersController.AutoCompleteListWrapper('PARTYNAME', 'PARTYNUMBER', 'PARTYADDR', null);
        objController.enableNewBusinessPartnerForm();
        
        objController.isCreateNewShipToChecked = false;
        objController.isUpdateSelectedShipToChecked = false;
        objController.enableNewBusinessPartnerForm();
        
        Test.stopTest();
    }
    
	public static testMethod void testValidateAddress()
    {
    	Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        
        objController.isUpdateSelectedBillToChecked = true;
        objController.isUpdateSelectedShipToChecked = true;
        objController.newBillToCountry = '';
        objController.newShipToCity = '';
        objController.newShipToCountry = '';
        objController.validateAddress();
        
        objController.newBillToContactName = 'CONTACTNAME';
        objController.newBillToStreet1 = 'STREET1';
        objController.newBillToCity = 'CITY';
        objController.newBillToState = 'STATE';
        objController.newBillToPostalCode = 'ZIPCODE';
        objController.newBillToCountry = 'COUNTRY';
        
        objController.newShipToContactName = 'CONTACTNAME';
        objController.newShipToStreet1 = 'STREET1';
        objController.newShipToCity = 'CITY';
        objController.newShipToState = 'STATE';
        objController.newShipToPostalCode = 'ZIPCODE';
        objController.newShipToCountry = 'COUNTRY';
        objController.validateAddress();
        Test.stopTest();
    } 
    
    public static testMethod void testProcessAddressValidationResponse()
    {
		Apttus_Proposal__Proposal__c quote = [SELECT Id, Name, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c,
        											ERP_Account__c, ERP_Bill_To_Account_Name__c, ERP_Account__r.Application__c  
        											FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Test.startTest();
        ApexPages.StandardController stdQuote = new ApexPages.StandardController(quote);
        EOI_GetBusinessPartnersController objController = new EOI_GetBusinessPartnersController(stdQuote);
        
        objController.processAddressValidationResponse();
        objController.startTime = System.now().getTime();
        //EOI_IIB_AddressValidationResponse.Record_element response = new EOI_IIB_AddressValidationResponse.Record_element();
        //response.STATUS_CODE = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_SUCCESS_STATUSCODE;
        //objController.addressValidationResponse = new EOI_IIB_AddressValidationResponse.Record_element[]{response};
        //objController.processAddressValidationResponse();
        
        //response.STATUS_CODE = WK_Constants.EOI_SAP_DQ_ADDR_VALIDATION_SUCCESS_STATUSCODE + '22';
        objController.processAddressValidationResponse();
        Test.stopTest();
    }
}