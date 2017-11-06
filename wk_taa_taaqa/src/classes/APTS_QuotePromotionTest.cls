/*
 Author: Venkata Sabbella

*/

@isTest
public with sharing class APTS_QuotePromotionTest {
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
     newQuotePromoController.Initiator();
     newQuotePromoController.doOK();
     newQuotePromoController.doCancel();
     
     //cancelURL=%2Fapex%2FAptps_QuotePromotionCancelInterceptor%3FRollBackId%3Da2de0000000TofLAAS%26proposalId%3Da0ve0000005OSjpAAG%26QuotePromotionId%3Da2de0000000TofLAAS
     
     
     
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
       
       Apttus_Config2__PriceList__c priceListSO = APTS_TestData.createPriceList(Rt.Name, 
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
                                                                         
      Apttus_Proposal__Proposal__c proposalSO = APTS_TestData.createQuoteOrProposal('Test Configure', 
                                                                        opp.id,
                                                                        Date.today(), 
                                                                        Date.today().addMonths(12), 
                                                                        priceListSO.Id,
                                                                        Date.today(),
                                                                        '3 Years',
                                                                        false,
                                                                        rt.id);                                                                  
                                                                                       
     Test.setCurrentPage(page.proposalSubmitToCOP);
     Apexpages.currentpage().getParameters().put('id',proposalSO.id);
     Test.startTest();
     Apexpages.standardController proposalStdController=new Apexpages.standardController(proposalSO);
     updateProposalController upc=new updateProposalController(proposalStdController);
     upc.doCancel();
     upc.doSubmitToCOP();
     Test.stopTest();
     
    }
    
    static testMethod void testQuotePromotionTgr()
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
                                                                        
                                                                        
         APTS_Account_Attributes__c acctattributes=new APTS_Account_Attributes__c(name='Account Attribute 1',
          																		 Promotion_Account_Attribute_API_Name__c='Promotion_Has_COMPL1_Master_Tax_Guide__c	',
          																		 Quote_Account_Attribute_API_Name__c='Quote_Has_COMPL1_Master_Tax_Guide__c' 
         																			);  
         insert acctattributes;																			                                                               
         APTS_TestData.createPromotions(priceListSO.id,proposalSO.id, productSO); 
         list<Quote_Promotion__c> quotePromotions=[select id,name,Quote_Proposal__c,Promotion__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id ];
         system.assertNotEquals(quotePromotions,Null); 
         system.assert(quotePromotions.size()>0); 
         
        APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan = false;
        id PromotId= quotePromotions[0].Promotion__c;
        quotePromotions[0].Promotion__c=quotePromotions[1].Promotion__c;
        quotePromotions[1].Promotion__c=PromotId;        
        update quotePromotions;
         
         APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan=false;
         list<Quote_Promotion__c> quotePromotions2list=[select id,name,Quote_Proposal__c,Promotion__c from Quote_Promotion__c where Quote_Proposal__c=:proposalSO.id limit 1];
         delete quotePromotions2list;
         
    }
}