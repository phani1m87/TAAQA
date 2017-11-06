/*
 Author: Ranjeet  Chouhan
 
 Last Modified by: Venkata Sabbella 
 Date:12/10/2014.
 Change: price rules are defined using the product name earlier.
         Change the callback to support the product code instead of product name.
 


*/

public with sharing class APTS_Pricing_Helper {
    
    /************************** START OF PROMOTIONS CODE *************************************************/
    
    private static Map<Id, Product2> productsMap;
    private static Map<String, Map<String, PromoCodeWrapper>> productWiseMaxDiscountedPromoMap;
   
    //Phase3: data list created to store promo data temporary
    Private static Map<String, List<PromoCodeWrapper>> productWisePromocodeList; // stores list of wrapper, and wrapper hold single promotion data
    Private static Map<String,String> promoCodeWisePromoName;  // stores promotion name for promo code
        
    public static List<Apttus_Config2__LineItem__c> applyPromoCodes(Apttus_Proposal__Proposal__c proposal, List<Apttus_Config2__LineItem__c> lineItemsList) {
        productsMap = new Map<Id, Product2>();
        List<Id> LineItemsIdList=new List<Id>(); //phase 3: lineitems id list created to identify for which line items promotion data should be inserted
        for(Apttus_Config2__LineItem__c lineitem:lineItemsList)
        {
         LineItemsIdList.add(lineitem.Id);
        }
        delete [select id from Line_Item_Promotion__c where Line_ItemId__c in:LineItemsIdList]; //phase 3: delete all the promotion data which is child of line items. basically all promotion will be deleted and again new data which is applicable at time to be inserted.
        productWiseMaxDiscountedPromoMap = new Map<String, Map<String, PromoCodeWrapper>>();
        productWisePromocodeList = new Map<String, List<PromoCodeWrapper>>();
        initializePromotionsData(proposal, lineItemsList);
        //phase 3: processing data below code checks if promo data is available for line item then create child promotion data for that line item.
        set<String> productCodesSet=productWisePromocodeList.keySet();
        Map<Id,String> productIdWiseProductCode=new Map<Id,String>();
        List<Line_Item_Promotion__c> LineItemPromotionsList=new List<Line_Item_Promotion__c>();
        List<id> lineitemIdList=new List<id>();
        String uniqueIdnetifier='';
        String oldPromoC='';
        String newPromC='';
        if(productCodesSet!=null)
        {
         List<product2> productList=[select id,productCode from product2 where productCode in:productCodesSet];
        
         for(product2 prod:productList)
         {
           productIdWiseProductCode.put(prod.Id,prod.productCode);
         }
        }
        
        List<Apttus_Config2__LineItem__c> lineItemsListForPromo=new List<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c lineItemOj:lineItemsList)
        {
           if(lineItemOj.APTS_Promo_Code__c==null)
           {
            //system.debug('test promo:'+lineItemOj.APTS_Promo_Code__c+'other field');
            if(lineItemOj.Has_Promotions__c==false)
            lineItemsListForPromo.add(lineItemOj);
           }
           else
           {
             List<PromoCodeWrapper> promoWrapperforProduct=productWisePromocodeList.get(productIdWiseProductCode.get(lineItemOj.Apttus_Config2__ProductId__c));
             if(promoWrapperforProduct!=null)
             {
               boolean promoUpdate=true;
               for(PromoCodeWrapper promowrapper:promoWrapperforProduct)
               {
                if(promowrapper.promoCode==lineItemOj.APTS_Promo_Code__c)
                {
                 promoUpdate=false;
                 break;
                }
               }
               if(promoUpdate==true)
               lineItemsListForPromo.add(lineItemOj);
              }
              else
              {
               lineItemsListForPromo.add(lineItemOj);
              }
            }
          }
        List<Apttus_Config2__LineItem__c> updatedLineItems = applyPromoCodes(lineItemsListForPromo);
      //  System.debug('updatedlineitems');
      
      
        For(Apttus_Config2__LineItem__c lineItem:lineItemsList)
        {
        //  System.debug('updatedlineitems wrapperList parent'+productWisePromocodeList+'productcode'+productIdWiseProductCode.get(lineItem.Apttus_Config2__ProductId__c));
          List<PromoCodeWrapper> promocodeWrapperList1=productWisePromocodeList.get(productIdWiseProductCode.get(lineItem.Apttus_Config2__ProductId__c)); //phase 3:promowrapper list is retrieved from list by using product code
       //   System.debug('updatedlineitems wrapperList'+promocodeWrapperList1);
          String promoValues='';
          lineitemIdList.add(lineItem.Id);
          //phase 3:iterate through promowrapper list and create line item promotion record for every promowrapper
          if(promocodeWrapperList1!=null)
          {
            for(PromoCodeWrapper promoWrapper:promocodeWrapperList1)
            {
          //    promoValues=promovalues+promoWrapper.promoCode+'('+promoCodeWisePromoName.get(promoWrapper.promoCode)+')';//'(%'+promoWrapper.adjustment+')-';
              Line_Item_Promotion__c lineItemPromotion=new Line_Item_Promotion__c(Line_ItemId__c=lineItem.Id,Promo_Name__c=promoCodeWisePromoName.get(promoWrapper.promoCode),Promo_Code__c=promoWrapper.promoCode,Promo__c=promoWrapper.adjustment);
              LineItemPromotionsList.add(lineItemPromotion);
            }
          }
          lineItem.Has_Promotions__c=false;
         }
        //phase 3: insert line item promotions records.
        if(!LineItemPromotionsList.isEmpty())
          insert LineItemPromotionsList;
     //   System.debug('return Lineitems');
        return updatedLineItems;
    }
    
    private static List<Quote_Promotion__c> getQuotePromotions(Apttus_Proposal__Proposal__c proposal) {
        List<Quote_Promotion__c> quotePromotions = [Select Promotion__c, Promotion_Code__c, Promotion__r.Eligibility_Criteria_Product_Group__c, 
            Promotion__r.Match_Rule_Product_Eligibility_Group__c, Promotion__r.Match_Min_Products__c, Account_Attribute_Match__c, 
            Promotion__r.Match_Max_Products__c, Promotion__r.Entities_to_Match__c , Promotion__r.Id
            From Quote_Promotion__c Where Quote_Proposal__c = :proposal.Id AND Is_Valid__c = true];
        
        return quotePromotions;
    }
    
    public static void initializePromotionsData(Apttus_Proposal__Proposal__c proposal, List<Apttus_Config2__LineItem__c> lineItemsList) {
        
        List<Quote_Promotion__c> quotePromotions = proposal.Promotion_Groups__r;
        
        if(quotePromotions.isEmpty()) {
            quotePromotions = getQuotePromotions(proposal);
        }
        
        Map<String, Quote_Promotion__c> promoCodeMap = new Map<String, Quote_Promotion__c>();
        List<Id> promotionIdList= new List<Id>();
        promoCodeWisePromoName = new Map<String,String>();
        
        Set<Id> productGroupIdSet = new Set<Id>();
        
        if(!quotePromotions.isEmpty()) {
            for(Quote_Promotion__c quotePromotion : quotePromotions) {
                promoCodeMap.put(quotePromotion.Promotion_Code__c, quotePromotion);
                promotionIdList.add(quotePromotion.Promotion__c);
                productGroupIdSet.add(quotePromotion.Promotion__r.Eligibility_Criteria_Product_Group__c); 
            }
        }
        List<Promotion__c> promotionsList=[select id,Name,Promo_Code__c from Promotion__c where id in:promotionIdList];
        For(Promotion__c promotion:promotionsList)
        {
          promoCodeWisePromoName.put(promotion.Promo_Code__c,promotion.Name);
        }
        Map<Id, Set<Id>> productGroupIdWiseProductIdsMap = new Map<Id, Set<Id>>();
        
        if(productGroupIdSet != null && !productGroupIdSet.isEmpty()) {
            List<Apttus_Config2__ProductGroupMember__c> productGroupMemberList = [Select Apttus_Config2__ProductId__c, Apttus_Config2__ProductGroupId__c 
                From Apttus_Config2__ProductGroupMember__c Where Apttus_Config2__ProductGroupId__c IN :productGroupIdSet];
            
            if(!productGroupMemberList.isEmpty()) {
                for(Apttus_Config2__ProductGroupMember__c productGroupMember : productGroupMemberList) {
                    Set<Id> productIdsList = productGroupIdWiseProductIdsMap.get(productGroupMember.Apttus_Config2__ProductGroupId__c);
                    
                    if(productIdsList == null) {
                        productIdsList = new Set<Id>();
                        productGroupIdWiseProductIdsMap.put(productGroupMember.Apttus_Config2__ProductGroupId__c, productIdsList);
                    }
                    
                    productIdsList.add(productGroupMember.Apttus_Config2__ProductId__c);
                }
            }   
        }
        
        populatePromotionRelatedData(promoCodeMap, productGroupIdWiseProductIdsMap, lineItemsList);
        
        Set<Id> productIds = new set<Id>();
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList) {
            if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                productIds.add(lineItemSO.Apttus_Config2__OptionId__c);
            } else {
                productIds.add(lineItemSO.Apttus_Config2__ProductId__c);
            }
        }
        
        if(!productIds.isEmpty()) {
            productsMap = new Map<Id, Product2>([Select id, name, Family, ProductCode, Apttus_Config2__ConfigurationType__c From Product2 Where Id IN :productIds]);
        }
    }
    
    private static void populatePromotionRelatedData(Map<String, Quote_Promotion__c> promoCodeMap, Map<Id, Set<Id>> productGroupIdWiseProductIdsMap, List<Apttus_Config2__LineItem__c> lineItemsList) {
        for(Apttus_Config2__PriceRuleEntry__c priceRuleEntryObj : [Select Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__Dimension1Value__c,
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RuleType__c,
            Apttus_Config2__ProductFamily__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c
            From Apttus_Config2__PriceRuleEntry__c
            Where Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name IN :promoCodeMap.keySet() AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__Active__c = true AND 
            Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c = true]) {
            
            String promoCodeRule = priceRuleEntryObj.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.name;
            String productCode = priceRuleEntryObj.Apttus_Config2__Dimension1Value__c;
            String applicationLevel = priceRuleEntryObj.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c;
            Boolean putPromo=true;
            if(priceRuleEntryObj.Apttus_Config2__AdjustmentAmount__c == null)
                continue;
            
            Quote_Promotion__c quotePromotionObj = promoCodeMap.get(promoCodeRule);
            
            if(quotePromotionObj == null) {
                continue;
            }
            
            system.debug('quotePromotionObj.Promotion__r.Entities_to_Match__c ::::::::::::::::::::' + quotePromotionObj.Promotion__r.Entities_to_Match__c );
            system.debug('quotePromotionObj.Account_Attribute_Match__c ::::::::::::::::::::' + quotePromotionObj.Account_Attribute_Match__c );
            
            if(quotePromotionObj.Promotion__r.Entities_to_Match__c == 'Product Only' && !checkEligibilityConditions(quotePromotionObj, productCode, productGroupIdWiseProductIdsMap, lineItemsList)) {
                continue;
            } else if(quotePromotionObj.Promotion__r.Entities_to_Match__c == 'Account Only' && quotePromotionObj.Account_Attribute_Match__c == false) {
                continue;
            } else if(quotePromotionObj.Promotion__r.Entities_to_Match__c == 'Product or Account' && quotePromotionObj.Account_Attribute_Match__c == false && !checkEligibilityConditions(quotePromotionObj, productCode, productGroupIdWiseProductIdsMap, lineItemsList)) {
                continue;         
            } else if(quotePromotionObj.Promotion__r.Entities_to_Match__c == 'Product and Account' && (quotePromotionObj.Account_Attribute_Match__c == false || !checkEligibilityConditions(quotePromotionObj, productCode, productGroupIdWiseProductIdsMap, lineItemsList))) {
                continue;
            }
            
            system.debug('quotePromotionObj ::::::::::::::::::::::::: ' + quotePromotionObj.Promotion_Code__c);
            
            Map<String, PromoCodeWrapper> adjWiseMaxDiscountedPromoMap = productWiseMaxDiscountedPromoMap.get(productCode);
            
            if(adjWiseMaxDiscountedPromoMap == null) {
                adjWiseMaxDiscountedPromoMap = new Map<String, PromoCodeWrapper>();
                productWiseMaxDiscountedPromoMap.put(productCode, adjWiseMaxDiscountedPromoMap);
            }
            
            //phase 3: fill out promowrapper and pu in map using product code
            List<PromoCodeWrapper> promocodeWrapperList=productWisePromocodeList.get(productCode);
                if(promocodeWrapperList == null)
                {
                 promocodeWrapperList=new List<PromoCodeWrapper>();
                 productWisePromocodeList.put(productcode,promocodeWrapperList);
                }  
            //phase 3: checks for duplicate promo code for single product
            for(PromoCodeWrapper promoWrapper:promocodeWrapperList)
            {
              if(promoWrapper.promoCode==promoCodeRule)
              {
                putPromo=false;
                break;
              }
            }
            if(putPromo==true)
            {
             PromoCodeWrapper promoCodeWrapperObjTemp = new PromoCodeWrapper(promoCodeRule, priceRuleEntryObj.Apttus_Config2__AdjustmentAmount__c);
             promocodeWrapperList.add(promoCodeWrapperObjTemp);
            }
            System.debug('Test promo codes-->'+productWisePromocodeList);
                
            PromoCodeWrapper promoCodeWrapperObj = adjWiseMaxDiscountedPromoMap.get(priceRuleEntryObj.Apttus_Config2__AdjustmentType__c);
            
            if(promoCodeWrapperObj == null) {
                promoCodeWrapperObj = new PromoCodeWrapper(promoCodeRule, priceRuleEntryObj.Apttus_Config2__AdjustmentAmount__c);  
                adjWiseMaxDiscountedPromoMap.put(priceRuleEntryObj.Apttus_Config2__AdjustmentType__c, promoCodeWrapperObj);
            }
            if(promoCodeWrapperObj.adjustment < priceRuleEntryObj.Apttus_Config2__AdjustmentAmount__c) {
                promoCodeWrapperObj.promoCode = promoCodeRule;
                promoCodeWrapperObj.adjustment = priceRuleEntryObj.Apttus_Config2__AdjustmentAmount__c;
            }
        } 
        
    }
    
    private static Boolean checkEligibilityConditions(Quote_Promotion__c quotePromotionObj, String productCode, Map<Id, Set<Id>> productGroupIdWiseProductIdsMap, List<Apttus_Config2__LineItem__c> lineItemsList) {
        String matchRule = quotePromotionObj.Promotion__r.Match_Rule_Product_Eligibility_Group__c;
        Id productGroupId = quotePromotionObj.Promotion__r.Eligibility_Criteria_Product_Group__c;
         
        if(matchRule == null || matchRule == '' || productGroupId == null) {
            return true;
        } 
        
        Set<Id> productIds = productGroupIdWiseProductIdsMap.get(productGroupId);
        String StrProductId = String.ValueOf(productIds);
        
        if(matchRule == 'Match Any in Group') {
            for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList) {
                if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                    if(productIds.contains(lineItemSO.Apttus_Config2__OptionId__c)) {
                        return true;
                    }
                } else {
                    if(productIds.contains(lineItemSO.Apttus_Config2__ProductId__c)) {
                        return true;
                    }
                }
            }   
        } else if(matchRule == 'Match All in Group') {
            for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList) {
                if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                    if(productIds.contains(lineItemSO.Apttus_Config2__OptionId__c)) {
                        productIds.remove(lineItemSO.Apttus_Config2__OptionId__c);
                    }
                } else {
                    if(productIds.contains(lineItemSO.Apttus_Config2__ProductId__c)) {
                        productIds.remove(lineItemSO.Apttus_Config2__ProductId__c);
                    }
                }
            }
            
            if(productIds.isEmpty()) {
                return true;
            }
        } else if(matchRule == 'Min/Max' && ((quotePromotionObj.Promotion__r.Match_Min_Products__c != null && quotePromotionObj.Promotion__r.Match_Min_Products__c > 0) || (quotePromotionObj.Promotion__r.Match_Max_Products__c != null && quotePromotionObj.Promotion__r.Match_Max_Products__c > 0))) {
            
            Integer size = productIds.size();
            
            // We have to create temp ProductID set. Previously we was removing items from main productId set. resulting Min/Max not working.
            Set<String> setProId = new Set<String>();
                for(String strProId : productIds){
                   setProId.add(strProId);
              }
            
            for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList){
                if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                    if(setProId.contains(lineItemSO.Apttus_Config2__OptionId__c)) {
                        setProId.remove(lineItemSO.Apttus_Config2__OptionId__c);
                    }
                } else if(lineItemSO.Apttus_Config2__ProductId__c != null)
                {
                    if(setProId.contains(lineItemSO.Apttus_Config2__ProductId__c)) {
                        setProId.remove(lineItemSO.Apttus_Config2__ProductId__c);
                   }
                }
            } 
            
            if(quotePromotionObj.Promotion__r.Match_Min_Products__c != null && quotePromotionObj.Promotion__r.Match_Min_Products__c > 0) {
                if(size - setProId.size() >= quotePromotionObj.Promotion__r.Match_Min_Products__c) {
                    return true;
                }
            } else {
                if(size - setProId.size() <= quotePromotionObj.Promotion__r.Match_Max_Products__c) {
                    return true;
                }
            }
        } 
        
        return false;
    }
    
    public static List<Apttus_Config2__LineItem__c> applyPromoCodes(List<Apttus_Config2__LineItem__c> lineItemsList) {
        List<Apttus_Config2__LineItem__c> updatedLineItems = new List<Apttus_Config2__LineItem__c>();
        
        Map<Decimal, String> lineNumberWisePromoCodesMap = new Map<Decimal, String>();
        Map<Decimal, Decimal> lineNumberWisePromoPercentMap = new Map<Decimal, Decimal>();
        //Set<Decimal> promoCodesAppliedLineNumbers = new Set<Decimal>();
        
        // First Applying promo codes for Bundle and Standalone lines
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList) {
            if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                continue;
            }
            
            String originalPromoCode = lineItemSO.APTS_Promo_Code__c;
            Decimal originalPromoPercent = lineItemSO.APTPS_PromoDiscountApplied__c;
            
            lineItemSO.APTS_Promo_Code__c = null;
            lineItemSO.APTPS_PromoDiscountApplied__c = null;
            
            lineItemSO.APTPS_PromoDebugString__c = 'Product Id:' + lineItemSO.Apttus_Config2__ProductId__c;
            
            String productId = (lineItemSO.Apttus_Config2__OptionId__c != null) ? lineItemSO.Apttus_Config2__OptionId__c : lineItemSO.Apttus_Config2__ProductId__c;
            
            Product2 productObj = productsMap.get(productId);
            
            if(productObj != null) {
                Map<String, PromoCodeWrapper> adjWiseMaxDiscountedPromoMap = productWiseMaxDiscountedPromoMap.get(productObj.ProductCode);
                
                Decimal maxDiscountPercent = 0;
                String appliedPromoCode = null;
                
                if(adjWiseMaxDiscountedPromoMap != null) {
                    for(String adjType : adjWiseMaxDiscountedPromoMap.keySet()) {
                        PromoCodeWrapper promoCodeWrapperObj = adjWiseMaxDiscountedPromoMap.get(adjType);
                        
                        if(adjType == '% Discount' && maxDiscountPercent < promoCodeWrapperObj.adjustment) {
                            maxDiscountPercent = promoCodeWrapperObj.adjustment;
                            appliedPromoCode = promoCodeWrapperObj.promoCode;
                        }
                    }
                }
                
                if(maxDiscountPercent > 0) {
                    lineItemSO.APTPS_PromoDiscountApplied__c = maxDiscountPercent;  
                } else {
                    lineItemSO.APTPS_PromoDiscountApplied__c = null;
                }
                
                lineItemSO.APTS_Promo_Code__c = appliedPromoCode;
                lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
            }
            
            
             if(originalPromoCode != lineItemSO.APTS_Promo_Code__c || originalPromoPercent != lineItemSO.APTPS_PromoDiscountApplied__c) {
                updatedLineItems.add(lineItemSO);
             }
            
            if(lineItemSO.APTS_Promo_Code__c != null) {
                //promoCodesAppliedLineNumbers.add(lineItemSO.Apttus_Config2__LineNumber__c);
                lineNumberWisePromoCodesMap.put(lineItemSO.Apttus_Config2__LineNumber__c, lineItemSO.APTS_Promo_Code__c);
                lineNumberWisePromoPercentMap.put(lineItemSO.Apttus_Config2__LineNumber__c, lineItemSO.APTPS_PromoDiscountApplied__c);
            }
        }
        
        // Now Applying promo codes for Option lines        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemsList) {
            if(lineItemSO.Apttus_Config2__OptionId__c == null) {
                continue;
            }
            
            String bundlePromoCode = lineNumberWisePromoCodesMap.get(lineItemSO.Apttus_Config2__LineNumber__c);
            Decimal bundlePromoPercent = lineNumberWisePromoPercentMap.get(lineItemSO.Apttus_Config2__LineNumber__c);
            
           
            if(bundlePromoCode != null && bundlePromoPercent != null && bundlePromoPercent > 0) {
                if(lineItemSO.APTS_Promo_Code__c == null || lineItemSO.APTS_Promo_Code__c != bundlePromoCode) {
                    lineItemSO.APTS_Promo_Code__c = bundlePromoCode;
                    lineItemSO.APTPS_PromoDiscountApplied__c = null;
                    lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
                    
                    updatedLineItems.add(lineItemSO);
                }
                
                continue;    
             }
            
            /*
            if(promoCodesAppliedLineNumbers.contains(lineItemSO.Apttus_Config2__LineNumber__c)) {
                if(lineItemSO.APTS_Promo_Code__c != null || lineItemSO.APTPS_PromoDiscountApplied__c != null) {
                    lineItemSO.APTS_Promo_Code__c = null;
                    lineItemSO.APTPS_PromoDiscountApplied__c = null;
                    lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
                    
                    updatedLineItems.add(lineItemSO);
                }
                
                continue;    
            }
            */
            
            String originalPromoCode = lineItemSO.APTS_Promo_Code__c;
            Decimal originalPromoPercent = lineItemSO.APTPS_PromoDiscountApplied__c;
            
            lineItemSO.APTS_Promo_Code__c = null;
            lineItemSO.APTPS_PromoDiscountApplied__c = null;
            
            lineItemSO.APTPS_PromoDebugString__c = 'Product Id:' + lineItemSO.Apttus_Config2__ProductId__c;
            
            String productId = (lineItemSO.Apttus_Config2__OptionId__c != null) ? lineItemSO.Apttus_Config2__OptionId__c : lineItemSO.Apttus_Config2__ProductId__c;
            
            Product2 productObj = productsMap.get(productId);
            
            if(productObj != null) {
                Map<String, PromoCodeWrapper> adjWiseMaxDiscountedPromoMap = productWiseMaxDiscountedPromoMap.get(productObj.ProductCode);
                
                Decimal maxDiscountPercent = 0;
                String appliedPromoCode = null;
                
                if(adjWiseMaxDiscountedPromoMap != null) {
                    for(String adjType : adjWiseMaxDiscountedPromoMap.keySet()) {
                        PromoCodeWrapper promoCodeWrapperObj = adjWiseMaxDiscountedPromoMap.get(adjType);
                        
                        if(adjType == '% Discount' && maxDiscountPercent < promoCodeWrapperObj.adjustment) {
                            maxDiscountPercent = promoCodeWrapperObj.adjustment;
                            appliedPromoCode = promoCodeWrapperObj.promoCode;
                        }
                    }
                }
                
                if(maxDiscountPercent > 0) {
                    lineItemSO.APTPS_PromoDiscountApplied__c = maxDiscountPercent;
                } else {
                    lineItemSO.APTPS_PromoDiscountApplied__c = null;
                }
                
                lineItemSO.APTS_Promo_Code__c = appliedPromoCode;
                lineItemSO.Apttus_Config2__PricingStatus__c = 'Pending';
            }
            
           
           if(originalPromoCode != lineItemSO.APTS_Promo_Code__c || originalPromoPercent != lineItemSO.APTPS_PromoDiscountApplied__c) {
                updatedLineItems.add(lineItemSO);
            }
           
        }
        
        return updatedLineItems;
    }
    
    public class PromoCodeWrapper {
        public String promoCode;
        public Decimal adjustment;
        
        public PromoCodeWrapper(String promoCode, Decimal adjustment) {
            this.promoCode = promoCode;
            this.adjustment = adjustment;
        }
    }
    
    /************************** END OF PROMOTIONS CODE *************************************************/
    
    /************************** START OF MYA CODE *************************************************/
    /*
    public static void addMYALines(List<Apttus_Config2__LineItem__c> allLines, Set<Id> productIdSet, Integer years, Boolean isStubsYearQuote, String productConfigId) {
        List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        Map<Integer, List<Apttus_CPQApi.CPQ.SelectedOptionDO>> bundleLineNumberWiseOptionsMap = new Map<Integer, List<Apttus_CPQApi.CPQ.SelectedOptionDO>>();
        
        List<String> customFields = new List<String>();
        customFields.add('APTS_MYA_Lines_Unique_Key__c');
        //customFields.add('APTS_Promo_Code__c');
        //customFields.add('APTPS_PromoDiscountApplied__c');
        
        List<Apttus_Config2__LineItem__c> lineItemUpdateList = new List<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c lineItemSO : allLines) {
            if(isRecurringStandaloneOrOptionLine(lineItemSO, productIdSet) && lineItemSO.Apttus_Config2__PricingStatus__c == 'Pending' && lineItemSO.Apttus_Config2__ChargeType__c == null && lineItemSO.APTS_Year__c == null) {
                lineItemSO.APTS_MYA_Lines_Unique_Key__c = 'Recurring Charge Type' + ':' + lineItemSO.Apttus_Config2__LineNumber__c + ':' + lineItemSO.Apttus_Config2__PrimaryLineNumber__c;
                lineItemSO.APTS_Year__c = 1;
                
                lineItemUpdateList.add(lineItemSO);
            }
        }
        
        if(!lineItemUpdateList.isEmpty()) {
            update lineItemUpdateList;
        }
        
        for(Apttus_Config2__LineItem__c lineItemSO : allLines) {
            if(isRecurringStandaloneOrOptionLine(lineItemSO, productIdSet) && lineItemSO.Apttus_Config2__PricingStatus__c == 'Pending' && lineItemSO.Apttus_Config2__ChargeType__c == null && lineItemSO.APTS_Year__c == 1) {
                if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                    List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectOptions = bundleLineNumberWiseOptionsMap.get(Integer.valueOf(lineItemSO.Apttus_Config2__LineNumber__c));
                
                    if(selectOptions == null) {
                        selectOptions = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                        bundleLineNumberWiseOptionsMap.put(Integer.valueOf(lineItemSO.Apttus_Config2__LineNumber__c), selectOptions);
                    }
                    
                    for(Integer i = 2; i <= years; i++) {
                        Apttus_CPQApi.CPQ.SelectedOptionDO selectOption = getSelectOptionDO(lineItemSO, isStubsYearQuote, customFields);
                        selectOptions.add(selectOption);
                    }
                } else if (lineItemSO.APTS_Product_Configuration_Type__c == 'Standalone') {
                    for(Integer i = 2; i <= years; i++) {
                        Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = getSelectedProductDO(lineItemSO, isStubsYearQuote, customFields);
                        selectedProducts.add(selectedProduct);    
                    }
                }
            }
        }
        
        addProductsAndOptions(selectedProducts, bundleLineNumberWiseOptionsMap, productConfigId);
    }
    
    private static Boolean isRecurringStandaloneOrOptionLine(Apttus_Config2__LineItem__c lineItemSO, Set<Id> productIdSet) {
        String productId = (lineItemSO.Apttus_Config2__OptionId__c != null) ? lineItemSO.Apttus_Config2__OptionId__c : lineItemSO.Apttus_Config2__ProductId__c;
        
        if((lineItemSO.Apttus_Config2__OptionId__c != null || lineItemSO.APTS_Product_Configuration_Type__c == 'Standalone') && productIdSet.contains(productId)) {
            return true;
        }
        
        return false;
    }
    
    private static Apttus_CPQApi.CPQ.SelectedOptionDO getSelectOptionDO(Apttus_Config2__LineItem__c lineItemSO, Boolean isStubsYearQuote, List<String> customFields) {
        Apttus_CPQApi.CPQ.SelectedOptionDO selectOption = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                        
        selectOption.ComponentId = lineItemSO.Apttus_Config2__ProductOptionId__c;
        selectOption.ComponentProductId = lineItemSO.Apttus_Config2__OptionId__c;
        selectOption.Quantity = lineItemSO.Apttus_Config2__Quantity__c;
        selectOption.StartDate = lineItemSO.Apttus_Config2__StartDate__c;
        selectOption.EndDate = lineItemSO.Apttus_Config2__EndDate__c;
        
        if(isStubsYearQuote == false) {
            selectOption.SellingTerm = lineItemSO.Apttus_Config2__SellingTerm__c;
        } else {
            selectOption.SellingTerm = 1.0;
        }
        
        selectOption.CustomData = lineItemSO;
        selectOption.CustomFields = customFields;
        
        return selectOption;
    }
    
    private static Apttus_CPQApi.CPQ.SelectedProductDO getSelectedProductDO(Apttus_Config2__LineItem__c lineItemSO, Boolean isStubsYearQuote, List<String> customFields) {
        Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
                
        selectedProduct.ProductId = lineItemSO.Apttus_Config2__ProductId__c;
        selectedProduct.Quantity = lineItemSO.Apttus_Config2__Quantity__c;
        
        if(isStubsYearQuote == false) {
            selectedProduct.SellingTerm = lineItemSO.Apttus_Config2__SellingTerm__c;
        } else {
            selectedProduct.SellingTerm = 1.0;
        }
        
        selectedProduct.StartDate = lineItemSO.Apttus_Config2__StartDate__c;
        selectedProduct.EndDate = lineItemSO.Apttus_Config2__EndDate__c;
        selectedProduct.CustomData = lineItemSO;
        selectedProduct.CustomFields = customFields;
        
        return selectedProduct;
    }
    
    private static void addProductsAndOptions(List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts, Map<Integer, List<Apttus_CPQApi.CPQ.SelectedOptionDO>> bundleLineNumberWiseOptionsMap, String productConfigId) {
        if(!selectedProducts.isEmpty()) {
            Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
            request.CartId = productConfigId;
            request.SelectedProducts = selectedProducts;    
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
        }
        
        if(!bundleLineNumberWiseOptionsMap.isEmpty()) {
            for(Integer lineNumber : bundleLineNumberWiseOptionsMap.keySet()) {
                List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectOptions = bundleLineNumberWiseOptionsMap.get(lineNumber);
                
                Apttus_CPQApi.CPQ.AddOptionsResponseDO addOptionsResponse = Apttus_CPQApi.CPQWebService.addOptions(productConfigId, lineNumber, selectOptions);
            }
        }
    }
    
    public static void addAdditionalMYALines(List<Apttus_Config2__LineItem__c> allLines, Integer termsToAdd, Boolean isStubsYearQuote, String productConfigId) {
        List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        Map<Integer, List<Apttus_CPQApi.CPQ.SelectedOptionDO>> bundleLineNumberWiseOptionsMap = new Map<Integer, List<Apttus_CPQApi.CPQ.SelectedOptionDO>>();
        
        List<String> customFields = new List<String>();
        customFields.add('APTS_MYA_Lines_Unique_Key__c');
        //customFields.add('APTS_Promo_Code__c');
        //customFields.add('APTPS_PromoDiscountApplied__c');
        
        for(Apttus_Config2__LineItem__c lineItemSO : allLines) {
            if(lineItemSO.Apttus_Config2__OptionId__c != null) {
                List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectOptions = bundleLineNumberWiseOptionsMap.get(Integer.valueOf(lineItemSO.Apttus_Config2__LineNumber__c));
            
                if(selectOptions == null) {
                    selectOptions = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                    bundleLineNumberWiseOptionsMap.put(Integer.valueOf(lineItemSO.Apttus_Config2__LineNumber__c), selectOptions);
                }
                
                for(Integer i = 1; i <= termsToAdd; i++) {
                    Apttus_CPQApi.CPQ.SelectedOptionDO selectOption = getSelectOptionDO(lineItemSO, isStubsYearQuote, customFields);
                    selectOptions.add(selectOption);
                }
            } else if (lineItemSO.APTS_Product_Configuration_Type__c == 'Standalone') {
                for(Integer i = 2; i <= termsToAdd; i++) {
                    Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = getSelectedProductDO(lineItemSO, isStubsYearQuote, customFields);
                    selectedProducts.add(selectedProduct);    
                }
            }
        }
        
        addProductsAndOptions(selectedProducts, bundleLineNumberWiseOptionsMap, productConfigId);
    }
    */
    /************************** END OF MYA CODE *************************************************/
    
}