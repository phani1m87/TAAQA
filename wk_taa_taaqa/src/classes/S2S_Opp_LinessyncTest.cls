/*
    **************************************************************************
    Name    :   S2S_Opp_LinessyncTest
    
    Used for  :   Test class for S2S_Opp_Linessync.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          05-Sep-2017  
    
   
    
    ***************************************************************************
*/
@isTest
public class S2S_Opp_LinessyncTest
{
  static testMethod void postest()
  {
      
        Account a = new Account( Name = 'pfxtest',BillingStreet='25 fake street',BillingPostalCode='30062',Market_Segment__c='Accounting Firms',Market_Sub_Segment__c='Sole Proprietor',BillingCountry='United States',BillingCity='Kennesaw' );
        insert a;
        
       Contact c =new Contact(FirstName='testFName',LastName='testLName', email='emailFormat@gmail.com', AccountId = a.id);
       insert c;
       
       Opportunity Opp = new Opportunity( Name = 'TestOpp',SFS_Opportunity_ID__c='0060j000009DTWfAAO',Primary_Contact_for_Proposal__c=c.id,AccountId = a.Id,type = 'New to Existing',Closedate = Date.today().addYears(1),stagename = '6. Closed Won',product_category__c = 'Med/Large Software',Amount = 1.00, product_Sub_Category__c = 'Tax');
        insert Opp;
        
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String Body= '{"OppProducts":{"Request_Type":"INSERT","Opp_Lines":[{"Unit_Price":669.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042258","Opp_Product_Id":"00k0j000003UPG7AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042607","Opp_Product_Id":"00k0j000003UPG8AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042254","Opp_Product_Id":"00k0j000003UPG9AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042257","Opp_Product_Id":"00k0j000003UPGAAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042605","Opp_Product_Id":"00k0j000003UPGBAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042606","Opp_Product_Id":"00k0j000003UPGCAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042101","Opp_Product_Id":"00k0j000003UPGDAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042204","Opp_Product_Id":"00k0j000003UPGEAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042206","Opp_Product_Id":"00k0j000003UPGFAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000042146","Opp_Product_Id":"00k0j000003UPGGAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000015176","Opp_Product_Id":"00k0j000003UPGHAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":1.00,"Product_Number":"0000015247","Opp_Product_Id":"00k0j000003UPGIAA4"}]}}';
        
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/OpportunityLines' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            Id result= S2S_Opp_Linessync.doPost(); 
            
        Test.stopTest();   
  }
  
  static testMethod void Negativepostest()
  {
      
        Account a = new Account( Name = 'pfxtest',BillingStreet='25 fake street',BillingPostalCode='30062',Market_Segment__c='Accounting Firms',Market_Sub_Segment__c='Sole Proprietor',BillingCountry='United States',BillingCity='Kennesaw' );
        insert a;
        
       Contact c =new Contact(FirstName='testFName',LastName='testLName', email='emailFormat@gmail.com', AccountId = a.id);
       insert c;
       
       Opportunity Opp = new Opportunity( Name = 'TestOpp',Primary_Contact_for_Proposal__c=c.id,AccountId = a.Id,type = 'New to Existing',Closedate = Date.today().addYears(1),stagename = '6. Closed Won',product_category__c = 'Med/Large Software',Amount = 1.00, product_Sub_Category__c = 'Tax');
        insert Opp;
       
      // OpportunityLineItem Opp = new OpportunityLineItem( Name = 'TestOpp',SFS_Opportunity_Record_Id__c='454545554554',UnitPrice=100,Quantity= 1,SFDC_Product__c= 124233444,stagename = '6. Closed Won',product_category__c = 'Med/Large Software',Amount = 1.00, product_Sub_Category__c = 'Tax');
        //insert Opp; 
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String Body= '{"OppProducts":{"Request_Type":"UPDATE","Opp_Lines":[{"Unit_Price":669.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042258","Opp_Product_Id":"00k0j000003UPG7AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042607","Opp_Product_Id":"00k0j000003UPG8AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042254","Opp_Product_Id":"00k0j000003UPG9AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042257","Opp_Product_Id":"00k0j000003UPGAAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042605","Opp_Product_Id":"00k0j000003UPGBAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042606","Opp_Product_Id":"00k0j000003UPGCAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042101","Opp_Product_Id":"00k0j000003UPGDAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042204","Opp_Product_Id":"00k0j000003UPGEAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042206","Opp_Product_Id":"00k0j000003UPGFAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042146","Opp_Product_Id":"00k0j000003UPGGAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000015176","Opp_Product_Id":"00k0j000003UPGHAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000015247","Opp_Product_Id":"00k0j000003UPGIAA4"}]}}';
        
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/OpportunityLines' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            Id result= S2S_Opp_Linessync.doPost(); 
            
        Test.stopTest();   
  }
  
  static testMethod void Deletetest()
  {
      
       
        
    
        Test.startTest();

            RestResponse res = new RestResponse();
            RestRequest req = new RestRequest(); 

                      
         String Body= '{"OppProducts":{"Request_Type":"DELETE","Opp_Lines":[{"Unit_Price":669.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042258","Opp_Product_Id":"00k0j000003UPG7AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042607","Opp_Product_Id":"00k0j000003UPG8AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042254","Opp_Product_Id":"00k0j000003UPG9AAO"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042257","Opp_Product_Id":"00k0j000003UPGAAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042605","Opp_Product_Id":"00k0j000003UPGBAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042606","Opp_Product_Id":"00k0j000003UPGCAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042101","Opp_Product_Id":"00k0j000003UPGDAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042204","Opp_Product_Id":"00k0j000003UPGEAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042206","Opp_Product_Id":"00k0j000003UPGFAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000042146","Opp_Product_Id":"00k0j000003UPGGAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000015176","Opp_Product_Id":"00k0j000003UPGHAA4"},{"Unit_Price":0.00,"TAA_Opp_productId":null,"SFDCOpportunity":"0060j000009DTWfAAO","QuoteNumber":"Q-165645","QuoteId":"a1w0j000000BtanAAC","Quantity":2.00,"Product_Number":"0000015247","Opp_Product_Id":"00k0j000003UPGIAA4"}]}}';
        
        
            req.requestBody = Blob.valueOf(Body);

            req.httpMethod = 'post';
            req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated 
            req.requestURI = '/services/apexrest/OpportunityLines' ;  
            RestContext.request = req;
            RestContext.response = res;

            //List<Wrapper> lstWrapper = myController.getMeListOfProducts(); // Use this line if wrapper class is outside
            Id result= S2S_Opp_Linessync.doPost(); 
            
        Test.stopTest();   
  }
  
}