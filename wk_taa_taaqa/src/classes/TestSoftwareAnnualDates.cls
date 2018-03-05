@isTest 
Public class TestSoftwareAnnualDates {

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
        
 Product2 Prod = new Product2(
        name = 'Test Product', productcode = '234567');

            Insert Prod;
        
  Apttus_Config2__PriceListItem__c PLIID = new Apttus_Config2__PriceListItem__c(
          Apttus_Config2__Active__c = true,
          Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4',
          Apttus_Config2__ProductId__c = Prod.Id,
          Apttus_Config2__PriceUom__c = 'each',
          Apttus_Config2__ListPrice__c = 0.00000,
          Apttus_Config2__ChargeType__c = 'One Time fee');
          
          Insert PLIID;
        

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
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4', extended_maintenance_months__c = 3);

            Insert P;

Apttus_Config2__ProductConfiguration__c PC = new Apttus_Config2__ProductConfiguration__c(
    name = 'Test Config', 
    Apttus_Config2__BusinessObjectId__c = p.Id,
    Apttus_Config2__BusinessObjectType__c = 'Proposal',
    Apttus_Config2__VersionNumber__c = 1,
    Apttus_QPConfig__Proposald__c = p.Id,
    Proposal_ID__c = p.Id,
    Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4',
    Apttus_Config2__Status__c = 'Saved',
    Apttus_Config2__AccountId__c = acc.Id);

        Insert PC;
        
   Apttus_Config2__LineItem__c CLI = new Apttus_Config2__LineItem__c(
       Apttus_Config2__ConfigurationId__c = PC.Id,
    Apttus_Config2__LineNumber__c = 1,
    Apttus_Config2__IsPrimaryLine__c = True,
    Apttus_Config2__ItemSequence__c = 1,
    Apttus_Config2__LineType__c = 'Product/Service',
    Apttus_Config2__ProductId__c = Prod.Id,
    Apttus_Config2__Customizable__c = True,
    Apttus_Config2__ClassificationHierarchy__c = 'Test',
    Apttus_Config2__Quantity__c = 1.00000,
    Apttus_Config2__IsQuantityModifiable__c = true,
    Apttus_Config2__Uom__c = 'Year',
    Apttus_Config2__Term__c = 1,    
    Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4',
    Apttus_Config2__PriceListItemId__c = PLIID.Id,
    Apttus_Config2__PriceType__c = 'One Time',
    Apttus_Config2__PriceMethod__c = 'One Time',
    Apttus_Config2__ChargeType__c = 'One Time Fee',
    Apttus_Config2__Frequency__c = 'Yearly',
    Apttus_Config2__AllowManualAdjustment__c = true,
    Apttus_Config2__AllocateGroupAdjustment__c = true,
    Apttus_Config2__ListPrice__c = 0.00000,
    Apttus_Config2__BasePrice__c = 0.00000,
    Apttus_Config2__BasePriceMethod__c = 'Flat Price',
    Apttus_Config2__BaseExtendedPrice__c = 0.00000,
    Apttus_Config2__OptionPrice__c = 0.00000,
    Apttus_Config2__ExtendedPrice__c = 0.00000,
    Apttus_Config2__Description__c = 'Test',
    Apttus_Config2__PrimaryLineNumber__c = 1);
    
        Insert CLI;



    



Apttus_Proposal__Proposal_Line_Item__c PropLI = new Apttus_Proposal__Proposal_Line_Item__c(
    apttus_proposal__Proposal__c =p.Id, 
    apttus_proposal__product__c = Prod.Id,
    Apttus_QPConfig__ItemSequence__c = 1, 
    Apttus_QPConfig__LineNumber__c = 2,
    Apttus_QPConfig__LineStatus__c = 'New',
    Apttus_QPConfig__Quantity2__c=1.00000,
    Apttus_QPConfig__ConfigurationId__c = PC.Id  );

            insert PropLI;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c PAV = new Apttus_QPConfig__ProposalProductAttributeValue__c(
    extended_maintenance_months__c = '3',
    number_of_users__c = 1.0,
    Apttus_QPConfig__LineItemId__c = PropLI.Id);
    
        Insert PAV;
        PropLI.Apttus_QPConfig__AttributeValueId__c = PAV.Id;
        update PropLI;
       


 P.extended_maintenance_approved__c = true;
        update P;
    }
}