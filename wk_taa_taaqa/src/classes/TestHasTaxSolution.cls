@isTest 
Public class TestHasTaxSolution {

    static testMethod void insertProposalLineItem() {
    Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        Contact c = new Contact(
        firstname = 'Jim', lastname = 'Montgomery');
        Insert c;
        
        Product2 P2 = new Product2(
        name = 'test product', family = 'Fixed Assets Manager',productcode = '123456');
        Insert P2;
        
        
        

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        AccountId = acc.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax',
        RecordTypeId = '01231000001NWyt',Primary_Contact_for_Proposal__c = c.Id);
        insert O;
        
 Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = acc.Id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtS',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4');
        Insert P;
        
  Apttus_proposal__Proposal__c P1 = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = acc.Id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtS',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4', extended_maintenance_months__c = 3);
        Insert P1;
        Apttus_Proposal__Proposal_Line_Item__c PLI3 = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p1.Id, apttus_proposal__product__c = p2.Id,Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 2,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000);
        insert PLI3;
        P1.extended_maintenance_approved__c = true;
        update P1;

             
//Apttus_Proposal__Proposal_Line_Item__c PLI = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, apttus_proposal__product__c = p2.Id,Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 1,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000);
//Apttus_Proposal__Proposal_Line_Item__c PLI2 = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, apttus_proposal__product__c = p2.Id,Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 2,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000);
//Template_Line_item__c TLI = new Template_Line_Item__c (quote_proposal__c = p.Id, proposal_line_item__C = PLI.Id,  product__c = p2.Id);       
       //insert PLI;
      //insert PLI2;
         // insert TLI;    
       //Delete PLI;
       
  //Apttus_Proposal__Proposal_Line_Item__c PLI1 = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, apttus_proposal__product__c = p2.Id,Apttus_QPConfig__ItemSequence__c = 1, Apttus_QPConfig__LineNumber__c = 1,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000 );
     
       
   //insert PLI1;
          
     
         }
}