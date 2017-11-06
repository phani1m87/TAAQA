@istest(seealldata=true)
public with sharing class APTS_ProposalTestCases {   
  
  /**/ 
  
  static testMethod void proposalTriggerTest()
  {/*
   
    Account acctObj = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acctObj;
        
        contact contact1 = new contact(LastName='Dest Contact', AccountId= acctObj.Id,Email = 'test@test.com');//kalyan
        insert contact1;

        Opportunity OpptyObj=new Opportunity(name='CPQ Test Oppty',
                                  AccountId=acctObj.id,
                                  closedate=date.today()+30,
                                  stageName='5. Time to Buy',
                                  Primary_Contact_for_Proposal__c = contact1.Id);
        insert OpptyObj;
         
        
         system.assertNotEquals(contact1,null);                        
         Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c = 'myProposal', 
            Apttus_Proposal__Opportunity__c = OpptyObj.id, 
            Apttus_Proposal__Account__c = acctObj.Id,
            Apttus_Proposal__Primary__c = false,
            Aptps_Conversion_Contact__c=contact1.id,
            Aptps_Training_Contact__c=contact1.id,
            Apttus_QPConfig__ConfigurationFinalizedDate__c=null
         
            
            
            //Apttus_QPConfig__PriceListId__c=
             );
        insert propObj; 
        
        Apttus_Proposal__Proposal__c propObj1=[select id,name,Apttus_QPConfig__PriceListId__c
        
                                     from Apttus_Proposal__Proposal__c 
                                     where id=:propObj.id];
        
        product2 optionproduct=[select id,name from product2 where Apttus_Config2__ConfigurationType__c='Option' limit 1];
        system.assertNotEquals(optionproduct,null);
        
        product2 bundleProduct=[select id,name from product2 where Apttus_Config2__ConfigurationType__c='Bundle' limit 1];

        system.assertNotEquals(bundleproduct,null);    
           
        
       
                                     
        

        system.assertNotEquals(propObj1.Apttus_QPConfig__PriceListId__c,null);
        
        list<Apttus_Proposal__Proposal_Line_Item__c> PLIlist=new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c PLI=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=propObj.id,
                                                                                              Apttus_Proposal__Product__c=bundleProduct.id,
                                                                                              Apttus_QPConfig__LineType__c='Product/Service',
                                                                                              Apttus_QPConfig__PriceListId__c=propObj1.Apttus_QPConfig__PriceListId__c,
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
        Apttus_Proposal__Proposal_Line_Item__c PLI1=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=propObj.id,
                                                                                               Apttus_Proposal__Product__c=bundleProduct.id,
                                                                                               Apttus_QPConfig__OptionId__c=optionproduct.id,
                                                                                               Apttus_QPConfig__LineType__c='Option',
                                                                                               Apttus_QPConfig__PriceListId__c=propObj1.Apttus_QPConfig__PriceListId__c,
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
        Apttus_Proposal__Proposal_Line_Item__c PLI2=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=propObj.id
                                                                                      );
        PLIlist.add(PLI2);
        
        insert PLIlist;
        
        //Apttus_Proposal__Proposal_Line_Item__c PLI3=CreateProposalLineItem();
                                                                                      
        Apttus_Config2__ProductConfiguration__c prodCObj = new Apttus_Config2__ProductConfiguration__c(
            Name = 'myConfig', 
            Apttus_Config2__Status__c='New',
            Apttus_QPConfig__Proposald__c = propObj.id);
        insert prodCObj;                    
            system.debug('!!..' + prodCObj.id);
            
            
            
        propObj.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today();
        update propObj;    
            
        Test.StartTest();
        system.assert(APTPS_ProposalTgrHelper.proposalTriggerMap.get('afterupdate'));
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
        propObj.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today()+1;
        update propObj;  
        
        Test.StopTest();
         */   
   
  }
  
  


      static testMethod void proposalTriggerTest4()
    {
     
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1));
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        
        
        //opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'TestApttus4',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = createProduct('StandAlone1',
                                            'TestAPttus5',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = createProduct('standAlone2',
                                            'TestApttus6',
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
                                                                   Date.today().addMonths(12));   
         
        
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
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
       
       /*end price setup*/
       Apttus_Config2__PriceDimension__c priceDimension = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c  = 'Apttus_Config2__LineItem__c',
                                                                                                  Apttus_Config2__ContextType__c =  'Line Item' ,
                                                                                                  Apttus_Config2__Datasource__c = 'LAN__c',
                                                                                                  //IsDeleted =   false,
                                                                                                  Name =  'LAN (LAN)'
                                                                                                  ); 

        insert priceDimension;

        Apttus_Config2__PriceRuleset__c priceRuleSet = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                            Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                            Apttus_Config2__Category__c = 'All',
                                                                                            Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                            Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                            Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                            Apttus_Config2__Sequence__c = 1.0,
                                                                                            Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                            Apttus_Config2__UseType__c  = 'Line Item',
                                                                                            //IsDeleted = false,
                                                                                            Name  = 'IC Banded Pricing 25'
                                                                                            );

        insert priceRuleSet;
        
        Apttus_Config2__PriceRule__c priceRule = new Apttus_Config2__PriceRule__c(
                                                                                    Apttus_Config2__Active__c = true,
                                                                                    Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                    Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                    Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                    Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                    Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                    Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                    //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                    //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                    //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                    //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                    Apttus_Config2__InitialRows__c  = 5.0,
                                                                                    //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                    Apttus_Config2__RulesetId__c   = priceRuleSet.Id,
                                                                                    Apttus_Config2__RuleType__c = 'Dimension',
                                                                                    Apttus_Config2__Sequence__c = 1.0,
                                                                                    Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                    //IsDeleted = false
                                                                                  );

        insert priceRule;

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                  Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                  Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                  Apttus_Config2__Dimension1Value__c  = '01',
                                                                                                  //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                 // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                  Apttus_Config2__MatchInAsset__c = false,
                                                                                                  Apttus_Config2__PriceRuleId__c  = priceRule.Id,
                                                                                                  Apttus_Config2__Sequence__c = 1.0  
                                                                                                  //IsDeleted = false,
                                                                                                  //Name  = 'RE-0000000070'
                                                                                                );

        insert priceRuleEntry;

          /**Pricing set 2**/

              Apttus_Config2__PriceRuleset__c priceRuleSet1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                                  Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                                  Apttus_Config2__Category__c = 'All',
                                                                                                  Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                                  Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                                  Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                                  Apttus_Config2__Sequence__c = 1.0,
                                                                                                  Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                                  Apttus_Config2__UseType__c  = 'Line Item',
                                                                                                  //IsDeleted = false,
                                                                                                  Name  = 'IC Banded Pricing 26'
                                                                                                  );

              insert priceRuleSet1;
              
              Apttus_Config2__PriceRule__c priceRule1 = new Apttus_Config2__PriceRule__c(
                                                                                          Apttus_Config2__Active__c = true,
                                                                                          Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                          Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                          Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                          Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                          Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                          Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                          //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                          //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                          //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                          //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                          Apttus_Config2__InitialRows__c  = 5.0,
                                                                                          //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                          Apttus_Config2__RulesetId__c   = priceRuleSet1.Id,
                                                                                          Apttus_Config2__RuleType__c = 'Dimension',
                                                                                          Apttus_Config2__Sequence__c = 1.0,
                                                                                          Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                          //IsDeleted = false
                                                                                        );

              insert priceRule1;

              Apttus_Config2__PriceRuleEntry__c priceRuleEntry1 = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                        Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                        Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                        Apttus_Config2__Dimension1Value__c  = '01',
                                                                                                        //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                       // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                        Apttus_Config2__MatchInAsset__c = false,
                                                                                                        Apttus_Config2__PriceRuleId__c  = priceRule1.Id,
                                                                                                        Apttus_Config2__Sequence__c = 1.0  
                                                                                                        //IsDeleted = false,
                                                                                                        //Name  = 'RE-0000000070'
                                                                                                      );

              insert priceRuleEntry1;




          /**Pricing set 2**/

        /*end price setup*/
        
       /* Promotion__c promotion = [SELECT Id,Promo_Code__c,qUOTE__C FROM Promotion__c WHERE Promo_Code__c  = 'IC Banded Pricing 25'];
        system.debug('promotion: '+promotion);

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry2 = [Select Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__Dimension1Value__c,
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RuleType__c,
            Apttus_Config2__ProductFamily__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c
            From Apttus_Config2__PriceRuleEntry__c
            Where Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name =  'IC Banded Pricing 25' AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__Active__c = true AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true LIMIT 1];

        system.debug('priceRuleEntry: '+priceRuleEntry2);*/
        //priceRuleEntry.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true;
        //update priceRuleEntry;

        Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,acc.Id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        //PromoCode__c = promotion.Promo_Code__c,
                                                                        false);

        List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalSO.id];//kalyan to colve the Promotion does not match filter criteria validation


        /**quote promo start**/

       //List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalId];//kalyan to colve the Promotion does not match filter criteria validation


        Apttus_Config2__ProductGroup__c pg1=new Apttus_Config2__ProductGroup__c(name='test');
        insert pg1;
        
        Apttus_Config2__ProductGroupMember__c pgm1=new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                             Apttus_Config2__ProductId__c=productSO.id,
                                                                                             Apttus_Config2__ProductGroupId__c=pg1.id);
                                                                                             
        insert pgm1;
        list<Promotion__c> promotionlist=new list<Promotion__c>();

            Promotion__c promotion2=new Promotion__c(Name='Promo2',
                                              Promo_Code__c='IC Banded Pricing 26',
                                              Entities_to_Match__c = 'Product Only' ,
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Rule_Product_Eligibility_Group__c='Min/Max',
                                               Match_Min_Products__c=10,
                                              Match_Max_Products__c=10
                                              ); 
        promotionlist.add(promotion2); 

       /* Promotion__c promotion1=new Promotion__c(Name='Promo1',
                                              Promo_Code__c='IC Banded Pricing 25',
                                              Entities_to_Match__c = 'Product Only',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                               Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              );
                                              
                                              
        promotionlist.add(promotion1); */                                      
    
        
        /* Promotion__c promotion3=new Promotion__c(Name='Promo3',
                                              Promo_Code__c='Promo3',
                                              Entities_to_Match__c = 'Product or Account',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(10),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              Match_Rule_Product_Eligibility_Group__c='Min/Max',
                                               Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              ); 
        promotionlist.add(promotion3);*/                                       
        
        insert promotionlist;
        
        
         system.assertNotEquals(promotionlist[0].id,null);
         system.assertNotEquals(promotionlist[0].id,null);
         
         //system.assertNotEquals(promotionlist[1].Price_List__c,null);
        
        
        list<Quote_Promotion__c> QuotePromoitonlist=new list<Quote_Promotion__c>();
       /* Quote_Promotion__c QuotePromoiton1= new Quote_Promotion__c(//Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[0].id,
                                                                  //Promotion_Code__c = 'IC Banded Pricing 25',

                                                                  Today__c=date.today(),
                                                                  Quote_Proposal__c = proposalSO.id
                                                                  );
        QuotePromoitonlist.add(QuotePromoiton1);*/
        
        //insert QuotePromoiton1;  
        
        Quote_Promotion__c QuotePromoiton2= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Account_Attribute_Match__c = false,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton2); 
         
       /*  Quote_Promotion__c QuotePromoiton3= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton3);  */
         
         
         insert QuotePromoitonlist;
         
         //QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         //QuotePromoitonlist[1].Promotion__c=promotionlist[1].id;

         APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan = false;

         //system.debug('QuotePromoitonlist[0].Promotion__c before update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);
 
         update  QuotePromoitonlist;

         //system.debug('QuotePromoitonlist[0].Promotion__c after update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);

         //system.assertNotEquals(QuotePromoitonlist[0].id,null);
         //system.assertNotEquals(QuotePromoitonlist[1].id,null);
         //system.assertNotEquals(QuotePromoitonlist[2].id,null);

         /***quote promotion***/
            
        
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
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.id,//productOptionId
                                                                productSO.id,//OptionId,
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
                                                                'Product/Service',//linetype
                                                                productSO5.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.id,//productOptionId
                                                                productSO.Id,//OptionId,
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
                                                                2);
       Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
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
                                                                2);                                                                                                                                       
       
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        2
                                                                                        );
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO1=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO3.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        3
                                                                                        );
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO2=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO4.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        1
                                                                                        );  
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO3=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO5.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        null
                                                                                        );
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO4=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO6.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        4
                                                                                        );   
         Test.StartTest();
         proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today(); 
         //proposalSO.PromoCode__c = promotion.Promo_Code__c;
         update proposalSO;    
            
        
        system.assert(APTPS_ProposalTgrHelper.proposalTriggerMap.get('afterupdate'));
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
        proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today()+1;
        proposalSO.APTS_Enforce_Repricing__c=true;
        proposalSO.MYA_Term__c='4';
        proposalSO.SAP_Payment_Terms__c='Net30';
          //added by Praveen Bala 10/22/2015
         QuoteProposalTriggerHandler.hasAlreadyRun=false;
        update proposalSO;  
        
       /* string str1= APTSConstants.bundle+APTSConstants.STANDALONE;
       str1+=APTSConstants.PRODUCTSERVICE;
       str1+=APTSConstants.OPTION;
       str1+=APTSConstants.CommaDelimeter;
      str1+=APTSConstants.AMS;
       str1+=APTSConstants.SAP;
       str1+=APTSConstants.FLEXPAY;
       str1+=APTSConstants.IPP4;
       str1+=APTSConstants.IPP6;
       str1+=APTSConstants.IPP12;
       str1+=APTSConstants.NET30;
       str1+=APTSConstants.FULLPAY;
       str1+=APTSConstants.COMPLETE; str1+=APTSConstants.PENDING; str1+=APTSConstants.CONTINUEFLOW; 
       str1+=APTSConstants.SPACE ; str1+=APTSConstants.DOT ; str1+=APTSConstants.CUSTOMSETTINGRECORD ; str1+=APTSConstants.PERCENT ; str1+=APTSConstants.DOLLER ; str1+=APTSConstants.Training_Consulting; str1+=APTSConstants.Compliance_Services;*/
        //system.debug('map-'+APTS_Pricing_Helper.promoCodeMap);
        Test.StopTest();                                                                                                                                                                                                                                                                                                                                                                                                               
        
    }
     
      static testMethod void proposalTriggerTest3()
    {
     
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1));
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        
        
        //opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'TestApttus4',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = createProduct('StandAlone1',
                                            'TestAPttus5',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = createProduct('standAlone2',
                                            'TestApttus6',
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
                                                                   Date.today().addMonths(12));   
         
        
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
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
       
       /*end price setup*/
       Apttus_Config2__PriceDimension__c priceDimension = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c  = 'Apttus_Config2__LineItem__c',
                                                                                                  Apttus_Config2__ContextType__c =  'Line Item' ,
                                                                                                  Apttus_Config2__Datasource__c = 'LAN__c',
                                                                                                  //IsDeleted =   false,
                                                                                                  Name =  'LAN (LAN)'
                                                                                                  ); 

        insert priceDimension;

        Apttus_Config2__PriceRuleset__c priceRuleSet = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                            Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                            Apttus_Config2__Category__c = 'All',
                                                                                            Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                            Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                            Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                            Apttus_Config2__Sequence__c = 1.0,
                                                                                            Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                            Apttus_Config2__UseType__c  = 'Line Item',
                                                                                            //IsDeleted = false,
                                                                                            Name  = 'IC Banded Pricing 25'
                                                                                            );

        insert priceRuleSet;
        
        Apttus_Config2__PriceRule__c priceRule = new Apttus_Config2__PriceRule__c(
                                                                                    Apttus_Config2__Active__c = true,
                                                                                    Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                    Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                    Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                    Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                    Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                    Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                    //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                    //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                    //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                    //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                    Apttus_Config2__InitialRows__c  = 5.0,
                                                                                    //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                    Apttus_Config2__RulesetId__c   = priceRuleSet.Id,
                                                                                    Apttus_Config2__RuleType__c = 'Dimension',
                                                                                    Apttus_Config2__Sequence__c = 1.0,
                                                                                    Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                    //IsDeleted = false
                                                                                  );

        insert priceRule;

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                  Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                  Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                  Apttus_Config2__Dimension1Value__c  = '01',
                                                                                                  //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                 // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                  Apttus_Config2__MatchInAsset__c = false,
                                                                                                  Apttus_Config2__PriceRuleId__c  = priceRule.Id,
                                                                                                  Apttus_Config2__Sequence__c = 1.0  
                                                                                                  //IsDeleted = false,
                                                                                                  //Name  = 'RE-0000000070'
                                                                                                );

        insert priceRuleEntry;

          /**Pricing set 2**/

              Apttus_Config2__PriceRuleset__c priceRuleSet1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                                  Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                                  Apttus_Config2__Category__c = 'All',
                                                                                                  Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                                  Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                                  Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                                  Apttus_Config2__Sequence__c = 1.0,
                                                                                                  Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                                  Apttus_Config2__UseType__c  = 'Line Item',
                                                                                                  //IsDeleted = false,
                                                                                                  Name  = 'IC Banded Pricing 26'
                                                                                                  );

              insert priceRuleSet1;
              
              Apttus_Config2__PriceRule__c priceRule1 = new Apttus_Config2__PriceRule__c(
                                                                                          Apttus_Config2__Active__c = true,
                                                                                          Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                          Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                          Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                          Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                          Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                          Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                          //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                          //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                          //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                          //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                          Apttus_Config2__InitialRows__c  = 5.0,
                                                                                          //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                          Apttus_Config2__RulesetId__c   = priceRuleSet1.Id,
                                                                                          Apttus_Config2__RuleType__c = 'Dimension',
                                                                                          Apttus_Config2__Sequence__c = 1.0,
                                                                                          Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                          //IsDeleted = false
                                                                                        );

              insert priceRule1;

              Apttus_Config2__PriceRuleEntry__c priceRuleEntry1 = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                        Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                        Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                        Apttus_Config2__Dimension1Value__c  = '01',
                                                                                                        //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                       // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                        Apttus_Config2__MatchInAsset__c = false,
                                                                                                        Apttus_Config2__PriceRuleId__c  = priceRule1.Id,
                                                                                                        Apttus_Config2__Sequence__c = 1.0  
                                                                                                        //IsDeleted = false,
                                                                                                        //Name  = 'RE-0000000070'
                                                                                                      );

              insert priceRuleEntry1;




          /**Pricing set 2**/

        /*end price setup*/
        
        /*Promotion__c promotion = [SELECT Id,Promo_Code__c,qUOTE__C FROM Promotion__c WHERE Promo_Code__c  = 'IC Banded Pricing 25'];
        system.debug('promotion: '+promotion);

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry2 = [Select Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__Dimension1Value__c,
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RuleType__c,
            Apttus_Config2__ProductFamily__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c
            From Apttus_Config2__PriceRuleEntry__c
            Where Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name =  'IC Banded Pricing 25' AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__Active__c = true AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true LIMIT 1];

        system.debug('priceRuleEntry: '+priceRuleEntry2);*/
        //priceRuleEntry.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true;
        //update priceRuleEntry;

        Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,acc.Id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        //PromoCode__c = promotion.Promo_Code__c,
                                                                        false);

        List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalSO.id];//kalyan to colve the Promotion does not match filter criteria validation


        /**quote promo start**/

       //List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalId];//kalyan to colve the Promotion does not match filter criteria validation


        Apttus_Config2__ProductGroup__c pg1=new Apttus_Config2__ProductGroup__c(name='test');
        insert pg1;
        
        Apttus_Config2__ProductGroupMember__c pgm1=new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                             Apttus_Config2__ProductId__c=productSO.id,
                                                                                             Apttus_Config2__ProductGroupId__c=pg1.id);
                                                                                             
        insert pgm1;
        list<Promotion__c> promotionlist=new list<Promotion__c>();

            Promotion__c promotion2=new Promotion__c(Name='Promo2',
                                              Promo_Code__c='IC Banded Pricing 26',
                                              Entities_to_Match__c = 'Product Only' ,
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                               Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              ); 
        promotionlist.add(promotion2); 

       /* Promotion__c promotion1=new Promotion__c(Name='Promo1',
                                              Promo_Code__c='IC Banded Pricing 25',
                                              Entities_to_Match__c = 'Product Only',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                               Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              );
                                              
                                              
        promotionlist.add(promotion1); */                                      
    
        
         Promotion__c promotion3=new Promotion__c(Name='Promo3',
                                              Promo_Code__c='Promo3',
                                              Entities_to_Match__c = 'Product or Account',
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
       /* Quote_Promotion__c QuotePromoiton1= new Quote_Promotion__c(//Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[0].id,
                                                                  //Promotion_Code__c = 'IC Banded Pricing 25',

                                                                  Today__c=date.today(),
                                                                  Quote_Proposal__c = proposalSO.id
                                                                  );
        QuotePromoitonlist.add(QuotePromoiton1);*/
        
        //insert QuotePromoiton1;  
        
        Quote_Promotion__c QuotePromoiton2= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Account_Attribute_Match__c = false,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton2); 
         
         Quote_Promotion__c QuotePromoiton3= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton3);  
         
         
         insert QuotePromoitonlist;
         
         //QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[1].Promotion__c=promotionlist[1].id;

         APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan = false;

         //system.debug('QuotePromoitonlist[0].Promotion__c before update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);
          

         update  QuotePromoitonlist;

         system.debug('QuotePromoitonlist[0].Promotion__c after update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);

         //system.assertNotEquals(QuotePromoitonlist[0].id,null);
         system.assertNotEquals(QuotePromoitonlist[1].id,null);
         //system.assertNotEquals(QuotePromoitonlist[2].id,null);

         /***quote promotion***/
            
        
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
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.id,//productOptionId
                                                                productSO.id,//OptionId,
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
                                                                'Product/Service',//linetype
                                                                productSO5.Id,//product Id
                                                                true,//boolean customizable
                                                                prodOptComp_pso3.id,//productOptionId
                                                                productSO.Id,//OptionId,
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
                                                                2);
       Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
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
                                                                2);                                                                                                                                       
       
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        2
                                                                                        );
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO1=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO3.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        3
                                                                                        );
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO2=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO4.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        1
                                                                                        );  
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO3=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO5.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        null
                                                                                        );
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO4=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO6.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        4
                                                                                        );       
         
         Test.StartTest();
         proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today(); 
         //proposalSO.PromoCode__c = promotion.Promo_Code__c;check impact 
         update proposalSO;    
            
        
        system.assert(APTPS_ProposalTgrHelper.proposalTriggerMap.get('afterupdate'));
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
        proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today()+1;
        proposalSO.APTS_Enforce_Repricing__c=true;
        proposalSO.MYA_Term__c='4';
        proposalSO.SAP_Payment_Terms__c='Net30';
        update proposalSO;  
        
       /* string str1= APTSConstants.bundle+APTSConstants.STANDALONE;
       str1+=APTSConstants.PRODUCTSERVICE;
       str1+=APTSConstants.OPTION;
       str1+=APTSConstants.CommaDelimeter;
      str1+=APTSConstants.AMS;
       str1+=APTSConstants.SAP;
       str1+=APTSConstants.FLEXPAY;
       str1+=APTSConstants.IPP4;
       str1+=APTSConstants.IPP6;
       str1+=APTSConstants.IPP12;
       str1+=APTSConstants.NET30;
       str1+=APTSConstants.FULLPAY;
       str1+=APTSConstants.COMPLETE; str1+=APTSConstants.PENDING; str1+=APTSConstants.CONTINUEFLOW; 
       str1+=APTSConstants.SPACE ; str1+=APTSConstants.DOT ; str1+=APTSConstants.CUSTOMSETTINGRECORD ; str1+=APTSConstants.PERCENT ; str1+=APTSConstants.DOLLER ; str1+=APTSConstants.Training_Consulting; str1+=APTSConstants.Compliance_Services;*/
        //system.debug('map-'+APTS_Pricing_Helper.promoCodeMap);
        Test.StopTest();                                                                                                                                                                                                                                                                                                                                                                                                               
        
    }


    static testMethod void proposalTriggerTest2()
    {
     
     Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1));
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        
        
        
        //opp = [Select id,StageName from Opportunity where id =:opp.id];
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12));
                                           
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'TestApttus4',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO5 = createProduct('Bundle2',
                                            'TestAPttus5',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Bundle',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12));
        Product2 productSO6 = createProduct('standAlone2',
                                            'TestApttus6',
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
                                                                   Date.today().addMonths(12));   
         
        
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
        //plItemSO1-->bundle  
        //plItemSO2-->Option  
        //plItemSO3-->Option        
        //plItemSO4-->Standalone  
        //plItemSO5-->Standalone     
        // STEP IV - Create a new quote/proposal
       
       /*end price setup*/
       Apttus_Config2__PriceDimension__c priceDimension = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c  = 'Apttus_Config2__LineItem__c',
                                                                                                  Apttus_Config2__ContextType__c =  'Line Item' ,
                                                                                                  Apttus_Config2__Datasource__c = 'LAN__c',
                                                                                                  //IsDeleted =   false,
                                                                                                  Name =  'LAN (LAN)'
                                                                                                  ); 

        insert priceDimension;

        Apttus_Config2__PriceRuleset__c priceRuleSet = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                            Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                            Apttus_Config2__Category__c = 'All',
                                                                                            Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                            Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                            Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                            Apttus_Config2__Sequence__c = 1.0,
                                                                                            Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                            Apttus_Config2__UseType__c  = 'Line Item',
                                                                                            //IsDeleted = false,
                                                                                            Name  = 'IC Banded Pricing 25'
                                                                                            );

        insert priceRuleSet;
        
        Apttus_Config2__PriceRule__c priceRule = new Apttus_Config2__PriceRule__c(
                                                                                    Apttus_Config2__Active__c = true,
                                                                                    Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                    Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                    Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                    Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                    Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                    Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                    //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                    //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                    //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                    //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                    Apttus_Config2__InitialRows__c  = 5.0,
                                                                                    //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                    Apttus_Config2__RulesetId__c   = priceRuleSet.Id,
                                                                                    Apttus_Config2__RuleType__c = 'Dimension',
                                                                                    Apttus_Config2__Sequence__c = 1.0,
                                                                                    Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                    //IsDeleted = false
                                                                                  );

        insert priceRule;

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                  Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                  Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                  Apttus_Config2__Dimension1Value__c  = 'TestApttus',
                                                                                                  //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                 // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                  Apttus_Config2__MatchInAsset__c = false,
                                                                                                  Apttus_Config2__PriceRuleId__c  = priceRule.Id,
                                                                                                  Apttus_Config2__Sequence__c = 1.0  
                                                                                                  //IsDeleted = false,
                                                                                                  //Name  = 'RE-0000000070'
                                                                                                );

        insert priceRuleEntry;

          /**Pricing set 2**/

              Apttus_Config2__PriceRuleset__c priceRuleSet1 = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c  = true,
                                                                                                  Apttus_Config2__AdjustmentAppliesTo__c  = 'Base Price',
                                                                                                  Apttus_Config2__Category__c = 'All',
                                                                                                  Apttus_Config2__Criteria__c = '{ "sObjectName" : "Apttus_Config2__LineItem__c", "sObjectLabel" : "Line Item", "filter" : { "predicates" : [ { "RowNum" : 1, "FieldValue" : "9571", "FieldType" : "STRING", "FieldName" : "LAN__c", "FieldLabel" : "LAN", "CompOper" : "equal to", "BoolOper" : null } ], "condExpr" : "1", "childFilter" : null }, "fields" : [ "LAN__c" ], "exprStr" : "(LAN = 9571)" }',
                                                                                                  Apttus_Config2__Description__c  = 'For testing - DO NOT USE OR ACTIVATE',
                                                                                                  Apttus_Config2__PriceListId__c  = priceListSO.id,  
                                                                                                  Apttus_Config2__Sequence__c = 1.0,
                                                                                                  Apttus_Config2__StopProcessingMoreRules__c  = false,
                                                                                                  Apttus_Config2__UseType__c  = 'Line Item',
                                                                                                  //IsDeleted = false,
                                                                                                  Name  = 'IC Banded Pricing 26'
                                                                                                  );

              insert priceRuleSet1;
              
              Apttus_Config2__PriceRule__c priceRule1 = new Apttus_Config2__PriceRule__c(
                                                                                          Apttus_Config2__Active__c = true,
                                                                                          Apttus_Config2__AdjustmentAppliesTo__c  = 'List Price',
                                                                                          Apttus_Config2__AdjustmentChargeType__c = 'Adjustment',
                                                                                          Apttus_Config2__AllowableAction__c  = 'Unrestricted',
                                                                                          Apttus_Config2__AllowRemovalOfAdjustment__c = false,
                                                                                          Apttus_Config2__Dimension1Id__c = priceDimension.id,
                                                                                          Apttus_Config2__Dimension1ValueType__c = 'Discrete',
                                                                                          //Apttus_Config2__Dimension2Id__c = PRICING DIMENSION 2 ID,
                                                                                          //Apttus_Config2__Dimension2ValueType__c  = Discrete,
                                                                                          //Apttus_Config2__Dimension3Id__c = PRICING DIMENSION 3 ID,
                                                                                          //Apttus_Config2__Dimension3ValueType__c  = Range,
                                                                                          Apttus_Config2__InitialRows__c  = 5.0,
                                                                                          //Apttus_Config2__NumberOfEntries__c = 9.0,
                                                                                          Apttus_Config2__RulesetId__c   = priceRuleSet1.Id,
                                                                                          Apttus_Config2__RuleType__c = 'Dimension',
                                                                                          Apttus_Config2__Sequence__c = 1.0,
                                                                                          Apttus_Config2__StopProcessingMoreRules__c  = false
                                                                                          //IsDeleted = false
                                                                                        );

              insert priceRule1;

              Apttus_Config2__PriceRuleEntry__c priceRuleEntry1 = new Apttus_Config2__PriceRuleEntry__c(

                                                                                                        Apttus_Config2__AdjustmentAmount__c = 150.0, 
                                                                                                        Apttus_Config2__AdjustmentType__c = '% Discount',
                                                                                                        Apttus_Config2__Dimension1Value__c  = 'TestApttus3',
                                                                                                        //Apttus_Config2__Dimension2Value__c  = 'Module on CD (CC)',
                                                                                                       // Apttus_Config2__Dimension3Value__c  = 1,
                                                                                                        Apttus_Config2__MatchInAsset__c = false,
                                                                                                        Apttus_Config2__PriceRuleId__c  = priceRule1.Id,
                                                                                                        Apttus_Config2__Sequence__c = 1.0  
                                                                                                        //IsDeleted = false,
                                                                                                        //Name  = 'RE-0000000070'
                                                                                                      );

              insert priceRuleEntry1;




          /**Pricing set 2**/

        /*end price setup*/
        
        /*Promotion__c promotion = [SELECT Id,Promo_Code__c,qUOTE__C FROM Promotion__c WHERE Promo_Code__c  = 'IC Banded Pricing 25'];
        system.debug('promotion: '+promotion);

        Apttus_Config2__PriceRuleEntry__c priceRuleEntry2 = [Select Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__Dimension1Value__c,
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RuleType__c,
            Apttus_Config2__ProductFamily__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c
            From Apttus_Config2__PriceRuleEntry__c
            Where Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name =  'IC Banded Pricing 25' AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__Active__c = true AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true LIMIT 1];

        system.debug('priceRuleEntry: '+priceRuleEntry2);*/
        //priceRuleEntry.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true;
        //update priceRuleEntry;

        Apttus_Proposal__Proposal__c proposalSO = createQuoteOrProposal('Test Configure', 
                                                                        opp.id,acc.Id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        //PromoCode__c = promotion.Promo_Code__c,
                                                                        false);

        List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalSO.id];//kalyan to colve the Promotion does not match filter criteria validation


        /**quote promo start**/

       //List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalId];//kalyan to colve the Promotion does not match filter criteria validation


        Apttus_Config2__ProductGroup__c pg1=new Apttus_Config2__ProductGroup__c(name='test');
        insert pg1;
        
        Apttus_Config2__ProductGroupMember__c pgm1=new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__Sequence__c=1,
                                                                                             Apttus_Config2__ProductId__c=productSO.id,
                                                                                             Apttus_Config2__ProductGroupId__c=pg1.id);
                                                                                             
        insert pgm1;
        list<Promotion__c> promotionlist=new list<Promotion__c>();
        Promotion__c promotion1=new Promotion__c(Name='Promo1',
                                              Promo_Code__c='IC Banded Pricing 25',
                                              Entities_to_Match__c = 'Product Only',
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                               Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              );
                                              
                                              
        promotionlist.add(promotion1);                                       
        Promotion__c promotion2=new Promotion__c(Name='Promo2',
                                              Promo_Code__c='IC Banded Pricing 26',
                                              Entities_to_Match__c = 'Account Only' ,
                                              Active__c=true,
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                              Effective_Date__c=date.today().addDays(-1),
                                              Expiration_Date__c=date.today().addDays(1),
                                              Eligibility_Criteria_Product_Group__c=pg1.id,
                                              //Match_Rule_Product_Eligibility_Group__c='Match All in Group',
                                              Match_Rule_Product_Eligibility_Group__c='Match Any in Group',
                                               Match_Min_Products__c=1,
                                              Match_Max_Products__c=1
                                              ); 
        promotionlist.add(promotion2); 
        
         Promotion__c promotion3=new Promotion__c(Name='Promo3',
                                              Promo_Code__c='Promo3',
                                              Entities_to_Match__c = 'Product or Account',
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
        Quote_Promotion__c QuotePromoiton1= new Quote_Promotion__c(//Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[0].id,
                                                                  //Promotion_Code__c = 'IC Banded Pricing 25',

                                                                  Today__c=date.today(),
                                                                  Quote_Proposal__c = proposalSO.id
                                                                  );
        QuotePromoitonlist.add(QuotePromoiton1);
        
        //insert QuotePromoiton1;  
        
        Quote_Promotion__c QuotePromoiton2= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Account_Attribute_Match__c = true,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton2); 
         
         Quote_Promotion__c QuotePromoiton3= new Quote_Promotion__c(Quote_Proposal__c= proposalSO.id,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,kalyan
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton3);  
         
         
         insert QuotePromoitonlist;
         
         QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[1].Promotion__c=promotionlist[1].id;
         QuotePromoitonlist[2].Promotion__c=promotionlist[2].id;

         APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan = false;

         system.debug('QuotePromoitonlist[0].Promotion__c before update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);
          
         //update  QuotePromoitonlist;

         system.debug('QuotePromoitonlist[0].Promotion__c after update in APTPS_TestClass: '+QuotePromoitonlist[0].Promotion__c);

         system.assertNotEquals(QuotePromoitonlist[0].id,null);
         system.assertNotEquals(QuotePromoitonlist[1].id,null);
         system.assertNotEquals(QuotePromoitonlist[2].id,null);

         /***quote promotion***/
            
        
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
        // STEP VII - Create new line items
        Apttus_Config2__LineItem__c lineItemSO = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                1,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO.Id,//product Id
                                                                true,//boolean customizable
                                                                //prodOptComp_pso3.id,//productOptionId
                                                                null,
                                                                //productSO.id,//OptionId,
                                                                null, //OptionId
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
                                                                2,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Product/Service',//linetype
                                                                productSO5.Id,//product Id
                                                                true,//boolean customizable
                                                                //prodOptComp_pso3.id,//productOptionId
                                                                null,
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
                                                                2);
       Apttus_Config2__LineItem__c lineItemSO2 = createLineItem(configSO.Id,//configId
                                                                null,//groupId
                                                                2,//line number
                                                                true,//Is primary line
                                                                1,//itemseq
                                                                'Option',//linetype
                                                                productSO5.Id,//product Id
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
                                                                2);                                                                                                                                       
       update  QuotePromoitonlist;
       
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        2
                                                                                        );
       Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO1=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO3.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        3
                                                                                        );
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO2=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO.id,
                                                                                        ProductSO4.id,
                                                                                        pricelistSO.id,
                                                                                        'Option',
                                                                                        1
                                                                                        );  
      Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO3=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO5.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        null
                                                                                        );
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItemSO4=createProposalLineItem(proposalSO.id,
                                                                                        ConfigSO.id,
                                                                                        ProductSO6.id,
                                                                                        null,
                                                                                        pricelistSO.id,
                                                                                        'Product/Service',
                                                                                        4
                                                                                        );       
        
        Test.StartTest();
         
         proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today(); 
         //proposalSO.PromoCode__c = promotion.Promo_Code__c; 
       //  update proposalSO;    
            
        
        system.assert(APTPS_ProposalTgrHelper.proposalTriggerMap.get('afterupdate'));
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',false);
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',false);
        proposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c=date.today()+1;
        proposalSO.APTS_Enforce_Repricing__c=true;
        proposalSO.MYA_Term__c='4';
        proposalSO.SAP_Payment_Terms__c='Net30';
        update proposalSO;  
        
       /* string str1= APTSConstants.bundle+APTSConstants.STANDALONE;
       str1+=APTSConstants.PRODUCTSERVICE;
       str1+=APTSConstants.OPTION;
       str1+=APTSConstants.CommaDelimeter;
      str1+=APTSConstants.AMS;
       str1+=APTSConstants.SAP;
       str1+=APTSConstants.FLEXPAY;
       str1+=APTSConstants.IPP4;
       str1+=APTSConstants.IPP6;
       str1+=APTSConstants.IPP12;
       str1+=APTSConstants.NET30;
       str1+=APTSConstants.FULLPAY;
       str1+=APTSConstants.COMPLETE; str1+=APTSConstants.PENDING; str1+=APTSConstants.CONTINUEFLOW; 
       str1+=APTSConstants.SPACE ; str1+=APTSConstants.DOT ; str1+=APTSConstants.CUSTOMSETTINGRECORD ; str1+=APTSConstants.PERCENT ; str1+=APTSConstants.DOLLER ; str1+=APTSConstants.Training_Consulting; str1+=APTSConstants.Compliance_Services;*/
        //system.debug('map-'+APTS_Pricing_Helper.promoCodeMap);
        Test.StopTest();                                                                                                                                                                                                                                                                                                                                                                                                               
        
    }
    
    
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Id proposalId,Id ConfigId, Id productId, Id OptionId,Id pricelistId,string linetype, integer year)
    {
     Apttus_Proposal__Proposal_Line_Item__c propline= new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalId,
                                                                                                 Apttus_QPConfig__ConfigurationId__c=ConfigId,
                                                                                                 Apttus_QPConfig__OptionId__c=OptionId, Apttus_Proposal__Product__c=productId,
                                                                                                 Apttus_QPConfig__ItemSequence__c=1,Apttus_QPConfig__LineNumber__c=2,
                                                                                                 Apttus_QPConfig__LineType__c=linetype,
                                                                                                 Apttus_QPConfig__PriceListId__c=pricelistId, 
                                                                                                 Apttus_QPConfig__ChargeType__c='Subscription Fee',
                                                                                                 Apttus_QPConfig__PriceType__c='Recurring', 
                                                                                                 Apttus_QPConfig__SellingTerm__c=1, 
                                                                                                 Apttus_QPConfig__BasePrice__c=100,
                                                                                                 Apttus_QPConfig__AdjustmentType__c='% Discount',   
                                                                                                 Apttus_QPConfig__AdjustmentAmount__c=10,
                                                                                                 Apttus_QPConfig__NetPrice__c    =100,
                                                                                                 Apttus_QPConfig__AdjustedPrice__c  =100,
                                                                                                 Apttus_QPConfig__BaseExtendedCost__c=100,
                                                                                                 Apttus_QPConfig__ExtendedPrice__c=100,                                                                    
                                                                                                 Apttus_QPConfig__NetAdjustmentPercent__c=10,
                                                                                                 APTS_Year__c=year   );
      insert propline;
      system.assertnotEquals(propline.id,null);
      return propline;
    }
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
        if(configType=='Option')
        product.AMS_Product_Category__c='Tax Consulting';
    
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
                                                               ID opptyId, ID accId,
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
        // opportunity
        proposalSO.Apttus_Proposal__Opportunity__c = opptyId;
        proposalSO.Apttus_Proposal__Account__c = accId;
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
        
        proposalSO.MYA__c =true;
        proposalSO.AMS_MYA_Platform__c = 'CCH Axcess';//kalyan to solve MYA_AMS_Validation

        proposalSO.APTS_Enforce_Repricing__c=false;
        
        proposalSO.MYA_Term__c='3';
        proposalSO.RecordTypeId = Rt.id;
        proposalSO.Stubs_Year_Quote__c=stubyearquote;
        proposalSO.PromoCode__c = 'IC Banded Pricing 25';
        if(stubyearquote){
         proposalSO.Stub_Start_Date__c=date.today().addYears(-1); 
         proposalSO.Stub_End_Date__c=date.today().addYears(1);
         proposalSO.PromoCode__c = 'IC Banded Pricing 25';

        }
        proposalSO.Order_Type__c = 'SAP' ;   
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
        lineItemSO.Apttus_Config2__PricingStatus__c = 'New';
        lineItemSO.Apttus_Config2__SyncStatus__c = 'Pending';  
        
        
        lineItemSO.APTS_Year__c=1;                                                                                                                                                                                                  
        //lineItemSO.IsLineAlreadyCreated__c = true;
        
        // insert line item
        insert lineItemSO;
        
       // System.assert(lineItemSO.Id != null, 'Failed to create the line item for owner ' + UserInfo.getUserId());
            
        return lineItemSO;
        
    } 
    static OpportunityLineItem createOpportunityLineItem( 
                                          Id OpportunityId,  
                                          string lineType,
                                          Id Pricebook2Id,
                                          Id productId )
    {
    PricebookEntry entry=new PricebookEntry(Pricebook2Id=Pricebook2Id,
                                        product2Id=productId,
                                        unitprice=1000,
                                        IsActive=true
                                        );
    insert entry;                                    
      
     OpportunityLineItem opli =new OpportunityLineItem(PricebookEntryId=entry.Id, 
                                                  OpportunityId=OpportunityId, 
                                                  UnitPrice=100, 
                                                  Quantity=1,LineType__c=lineType);
     insert opli;   
     system.assertNotEquals(opli.id,null);
     return opli;                                          
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
    /*private static list<Promotion__c> createPromotions(Id pricelistId,Id proposalId,product2 product)
    {
        List<Apttus_Proposal__Proposal__c> proposalRec = [SELECT Id, Apttus_QPConfig__PriceListId__c FROM Apttus_Proposal__Proposal__c where Id=:proposalId];


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
                                              Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
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
                                               Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
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
                                               Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
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
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
                                                                  //Promotion__c=promotionlist[0].id,
                                                                  Today__c=date.today()
                                                                  );
        QuotePromoitonlist.add(QuotePromoiton1);
        
        //insert QuotePromoiton1;  
        
        Quote_Promotion__c QuotePromoiton2= new Quote_Promotion__c(Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton2); 
         
         Quote_Promotion__c QuotePromoiton3= new Quote_Promotion__c(Quote_Proposal__c=ProposalId,
                                                                  Price_List__c=proposalRec[0].Apttus_QPConfig__PriceListId__c,//PricelistId,
                                                                  //Promotion__c=promotionlist[1].id,
                                                                  Today__c=date.today()
                                                                  );
         QuotePromoitonlist.add(QuotePromoiton3);  
         
         
         insert QuotePromoitonlist;
         
         QuotePromoitonlist[0].Promotion__c=promotionlist[0].id;
         QuotePromoitonlist[1].Promotion__c=promotionlist[1].id;
          QuotePromoitonlist[2].Promotion__c=promotionlist[2].id;
          
         update  QuotePromoitonlist;
         system.assertNotEquals(QuotePromoitonlist[0].id,null);
         system.assertNotEquals(QuotePromoitonlist[1].id,null);
         system.assertNotEquals(QuotePromoitonlist[2].id,null);
                                                           
        //insert QuotePromoiton2; 
        
        return  promotionlist;
     
    }*/

}