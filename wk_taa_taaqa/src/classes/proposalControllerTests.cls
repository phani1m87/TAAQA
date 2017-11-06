@isTest
public class proposalControllerTests {

    public static testMethod void testRenewAsIsController() {
        
        Account acctObj = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acctObj;
        
        contact contact1 = new contact(LastName='Dest Contact', AccountId= acctObj.Id,Email = 'test@test.com');
        insert contact1;

        Opportunity OpptyObj=new Opportunity(name='CPQ Test Oppty',
                                  AccountId=acctObj.id,
                                  closedate=date.today()+30,
                                  stageName='5. Time to Buy',
                                  Primary_Contact_for_Proposal__c = contact1.Id);
        insert OpptyObj;
         
        
         system.assertNotEquals(contact1,null);                        
         Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c();
         priceList.name='Professional Software Price List';
         insert priceList;
         
         Apttus_Config2__PriceList__c priceList1=new Apttus_Config2__PriceList__c();
         priceList1.name='SAP Books';
         insert priceList1;
         
         Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c = 'myProposal', 
            Apttus_Proposal__Opportunity__c = OpptyObj.id, 
            Apttus_Proposal__Account__c = acctObj.Id,
            Apttus_Proposal__Primary__c = false,
            Aptps_Conversion_Contact__c=contact1.id,
            Aptps_Training_Contact__c=contact1.id,
            Apttus_QPConfig__ConfigurationFinalizedDate__c=null,
            Apttus_QPConfig__PriceListId__c=priceList.id);
          //  propObj.RecordType = [select Id,Name,SobjectType from RecordType where Name = 'SAP Books' and SobjectType = 'Apttus_Proposal__Proposal__c' limit 1];
        insert propObj; 
        
        
        Apttus_Proposal__Proposal__c propObj1 = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c = 'myProposal', 
            Apttus_Proposal__Opportunity__c = OpptyObj.id, 
            Apttus_Proposal__Account__c = acctObj.Id,
            Apttus_Proposal__Primary__c = false,
            Aptps_Conversion_Contact__c=contact1.id,
            Aptps_Training_Contact__c=contact1.id,
            Apttus_QPConfig__ConfigurationFinalizedDate__c=null,
            Apttus_QPConfig__PriceListId__c=priceList1.id);
          //  propObj.RecordType = [select Id,Name,SobjectType from RecordType where Name = 'SAP Books' and SobjectType = 'Apttus_Proposal__Proposal__c' limit 1];
        insert propObj1; 
         //RecordType rt=[select Id,Name from RecordType where id=:propObj.RecordTypeId And SobjectType = 'Apttus_Proposal__Proposal__c'];
        System.debug('milan test'+propObj.RecordType);
        test.startTest();
        
        PageReference pageRef = Page.renewalAsIs;
        Test.setCurrentPage(pageRef);
      
        updateProposalControllerForRenewAsIn controller = new updateProposalControllerForRenewAsIn(new ApexPages.StandardController(propObj));
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', propObj.id);
      
        Pagereference pg=controller.doSubmitToCOP();
        String cancelPage=controller.doCancel().getUrl();
        
        updateProposalControllerForRenewAsIn controller1 = new updateProposalControllerForRenewAsIn(new ApexPages.StandardController(propObj1));
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', propObj1.id);
      
        Pagereference pg1=controller1.doSubmitToCOP();
        
        PageReference pageReference = Page.proposalSubmitToCOPForAMS;
        Test.setCurrentPage(pageReference);
      
        SubmitToCOPForAMSController controllerForAMS = new SubmitToCOPForAMSController(new ApexPages.StandardController(propObj));
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', propObj.id);
      
        Pagereference pgForAMS=controllerForAMS.doSubmitToCOPForAMS();
        String cancelPage1=controllerForAMS.doCancel().getUrl();
        
        SubmitToCOPForAMSController controllerForAMS1 = new SubmitToCOPForAMSController(new ApexPages.StandardController(propObj1));
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', propObj1.id);
      
        Pagereference pgForAMS1=controllerForAMS1.doSubmitToCOPForAMS();
        
        
        
        test.stopTest();
    }
     public static testMethod void testSelectPromotionController() {
      
         Account acctObj = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acctObj;
        
        contact contact1 = new contact(LastName='Dest Contact', AccountId= acctObj.Id,Email = 'test@test.com');
        insert contact1;

        Opportunity OpptyObj=new Opportunity(name='CPQ Test Oppty',
                                  AccountId=acctObj.id,
                                  closedate=date.today()+30,
                                  stageName='5. Time to Buy',
                                  Primary_Contact_for_Proposal__c = contact1.Id);
        insert OpptyObj;
         
        
         system.assertNotEquals(contact1,null);                        
         Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c();
         priceList.name='Professional Software Price List';
         insert priceList;
         
         Apttus_Config2__PriceList__c priceList1=new Apttus_Config2__PriceList__c();
         priceList1.name='SAP Books';
         insert priceList1;
         
         Product2 productSO=new Product2(name='test product',Apttus_Config2__ConfigurationType__c='Standalone');
        insert productSO;
        
        Apttus_Config2__PriceListItem__c plitemSO = APTS_TestData.createPriceListItem(priceList1.id,productSO.Id,'Subscription','One time','one time',100,0,1000,'100',Date.Today(),Date.Today()+60,true);
       
         
        
        Apttus_Proposal__Proposal__c propObj1 = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c = 'myProposal', 
            Apttus_Proposal__Opportunity__c = OpptyObj.id, 
            Apttus_Proposal__Account__c = acctObj.Id,
            Apttus_Proposal__Primary__c = false,
            Aptps_Conversion_Contact__c=contact1.id,
            Aptps_Training_Contact__c=contact1.id,
            Apttus_QPConfig__ConfigurationFinalizedDate__c=null,
            Apttus_QPConfig__PriceListId__c=priceList1.id);
          //  propObj.RecordType = [select Id,Name,SobjectType from RecordType where Name = 'SAP Books' and SobjectType = 'Apttus_Proposal__Proposal__c' limit 1];
        insert propObj1;
        Apttus_Config2__TempObject__c tempObj=new Apttus_Config2__TempObject__c(); 
        insert tempObj;
        Apttus_Config2__ProductConfiguration__c configSO=APTS_TestData.createProductConfiguration('testname',1,propObj1.Id,'Proposal','test',priceList1.Id,null,'new',Datetime.Now(),Datetime.Now(),false,'test');
        
        Apttus_Config2__LineItem__c lineItemSo=APTS_TestData.createLineItem(configSO.Id,null,1,true,1,'Product/Service',productSO.Id,true,null,null,null,'test',1,true,'Year',1,priceList1.Id,plitemSO.Id,'one time','one time','Subscription fee','Yearly',true,true,100,100,'Flat Price',100,0,100,'test',1);
        
        Line_Item_Promotion__c promObj=new Line_Item_Promotion__c(Line_ItemId__c=lineItemSo.id,Promo_Code__c='test',Promo__c=10,Promo_Name__c='test');
        insert promObj;
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(name='System Properties',Apttus_Config2__ViewCartPage__c='apttus_config2__Cart');
        insert configSetting;
        
        
        
        Apttus_Config2__ProductConfiguration__c configSO1=APTS_TestData.createProductConfiguration('testname1',1,propObj1.Id,'Proposal','test',priceList1.Id,null,'new',Datetime.Now(),Datetime.Now(),false,'test');
        
        Apttus_Config2__LineItem__c lineItemSo1=APTS_TestData.createLineItem(configSO1.Id,null,1,true,1,'Product/Service',productSO.Id,true,null,null,null,'test',1,true,'Year',1,priceList1.Id,plitemSO.Id,'one time','one time','Subscription fee','Yearly',true,true,100,100,'Flat Price',100,0,100,'test',1);
        
        Line_Item_Promotion__c promObj1=new Line_Item_Promotion__c(Line_ItemId__c=lineItemSo1.id,Promo_Code__c='test',Promo__c=10,Promo_Name__c='test');
        insert promObj1;
        
        Apttus_Config2__LineItem__c lineItemSo2=new Apttus_Config2__LineItem__c(Apttus_Config2__ItemSequence__c=2,Apttus_Config2__DerivedFromId__c=lineItemSo1.id,Apttus_Config2__LineNumber__c=2,Apttus_Config2__ConfigurationId__c=configSO1.Id);
        insert lineItemSo2;
        
        
        test.startTest();
        PageReference pageRef = Page.selectPromotion;
        Test.setCurrentPage(pageRef);
        
        List<Apttus_Config2__LineItem__c> LineItemList=new List<Apttus_Config2__LineItem__c>();
        LineItemList.add(lineItemSo1);
        selectPromotionController controller = new selectPromotionController(new ApexPages.StandardController(lineItemSo));
        controller.promoName='NONE';
        controller.LineItemListToUpdate=LineItemList;
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', lineItemSo.id);
      
        Pagereference pg=controller.applyPromo();
        String cancelPage=controller.Cancel().getUrl();
        
        selectPromotionController controller1 = new selectPromotionController(new ApexPages.StandardController(lineItemSo));
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', lineItemSo.id);
      
        Pagereference pg1=controller1.applyPromo();
        String cancelPage1=controller1.Cancel().getUrl();
        
        lineItemSo1.Apttus_Config2__HasOptions__c=true;
        update lineItemSo1;
       
        
        selectPromotionController controller2 = new selectPromotionController(new ApexPages.StandardController(lineItemSo1));
        controller2.promoName='test';
        controller2.promoCode='test';
        controller2.promoPercent=20;
        
        controller2.LineItemListToUpdate=LineItemList;
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', lineItemSo1.id);
      
        Pagereference pg3=controller2.applyPromo();
     }
     
     public static testMethod void testPromoHelper() {
         
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
                                                                
        Apttus_Config2__LineItem__c lineItemSOCopy = APTS_TestData.createLineItem(configSO.Id,//configId
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
     
         List<Apttus_Config2__LineItem__c> lineItemList=new List<Apttus_Config2__LineItem__c>();
         lineItemSO.APTS_Promo_Code__c='testtt';
         update lineItemSO;
         lineItemList.add(lineItemSO);
         lineItemList.add(lineItemSO1);
         lineItemList.add(lineItemSO2);
         test.startTest();
         
         APTS_Pricing_Helper.applyPromoCodes(proposalSO,lineItemList);
         
         lineItemSO.Apttus_Config2__LineStatus__c='Renewed';
         lineItemSOCopy.Apttus_Config2__LineStatus__c='Cancelled';
         update lineItemSO;
         update lineItemSOCopy;
         
         PageReference pageRef = Page.APTS_GoToPricing_Renewal;
        Test.setCurrentPage(pageRef);
        
        APTS_GoToPricing_Renewal_Ctlr controller = new APTS_GoToPricing_Renewal_Ctlr(new ApexPages.StandardController(configSO));
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', configSO.id);
      
        Pagereference pg=controller.doRedirect();
         
         test.stopTest();
     }
}