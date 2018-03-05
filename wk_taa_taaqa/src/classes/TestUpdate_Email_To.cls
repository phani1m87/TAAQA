@isTest 
private class TestUpdate_Email_To {

    static testMethod void Update_Email_To() {
      
      Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco', named_account_type__c = 'Strategic' );
        insert acc;
        
         Contact C = new Contact(
 lastname = 'Montgomery',
 firstname = 'Jim',
 accountId = acc.Id);
     insert C;
        
        Account_x_reference__c xref = new account_x_reference__c(
name = '990026',
applicationid__c = '990026', 
application__c = 'AMS',account__c = acc.id);
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
        account_x_reference__C = xref.Id,
        Primary_Contact_for_Proposal__c = c.Id);
        insert O;   
          
       Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = acc.id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4');
        Insert P;
        
   Account acc1 = new Account(
            Name = 'myAcct1', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='90503',
            BillingCountry='United States',
            BillingCity='San Francisco');
        insert acc1;
     
        
  Account_x_reference__c xref1 = new account_x_reference__c(
name = '990027',
applicationid__c = '990027', 
application__c = 'AMS', account__c = acc1.id);
insert xref1;
      
         

 Opportunity O1 = new Opportunity(
        Name = 'TestOpp1',
        accountId = acc1.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        account_x_reference__C = xref1.Id,
        Primary_Contact_for_Proposal__c = c.Id);
        insert O1;   
          
       Apttus_proposal__Proposal__c P1 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O1.Name',
        Apttus_Proposal__Account__c = acc1.id,
        Apttus_Proposal__Opportunity__c = O1.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref1.Id,
        rush_order__c = 'Yes',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4');
        Insert P1;
        
        
        
                 
       

 Opportunity O2 = new Opportunity(
        Name = 'TestOpp2',
        accountId = acc1.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        account_x_reference__C = xref1.Id,
        Primary_Contact_for_Proposal__c = c.Id);
        insert O2;   
          
       Apttus_proposal__Proposal__c P2 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O2.Name',
        Apttus_Proposal__Account__c = acc1.id,
        Apttus_Proposal__Opportunity__c = O2.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref1.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4');
        Insert P2;
        
         Apttus_proposal__Proposal__c P3 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O3.Name',
        Apttus_Proposal__Account__c = acc1.id,
        Apttus_Proposal__Opportunity__c = O2.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref1.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4', has_site_builder__c = true);
        Insert P3;

        Apttus_proposal__Proposal__c P4 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O3.Name',
        Apttus_Proposal__Account__c = acc1.id,
        Apttus_Proposal__Opportunity__c = O2.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref1.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4', has_Fam__c = true);
        Insert P4;
        
         Apttus_proposal__Proposal__c P5 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O3.Name',
        Apttus_Proposal__Account__c = acc1.id,
        Apttus_Proposal__Opportunity__c = O2.Id,
        RecordTypeId = '012i0000001EOtS',
        erp_account__C = xref1.Id,
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4', has_tax_lines__c = true, ams_account_grouping__c = '028');
        Insert P5;
        
        
        }
        
        
        }