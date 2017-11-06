global class UpdateAccountAddressBatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
       UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
       Database.executeBatch(job);
    }
}