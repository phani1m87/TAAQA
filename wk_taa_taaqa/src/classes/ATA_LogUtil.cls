/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/28/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public without sharing class ATA_LogUtil 
{
    //SMS - 1040 updated security model of class from with sharing to without sharing because of insufficient priviledges
    // **** Log Utility for ATA 2.0 functionality
    
    // *** utility method to instantiate the Monitoring_Log__c and return it    
    public static Monitoring_Log__c  createMonitoringLog(String processName, String className, String methodName, String detail, String accountId, String errorType)
    {
        Monitoring_Log__c  er = new Monitoring_Log__c();
        er.Name = processName;          // process name {'Account Team Automation'}             
        er.Class__c = className;        // class name
        er.Method__c = methodName;      // method name
        er.Detail__c = detail;          // detail
        er.Account__c = accountId;      // accountId
        er.Type__c = errorType;         // error type
        return er;
    }       
}