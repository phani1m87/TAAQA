/*
 * trigger on custom object TSM_Shared_Product__c for replicating the opportunity products from SFS to TAA
 * This is an intermediate object which is being shared between SFS and TAA. 
 * Note: As we are not sharing the products, it is not possible to share the Opportunity products between 2 orgs.
 * */
trigger TSM_SharedProductTrigger on TSM_Shared_Product__c (after insert, after update) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('TSM_Shared_Product__c');
    if(!isTriggerOff) {
        // processing the records to create the respective opportunity line items records
        if(Trigger.isAfter && Trigger.isInsert) {
            TSM_SharedProductTriggerHandler.onAfterInsert(Trigger.new);
        }
        // processing the updated records to reflect the changes to respective opportunity line items
        if(Trigger.isAfter && Trigger.isUpdate) {
            TSM_SharedProductTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }    
}