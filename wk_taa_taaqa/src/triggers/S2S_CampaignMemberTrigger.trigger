/*
 * Generic trigger for CampaignMember Object. Calls the trigger handler class for specific events.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/16/2016 Vinay        1.0      Initial draft
 * 11/09/2017 Shivaji      1.1      SMS-911
 * ------------------------------------------------------------------------- */
trigger S2S_CampaignMemberTrigger on CampaignMember (before insert, after insert) 
{
  	// this is to turn off the trigger based on the flag by using custom settings S2S_Trigger_Control__c
    Boolean isTriggerOff = S2S_Util.fetchTriggerOffFlag('CampaignMember');
    if(!isTriggerOff && !S2S_CampaignMemberTriggerHandler.alreadyProcessed) 
    {    
        if(Trigger.isInsert)
        {
            if(Trigger.isBefore) {
                //call your handler.after method
                S2S_CampaignMemberTriggerHandler.setFieldsOnCreate(Trigger.new);
            }
            if (Trigger.isAfter) {
                //call your handler.after method
                S2S_CampaignMemberTriggerHandler.generateLead(Trigger.new);
            }
        }
    }    
}