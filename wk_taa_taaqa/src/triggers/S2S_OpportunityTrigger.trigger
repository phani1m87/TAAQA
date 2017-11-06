/*
 * trigger to perform the S2S records replication for TAA <-> SFS orgs  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/10/2017 Raj Gonola       1.0      Initial draft
 * ------------------------------------------------------------------------- */
trigger S2S_OpportunityTrigger on Opportunity (before insert,before update, after insert,after update,after delete) {
    // this is to turn off the trigger based on the flag by using custom settings S2S_Trigger_Control__c&& !S2S_OpportunityTriggerHandler.alreadyProcessed
    Boolean isTriggerOff = S2S_Util.fetchTriggerOffFlag('Opportunity');
    if(!isTriggerOff ) {    
        
        // for after update
        if(Trigger.isAfter && Trigger.isUpdate) {
           S2S_OpportunityTriggerHandler.opponAfterupdate(Trigger.newMap, Trigger.oldMap);        
        }
        
        //for before update
        if(Trigger.isBefore && Trigger.isUpdate) {
           S2S_OpportunityTriggerHandler.opponBeforeupdate(Trigger.newMap, Trigger.oldMap);        
        }
        
        // processing logic for deleted records
        if(Trigger.isAfter && Trigger.isDelete) {
            S2S_OpportunityDeletionTriggerHandler.onAfterDelete(Trigger.old);
        }
    }    
}