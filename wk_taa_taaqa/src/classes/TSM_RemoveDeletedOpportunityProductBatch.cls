/*
 * Batch class for Remove the shared Opportunity Product records from the TAA Environment 
 * when they have been deleted from the Source Environment.
 * It will only process the Opportunity Products which were successfully replicated from SFS -> TAA
 * Batch class: TSM_RemoveDeletedOpportunityProductBatch
 * Batch Scheduler: TSM_RemoveDeletedOpportunityProductScheduler
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

global class TSM_RemoveDeletedOpportunityProductBatch implements Database.Batchable<sObject> {
	
	global string queryString = '';
	
	public TSM_RemoveDeletedOpportunityProductBatch() { 
		if(Test.isRunningTest())
			queryString = 'Select Id, SFS_Oppty_Product_Record_ID__c from TSM_Shared_Product__c';
		else
			queryString = 'Select Id, SFS_Oppty_Product_Record_ID__c from TSM_Shared_Product__c where Id IN (Select LocalRecordId from PartnerNetworkRecordConnection where PartnerRecordID = NULL and Status =\'Inactive\') ';
    }
	
	// fetch all the new opportunities are replicated from TAA to SFS
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    
    // process the selected opportunity products
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
    	 List<TSM_Shared_Product__c> sharedProducts = (List<TSM_Shared_Product__c>) scope;
    	 Set<String> prodIds = new Set<String>();
    	 for (TSM_Shared_Product__c prod : sharedProducts) {
    	 	prodIds.add(prod.SFS_Oppty_Product_Record_ID__c);
    	 }
    	 
    	 List<OpportunityLineItem> prodList = [Select Id from OpportunityLineItem where SFS_Opportunity_Product_Record_ID__c IN: prodIds];
    	 if(!prodList.IsEmpty()) {
	    	// Delete the Shared Opportunity Product records from TAA Environment
			Database.delete(prodList, false);
    	 }
    }
    
    public void finish(Database.BatchableContext bc) {
        // finish to start the next batch
        // scheduled time must be mentioned in seconds
    	TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
        //Integer minutesGap = Integer.valueOf(tsmCS.ScheduleMinuteFrequency__c);
    	Integer secondsGap = Integer.valueOf(tsmCS.ScheduleSecondFrequency__c); 
    	DateTime scheduledTime = DateTime.now().addSeconds(secondsGap);
    	String timeString = scheduledTime.format( 'yyyy-MM-dd HH:mm:ss' );
    	String cronString = scheduledTime.format( 's m H d M ? yyyy' );
    	System.schedule('TSM_RemoveDeletedOpportunityProductBatch - ' + timeString + ' (' + Math.random() + ')', cronString, new TSM_RemoveDeletedOpptyProductScheduler() );
    } 
}