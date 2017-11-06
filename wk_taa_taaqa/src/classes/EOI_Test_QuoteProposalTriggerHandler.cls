@isTest
public class EOI_Test_QuoteProposalTriggerHandler {
    public static Schema.DescribeSObjectResult proposalSchema = Schema.SObjectType.Apttus_Proposal__Proposal__c; 
    public static Map<String,Schema.RecordTypeInfo> ProposalRecordTypeInfo = proposalSchema.getRecordTypeInfosByName();
    
    public static Schema.DescribeSObjectResult opportunitySchema = Opportunity.sObjectType.getDescribe();
    public static Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = opportunitySchema.getRecordTypeInfosByName();

    public static testMethod void myUnitTest() 
    {
        createCustomSettingForOrderAutomation();
        Account newAccount = createAccount();
        insert newAccount;
        system.assertNotEquals(newAccount.Id,null);
        
        Contact newContact = createContact(newAccount.Id);
        insert newContact;
        system.assertNotEquals(newContact.Id,null);
        
        Opportunity newOpportunity = createOpportunity(newAccount.Id, newContact.Id);
        insert newOpportunity;
        system.assertNotEquals(newOpportunity.Id,null);
        
        Account_X_Reference__c accountRef = createAccountXReference(newAccount.Id);
        insert accountRef;
        system.assertNotEquals(accountRef.Id,null);
        
        Apttus_Config2__PriceList__c priceList = createPriceList('R&L Price List', 'tsting', Date.today(), Date.today()+90);
        
        Apttus_Proposal__Proposal__c newProposal = createProposal('', 'Standard+IP','','', '4001178291','123456', '12345', '','','','1234567891234567', '', newAccount.Id, newContact.Id, newOpportunity.Id, accountRef.Id, WK_Constants.EOI_QuoteRecordType_SAP_Subscription);
        newProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
        newProposal.SAP_Sales_Channel__c = 'Field Sales Rep';
        newProposal.SAP_Contact_Channel__c = 'Field Sales Rep';
        insert newProposal;
        Apttus_Proposal__Proposal__c newProposalWithAllDetails = [SELECT ERP_Account__r.ApplicationID__c, ERP_Account__r.Application__c, Apttus_Proposal__Account__r.Named_Account__c, Apttus_Proposal__Account__r.Market_Segment__c, Apttus_QPConfig__PriceListId__r.Name, MYA__c, ASA__c, WK_Stub_Year__c, SAP_Drop_Shipment__c, SAP_IC_Trial_Account_Number__c, Shipping_Method__c, Shipping_Account__c, Has_PICK_Line_Item__c, Id, Name, Eligible_for_Order_Automation__c, RecordType.Name, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c, ERP_Address_Override__c, ERP_Contact_Override__c, MA_Year_1_Start_Date__c FROM Apttus_Proposal__Proposal__c WHERE Id =: newProposal.Id];
        system.assertNotEquals(newProposal.Id,null);
        system.assertNotEquals(newProposalWithAllDetails.Eligible_for_Order_Automation__c,false); //assert whether formual field is true
        
        Apttus_Proposal__Proposal__c propObj1=[select id,name,Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c where id=:newProposal.id];
        system.debug('Proposal :: '+propObj1);
        
        Product2 optionproduct = createProduct('OptionProduct2','TestApttus4','TestApttus3','TestApttus3','Option','Each',true,Date.today(),Date.today().addMonths(12),'Training & Consulting');
        Product2 bundleProduct = createProduct('BundleProduct1','TestApttus','TEST Apttus','TestApttus','Bundle','Each',true,Date.today(),Date.today().addMonths(12),'Software');
        system.assertNotEquals(optionproduct.Id,null);
        system.assertNotEquals(bundleProduct.Id,null);

        
        list<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = createProposalLineItem(newProposalWithAllDetails.Id, bundleProduct.Id, optionproduct.Id,priceList.Id);
        system.assertNotEquals(proposalLineItemList.size(),0);
        System.debug('#### : ' + newProposalWithAllDetails.RecordType.Name);
        System.debug('#### : ' + priceList.Name);
        insert proposalLineItemList;
        
        Apttus_Proposal__Proposal__c newProposalSAPBook = createProposal('', 'Standard+IP','','', '4001178291','123456', '12345', '','','','1234567891234567', '',newAccount.Id,newContact.Id, newOpportunity.Id, accountRef.Id, WK_Constants.EOI_QuoteRecordType_SAP_Books);
        newProposalSAPBook.Apttus_QPConfig__PriceListId__c = priceList.Id;
        newProposalSAPBook.SAP_Sales_Channel__c = 'Field Sales Rep';
        newProposalSAPBook.SAP_Contact_Channel__c = 'Field Sales Rep';
        insert newProposalSAPBook;
        Apttus_Proposal__Proposal__c newProposalSAPBookWithAllDetails = [SELECT Id, Name, Eligible_for_Order_Automation__c, RecordType.Name, ERP_Account__r.ApplicationID__c, ERP_Account__r.Application__c, SAP_Bill_To_Partner_Number__c, SAP_Ship_To_Partner_Number__c, ERP_Address_Override__c, ERP_Contact_Override__c, MA_Year_1_Start_Date__c, Apttus_Proposal__Account__r.Named_Account__c, Apttus_Proposal__Account__r.Market_Segment__c, Apttus_QPConfig__PriceListId__r.Name, MYA__c, ASA__c, WK_Stub_Year__c, SAP_IC_Trial_Account_Number__c, Shipping_Method__c, Shipping_Account__c  FROM Apttus_Proposal__Proposal__c WHERE Id =: newProposal.Id];
        system.assertNotEquals(newProposalSAPBook.Id,null);
        system.assertNotEquals(newProposalSAPBookWithAllDetails.Eligible_for_Order_Automation__c,false); //assert whether formual field is true
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        newProposalWithAllDetails.Apttus_Proposal__Approval_Stage__c = 'Submitted to COP';
        update newProposalWithAllDetails;
        
        newProposalSAPBookWithAllDetails.Apttus_Proposal__Approval_Stage__c = 'Submitted to COP';
        update newProposalSAPBookWithAllDetails;
        Test.stopTest();
    }
    
    public static Apttus_Proposal__Proposal__c createProposal(String accessLevel, String authenticationType,String billToCity,String billToCountry, String billToPartnerNo,string phoneNo, string billToZipCode, string billToState, String street1, string street2, string token, string cardType, Id accountId, Id contactId, Id opportunityId, Id accountRef, String recordType)
    {
        Apttus_Proposal__Proposal__c quoteProposal = new Apttus_Proposal__Proposal__c();
        quoteProposal.Access_Type__c = 'All - Link';
        //quoteProposal.Auto_Renewal_SO_Compliance__c = 'Opt-In (OBR)';
        quoteProposal.Auto_Renewal_SO_Compliance__c = WK_Constants.EOI_Not_Applicable_TC;
        quoteProposal.Conversion_Type__c = 'New';
        
        quoteProposal.Annual_Start_Date__c = Date.today().addDays(90).toStartOfMonth();
        quoteProposal.Aptps_Cyber_source_Token__c = '1234567892345678';
        quoteProposal.Credit_Card_Expiration__c = Date.today()+180;
        quoteProposal.Credit_Card_Type__c = 'Visa';
        quoteProposal.ERP_Account__c = accountRef;
        quoteProposal.Name_on_Card__c = 'testFName';
        quoteProposal.Number_of_Concurrent_Users__c = 1;
        quoteProposal.SAP_Payment_Terms__c = 'NET 60';
        quoteProposal.Apttus_Proposal__Primary_Contact__c =contactId;
        quoteProposal.Apttus_Proposal__Opportunity__c = opportunityId; 
        quoteProposal.Apttus_Proposal__Account__c = accountId;
        quoteProposal.Shipping_Method__c = 'Ground Parcel';
        quoteProposal.Stub_Start_Date__c = Date.Today();
        quoteProposal.WK_Stub_Year__c = true;
        quoteProposal.WK_Stub_Year_Start_Date__c = Date.Today();
        quoteProposal.WK_Stub_Year_End_Date__c = Date.Today().addDays(5);
        quoteProposal.Customer_Group__c = 'Commercial';
        quoteProposal.MYA__c = false;
        quoteProposal.Payment_Method__c = 'Credit Card';
        quoteProposal.Quote_Total__c= 237.3;
        quoteProposal.Credit_Card_Last_4__c = '1111';
        quoteProposal.SAP_Payment_Terms__c = 'NET 60';
        quoteProposal.Split_Commission__c = '20% selling rep/80% inventory rep';
        quoteProposal.RecordTypeId = ProposalRecordTypeInfo.get(RecordType).getRecordTypeId();
        quoteProposal.ASA__c = false;
        quoteProposal.SAP_IC_Trial_Account_Number__c = '';//'31345678';
        quoteProposal.New_Bill_To_Country__c = 'US';
        quoteProposal.New_Ship_To_City__c = 'US';
        quoteProposal.SAP_Drop_Shipment__c = false;
        quoteProposal.Approved_for_Order_Automation__c = true;
        quoteProposal.Quote_Total__c = 100;
        quoteProposal.Order_Type__c = 'SAP';
        quoteProposal.ERP_Address_Override__c = false;
        quoteProposal.ERP_Contact_Override__c = false;
        return quoteProposal;
    }
    
    public static Account createAccount()
    {
        Account acctObj = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco',
            Market_Segment__c = 'General Corporate',
            Named_Account__c = false,
            Named_Account_Type__c = 'Service Source');
            return acctObj;
    }
    
    public static Contact createContact(Id accId)
    {
        contact contact1 = new contact(LastName='Dest Contact', AccountId= accId,Email = 'test@test.com');//kalyan
        return contact1;
    }
     
    public static Opportunity createOpportunity(Id accId, Id contactId)
    {
        Opportunity OpptyObj=new Opportunity(name='CPQ Test Oppty',
                                  AccountId=accId,
                                  closedate=date.today()+30,
                                  stageName='5. Time to Buy',
                                  Primary_Contact_for_Proposal__c = contactId,
                                  Type = 'New to Existing',
                                  RecordTypeId = OpportunityRecordTypeInfo.get('New Sales Opportunity').getRecordTypeId());
        return OpptyObj;
        
    }
        
       public static list<Apttus_Proposal__Proposal_Line_Item__c> createProposalLineItem(Id proposalId,Id bundleProductId, Id optionalProductId, Id priceListId)
       {
        list<Apttus_Proposal__Proposal_Line_Item__c> PLIlist=new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c PLI=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalId,
                                                                                              Apttus_Proposal__Product__c=bundleProductId,
                                                                                              Apttus_QPConfig__LineType__c='Product/Service',
                                                                                              Apttus_QPConfig__PriceListId__c=priceListId,
                                                                                              Apttus_QPConfig__ListPrice__c=100,
                                                                                              Apttus_QPConfig__ChargeType__c='Subscription Fee', 
                                                                                               Apttus_QPConfig__PriceType__c='Recurring', 
                                                                                               Apttus_QPConfig__SellingTerm__c=1, 
                                                                                               Apttus_QPConfig__BasePrice__c=100, 
                                                                                               Apttus_QPConfig__AdjustmentType__c='', 
                                                                                               Apttus_QPConfig__AdjustmentAmount__c=100, 
                                                                                               Apttus_QPConfig__NetPrice__c=100, 
                                                                                               Apttus_QPConfig__AdjustedPrice__c=100, 
                                                                                               Apttus_QPConfig__BaseExtendedPrice__c=180, 
                                                                                               Apttus_QPConfig__ExtendedPrice__c=200, 
                                                                                               //Apttus_QPConfig__ClassificationId__c='', 
                                                                                               //Apttus_QPConfig__ClassificationHierarchy__c='', 
                                                                                               APTS_Year__c=1, 
                                                                                               Apttus_QPConfig__NetAdjustmentPercent__c=10                                                                                               
                                                                                               );
        PLIlist.add(PLI);
        Apttus_Proposal__Proposal_Line_Item__c PLI1=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalId,
                                                                                               Apttus_Proposal__Product__c=bundleProductId,
                                                                                               Apttus_QPConfig__OptionId__c=optionalProductId,
                                                                                               Apttus_QPConfig__LineType__c='Product/Service',
                                                                                               Apttus_QPConfig__PriceListId__c=priceListId,
                                                                                               Apttus_QPConfig__ListPrice__c=100,
                                                                                               //Apttus_QPConfig__LineType__c, 
                                                                                               //Apttus_QPConfig__PriceListId__c, 
                                                                                               //Apttus_QPConfig__ListPrice__c=100, 
                                                                                               Apttus_QPConfig__ChargeType__c='Subscription Fee', 
                                                                                               Apttus_QPConfig__PriceType__c='Recurring', 
                                                                                               Apttus_QPConfig__SellingTerm__c=1, 
                                                                                               Apttus_QPConfig__BasePrice__c=100, 
                                                                                               Apttus_QPConfig__AdjustmentType__c='', 
                                                                                               Apttus_QPConfig__AdjustmentAmount__c=100, 
                                                                                               Apttus_QPConfig__NetPrice__c=100, 
                                                                                               Apttus_QPConfig__AdjustedPrice__c=100, 
                                                                                               Apttus_QPConfig__BaseExtendedPrice__c=180, 
                                                                                               Apttus_QPConfig__ExtendedPrice__c=200, 
                                                                                               //Apttus_QPConfig__ClassificationId__c='', 
                                                                                               //Apttus_QPConfig__ClassificationHierarchy__c='', 
                                                                                               APTS_Year__c=1, 
                                                                                               Apttus_QPConfig__NetAdjustmentPercent__c=10                                                                                                
                                                                                               );
        PLIlist.add(PLI1);  
        Apttus_Proposal__Proposal_Line_Item__c PLI2=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalid
                                                                                      );
        PLIlist.add(PLI2);
        
        return PLIlist;
       }

       public static Apttus_Config2__PriceList__c createPriceList(String priceListName, string priceListDesc, Date effectiveDate, Date expirationDate) {
        
        Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(Name = 'R&L Price List', OwnerId = UserInfo.getUserId());
        priceListSO.Apttus_Config2__Description__c = priceListDesc;
        priceListSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        priceListSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        priceListSO.Apttus_Config2__Active__c = true;
        insert priceListSO;
        System.assert(priceListSO.Id != null, 'Failed to create the price list for owner ' + UserInfo.getUserId());
        return priceListSO;
        
    } 
        
    public static Product2 createProduct(String productName,String productCode,String productFamily,String productDesc,String configType,String unitOfMeasure,Boolean customizable, Date effectiveDate, Date expirationDate,string productline) {
        
        Product2 product = new Product2(Name=productName);
        product.ProductCode = productCode;
        product.Family = productFamily;
        product.Description = productDesc;
        product.Apttus_Config2__ConfigurationType__c = configType;
        product.Apttus_Config2__Uom__c = unitOfMeasure;
        product.Apttus_Config2__Customizable__c = customizable;
        product.Apttus_Config2__EffectiveDate__c = effectiveDate;
        product.Apttus_Config2__ExpirationDate__c = expirationDate;
        if(configType=='Option')
        product.AMS_Product_Category__c='Tax Consulting';
        product.Product_Line__c=productline;
        insert product;
        System.assert(product.Id != null, 'Failed to create the product for owner ' + UserInfo.getUserId());
        return product;
        
    } 
         
        
    public static void createCustomSettingForOrderAutomation()
    {
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
        insert orderCustomSetting;
    }
                
     public static Account_X_Reference__c createAccountXReference(Id AccountId)
     {
        Account_X_Reference__c accountReference = new Account_X_Reference__c(name='4001069962', Account__c=AccountId, ERP_Account_Name__c = 'myAcct', ApplicationID__c='4001069962');
        accountReference.Application__c = 'SAP';
        accountReference.Bill_To_Partner_Number__c = '4001303451';
        accountReference.Ship_To_Partner_Number__c = '4001303451';
        return accountReference;
     }
    /*SELECT Accept__c,Access_Type__c,Annual_End_Date__c,Annual_Start_Date__c,Approved_for_Order_Automation__c,ASA_Stub__c,ASA__c,Bill_To_City__c,Bill_To_Contact_Name__c,Bill_To_Country__c,Bill_To_Fax__c,Bill_To_Phone__c,Bill_To_State__c,Bill_To_Street_Line_1__c,Bill_To_Street_Line_2__c,Bill_To_Zip_Postal_Code__c,Credit_Card_Expiration__c,Credit_Card_Last_4__c,Credit_Card_Type__c,Customer_Group__c,Custom_Contract_Type__c,Cyber_Source_URL__c,Eligible_for_Order_Automation__c,ERP_Order_Status__c,ERP_Order__c,IC_Admin_Info_Updated__c,IC_Admin_Quote__c,IC_Contact_Email__c,IC_Contact_First_Name__c,IC_Contact_Last_Name__c,IC_Contact_Phone__c,Inventory_DTN__c,MYA_Uplift_Year_2__c,MYA_Uplift_Year_3__c,MYA__c,Name,Name_on_Card__c,New_Bill_To_Account_Name__c,New_Bill_To_City__c,New_Bill_To_Contact__c,New_Bill_To_Country__c,New_Bill_To_Phone__c,New_Bill_To_State__c,New_Bill_To_Street_1__c,New_Bill_To_Street_2__c,New_Bill_To_Zip_Postal_Code__c,New_IDs_Issued__c,New_IP_Prompt__c,New_Max_IDs_Allowed__c,Number_of_Concurrent_Users__c,Number_Of_Promotions__c,One_Line_Invoice_Header__c,Owner_DTN__c,Payment_Method__c,PromoCode__c,Quote_Total__c,RecordTypeId,Renewal_Discount__c,Rush_Order__c,SAP_Order_Type__c,SAP_Payment_Terms__c,Split_Commission__c,WK_Stub_Year__c FROM Apttus_Proposal__Proposal__c WHERE Id = 'a0wq0000001aZc1'



    */
}