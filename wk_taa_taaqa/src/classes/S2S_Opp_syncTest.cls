/*
    **************************************************************************
    Name    :   S2S_Opp_syncTest
    
    Used for  :   Test class for S2S_Opp_sync.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          05-Sep-2017  
    
   
    
    ***************************************************************************
*/
@isTest
public class S2S_Opp_syncTest
{
  static testMethod void postest()
  {
      
        Account a = new Account( Name = 'pfxtest',BillingStreet='25 fake street',BillingPostalCode='30062',Market_Segment__c='Accounting Firms',Market_Sub_Segment__c='Sole Proprietor',BillingCountry='United States',BillingCity='Kennesaw' );
        insert a;
        
       Contact c =new Contact(FirstName='testFName',LastName='testLName', email='emailFormat@gmail.com', AccountId = a.id);
       insert c;
       
       Opportunity Opp = new Opportunity( Name = 'TestOpp',Primary_Contact_for_Proposal__c=c.id,AccountId = a.Id,type = 'New to Existing',Closedate = Date.today().addYears(1),stagename = '6. Closed Won',product_category__c = 'Med/Large Software',Amount = 1.00, product_Sub_Category__c = 'Tax');
        insert Opp;
        
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String Body= '{\"opps\":[{\"Type\":\"New to Existing\",\"TAAPrimaryContact\":\"0030S0000073vfNQAQ\",\"TAAOppRecordId\":\"0030S0000073vfNQAQ\",\"TAAAccountID\":\"0010S000008H6s1QAC\",\"StageName\":\"5. Time to Buy\",\"SFSPrimaryContact\":\"0030j00000BYUaRAAX\",\"SFSPID\":null,\"SFSOppRecordId\":\"0060j000009DssnAAC\",\"SFSCID\":null,\"SFSAccountID\":\"0010j00000BRS8YAAX\",\"quoteNumber\":\"Q-165685\",\"quoteId\":\"a1w0j000000BtmeAAC\",\"ProductSubCategory\":\"Tax\",\"ProductCategory\":\"Small Firm Software\",\"OtherCompetitor\":null,\"OtherCloseReason\":null,\"OppOwner\":\"Rajesh Gonola\",\"oneforceCon\":\"0000838367\",\"oneforceAcc\":\"0000446962\",\"Name\":\"fgh\",\"ForecastType\":\"Medium (50-90%)\",\"Competitor\":\"AICPA\",\"CloseReason\":\"Adding to Suite\",\"CloseDate\":\"2017-09-25\",\"Amount\":\"669.00\"}]}';
        
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/Opportunitysync' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            Id result= S2S_Opp_sync.doPost(); 
            
        Test.stopTest();   
  }
  
  static testMethod void Negativepostest()
  {
      
       
        
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String Body= '{\"opps\":[{\"Type\":\"New to Existing\",\"TAAPrimaryContact\":\"0030S0000073vfNQAQ\",\"TAAOppRecordId\":\"0030S0000073vfNQAQ\",\"TAAAccountID\":\"0010S000008H6s1QAC\",\"StageName\":\"5. Time to Buy\",\"SFSPrimaryContact\":\"0030j00000BYUaRAAX\",\"SFSPID\":null,\"SFSOppRecordId\":\"0060j000009DssnAAC\",\"SFSCID\":null,\"SFSAccountID\":\"0010j00000BRS8YAAX\",\"quoteNumber\":\"Q-165685\",\"quoteId\":\"a1w0j000000BtmeAAC\",\"ProductSubCategory\":\"Tax\",\"ProductCategory\":\"Small Firm Software\",\"OtherCompetitor\":null,\"OtherCloseReason\":null,\"OppOwner\":\"Rajesh Gonola\",\"oneforceCon\":\"0000838367\",\"oneforceAcc\":\"0000446962\",\"Name\":\"fgh\",\"ForecastType\":\"Medium (50-90%)\",\"Competitor\":\"AICPA\",\"CloseReason\":\"Adding to Suite\",\"CloseDate\":\"2017-09-25\",\"Amount\":\"669.00\"}]}';
        
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/Opportunitysync' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            Id result= S2S_Opp_sync.doPost(); 
            
        Test.stopTest();   
  }
  
}