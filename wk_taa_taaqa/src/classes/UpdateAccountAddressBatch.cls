global class UpdateAccountAddressBatch implements Database.Batchable<sObject> {
    
    public String query;
    public String queryCount;
  
  global Database.queryLocator start(Database.BatchableContext bc){
       UpdateAccountAddressBatchController controller = new UpdateAccountAddressBatchController();
       Datetime accountXrefHistoryDate=System.today();
       List<Monitoring_Log__c>errorRecordslist=new  List<Monitoring_Log__c>();
       
       List<AsyncApexJob> asyncApexJobList= [SELECT CompletedDate, Status, ApexClass.Name FROM AsyncApexJob where 
       ApexClass.Name='UpdateAccountAddressBatch' and Status='Completed' order by CompletedDate desc limit 1 ]; 
       
       if(asyncApexJobList.size()>0){
           for(AsyncApexJob asyncJob:asyncApexJobList){
             accountXrefHistoryDate=asyncJob.CompletedDate;
             system.debug('accountXrefHistoryDate****'+accountXrefHistoryDate);
           }
       }
       
      /* String[] accountXrefLastExecutedDate=String.ValueOf(accountXrefHistoryDate.addHours(8)).split(' ');
       String lastExceutedBatchDate=accountXrefLastExecutedDate[0]+'T'+accountXrefLastExecutedDate[1]+'Z';*/
       
       String lastExceutedBatchDate=accountXrefHistoryDate.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');
       system.debug('lastExceutedBatchDate**'+lastExceutedBatchDate);
       
       queryCount=QueryServiceClass.getAccountXReferenceHistoryCount(lastExceutedBatchDate);
       system.debug('queryCount**'+queryCount);
       
       Integer countRows = Database.countQuery(queryCount);
       system.debug('Counter Value**'+countRows);
       
       query = 'Select Id from Account_X_Reference__History limit 0';
        
        if(countRows<1){
            Monitoring_Log__c m = new Monitoring_Log__c();
            m.Name = 'Account address automation';
            m.Detail__c = 'No Application Account records processed. No records have been found in Account X reference history table.';
            m.Type__c = WK_Exception.ADM_NO_RECORDS_FOUND_IN_HISTORY;
            errorRecordslist.add(m);
        }
        else if(countRows > controller.taaCusSet.maxDailyLimit__c){
             Monitoring_Log__c m = new Monitoring_Log__c();
             m.Name = 'Account address automation';
             m.Detail__c = 'Maximum daily application limit of '+' ' +controller.taaCusSet.maxDailyLimit__c+' '+'exceeded.'+ ' '+ CountRows +' No. of records found in Account x reference history table. Hence no processing executed.';
             m.Type__c = WK_Exception.ADM_EXCEPTION_DALIY_LIMIT_EXCEEDED;
             errorRecordslist.add(m);    
          }
        
        else{
            query = QueryServiceClass.getAccountXReferenceHistory(lastExceutedBatchDate);
            system.debug('query**'+query);
        }
       
        if(errorRecordslist.size() > 0){
            Database.insert(errorRecordslist,false);
         }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<sObject>scope){
     AsyncApexJob  job= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from AsyncApexJob where Id = :bc.getJobId()];  
       List<Monitoring_Log__c>errorRecordslist=new  List<Monitoring_Log__c>();
       try{ 
            List<Account_X_Reference__History> updateAbleAccountXRefsHistory = (List<Account_X_Reference__History>)scope;
            
            UpdateAccountAddressBatchController controller = new UpdateAccountAddressBatchController();
            system.debug('updateAbleAccountXRefsHistory.size()****'+updateAbleAccountXRefsHistory.size());
            
            if(updateAbleAccountXRefsHistory.size() > 0){
               controller.processAccountXReferenceHistory(updateAbleAccountXRefsHistory,job);
             } 
             
         }catch(WK_Exception e){
                  Monitoring_Log__c m = new Monitoring_Log__c();
                  m.Name = 'Account automation';
                  m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                  m.Type__c = WK_Exception.ATA_CODE_ERROR;
                  errorRecordslist.add(m);
          }
         if(errorRecordslist.size() > 0){
                Database.insert(errorRecordslist,false);
         }
         
    }
    global void finish(Database.BatchableContext bc){
        
    }
}