/*
 * Batch apex process to remove the shared Opportunity Product records from the TAA Environment  
 * It will only process the Opportunity Products which were successfully deleted from SFS Org
 * Batch class: TSM_RemoveDeletedOpportunityProductBatch
 * Batch Scheduler: TSM_RemoveDeletedOpptyProductScheduler
 * Frequency: every 10 seconds (can be changed by using below custom settings)
 * Custom Settings: TSM_Custom_Settings.ScheduleSecondFrequency__c (10)  
 *
 *--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 1/26/2017  Abi				1.0			Initial draft
 * ------------------------------------------------------------------------- 
 * Instructions to enable the batch scheduling time using TSM_Custom_Settings.ScheduleSecondFrequency__c
 * Need to set the value or change the frequency by seconds example: 10 
 * SET/CHANGE Batch frequency: Setup -> Develop -> Custom Settings -> TSM_Custom_Settings__c -> Manage -> enter
 *							ScheduleSecondFrequency__c = 10
 * START Batch: using Developer Console - Execute anonymous: 
 * 						Database.executeBatch(new TSM_RemoveDeletedOpportunityProductBatch());
 * STOP Batch: Scheduled Jobs : Delete the batch with the name 'TSM_RemoveDeletedOpportunityProductBatch - %' 
 * 				which is scheduled to run in future time.
 */
public class TSM_RemoveDeletedOpptyProductScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        TSM_RemoveDeletedOpportunityProductBatch rcb = new TSM_RemoveDeletedOpportunityProductBatch();
        Database.executeBatch(rcb, 200);  
        // for purging the completed scheduled job
        System.abortJob(sc.getTriggerId());
    }        
}