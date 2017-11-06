/**
  *  Author: Salesforce Services
  *  Description: Apex Job to do Mass Account Merge based on DWL provided data.
  *  Params: This job accepts one parameter:
  *          1. Batch Id - Unique identifies a batch of records, typically a file. 
  *                        The job merges records that belongs to only that batchid.
  */

global class MassAccountMerge implements Database.Batchable<sObject>{
   global final String MassMergeBatchId;
   
   /*
    * Constructor for MassAccountMerge
    * @Param: Batch Id - Unique Batch Id assigned for Mass Merge.
    */
   global MassAccountMerge(String batchId){
      MassMergeBatchId = batchId;
   }

   /*
    * @Method: Start
    * @Description: Prepares query for records to merge.
    * @Param: Batch Id - Unique Batch Id assigned for Mass Merge.
    */
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT Id, Merge_To_Account_used_by_MassMerge__c from Account WHERE MassMerge_Batch_Id_used_by_MassMerge__c =\'' + MassMergeBatchId + '\'');
   }

   /*
    * @Method: execute
    * @Description: Merge the accounts in batches.
    * @Param: Batch Id - Unique Batch Id assigned for Mass Merge.
    */
   global void execute(Database.BatchableContext BC, List<sObject> scope){
     for(sObject s : scope){
         Account mergeToAccount = new Account(Id = (Id)s.get('Merge_To_Account_used_by_MassMerge__c'));
         Account childAccount = (Account)s;
         merge mergeToAccount childAccount;
     } 
    }

   /*
    * @Method: finish
    * @Description: Send an email to creator of batch once the batch is complete.
    * @Param: Batch Id - Unique Batch Id assigned for Mass Merge.
    */    
   global void finish(Database.BatchableContext BC){
    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,ExtendedStatus,
         TotalJobItems, CreatedBy.Email
         FROM AsyncApexJob WHERE Id =
                :BC.getJobId()];
   
       // Send an email to the Apex job's submitter notifying of job completion.
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Mass Account Merge: ' + a.Status);
        mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
                ' batches with '+ a.NumberOfErrors + ' failures.' +'\n' + a.ExtendedStatus);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
   }
}