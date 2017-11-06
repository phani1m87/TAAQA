trigger ProfessionalServices on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {

    Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Professional_Services__c,(Select id from R00N70000001yUfBEAU__r where professional_services_product__c = true) FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    //Please use child relationship name in place of Apttus_Proposal__Proposal_Line_Items__r
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c);
        if(parentProposal.containsKey(ProposalLineItem.Apttus_Proposal__Proposal__c) && parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal.Has_Professional_Services__c = true;
        }
        else
        {
            myParentProposal.Has_Professional_Services__c = false ;
        }
    }
    update parentProposal.values();
 }