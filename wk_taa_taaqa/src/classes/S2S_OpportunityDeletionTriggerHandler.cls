/*
 * apex class to perform the S2S records replication for TAA <-> SFS orgs  
 * This class  is used for replicating opp chnages from SFS --> TAA.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/13/2017 Raj Gonola       1.0      Initial draft
 * ------------------------------------------------------------------------- */
public class S2S_OpportunityDeletionTriggerHandler{
  
    
     // processing logic for update operation
    public static void onAfterDelete(List<Opportunity> oldRecords) {
          
          S2S_OppUtil oput = new S2S_OppUtil();
          List<S2S_OppUtil.opps> setopps = new List<S2S_OppUtil.opps>();
          List<Account> accountToupdate= new List<Account>();
          Map<ID,Opportunity> actpid = new Map<ID,Opportunity>();
          
          Datetime stsrttime;
       stsrttime = Datetime.now();
      Integer seconds = stsrttime.second();
      
        // List of SFDC Account #
        for(Opportunity opp: oldRecords) {
            
            // this is to prepare the set of email address of the owners
            if(  !String.isblank(opp.SFS_Opportunity_ID__c) ) {
            
                 S2S_OppUtil.opps  opplines   = new  S2S_OppUtil.opps();
                 
                 opplines.oneforceAcc=opp.SFDC_Account__c;
                 opplines.oneforceCon=opp.SFDC_Contact__c;
                   
                 opplines.SFSOppRecordId=opp.SFS_Opportunity_ID__c;
                
                 
                 opplines.TAAOppRecordId=opp.Id;
                 
                 
                 opplines.Type=opp.SFS_Opp_Type__c;
                 opplines.Amount=string.valueof(opp.Amount);
                 opplines.StageName=opp.SFS_Opp_Stage__c;
                 
                 opplines.ProductCategory=opp.Product_Category__c;
                 opplines.ProductSubCategory=opp.Product_Sub_Category__c;
                 
                 opplines.ForecastType=opp.Forecast_Type__c;
                 opplines.CloseDate=String.valueof(opp.CloseDate);
                 
                 opplines.CloseReason=opp.Closed_Reason__c;
                 opplines.OtherCloseReason=opp.Reason_Details_Other_Reason__c;
                 
                 opplines.Competitor=opp.Competitor__c;
                 opplines.OtherCompetitor=opp.Other_Competitor__c;
                 opplines.OppOwner=opp.TAA_Opportunity_Owner_Id__c ;
                 opplines.Name=opp.Name;
                 
                 
            
              setopps.add(opplines);
             
             }
             
             
            
        }
       
       
         oput.opps =setopps;
         
         String strRequestParam = JSON.serialize(oput);
                
         system.debug('request json'+strRequestParam);
        
        try{         
        
         
         if(setopps.size()>0) SendInfo(strRequestParam,stsrttime,seconds);  
         
          }catch(Exception  ex){
          
          }
    } 
    
    
    
     @future(callout=true)
    public static void SendInfo(String Jsons,DateTime stsrttime,Integer seconds) {
    
        String Result;
        
        HttpResponse authres =OauthUtil.Authenticate('');
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
          if(!Test.isRunningTest()) { req.setEndpoint(objAuthenticationInfo.instance_url+'/services/apexrest/OpportunityDeletion'); } else {req.setEndpoint('http://fakeurl.com/services/oauth2/token');}
          res = h.send(req);
          system.debug('RESPONSE_BODY'+res.getStatusCode());
          String Error_message;
                       if(res.getStatusCode()==200){ 
                       
                       List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Del',Jsons ,null,null,'TAA',res.getStatus(),res.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);

                       }else{
                       
                       List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Del',Jsons ,null,null,'TAA',res.getStatus(),res.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
                       }
               }else{
               
               List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Del',Jsons ,null,null,'TAA',authres.getStatus(),authres.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
               
               
               }
           
           }else{
           
           List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
              logList.add(S2S_Util.prepareLogEntry('Opp Del',Jsons ,null,null,'TAA',authres.getStatus(),authres.getStatusCode(),stsrttime,seconds));
              
             if(!logList.isEmpty())
              Database.insert(logList, false);
              
           
           
           }
     }catch(Exception ex){
   
           Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
           List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
             
              logList.add(S2S_Util.prepareLogEntry('Opp Del',Jsons ,null,null,'TAA',Result,500,stsrttime,seconds));
               
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
            
              
           }
            
            
        }     
}