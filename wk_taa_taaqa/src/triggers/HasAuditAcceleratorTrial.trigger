trigger HasAuditAcceleratorTrial on Apttus_Proposal__Proposal_Line_Item__c (after insert,after update) {
 Map<ID, Apttus_Proposal__Proposal__c> parentProposal2 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds2 = new List<Id>();
    List<Id> LineItems2 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds2.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems2.add(childObj.Id);
    }
  
    parentProposal2 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Audit_Accelerator_Trial__c,(Select id from R00N70000001yUfBEAU__r where Product_code__c = '10046987-0001') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds2]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem2: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal2 = parentProposal2.get(ProposalLineItem2.Apttus_Proposal__Proposal__c);
        if(parentProposal2.containsKey(ProposalLineItem2.Apttus_Proposal__Proposal__c) && parentProposal2.get(ProposalLineItem2.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal2.Has_Audit_Accelerator_Trial__c = true;
        }
        else
        {
            myParentProposal2.Has_Audit_Accelerator_Trial__c = false ;
        }
    }
    update parentProposal2.values();

}