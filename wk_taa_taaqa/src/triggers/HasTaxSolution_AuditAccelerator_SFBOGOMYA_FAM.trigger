trigger HasTaxSolution_AuditAccelerator_SFBOGOMYA_FAM on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {


    Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Tax_Solution__c,(Select id from R00N70000001yUfBEAU__r where is_tax_Solution__c = true) FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c);
        if(parentProposal.containsKey(ProposalLineItem.Apttus_Proposal__Proposal__c) && parentProposal.get(ProposalLineItem.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal.Has_Tax_Solution__c = true;
        }
        else
        {
            myParentProposal.Has_Tax_Solution__c = false ;
        }
    }
    update parentProposal.values();
    
    Map<ID, Apttus_Proposal__Proposal__c> parentProposal1 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds1 = new List<Id>();
    List<Id> LineItems1 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds1.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems1.add(childObj.Id);
    }
  
    parentProposal1 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_Audit_Accelerator__c,(Select id from R00N70000001yUfBEAU__r where Product_family__c = 'CCH Audit Accelerator') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds1]);
    
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
    
     Map<ID, Apttus_Proposal__Proposal__c> parentProposal3 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds3 = new List<Id>();
    List<Id> LineItems3 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds3.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems3.add(childObj.Id);
    }
    update parentProposal3.values();
    
    
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
    
     Map<ID, Apttus_Proposal__Proposal__c> parentProposal4 = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds4 = new List<Id>();
    List<Id> LineItems4 = new List<Id>();

    for (Apttus_Proposal__Proposal_Line_Item__c childObj : Trigger.new) {
        listIds4.add(childObj.Apttus_Proposal__Proposal__c);
        LineItems4.add(childObj.Id);
    }
  
    parentProposal4 = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_FAM__c,(Select id from R00N70000001yUfBEAU__r where Product_Family__c = 'Fixed Assets Manager') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds4]);
    
    for (Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem4: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal4 = parentProposal4.get(ProposalLineItem4.Apttus_Proposal__Proposal__c);
        if(parentProposal4.containsKey(ProposalLineItem4.Apttus_Proposal__Proposal__c) && parentProposal4.get(ProposalLineItem4.Apttus_Proposal__Proposal__c).R00N70000001yUfBEAU__r.size() > 0)
        {
            myParentProposal4.Has_FAM__c = true;
        }
        else
        {
            myParentProposal4.Has_FAM__c = false ;
        }
    }
    update parentProposal4.values();
     
 }