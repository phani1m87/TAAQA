trigger TeamMateRenewal on Quote_Promotion__c (after insert,after update,before delete) {
Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();
    
    If(trigger.Isdelete){
for (Quote_Promotion__c childObj : Trigger.old) {
        listIds.add(childObj.Quote_Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_TeamMate_Promotion__c,(Select id from Promotion_Groups__r where Promotion_Code__c = 'TMA') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Quote_Promotion__c QPromo: Trigger.old){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(QPromo.Quote_Proposal__c);
        if(parentProposal.containsKey(QPromo.Quote_Proposal__c) && parentProposal.get(QPromo.Quote_Proposal__c).Promotion_Groups__r.size() > 0)
        {
            myParentProposal.Has_TeamMate_Promotion__c = false;
        }
       
    }
    update parentProposal.values();
    }
    
if(Trigger.IsInsert)
{
    for (Quote_Promotion__c childObj : Trigger.new) {
        listIds.add(childObj.Quote_Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_TeamMate_Promotion__c,(Select id from Promotion_Groups__r where Promotion_Code__c = 'TMA') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Quote_Promotion__c QPromo: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(QPromo.Quote_Proposal__c);
        if(parentProposal.containsKey(QPromo.Quote_Proposal__c) && parentProposal.get(QPromo.Quote_Proposal__c).Promotion_Groups__r.size() > 0)
        {
            myParentProposal.Has_TeamMate_Promotion__c = true;
        }
        
    
    update parentProposal.values();
    }
   } 
   if(Trigger.IsUpdate)
{
    for (Quote_Promotion__c childObj : Trigger.new) {
        listIds.add(childObj.Quote_Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Has_TeamMate_Promotion__c,(Select id from Promotion_Groups__r where Promotion_Code__c = 'TMA') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    
    for (Quote_Promotion__c QPromo: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(QPromo.Quote_Proposal__c);
        if(parentProposal.containsKey(QPromo.Quote_Proposal__c) && parentProposal.get(QPromo.Quote_Proposal__c).Promotion_Groups__r.size() > 0)
        {
            myParentProposal.Has_TeamMate_Promotion__c = true;
        }
        
    
    update parentProposal.values();
    }
   } 
}