/*
 * Test class for below components
 * 1. TAA_ServiceOverviewController.cls
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 05/04/2017 SHIVAJI           1.0         Initial draft
 * 08/23/2017 SHIVAJI           1.1         Create Case Requirement
 * ------------------------------------------------------------------------- */
@isTest (seeAllData = false)
public class TAA_ServiceOverviewControllerTest 
{
    // data preparation
    @testSetup static void testdataFactory() 
    {
        Account newAccount = HelperTestClass.accountWithAddress_zip();
        HelperTestClass.xAccountWithSFSCountryChange(newAccount);
        HelperTestClass.xAccountWithAMSAndAddress(newAccount);
        HelperTestClass.xAccountSAP(newAccount);
        
        insert new Case(Escalation__c = 'E3');
    	
    	insert new Attachment(Name = 'DELETE###test.pdf', Description = 'test', IsPrivate = true, Body = Blob.valueOf('Test'), ParentId = newAccount.Id);
                
        insert new Oauth_settings__c(Name = 'TAAServiceOrg', ClientId__c = '541255441', ClientSecret__c = 'f4544155d5d44sd55fd4d5d', Username__c = 'test@name.com', Password__c = 'password', URL__c = 'http://url.com');
        insert new TAA_IIB_CreateCase_Credentials__c(IIB_Service_URL__c = 'https://example.wk', LoggingFlag__c = true, ServiceVersion__c = 'V4', SourceSystemName__c = 'SFDC', TransactionMonitoringFlag__c = true);
        
        List<Support_Site_Product_Details__c> lstProducts = new List<Support_Site_Product_Details__c>();
        lstProducts.add(new Support_Site_Product_Details__c(Name = '1', Product_Id__c = '1', Product_Name__c = 'All Other Print Publications', AccountType__c = 'o'));
        lstProducts.add(new Support_Site_Product_Details__c(Name = '2', Product_Id__c = '2', Product_Name__c = 'ATX Advantage', AccountType__c = 's'));
        insert lstProducts;
        
        List<Support_Site_Feature_Details__c> lstFeatures = new List<Support_Site_Feature_Details__c>();
        lstFeatures.add(new Support_Site_Feature_Details__c(Name = '1', ProductId__c = '1', Feature_Name__c = '1040 - Interview', AccountType__c = 'o'));
        lstFeatures.add(new Support_Site_Feature_Details__c(Name = '2', ProductId__c = '2', Feature_Name__c = '706/709 - Interview', AccountType__c = 's'));
        insert lstFeatures;
    }
	
    // test positive case for Account 
    static testmethod void testInvokeGetCases()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
            //objController.objAuthenticationInfo.access_token = 'TEST TOKEN';
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://sfdcfakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.invokeGetCases();
        
            objController.currentAccount.Audit_Competitor_End_Date__c = System.Today().addDays(-28);
            objController.currentAccount.Axcess_Tax_Competitor_End_Date__c = System.Today();
            objController.productFamilyName = 'ARM';
            objController.accountNumber = '1111';
            objController.fetchListOfCases();
            
            TAA_ServiceOverviewController.CaseResponse objCaseResponse = new TAA_ServiceOverviewController.CaseResponse();
            objCaseResponse.totalSize = 1;
            objCaseResponse.done = true;
            
            TAA_ServiceOverviewController.Attributes objAttr = new TAA_ServiceOverviewController.Attributes();
            objAttr.type = 'cases';
            objAttr.url = 'http://fakeurl.com';
            
            TAA_ServiceOverviewController.AccountRecords objAccnt = new TAA_ServiceOverviewController.AccountRecords();
            objAccnt.attributes = objAttr;
            objAccnt.Status = 'completed';
            objAccnt.expr0 = 1; 
            
            TAA_ServiceOverviewController.Cases objCases = new TAA_ServiceOverviewController.Cases();
            objCases.Totalsize = 1;
            objCases.done = true;
            
            Test.stopTest();
        }
    }
    
    // test positive case for Account 
    static testmethod void testGetProductFamilyList()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
            objController.objAuthenticationInfo = NULL;
            objController.getProductFamilyList();
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://fakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.getProductFamilyList();
            
            objController.objAuthenticationInfo.access_token = NULL;
            objController.getProductFamilyList();
            Test.stopTest();
        }
    }
    
    // test positive case for Account 
    static testmethod void testFetchListOfCases()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
            objController.objAuthenticationInfo = NULL;
            objController.fetchListOfCases();
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://fakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.fetchListOfCases();
            
            objController.objAuthenticationInfo.access_token = NULL;
            objController.fetchListOfCases();
            
            objController.caseDetailWithComments = new TAA_ServiceOverviewController.CaseWithCommentsResponse();
            objController.caseDetailWithComments.totalSize = 0;
            objController.caseDetailWithComments.done = true;
            objController.caseDetailWithComments.records = new List<Case>();
            
            Test.stopTest();
        }
    }
    
    // test positive case for Account 
    static testmethod void testGetCaseDetail()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
            //Test.setCurrentPageReference(new PageReference('Page.ServiceListOfCases'));
            System.currentPageReference().getParameters().put('selectedCaseId', 'caseId');
            objController.objAuthenticationInfo = NULL;
            objController.getCaseDetails();
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://fakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.getCaseDetails();
            
            objController.objAuthenticationInfo.access_token = NULL;
            objController.getCaseDetails();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_StartRequest_Negative()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();
            objController.invokeGetCases();   
            objController.enableNewCaseForm();
            objController.productId = '1';
            objController.refreshFeatureList();
            objController.productId = '';
            objController.startRequest();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_StartRequest_Positive()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();
            objController.invokeGetCases();   
            objController.productId = '1';
            objController.accountNumber = 'Demo xAccount with SFS';
            objController.accountType = 's';
            objController.contactFirstName = 'FIRSTNAME';
            objController.contactLastName = 'LASTNAME';
            objController.contactEmail = 'abc@example.com';
            objController.contactReason = 's';
            objController.issueReason = 'h';
            objController.strSubject = 'TEST CASE';
            objController.strDescription = 'TEST CASE';
            objController.isVisibleToCustomer = true;
            objController.featureId = '';
            objController.customerType = '';
            objController.bestTimeToContact = 'CST';
            objController.contactPhone = '9999999999';
            objController.internalComment = 'COMMENT';
            objController.startRequest();
            
            objController.productId = '';
            objController.contactReason = 'p';
            objController.startRequest();
            
            objController.invoiceNumber = '123456';
            objController.orderNumber = '123456';
            objController.contactReason = 'b';
            objController.startRequest();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_ProcessResponse_Positive()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();
            objController.invokeGetCases();   
            //objController.enableNewCaseForm();
            objController.productId = '1';
            objController.accountNumber = 'Demo xAccount with SFS';
            objController.accountType = 's';
            objController.contactFirstName = 'FIRSTNAME';
            objController.contactLastName = 'LASTNAME';
            objController.contactEmail = 'abc@example.com';
            objController.contactReason = 'p';
            objController.issueReason = 'h';
            objController.strSubject = 'TEST CASE';
            objController.strDescription = 'TEST CASE';
            objController.isVisibleToCustomer = true;
            objController.featureId = '';
            objController.customerType = '';
            //objController.refreshFeatureList();
            objController.startRequest();
            IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element response = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element();
            response.createCase = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseRespType();
            response.createCase.caseNumber = '1234567';
            response.createCase.sfdcCaseUrl = 'https://test.example.com/1234567';
            objController.response = response;
            objController.processResponse();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_ProcessResponse_Negative_0()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();
            objController.invokeGetCases();   
            //objController.enableNewCaseForm();
            objController.productId = '1';
            objController.accountNumber = 'Demo xAccount with SFS';
            objController.accountType = 's';
            objController.contactFirstName = 'FIRSTNAME';
            objController.contactLastName = 'LASTNAME';
            objController.contactEmail = 'abc@example.com';
            objController.contactReason = 's';
            objController.issueReason = 'h';
            objController.strSubject = 'TEST CASE';
            objController.strDescription = 'TEST CASE';
            objController.isVisibleToCustomer = true;
            objController.featureId = '';
            objController.customerType = '';
            //objController.refreshFeatureList();
            objController.startRequest();
            IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element response = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element();
            //response.createCase = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseRespType();
            //response.createCase.caseNumber = '1234567';
            response.errorMessages = new IIB_TAAServiceSiteCreateCase_V4.ErrorMessagesType();
            response.errorMessages.ErrorMessage = new IIB_TAAServiceSiteCreateCase_V4.ErrorMessageType();
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK;
            objController.response = response;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_NOT_PRESENT;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_EMAIL_BLANK;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_FIRSTNAME_BLANK;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_LASTNAME_BLANK;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_PRODUCT_NOT_PRESENT;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_CREATECASE_FAILED_PRODUCTFAMILY_NOT_PRESENT;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = WK_Constants.SVC_INTERNAL_SERVER_ERRORCODE;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.customErrorMessageCode = null;
            response.errorMessages.ErrorMessage.errorMessageCode = WK_Constants.SVC_INTERNAL_SERVER_ERRORCODE;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.errorMessageCode = WK_Constants.SVC_IIB_DATA_MISSING;
            objController.processResponse();
            
            response.errorMessages.ErrorMessage.errorMessageCode = WK_Constants.SVC_IIB_DATA_INVALID;
            objController.processResponse();
            
            objController.response = null;
            objController.processResponse();
            
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_ProcessResponse_Negative_1()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        System.runAs(currentUser){
            Test.startTest();
            objController.accountNumber = '123';
            objController.startRequest();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_AsyncIIB_TAAServiceSiteCreateCase_V4()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(currentUser){
            Test.startTest();
            AsyncIIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_elementFuture objAsync = new AsyncIIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_elementFuture();
            objAsync.getValue();
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateCase_IIB_TAAServiceSiteCreateCase_V4()
    {
        User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs(currentUser){
            Test.startTest();
            IIB_TAAServiceSiteCreateCase_V4.CaseRelatedInfoType objCaseRelatedInfo = new IIB_TAAServiceSiteCreateCase_V4.CaseRelatedInfoType();
            IIB_TAAServiceSiteCreateCase_V4.ActivityHistoryListType objActivityHistoryListType = new IIB_TAAServiceSiteCreateCase_V4.ActivityHistoryListType();
            IIB_TAAServiceSiteCreateCase_V4.CaseStatusType objCaseStatusType = new IIB_TAAServiceSiteCreateCase_V4.CaseStatusType();
            IIB_TAAServiceSiteCreateCase_V4.ActivityHistoryType objActivityHistoryType = new IIB_TAAServiceSiteCreateCase_V4.ActivityHistoryType();
            IIB_TAAServiceSiteCreateCase_V4.relatedCaseInfoType objRelatedCaseInfoType = new IIB_TAAServiceSiteCreateCase_V4.relatedCaseInfoType();
            IIB_TAAServiceSiteCreateCase_V4.EmployeeContactInfoType objEmployeeContactInfoType = new IIB_TAAServiceSiteCreateCase_V4.EmployeeContactInfoType();
            IIB_TAAServiceSiteCreateCase_V4.CaseCommentsType objCaseCommentsType = new IIB_TAAServiceSiteCreateCase_V4.CaseCommentsType();
            IIB_TAAServiceSiteCreateCase_V4.UUIDMetaDataResponseType objUUIDMetaDataResponseType = new IIB_TAAServiceSiteCreateCase_V4.UUIDMetaDataResponseType();
            IIB_TAAServiceSiteCreateCase_V4.relatedCaseInfoListType objRelatedCaseInfoListType = new IIB_TAAServiceSiteCreateCase_V4.RelatedCaseInfoListType();
            
            IIB_TAAServiceSiteCreateCase_V4.CreateCaseSOAP objCreateCaseSOAP = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseSOAP();
            Test.stopTest();
        }
    }
    
    static testmethod void testRefreshFormWithProducts()
    {
    	User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        
        System.runAs(currentUser){
            Test.startTest();
            objController.invokeGetCases();
            objController.accountNumber = 'Demo xAccount with SFS';
            objController.refreshFormWithProducts();
            
            objController.productId = '1';
        	objController.issueReason = 't';
        	objController.lstSupportSiteIssueReason = new List<SelectOption>();
        	objController.lstSupportSiteFeatures = new List<SelectOption>(); 
        	objController.refreshFeatureList();
        	
        	objController.productId = '2';
        	objController.refreshFeatureList();
            
            objController.accountNumber = 'Demo xAccount with AMS';
            objController.refreshFormWithProducts();
            Test.stopTest();
        }       
    }
    
    static testmethod void testRefreshContactDetails()
    {
    	User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        
        System.runAs(currentUser){
        	Test.startTest();
        	objController.contactChoice = 'Me';
        	objController.refreshContactDetails();
        	
        	objController.contactChoice = 'Customer';
        	objController.refreshContactDetails();
        	Test.stopTest();
        }
    }
    
    static testmethod void testUpdateCase()
    {
    	User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        
        System.runAs(currentUser){
        	Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
			        	
        	objController.caseDetailWithComments = new TAA_ServiceOverviewController.CaseWithCommentsResponse();
            objController.caseDetailWithComments.totalSize = 1;
            objController.caseDetailWithComments.done = true;
            objController.caseDetailWithComments.records = new List<Case>{new Case(Escalation__c = 'E1')};
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://sfdcfakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
                                        
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.updateCase();
            
            Case objCase = [SELECT Id, CaseNumber, Escalation__c FROM Case LIMIT 1];
            
            objController.caseDetailWithComments.records = new List<Case>{objCase};
            objController.updateCase();
            
            objCase.Escalation__c = NULL;
            objController.caseDetailWithComments.records = new List<Case>{objCase};
            objController.updateCase();
            
            objCase.Escalation__c = '';
            objController.objAuthenticationInfo = NULL;
            objController.updateCase();
        	Test.stopTest();
        }
    }
    
    static testmethod void testAddNewCaseComment()
    {
    	User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        
        System.runAs(currentUser){
        	Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
	
			objController.caseCommentBody = NULL;
            objController.addNewCaseComment();			        	
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://sfdcfakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
                                        
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.caseCommentBody = 'Case Comment';
            objController.addNewCaseComment();
            
            objController.selectedCaseId = '123456';
            objController.addNewCaseComment();
            
            objController.objAuthenticationInfo = NULL;
            objController.addNewCaseComment();
        	Test.stopTest();
        }
    }
    
    static testmethod void testAddNewCaseAttachment()
    {
    	User currentUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        Account account = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(account);
        TAA_ServiceOverviewController objController = new TAA_ServiceOverviewController(stdAcc);
        
        System.runAs(currentUser){
        	Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new TAAServiceOrgMockResponse());
        	Test.setCurrentPageReference(new PageReference('Page.myPage')); 
			Attachment objAttachment = [SELECT Id FROM Attachment LIMIT 1];
			
            objController.addNewCaseAttachment();			        	
            
            String authResponse = '{"access_token": "00Dg0000001qFYY!ARsAQNhy..Q_7MGPdlcaz6gv.5oPDiVyvHrnMArdm6jysyhxUj5TgZ9K9J3XP.CSVp2rfC3gzl46hhplMBMudI0NFyxUzMGC","instance_url": "https://sfdcfakeurl.com",'+
                                        +'"id": "https://test.salesforce.com/id/00Dg0000001qFYYEA2/005g0000004GW3GAAW",'+
                                        +'"token_type": "Bearer",'+
                                        +'"issued_at": "1499964009054",'+
                                        +'"signature": "zPbGhj4nIsMrpEng5J4Z8cIA/97bCRi+8qPliOA9aKE="}';
                                        
            objController.objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authResponse, OauthUtil.OAuth2.class);
            objController.selectedCaseId = '123456';
            System.currentPageReference().getParameters().put('newAttachmentId', objAttachment.Id);
            objController.addNewCaseAttachment();
            
            objController.objAuthenticationInfo = NULL;
            objController.selectedCaseId = '123456';
            System.currentPageReference().getParameters().put('newAttachmentId', objAttachment.Id);
            objController.addNewCaseAttachment();
        	Test.stopTest();
        }
    }
}