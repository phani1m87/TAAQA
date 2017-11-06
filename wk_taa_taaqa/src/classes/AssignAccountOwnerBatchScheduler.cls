/*
 * Scheduler class for AssignAccountOwnerBatch.
 * Batch size kept 50 considering operations after account update. 
 * Account Owner Fields Assignment: SMS-858  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 07/05/2017 PIYUSH            1.0          Initial draft
 * ------------------------------------------------------------------------- */
global class AssignAccountOwnerBatchScheduler implements Schedulable{
	global void execute(SchedulableContext sc){
		AssignAccountOwnerBatch job = new AssignAccountOwnerBatch();
		Database.executeBatch(job,50);
	}
}