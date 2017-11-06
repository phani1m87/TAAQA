/*
 * trigger to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2016 Raj               1.0         Initial draft
 * ------------------------------------------------------------------------- */
trigger TSM_AccountTrigger on Account (after insert) {
    // this is to turn off the trigger based on the flag by using custom settings TSM_Trigger_Control__c
    Boolean isTriggerOff = TSM_Util.fetchTriggerOffFlag('Account');
    if(!isTriggerOff) {
        // after insert the new accounts
        if(Trigger.isAfter && Trigger.isInsert) {
            TSM_AccountTriggerHandler.onAfterInsert(Trigger.new);
        }
    }    
}