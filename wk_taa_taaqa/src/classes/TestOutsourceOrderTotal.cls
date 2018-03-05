@isTest 
private class TestOutsourceOrderTotal {

    static testMethod void OutsourceOrderTest() {
    
    Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco', 
            market_segment__c = 'Accounting Firms', 
            market_sub_segment__c = '2-4 Total Employees',
            has_axcess_tax__c = True,
            RecordTypeId = '012i0000000Ou0CAAS' );
        insert A;

 Contact c = new Contact(
        firstname = 'Jim', lastname = 'Montgomery');
        Insert c;
        
        Account_x_reference__c xref = new account_x_reference__c(
name = '990026',
applicationid__c = '990026', 
application__c = 'AMS', ams_special_agreement__c = 'X', ams_consolidation_code__c = '028',
account__c = a.id);
insert xref;

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        accountId = A.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax');
        insert O;

 Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = A.id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtSAAW', 
        erp_account__c = xref.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4',
        os_deposit_flag__c = false);
        Insert P;
        
       p.os_deposit_amount__c = 4750.00;
       p.os_offshore_1041_count__c = 100;
       p.os_tax_year__c = '2018';
       
       
       update p;

    
    
}
 }