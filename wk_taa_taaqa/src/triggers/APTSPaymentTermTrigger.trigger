/*
* Developed by Majid Khan(Apttus)
* Developed Date 15 Oct 2014
*/
trigger APTSPaymentTermTrigger on APTS_Payment_Term_Detail__c (before update, before delete) {
    APTSPaymentTermTriggerHandler triggerHandler = new APTSPaymentTermTriggerHandler();
    if(Trigger.isUpdate){
        triggerHandler.onBeforeUpdate(Trigger.new);
    }
    if(Trigger.isDelete){
        
        triggerHandler.onDelete(Trigger.old); 
    }
        
    
    
}