@isTest 
public class ProSoftRevControllerTest{
 
     Public static  testMethod void ProSoftRevControllerTest()
          {
       
Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;

professional_software_revenue__c PR = new professional_software_revenue__c(
account__c = acc.Id,sfdc_acctid__c = acc.Id, x2016_tax_software__c = 2500.00);
insert PR;
     

    
                 PageReference pageRef = Page.ProfessionalSoftwareRevenue;
                                                                             
                 pageRef.getParameters().put('Id',acc.Id);
                 Test.setCurrentPage(pageRef);
                 
                  ProSoftRevController  ps = new ProSoftRevController();
            ps.GetRevenue();
             
             

            
          
                 

        
     }
}