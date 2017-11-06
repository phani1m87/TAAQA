@isTest (SeeAllData = true)
private class TestCaseSales411Owner {

    static testMethod void insertCase() {
        Account a= [select Id from account where name = 'CCH INC. TECHNICAL SUPPORT-BOESCHEN'LIMIT 1];
        user u = [select Id from user where lastname = 'Arno'];
        RecordType RT = [select id from RecordType where name = 'Sales411'];
Case C = new Case(status='Received',RecordTypeId=RT.id,OwnerId=u.Id, Origin='Web',Subject='TestClass',Type='Pricing',business_segment__c='Software (Med & Large)',
Category__c='Tax',Description='TestClass',Accountid=A.Id);
 

       
       insert C;
   
          
     
         }
}