/*
 * Test class for below components
 * 1. EOI_IIB_ERP_GetAccountInfo_V2.cls
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/11/2017 SHIVAJI           1.0         Initial draft
 * ------------------------------------------------------------------------- */
@isTest (seeAllData = false)
public class EOI_IIB_ERP_GetAccountInfo_V2Test 
{
   	// data preparation
	public static testMethod void testCase_1() 
    {
    	EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoRequestWrapper objGetAccountInfoRequest = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoRequestWrapper();
    	objGetAccountInfoRequest.uuidMetaDataRequest = new EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataRequestType();
    	objGetAccountInfoRequest.accountInfo = new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoType();
    	EOI_IIB_ERP_GetAccountInfo_V2.AdditionalTaxInfoType objTaxInfo = new EOI_IIB_ERP_GetAccountInfo_V2.AdditionalTaxInfoType();
    	EOI_IIB_ERP_GetAccountInfo_V2.ContactType objContactType = new EOI_IIB_ERP_GetAccountInfo_V2.ContactType();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfo_element objGetAccountInfo = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfo_element();
    	objGetAccountInfo.accountInfo = new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoType();
    	objGetAccountInfo.uuidMetaDataRequest = new EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataRequestType();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element objGetAccountInfoResp = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoResponse_element();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.ElectronicFilingCustomerInfoType objElectoCustInfo = new EOI_IIB_ERP_GetAccountInfo_V2.ElectronicFilingCustomerInfoType();
    	EOI_IIB_ERP_GetAccountInfo_V2.CreditInfoType objCreditInfo = new EOI_IIB_ERP_GetAccountInfo_V2.CreditInfoType();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactsType objCustContactType = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactsType();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.AxcessType objAxs = new EOI_IIB_ERP_GetAccountInfo_V2.AxcessType();
    	EOI_IIB_ERP_GetAccountInfo_V2.OtherSupportType objSupport = new EOI_IIB_ERP_GetAccountInfo_V2.OtherSupportType();
    	EOI_IIB_ERP_GetAccountInfo_V2.FoundationType objFoundation = new EOI_IIB_ERP_GetAccountInfo_V2.FoundationType();
    	EOI_IIB_ERP_GetAccountInfo_V2.EntityInfoListType objEntityInfo = new EOI_IIB_ERP_GetAccountInfo_V2.EntityInfoListType();
    	EOI_IIB_ERP_GetAccountInfo_V2.SupportInfoType objSupportType = new EOI_IIB_ERP_GetAccountInfo_V2.SupportInfoType();
    	EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataResponseType objUUID = new EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataResponseType();
    	EOI_IIB_ERP_GetAccountInfo_V2.EntityInfoType objEntity = new EOI_IIB_ERP_GetAccountInfo_V2.EntityInfoType();
    	EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoSOAP objGetAccntInfoSoap = new EOI_IIB_ERP_GetAccountInfo_V2.GetAccountInfoSOAP();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessagesType objErrorMessages = new EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessagesType();
    	EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType objErrorMessage = new EOI_IIB_ERP_GetAccountInfo_V2.ErrorMessageType();
    	EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType objCustContact = new EOI_IIB_ERP_GetAccountInfo_V2.CustomerContactType();
    	EOI_IIB_ERP_GetAccountInfo_V2.ContactListType objContactList = new EOI_IIB_ERP_GetAccountInfo_V2.ContactListType();
    	
    	EOI_IIB_ERP_GetAccountInfo_V2.AddressType objAddress = new EOI_IIB_ERP_GetAccountInfo_V2.AddressType();
    	EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoResponseType objAccountInfoResp = new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoResponseType();
    	
    	//objGetAccntInfoSoap.GetAccountInfo(new EOI_IIB_ERP_GetAccountInfo_V2.UUIDMetaDataRequestType(), new EOI_IIB_ERP_GetAccountInfo_V2.AccountInfoType());
    }
}