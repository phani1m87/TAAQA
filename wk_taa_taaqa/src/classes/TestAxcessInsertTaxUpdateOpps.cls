@isTest
Private Class TestAxcessInsertTaxUpdateOpps{
static testMethod void InsertOpp(){

TaxUpdateYear__C TUY = new TaxUpdateYear__c(
name = 'UpdateYear',
year__c = '2018');
insert TUY;

Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco',
            market_segment__c = 'Accounting Firms',
            market_sub_segment__c = 'Sole Proprietor',
            Axcess_Tax_Update_Counter__c = 0,
            pfx_tax_update_counter__c = 0);
        insert A;
        
        
        
        

product2 Pr = new product2 (name = 'CCH Axcess Tax - Tax Update - MTS',
ProductCode = '220407');
Insert Pr;

Apttus_Config2__PriceListItem__C PLI = new Apttus_Config2__PriceListItem__C(
Apttus_Config2__ProductId__c = Pr.Id, Apttus_Config2__ChargeType__c = 'One Time Fee', 
Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4', Apttus_Config2__ListPrice__c = 150.00);

insert PLI;

PriceBookEntry PBE = new PriceBookEntry(
Pricebook2Id = '01si0000000JXqb', Product2Id = Pr.Id, UnitPrice = 150.00, isActive = true);

insert PBE;


        
        A.Axcess_Tax_Update_Counter__c = 1;
        a.Tax_Update_Account_Number__c = 'a013100000csYYR';
        
        update a;
        
        
   
        }
        }