/*
 * Trigger for Opportunty products replication from SFS org -> TAA org
 * */
trigger TSM_OpportunityLineItemTrigger on OpportunityLineItem (before insert) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('OpportunityLineItem');
    if(!isTriggerOff) {
        // processing logic for trigger 
        if(Trigger.isBefore && Trigger.isInsert) {
            TSM_OpportunityLineItemTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }    
}