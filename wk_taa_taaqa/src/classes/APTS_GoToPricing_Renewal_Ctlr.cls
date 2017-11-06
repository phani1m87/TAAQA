public with sharing class APTS_GoToPricing_Renewal_Ctlr {
    
    /**************************************** PRIVATE VARIABLES **************************************/
    
    private Apttus_Config2__ProductConfiguration__c configSO;    
    private String productConfigId;
    private String configRequestId;
    private String cartPageUrl;
    private String retId;
    private String proposalId;
    
    /**************************************** END OF PRIVATE VARIABLES **************************************/
    
    public APTS_GoToPricing_Renewal_Ctlr (ApexPages.standardController stdCon) {
        
        configSO = (Apttus_Config2__ProductConfiguration__c)stdCon.getRecord();
        productConfigId = configSO.Id;
        configRequestId = ApexPages.currentPage().getParameters().get('configRequestId'); 
        retId = ApexPages.currentPage().getParameters().get('retId');
        proposalId = ApexPages.currentPage().getParameters().get('businessObjectId');
        cartPageUrl = getCartDetailPageUrl();
    }
    
    
    private String getCartDetailPageUrl() {
        String cartPageUrl = '/apex/Apttus_Config2__CartDetailView?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        
        List<Apttus_Config2__ConfigSystemProperties__c> configSystemPropertiesCSList = Apttus_Config2__ConfigSystemProperties__c.getall().values();
        
        if(configSystemPropertiesCSList.size() > 0) {
            String cartPage = configSystemPropertiesCSList[0].Apttus_Config2__ViewCartPage__c;
            cartPageUrl = '/apex/' + cartPage + '?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        } 
        return cartPageUrl;
    }
    
    public PageReference doRedirect() {
        PageReference pg;
        configSO.ConfigRequestId__c=configRequestId;
        update configSO;  
        List<Apttus_Config2__LineItem__c> lineItemsList = getLineItems();
        List<Apttus_Config2__LineItem__c> cancelledLines = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> renewedLines = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> tobeDeletedLines = new List<Apttus_Config2__LineItem__c>();
        
        if(lineItemsList!=null)
        {
         for(Apttus_Config2__LineItem__c lineItem:lineItemsList)
         {
          if(lineItem.Apttus_Config2__LineStatus__c=='Renewed')
            renewedLines.add(lineItem);
          if(lineItem.Apttus_Config2__LineStatus__c=='Cancelled')
            cancelledLines.add(lineItem);
         }
        }
        
        if(!cancelledLines.isEmpty()&&!renewedLines.isEmpty())
        {
         for(Apttus_Config2__LineItem__c lineItemCancelled:cancelledLines)
         {
            for(Apttus_Config2__LineItem__c lineItemRenewed:renewedLines)
            {
              if(lineItemCancelled.Apttus_Config2__ProductId__c==lineItemRenewed.Apttus_Config2__ProductId__c)
               tobeDeletedLines.add(lineItemRenewed);
            }
         }
        }
        
        if(!tobeDeletedLines.isEmpty())
        {
          delete tobeDeletedLines;
        }
              
        pg = new PageReference(cartPageUrl);
        
        pg.setRedirect(true);
        
        return pg;
    }
    
    
    private List<Apttus_Config2__LineItem__c> getLineItems() {
        List<Apttus_Config2__LineItem__c> lineItemsList = [ Select Apttus_Config2__PricingStatus__c, Apttus_Config2__ChargeType__c, 
                                                            Apttus_Config2__ProductOptionId__c, Apttus_Config2__OptionId__c, APTS_Product_Configuration_Type__c, 
                                                            Apttus_Config2__ProductId__c, APTS_MYA_Lines_Unique_Key__c, Apttus_Config2__StartDate__c,
                                                            Apttus_Config2__EndDate__c, Apttus_Config2__SellingTerm__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__Quantity__c, APTS_Promo_Code__c,
                                                            APTPS_PromoDiscountApplied__c,Has_Promotions__c,Apttus_Config2__LineStatus__c
                                                            From Apttus_Config2__LineItem__c 
                                                            Where Apttus_Config2__ConfigurationId__c = :productConfigId ];
                        
        return lineItemsList;
    }
     
}