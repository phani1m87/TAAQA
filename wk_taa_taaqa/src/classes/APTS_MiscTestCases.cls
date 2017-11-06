@istest
public with sharing class APTS_MiscTestCases {
	
	static testMethod void opportunityLineItemTriggerTest()
	{
		Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        contact ct= new contact(firstname='test',LastName='test',email='test@domain.com', phone='1234567890');
        insert ct;
        //opp = [Select id,StageName from Opportunity where id =:opp.id];
        //Pricebook2  standardBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        //opp.PriceBook2Id=standardBook.id;
        //update opp;
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'Test',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
         Product2 productSO2 = APTS_TestData.createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'Books',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));                                  
       
         Product2 productSO3 = APTS_TestData.createProduct('OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Software',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = APTS_TestData.createProduct('OptionProduct2',
                                            'TestApttus4',
                                            'TestApttus3',
                                            'Test',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = APTS_TestData.createProduct('StandAlone1',
                                            'TestAPttus5',
                                            'TestApttus2',
                                            'Books',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = APTS_TestData.createProduct('standAlone2',
                                            'TestApttus6',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
                                            list<PricebookEntry> pbe=new list<PricebookEntry>();
                                  
list<OpportunityLineItem> opProductList=new list<OpportunityLineItem>();
OpportunityLineItem opli1=APTS_TestData.createOpportunityLineItem(opp.id,'Product/Service',Test.getStandardPricebookId(),productSO.id);
OpportunityLineItem opli2=APTS_TestData.createOpportunityLineItem(opp.id,'Product/Service',Test.getStandardPricebookId(),productSO5.id); 
//OpportunityLineItemHelper.opportunityLineItemTriggerMap.put('beforeinsert',false);                            
OpportunityLineItem opli3=APTS_TestData.createOpportunityLineItem(opp.id,'Option',Test.getStandardPricebookId(),productSO3.id);
OpportunityLineItem opli4=APTS_TestData.createOpportunityLineItem(opp.id,'Option',Test.getStandardPricebookId(),productSO4.id);
OpportunityLineItem opli5=APTS_TestData.createOpportunityLineItem(opp.id,'Product/Service',Test.getStandardPricebookId(),productSO2.id);

opProductList.add(opli1);
opProductList.add(opli2);
opProductList.add(opli3);
opProductList.add(opli4);
//opProductList.add(opli5);
insert opProductList;
   

                                            
	 
	}
	
		//static testMethod void proposalTriggerTest() 
	//{}
	
	static testMethod void proposalTriggerTest()
	{
	 Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        
        contact contact1=new contact(firstname='Test01',LastName='Test01',Phone='8008008000',Email='test@test1.com');
        insert contact1;
                                 
                                 
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1',
                                           'BundleProduct1',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
                                           
       
         Product2 productSO3 = APTS_TestData.createProduct('OptionProduct1',
                                            'OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = APTS_TestData.createProduct('OptionProduct2',
                                            'OptionProduct2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = APTS_TestData.createProduct('StandAlone1',
                                            'StandAlone1',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = APTS_TestData.createProduct('standAlone2',
                                            'standAlone2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
                                            
       
        //2nd bundle
        Product2 productSO7 = APTS_TestData.createProduct('BundleProduct2',
                                           'BundleProduct2',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12)); 
        RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
         Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
                                                                   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
                                                                        
        
        Apttus_Config2__PriceListItem__c plItemSO2 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO3.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
        Apttus_Config2__PriceListItem__c plItemSO3 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO4.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);                                                                
        Apttus_Config2__PriceListItem__c plItemSO4 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO5.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
                                                                        
        Apttus_Config2__PriceListItem__c plItemSO5 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO6.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                       1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);   
         Apttus_Config2__PriceListItem__c plItemSO6 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO6.Id,
                                                                        'One Time Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true); 
          
          string userRole = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId()].Name;
       
       Price_List_Defaulting__c pld=new Price_List_Defaulting__c(Name='TestCustomSetting',
                                                                 Price_List_ID__c=string.valueOf(priceListSO.id),
                                                                 Price_List_Name__c=pricelistSO.name ,
       															 Quote_Header_Record_Type__c=rt.name,
       															 Role__c=userRole
       );
       
       insert pld;
          Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id); 
        
        
         APTS_Payment_Term_Detail__c ptd=new APTS_Payment_Term_Detail__c (APTS_Payment_Term__c='Full Pay',
                                                                       APTS_Quote_Proposal__c=proposalSO.id); 
         
         proposalSO.Apttus_QPConfig__PriceListId__c=priceListSO.Id;
         proposalSO.Order_Type__c = 'SAP';
         proposalSO.SAP_Payment_Terms__c= 'Flex Pay';
         update proposalSO;
         
        
       
           
         APTS_TestData.createPromotions(priceListSO.id,proposalSO.id, productSO); 
         list<Quote_Promotion__c> quotePromotions=[select id,name,Quote_Proposal__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id ];
         system.assert(quotePromotions.size()>0);
        //* create configuration object and config line items
        
         Apttus_Config2__ProductConfiguration__c configSO = APTS_TestData.createProductConfiguration('Pricing Callback Test',
                                                                                      1,
                                                                                      proposalSO.Id,
                                                                                      'Proposal',
                                                                                      'Ad Hoc',
                                                                                      priceListSO.Id,//proposalSO.Apttus_QPConfig__PriceListId__c,
                                                                                      null,
                                                                                      'Finalized',
                                                                                      null,
                                                                                      Datetime.now(),
                                                                                      true,
                                                                                      'Pricing Callback Test');
                                                                                      
                                                                                      
         Apttus_Config2__LineItem__c lineItemSO = APTS_TestData.createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                null,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO.Id,//price list item
                                                                'One Time',//price type
                                                                'Per Unit',// price method
                                                                'Subscription Fee', // charge type
                                                                null,//frequency
                                                                true,//allow manual adj
                                                                true,//allocate group adj
                                                                9485,//listprice
                                                                9485,//baseprice
                                                                'Per Unit',//baserpricemethod
                                                                9485,//optionprice
                                                                null,//extprice
                                                                9485,
                                                                'TestaPTTUS',
                                                                1);
        
        // attach the totaling group
        //lineItemSO.Apttus_Config2__AdHocGroupId__c = adGroupSO.Id;
        //lineItemSO.Apttus_Config2__OptionId__c=productSO6.Id;
        
         Apttus_Config2__LineItem__c lineItemSO1 = APTS_TestData.createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Option',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                null,//prodOptComp_pso3.id,//productOptionId
                                                                productSO3.Id,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO2.Id,//price list item
                                                                'Recurring',//price type
                                                                'Per Unit',// price method
                                                               null,// 'Subscription Fee', // charge type
                                                                null,//frequency
                                                                true,//allow manual adj
                                                                true,//allocate group adj
                                                                9485,//listprice
                                                                9485,//baseprice
                                                                'Per Unit',//baserpricemethod
                                                                9485,//optionprice
                                                                null,//extprice
                                                                9485,
                                                                'TestaPTTUS',
                                                                2);
         Apttus_Config2__LineItem__c lineItemSO2 = APTS_TestData.createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                2,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO6.Id,//product Id
                                                                true,//boolean customizable
                                                                null,//prodOptComp_pso6.id,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO6.Id,//price list item
                                                                'Recurring',//price type
                                                                'Per Unit',// price method
                                                               null,// 'Subscription Fee', // charge type
                                                                null,//frequency
                                                                true,//allow manual adj
                                                                true,//allocate group adj
                                                                9485,//listprice
                                                                9485,//baseprice
                                                                'Per Unit',//baserpricemethod
                                                                9485,//optionprice
                                                                null,//extprice
                                                                9485,
                                                                'TestaPTTUS',
                                                                2);
                                                                                                                                               
       
        
        
        //* Create the proposal Line Items
         list<Apttus_Proposal__Proposal_Line_Item__c> proposalLinesList=new list<Apttus_Proposal__Proposal_Line_Item__c>();
         
         
         Apttus_Proposal__Proposal_Line_Item__c PLI=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO.id,
                                                                                            null,
                                                                                            pricelistSO.id,
                                                                                           'Product/Service',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );    
         Apttus_Proposal__Proposal_Line_Item__c PLI1=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO.id,
                                                                                            ProductSO3.id,
                                                                                            pricelistSO.id,
                                                                                           'Option',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );
                                                                                           
        Apttus_Proposal__Proposal_Line_Item__c PLI2=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO.id,
                                                                                            ProductSO4.id,
                                                                                            pricelistSO.id,
                                                                                           'Option',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );
        Apttus_Proposal__Proposal_Line_Item__c PLI3=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO5.id,
                                                                                            null,
                                                                                            pricelistSO.id,
                                                                                           'Product/Service',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );  
       Apttus_Proposal__Proposal_Line_Item__c PLI4=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO6.id,
                                                                                            null,
                                                                                            pricelistSO.id,
                                                                                           'Product/Service',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );
       
      
      
      
      Apttus_Proposal__Proposal_Line_Item__c PLI5=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO.id,
                                                                                            ProductSO3.id,
                                                                                            pricelistSO.id,
                                                                                           'Option',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            ); 
                                                                                            
      Apttus_Proposal__Proposal_Line_Item__c PLI6=   APTS_TestData.createProposalLineItem(proposalSO.id,
                                                                                            null,//ConfigSO.id,
                                                                                            ProductSO.id,
                                                                                            ProductSO4.id,
                                                                                            pricelistSO.id,
                                                                                           'Option',
                                                                                            //4,
                                                                                            false//Perform DML
                                                                                            );                                                                                                                                                                    
                                                                                                                                                                                     
         proposalLinesList.add(PLI);                                                                                                                                                                                                                                                                                                                                               
         proposalLinesList.add(PLI1);  
         proposalLinesList.add(PLI2);
         proposalLinesList.add(PLI3);  
         proposalLinesList.add(PLI4);
         proposalLinesList.add(PLI5);  
         proposalLinesList.add(PLI6);
         
         insert proposalLinesList;
         
         APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
         APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
         proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today();
         
         proposalSO.Stubs_Year_Quote__c=true;        
         proposalSO.Stub_Start_Date__c=date.today().addYears(-1); 
         proposalSO.Stub_End_Date__c=date.today().addYears(1);
         proposalSO.Annual_Start_Date__c=proposalSO.Stub_End_Date__c.addDays(10);
         proposalSO.MYA__c =false;
         proposalSO.AMS_MYA_Platform__c =null;
         proposalSO.MYA_Term_New__c=null;
         proposalSO.MYA_Uplift_Year_2__c=null;
         proposalSO.MYA_Uplift_Year_3__c=null;
         proposalSO.MYA_Uplift_Year_4__c=null;
         proposalSO.MYA_Uplift_Year_5__c=null;
         proposalSO.Order_Type__c = 'SAP';
         proposalSO.SAP_Payment_Terms__c= 'NET 30';
         update proposalSO;
         
         Test.startTest();
         list<Quote_Promotion__c> quotePromotions1=[select id,name,Quote_Proposal__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id ];
         proposalSO.APTS_Enforce_Repricing__c=false;
         update proposalSO;
         
         system.assert(quotePromotions1.size()>0);
         
         APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
         APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
         proposalSO.APTS_Enforce_Repricing__c=true;
         update proposalSO;
         
               // List<Apttus_Config2__ProductConfiguration__c> productConfigList = [Select Apttus_QPConfig__Proposald__c, 
	           // (Select Apttus_Config2__PricingStatus__c, Apttus_Config2__OptionId__c, Apttus_Config2__ProductId__c, APTS_Promo_Code__c, 
	           // APTPS_PromoDiscountApplied__c, APTS_Needs_Repricing__c, Apttus_Config2__LineNumber__c From Apttus_Config2__LineItems__r) 
	           // From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN :proposalIdSet AND 
	           // Apttus_Config2__Status__c NOT IN ('New', 'Superseded', 'Abandoned')];
	            
	            //system.assert(productConfigList.size()>0);
         //delete quotePromotions1;
         //list<Quote_Promotion__c> quotePromotions2=[select id,name,Quote_Proposal__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id ];
         //system.assertEquals(quotePromotions2.size(),0);
         
         //proposalSO.APTS_Enforce_Repricing__c=true;
         //update proposalSO;
         apttus_proposal__proposal__c qproposal=[select id, name ,APTS_Enforce_Repricing__c from apttus_proposal__proposal__c where id=:proposalSO.id];
         //system.assert(qproposal.APTS_Enforce_Repricing__c);
         
         
         Test.stopTest();
         
                                                                                                                                                                                                                                            
	}
	
	static TestMethod void testPaymentTermDetail()
	{
	 
       
        Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        
       
       
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1', 
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
       
       
       
       RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
       system.assert(rt!=null);
       Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List',  
                                                                  'Professional Software Price List', 
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
         
          
                                                                     
         Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id); 
                                                                        
         
         																		                                                               
       APTS_Payment_Term_Detail__c  paymentTermDetail=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='Full Pay');
       
       try{
       insert paymentTermDetail;
       }
       catch(Exception Ex)
       {
        
       }
       
       paymentTermDetail.Final_Installment_Amount_2__c=120;
       try{
       update paymentTermDetail;
       }
       catch(exception ex){
       
       }
       
       
        
         
    
	
	}
	static TestMethod void testPaymentTermDetaildelete()
	{
	 
       
        Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        
       
       
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1', 
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
       
       
       
       RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
       system.assert(rt!=null);
       Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List',  
                                                                  'Professional Software Price List', 
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
         
          
                                                                     
         Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id); 
                                                                        
         
         																		                                                               
       APTS_Payment_Term_Detail__c  paymentTermDetail=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='Net 30');
       
       
       insert paymentTermDetail;
       try{}
       catch(Exception Ex)
       {
        
       }
       
       APTS_Payment_Term_Detail__c  paymentTermDetail1=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='Net 30');
        insert paymentTermDetail1;
        
        APTS_Payment_Term_Detail__c  paymentTermDetail2=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='Flex Pay');
        insert paymentTermDetail2;
        
        APTS_Payment_Term_Detail__c  paymentTermDetail3=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='IPP 4');
        insert paymentTermDetail3;
        
        APTS_Payment_Term_Detail__c  paymentTermDetail4=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='IPP 6');
        insert paymentTermDetail4;
        
        APTS_Payment_Term_Detail__c  paymentTermDetail5=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=100,
                                                                                      APTS_Initial_Deposit_Date__c=date.today(),
                                                                                      APTS_Payment_Term__c ='IPP 12');
        insert paymentTermDetail5;
        
        delete paymentTermDetail1;
        delete paymentTermDetail2;
        delete paymentTermDetail3;
        delete paymentTermDetail4;
        delete paymentTermDetail5;
        
        
         proposalSO.Order_Type__c ='SAP';
        update proposalSO;
         
         APTS_Payment_Term_Detail__c  paymentTermDetail6=new APTS_Payment_Term_Detail__c(APTS_Quote_Proposal__c=proposalSO.id,
                                                                                      Final_Installment_Amount_2__c=100,
                                                                                      APTS_Initial_Deposit__c=null,
                                                                                      APTS_Initial_Deposit_Date__c=null,
                                                                                      APTS_Payment_Term__c ='IPP 12');
                                                                                      
        insert paymentTermDetail6;
        update paymentTermDetail6;
        
        
        
        
        //delete paymentTermDetail6;
       //paymentTermDetail.Final_Installment_Amount_2__c=120;
       /*try{
       update paymentTermDetail;
       }
       catch(exception ex){
       
       }*/
       
       
        
         
    
	
	}
	static testMethod void oppPrimayrContactTest()
  {
       
        
        

        Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer', BillingStreet = 'test street', BillingCity = 'test city', 
                                BillingState='test state', BillingCountry='countrytest', BillingPostalCode='123451', Phone='1234567890' );
        insert acc;

        contact ct = new contact(LastName='Dest Contact', AccountId= acc.Id,Email = 'test@test.com');//kalyan
        insert ct;

        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='5. Time to Buy', 
                                          //Competitors__c = '**None**', 
                                          pricebook2Id=test.getStandardPricebookId(),
                                          CloseDate = Date.today().addYears(1),
                                           Primary_Contact_for_Proposal__c = ct.Id); 
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
        Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
        
        
        /*Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,acc.Id,

                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        rt.id);  */
        Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id);                                                                
                                                                        
         contact cont=new contact(FirstName='test',lastname='apttus', email='test@apttus.com',phone='000 000 0000',accountId=acc.id);  
         insert cont;  
         OpportunityContactRole oppCtrole=new OpportunityContactRole(ContactId=cont.id,IsPrimary=true,OpportunityId=opp.id,Role='Business User');  
         insert oppCtrole;                                              
         Test.startTest();
         Test.setCurrentPage(page.NewPromotionForProposal);
         //apexpages.currentpage().getParameters().get();
         ApexPages.StandardController apsc= new ApexPages.StandardController(opp);
         oppContactRoleHelper ocrh=new oppContactRoleHelper(apsc);
         ocrh.rollupOppContacts();
         Test.stopTest();
  }
  static testMethod void newQuotePromoTest()
  {
  Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer', BillingStreet = 'test street', BillingCity = 'test city', 
                                BillingState='test state', BillingCountry='countrytest', BillingPostalCode='123451', Phone='1234567890' );
        insert acc;

        contact ct = new contact(LastName='Dest Contact', AccountId= acc.Id,Email = 'test@test.com');//kalyan
        insert ct;

        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='5. Time to Buy', 
                                          //Competitors__c = '**None**', 
                                          pricebook2Id=test.getStandardPricebookId(),
                                          CloseDate = Date.today().addYears(1),
                                           Primary_Contact_for_Proposal__c = ct.Id); 
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
        Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
        
        
        /*Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,acc.Id,

                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        rt.id);  */
        Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id);     
         Test.startTest();
         Test.setCurrentPage(page.NewPromotionForProposal);
         apexpages.currentpage().getParameters().put('proposalId',proposalSO.id);
         editNewQuotePromo newQuotepromoctrl= new editNewQuotePromo();
         newQuotepromoctrl.initiator();
         Test.stopTest();
         
                                                                                                                                
       
  }
  static testMethod void docuSignTriggerTest()
    {
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        
        contact contact1=new contact(firstname='Test01',LastName='Test01',Phone='8008008000',Email='test@test1.com');
        insert contact1;
                                 
                                 
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1',
                                           'BundleProduct1',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
                                           
       
         Product2 productSO3 = APTS_TestData.createProduct('OptionProduct1',
                                            'OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
           
         RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
         Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
                                                                   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
                                                                        
        
        Apttus_Config2__PriceListItem__c plItemSO2 = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                         productSO3.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        1685,
                                                                        1500,
                                                                        1800,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
       
                                     
         Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id); 

        //system.assertNotEquals(propObj1.Apttus_QPConfig__PriceListId__c,null);
        
        list<Apttus_Proposal__Proposal_Line_Item__c> PLIlist=new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c PLI=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalSO.id,
                                                                                              Apttus_Proposal__Product__c=productSO.id,
                                                                                              Apttus_QPConfig__LineType__c='Product/Service',
                                                                                              Apttus_QPConfig__PriceListId__c=proposalSO.Apttus_QPConfig__PriceListId__c,
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
        Apttus_Proposal__Proposal_Line_Item__c PLI1=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalSO.id,
                                                                                               Apttus_Proposal__Product__c=productSO.id,
                                                                                               Apttus_QPConfig__OptionId__c=productSO3.id,
                                                                                               Apttus_QPConfig__LineType__c='Option',
                                                                                               Apttus_QPConfig__PriceListId__c=proposalSO.Apttus_QPConfig__PriceListId__c,
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
        Apttus_Proposal__Proposal_Line_Item__c PLI2=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalSO.id
                                                                                      );
        PLIlist.add(PLI2);
        
        insert PLIlist;
        
        Test.startTest();
        Apttus_DocuApi__DocuSignEnvelope__c mydocuSignEnv=new Apttus_DocuApi__DocuSignEnvelope__c(name='test',
                                                                                                  Apttus_QPDSign__QuoteProposal__c=proposalSO.id,
                                                                                                  //Name, 
                                                                                                  Apttus_DocuApi__DocumentName__c='test', 
                                                                                                  Apttus_DocuApi__DocumentUploadStatus__c=false, 
                                                                                                  Apttus_DocuApi__DocumentUploadStatusMessage__c='test', 
                                                                                                  Apttus_DocuApi__EmailSubject__c='test', 
                                                                                                  Apttus_DocuApi__ParentId__c=proposalSO.id, 
                                                                                                  Apttus_DocuApi__Status__c='Sent', 
                                                                                                  Apttus_DocuApi__EnvelopeId__c='test', 
                                                                                                  Apttus_DocuApi__EnvelopeContent__c='test', 
                                                                                                  Apttus_DocuApi__NumberOfDocuments__c=1
                                                                                                  );
        insert mydocuSignEnv;
        
        mydocuSignEnv.Apttus_DocuApi__DocumentName__c='test1';
        update mydocuSignEnv;
        
        Test.stopTest();
    
    }
    
    
    
    static testMethod void APTSsubmitToCOPTest()
    {
     
       
        Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        
       
       
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1', 
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
       
       
       
       RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
       system.assert(rt!=null);
       Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List',  
                                                                  'Professional Software Price List', 
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
         
          
                                                                     
         Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id);                                                             
                                                                                       
     Test.setCurrentPage(page.proposalSubmitToCOP);
     Apexpages.currentpage().getParameters().put('id',proposalSO.id);
     Test.startTest();
     Apexpages.standardController proposalStdController=new Apexpages.standardController(proposalSO);
     updateProposalController upc=new updateProposalController(proposalStdController);
     upc.doCancel();
     upc.doSubmitToCOP();
     Test.stopTest();
     
    }
    
    static testMethod void APTSquotePromoCancelInterceptor()
    {
      
       
        Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        
       
       
        Product2 productSO = APTS_TestData.createProduct('BundleProduct1', 
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
       
       
       
       RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
       
       system.assert(rt!=null);
       Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList('Professional Software Price List',  
                                                                  'Professional Software Price List', 
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = APTS_TestData.createPriceListItem(priceListSO.Id,
                                                                        productSO.Id,
                                                                        'Subscription Fee', 
                                                                        'Recurring',
                                                                        'Per Unit',
                                                                        9485,
                                                                        9000,
                                                                        10000,
                                                                        'Unit Price',
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12),
                                                                        true);
         
          
                                                                     
         Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        Rt.id); 
         APTS_TestData.createPromotions(priceListSO.id,proposalSO.id, productSO); 
         list<Quote_Promotion__c> quotePromotions=[select id,name,Quote_Proposal__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id ];
         system.assertNotEquals(quotePromotions,Null); 
         system.assert(quotePromotions.size()>0); 
                                                                                                                                   
     Test.setCurrentPage(page.Aptps_QuotePromotionCancelInterceptor);
     Apexpages.currentpage().getParameters().put('RollBackId',quotePromotions[0].id);
     Apexpages.currentpage().getParameters().put('proposalId',proposalSO.id);
     Apexpages.currentpage().getParameters().put('QuotePromotionId',quotePromotions[0].id);
     
     Apexpages.standardController proposalController=new Apexpages.standardController(proposalSO);
     
     editNewQuotePromo newQuotePromoController= new editNewQuotePromo();
     newQuotePromoController.doOK();
     newQuotePromoController.doCancel();
     /*
     cancelURL=%2Fapex%2FAptps_QuotePromotionCancelInterceptor%3FRollBackId%3Da2de0000000TofLAAS%26proposalId%3Da0ve0000005OSjpAAG%26QuotePromotionId%3Da2de0000000TofLAAS
     
     */
     
    }
  
	
	

}