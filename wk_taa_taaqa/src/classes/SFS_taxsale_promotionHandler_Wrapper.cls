/*
    **************************************************************************
    Name    :   SFS_taxsale_promotionHandler_Wrapper 
    
    Used for  :   This Apex class is used as a wrapper class for smallfirm_taxsale_promotionHandler Apex Class .
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
    
    ***************************************************************************
*/

global class SFS_taxsale_promotionHandler_Wrapper {
    
  
        public Customer Customer;
        public Contacts Contacts;
       
    
   
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
    
       
                   
    public static SFS_taxsale_promotionHandler_Wrapper parse(String json){
        return (SFS_taxsale_promotionHandler_Wrapper) System.JSON.deserialize(json, SFS_taxsale_promotionHandler_Wrapper.class);
    }

}