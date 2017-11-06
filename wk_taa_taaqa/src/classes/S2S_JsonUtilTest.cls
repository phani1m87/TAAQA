/*
    **************************************************************************
    Name    :   S2S_JsonUtil
    
    Used for  :   Test class for S2S_JsonUtilTest  .
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          05-Sep-2017  
    
   
    
    ***************************************************************************
*/


@IsTest
public class S2S_JsonUtilTest {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{\"Opportunity\":{\"Type\":\"New Sale To New Customer\",\"StageName\":\"Align\",\"SFDCOpportunity\":\"0000182709\",\"ProductSubCategory\":\"Tax\",\"ProductCategory\":\"Small Firm Software\",\"PrimaryContact\":\"0030S0000073w9XQAQ\",\"OppRecordId\":\"0060S000005hW5uQAE\",\"OppOwner\":\"mason.young=wolterskluwer.com@example.com\",\"Name\":\"RajFieldTest2\",\"ForecastType\":\"Low (<50%)\",\"CloseDate\":\"2017-09-26\",\"Amount\":\"669.00\",\"AccountID\":\"0010S000008H82iQAC\"},\"Customer\":{\"subsegment\":\"Sole Proprietor\",\"ShippingZip\":\"30144\",\"ShippingSuite\":null,\"ShippingState\":\"ga\",\"Shippingcountry\":\"United States\",\"ShippingCity\":\"kennesaw\",\"ShippingAdress\":\"123 main street\",\"Segment\":\"Accounting Firms\",\"Phone\":\"(777) 777-7777\",\"Name\":\"RajFIeldTest2\",\"BillingZip\":\"30144\",\"BillingSuite\":null,\"BillingState\":\"ga\",\"Billingcountry\":\"United States\",\"BillingCity\":\"kennesaw\",\"BillingAdress\":\"123 main street\",\"AcctOwner\":null,\"AccoutNumber\":\"0000446967\",\"AccountRecordId\":\"0010S000008H82iQAC\"},\"Contacts\":{\"Phone\":\"(777) 777-7777\",\"Mobile\":null,\"LastName\":\"FieldTest2\",\"FirstName\":\"Raj\",\"Fax\":null,\"Email\":\"geoffrey.rubin@wolterskluwer.com\",\"ContactRecordId\":\"0030S0000073w9XQAQ\",\"ContactNumber\":\"0000838372\"}}';
        S2S_JsonUtil r = S2S_JsonUtil.parse(json);
        System.assert(r != null);


       
    }
}