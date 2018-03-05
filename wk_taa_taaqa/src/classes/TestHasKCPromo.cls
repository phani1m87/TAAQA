@isTest
public class TestHasKCPromo {

Static testMethod void insertPromotion() {

Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert A;
 Contact c = new Contact(
        firstname = 'Jim', lastname = 'Montgomery');
        Insert c;
        
 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        accountId = A.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax', primary_contact_for_proposal__c = c.Id);
        insert O;

 Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(
        apttus_proposal__Proposal_Name__c = 'O.Name',
        Apttus_Proposal__Account__c = A.id,
        Apttus_Proposal__Opportunity__c = O.Id,
        RecordTypeId = '012i0000001EOtUAAW',
        Apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L5',
        sap_contact_channel__c = 'Field Sales Rep', 
        sap_sales_channel__c = 'Field Sales Rep',
        Auto_Renewal_SO_Compliance__c = 'Opt-In (OBR)');
        Insert P;
        
        Promotion__c Pr = New promotion__c(name = 'Teammate renewal', 
        promo_code__c = '24315', 
        active__c = true,
        price_list__c = 'a1fi0000000y6L5', 
        effective_date__c = Date.newInstance(2017, 1, 1), 
        expiration_date__c = Date.newInstance(2019, 12, 31));
        
        insert Pr;
        
  Quote_Promotion__c QP = New Quote_Promotion__c(
  quote_Proposal__C = p.Id, promotion__c = Pr.Id) ; 
  
  Insert QP ;
  Apttus_Proposal__Proposal_Line_Item__c PLI = new Apttus_Proposal__Proposal_Line_Item__c (apttus_proposal__Proposal__c =p.Id, 
  apttus_proposal__product__c = '01ti0000005lLPv',Apttus_QPConfig__ItemSequence__c = 1, 
  Apttus_QPConfig__LineNumber__c = 1,Apttus_QPConfig__LineStatus__c = 'New', Apttus_QPConfig__Quantity2__c=1.00000,
  apts_promo_code__c = '24315');
Insert PLI;
  
  QP.Quote_Has_Others__c = true;
  Update QP;
  Delete QP;
        
        
        }
        }