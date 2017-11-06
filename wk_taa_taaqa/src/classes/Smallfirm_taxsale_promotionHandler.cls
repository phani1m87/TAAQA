/*
    **************************************************************************
    Name    :   smallfirm_taxsale_promotionHandler 
    Used for  :   This Apex class is used to push information from TAA to SFS, so that there is an opportunity,quote and order created for the $0 books in SFS, only If they have purchased a Tax solution.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
    
    ***************************************************************************
*/

   
 public class Smallfirm_taxsale_promotionHandler {
      
        public static boolean hasAlreadyRun = false;
        
        public static boolean hasAlreadyRunMethod(){
            return hasAlreadyRun;
        }
        
        public static void setAlreadyRunMethod(){
            hasAlreadyRun = true;
        } 
    
        Public Map<Id,Id> accountstoprocess;
        Public Set<Id> contactstoprocess;
        Public Map<Id,Contact> contacttoupdate;
        Public Map<Id,Apttus_Proposal__Proposal__c> acntstoproposal;
        
        
 
   public void afterupdate(List<Apttus_Proposal__Proposal__c> aftruptquotes, Map<ID, Apttus_Proposal__Proposal__c> oldQuoteMap) {  
      
       try{
           accountstoprocess= new Map<Id,Id>();
           contactstoprocess= new Set<Id>();
           contacttoupdate= new Map<Id,Contact>();
           acntstoproposal = new Map<Id,Apttus_Proposal__Proposal__c>();
           List<S2S_LogFile__c> logtoinsert=new List<S2S_LogFile__c>();
           
            
           for(Apttus_Proposal__Proposal__c quote : aftruptquotes) {   
           
           System.debug(' ---->'+quote.Apttus_Proposal__Account__r.Market_Sub_Segment__c);  
           
              if( (    ((quote.Account_Marketing_SubSegment__c =='Sole Proprietor') || (quote.Account_Marketing_SubSegment__c =='2-4 Total Employees')) 
                      && (quote.Account_Marketing_Segment__c=='Accounting Firms') && 
                      ((quote.Opp_Type__c =='New to New') || (quote.Opp_Type__c =='New to Existing')) 
                      && quote.Has_Tax_Solution__c == true && 
                       quote.Opp_Stage__c=='6. Closed Won' 
                       && quote.Apttus_Proposal__Approval_Stage__c=='Submitted to COP') && quote.Got_SFS_Book_Promo__c== False ) {
                  
                  if(quote.Apttus_Proposal__Account__c != null && (quote.Opp_Primary_ContactId__c != null || quote.Opp_Primary_ContactId__c != '' ) ){
                    accountstoprocess.put(quote.Apttus_Proposal__Account__c,quote.id);
                    contactstoprocess.add(quote.Opp_Primary_ContactId__c);
                    acntstoproposal.put(quote.Apttus_Proposal__Account__c,quote);
                    System.debug(' ---->'+accountstoprocess +contactstoprocess);  
                    }
                }
            }
           
           
              List<Account> accountstopush =[Select id,Name,Phone,Market_Segment__c,Market_Sub_Segment__c,SFDC_Account_Text__c,BillingStreet, BillingCity,
                                                    BillingState, BillingPostalCode, BillingCountry,ShippingStreet,ShippingCity,ShippingState,
                                                    ShippingPostalCode,ShippingCountry From Account Where id IN : accountstoprocess.keySet()];
              
              
              List<Contact> cnt=[ Select  Id,AccountId,Name,Phone,Email,LastName,FirstName,SFDC_Contact_Text__c  From Contact Where  Id IN : contactstoprocess AND Inactive__c = false order by CreatedDate DESC Limit 1 ];
                       
                for(Contact c: cnt){
                 
                contacttoupdate.put(c.AccountId,c);
                System.debug('Contacts map'+contacttoupdate);  
                }
                         
             List<SFS_taxsale_promotionHandler_Wrapper> accInfo= new List<SFS_taxsale_promotionHandler_Wrapper> ();
                
            for(Account a:accountstopush ){
                 
                 try{
                 
                 SFS_taxsale_promotionHandler_Wrapper jsninfo= new SFS_taxsale_promotionHandler_Wrapper ();

                 SFS_taxsale_promotionHandler_Wrapper.Customer custInfo=new SFS_taxsale_promotionHandler_Wrapper.Customer();
                 
                 custInfo.Name=a.Name;
                 custInfo.AccoutNumber=a.SFDC_Account_Text__c;
                 custInfo.AccountRecordId=a.id;
                 custInfo.Phone=a.Phone;
                 custInfo.Segment=a.Market_Segment__c;
                 custInfo.subsegment=a.Market_Sub_Segment__c;
                
                  
                 custInfo.BillingAdress=acntstoproposal.get(a.id).Bill_To_Street_Line_1__c; 
                 custInfo.BillingSuite=acntstoproposal.get(a.id).Bill_To_Street_Line_2__c;                                       
                 custInfo.BillingCity=acntstoproposal.get(a.id).Bill_To_City__c;
                 custInfo.BillingState=acntstoproposal.get(a.id).Bill_To_State__c;
                 custInfo.BillingZip=acntstoproposal.get(a.id).Bill_To_Zip_Postal_Code__c;
                 custInfo.Billingcountry=acntstoproposal.get(a.id).Bill_To_Country__c;
                 
                 custInfo.ShippingAdress=acntstoproposal.get(a.id).Ship_To_Street_Line_1__c;
                 custInfo.ShippingSuite=acntstoproposal.get(a.id).Ship_To_Street_Line_2__c;
                 custInfo.ShippingCity=acntstoproposal.get(a.id).Ship_To_City__c;
                 custInfo.ShippingState=acntstoproposal.get(a.id).Ship_To_State__c;
                 custInfo.ShippingZip=acntstoproposal.get(a.id).Ship_To_Zip_Postal_Code__c;
                 custInfo.Shippingcountry=acntstoproposal.get(a.id).Ship_To_Country__c;                 
                  
                  
                 jsninfo.Customer=custInfo;
                 
                 
                 
                SFS_taxsale_promotionHandler_Wrapper.Contacts Contacts = new SFS_taxsale_promotionHandler_Wrapper.Contacts ();
                
                 Contacts.FirstName=contacttoupdate.get(a.id).FirstName;
                 Contacts.LastName=contacttoupdate.get(a.id).LastName;
                 Contacts.Email=contacttoupdate.get(a.id).Email;
                 Contacts.Phone=contacttoupdate.get(a.id).Phone;
                 Contacts.ContactRecordId=contacttoupdate.get(a.id).id;
                 Contacts.ContactNumber=contacttoupdate.get(a.id).SFDC_Contact_Text__c;
                 
                 jsninfo.Contacts=Contacts;
                 
                 //serialize the request
                String strRequestParam = JSON.serialize(jsninfo);
                
                 system.debug('request json'+strRequestParam);
                 
                 SendInfo(strRequestParam,a.id,contacttoupdate.get(a.id).id,accountstoprocess.get(a.id));
                 
                 //response= response.replace('"','');
             
                // system.debug('Resp String'+response);
                  
                 accInfo.add(jsninfo);
                 
           }catch(Exception ex){
   
           String Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
            
            
            S2S_LogFile__c log=new S2S_LogFile__c(Related_Account__c=a.Id,API_Type__c='PFX Book Promo',Log_Info__c=Result,API_Response_Code__c=6000);
               
               logtoinsert.add(log);
               
               
           }
          }
          
          if(logtoinsert.size()>0) insert logtoinsert;
          
       }catch(Exception ex){
   
           String Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
            S2S_LogFile__c log=new S2S_LogFile__c(API_Type__c='PFX Book Promo',Log_Info__c=Result,API_Response_Code__c=6000);
               
            insert log;
           }   
    }
    
    
     @Future(callout=true)  
    public static Void SendInfo(String Jsons,String accId,String CntId,Id quoteId) {
        
        String Result;
        
        HttpResponse authres  = new HttpResponse();
        
        authres = OauthUtil.Authenticate('');
        
       try{
        
        
        system.debug('Auth request response'+authres.getStatusCode());
        
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        
        if(authres.getStatusCode()==200 || Test.isRunningTest()){ 
        
        
        OauthUtil.OAuth2 objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authres.getbody(), OauthUtil.OAuth2.class);
        
        if(objAuthenticationInfo.access_token!=null || Test.isRunningTest()){
        
        
          Http h = new Http();
          
          if(!Test.isRunningTest())
          req.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
          req.setHeader('Content-Type','application/json');
          req.setHeader('accept','application/json');
          req.setTimeout(120000);
        
          req.setBody(Jsons);//Send JSON body
          req.setMethod('POST');
          req.setEndpoint(objAuthenticationInfo.instance_url+'/services/apexrest/PFXPromotion');
          if(!Test.isRunningTest()) res = h.send(req);
          
                       if(res.getStatusCode()==200 || Test.isRunningTest()){ 
                       
                       List<Account> acnt = [Select Id,Name,SFS_Account_Record_ID__c From Account Where id=:accId];
                       List<Contact> cnt = [Select Id,SFS_Contact_Record_ID__c,Name From Contact Where id=:CntId];
                       List<Apttus_Proposal__Proposal__c> qut = [Select Id,Got_SFS_Book_Promo__c  From Apttus_Proposal__Proposal__c Where id=:quoteId];

                       Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
                
                  for (String key : m1.keySet()) {
           
                if(String.isNotBlank((String)m1.get('AccountId')) && key.equals('AccountId')){
                
                  acnt[0].SFS_Account_Record_ID__c=(String)m1.get('AccountId');
                 
                 }else if(String.isNotBlank((String)m1.get('ContactID')) && key.equals('ContactID')){
                
                  cnt[0].SFS_Contact_Record_ID__c=(String)m1.get('ContactID');
                 
                 }
            
                }
                       
                       qut[0].Got_SFS_Book_Promo__c= true;
                       update acnt[0];
                       update cnt[0];
                       update qut[0];
                       //return res.getbody();
                       
                      S2S_LogFile__c log=new S2S_LogFile__c(Related_Account__c=accId,API_Type__c='PFX Book Promo',Log_Info__c=Jsons,API_Response_Code__c=res.getStatusCode(),API_Response__c=res.getbody());
                       
                      insert log;
              
                       }else{
                       
                       Result='failure';
                       
                       S2S_LogFile__c log=new S2S_LogFile__c(Related_Account__c=accId,API_Type__c='PFX Book Promo',Log_Info__c=Jsons,API_Response_Code__c=res.getStatusCode(),API_Response__c=res.getbody());
               
                       insert log;
                       //return Result;
                       
                       }
               }else{
               
               Result='Authentication failure';
               
               S2S_LogFile__c log=new S2S_LogFile__c(Related_Account__c=accId,API_Type__c='PFX Book Promo',Log_Info__c=Jsons,API_Response_Code__c=authres.getStatusCode(),API_Response__c=authres.getbody());
               
              insert log;
              
              // return Result;
               
               }
           
           }else{
           
           Result='failure';
           
           S2S_LogFile__c log=new S2S_LogFile__c(Related_Account__c=accId,API_Type__c='PFX Book Promo',Log_Info__c=Jsons,API_Response_Code__c=authres.getStatusCode(),API_Response__c=authres.getbody());
               
           insert log;
               
           //return Result;
           
           } 
           }catch(Exception ex){
   
           Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
           S2S_LogFile__c log=new S2S_LogFile__c();
            
               log.Related_Account__c=accId;
               log.API_Type__c='PFX Book Promo';
               log.Log_Info__c=Result;
               if(authres.getStatusCode() != null)log.API_Response_Code__c=authres.getStatusCode();
               log.API_Response__c=authres.getbody();
               
              insert log;
              
           }
           // return res.getbody();
            
        }   
        
    }