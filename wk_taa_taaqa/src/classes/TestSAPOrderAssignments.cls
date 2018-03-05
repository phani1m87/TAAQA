@isTest
private class TestSAPOrderAssignments{
static testMethod void UpdateProposal(){
Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        
 Contact C = new Contact(
 lastname = 'Montgomery',
 firstname = 'Jim',
 accountId = acc.Id);
     insert C;

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        AccountId = acc.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        RecordTypeId = '01231000001NWyt',
        Primary_Contact_for_Proposal__c = c.Id);
        insert O;
        
 Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = acc.Id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtS',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4',        
        order_validator__c = '00531000007E74gAAC',
        order_biller__c = '00531000007E74gAAC');
        Insert P;
        
        
        
        p.sap_order_processor__c = '005i0000001gISQAA2';        
        update p;
        
        p.sap_order_on_hold__c = true;
        update p;
        
        p.sap_order_rejected__c = true;
        p.sap_order_rejection_notes__c = 'Test Notes';
        p.sap_order_rejection_reason__c = 'Other';
        update p;
        
        p.sap_biller_rejected__c = true;
        p.sap_biller_rejection_notes__c = 'Test Notes Biller';
        update p;
        
        p.sap_order_corrected__c = true;
        update p;
        
        p.sap_order_complete__c = true;
        update p;
        
       
        
       
   }
   }