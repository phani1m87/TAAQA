@istest
Public class Testtrg_assignCaseRequestor
{
    public static testMethod void PopulateCaseRequestor()
    {
        test.starttest();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User();
            u.Alias = 'standt2';
            u.Email='2standarduser@test.com'; 
            u.EmailEncodingKey='UTF-8'; 
            u.LastName='Testing1'; 
            u.LanguageLocaleKey='en_US';
            u.LocaleSidKey='en_US'; 
            u.ProfileId = p.Id; 
            u.TimeZoneSidKey='America/Los_Angeles'; 
            u.UserName='1standarduser@testorg.com';
            u.DTN__c='7787'; 
            u.High_Level_Division__c='Research and Learning';
            u.Division__c='Northeast';
            u.License_Charge_To__c='Sales';
            u.CostCenter__c='1110';
            insert u;
            
            Group G=[select Id from Group where Name = 'Sales411' and Type = 'Queue'];
            
            Case c = new Case();
            c.Status='Completed';
            c.Origin='Email';
            c.Subject='Sales411';
            c.Description='Test';
            c.SuppliedEmail='2standarduser@test.com';
            c.ownerId=G.id;
            insert c;
            
            test.stoptest();
            
    }
}