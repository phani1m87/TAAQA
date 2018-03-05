@isTest (SeeAllData = true)
private class TestCaseSales411Owner {

    static testMethod void insertCase() {
        Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        user u = [select Id from user where lastname = 'Arno'];
        RecordType RT = [select id from RecordType where name = 'Sales411'];
Case C = new Case(status='Received',RecordTypeId=RT.id,OwnerId=u.Id, Origin='Web',Subject='TestClass',Type='Pricing',business_segment__c='Software (Med & Large)',
Category__c='Tax',Description='TestClass',Accountid=Acc.Id);
 

       
       insert C;
   
          
     
         }
}