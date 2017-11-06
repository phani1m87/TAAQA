/*
    **************************************************************************
    Name    :   SyncAccountstoSFS
    Used for  :   This Apex class is used to push information from TAA to SFS, so that there is an opportunity,Account and Contact created  in SFS Salesforce Instance, only If it is a Small Firm Sale.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
    
    ***************************************************************************
*/

global class S2S_SyncAccountstoSFS
{
      
      
      //service to create json file for Account and contact
      
      webservice Static String pushaccount(Id oppid){
      
      
         
      Map<Id, Account> acctMap = new Map<Id, Account>();
      String response;
       
      String result;
      Datetime stsrttime;
      
      stsrttime = Datetime.now();
      Integer seconds = stsrttime.second();
        
      List<Opportunity> opp=[Select Id,AccountID, SFS_Opp_Stage__c , SFS_Opp_Type__c ,SFS_Opportunity_ID__c,TAA_Opportunity_Owner_Text__c,Primary_Contact_for_Proposal__c,Owner.id,Type,Amount,StageName,Product_Category__c,Product_Sub_Category__c,Forecast_Type__c,CloseDate,Name,SFDC_Opportunity__c From Opportunity Where  Id=:oppid];
      
      
      List<Account> accountstopush =[Select id,Name,Phone,Market_Segment__c,Market_Sub_Segment__c,SFDC_Account_Text__c,BillingStreet, BillingCity,
                                            BillingState, BillingPostalCode, BillingCountry,ShippingStreet,ShippingCity,ShippingState,
                                            ShippingPostalCode,ShippingCountry From Account Where id=:opp[0].AccountID];
      
      
      List<Contact> cnt=[Select Id,Name,Phone,Email,LastName,FirstName,SFDC_Contact_Text__c  From Contact Where  id=:opp[0].Primary_Contact_for_Proposal__c];
            
            if(opp[0].SFS_Opportunity_ID__c == null || opp[0].SFS_Opportunity_ID__c ==''){
            
           
             try{ 
       
                 
                 S2S_JsonUtil accInfo=new S2S_JsonUtil();
                
                 
                 
                 S2S_JsonUtil.Customer custInfo=new S2S_JsonUtil.Customer();
                 
                 custInfo.Name=accountstopush[0].Name;
                 custInfo.AccoutNumber=accountstopush[0].SFDC_Account_Text__c;
                 custInfo.AccountRecordId=accountstopush[0].id;
                 custInfo.Phone=accountstopush[0].Phone;
                 custInfo.Segment=accountstopush[0].Market_Segment__c;
                 custInfo.subsegment=accountstopush[0].Market_Sub_Segment__c;
                
                  
                 custInfo.BillingAdress=accountstopush[0].BillingStreet;                                        
                 custInfo.BillingCity=accountstopush[0].BillingCity;
                 custInfo.BillingState=accountstopush[0].BillingState;
                 custInfo.BillingZip=accountstopush[0].BillingPostalCode;
                 if(!String.IsBlank(accountstopush[0].BillingCountry)){
                 custInfo.Billingcountry=accountstopush[0].BillingCountry;
                 }else{
                 custInfo.Billingcountry='US';
                 }
                 custInfo.ShippingAdress=accountstopush[0].BillingStreet;
                 custInfo.ShippingCity=accountstopush[0].BillingCity;
                 custInfo.ShippingState=accountstopush[0].BillingState;
                 custInfo.ShippingZip=accountstopush[0].BillingPostalCode;
                 custInfo.Shippingcountry=accountstopush[0].BillingCountry;                 
                  
                  
                 accInfo.Customer=custInfo;
                 
                 
                 
                S2S_JsonUtil.Contacts Contacts = new S2S_JsonUtil.Contacts ();
                
                 Contacts.FirstName=cnt[0].FirstName;
                 Contacts.LastName=cnt[0].LastName;
                 Contacts.Email=cnt[0].Email;
                 Contacts.Phone=cnt[0].Phone;
                 Contacts.ContactRecordId=cnt[0].id;
                 Contacts.ContactNumber=cnt[0].SFDC_Contact_Text__c;
                 
                 accInfo.Contacts=Contacts;
                 
                 
                S2S_JsonUtil.Opportunity Opportunity = new S2S_JsonUtil.Opportunity ();
                
                 Opportunity.OppRecordId=opp[0].Id;
                 Opportunity.AccountID=opp[0].AccountID;
                 Opportunity.PrimaryContact=opp[0].Primary_Contact_for_Proposal__c;
                 Opportunity.Type=opp[0].SFS_Opp_Type__c;
                 Opportunity.Amount=string.valueof(opp[0].Amount);
                 Opportunity.StageName=opp[0].SFS_Opp_Stage__c;
                 Opportunity.ProductCategory=opp[0].Product_Category__c;
                 Opportunity.ProductSubCategory=opp[0].Product_Sub_Category__c;
                 Opportunity.ForecastType=opp[0].Forecast_Type__c;
                 Opportunity.CloseDate=String.valueof(opp[0].CloseDate);
                 Opportunity.Name=opp[0].Name;
                 Opportunity.SFDCOpportunity =opp[0].SFDC_Opportunity__c ;
                 Opportunity.OppOwner=opp[0].TAA_Opportunity_Owner_Text__c;
                 
                 accInfo.Opportunity=Opportunity;
                  
                //serialize the request
                String strRequestParam = JSON.serialize(accInfo);
                
                 system.debug('request json'+strRequestParam);
                 
                 response=SendInfo(strRequestParam,accountstopush[0].id,cnt[0].id,opp[0].id,stsrttime);
                 
                 response= response.replace('"','');
             
                 system.debug('Resp String'+response);
                
                return response;
                
                
               }catch(Exception ex){
   
           String Results='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
            S2S_LogFile__c log=new S2S_LogFile__c();
            
                       log.Related_Account__c=accountstopush[0].id;
                       log.API_Type__c='Create Quote Button';    log.Source__c='TAA';
                       log.Log_Info__c=Results;
                       log.API_Request_Time__c=stsrttime;
                       log.API_Response_Time__c=Datetime.now();
                       log.Related_Opportunity__c=opp[0].Id;
                       log.API_Response_Code__c=6000;
                       log.API_Request_Time_sec__c=String.valueof(stsrttime.second());
                       log.API_Response_Time_sec__c=String.valueof(log.API_Response_Time__c.second());
                       
               
              insert log;
               
               return Results;
           }   
      
       }else{
           String Results='You may have already created a Steelbrick Quote for this Opportunity.';
            return Results;
            
          }  
      }
      
      
       
  
    
    public static String SendInfo(String Jsons,String accId,String CntId,string oppId,Datetime stsrttime) {
    
        String Result;
        
        HttpResponse authres = OauthUtil.Authenticate('');
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
         try{
         
        system.debug('Auth request response'+authres.getStatusCode());
        
        
        
        if(authres.getStatusCode()==200){ 
            
        OauthUtil.OAuth2 objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(authres.getbody(), OauthUtil.OAuth2.class);
       
        
        if(objAuthenticationInfo.access_token!=null){
        
        
          Http h = new Http();
          
          req.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
          req.setHeader('Content-Type','application/json');
          req.setHeader('accept','application/json');
          req.setTimeout(120000);
        
          req.setBody(Jsons);//Send JSON body
          req.setMethod('POST');
          if(!Test.isRunningTest()) { req.setEndpoint(objAuthenticationInfo.instance_url+'/services/apexrest/syncaccount'); } else {req.setEndpoint('http://fakeurl.com/services/oauth2/token');}
          res = h.send(req);
          system.debug('RESPONSE_BODY'+res.getStatusCode());
          String Error_message;
                       if(res.getStatusCode()==200){ 
                       
                       List<Account> acnt = [Select Id,Name,SFS_Account_Record_ID__c From Account Where id=:accId];
                       List<Contact> cnt = [Select Id,SFS_Contact_Record_ID__c,Name From Contact Where id=:CntId];
                       List<Opportunity> p= [Select Id,SFS_Opportunity_ID__c,Name From Opportunity Where id=:oppId];
                       
                       Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
                            
                              for (String key : m1.keySet()) {
                       
                            if(String.isNotBlank((String)m1.get('AccountId')) && key.equals('AccountId')){
                            
                              acnt[0].SFS_Account_Record_ID__c=(String)m1.get('AccountId');
                             
                             }else if(String.isNotBlank((String)m1.get('ContactID')) && key.equals('ContactID')){
                            
                              cnt[0].SFS_Contact_Record_ID__c=(String)m1.get('ContactID');
                             
                             }else if(String.isNotBlank((String)m1.get('OppId')) && key.equals('OppId')){
                            
                              p[0].SFS_Opportunity_ID__c=(String)m1.get('OppId');
                             
                             }else if(String.isNotBlank((String)m1.get('ErrorMessage')) && key.equals('ErrorMessage')){
                            
                              Error_message=(String)m1.get('ErrorMessage');
                             
                             }
                        
                            }
                            
                       update acnt[0];
                       update cnt[0];
                       update p[0];
                        S2S_LogFile__c log=new S2S_LogFile__c();
            
                       log.Related_Account__c=accId;
                       log.API_Type__c='Create Quote Button';    log.Source__c='SFS';
                       log.Log_Info__c=Jsons;
                       log.Related_Opportunity__c=oppId;
                       log.API_Request_Time__c=stsrttime;
                       log.API_Response_Time__c=Datetime.now();
                       log.API_Response_Code__c=res.getStatusCode();
                       log.API_Response__c=res.getbody();
                       log.API_Request_Time_sec__c=String.valueof(stsrttime.second());
                       log.API_Response_Time_sec__c=String.valueof(log.API_Response_Time__c.second());
                       
                      insert log;
                       
                       if(!String.isNotBlank(Error_message)){
                       
                        return p[0].SFS_Opportunity_ID__c;
                       }else{return Error_message;} 
                       
                       }else{
                       
                       
                        
                         Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
                            
                              for (String key : m1.keySet()) {
                       
                            if(String.isNotBlank((String)m1.get('Response_Message')) && key.equals('Response_Message')) Result =(String)m1.get('Response_Message');
                            
                           }  
                         Integer seconds = Datetime.now().second();    
                          
                        S2S_LogFile__c log=new S2S_LogFile__c(API_Request_Time__c=stsrttime,API_Response_Time__c=Datetime.now(),Related_Account__c=accId,API_Request_Time_sec__c=String.valueof(stsrttime.second()),API_Response_Time_sec__c=String.valueof(Datetime.now().second()),API_Type__c='Create Quote Button',Source__c='SFS',Log_Info__c=Jsons,Related_Opportunity__c=oppId,API_Response_Code__c=res.getStatusCode(),API_Response__c=res.getbody());
                           
                          insert log;
                          
                       return Result;
                       
                       }
               }else{
               
               Map<String, Object> m1= (Map<String, Object>)JSON.deserializeUntyped(authres.getbody());
                            
                              for (String key : m1.keySet()) {
                       
                            if(String.isNotBlank((String)m1.get('Response_Message')) && key.equals('Response_Message'))  Result =(String)m1.get('Response_Message');
                            
                            
                           }
                           
                S2S_LogFile__c log=new S2S_LogFile__c(API_Request_Time__c=stsrttime,API_Response_Time__c=Datetime.now(),API_Request_Time_sec__c=String.valueof(stsrttime.second()),API_Response_Time_sec__c=String.valueof(Datetime.now().second()),Related_Account__c=accId,API_Type__c='Create Quote Button',Source__c='SFS',Log_Info__c=Jsons,Related_Opportunity__c=oppId,API_Response_Code__c=authres.getStatusCode(),API_Response__c=authres.getbody());
               
              insert log;
              
               return Result;
               
               }
           
           }else{
           
           Result='Authentication failure';
           S2S_LogFile__c log=new S2S_LogFile__c(API_Request_Time__c=stsrttime,API_Response_Time__c=Datetime.now(),API_Request_Time_sec__c=String.valueof(stsrttime.second()),API_Response_Time_sec__c=String.valueof(Datetime.now().second()),Related_Account__c=accId,API_Type__c='Create Quote Button',Source__c='TAA',Log_Info__c=Jsons,Related_Opportunity__c=oppId);
               if(authres.getStatusCode() != null){ log.API_Response_Code__c=authres.getStatusCode();log.API_Response__c=authres.getbody();}
               
              insert log;
              
           return Result;
           
           } 
            }catch(Exception ex){
   
           Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
           S2S_LogFile__c log=new S2S_LogFile__c(API_Request_Time__c=stsrttime,API_Response_Time__c=Datetime.now(),API_Request_Time_sec__c=String.valueof(stsrttime.second()),API_Response_Time_sec__c=String.valueof(Datetime.now().second()),Related_Account__c=accId,API_Type__c='Create Quote Button',Source__c='TAA',Log_Info__c=Jsons,Related_Opportunity__c=oppId);
               if(authres.getStatusCode() != null){ log.API_Response_Code__c=authres.getStatusCode(); log.API_Response__c=Result+authres.getbody();}
              insert log;
            
            return Result;  
           }
            return Result;
            
        }   
  
  

 }