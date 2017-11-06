/*
 * trigger to perform the below opportunity operations
 * 1. Add Overlay Opportunity Split User  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 05/01/2017 SHIVAJI           1.0          Initial draft
 * ------------------------------------------------------------------------- */
trigger UpdateOpportunitySplit on Opportunity (after insert, after update){ 
    // this is to turn off the trigger based on the flag by using custom settings Trigger_Control__c
    Map<String, Trigger_Control__c> mapTriggerControlSetting = Trigger_Control__c.getAll(); 
    Boolean isTriggerOff = mapTriggerControlSetting.get('executeOpportunityTrigger') != NULL ? mapTriggerControlSetting.get('executeOpportunityTrigger').isTriggerOff__c : TRUE;
    if(!isTriggerOff){    
        // for after insert
        if(Trigger.isAfter && Trigger.isInsert) {
            OpportunitySplitHandler.onAfterInsert(trigger.new);        
        }
        // for after update 
        if(Trigger.isAfter && Trigger.isUpdate) {
            OpportunitySplitHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
    }    
}