trigger AssociationPromotionName on Quote_promotion__c (after insert, after update) { 
  Map<ID, apttus_proposal__proposal__c> parentProposal = new Map<ID, apttus_proposal__proposal__c>(); 
  List<Id> listIds = new List<Id>();

  for (Quote_promotion__c childObj : Trigger.new)  {
    listIds.add(childObj.quote_proposal__c);
  }

 
  parentProposal = new Map<Id, apttus_proposal__proposal__c>([SELECT id,has_association_promotion__c, Promotion_name__c,(SELECT ID, promoname__c FROM promotion_groups__r where promotion_code__c like'Assoc%') FROM apttus_proposal__proposal__c WHERE ID IN :listIds]);

  for (Quote_Promotion__c quotePromotion: Trigger.new){
     apttus_proposal__proposal__c myParentProposal = parentproposal.get(quotePromotion.Quote_Proposal__c);
     myParentProposal.Promotion_name__c = quotePromotion.Promoname__c;
     myParentProposal.Has_Association_Promotion__C = true;
  }

  update parentProposal.values();
}