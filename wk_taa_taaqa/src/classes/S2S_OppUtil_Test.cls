/*
    **************************************************************************
    Name    :   S2S_OppUtil_Test
    
    Used for  :   This test class for S2S_OppUtil for Opp sync in Salesforce 2 Salesforce Integration Connection.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola        05-OCt-2017  
    
   
    
    ***************************************************************************
*/

@IsTest
public class S2S_OppUtil_Test {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{\"opps\":[{\"Type\":\"New to Existing\",\"TAAPrimaryContact\":\"0030S0000073vfNQAQ\",\"TAAOppRecordId\":\"0060S000005hVwdQAE\",\"TAAAccountID\":\"0010S000008H6s1QAC\",\"StageName\":\"5. Time to Buy\",\"SFSPrimaryContact\":\"0030j00000BYUaRAAX\",\"SFSPID\":null,\"SFSOppRecordId\":\"0060j000009DssnAAC\",\"SFSCID\":null,\"SFSAccountID\":\"0010j00000BRS8YAAX\",\"quoteNumber\":\"Q-165685\",\"quoteId\":\"a1w0j000000BtmeAAC\",\"ProductSubCategory\":\"Tax\",\"ProductCategory\":\"Small Firm Software\",\"OtherCompetitor\":null,\"OtherCloseReason\":null,\"OppOwner\":\"Rajesh Gonola\",\"oneforceCon\":\"0000838367\",\"oneforceAcc\":\"0000446962\",\"Name\":\"fgh\",\"ForecastType\":\"Medium (50-90%)\",\"Competitor\":\"AICPA\",\"CloseReason\":\"Adding to Suite\",\"CloseDate\":\"2017-09-25\",\"Amount\":\"669.00\"}]}';
        S2S_OppUtil r = S2S_OppUtil.parse(json);
        System.assert(r != null);

        }
}