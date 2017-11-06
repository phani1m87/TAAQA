@RestResource(urlMapping='/OpportunityLines/*')  
 global with sharing class S2S_Opp_Linessync{  
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
      
      S2S_OppLinesUtil obj = S2S_OppLinesUtil.parse(body.toString());
      S2S_OppLinesUtil.OppProducts  lns= new S2S_OppLinesUtil.OppProducts  ();
       List<S2S_OppLinesUtil.Opp_Lines> setOpplines= new List<S2S_OppLinesUtil.Opp_Lines> ();
       Datetime stsrttime;
       stsrttime = Datetime.now();
      Integer seconds = stsrttime.second();
      
       lns=obj.OppProducts;
       
       
       String strRequest = JSON.serialize(obj);
       
       try{
           if(lns.Request_Type =='INSERT'){
           setOpplines=obj.OppProducts.Opp_Lines;
           Processlines(lns.Request_Type,setOpplines,strRequest,stsrttime,seconds );
            
           }else if(lns.Request_Type =='UPDATE'){
           
           setOpplines=obj.OppProducts.Opp_Lines;
           Processlines(lns.Request_Type,setOpplines,strRequest,stsrttime,seconds );
           
           }else if(lns.Request_Type =='DELETE'){
           
           setOpplines=obj.OppProducts.Opp_Lines;
           Processlines(lns.Request_Type,setOpplines,strRequest,stsrttime,seconds );
           
           }
         }catch(Exception e){
         
          String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();   logList.add(S2S_Util.prepareLogEntry('Opp Lines',strRequest ,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                if(!logList.isEmpty())  Database.insert(logList, false);
                
      
         
         
         }
       
       
       
      System.debug('Request here is'+obj);
      
      
      
      //String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();    
                logList.add(S2S_Util.prepareLogEntry('Opp Lines',strRequest ,null,null,'TAA','Success',201,stsrttime,seconds)); 
                if(!logList.isEmpty())
                Database.insert(logList, false);
                
      return null;
      }
   
   
   Public Static void Processlines(String Request,List<S2S_OppLinesUtil.Opp_Lines> x,String jsn,DateTime stsrttime,Integer seconds){
   
     
     
     if(Request =='INSERT'){
     
        List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
        
        Map<ID,String> opptoQuotenumber = new Map<ID,String>();
        Map<ID,String> opptoQuoteId = new Map<ID,String>();
        
        for(S2S_OppLinesUtil.Opp_Lines tsp : x){
        
        
            if(tsp.SFDCOpportunity != null && tsp.Product_Number!= null && 
              tsp.Opp_Product_Id != null) {
                itemsList.add(new OpportunityLineItem(SFDC_Product__c=tsp.Product_Number,
                                                     SFS_Opportunity_Record_Id__c=tsp.SFDCOpportunity.substring(0,18) ,
                                                     SFS_Opportunity_Product_Record_ID__c=tsp.Opp_Product_Id.substring(0,18) ,
                                                     UnitPrice=tsp.Unit_Price,
                                                     Steelbrick_Quote__c=true, 
                                                     Quantity=tsp.Quantity));
                                                     
                                       opptoQuotenumber.put(tsp.SFDCOpportunity,tsp.QuoteNumber); 
                                       opptoQuoteId.put(tsp.SFDCOpportunity,tsp.QuoteId);             
            }    
        
        }
     
         if(!itemsList.isEmpty()) {
            try {
                 
                
                List<Opportunity> oppUpdatelist = new List<Opportunity>();
               
               if(!opptoQuotenumber.isEmpty()){ 
                 for(Opportunity item: [SELECT Id, SteelBrick_Quote__c,SFS_Opportunity_ID__c , SFS_Primary_Quote_ID_18__c FROM Opportunity
                                                       WHERE SFS_Opportunity_ID__c IN :opptoQuotenumber.keyset()]) {
                   
                   item.SteelBrick_Quote__c = opptoQuotenumber.get(item.SFS_Opportunity_ID__c.substring(0,18) );
                   item.SFS_Primary_Quote_ID_18__c= opptoQuoteId.get(item.SFS_Opportunity_ID__c.substring(0,18) );
                   oppUpdatelist.add(item);
                                               
                 }
                }
                try {
                if(!oppUpdatelist.isEmpty()) Database.update(oppUpdatelist,false); 
                }
                 catch(DmlException e) {  
                  String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();    
                  logList.add(S2S_Util.prepareLogEntry('Opp Lines',jsn,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                    if(!logList.isEmpty())
                    Database.insert(logList, false);
                insert itemsList; 
                }
                
                insert itemsList; 
                
            } catch(DmlException e) {
            
             String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();    
                logList.add(S2S_Util.prepareLogEntry('Opp Lines',jsn,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                if(!logList.isEmpty())
                    Database.insert(logList, false);
            }
     
          }
   
       }else if(Request =='UPDATE'){
        
         List<OpportunityLineItem> itemsToUpdate = new List<OpportunityLineItem>();
          Set<String> oppItemIds = new Set<String>();
        Map<String, S2S_OppLinesUtil.Opp_Lines> processMap = new Map<String, S2S_OppLinesUtil.Opp_Lines>();
        
        for(S2S_OppLinesUtil.Opp_Lines tsp : x){
        
        
            if(tsp.SFDCOpportunity != null && tsp.Product_Number!= null && 
              tsp.Opp_Product_Id != null  ) {
              
              oppItemIds.add(tsp.Opp_Product_Id.substring(0,18));
              processMap.put(tsp.Opp_Product_Id.substring(0,18), tsp);
                
                
            }    
        
        }
        
        // fetch the respective opportunty line items
        for(OpportunityLineItem item: [SELECT Id, SFS_Opportunity_Record_Id__c, UnitPrice, 
                                       Quantity, SFDC_Product__c, SFS_Opportunity_Product_Record_ID__c 
                                       FROM OpportunityLineItem 
                                       WHERE SFS_Opportunity_Product_Record_ID__c IN :oppItemIds]) {
          if(item.SFDC_Product__c != null && item.SFDC_Product__c == processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).Product_Number) {
              
              item.UnitPrice = processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).Unit_Price;
              item.Quantity = processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).Quantity;
               
                itemsToUpdate.add(item);
            }                                   
        }
        
     
         if(!itemsToUpdate.isEmpty()) {
            try {
                Database.update(itemsToUpdate,false);  
            } catch(DmlException e) {
              
               String Msg='Something Went wrong'+e.getMessage()+e.getLineNumber()+e.getStackTraceString();
                  List<S2S_LogFile__c > logList = new List<S2S_LogFile__c >();  logList.add(S2S_Util.prepareLogEntry('Opp Lines',jsn,null,null,'TAA',Msg,500,stsrttime,seconds)); 
                if(!logList.isEmpty()) Database.insert(logList, false);
            }
     
          }
   
       }else if(Request =='DELETE'){
        
          List<Id> oppItemForDeleteIds = new List<Id>();
          List<Id> oppItemIds = new List<Id>();
        for(S2S_OppLinesUtil.Opp_Lines tsp : x){
        
        
            if(tsp.SFDCOpportunity != null && tsp.Product_Number!= null && 
              tsp.Opp_Product_Id != null  ) {
                oppItemIds.add(tsp.Opp_Product_Id.substring(0,18) );
            }    
        
        }
        
          if(!oppItemIds.isEmpty()) {
           // fetch the respective opportunty line items
          for(OpportunityLineItem item: [SELECT Id 
                                       FROM OpportunityLineItem 
                                       WHERE SFS_Opportunity_Product_Record_ID__c IN :oppItemIds]) {
               oppItemForDeleteIds.add(item.Id);                        
          }
        }
        if(!oppItemForDeleteIds.isEmpty()) { Database.delete(oppItemForDeleteIds, false); }
   
       }
   
   
   }
 }