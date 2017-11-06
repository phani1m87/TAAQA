@isTest 
private class Smallfirm_taxsale_promotionHandlerTest {

    static testMethod void promotiontest() {
      
       
        Account a = new Account( Name = 'pfxtest',BillingStreet='25 fake street',BillingPostalCode='30062',Market_Segment__c='Accounting Firms',Market_Sub_Segment__c='Sole Proprietor',BillingCountry='United States',BillingCity='Kennesaw' );
        insert a;
        
       Contact c =new Contact(FirstName='testFName',LastName='testLName', email='emailFormat@gmail.com', AccountId = a.id);
       insert c;
       
       Opportunity Opp = new Opportunity( Name = 'TestOpp',Primary_Contact_for_Proposal__c=c.id,AccountId = a.Id,type = 'New to Existing',Closedate = Date.today().addYears(1),stagename = '6. Closed Won',product_category__c = 'Med/Large Software',Amount = 1.00, product_Sub_Category__c = 'Tax');
        insert Opp;
        
           insert new Oauth_settings__c(Name = 'Credentials',ClientId__c= '541255441');
             insert new Oauth_settings__c(Name = 'Credentials',ClientSecret__c= 'f4544155d5d44sd55fd4d5d');
             insert new Oauth_settings__c(Name = 'Credentials',Username__c= 'test@name.com');
             insert new Oauth_settings__c(Name = 'Credentials',Password__c= 'password');
             insert new Oauth_settings__c(Name = 'Credentials',URL__c= 'http://fakeurl.com');
       
        
    
      
          
       
          Test.StartTest();   
          Test.setMock(HttpCalloutMock.class, new OauthUtilMockHttpResponseGenerator());
            Apttus_proposal__Proposal__c P = New Apttus_proposal__Proposal__c(apttus_proposal__Proposal_Name__c = Opp.Name,Apttus_Proposal__Approval_Stage__c='Submitted to COP',Has_Tax_Solution__c = true,Apttus_Proposal__Account__c = a.Id,Apttus_Proposal__Opportunity__c = Opp.Id);
            insert P;
          
         
          
          Test.StopTest();
        
         }
         
       
}