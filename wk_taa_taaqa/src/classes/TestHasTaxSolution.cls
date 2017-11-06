@isTest 
private class TestHasTaxSolution {

    static testMethod void insertProposalLineItem() {
    Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        AccountId = acc.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        RecordTypeId = '01231000001NWyt');
        insert O;
        
 Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = acc.Id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtS',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4');
        Insert P;
        
    
             
Apttus_Proposal__Proposal_Line_Item__c PLI = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, apttus_proposal__product__c = '01ti0000005lLPv',Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 1,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000 );
 

       
       insert PLI;
       
       Delete PLI;
       
  Apttus_Proposal__Proposal_Line_Item__c PLI1 = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, apttus_proposal__product__c = '01ti0000005lK65AAE',Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 1,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000 );
     
       
   insert PLI1;
          
     
         }
}