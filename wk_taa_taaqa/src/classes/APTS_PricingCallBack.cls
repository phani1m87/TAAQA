/*************************************************************************************************************
* @author Ranjeet  - Apttus
* @CreatedDate 04/09/2014  
*
* Last Modified By - Venkata- Apttus
* @ModifiedDate 01/12/15
  History:debug selling term: 01/18/2015.
  Removed Commented Code.
 
   
   
***************************************************************************************************************/
global with sharing class APTS_PricingCallBack implements Apttus_Config2.CustomClass.IPricingCallback2 { 

    private Apttus_Config2.ProductConfiguration cart = null;
    private Apttus_Config2.CustomClass.PricingMode mode = null; 
    private Id cartId;
    private Apttus_Proposal__Proposal__c proposal;
    private Boolean isStubsYearQuote = false;//kalyan to cover test class
    //private Integer myaTerm = 0;
    //private Map<Id, Product2> productsMap = new Map<Id, Product2>();
    //private Map<String, Map<String, PromoCodeWrapper>> productWiseMaxDiscountedPromoMap = new Map<String, Map<String, PromoCodeWrapper>>();
    //private Boolean areMYALineAdded;
    //private Map<String, Integer> myaUniqueKeyWiseMaxYearMap;
    //Map<String, Apttus_Config2.LineItem> myaLineItemUniqueKeyWiseLineItemMap;
    
    /**
     * Callback at the beginning of the pricing call.
     * Use the start method to initialize state
     * @param cart the cart object
     */
     
    global void start(Apttus_Config2.ProductConfiguration cart) {
        this.cart = cart;
        this.cartId = cart.getConfigSO().Id; 
        //this.areMYALineAdded = false;
        
        /* Get fields from the quote related to the configuration */
        Id proposalId = cart.getConfigSO().Apttus_QPConfig__Proposald__c;

        proposal = [Select  Apttus_QPConfig__PriceListId__c, APTS_Enforce_Repricing__c, Stubs_Year_Quote__c, 
                    Stub_Start_Date__c, Stub_End_Date__c, MYA_Uplift_Year_2__c, MYA_Uplift_Year_3__c, MYA_Uplift_Year_4__c, MYA_Uplift_Year_5__c,
                    MYA__c,MYA_Term_New__c,
                    (Select Promotion__c, Promotion_Code__c, Promotion__r.Eligibility_Criteria_Product_Group__c, 
                    Promotion__r.Match_Rule_Product_Eligibility_Group__c, Promotion__r.Match_Min_Products__c, Account_Attribute_Match__c, 
                    Promotion__r.Match_Max_Products__c From Promotion_Groups__r Where Is_Valid__c = true)
                    From Apttus_Proposal__Proposal__c Where Id = :proposalId Limit 1];
        
        isStubsYearQuote = proposal.Stubs_Year_Quote__c;
        
        
    }
    
    /**
      * Callback to indicate the pricing mode
      * @param mode the pricing mode
      */
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        this.mode = mode;
    }
    
     /**
     * Callback before pricing the line item collection
     * Use this method to do all required pre-processing to prepare the line items for pricing.
     * @param itemColl the line item collection to pre-process
     */  
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        list<Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        
        //if(Apttus_Config2.CustomClass.PricingMode.BASEPRICE == mode) {
            //APTS_Pricing_Helper.applyPromoCodes(allLines, productsMap, productWiseMaxDiscountedPromoMap);
            //setYearlyPricesForLines(allLines);
            if( isStubsYearQuote == true) {
                setSellingTermForStubsYearQuote(allLines);
            }
        
    }

    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
        
    }
                                                  
    /**
     * Callback after pricing the line item collection
     * Use this method to do all required post-processing after line items are priced.
     * @param itemColl the line item collection to post-process
     */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        list<Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        
        setYearlyPricesForLines(allLines);
        if (Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT == mode) {
            /*
            if(myaTerm > 1 && isStubsYearQuote == false) {
                doPricingForMYALinesAfterPricing(allLines);
            }
            */
        }
        
        for(Apttus_Config2.LineItem lineItemMO : allLines) {
            Apttus_Config2__LineItem__c lineItemSO = lineItemMO.getLineItemSO();
            
            if(lineItemSO.Apttus_Config2__ConfigStatus__c != 'Complete') {
                lineItemSO.Apttus_Config2__ConfigStatus__c = 'Complete';
            }
        }
    }
    
    
    
    
    
    
    
    
    private void setYearlyPricesForLines(list<Apttus_Config2.LineItem> allLines)
    {
     for(Apttus_Config2.LineItem lineItemMO : allLines) {
            Apttus_Config2__LineItem__c lineItemSO = lineItemMO.getLineItemSO();
             
                lineItemSO.MYA_Year_2_Price__c=0;
                lineItemSO.MYA_Year_3_Price__c=0;
                lineItemSO.MYA_Year_4_Price__c=0;
                lineItemSO.MYA_Year_5_Price__c=0;
                
                lineItemSO.MYA_Year_2_Price__c=getYearlyPrice(2,lineItemSO,checkNull(proposal.MYA_Uplift_Year_2__c),checkNull(lineItemSO.Apttus_Config2__NetPrice__c));//lineItemSO.Year_2_Price__c;
                lineItemSO.MYA_Year_3_Price__c=getYearlyPrice(3,lineItemSO,checkNull(proposal.MYA_Uplift_Year_3__c),checkNull(lineItemSO.MYA_Year_2_Price__c));//lineItemSO.Year_3_Price__c;
                lineItemSO.MYA_Year_4_Price__c=getYearlyPrice(4,lineItemSO,checkNull(proposal.MYA_Uplift_Year_4__c),checkNull(lineItemSO.MYA_Year_3_Price__c));//lineItemSO.Year_4_Price__c;
                lineItemSO.MYA_Year_5_Price__c=getYearlyPrice(5,lineItemSO,checkNull(proposal.MYA_Uplift_Year_5__c),checkNull(lineItemSO.MYA_Year_4_Price__c));//lineItemSO.Year_5_Price__c;
                system.debug('yearly prices'+lineItemSO.MYA_Year_2_Price__c+':'+lineItemSO.MYA_Year_3_Price__c+':'+lineItemSO.MYA_Year_4_Price__c+':'+ lineItemSO.MYA_Year_5_Price__c);
                lineItemSO.MYA_All_Years_Total_Price__c =lineItemSO.Apttus_Config2__NetPrice__c!=null?lineItemSO.Apttus_Config2__NetPrice__c:0;
                lineItemSO.MYA_All_Years_Total_Price__c+=lineItemSO.MYA_Year_2_Price__c!=null?lineItemSO.MYA_Year_2_Price__c:0 ; 
                lineItemSO.MYA_All_Years_Total_Price__c+=lineItemSO.MYA_Year_3_Price__c!=null?lineItemSO.MYA_Year_3_Price__c:0;
                lineItemSO.MYA_All_Years_Total_Price__c+=lineItemSO.MYA_Year_4_Price__c!=null?lineItemSO.MYA_Year_4_Price__c:0; 
                 lineItemSO.MYA_All_Years_Total_Price__c+=lineItemSO.MYA_Year_5_Price__c!=null?lineItemSO.MYA_Year_5_Price__c:0;//lineItemSO.MYA_Total_Price__c;
                system.debug('Total price'+ lineItemSO.MYA_All_Years_Total_Price__c+':'+lineItemSO.Apttus_Config2__NetPrice__c);                                         
            
     }
    }
    
    private decimal checkNull(decimal d)
    {
     if(d==null)
     return 0;
     else return d;
    }
    
    private decimal getYearlyPrice(Integer year ,Apttus_Config2__LineItem__c lineItemSO, decimal upliftPercent, decimal upliftcarryover)
    {
     Decimal yearlyPrice=null;
     //if(upliftPercent==null)upliftPercent=0;
     
     upliftPercent=(upliftPercent!=null)?upliftPercent/100:0;
     Integer myaterm=proposal.MYA_Term_New__c!=null?Integer.valueOf(proposal.MYA_Term_New__c):0;
     system.debug('uplift percent'+upliftPercent);
     system.debug('upliftcarryover'+upliftPercent);
     if(proposal.MYA__c 
        && myaterm>=year 
        && lineItemSO.Apttus_Config2__ChargeType__c=='Subscription Fee')
        {
        yearlyPrice= upliftcarryover * (1.0+ upliftPercent );
        system.debug('Net price:'+lineItemSO.Apttus_Config2__NetPrice__c+' : uplift percent:'+upliftPercent);
        }
     else if(proposal.Stubs_Year_Quote__c
             && year==2 
             && lineItemSO.Apttus_Config2__ChargeType__c=='Subscription Fee'
             && lineItemSO.Apttus_Config2__SellingTerm__c>0)
             yearlyPrice=lineItemSO.Apttus_Config2__NetPrice__c * (1/lineItemSO.Apttus_Config2__SellingTerm__c);
     
     system.debug('::::::::::::;'+yearlyPrice);        
     
     return yearlyPrice;
    }
    
    private void setSellingTermForStubsYearQuote(list<Apttus_Config2.LineItem> allLines) {
        for(Apttus_Config2.LineItem lineItemMO : allLines) {
            Apttus_Config2__LineItem__c lineItemSO = lineItemMO.getLineItemSO();
            
            Integer currentYear = System.today().year();
            //lineItemSO.Apttus_Config2__SellingTerm__c = 10;
            if((//lineItemSO.APTS_Product_Configuration_Type__c != 'Bundle' 
                lineItemSO.APTS_Product_Configuration_Type__c != null
                //&& lineItemSO.APTS_Year__c == null 
                //&& myaUniqueKeyWiseMaxYearMap.isEmpty()
                ) 
              //|| lineItemSO.APTS_Year__c == 1
              ) {
                lineItemSO.Apttus_Config2__StartDate__c = proposal.Stub_Start_Date__c;
                lineItemSO.Apttus_Config2__EndDate__c = proposal.Stub_End_Date__c;
                //lineItemSO.Apttus_Config2__SellingTerm__c=2;
                if(proposal.Stub_Start_Date__c != null && proposal.Stub_End_Date__c != null) {
                   
                   lineItemSO.Apttus_Config2__SellingTerm__c=1.0;
                   system.debug('Selling Term:'+lineItemSO.Apttus_Config2__SellingTerm__c);
                   Integer numberOfMonths=proposal.Stub_Start_Date__c.monthsBetween(proposal.Stub_End_Date__c)+1;
                   lineItemSO.Apttus_Config2__SellingTerm__c=Decimal.valueOf(numberOfMonths)/12;
                   system.debug('Selling Term:'+numberOfMonths);
                   if(lineItemSO.Apttus_Config2__PriceType__c=='One Time')
                   {
                    lineItemSO.Apttus_Config2__SellingTerm__c=null;
                   }
                   
                } 
                
            } 
                
        }
    }
    
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
        list<Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        
        //setYearlyPricesForLines(allLines); 

    }

    /**
     * Callback after all batches of line items are processed
    */
    global void finish() {
        //proposal.APTS_Enforce_Repricing__c = false;
        //update proposal;
    }
        
     /**
     * Gets the list of product line items associated with the Battery line
     * @param cart the cart object
     * @return the list of line item objects
     */
    private static List<Apttus_Config2__LineItem__C> getLineItems(List<Apttus_Config2.LineItem> allLines) {        
        List<Apttus_Config2__LineItem__C> lineItems = new List<Apttus_Config2__LineItem__C>();
        // iterate thru the cart and get the line items matching the battery code1 
        for (Apttus_Config2.LineItem lineItemMO : allLines) {
            lineItems.add(lineItemMO.getLineItemSO());
        }       
        return lineItems;
    }
    /*
    private Decimal getRoundedDecimal(Decimal value) {
        String s = ( value.setScale(2) + 0.001 ).format();
        Decimal d = Decimal.valueOf(s.substring(0,s.length()-1));
        
        return d;
    }
    */
}