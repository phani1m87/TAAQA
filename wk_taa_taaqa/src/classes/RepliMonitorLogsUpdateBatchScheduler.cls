global class RepliMonitorLogsUpdateBatchScheduler implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		RepliMonitorLogsUpdateBatch job = new RepliMonitorLogsUpdateBatch();
		Database.executeBatch(job);
    }
}