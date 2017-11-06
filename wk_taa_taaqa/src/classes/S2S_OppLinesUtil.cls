//
//Utility used for Sharing Opp lines through JSON
//

global class S2S_OppLinesUtil {

    public OppProducts OppProducts ;
   
   global class OppProducts { 
    public List<Opp_Lines> Opp_Lines;
    public String Request_Type;
    }

    global class Opp_Lines {
        public String Product_Number;
        public String SFDCOpportunity;
        public Decimal Quantity;
        public String Opp_Product_Id;
        public Decimal Unit_Price;
        public String TAA_Opp_productId;
        public String QuoteNumber;
        public String QuoteId;
    }

    
    public static S2S_OppLinesUtil parse(String json) {
        return (S2S_OppLinesUtil) System.JSON.deserialize(json, S2S_OppLinesUtil.class);
    }
}