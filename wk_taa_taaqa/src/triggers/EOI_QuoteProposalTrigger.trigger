trigger EOI_QuoteProposalTrigger on Apttus_Proposal__Proposal__c(after update) 
{
	
	EOI_QuoteProposalTriggerHandler aptsQuoteProposalHander = new EOI_QuoteProposalTriggerHandler();
     
	//EOI_Order_Integration__c orderSetting = EOI_Order_Integration__c.getInstance();
	if(WK_Utility.ServiceIntegrations().IsERPOrderCreationFromQuoteProposalOn__c)
	{  
		if(trigger.isupdate && trigger.isafter)
		{
			Map<Id,Apttus_Proposal__Proposal__c> oldProposalMap = trigger.OldMap;
          	for(Apttus_Proposal__Proposal__c aptusProposals : trigger.new)
          	{
				//#TechnicalDebt If we need to have a custom setting to manage the stage.
				if(EOI_QuoteProposalTriggerHandler.firstRun && aptusProposals.Eligible_for_Order_Automation__c)
            	{
             		if(aptusProposals.Apttus_Proposal__Approval_Stage__c == 'Submitted to COP' && aptusProposals.Approved_for_Order_Automation__c && (oldProposalMap.get(aptusProposals.Id).Apttus_Proposal__Approval_Stage__c != 'Submitted to COP' ||  oldProposalMap.get(aptusProposals.Id).Approved_for_Order_Automation__c == false))
             		{
                  		system.debug('In Trigger EOI_QuoteProposalTrigger');
                  		EOI_QuoteProposalTriggerHandler.firstRun = false; 
                  		aptsQuoteProposalHander.onAfterUpdate(trigger.new);
                	}
            	}
         	}
      	}
	}
}