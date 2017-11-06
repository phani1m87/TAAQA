/*
    **************************************************************************
    Name    :   QuoteProposalTriggerHandler 
    Usage   :   This trigger is used to update ERP Ship To/Bill To on Quote proposal based on ERP 
                Account/Ship To Account is populated 
    
    Version    |    Name            |    Date           
    1.0             Rajesh Meti          17-Nov-2014  
    
    Trigger : QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update)
    
    ***************************************************************************
*/

trigger QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update) {

    if(!QuoteProposalTriggerHandler.hasAlreadyRunMethod()){
        QuoteProposalTriggerHandler handler = new QuoteProposalTriggerHandler(); 
        
        //for before insert event
        if(Trigger.isBefore && Trigger.isInsert) {
        	//*** SMS-930 Prod Troubleshooting
        	APTPS_ProposalTgrHelper.defaultPriceList(trigger.new); 
            handler.onBeforeInsert(Trigger.New, Trigger.newMap);
        }
    
        //for before update event
        if(Trigger.isBefore && Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.New, Trigger.Old, Trigger.newMap, Trigger.oldMap);       
        }
        QuoteProposalTriggerHandler.setAlreadyRunMethod(); 
    }
}