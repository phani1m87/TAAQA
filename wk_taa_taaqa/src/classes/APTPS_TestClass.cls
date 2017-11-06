@istest(seealldata=true)
/*
 Author: Venkata Sabbella
 Last Modified: 01/09/2015
 Assumptions:
 
 Pricerule entries should be created as part of CPQ master data.
 price rule sets  should be created with the names of promotions used in the testclass
 i.e; promo1 and promo2
 
 price dimension should also be created
 
 option group category should be created XXX query at line 419 while creating product option group
 
 fixed: test class failing if dates are entered

*/


public with sharing class APTPS_TestClass {
    
    private static final String LINE_STATUS_AMENDED = 'Amended';
    private static final String BILL_TO_ACCOUNT_TYPE_BILL_TO_ACCOUNT = 'Bill To Account';
    private static final String BILL_TO_ACCOUNT_TYPE_OTHER = 'Other';
    private static final String AMEND_ACTION = 'Amend';
    private static final String CANCEL_ACTION = 'Cancel';
    private static final String LINE_TYPE_PRODUCT_SERVICE = 'Product/Service';
    private static final String LINE_TYPE_OPTION = 'Option';
    private static final String LINE_STATUS_NEW = 'New';
    private static final String PRICE_TYPE_RECURRING = 'Recurring';
    private static final String CHARGE_TYPE_OVERAGE = 'Overage';
    private static final String CHARGE_TYPE_INCLUDED_UNITS = 'Included Units';
    private static final String CHARGE_TYPE_COMMIT = 'Commit';
    private static final String CHARGE_TYPE_INCLUDED = 'Included';
    private static final String  LINE_STATUS_CANCELLED = 'Cancelled';
    /**
     * Tests the pricing callback    */
    /*static testmethod void test1() {
        
        APTPS_TestClass testObject = new APTPS_TestClass();
        
        // test the callback 
        testObject.testCallback1(); 
       
        
    }*
    
    /**
     * Test the callback 
     */
    
     private static testMethod void testValidationCallBack()
    {
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'BundleProduct1',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'OptionProduct2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = createProduct('StandAlone1',
                                            'StandAlone1',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = createProduct('standAlone1',
                                            'standAlone1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
          Apttus_Config2__ProductOptionGroup__c prodOptionGrp=new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__Sequence__c=0,
                                                                                                        Apttus_Config2__MinOptions__c=0,
                                                                                                        Apttus_Config2__MaxOptions__c=100,
                                                                                                        Apttus_Config2__ProductId__c=productSO.id,
                                                                                                        Apttus_Config2__OptionGroupId__c=[select id from Apttus_Config2__ClassificationHierarchy__c 
                                                                                                                                          where Apttus_Config2__HierarchyId__r.Apttus_Config2__Type__c='Option Group' limit 1].id 
                                                                                                        
                                                                                                        );    
         insert   prodOptionGrp;
         
        Apttus_Config2__ProductOptionComponent__c prodOptComp_pso3= CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO3.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                       'Option',//string relationshipType
                                                                                       1
                                                                                       );
                                
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso4=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO4.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                       'Option',//string relationshipType
                                                                                        2);
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso5=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO5.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                        'Option',//string relationshipType
                                                                                        3);
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso6=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO6.id,//Id OptionId,
                                                                                      productSO.id,//Id parentProductId,
                                                                                      'Option',//string relationshipType
                                                                                      4);                                                                                                                                                                             
         // STEP II - Create a new price list
        Apttus_Config2__PriceList__c priceListSO = createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
                                                                   
         Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false);
                                                                        
         Apttus_Proposal__Proposal__c queiredproposalSo =[select id,Apttus_QPConfig__PriceListId__c 
                                                          from 
                                                          Apttus_Proposal__Proposal__c where id=:proposalSO.id];
                                                                                   
        system.assertNotEquals(queiredproposalSo,null);   
        system.assertNotEquals(queiredproposalSo.Apttus_QPConfig__PriceListId__c,null);   
        
        Id priceListid=queiredproposalSo.Apttus_QPConfig__PriceListId__c;                                                          
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = createPriceListItem(priceListid,
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
                                                                        
        
        Apttus_Config2__PriceListItem__c plItemSO2 = createPriceListItem(priceListid,
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
        Apttus_Config2__PriceListItem__c plItemSO3 = createPriceListItem(priceListid,
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
          //plItemSO3.Apttus_Config2__Active__c=true;
          //update  plItemSO3;                                                                                                                                     
        Apttus_Config2__PriceListItem__c plItemSO4 = createPriceListItem(priceListid,
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
                                                                        
        Apttus_Config2__PriceListItem__c plItemSO5 = createPriceListItem(priceListid,
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
         Apttus_Config2__PriceListItem__c plItemSO6 = createPriceListItem(priceListid,
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
                                                                        true
                                                                        ); 
                                                                        
          //plItemSO6.Apttus_Config2__Active__c=true;
          //update  plItemSO6;                                                                                                                            
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
        
        createPromotions(priceListid,proposalSO.id,productSO);     
        
         // STEP V - create a new configuration object
        Apttus_Config2__ProductConfiguration__c configSO = createProductConfiguration('Pricing Callback Test',
                                                                                      1,
                                                                                      proposalSO.Id,
                                                                                      'Proposal',
                                                                                      'Ad Hoc',
                                                                                      proposalSO.Apttus_QPConfig__PriceListId__c,
                                                                                      null,
                                                                                      'Finalized',
                                                                                      null,
                                                                                      Datetime.now(),
                                                                                      true,
                                                                                      'Pricing Callback Test');
       
        // STEP VI - Create new ad hoc groups
        Apttus_Config2__AdHocGroup__c adGroupSO = createAdHocGroup('Group A',
                                                                   configSO.Id,
                                                                   'Group A');  
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
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
                                                                priceListid,//pricelistId
                                                                plItemSO.Id,//price list item
                                                                'Recurring',//price type
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
        
         Apttus_Config2__LineItem__c lineItemSO1 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Option',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.Id,//productOptionId
                                                                productSO3.Id,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListid,//pricelistId
                                                                plItemSO2.Id,//price list item
                                                                'Recurring',//price type
                                                                'Per Unit',// price method
                                                                null, // charge type
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
         Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso4.Id,//productOptionId
                                                                productSO4.Id,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListid,//pricelistId
                                                                plItemSO3.Id,//price list item
                                                                'Recurring',//price type
                                                                'Per Unit',// price method
                                                                null, // charge type
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
                                                                3);
       //chargetype=null;
       Apttus_Config2__LineItem__c lineItemSO21 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso4.Id,//productOptionId
                                                                productSO4.Id,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListid,//pricelistId
                                                                plItemSO3.Id,//price list item
                                                                'Recurring',//price type
                                                                'Per Unit',// price method
                                                                null, // charge type
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
                                                                3);   
                                                                
      //temp renew
        list<Apttus_Config2__TempRenew__c> tempRenewList = new list<Apttus_Config2__TempRenew__c>();
        Apttus_Config2__TempRenew__c tempRenew1 = new Apttus_Config2__TempRenew__c(Apttus_Config2__ActionName__c = AMEND_ACTION, Apttus_Config2__Quantity__c = 10, Apttus_Config2__StartDate__c = date.today(), Apttus_Config2__EndDate__c = date.today().addDays(10), Apttus_Config2__IsSelected__c = true);
        tempRenewList.add(tempRenew1);
        
        Apttus_Config2__TempRenew__c tempRenew2 = new Apttus_Config2__TempRenew__c(Apttus_Config2__ActionName__c = CANCEL_ACTION, Apttus_Config2__Quantity__c = 10, Apttus_Config2__StartDate__c = date.today(), Apttus_Config2__EndDate__c = date.today().addDays(10), Apttus_Config2__IsSelected__c = true);
        tempRenewList.add(tempRenew2);
        
        insert tempRenewList;                                                          
                                                                                                                       
                                                                    
       test.startTest();
        Apttus_Config2.CustomClass.ValidationResult vResult = Apttus_Config2.CPQWebService.validateCart(ConfigSO.ID);
        boolean isSuccess = vResult.IsSuccess;
        system.debug('***************isSuccess ' + isSuccess);  
        
        
        
        for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,
                                                            //APTS_Year__c,
                                                            Apttus_Config2__PricingStatus__c,promocode__c,Apttus_Config2__AdjustmentAmount__c
                                                            from Apttus_Config2__LineItem__c
                                                 where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          //lineItem.APTS_Year__c=3;
          lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
          lineItem.APTS_Promo_Code__c='promo1';
          lineItem.Apttus_Config2__AdjustmentAmount__c=10;
         }
         
         update lineItemList;
        } 
        
        Apttus_Config2.CustomClass.ValidationResult vResult2 = Apttus_Config2.CPQWebService.validateCart(ConfigSO.ID);
        boolean isSuccess1 = vResult2.IsSuccess;
        system.debug('***************isSuccess ' + isSuccess); 
        
        
        
        
        APTSValidationCallback controller = new APTSValidationCallback();
        //Apttus_Config2.ProductConfiguration cart = new Apttus_Config2.ProductConfiguration(configuration);
        Apttus_Config2.ProductConfiguration cart;
        
        //validateAssetItems()      
        Apttus_Config2.CustomClass.ValidationResult result1 = controller.validateAssetItems(cart, tempRenewList);
        //system.assert(result.isSuccess == false); 
        //Apttus_Config2.CustomClass.ValidationResult result1 = controller.validateCart(cart); 

       Apttus_Config2.CustomClass.ValidationResult result2 = controller.validateRampLineItems(cart, null);

       test.stopTest();
                                                                                                                        
     
    }
    
    //Venkata R Sabbella
    static testMethod void TestNegativeValidationCallBack()
    {
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'BundleProduct1',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
        Apttus_Config2__PriceList__c priceListSO = createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   
                                                                   
         Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false);    
        Apttus_Proposal__Proposal__c queiredproposalSo =[select id,Apttus_QPConfig__PriceListId__c 
                                                          from 
                                                          Apttus_Proposal__Proposal__c where id=:proposalSO.id];
                                                                                   
        system.assertNotEquals(queiredproposalSo,null);   
        system.assertNotEquals(queiredproposalSo.Apttus_QPConfig__PriceListId__c,null);   
        
        Id priceListid=queiredproposalSo.Apttus_QPConfig__PriceListId__c;                                                          
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = createPriceListItem(priceListid,
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
     Apttus_Config2__ProductConfiguration__c configSO = createProductConfiguration('Pricing Callback Test',
                                                                                      1,
                                                                                      proposalSO.Id,
                                                                                      'Proposal',
                                                                                      'Ad Hoc',
                                                                                      proposalSO.Apttus_QPConfig__PriceListId__c,
                                                                                      null,
                                                                                      'Finalized',
                                                                                      null,
                                                                                      Datetime.now(),
                                                                                      true,
                                                                                      'Pricing Callback Test');
       
        // STEP VI - Create new ad hoc groups
        Apttus_Config2__AdHocGroup__c adGroupSO = createAdHocGroup('Group A',
                                                                   configSO.Id,
                                                                   'Group A');  
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
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
                                                                priceListid,//pricelistId
                                                                plItemSO.Id,//price list item
                                                                'Recurring',//price type
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
    
    
     test.startTest();
     
        
        list<Apttus_Config2__LineItem__c> lineItemlist=[select id,
                                                            //APTS_Year__c,
                                                            Apttus_Config2__PricingStatus__c,
                                                            Apttus_Config2__AdjustmentAmount__c,
                                                            APTS_Promo_Code__c
                                                           
                                                            
                                                            from Apttus_Config2__LineItem__c
                                                 where Apttus_Config2__ConfigurationId__c=:configSo.id];
        for(Apttus_Config2__LineItem__c lineItem:lineItemlist)  
        {
         system.assert(lineItem.Apttus_Config2__PricingStatus__c=='Pending');
         lineItem.Apttus_Config2__PricingStatus__c='Complete';
         
          lineItem.APTS_Promo_Code__c='TestPromo';
          lineItem.Apttus_Config2__AdjustmentAmount__c=100;
        } 
        update lineItemlist;
     
        Apttus_Config2.CustomClass.ValidationResult vResult = Apttus_Config2.CPQWebService.validateCart(ConfigSO.ID);
        boolean isSuccess = vResult.IsSuccess;     
     Test.stopTest();                                                  
                                                                                                                                                                                                                               
    }
    
    static testMethod void testPricingCallback2()
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
        Product2 productSO = createProduct('BundleProduct1',
                                           'BundleProduct1',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'OptionProduct2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = createProduct('StandAlone1',
                                            'StandAlone1',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = createProduct('standAlone2',
                                            'standAlone2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
         // STEP II - Create a new price list
        Apttus_Config2__PriceList__c priceListSO = createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   //kalyan changed first parameter to overcome Price_List_Validation
         
        
        // STEP III - Create price list items
        Apttus_Config2__PriceListItem__c plItemSO = createPriceListItem(priceListSO.Id,
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
                                                                        
        
        Apttus_Config2__PriceListItem__c plItemSO2 = createPriceListItem(priceListSO.Id,
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
        Apttus_Config2__PriceListItem__c plItemSO3 = createPriceListItem(priceListSO.Id,
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
        Apttus_Config2__PriceListItem__c plItemSO4 = createPriceListItem(priceListSO.Id,
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
                                                                        
        Apttus_Config2__PriceListItem__c plItemSO5 = createPriceListItem(priceListSO.Id,
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
         Apttus_Config2__PriceListItem__c plItemSO6 = createPriceListItem(priceListSO.Id,
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
        Apttus_Config2__ProductOptionGroup__c prodOptionGrp=new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__Sequence__c=0,
                                                                                                        Apttus_Config2__MinOptions__c=0,
                                                                                                        Apttus_Config2__MaxOptions__c=100,
                                                                                                        Apttus_Config2__ProductId__c=productSO.id,
                                                                                                        Apttus_Config2__OptionGroupId__c=[select id from Apttus_Config2__ClassificationHierarchy__c 
                                                                                                                                          where Apttus_Config2__HierarchyId__r.Apttus_Config2__Type__c='Option Group' limit 1].id 
                                                                                                        
                                                                                                        );    
         insert   prodOptionGrp;
        
        Apttus_Config2__ProductOptionComponent__c prodOptComp_pso3= CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO3.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                       'Option',//string relationshipType
                                                                                       1
                                                                                       );
                                
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso4=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO4.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                       'Option',//string relationshipType
                                                                                        2);
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso5=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO5.id,//Id OptionId,
                                                                                       productSO.id,//Id parentProductId,
                                                                                        'Option',//string relationshipType
                                                                                        3); 
         Apttus_Config2__ProductOptionComponent__c prodOptComp_pso6=CreateOptionComponents(prodOptionGrp.id,//Id OptionGroupId,
                                                                                       productSO6.id,//Id OptionId,
                                                                                      productSO.id,//Id parentProductId,
                                                                                      'Option',//string relationshipType
                                                                                      4);                                                                
                                                                                                                                       
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
        Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        true);
        
        
         proposalSO.Apttus_QPConfig__PriceListId__c=priceListSO.Id;
         system.debug('recType ---: '+proposalSO.RecordTypeId + ' pricelistName '+proposalSO.Apttus_QPConfig__PriceListId__r.Name);
         if(proposalSO.RecordTypeId != null && proposalSO.Apttus_QPConfig__PriceListId__r.Name !=null)//kalyan - because from somewhere we were getting nulls
         update proposalSO;                                                              
        /*proposalSO.Apttus_QPConfig__PriceListId__c=[select id,Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c where id=:proposalSO.id].Apttus_QPConfig__PriceListId__c;  
        //Apttus_Proposal__Proposal__c,Apttus_QPConfig__PriceListId__c        
        priceListSO.Id=proposalSO.Apttus_QPConfig__PriceListId__c; 
        
        system.assertequals( proposalSO.Apttus_QPConfig__PriceListId__c,priceListSO.Id);  */                                                   
        createPromotions(priceListSO.Id,proposalSO.id,productSO6);  
           
        
         // STEP V - create a new configuration object
        Apttus_Config2__ProductConfiguration__c configSO = createProductConfiguration('Pricing Callback Test',
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
       
        // STEP VI - Create new ad hoc groups
        Apttus_Config2__AdHocGroup__c adGroupSO = createAdHocGroup('Group A',
                                                                   configSO.Id,
                                                                   'Group A');  
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
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
        
         Apttus_Config2__LineItem__c lineItemSO1 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Option',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.id,//productOptionId
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
         Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                2,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO6.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso6.id,//productOptionId 
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
        Apttus_Config2__LineItem__c lineItemSO3 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                3,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO5.id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso5.id,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO4.Id,//price list item
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
         Apttus_Config2__LineItem__c lineItemSO4 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Option',//linetype
                                                                productSO.id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso4.id,//productOptionId
                                                                productSO4.id,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO3.Id,//price list item
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
         Apttus_Config2__LineItem__c lineItemSO5 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                4,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO5.id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso5.id,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO4.Id,//price list item
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
         Apttus_Config2__LineItem__c lineItemSO6 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                5,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO5.id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso5.id,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO4.Id,//price list item
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
         Apttus_Config2__LineItem__c lineItemSO7 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                6,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO5.id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso5.id,//productOptionId
                                                                null,//OptionId,
                                                                null,//classid
                                                                null,//string classhierarchy
                                                                1,//qty
                                                                true,//isQtymodifiable
                                                                'Each',//UOM
                                                                1,//term
                                                                priceListSO.Id,//pricelistId
                                                                plItemSO4.Id,//price list item
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
                                                                
                                                                                 
       
       
        
        test.setCurrentPage(page.APTS_GoToPricing_Custom);
        apexpages.currentpage().getParameters().put('Id',configSO.id);
        apexpages.currentpage().getParameters().put('retId',proposalSO.id);
        apexpages.currentpage().getParameters().put('businessObjectId',proposalSO.id);
        apexpages.standardController apsc=new apexpages.standardController(configSO);
        APTS_GoToPricing_Custom_Ctlr GTPctrl=new APTS_GoToPricing_Custom_Ctlr(apsc);
        GTPctrl.doRedirect();
        
        for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,
                                                            //APTS_Year__c,
                                                            Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c
                                                            where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          //lineItem.APTS_Year__c=3;
          //lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
          lineItem.Apttus_Config2__ChargeType__c='Subscription Fee';
         }
         
         update lineItemList;
        }
        
        
        
        Test.startTest();
        
        
         try{
       
             //call pricing 
        //     Boolean result = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configSO.Id, 1);
            //lineItemSO.Apttus_Config2__PrimaryLineNumber__c = 1;
            //update lineItemSO;
       //    Apttus_Config2.PricingWebService.computeNetPriceForItemColl(configSO.Id, 1);
        }catch(Exception ex){
           // system.debug(ex);
        }
        
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        Apttus_Proposal__Proposal__c proposal=[select id,APTS_Enforce_Repricing__c from Apttus_Proposal__Proposal__c where id=:proposalSo.id];
        system.assert(!proposal.APTS_Enforce_Repricing__c);
        proposalSo.APTS_Enforce_Repricing__c=true;
        proposalSO.MYA_Term_New__c='4';
        proposalSO.MYA_Uplift_Year_2__c = 21;
        proposalSO.MYA_Uplift_Year_3__c = 22;
        proposalSO.MYA_Uplift_Year_4__c = 23;
        //proposalSO.MYA_Uplift_Year_5__c = 24;

        update proposalSO;
        
        for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,
                                                //APTS_Year__c,
                                                Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c
                                                 where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          //lineItem.APTS_Year__c=3;
          lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
         }
         
         update lineItemList;
        } 
        
        //GTPctrl.doRedirect();
        
        /*for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,APTS_Year__c from Apttus_Config2__LineItem__c
                                                 where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          lineItem.APTS_Year__c=3;
         }
         
         update lineItemList;
        }         */
        GTPctrl.doRedirect();
       
        try{
             //call pricing 
        //      Boolean result2 = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configSO.Id, 1);
            //lineItemSO.Apttus_Config2__PrimaryLineNumber__c = 1;
            //update lineItemSO;
       //    Apttus_Config2.PricingWebService.computeNetPriceForItemColl(configSO.Id, 3);
           //Boolean pResult1=Apttus_Config2.PricingWebService.executeTotalPriceStepForCart(configSO.Id, 'Finalize');
           
        }catch(Exception ex){
            system.debug(ex);
        }
        
         /*try{
             //call pricing 
          Boolean result = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configSO.Id, 3);
            //lineItemSO.Apttus_Config2__PrimaryLineNumber__c = 1;
            //update lineItemSO;
           Apttus_Config2.PricingWebService.computeNetPriceForItemColl(configSO.Id, 3);
           
           Boolean pResult = Apttus_Config2.PricingWebService.computeTotalPriceForCart(configSO.Id);
           Boolean pResult1=Apttus_Config2.PricingWebService.executeTotalPriceStepForCart(configSO.Id, 'Finalize');
           
        }catch(Exception ex){
           // system.debug(ex);
        }*/
        APTS_PricingCallBack pcb=new APTS_PricingCallBack();
        //pcb.getLineItems(null);
        //pcb.getAdjustedPrice(100,'% Discount',100); 
        //pcb.getAdjustedPrice(100,'Discount Amount',100);
        //pcb.getAdjustedPrice(100,'Uplift Amount',100);
        //pcb.getAdjustedPrice(100,'Price Override',100);
        //pcb.getNetAdjustmentPercent(10,10);
        Test.stopTest();                                    
    }
    
    
    
    static testMethod void testPricingCallback3()
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
       
        Product2 productSO6 = createProduct('standAlone2',
                                            'standAlone2',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
         // STEP II - Create a new price list
        Apttus_Config2__PriceList__c priceListSO = createPriceList('Professional Software Price List', 
                                                                   'Price list for Apttus',
                                                                   Date.today(), 
                                                                   Date.today().addMonths(12));   //kalyan changed first parameter to overcome Price_List_Validation
         
        
        // STEP III - Create price list items
       
                                                                        
        Apttus_Config2__PriceListItem__c plItemSO5 = createPriceListItem(priceListSO.Id,
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
         Apttus_Config2__PriceListItem__c plItemSO6 = createPriceListItem(priceListSO.Id,
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
                                                                 
                                                                                                                                       
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
        Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        true);
        
        
         proposalSO.Apttus_QPConfig__PriceListId__c=priceListSO.Id;
         system.debug('recType ---: '+proposalSO.RecordTypeId + ' pricelistName '+proposalSO.Apttus_QPConfig__PriceListId__r.Name);
         if(proposalSO.RecordTypeId != null && proposalSO.Apttus_QPConfig__PriceListId__r.Name !=null)//kalyan - because from somewhere we were getting nulls
         update proposalSO;                                                              
        /*proposalSO.Apttus_QPConfig__PriceListId__c=[select id,Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c where id=:proposalSO.id].Apttus_QPConfig__PriceListId__c;  
        //Apttus_Proposal__Proposal__c,Apttus_QPConfig__PriceListId__c        
        priceListSO.Id=proposalSO.Apttus_QPConfig__PriceListId__c; 
        
        system.assertequals( proposalSO.Apttus_QPConfig__PriceListId__c,priceListSO.Id);  */                                                   
        createPromotions(priceListSO.Id,proposalSO.id,productSO6);  
           
        
         // STEP V - create a new configuration object
        Apttus_Config2__ProductConfiguration__c configSO = createProductConfiguration('Pricing Callback Test',
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
       
        // STEP VI - Create new ad hoc groups
        Apttus_Config2__AdHocGroup__c adGroupSO = createAdHocGroup('Group A',
                                                                   configSO.Id,
                                                                   'Group A');  
        // STEP VII - Create new line items
       
         Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                2,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO6.Id,//product Id
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
                                                                
                                                               
                                                                
       
        
     /*   test.setCurrentPage(page.APTS_GoToPricing_Custom);
        apexpages.currentpage().getParameters().put('Id',configSO.id);
        apexpages.currentpage().getParameters().put('retId',proposalSO.id);
        apexpages.currentpage().getParameters().put('businessObjectId',proposalSO.id);
        apexpages.standardController apsc=new apexpages.standardController(configSO);
        APTS_GoToPricing_Custom_Ctlr GTPctrl=new APTS_GoToPricing_Custom_Ctlr(apsc);
        GTPctrl.doRedirect();
        */
        for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,
                                                            //APTS_Year__c,
                                                            Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c
                                                            where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          //lineItem.APTS_Year__c=3;
          //lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
          lineItem.Apttus_Config2__ChargeType__c='Subscription Fee';
         }
         
         update lineItemList;
        }
        
        
        
        Test.startTest();
        
        
         try{
       
             //call pricing 
             Boolean result = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configSO.Id, 1);
           Apttus_Config2.PricingWebService.computeNetPriceForItemColl(configSO.Id, 1);
        }catch(Exception ex){
           // system.debug(ex);
        }
        
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        Apttus_Proposal__Proposal__c proposal=[select id,APTS_Enforce_Repricing__c from Apttus_Proposal__Proposal__c where id=:proposalSo.id];
        system.assert(!proposal.APTS_Enforce_Repricing__c);
        proposalSo.APTS_Enforce_Repricing__c=true;
        proposalSO.MYA_Term_New__c='4';
        proposalSO.MYA_Uplift_Year_2__c = 21;
        proposalSO.MYA_Uplift_Year_3__c = 22;
        proposalSO.MYA_Uplift_Year_4__c = 23;
        //proposalSO.MYA_Uplift_Year_5__c = 24;

        update proposalSO;
        
        for(list<Apttus_Config2__LineItem__c> lineItemList:[select id,
                                                //APTS_Year__c,
                                                Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c
                                                 where Apttus_Config2__ConfigurationId__c=:configSo.id])  
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemList )
         {
          //lineItem.APTS_Year__c=3;
          lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
         }
         
         update lineItemList;
        } 
        
       // GTPctrl.doRedirect();
       
        try{
             //call pricing 
              Boolean result2 = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configSO.Id, 1);
           Apttus_Config2.PricingWebService.computeNetPriceForItemColl(configSO.Id, 3);
          
           
        }catch(Exception ex){
            system.debug(ex);
        }
        
        APTS_PricingCallBack pcb=new APTS_PricingCallBack();
        Test.stopTest();                                    
    }
        

    
   
    
    
    /**
     * Creates a product for the given user
     * @param productName the product name
     * @param productCode the product code
     * @param productFamily the product family
     * @param productDesc the product description
     * @param configType the configuration type
     * @param unitOfMeasure the unit of measure
     * @param customizable the product customizable indicator
     * @param effectiveDate the product effective date
     * @param expirationDate the product expiration date
     * @return the product
     */
    private static Product2 createProduct(String productName, 
                                   String productCode, 
                                   String productFamily, 
                                   String productDesc,
                                   String configType,
                                   String unitOfMeasure,
                                   Boolean customizable,
                                   Date effectiveDate,
                                   Date expirationDate) {
        
        // create a new product
        Product2 product = new Product2(Name=productName);
        
        // setup product data
        
        // product code
        product.ProductCode = productCode;
        // product family
        product.Family = productFamily;
        // description
        product.Description = productDesc;
        // configuration type
        product.Apttus_Config2__ConfigurationType__c = configType;
        // unit of measure
        product.Apttus_Config2__Uom__c = unitOfMeasure;
        // customizable
        product.Apttus_Config2__Customizable__c = customizable;
        // effective date
        product.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        product.Apttus_Config2__ExpirationDate__c = expirationDate;
    
        // insert product
        insert product;
        
        System.assert(product.Id != null, 'Failed to create the product for owner ' + UserInfo.getUserId());
            
        return product;
        
    } 
    
    /**
     * Creates a price list for the given user
     * @param priceListName the price list name
     * @param priceListDesc the price list description
     * @param effectiveDate the price list effective date
     * @param expirationDate the price list expiration date
     * @return the price list
     */
    private static Apttus_Config2__PriceList__c createPriceList(String priceListName, 
                                                         String priceListDesc,
                                                         Date effectiveDate,
                                                         Date expirationDate) {
        
        // create a new pricelist
        Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(Name = priceListName, OwnerId = UserInfo.getUserId());
        
        // setup price list data
        
        // description
        priceListSO.Apttus_Config2__Description__c = priceListDesc;
        // effective date
        priceListSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        priceListSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        // active
        priceListSO.Apttus_Config2__Active__c = true;
        
        // insert price list
        insert priceListSO;
        
        System.assert(priceListSO.Id != null, 'Failed to create the price list for owner ' + UserInfo.getUserId());
            
        return priceListSO;
        
    } 
    
    /**
     * Creates a price list item for the given user
     * @param priceListId the price list Id
     * @param productId the product Id
     * @param chargeType the charge type
     * @param priceType the price type
     * @param priceMethod the price method
     * @param listPrice the list price
     * @param minPrice the minimum price
     * @param maxPrice the maximum price
     * @param minMaxPriceAppliesTo the minmax price applies to
     * @param effectiveDate the entry effective date
     * @param expirationDate the entry expiration date
     * @return the price list item
     */
    private static Apttus_Config2__PriceListItem__c createPriceListItem(ID priceListId,
                                                                 ID productId, 
                                                                 String chargeType,
                                                                 String priceType,
                                                                 String priceMethod,
                                                                 Decimal listPrice,
                                                                 Decimal minPrice,
                                                                 Decimal maxPrice,
                                                                 String minMaxPriceAppliesTo,
                                                                 Date effectiveDate,
                                                                 Date expirationDate,
                                                                 boolean active) {
        
        // create a new pricelist item
        Apttus_Config2__PriceListItem__c itemSO = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceListId);
        
        // setup price list entry data
        
        // product id
        itemSO.Apttus_Config2__ProductId__c = productId;
        // charge type
        itemSO.Apttus_Config2__ChargeType__c = chargeType;
        // price type
        itemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        itemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // list price
        itemSO.Apttus_Config2__ListPrice__c = listPrice;
        // min price
        itemSO.Apttus_Config2__MinPrice__c = minPrice;
        // max price
        itemSO.Apttus_Config2__MaxPrice__c = maxPrice;
        // max price
        itemSO.Apttus_Config2__MinMaxPriceAppliesTo__c = minMaxPriceAppliesTo;
        // effective date
        itemSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        itemSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        
        itemSO.Apttus_Config2__Active__c =  active;
        
        // insert price list item
        insert itemSO;
        
        System.assert(itemSO.Id != null, 'Failed to create the price list item for owner ' + UserInfo.getUserId());
            
        return itemSO;
        
    } 
    
    /**
     * Creates a quote/proposal for the given user
     * @param qpName the quote/proposal name
     * @param opptyId the related opportunity id
     * @param approvalDate the quote/proposal approval date
     * @param expirationDate the quote/proposal expiration date
     * @param priceListId the price list id
     * @param pricingDate the pricing date
     * @param maintDuration the maintenance duration
     * @return the quote/proposal
     */
    private static Apttus_Proposal__Proposal__c createQuoteOrProposal(String qpName,
                                                               ID opptyId,
                                                               Date approvalDate, 
                                                               Date expirationDate, 
                                                               ID priceListId,
                                                               Date pricingDate,
                                                               String maintDuration,
                                                               boolean stubyearquote) {

        RecordType Rt=[select id,name,developername from recordType where sobjectType='Apttus_Proposal__Proposal__c' and DeveloperName='AMS_Proposal'];
        
        // create a new quote/proposal
        Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c(OwnerId = UserInfo.getUserId());
        // setup proposal data
        
        // proposal name
        proposalSO.Apttus_Proposal__Proposal_Name__c = qpName;
        proposalSO.RecordTypeId = Rt.Id;//kalyan to overcome Price_List_Validation
        // opportunity
        proposalSO.Apttus_Proposal__Opportunity__c = opptyId;
        // approval date
        proposalSO.Apttus_Proposal__Proposal_Approval_Date__c = approvalDate;
        // expiration date
        proposalSO.Apttus_Proposal__Proposal_Expiration_Date__c = expirationDate;
        // expected start date
        proposalSO.Apttus_Proposal__ExpectedStartDate__c = Date.today();
        // expected end date
        proposalSO.Apttus_Proposal__ExpectedEndDate__c = Date.today().addMonths(12);
        // price list id
        proposalSO.Apttus_QPConfig__PriceListId__c = priceListId;
        // pricing date
        proposalSO.Apttus_QPConfig__PricingDate__c = pricingDate;
        
        proposalSO.APTS_Enforce_Repricing__c=false;
        
        proposalSO.MYA__c =true;
        proposalSO.AMS_MYA_Platform__c = 'CCH Axcess';//kalyan to solve MYA_AMS_Validation

        proposalSO.MYA_Term_New__c='3';
        proposalSO.MYA_Uplift_Year_2__c = 21;
        proposalSO.MYA_Uplift_Year_3__c = 22;

        proposalSO.Stubs_Year_Quote__c=stubyearquote;
        if(stubyearquote){
         proposalSO.Stub_Start_Date__c=date.today().addYears(-1); 
         proposalSO.Stub_End_Date__c=date.today().addYears(1);
         proposalSO.Annual_Start_Date__c=proposalSO.Stub_End_Date__c.addDays(10);
         
         proposalSO.MYA__c =false;
         proposalSO.AMS_MYA_Platform__c = '';//kalyan to solve MYA_AMS_Validation and to 

         //proposalSO.MYA_Term_New__c='';
        // proposalSO.MYA_Term_New__c='4';//MYA_Term_Uplifts_Synch_2 validationm
        // proposalSO.MYA_Uplift_Year_2__c = 21;//MYA_Term_Uplifts_Synch_2 validationm
        // proposalSO.MYA_Uplift_Year_3__c = 22;//MYA_Term_Uplifts_Synch_2 validationm
        // proposalSO.MYA_Uplift_Year_4__c = 23;//MYA_Term_Uplifts_Synch_2 validationm
        // proposalSO.MYA_Uplift_Year_5__c = 24;//MYA_Term_Uplifts_Synch_2 validationm

        }
        proposalSO.APTS_Enforce_Repricing__c=false;    
        // insert quote/proposal
        insert proposalSO;
        
        System.assert(proposalSO.Id != null, 'Failed to create the quote/proposal for owner ' + UserInfo.getUserId());
            
        return proposalSO;
        
    } 
    
    /**
     * Creates a product configuration for the given user
     * @param configName the configuration name
     * @param versionNbr the version number
     * @param bObjectId the business object id
     * @param bObjectType the business object type
     * @param groupType the summary group type
     * @param priceListId the price list Id
     * @param ancestorId the ancestor id
     * @param status the configuration status
     * @param finalizedDate the finalized date
     * @param effectiveDate the effective date
     * @param isTransient the transient configuration indicator
     * @param configDesc the configuration description
     * @return the product configuration group
     */
    private static Apttus_Config2__ProductConfiguration__c createProductConfiguration(String configName,
                                                                               Integer versionNbr,
                                                                               ID bObjectId,
                                                                               String bObjectType,
                                                                               String groupType,
                                                                               ID priceListId, 
                                                                               ID ancestorId, 
                                                                               String status, 
                                                                               Datetime finalizedDate, 
                                                                               Datetime effectiveDate, 
                                                                               Boolean isTransient,
                                                                               String configDesc) {
        
        // create a new classification name
        Apttus_Config2__ProductConfiguration__c configSO = new Apttus_Config2__ProductConfiguration__c(Name = configName, OwnerId = UserInfo.getUserId());
        
        // setup product configuration data
        
        // version number
        configSO.Apttus_Config2__VersionNumber__c = versionNbr;
        // summary group type
        configSO.Apttus_Config2__SummaryGroupType__c = groupType;
        // business object 
        configSO.Apttus_Config2__BusinessObjectId__c = bObjectId;
        // business object type
        configSO.Apttus_Config2__BusinessObjectType__c = bObjectType;
        // proposal id
        configSO.Apttus_QPConfig__Proposald__c = bObjectId;
        // price list id
        configSO.Apttus_Config2__PriceListId__c = priceListId;
        // ancestor id
        configSO.Apttus_Config2__AncestorId__c = ancestorId;
        // status 
        configSO.Apttus_Config2__Status__c = status;
        // is transient
        configSO.Apttus_Config2__IsTransient__c = isTransient;
        // finalized date
        configSO.Apttus_Config2__FinalizedDate__c = finalizedDate;
        // effective date
        configSO.Apttus_Config2__EffectiveDate__c = effectiveDate; 
        // description
        configSO.Apttus_Config2__Description__c = configDesc;
        
        // insert product configuration
        insert configSO;
        
        System.assert(configSO.Id != null, 'Failed to create the product configuration for owner ' + UserInfo.getUserId());
            
        return configSO;
        
    } 
    
    /**
     * Creates an ad hoc group for the given user
     * @param groupName the group name
     * @param configId the product configuration Id
     * @param groupDesc the group description
     * @return the ad hoc group
     */
    private static Apttus_Config2__AdHocGroup__c createAdHocGroup(String groupName,
                                                           ID configId,
                                                           String groupDesc) {
        
        // create a new ad hoc group
        Apttus_Config2__AdHocGroup__c groupSO = new Apttus_Config2__AdHocGroup__c(Name = groupName, Apttus_Config2__ConfigurationId__c = configId);
    
        // setup ad hoc group data
        
        // description
        groupSO.Apttus_Config2__Description__c = groupDesc;
        
        // insert ad hoc group 
        insert groupSO;
        
        System.assert(groupSO.Id != null, 'Failed to create the ad hoc group for owner ' + UserInfo.getUserId());
            
        return groupSO;
        
    } 
    
    /**
     * Creates a line item for the given user
     * @param configId the product configuration Id
     * @param groupId the summary group id
     * @param lineNumber the line number
     * @param isPrimaryLine the primary line indicator
     * @param itemSeq the item sequence
     * @param lineType the line type
     * @param productId the product Id
     * @param customizable the product customizable indicator
     * @param productOptionId the product option Id
     * @param optionId the option Id
     * @param classId the leaf classification id
     * @param classHierarchy the classification hierarchy
     * @param quantity the line quantity
     * @param isQtyModifiable the quantity modifiable indicator
     * @param uom the unit of measure
     * @param term the term
     * @param priceListId the price list Id
     * @param plItemId the price list item id
     * @param priceType the price type
     * @param priceMethod the price method
     * @param chargeType the charge type
     * @param frequency the frequency
     * @param allowManualAdj the manual adjustment indicator
     * @param allocateGroupAdj the allocate group adjustment indicator
     * @param listPrice the list price
     * @param basePrice the base price
     * @param basePriceMethod the base price method
     * @param baseExtPrice the base extended price
     * @param optionPrice the option price
     * @param extPrice the extended price
     * @param lineDesc the line item description
     * @return the line item
     */
    private static Apttus_Config2__LineItem__c createLineItem(ID configId,
                                                       ID groupId,
                                                       Integer lineNumber,
                                                       Boolean isPrimaryLine,
                                                       Integer itemSeq,
                                                       String lineType,
                                                       ID productId,
                                                       Boolean customizable,
                                                       ID productOptionId,
                                                       ID optionId,
                                                       ID classId,
                                                       String classHierarchy,
                                                       Decimal quantity,
                                                       Boolean isQtyModifiable,
                                                       String uom,
                                                       Integer term,
                                                       ID priceListId,
                                                       ID plItemId,
                                                       String priceType,
                                                       String priceMethod,
                                                       String chargeType,
                                                       String frequency,
                                                       Boolean allowManualAdj,
                                                       Boolean allocateGroupAdj,
                                                       Decimal listPrice,
                                                       Decimal basePrice,
                                                       String basePriceMethod,
                                                       Decimal baseExtPrice,
                                                       Decimal optionPrice,
                                                       Decimal extPrice,
                                                       String lineDesc,
                                                       integer primarylineNumber
                                                       //integer year
                                                       ) {
        
        // create a new line item
        Apttus_Config2__LineItem__c lineItemSO = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configId);
        
        // setup line item data
        
        // line number
        lineItemSO.Apttus_Config2__LineNumber__c = lineNumber;
        // primary line
        lineItemSO.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        // item sequence
        lineItemSO.Apttus_Config2__PrimaryLineNumber__c=primarylineNumber;
        lineItemSO.Apttus_Config2__ItemSequence__c = itemSeq;
        // summary group id
        lineItemSO.Apttus_Config2__SummaryGroupId__c = groupId;
        // line type
        lineItemSO.Apttus_Config2__LineType__c = lineType;
        // product id
        lineItemSO.Apttus_Config2__ProductId__c = productId;
        // customizable
        lineItemSO.Apttus_Config2__Customizable__c = customizable;
        // product option id
        lineItemSO.Apttus_Config2__ProductOptionId__c = productOptionId;
        // option id
        lineItemSO.Apttus_Config2__OptionId__c = optionId;
        // classification id
        lineItemSO.Apttus_Config2__ClassificationId__c = classId;
        // classification hierarchy
        lineItemSO.Apttus_Config2__ClassificationHierarchy__c = classHierarchy;
        // quantity
        lineItemSO.Apttus_Config2__Quantity__c = quantity;
        // quantity modifiable
        lineItemSO.Apttus_Config2__IsQuantityModifiable__c = isQtyModifiable;
        // uom
        lineItemSO.Apttus_Config2__Uom__c = uom;
        // term
        lineItemSO.Apttus_Config2__Term__c = term;
        // price list id
        lineItemSO.Apttus_Config2__PriceListId__c = priceListId;
        // price list item id
        lineItemSO.Apttus_Config2__PriceListItemId__c = plItemId;
        // price type
        lineItemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        lineItemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // charge type
        lineItemSO.Apttus_Config2__ChargeType__c = chargeType;
        // frequency
        lineItemSO.Apttus_Config2__Frequency__c = frequency;
        // allow manual adjustment
        lineItemSO.Apttus_Config2__AllowManualAdjustment__c = allowManualAdj;
        // allocate group adjustment
        lineItemSO.Apttus_Config2__AllocateGroupAdjustment__c = allocateGroupAdj;
        // list price
        lineItemSO.Apttus_Config2__ListPrice__c = listPrice;
        // base price
        lineItemSO.Apttus_Config2__BasePrice__c = basePrice;
        // base price mthod
        lineItemSO.Apttus_Config2__BasePriceMethod__c = basePriceMethod;
        // base extended price
        lineItemSO.Apttus_Config2__BaseExtendedPrice__c = baseExtPrice;
        // option price
        lineItemSO.Apttus_Config2__OptionPrice__c = optionPrice;
        // extended price
        lineItemSO.Apttus_Config2__ExtendedPrice__c = extPrice;
        // description
        lineItemSO.Apttus_Config2__Description__c = lineDesc;
        
        
         //lineItemSO.Apttus_Config2__PriceType__c = 'Recurring';
        // price method
        //lineItemSO.Apttus_Config2__PriceMethod__c = 'Flat Price';
        // charge type
        //lineItemSO.Apttus_Config2__ChargeType__c = 'Flat Price';
        // frequency
        //lineItemSO.Apttus_Config2__Frequency__c = 'Monthly';
        //lineItemSO.Apttus_Config2__BasePriceMethod__c = 'Flat Price';
         
        //   lineItemSO.Currency_Decimals__c = 2;    
        lineItemSO.Apttus_Config2__Term__c = 1;
        lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
        lineItemSO.Apttus_Config2__SyncStatus__c = 'Pending';  
       // Apttus_Config2__Quantity__c
        
        //lineItemSO.APTS_Year__c=null;                                                                                                                                                                                                  
        //lineItemSO.IsLineAlreadyCreated__c = true;
       
        // insert line item
        insert lineItemSO;
        
       // System.assert(lineItemSO.Id != null, 'Failed to create the line item for owner ' + UserInfo.getUserId());
            
        return lineItemSO;
        
    } 
    
    
    
    private static list<Promotion__c> createPromotions(Id pricelistId,Id proposalId,product2 product)
    {
        
        List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalId];//kalyan to colve the Promotion does not match filter criteria validation


        Apttus_Config2__ProductGroup__c pg1=new Apttus_Config2__ProductGroup__c(name='test');
        insert pg1;
        
        Apttus_Config2__ProductGroupMember__c pgm1=new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                             Apttus_Config2__ProductId__c=product.id,
                                                                                             Apttus_Config2__ProductGroupId__c=pg1.id);
                                                                                             
        insert pgm1;
        list<Promotion__c> promotionlist=new list<Promotion__c>();
        Promotion__c promotion1=new Promotion__c(Name='Promo1',
                                              Promo_Code__c='Promo1',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                              Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              );
                                              
                                              
        promotionlist.add(promotion1);                                       
        Promotion__c promotion2=new Promotion__c(Name='Promo2',
                                              Promo_Code__c='Promo2',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                               Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              ); 
        promotionlist.add(promotion2); 
        
         Promotion__c promotion3=new Promotion__c(Name='Promo3',
                                              Promo_Code__c='Promo3',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(10),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              Match_Rule_Product_Eligibility_Group__c='Min/Max',
                                               Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              ); 
        promotionlist.add(promotion3);                                       
        
        insert promotionlist;
        
        
         system.assertNotEquals(promotionlist[0].id,null);
         system.assertNotEquals(promotionlist[0].id,null);
         
         system.assertNotEquals(promotionlist[1].Price_List__c,null);
        
        
        list<Quote_Promotion__c> QuotePromoitonlist=new list<Quote_Promotion__c>();
        Quote_Promotion__c QuotePromoiton1= new Quote_Promotion__c(Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[0].id,
                                                                  Today__c=date.today()
                                                                  );
        QuotePromoitonlist.add(QuotePromoiton1);
        
        //insert QuotePromoiton1;  
        
        Quote_Promotion__c QuotePromoiton2= new Quote_Promotion__c(Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton2); 
         
         Quote_Promotion__c QuotePromoiton3= new Quote_Promotion__c(Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton3);  
         
         
         insert QuotePromoitonlist;
         
         QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[1].Promotion__c=promotionlist[1].id;
         QuotePromoitonlist[2].Promotion__c=promotionlist[2].id;

         APTS_QuotePromotionTriggerHelper.isBeforeQuotePromotionTgrRan = false;

         system.debug('QuotePromoitonlist[0].Promotion__c before update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);
          
         update  QuotePromoitonlist;

         system.debug('QuotePromoitonlist[0].Promotion__c after update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);

         system.assertNotEquals(QuotePromoitonlist[0].id,null);
         system.assertNotEquals(QuotePromoitonlist[1].id,null);
         system.assertNotEquals(QuotePromoitonlist[2].id,null);
                                                           
        //insert QuotePromoiton2; 
        
        return  promotionlist;
     
    }
    private static Apttus_Config2__ProductOptionComponent__c CreateOptionComponents(Id OptionGroupId,Id OptionId,Id parentProductId,string relationshipType, integer sequence)
    {
        Apttus_Config2__ProductOptionComponent__c prodOptionComp=new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__RelationshipType__c=relationshipType,
                                                                                                               Apttus_Config2__ProductOptionGroupId__c=OptionGroupId,
                                                                                                               Apttus_Config2__ParentProductId__c=parentProductId,
                                                                                                               Apttus_Config2__ComponentProductId__c=OptionId,
                                                                                                               Apttus_Config2__InclusionCriteria__c=null,
                                                                                                               Apttus_Config2__Sequence__c=sequence,
                                                                                                               Apttus_Config2__Default__c=true,
                                                                                                               Apttus_Config2__MinQuantity__c=1,
                                                                                                               Apttus_Config2__MaxQuantity__c=1,
                                                                                                               Apttus_Config2__DefaultQuantity__c=1
                                                                                                               
        
        );
        
        insert prodOptionComp;
        
        system.assertNotEquals(prodOptionComp.id,null);
        
        return prodOptionComp;
    
    }

  
    
   

}