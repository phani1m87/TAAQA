@isTest 
private class TestUpdate_X_Reference {

    static testMethod void Update_X_Reference() {
      
      Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        
        Account_x_reference__c xref = new account_x_reference__c(
name = '990026',
applicationid__c = '990026', 
application__c = 'AMS',
account__c = acc.id);
insert xref;

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        accountId = acc.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        is_ams_renewal__c = true,
        account_x_reference__C = xref.Id,
        AMS_renewal_email__c = '',
        ams_renewal_contact__c = '',
        X2017_AMS_Additional_Discount__c = ''
        );
        insert O;




o.X2017_AMS_Additional_Discount__C = '5% SALY';
o.AMS_renewal_email__c = 'joe@test.com';
o.ams_renewal_contact__c = 'Joe Test';

 

       Update o;
       
   
          
     
         }
}