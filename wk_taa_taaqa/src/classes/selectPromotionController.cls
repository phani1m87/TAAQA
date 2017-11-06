public class selectPromotionController
{ Public Apttus_Config2__LineItem__c lineItem;
  Public List<Apttus_Config2__LineItem__c> LineItemList;
  Public List<Apttus_Config2__LineItem__c> LineItemListToUpdate;
  Public String productName{get;set;}
  Public List<Line_Item_Promotion__c> promotionList;
  Public String sfdcBaseURL;
  Public String cartPageUrl;
  Public String pricingPageUrl;
  Public List<PromotionWrapperCls> PromotionWrapperList{get;set;}
  private String productConfigId;
  private String configRequestId;
  public String promoCode;
  public String promoName;
  public Double promoPercent;
  private String cartStatus;
  private String flow;
  
  public selectPromotionController(ApexPages.StandardController control) {
        
        lineItem            = (Apttus_Config2__LineItem__c) control.getRecord();
        //productName=lineItem.Apttus_Config2__Description__c;
        //sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        Apttus_Config2__ConfigSystemProperties__c csp = Apttus_Config2__ConfigSystemProperties__c.getValues('System Properties');
        sfdcBaseURL = csp.Apttus_Config2__InstanceUrl__c ;
        System.debug('Base URL: ' + sfdcBaseURL ); 
        Apttus_Config2__LineItem__c lineItemLocal=[select id,Apttus_Config2__ConfigurationId__c,Apttus_Config2__Description__c,Apttus_Config2__ConfigurationId__r.ConfigRequestId__c,Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where id=:lineItem.Id];
        productConfigId=lineItemLocal.Apttus_Config2__ConfigurationId__c;
        configRequestId=lineItemLocal.Apttus_Config2__ConfigurationId__r.ConfigRequestId__c;
        productName=lineItemLocal.Apttus_Config2__Description__c;
        System.debug('**** ApexPages.currentPage().getParameters()  : ' + ApexPages.currentPage().getParameters() );
        cartStatus = ApexPages.currentPage().getParameters().get('cartStatus');
        cartStatus = (String.isEmpty(cartStatus)) ? '' : cartStatus;
        flow = ApexPages.currentPage().getParameters().get('flow');
        flow = (String.isEmpty(flow)) ? 'old' : flow;
        System.debug('**** flow : ' + flow );
        cartPageUrl=getCartDetailPageUrl();
        pricingPageUrl=getPricingPageUrl();
        System.debug('**** cartPageUrl : ' + cartPageUrl );
        System.debug('**** pricingPageUrl : ' + pricingPageUrl );
        if(lineItem.Apttus_Config2__HasOptions__c=true)
        {
          LineItemListToUpdate=[select id,APTS_Promo_Code__c,APTPS_PromoDiscountApplied__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__PricingStatus__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__LineType__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:productConfigId And Apttus_Config2__LineType__c='Option' And Apttus_Config2__ParentBundleNumber__c=:lineItemLocal.Apttus_Config2__LineNumber__c];
        }
        
        List<Line_Item_Promotion__c> promotionList=[select id,Promo__c,Promo_Code__c,Promo_Name__c from Line_Item_Promotion__c where Line_ItemId__c=:lineItem.id];
        Line_Item_Promotion__c nonePromo=new Line_Item_Promotion__c(Promo_Name__c='NONE',Promo__c=0);
        PromotionWrapperList=new List<PromotionWrapperCls>();
        PromotionWrapperCls promotionWrappernone=new PromotionWrapperCls(nonePromo);
        PromotionWrapperList.add(promotionWrappernone);
        if(!promotionList.isEmpty())
        {
        for(Line_Item_Promotion__c promotionObj:promotionList)
        {
         PromotionWrapperCls promotionWrapper=new PromotionWrapperCls(promotionObj);
         PromotionWrapperList.add(promotionWrapper);
        }
        }
    }
    
   public void init() {
        System.debug('***Inside Init : ');
        /*PageReference pg;

        pg.setRedirect(true);
        
        return pg; */
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
        String cartPageUrl = '/apex/Apttus_Config2__CartDetailView?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        
        List<Apttus_Config2__ConfigSystemProperties__c> configSystemPropertiesCSList = Apttus_Config2__ConfigSystemProperties__c.getall().values();
        
        if(configSystemPropertiesCSList.size() > 0) {
            String cartPage = configSystemPropertiesCSList[0].Apttus_Config2__ViewCartPage__c;
            cartPageUrl = '/apex/' + cartPage + '?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        } 
        return cartPageUrl;*/
        return cartPageUrl;

        
    }
    
     private String getPricingPageUrl() {
        String pricingPageUrl ;
        if( flow.equals('ngCPQ') ) {
            pricingPageUrl = '/apex/Apttus_Config2__Cart?configRequestId=' + configRequestId + '&cartStatus=' + cartStatus + '&id=' + productConfigId + '&flow=ngCPQ#/cart';
        } else {
            pricingPageUrl = '/apex/Apttus_Config2__pricing?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        }
        /*String pricingPageUrl = '/apex/Apttus_Config2__pricing?id=' + productConfigId + '&configRequestId=' + configRequestId + '';
        
        List<Apttus_Config2__ConfigSystemProperties__c> configSystemPropertiesCSList = Apttus_Config2__ConfigSystemProperties__c.getall().values();
        
        if(configSystemPropertiesCSList.size() > 0) {
            String cartPage = configSystemPropertiesCSList[0].Apttus_Config2__ViewCartPage__c;
            if(cartPage=='Apttus_Config2__cart')
            {
              pricingPageUrl = '/apex/Apttus_Config2__pricing?id=' + productConfigId + '&configRequestId=' + configRequestId + '&flow=ngFlow';
            }
        } */
        return pricingPageUrl;
    }
   
   Public pagereference applyPromo()
   {
     for(PromotionWrapperCls promotionWrapper:PromotionWrapperList)
     {
        if(promotionWrapper.isSelected==true)
        {
         if(promoName!=null)
         {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select only 1 promo code'));
          return null;
         }
         promoName=promotionWrapper.promtion.Promo_Name__c;
         promoCode=promotionWrapper.promtion.Promo_Code__c;
         promoPercent=promotionWrapper.promtion.Promo__c;
        }
     }
     if(promoName!=null)
     {  
        if(promoName=='NONE')
        {
         lineItem.APTS_Promo_Code__c='';
         lineItem.APTPS_PromoDiscountApplied__c=0;
         lineItem.Has_Promotions__c=true;
        }
        else
        {
        lineItem.APTS_Promo_Code__c=promoCode;
        lineItem.APTPS_PromoDiscountApplied__c=promoPercent;
        }
        lineItem.Apttus_Config2__PricingStatus__c='Pending';
        update lineItem;
        if(!LineItemListToUpdate.isEmpty())
        {
          for(Apttus_Config2__LineItem__c lineItemLocl:LineItemListToUpdate)
          {
             if(promoName=='NONE')
             {  lineItemLocl.APTS_Promo_Code__c='';
               lineItemLocl.Has_Promotions__c=true;
             }
             else
             {
               lineItemLocl.APTS_Promo_Code__c=promoCode;
             }
             lineItemLocl.Apttus_Config2__PricingStatus__c='Pending';
             lineItemLocl.APTPS_PromoDiscountApplied__c=null;
          }
          update LineItemListToUpdate;
        }
     }
     else
     {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Select at least 1 promo code or click Cancel'));
        return null;
     }
     return new Pagereference(pricingPageUrl);
   }
   
   Public PageReference Cancel()
   {
     return new Pagereference(cartPageUrl);
   }
    
   public class PromotionWrapperCls {
     public Boolean isSelected {get;set;}
     public Line_Item_Promotion__c promtion{get;set;}

     public PromotionWrapperCls(Line_Item_Promotion__c promo){
          this.promtion= promo;
          isSelected=false;
     }
  }
}