trigger Has_Audit_Accelerator on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {
 Map<ID, Apttus_Proposal__Proposal__c> parentProposal1 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds1 = new List<Id>();
    List<Id> LineItems1 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds1.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems1.add(childObj.Id);
    }
  
    parentProposal1 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Audit_Accelerator__c,(Select id from R00N70000001yUfBEAU__r where Product_Family__c = 'CCH Audit Accelerator') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds1]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem1: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal1 = parentProposal1.get(ProposalLineItem1.Apttus_Proposal__Proposal__c);
        if(parentProposal1.containsKey(ProposalLineItem1.Apttus_Proposal__Proposal__c) && parentProposal1.get(ProposalLineItem1.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal1.Has_Audit_Accelerator__c = true;
        }
        else
        {
            myParentProposal1.Has_Audit_Accelerator__c = false ;
        }
    }
    update parentProposal1.values();

}