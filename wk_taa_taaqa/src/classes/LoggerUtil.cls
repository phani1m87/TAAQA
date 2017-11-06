public class LoggerUtil {

    public static Monitoring_Log__c createErrorRecord(String className, String controllerClass, String methodName, String detail){
        Monitoring_Log__c  er = new Monitoring_Log__c();
        er.Name = className;
        er.Class__c = controllerClass;
        er.Detail__c = detail;
        er.Method__c = methodName;
        return er;
    }
    
    /*
    @method : createMonitoringLog
    @parameters : String parameters processName, className, detail, methodName, record
    @Description : This method will create monitoring log
    */
    
    public static Monitoring_Log__c  createMonitoringLog(String processName, String className, String detail, String methodName, String accountId, String errorType){
        Monitoring_Log__c  er = new Monitoring_Log__c ();
        er.Name = processName;
        er.Class__c = className;
        er.Detail__c = detail;
        er.Method__c = methodName;
        er.Account__c = accountId;
        er.Type__c = errorType;
        return er;
    }
    
    public static Monitoring_Log__c  createBatchErrorRecord(String className, String controllerClass, String custodialid, String currentRepDtn,String newRepDTN, String custodialRepDTN, String detail,String type,String jobId){
        Monitoring_Log__c  er = new Monitoring_Log__c ();
        er.Name = className;
        er.Class__c = controllerClass;
        er.Detail__c = detail;
        //er.Method__c = methodName;
        //er.Current_Rep_DTN__c=currentRepDtn;
        er.Custodial__c=custodialid;
        //er.New_Rep_DTN__c=newRepDTN;
        er.Type__c=type;
        er.Apex_Job_ID__c= jobId;
        return er;
    }
    
     public static Monitoring_Log__c  createMonitoringLogWithTpe(String processName, String className, String detail, String methodName,String errorType){
        Monitoring_Log__c  er = new Monitoring_Log__c ();
        er.Name = processName;
        er.Class__c = className;
        er.Detail__c = detail;
        er.Method__c = methodName;
        er.Type__c = errorType;
        return er;
    }
    
     public static Monitoring_Log__c  createMonitoringLogWithBatchDetails(String processName, String className, String detail, String methodName, String accountId, String errorType,Id jobId){
        Monitoring_Log__c  er = new Monitoring_Log__c ();
        er.Name = processName;
        er.Class__c = className;
        er.Detail__c = detail;
        er.Method__c = methodName;
        er.Account__c = accountId;
        er.Type__c = errorType;
        er.Apex_Job_ID__c= jobId;
        return er;
        
    }
    
   public static Monitoring_Log__c createErrorRecordWithADM(String processName, String className, String detail, String methodName, String errorType,Id jobId){
        Monitoring_Log__c  er = new Monitoring_Log__c();
        er.Name = processName;
        er.Class__c = className;
        er.Detail__c = detail;
        er.Method__c = methodName;
        er.Type__c = errorType;
        er.Apex_Job_ID__c= jobId;
        return er;
    }
    
}