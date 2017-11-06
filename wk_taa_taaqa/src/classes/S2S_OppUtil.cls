/*
    **************************************************************************
    Name    :   JsonUtil
    
    Used for  :   This Apex class is used for Creating Json Files for Opp sync in Salesforce 2 Salesforce Integration Connection.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola        21-Sep-2017  
    
   
    
    ***************************************************************************
*/

global class S2S_OppUtil{
    
  
        public List<opps> opps;
    
   
    
    global class opps{
        
        public String oneforceAcc;   
        public String oneforceCon; 
        
        public String SFSOppRecordId;   
        public String TAAOppRecordId;  
        public String SFSAccountID; 
        public String TAAAccountID; 
        public String SFSPrimaryContact;
        public String TAAPrimaryContact;   
        public String Type;    
        public String Amount;    
        public String StageName;
        public String ProductCategory;
        public String ProductSubCategory;
        public String ForecastType;    
        public String CloseDate;   
        public String CloseReason;  
        public String OtherCloseReason;
        public String Competitor;   
        public String OtherCompetitor;
        public String Name;
        public String OppOwner;
        public String quoteId;
        public String quoteNumber;
        public String SFSPID;
        public String SFSCID;
        
    }
                   
                   
    public static S2S_OppUtil parse(String json){
        return (S2S_OppUtil) System.JSON.deserialize(json, S2S_OppUtil.class);
    }

}