public with sharing class APTS_GoToPricing_Custom_Ctlr {
    
    /**************************************** PRIVATE VARIABLES **************************************/
    
    private Apttus_Config2__ProductConfiguration__c configSO;    
    private String productConfigId;
    private String configRequestId;
    private String pricingPageUrl;
    private String cartDetailPageUrl;
    private String retId;
    private String proposalId;
    private String cartStatus;
    private String flow;
    
    /**************************************** END OF PRIVATE VARIABLES **************************************/
    
    public APTS_GoToPricing_Custom_Ctlr (ApexPages.standardController stdCon) {
        
        configSO = (Apttus_Config2__ProductConfiguration__c)stdCon.getRecord();
        productConfigId = configSO.Id;
        configRequestId = ApexPages.currentPage().getParameters().get('configRequestId'); 
        retId = ApexPages.currentPage().getParameters().get('retId');
        proposalId = ApexPages.currentPage().getParameters().get('businessObjectId');
        cartStatus = ApexPages.currentPage().getParameters().get('cartStatus');
        flow = ApexPages.currentPage().getParameters().get('flow');
        flow = (String.isEmpty(flow)) ? 'old' : flow;
        System.debug('**** flow : ' + flow );
        pricingPageUrl = getPricingPageUrl();
        cartDetailPageUrl = getCartDetailPageUrl();
    }
    
    private String getPricingPageUrl() {
        String pricingPageUrl ;
        if( flow.equals('ngCPQ') ) {
            pricingPageUrl = '/apex/Apttus_Config2__Cart?configRequestId=' + configRequestId + '&cartStatus=' + cartStatus + '&id=' + productConfigId + '&flow=ngCPQ#/cart';
        } else {
            pricingPageUrl = '/apex/Apttus_Config2__pricing?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        }
        /*
        List<Apttus_Config2__ConfigSystemProperties__c> configSystemPropertiesCSList = Apttus_Config2__ConfigSystemProperties__c.getall().values();
        
        if(configSystemPropertiesCSList.size() > 0) {
            String cartPage = configSystemPropertiesCSList[0].Apttus_Config2__ViewCartPage__c;
            if(cartPage=='Apttus_Config2__cart')
            {
              //pricingPageUrl = '/apex/Apttus_Config2__pricing?id=' + productConfigId + '&configRequestId=' + configRequestId + '&flow=ngFlow';
              pricingPageUrl = '/apex/Apttus_Config2__Cart?configRequestId=' + configRequestId + '&cartStatus=' + cartStatus + '&id=' + productConfigId + '&flow=ngCPQ#/cart';
            }
        } */
        return pricingPageUrl;
    }
    
    private String getCartDetailPageUrl() {
        String cartPageUrl ;

        if( flow.equals('ngCPQ') ) {
            cartPageUrl = '/apex/Apttus_Config2__Cart?configRequestId=' + configRequestId + '&cartStatus=' + cartStatus + '&id=' + productConfigId + '&flow=ngCPQ#/cart';
            //cartPageUrl = '/apex/Apttus_Config2__Cart?configRequestId=' + configRequestId + '&cartStatus=' + cartStatus + '&id=' + productConfigId + '&flow=ngCPQ#/configure/1';
        } else {
            cartPageUrl = '/apex/Apttus_Config2__CartDetailView?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        }
        /*
        List<Apttus_Config2__ConfigSystemProperties__c> configSystemPropertiesCSList = Apttus_Config2__ConfigSystemProperties__c.getall().values();
        
        if(configSystemPropertiesCSList.size() > 0) {
            String cartPage = configSystemPropertiesCSList[0].Apttus_Config2__ViewCartPage__c;
            cartPageUrl = '/apex/' + cartPage + '?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        } */
        return cartPageUrl;
    }
    
    public PageReference doRedirect() {
        PageReference pg;
        configSO.ConfigRequestId__c=configRequestId;
        update configSO;  
        List<Apttus_Config2__LineItem__c> lineItemsList = getLineItems();
        
        
        Apttus_Proposal__Proposal__c proposal = getProposal();
        
        /*      
        Boolean isStubsYearQuote = proposal.Stubs_Year_Quote__c;
        Integer myaTerm = 0;
        
        if(isStubsYearQuote) {
            myaTerm = 2;
        } else if(proposal.MYA_Term__c != null && proposal.MYA_Term__c != '') {
            myaTerm = Integer.valueOf(proposal.MYA_Term__c);
        }
        */
        
        List<Apttus_Config2__LineItem__c> lineItemsRequireRepricing = lineItemsRequireRepricing(lineItemsList);
        
        if(!lineItemsRequireRepricing.isEmpty()) {
            List<Apttus_Config2__LineItem__c> updatedLineItems = APTS_Pricing_Helper.applyPromoCodes(proposal, lineItemsList);
            
            for(Apttus_Config2__LineItem__c updatedLineItem : updatedLineItems ) {
                System.debug( '*****promocode : ' +updatedLineItem.APTS_Promo_Code__c + '; PromodiscountApplied:  ' +  updatedLineItem.APTPS_PromoDiscountApplied__c + ' ; Pricing Status :  ' + updatedLineItem.Apttus_Config2__PricingStatus__c );
            }
            
            if(!updatedLineItems.isEmpty()) {
                update updatedLineItems;
            }
            
            /*Set<Id> productIdSet = getRecurringProductIdSet(lineItemsRequireRepricing, proposal.Apttus_QPConfig__PriceListId__c);
            
            if(!productIdSet.isEmpty()) {
                APTS_Pricing_Helper.addMYALines(lineItemsRequireRepricing, productIdSet, myaTerm, isStubsYearQuote, this.productConfigId);
            }
            */
            
            pg = new PageReference(pricingPageUrl);
        } else {
            //pg = new PageReference(pricingPageUrl);
            pg = new PageReference(cartDetailPageUrl);
        }
        
        pg.setRedirect(true);
        
        return pg;
    }
    
    private List<Apttus_Config2__LineItem__c> lineItemsRequireRepricing(List<Apttus_Config2__LineItem__c> lineItemsList) {
        List<Apttus_Config2__LineItem__c> lineItemsRequireRepricing = new List<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c lineItemObj : lineItemsList) {
            if(lineItemObj.Apttus_Config2__PricingStatus__c == 'Pending' || (lineItemObj.Apttus_Config2__PricingStatus__c == 'Complete' && lineItemObj.Apttus_Config2__LineType__c == 'Option' && string.isblank(lineItemObj.PromoCode__c))) {
                lineItemsRequireRepricing.add(lineItemObj); 
            }
        }
        System.debug('**** lineItemsRequireRepricing size : ' + lineItemsRequireRepricing.size() );
        return lineItemsRequireRepricing;
    }
    
    private List<Apttus_Config2__LineItem__c> getLineItems() {
        List<Apttus_Config2__LineItem__c> lineItemsList = [ Select Apttus_Config2__PricingStatus__c, Apttus_Config2__ChargeType__c, 
                                                            Apttus_Config2__ProductOptionId__c, Apttus_Config2__OptionId__c, APTS_Product_Configuration_Type__c, 
                                                            Apttus_Config2__ProductId__c, APTS_MYA_Lines_Unique_Key__c, Apttus_Config2__StartDate__c,
                                                            Apttus_Config2__EndDate__c, Apttus_Config2__SellingTerm__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__Quantity__c, APTS_Promo_Code__c,
                                                            APTPS_PromoDiscountApplied__c,Has_Promotions__c,Apttus_Config2__LineType__c,PromoCode__c
                                                            From Apttus_Config2__LineItem__c 
                                                            Where Apttus_Config2__ConfigurationId__c = :productConfigId ];
        System.debug('**** lineItemsList size : ' + lineItemsList.size() );                
        return lineItemsList;
    }
    
    private Apttus_Proposal__Proposal__c getProposal() {
        Apttus_Proposal__Proposal__c proposal = [   Select Apttus_QPConfig__PriceListId__c, APTS_Enforce_Repricing__c,  
            Stubs_Year_Quote__c, Stub_Start_Date__c, Stub_End_Date__c, MYA_Uplift_Year_2__c, MYA_Uplift_Year_3__c, MYA_Uplift_Year_4__c, 
            MYA_Uplift_Year_5__c, (Select Promotion__c, Promotion_Code__c, Promotion__r.Eligibility_Criteria_Product_Group__c, 
            Promotion__r.Match_Rule_Product_Eligibility_Group__c, Promotion__r.Match_Min_Products__c, Account_Attribute_Match__c, 
            Promotion__r.Match_Max_Products__c, Promotion__r.Entities_to_Match__c From Promotion_Groups__r Where Is_Valid__c = true)
            From Apttus_Proposal__Proposal__c Where Id = :proposalId Limit 1];
        
        return proposal;
    }
    
    /*
    private Set<Id> getRecurringProductIdSet(List<Apttus_Config2__LineItem__c> lineItemsList, Id priceListId) {
        Set<Id> productIdSet = new Set<Id>();
        
        for(Apttus_Config2__LineItem__c lineItemObj : lineItemsList) {
            if((lineItemObj.Apttus_Config2__OptionId__c != null || lineItemObj.APTS_Product_Configuration_Type__c == 'Standalone') && lineItemObj.Apttus_Config2__PricingStatus__c == 'Pending' && lineItemObj.Apttus_Config2__ChargeType__c == null && lineItemObj.APTS_Year__c == null) {
                String productId = (lineItemObj.Apttus_Config2__OptionId__c != null) ? lineItemObj.Apttus_Config2__OptionId__c : lineItemObj.Apttus_Config2__ProductId__c;
                productIdSet.add(productId);
            }
        }
        
        system.debug('priceListId  :::::::::::::::::::::::::: ' + priceListId);
        system.debug('productIdSet ::::::::::::::::::::::' + productIdSet);
        
        
        if(!productIdSet.isEmpty()) {
            List<Apttus_Config2__PriceListItem__c> priceListItemList = [Select Apttus_Config2__ProductId__c
                                                                        From Apttus_Config2__PriceListItem__c 
                                                                        Where Apttus_Config2__PriceListId__c = :priceListId AND 
                                                                        Apttus_Config2__ProductId__c IN :productIdSet AND 
                                                                        Apttus_Config2__PriceType__c = 'Recurring' AND 
                                                                        Apttus_Config2__Active__c = true];
            
            
            productIdSet = new Set<Id>();
            
            system.debug('priceListItemList ::::::::::::::::::: ' + priceListItemList);
            
            for(Apttus_Config2__PriceListItem__c priceListItemObj : priceListItemList) {
                productIdSet.add(priceListItemObj.Apttus_Config2__ProductId__c);
            }
        }
        
        return productIdSet;
    }
    */
    
}