/*
 * apex class to perform the S2S records replication for TAA <-> SFS orgs  
 * This class  is used for replicating opp chnages from SFS --> TAA.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/13/2017 Raj Gonola       1.0      Initial draft
 * ------------------------------------------------------------------------- */
public class S2S_OpportunityTriggerHandler {
  
       // for recursion control
    public static boolean alreadyProcessed = false;
    
    
     // processing logic for before update operation
    public static void opponBeforeupdate(Map<Id,Opportunity> newRecordsMap, Map<Id,Opportunity> oldRecordsMap) {
    
        Set<String> ownerEmails = new Set<String>();
        Map<String, Id> userEmailMap = new Map<String, Id>();
        
          for(Opportunity opp: newRecordsMap.values()) {
            
            // this is to prepare the set of email address of the owners
            if(opp.SFS_Opportunity_ID__c != null && opp.TAA_Opportunity_Owner_ID__c != oldRecordsMap.get(opp.Id).TAA_Opportunity_Owner_ID__c ) {
              ownerEmails.add(opp.TAA_Opportunity_Owner_Id__c);
            }
            system.debug('email here'+opp.Owner.Email);
            if(opp.SFS_Opportunity_ID__c  != null && opp.OwnerId != oldRecordsMap.get(opp.Id).OwnerId) {
            system.debug('email here'+opp.Owner.Email);
              opp.TAA_Opportunity_Owner_ID__c= opp.TAA_Opportunity_Owner__c;
            }
            
            if(!String.isblank(oldRecordsMap.get(opp.Id).SFS_Opportunity_ID__c)&& String.isblank(opp.SFS_Opportunity_ID__c)) opp.SFS_Opportunity_ID__c=oldRecordsMap.get(opp.Id).SFS_Opportunity_ID__c;
           }
       
           // map the owner ids to respective owners in SFS 
        for(User usr : [SELECT Id, Email, FederationIdentifier FROM User WHERE Email IN :ownerEmails AND
                IsActive = true AND UserType ='Standard']) {
                  userEmailMap.put(usr.Email, usr.Id);
        }
        
        for(Opportunity opp: newRecordsMap.values()) {
           
           // set the owner ids to respective TAA opportunity owners
           if(opp.SFS_Opportunity_ID__c  != null && opp.TAA_Opportunity_Owner_ID__c != null && userEmailMap.containsKey(opp.TAA_Opportunity_Owner_ID__c)) {
               opp.OwnerId = userEmailMap.get(opp.TAA_Opportunity_Owner_ID__c);
           }
           
        }
    
    }
    
    
    
    
     // processing logic for update operation
    public static void opponAfterupdate(Map<Id,Opportunity> newRecordsMap, Map<Id,Opportunity> oldRecordsMap) {
          
          S2S_OppUtil oput = new S2S_OppUtil();
          List<S2S_OppUtil.opps> setopps = new List<S2S_OppUtil.opps>();
          List<Account> accountToupdate= new List<Account>();
          Map<ID,Opportunity> actpid = new Map<ID,Opportunity>();
          
          Datetime stsrttime;
       stsrttime = Datetime.now();
      Integer seconds = stsrttime.second();
      
        // List of SFDC Account #
        for(Opportunity opp: newRecordsMap.values()) {
            
            // this is to prepare the set of email address of the owners
            if(( opp.OwnerId != oldRecordsMap.get(opp.Id).OwnerId || opp.Name!= oldRecordsMap.get(opp.Id).Name || opp.Amount!= oldRecordsMap.get(opp.Id).Amount || opp.CloseDate!= oldRecordsMap.get(opp.Id).CloseDate || opp.Closed_Reason__c!= oldRecordsMap.get(opp.Id).Closed_Reason__c|| opp.StageName!= oldRecordsMap.get(opp.Id).StageName
                 || opp.Forecast_Type__c!= oldRecordsMap.get(opp.Id).Forecast_Type__c || opp.Competitor__c!= oldRecordsMap.get(opp.Id).Competitor__c ) 
                   && !String.isblank(opp.SFS_Opportunity_ID__c) ) {
            
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
             
             if(opp.SFS_PID__c!= oldRecordsMap.get(opp.Id).SFS_PID__c || opp.SFS_CID__c!= oldRecordsMap.get(opp.Id).SFS_CID__c){
             
                actpid.put(opp.AccountId,opp);
                 
             
             }
            
        }
       
       
         oput.opps =setopps;
         
         String strRequestParam = JSON.serialize(oput);
                
         system.debug('request json'+strRequestParam);
        
        try{         
        
          if(actpid.size()>0){
             
             for(Id aid : actpid.keyset()){
             
               Account a = new Account();
               a.id =aid;
               a.SFS_PID__c =actpid.get(aid).SFS_PID__c ;
               a.SFS_CID__c = actpid.get(aid).SFS_CID__c ;
               
               accountToupdate.add(a);
             }
          
          }
         try{ 
         if(accountToupdate.size()>0) Database.update(accountToupdate,false);
          }catch(Exception  ex){ }
         if(setopps.size()>0) SendInfo(strRequestParam,stsrttime,seconds);  
         S2S_OpportunityTriggerHandler.alreadyProcessed = true;
          }catch(Exception  ex){
          S2S_OpportunityTriggerHandler.alreadyProcessed = true;
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
          if(!Test.isRunningTest()) { req.setEndpoint(objAuthenticationInfo.instance_url+'/services/apexrest/Opportunitysync'); } else {req.setEndpoint('http://fakeurl.com/services/oauth2/token');}
          res = h.send(req);
          system.debug('RESPONSE_BODY'+res.getStatusCode());
          String Error_message;
                       if(res.getStatusCode()==200){ 
                       
                       List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Sync',Jsons ,null,null,'TAA',res.getStatus(),res.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);

                       }else{
                       
                       List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Sync',Jsons ,null,null,'TAA',res.getStatus(),res.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
                       }
               }else{
               
               List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
             logList.add(S2S_Util.prepareLogEntry('Opp Sync',Jsons ,null,null,'TAA',authres.getStatus(),authres.getStatusCode(),stsrttime,seconds));
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
               
               
               }
           
           }else{
           
           List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
              
              logList.add(S2S_Util.prepareLogEntry('Opp Sync',Jsons ,null,null,'TAA',authres.getStatus(),authres.getStatusCode(),stsrttime,seconds));
              
             if(!logList.isEmpty())
              Database.insert(logList, false);
              
           
           
           }
     }catch(Exception ex){
   
           Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           
           List<S2S_LogFile__c> logList = new List<S2S_LogFile__c>();   
             
              logList.add(S2S_Util.prepareLogEntry('Opp Sync',Jsons ,null,null,'TAA',Result,500,stsrttime,seconds));
               
             
             if(!logList.isEmpty())
              Database.insert(logList, false);
            
              
           }
            
            
        }     
}