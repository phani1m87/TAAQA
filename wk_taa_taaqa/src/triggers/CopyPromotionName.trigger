trigger CopyPromotionName on Apttus_Proposal__Proposal_Line_Item__c (before insert,before update) {

  Map<String,String> PromotionLookup = new Map<String,String>();
  Set<String> PromotionCode = new Set<String>();    

  for(Apttus_proposal__proposal_line_Item__c p:Trigger.new) {
    PromotionCode.add(p.apts_promo_code__c);
    
  }
 
  
  
  
  for(Promotion__c QP:

    [SELECT      name,promo_code__c
     FROM        Promotion__c
     WHERE       promo_code__c IN :PromotionCode]) {

     PromotionLookup.put(QP.Promo_Code__c, QP.Name);
  }

  for(Apttus_proposal__proposal_line_Item__c p:Trigger.new) {

    if(PromotionLookup.containsKey(p.apts_Promo_Code__c)) {
      p.Promotion_Name__C = PromotionLookup.get(p.apts_Promo_Code__c);
    }
  }
}