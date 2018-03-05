trigger HasSF_BOBO_MYA on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {
    Map<ID, Apttus_Proposal__Proposal__c> parentProposal3 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds3 = new List<Id>();
    List<Id> LineItems3 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds3.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems3.add(childObj.Id);
    }
  
    
    
    parentProposal3 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,SF_BOGO_MYA__c,(Select id from R00N70000001yUfBEAU__r ) FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds3]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem3: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal3 = parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c);
        if(parentProposal3.containsKey(ProposalLineItem3.Apttus_Proposal__Proposal__c) && parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal3.SF_BOGO_MYA__c = '';
        }
        
    }
    update parentProposal3.values();
 
    
    
    
 parentProposal3 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,SF_BOGO_MYA__c,(Select id from R00N70000001yUfBEAU__r where Product_name__c like '%SF-INTL%') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds3]);
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem3: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal3 = parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c);
        if(parentProposal3.containsKey(ProposalLineItem3.Apttus_Proposal__Proposal__c) && parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal3.SF_BOGO_MYA__c = 'BOGO';
        }
    }
    update parentProposal3.values();
    
        parentProposal3 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,SF_BOGO_MYA__c,(Select id from R00N70000001yUfBEAU__r where Product_name__c like '%SF-TR%') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds3]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem3: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal3 = parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c);
        if(parentProposal3.containsKey(ProposalLineItem3.Apttus_Proposal__Proposal__c) && parentProposal3.get(ProposalLineItem3.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal3.SF_BOGO_MYA__c = 'MYA';
        }
        
    }
    
    
    
    update parentProposal3.values();
}