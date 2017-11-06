public class S2S_Util {
  
    
    
    // prepare the app log record
    public static S2S_LogFile__c prepareLogEntry(String apiType, String info, String accId, String oppId, String surc,String rsp, Integer rspcode,DateTime rqsttm,Integer rqsec) {
        S2S_LogFile__c logEntry = new S2S_LogFile__c();
        logEntry.API_Type__c= apiType;
        logEntry.Log_Info__c= info;
        logEntry.Related_Account__c= accId;
        logEntry.Related_Opportunity__c= oppId;
        logEntry.Source__c= surc;
        
        logEntry.API_Request_Time__c=rqsttm;
        logEntry.API_Response_Time__c=Datetime.now();
        logEntry.API_Request_Time_sec__c=String.valueof(rqsec);
        logEntry.API_Response_Time_sec__c=String.valueof(logEntry.API_Response_Time__c.second());
                       
        logEntry.API_Response__c= rsp;
        logEntry.API_Response_Code__c= rspcode;
        return logEntry;
    }
    
    // utility method for fetching the trigger off flag for each object
    public static Boolean fetchTriggerOffFlag(String objName) {
        Map<String, S2S_Trigger_Control__c> controlMap = S2S_Trigger_Control__c.getAll();
        Boolean isTriggerOff = false;
        if(!controlMap.isEmpty() && controlMap.containsKey(objName)) {
            isTriggerOff = controlMap.get(objName).TriggerOff__c;
        }
        return isTriggerOff;
    }
}