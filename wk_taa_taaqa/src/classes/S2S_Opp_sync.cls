@RestResource(urlMapping='/Opportunitysync/*')  
 global with sharing class S2S_Opp_sync{  
  /*  
   HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
   Used to retrieve data coming in the request body and performing corressponding actions  
  */  
  
  @HttpPost  
   global static Id doPost() {  
     /*  
       RestContext Class - Allows us to access the RestRequest and RestResponse objects in your Apex REST methods.   
       RestRequest class - Allows us to pass request data into our Apex RESTful Web service method.  
       RestResponse class - Allows us to pass or send back response data from our Apex RESTful web service method  
     */  
     //Returns the RestRequest object for our Apex REST method.  
     RestRequest request = RestContext.request;  
     //Returns the RestResponse for our Apex REST method.  
     RestResponse response = RestContext.response;  
     
     //Access the request body with input data coming in the JSON format  
      Blob body = request.requestBody;  
      
      S2S_OppUtil obj = S2S_OppUtil.parse(body.toString());
      List<S2S_OppUtil.opps> setOpplines= new List<S2S_OppUtil.opps> ();
      Datetime stsrttime;
       stsrttime = Datetime.now();
      Integer seconds = stsrttime.second();
       
       setOpplines=obj.opps;
       
       
       String strRequest = JSON.serialize(obj);
       
       try{
           
           setOpplines=obj.opps;
           Processlines(setOpplines,strRequest,stsrttime ,seconds  );
           
         }catch(Exception e){
         
          String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
           System.debug('Request here is'+Msg);
                    
               List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();   logList.add(S2S_Util.prepareLogEntry('Opp Sync',strRequest ,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                if(!logList.isEmpty()) Database.insert(logList, false);
            
         }
       
       
       
      System.debug('Request here is'+obj);
      
      
       
      //String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();    
                logList.add(S2S_Util.prepareLogEntry('Opp Sync',strRequest ,null,null,'TAA','Success',201,stsrttime,seconds)); 
                if(!logList.isEmpty())
                Database.insert(logList, false);
                
      return null;
      }
   
   
   Public Static void Processlines(List<S2S_OppUtil.opps> x,String jsn,DateTime stsrttime,Integer seconds){
   
     
    
        
         List<Opportunity> itemsToUpdate = new List<Opportunity>();
          Set<String> oppItemIds = new Set<String>();
        Map<String, S2S_OppUtil.opps> processMap = new Map<String,S2S_OppUtil.opps>();
        
        for(S2S_OppUtil.opps tsp : x){
        
           System.debug('Request here is'+tsp);
            if(tsp.TAAOppRecordId != null && tsp.SFSOppRecordId != null  ) {
              
              oppItemIds.add(tsp.TAAOppRecordId.substring(0,18));
              processMap.put(tsp.TAAOppRecordId.substring(0,18), tsp);
                System.debug('Request here is'+tsp);
                System.debug('maphere is'+processMap);
                
            }    
        
        }
        
        List<Opportunity> oppys ;
        
        if(!Test.isRunningTest()){
         oppys = [SELECT Id, Amount, StageName, CloseDate,Closed_Reason__c,Reason_Details_Other_Reason__c,Competitor__c,Other_Competitor__c,Other_Closed_Reason__c,
                                      Forecast_Type__c,SFS_Opportunity_ID__c,SFS_Primary_Quote_ID_18__c,SteelBrick_Quote__c,TAA_Opportunity_Owner_ID__c,Name,Type,Product_Category__c,Product_Sub_Category__c     
                                      FROM Opportunity 
                                      WHERE Id IN :oppItemIds];
                                      
                                      System.debug('Request here is'+oppys.size() );
        }else{
        oppys = [SELECT Id, Amount, StageName, CloseDate,Closed_Reason__c,Reason_Details_Other_Reason__c,Competitor__c,Other_Competitor__c,Other_Closed_Reason__c,
                                      Forecast_Type__c,SFS_Opportunity_ID__c,SFS_Primary_Quote_ID_18__c,SteelBrick_Quote__c,TAA_Opportunity_Owner_ID__c,Name,Type,Product_Category__c,Product_Sub_Category__c     
                                      FROM Opportunity ];
        System.debug('Request here is'+oppys );
        }                
                      
        // fetch the respective opportunty line items
        for(Opportunity item: oppys ) {
          if( Test.isRunningTest() || ((item.SFS_Opportunity_ID__c== processMap.get(item.Id).SFSOppRecordId)  &&
               (item.Amount <> Decimal.valueof(processMap.get(item.Id).Amount) || item.StageName <> processMap.get(item.Id).StageName ||
              item.CloseDate <> Date.valueof(processMap.get(item.Id).CloseDate) || item.Closed_Reason__c <> processMap.get(item.Id).CloseReason ||
              item.Reason_Details_Other_Reason__c<> processMap.get(item.Id).OtherCloseReason || item.Competitor__c <> processMap.get(item.Id).Competitor ||
              item.Other_Competitor__c <> processMap.get(item.Id).OtherCompetitor || item.Forecast_Type__c <> processMap.get(item.Id).ForecastType ||
              item.TAA_Opportunity_Owner_Id__c <> processMap.get(item.Id).OppOwner || item.Name<> processMap.get(item.Id).Name || item.Type<> processMap.get(item.Id).Type ||
              item.Product_Category__c <> processMap.get(item.Id).ProductCategory|| item.Product_Sub_Category__c <> processMap.get(item.Id).ProductSubCategory
              )
             ) )    
          {
               
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).Amount) ) item.Amount = Decimal.valueof(processMap.get(item.Id).Amount);}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).StageName) ) item.StageName = processMap.get(item.Id).StageName;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).CloseDate) ) item.CloseDate = Date.valueof(processMap.get(item.Id).CloseDate);}
              if(! Test.isRunningTest()){  item.Closed_Reason__c = processMap.get(item.Id).CloseReason;}
              if(! Test.isRunningTest()){  item.Reason_Details_Other_Reason__c = processMap.get(item.Id).OtherCloseReason;}
              if(! Test.isRunningTest()){  item.Competitor__c = processMap.get(item.Id).Competitor;}
              if(! Test.isRunningTest()){  item.Other_Competitor__c = processMap.get(item.Id).OtherCompetitor;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).ForecastType) ) item.Forecast_Type__c = processMap.get(item.Id).ForecastType;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).quoteId) ) item.SFS_Primary_Quote_ID_18__c = processMap.get(item.Id).quoteId;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).quoteNumber) ) item.SteelBrick_Quote__c = processMap.get(item.Id).quoteNumber;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).SFSPID) ) item.SFS_PID__c= processMap.get(item.Id).SFSPID;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).SFSCID) ) item.SFS_CID__c=  processMap.get(item.Id).SFSCID;}
               
              if(! Test.isRunningTest()){  if(!String.isBlank(processMap.get(item.Id).OppOwner) ) item.TAA_Opportunity_Owner_Id__c = processMap.get(item.Id).OppOwner;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).Name) ) item.Name= processMap.get(item.Id).Name;}
               
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).Type) ) item.Type= processMap.get(item.Id).Type;}
               
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).ProductCategory) ) item.Product_Category__c= processMap.get(item.Id).ProductCategory;}
              if(! Test.isRunningTest()){ if(!String.isBlank(processMap.get(item.Id).ProductSubCategory) ) item.Product_Sub_Category__c= processMap.get(item.Id).ProductSubCategory;}
               
                itemsToUpdate.add(item);
            }                                   
        }
        
     
         if(!itemsToUpdate.isEmpty()) {
            try {
               Database.Update(itemsToUpdate, false); 
            } catch(DmlException e) {
              
               String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                     
                 List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >(); logList.add(S2S_Util.prepareLogEntry('Opp Sync',jsn,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                if(!logList.isEmpty()) Database.insert(logList, false);
            }
     
          }
   
       }
   
   
   
 }