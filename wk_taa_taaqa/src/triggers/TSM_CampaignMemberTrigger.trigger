/*
 * Generic trigger for CampaignMember Object. Calls the trigger handler class for specific events.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/16/2016 Vinay             1.0         Initial draft
 * ------------------------------------------------------------------------- */
trigger TSM_CampaignMemberTrigger on CampaignMember ( before insert, after insert) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('CampaignMember');
    if(!isTriggerOff && !TSM_CampaignMemberTriggerHandler.alreadyProcessed) {    
        if(Trigger.isInsert){
            if (Trigger.isBefore) {
                //call your handler.after method
                TSM_CampaignMemberTriggerHandler.setFieldsOnCreate(Trigger.new);
            }
            if (Trigger.isAfter) {
                //call your handler.after method
                TSM_CampaignMemberTriggerHandler.generateLead(Trigger.new);
            }
        }
    }    
}