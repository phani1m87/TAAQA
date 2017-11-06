@isTest 
private class TestHasWorkpaperManagerTrigger {

    static testMethod void insertAMSInventoryRollup() {
        Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert A;
        
         
                
        
        
        user u = [select Id from user where lastname = 'Arno'];
AMS_Inventory_Rollup__c M = new AMS_Inventory_rollup__c(accountid__c =A.Id, name= '511000');
       
       insert M;
       
       delete M;
   
  AMS_Inventory_Rollup__c M1 = new AMS_Inventory_rollup__c(accountid__c =A.Id, name= '999999');
  
  insert M1;
        
     
         }
}