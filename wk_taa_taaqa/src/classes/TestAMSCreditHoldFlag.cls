@isTest (SeeAllData = true)
private class TestAMSCreditHoldFlag {

    static testMethod void insertAccountXReference() {
        Account a= [select Id from account where name = 'CCH INC. TECHNICAL SUPPORT-BOESCHEN'];
        user u = [select Id from user where lastname = 'Arno'];
Account_x_Reference__c M = new Account_X_Reference__c(account__c =a.Id, name= '990026',application__c = 'AMS', applicationid__c = '990026',ams_credit_hold__c = true);
 

       
       insert M;
   
          
     
         }
}