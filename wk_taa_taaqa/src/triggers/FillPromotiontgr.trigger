trigger FillPromotiontgr on Apttus_Config2__LineItem__c (after insert) {
   // after config object is finalized and new config object is created when clicking configure products again. tihs trigger will use derived from field to fill promotions data to new line item.  
   Map <Id,Id> LineItemIdFromDerivedMap=new Map<Id,Id>();
   List <Line_Item_Promotion__c> lineitemPromotionList;
   List <Line_Item_Promotion__c> lineitemPromotionListToInsert=new List <Line_Item_Promotion__c>();
   Set <Id> derivedFromIdList;
   for(Apttus_Config2__LineItem__c lineItem:trigger.new)
   {
     if(lineItem.Apttus_Config2__DerivedFromId__c!=null)
     {
       LineItemIdFromDerivedMap.put(lineItem.Apttus_Config2__DerivedFromId__c,lineItem.Id);
     }
   }
   derivedFromIdList=LineItemIdFromDerivedMap.keyset();
   if(!derivedFromIdList.isEmpty())
   {
     lineitemPromotionList=[select Id,Line_ItemId__c,Promo__c,Promo_Code__c,Promo_Name__c from Line_Item_Promotion__c where Line_ItemId__c in:derivedFromIdList];
   }
   
   if(lineitemPromotionList!=null)
   {
     for(Line_Item_Promotion__c lineitemPromo:lineitemPromotionList)
     {
      Line_Item_Promotion__c lineItemPromoToInsert = new Line_Item_Promotion__c(Line_ItemId__c=LineItemIdFromDerivedMap.get(lineitemPromo.Line_ItemId__c),Promo__c=lineitemPromo.Promo__c,Promo_Code__c=lineitemPromo.Promo_Code__c,Promo_Name__c=lineitemPromo.Promo_Name__c);
      lineitemPromotionListToInsert.add(lineItemPromoToInsert);
     }
     insert lineitemPromotionListToInsert;
   }
   
}