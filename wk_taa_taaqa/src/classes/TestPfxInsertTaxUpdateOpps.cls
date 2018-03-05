@isTest
Private Class TestPfxInsertTaxUpdateOpps{
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
            Pfx_Tax_Update_Counter__c = 0 );
        insert A;
        
       
        
        A.Pfx_Tax_Update_Counter__C = 1;
        a.Tax_Update_Account_Number__c = 'a013100000csYYR';
        
        update a;
        
        
   
        }
        }