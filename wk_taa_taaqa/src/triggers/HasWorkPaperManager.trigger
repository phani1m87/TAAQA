trigger HasWorkPaperManager on AMS_Inventory_Rollup__c (after insert, after update) {

    Map<ID, Account> parentAccount = new Map<ID, Account>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (AMS_Inventory_Rollup__c childObj : Trigger.new) {
        listIds.add(childObj.AccountID__c);
        LineItems.add(childObj.Id);
    }
  
    parentAccount = new Map<Id, Account>([SELECT id,Has_WorkPaper_Manager__c,(Select id from Ams_inventory_rollups__r where name = '511000') FROM account WHERE ID IN :listIds]);
   
    for (AMS_Inventory_Rollup__c AMSInventoryRollup: Trigger.new){
         Account myParentAccount = parentAccount.get(AMSInventoryRollup.AccountID__c);
        if(parentAccount.containsKey(AMSInventoryRollup.AccountID__c) && parentaccount.get(AMSInventoryRollup.AccountID__c).AMS_Inventory_Rollups__r.size() > 0)
        {
            myParentAccount.Has_WorkPaper_Manager__c = true;
        }
        else
        {
            myParentAccount.Has_WorkPaper_Manager__c = false ;
        }
    }
    update parentAccount.values();
 }