trigger HasStandAloneProducts on Template_Line_item__c (before insert, before update) {



    Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (Template_Line_item__c childObj : Trigger.new) {
        listIds.add(childObj.Quote_Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Standalone_Product__c,(Select id from Template_Line_Items__r where Line_Type__C = 'Product/Service' and bundle_acro__c = '') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Template_Line_item__c TemplateLineItem: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(TemplateLineItem.Quote_Proposal__c);
        if(parentProposal.containsKey(TemplateLineItem.Quote_Proposal__c) && parentProposal.get(TemplateLineItem.Quote_Proposal__c).Template_Line_items__r.size() > 0)
        {
            myParentProposal.Has_Standalone_Product__c = 'Yes';
        }
        else
        {
            myParentProposal.Has_Standalone_Product__c = 'No' ;
        }
    }
    update parentProposal.values();
}