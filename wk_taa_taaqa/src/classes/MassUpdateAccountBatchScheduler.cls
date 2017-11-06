global class MassUpdateAccountBatchScheduler implements Schedulable{
	global void execute(SchedulableContext sc){
		MassUpdateAccountBatch job = new MassUpdateAccountBatch();
		Database.executeBatch(job);
	}
}