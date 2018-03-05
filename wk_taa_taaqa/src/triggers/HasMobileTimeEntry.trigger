trigger HasMobileTimeEntry on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {
 Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Mobile_Time_Entry__c,(Select id from R00N70000001yUfBEAU__r where is_mobile_time_entry__c = True) FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c);
        if(parentProposal.containsKey(ProposalLineItem.Apttus_Proposal__Proposal__c) && parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal.Has_Mobile_Time_Entry__c = true;
        }
        else
        {
            myParentProposal.Has_Mobile_Time_Entry__c = false ;
        }
    }
    update parentProposal.values();
}