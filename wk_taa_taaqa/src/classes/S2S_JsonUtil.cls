/*
    **************************************************************************
    Name    :   JsonUtil
    
    Used for  :   This Apex class is used for Creating Json Files for Salesforce 2 Salesforce Integration Connection.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
    
    ***************************************************************************
*/

global class S2S_JsonUtil{
    
  
        public Customer Customer;
        public Contacts Contacts;
        public Opportunity Opportunity;
    
   
    global class Customer {
        public String ShippingAdress;
        public String ShippingSuite; 
        public String ShippingCity; 
        public String ShippingState;    
        public String ShippingZip;  
        public string Shippingcountry;
        
        public String BillingAdress;
        public String BillingSuite;   
        public String BillingCity; 
        public String BillingState;    
        public String BillingZip;  
        public string Billingcountry;
        
        public String AccoutNumber;   
        //public String First_Name;   
        //public String Last_Name;    
        public String Name;  
        public String Phone;   
        public String Segment;
        public String subsegment;
        public String AccountRecordId;
        public String AcctOwner;
        
    }
    
       
    global class Contacts {
        public String Phone;    
        public String Fax;  
        public String Mobile;   
        public String Email;    
        public String FirstName;    
        public String LastName;
        public String ContactRecordId;
        public String ContactNumber;
    }
    
    global class Opportunity{
        public String OppRecordId;    
        public String AccountID;  
        public String PrimaryContact;   
        public String Type;    
        public String Amount;    
        public String StageName;
        public String ProductCategory;
        public String ProductSubCategory;
        public String ForecastType;    
        public String CloseDate;    
        public String Name;
        public String SFDCOpportunity ;
        public String OppOwner;
    }
                   
                   
    public static S2S_JsonUtil parse(String json){
        return (S2S_JsonUtil) System.JSON.deserialize(json, S2S_JsonUtil.class);
    }

}