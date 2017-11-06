/*
 * Trigger for Opportunty products replication from SFS org -> TAA org
 * */
trigger S2S_OpportunityLineItemTrigger on OpportunityLineItem (before insert) {
    // this is to turn off the trigger based on the flag by using custom settings S2S_Trigger_Control__c
    Boolean isTriggerOff = S2S_Util.fetchTriggerOffFlag('OpportunityLineItem');
    if(!isTriggerOff) {
        // processing logic for trigger 
        if(Trigger.isBefore && Trigger.isInsert) {
            S2S_OpportunityLineItemTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }    
}