@isTest 
public class AccExtensionsTest{
 
     Public static  testMethod void TestAccExtensions()
          {
       
Account acc = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert acc;

     

    
                 PageReference pageRef = Page.Account_History_VF;
                                                                             
                 pageRef.getParameters().put('Id',acc.Id);
                 Test.setCurrentPage(pageRef);
                 
              ApexPAges.StandardController sc = new ApexPages.StandardController(acc);
  AccExtensions a = new AccExtensions(sc);
          
               
            
          
                 

        
     }
}