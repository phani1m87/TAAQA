global class MassUpdateAccountBatch implements Database.Batchable<sObject> {
    public String query = null;
   // public TAACustomSetting__c taaCusSet =UtilCustomSettings.TAACustomSetting();
    public AccountAutomationSetting__c taaCusSet =UtilCustomSettings.TAACustomSetting();
    /*public String header = 'Account Name, Account Id \r\n';
    public String finalStr = header;
    public String recordStr;*/
    global Database.queryLocator start(Database.BatchableContext bc){
        set<String> setDirtyZipcodeDTN= new set<String>();
        for(ZipCodeDTN__c z : [Select Name from ZipCodeDTN__c where IsUpdated__c=true]){
            setDirtyZipcodeDTN.add(z.Name);
        }
        List<String>dirtyZipcodeDTNList= new List<String>();
        for (String s:setDirtyZipcodeDTN){
            dirtyZipcodeDTNList.add(s+'%');
        }
        System.debug('Size Of updated dirtyZipcodeDTNList'+dirtyZipcodeDTNList.size());
        if (dirtyZipcodeDTNList.size()>0)
            query=QueryServiceClass.massUpdateAccountStr+' ' +'OR BillingPostalCode Like : dirtyZipcodeDTNList)';
         else
            query= QueryServiceClass.massUpdateAccountStr +')';
            System.debug('Query for Batch>>>>>>>>>>>>>'+query);
        //query = QueryServiceClass.massUpdateAccountStr+' '+'OR BillingPostalCode in :setDirtyZipcodeDTN)';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<sObject>scope){
         AsyncApexJob  job= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];  
        //Set trigger off to run before starting batch process on Accounts update
        /*if(taaCusSet.IsTriggerOff__c ==false){
            taaCusSet.IsTriggerOff__c =true;
            update taaCusSet;
        }*/
        List<Account> updateAbleAccounts = (List<Account>)scope;
        /*for(Account a : updateAbleAccounts){
          recordStr += '"'+a.Name+'","'+a.Id+'"\r\n';
        }*/
        MassUpdateAccountBatchController controller = new MassUpdateAccountBatchController();
        controller.updateDTNAndSegmentAndSubsegment(updateAbleAccounts,job.id);
    }
    global void finish(Database.BatchableContext bc){
        //Set trigger on to run after batch process on Accounts update finished
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,ExtendedStatus,
         TotalJobItems, CreatedBy.Email
         FROM AsyncApexJob WHERE Id =
                :BC.getJobId()];
   
        Monitoring_Log__c m = LoggerUtil.createErrorRecord('MassUpdateAccountBatch','MassUpdateAccountBatchController','finish',
         'The batch Apex job processed ' + a.TotalJobItems +
               ' batches with '+ a.NumberOfErrors + ' failures.' +'\n' + a.ExtendedStatus);
        m.Apex_Job_ID__c= a.Id; 
        m.Type__c='ATA_MassUpdateAccountBatch';       
        insert m;
         //finalStr +=recordStr;
         //MassUpdateAccountBatchController.attachFileToMonitoringLog(finalStr, m.Id);
         
             
    }

}