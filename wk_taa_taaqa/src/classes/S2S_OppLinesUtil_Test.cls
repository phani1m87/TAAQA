@IsTest
public class S2S_OppLinesUtil_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Opp_Lines\": [{'+
        '       \"Product_Number\": \"0000182049\",'+
        '       \"SFDCOpportunity\": \"0030S0000072NfOQAU\",'+
        '       \"Quantity\": \"1\",'+
        '       \"Opp_Product_Id\": \"0030S0000072NfOQAU\",'+
        '       \"Unit_Price\": \"123\"'+
        '   }, {'+
        '       \"Product_Number\": \"0000182049\",'+
        '       \"SFDCOpportunity\": \"0030S0000072NfOQAU\",'+
        '       \"Quantity\": \"1\",'+
        '       \"Opp_Product_Id\": \"0030S0000072NfOQAU\",'+
        '       \"Unit_Price\": \"123\"'+
        '   }, {'+
        '       \"Product_Number\": \"0000182049\",'+
        '       \"SFDCOpportunity\": \"0030S0000072NfOQAU\",'+
        '       \"Quantity\": \"1\",'+
        '       \"Opp_Product_Id\": \"0030S0000072NfOQAU\",'+
        '       \"Unit_Price\": \"123\"'+
        '   }]'+
        '}';
        S2S_OppLinesUtil obj = S2S_OppLinesUtil.parse(json);
        System.assert(obj != null);
    }
}