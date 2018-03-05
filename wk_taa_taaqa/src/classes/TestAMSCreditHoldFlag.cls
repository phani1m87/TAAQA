@isTest 
private class TestAMSCreditHoldFlag {

    static testMethod void insertAccountXReference() {
         Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        user u = [select Id from user where lastname = 'Arno'];
Account_x_Reference__c M = new Account_X_Reference__c(account__c =acc.Id, name= '990026',application__c = 'AMS', applicationid__c = '990026',ams_credit_hold__c = true);
 

       
       insert M;
   
          
     
         }
}