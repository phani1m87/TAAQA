@isTest 
public class CBIControllerTest{
 
     Public static  testMethod void CBITest()
          {
  Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;
        
   Opportunity O = new Opportunity(
        Name = 'TestOpp',
        accountId = acc.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax');
        insert O;
        
        CBI_Form__c CB = new CBI_Form__c(
        opportunity__c = O.Id, recordtypeid = '01231000001AieH', presentation_date__c = date.Today(), presentation_type__C = 'Webinar', status__c = 'Draft',
        solution_architect__c = '005i0000001gISQAA2');     
        insert CB;                



     

    
                 PageReference pageRef = Page.cbiform;
                                                              
                 pageRef.getParameters().put('Id',cb.id);
                 Test.setCurrentPage(pageRef);
             
             CBIController  cbc = new CBIController();
             cbc.GetCBI();

            
          
                 

        
     }
}