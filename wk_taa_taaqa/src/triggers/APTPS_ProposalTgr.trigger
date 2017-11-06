/* 
  Author: Venkata Sabbella
  Last Modified Date: 01/07/2015.
  Last Modified Date: 2/26/2015 - kraman@apttus.com.

*/

trigger APTPS_ProposalTgr on Apttus_Proposal__Proposal__c (before insert, before update,after update) {
     
    //for update
    if( trigger.isbefore && 
        trigger.isUpdate && 
        !APTPS_ProposalTgrHelper.proposalTriggerMap.get('beforeupdate'))   
    {
        //recursive prevention
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeupdate',true);
        APTPS_ProposalTgrHelper.applyInformation(trigger.new); 
        //APTPS_ProposalTgrHelper.updateTrainingConsulting(trigger.new);
        APTPS_ProposalTgrHelper.updateTrainingConsulting(trigger.new);
        APTPS_ProposalTgrHelper.resetProposalStatus(trigger.newMap,trigger.oldMap);
        APTPS_ProposalTgrHelper.updateQuoteStage(trigger.new);
        //processproposalLinesUpdatesAPTPS_ProposalTgrHelper.processproposalLinesUpdates(trigger.newmap,trigger.oldmap);
        APTPS_ProposalTgrHelper.processproposalsForMinUplift(trigger.new);
        APTPS_ProposalTgrHelper.enforcePricingForstubdateUpdates(trigger.newmap,trigger.oldmap);
        APTPS_ProposalTgrHelper.enforeRepricingLineItems(trigger.new, trigger.oldMap);
        APTPS_ProposalTgrHelper.enforcePricingForConcurrentUsers(trigger.newmap,trigger.oldmap);
        
    } 
    
    //recursive prevention
    if(trigger.isinsert 
       && trigger.isbefore
       && !APTPS_ProposalTgrHelper.proposalTriggerMap.get('beforeinsert'))
    {
        //recursive prevention
        APTPS_ProposalTgrHelper.proposalTriggerMap.put('beforeinsert',true);
        APTPS_ProposalTgrHelper.applyInformation(trigger.new); 
        APTPS_ProposalTgrHelper.defaultPriceList(trigger.new); 
         
    }
    
    if(trigger.isupdate
       && trigger.isafter 
       && !APTPS_ProposalTgrHelper.proposalTriggerMap.get('afterupdate'))
   {
      APTPS_ProposalTgrHelper.proposalTriggerMap.put('afterupdate',true);   
     
      APTPS_ProposalTgrHelper.processproposalLinesforTemplates(trigger.newmap,trigger.oldmap);
      
      
      
      //commented by Ganga per Derrick's request
      //APTPS_ProposalTgrHelper.addRemoveMYALines(trigger.new, trigger.newMap, trigger.oldMap);
     //end
      APTPS_ProposalTgrHelper.updatePaymentTermsType(trigger.new, trigger.oldMap);
   }
    

}