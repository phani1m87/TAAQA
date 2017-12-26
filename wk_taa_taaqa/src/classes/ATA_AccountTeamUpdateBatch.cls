/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/12/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
global class ATA_AccountTeamUpdateBatch implements Database.Batchable<sObject> 
{
    // **** batchable to perform mass account team computation
    
    Boolean isDeleteExistingNRecreate = false;				// flag to decide the mode to run ATA
    Monitoring_Log__c startLog;								// start log
    
    // *** constructor to set the class variables
    public ATA_AccountTeamUpdateBatch(Boolean isDeleteExistingNRecreate, Monitoring_Log__c startLog)
    {
    	// set the flag to decide the mode to run
    	this.isDeleteExistingNRecreate = isDeleteExistingNRecreate;
    	this.startLog = startLog;
    }
    
    // start method
    global Database.queryLocator start(Database.BatchableContext bc)
    {
		// set apex job id to the start log
        this.startLog.Apex_Job_ID__c = bc.getJobId();
        insert startLog;
		
		// query locator to find affected accounts
		return Database.getQueryLocator(QueryServiceClass.queryToFindAffectedAccounts);	
    }
    
    // execute method
	global void execute(Database.BatchableContext bc, List<sObject> scope)
	{
     	// set apex job id to log into Monitoring Log
     	ATA_AccountTeamHandler.apexJobId = bc.getJobId();
     	
     	// call rule engine with list of accounts
     	ATA_AccountTeamHandler.generateAccountTeam((List<Account>)scope, isDeleteExistingNRecreate);
	}
	
	// finish method
	global void finish(Database.BatchableContext bc)
	{
		//List<Monitoring_Log__c> lstMonitoringLog = new List<Monitoring_Log__c>();
		
		// log batch result
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, ExtendedStatus, TotalJobItems, CreatedBy.Email
     					  FROM AsyncApexJob 
     					  WHERE Id =: bc.getJobId()];
   
        String logMessage = 'The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.' +'\n'; 
        if(a.ExtendedStatus != NULL){
        	logMessage = logMessage + ' Status : ' + a.ExtendedStatus;
        }
        
        String finishLogCode = ATA_Constants.ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_SUCCESS_CODE;
        // check if there are any errors then flip the log code
        if(a.NumberOfErrors > 0){
        	finishLogCode = ATA_Constants.ATA_ACCOUNTTEAM_UPDATEBATCH_FINISH_FAILURE_CODE;
        }					
        
        // prepare finish monitoring log
        Monitoring_Log__c finishLog = ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_AccountTeamUpdateBatch', 'finish', logMessage, null, finishLogCode);
        finishLog.Apex_Job_ID__c = a.Id;
        
        //lstMonitoringLog.add(startLog);
        //lstMonitoringLog.add(finishLog);
			
		// DML: insert start and finish monitoring logs               
        insert finishLog;
	}
}