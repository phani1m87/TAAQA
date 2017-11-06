public class TSM_Util {
    // find the existing PNRC records of previously shared records
    public static Map<Id, PartnerNetworkRecordConnection> fetchExistingShares(Set<Id> recordIdSet, Id networkId) {
        Map<Id, PartnerNetworkRecordConnection> recordShrMap = new Map<Id, PartnerNetworkRecordConnection>();
        // find the respective PNRC records of existing shared accounts
        if(recordIdSet.size() > 0) {
            for(PartnerNetworkRecordConnection recordShrRec : 
                        [SELECT Id, LocalRecordId, PartnerRecordId, Status                                                             
                           FROM PartnerNetworkRecordConnection                                                              
                          WHERE LocalRecordId IN :recordIdSet                                                              
                            AND Status != null AND ConnectionId = :networkId]) {
                recordShrMap.put(recordShrRec.LocalRecordId, recordShrRec);        
            }            
        }
        return recordShrMap;
    }
    
    // this is to create the new sharing records (bulk) - generic
    // #Deprecated :SMS - 752 This method is replaced by insertSharesObject which allows replication Logging
    public static void insertShares(List<PartnerNetworkRecordConnection> pnrcList, String clsName, String procType) {    
        if(!pnrcList.isEmpty()) {
            Database.SaveResult[] results = Database.insert(pnrcList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.SaveResult sr: results) {
                system.debug('Inside save Results===>');
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(prepareLogEntry(err.getMessage(), String.valueOf(err.getStatusCode()), err.getMessage(), 
                                                    clsName, procType));
                        //System.debug(err.getStatusCode(), err.getMessage(), err.getFields())
                        //to capture them in custom object TSM_App_Log__c for reference
                    }
                }
               
            }
            if(!logList.isEmpty())
                Database.insert(logList, false);
        }
    }
    
    // this is to create the new sharing records (bulk) - generic
    //SMS - 752: insertShares method is replaced by insertSharesObject inorder to get PertnerNetworkRecordConnection's Ids
    public static List<String> insertSharesObject(List<PartnerNetworkRecordConnection> pnrcList, String clsName, String procType) {
        List<String> insertedPartnerNetworkRecListIDs = new List<String>();
        if(!pnrcList.isEmpty()) {
            Database.SaveResult[] results = Database.insert(pnrcList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.SaveResult sr: results) {
                system.debug('Inside save Results===>');
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(prepareLogEntry(err.getMessage(), String.valueOf(err.getStatusCode()), err.getMessage(), 
                                                    clsName, procType));            
                        //to capture them in custom object TSM_App_Log__c for reference
                    }
                }
               // SMS -752 : Start
               if(sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted ' + sr.getId());
                insertedPartnerNetworkRecListIDs.add(sr.getId());
               }
               // SMS -752 : End
            }
            if(!logList.isEmpty())
                Database.insert(logList, false);
        }
        
        return insertedPartnerNetworkRecListIDs;
    }
     
    // SMS - 752 : Method for creating Monitoring log for Replication
    Public static void insertReplicationMonitoringLog(List<String> networkConnectionIds,String ObjectType){
        try{
        //List<PartnerNetworkRecordConnection> partnerNeworkObjectLst = [select RelatedRecords,SendClosedTasks,SendEmails,SendOpenTasks,StartDate,Status from PartnerNetworkRecordConnection where id in :networkConnectionIds];
        List<PartnerNetworkRecordConnection> partnerNeworkObjectLst = [SELECT LocalRecordId, RelatedRecords, SendClosedTasks, SendEmails, SendOpenTasks, StartDate, Status FROM PartnerNetworkRecordConnection WHERE Id IN: networkConnectionIds];
        system.debug('partnerNeworkObjectLst===>'+partnerNeworkObjectLst);
        List<ReplicationMonitoringLog__c> replicationLogList = new List<ReplicationMonitoringLog__c>();
        
        if(partnerNeworkObjectLst.size()>0){
            for(PartnerNetworkRecordConnection PartNetRecConnObj:partnerNeworkObjectLst){
                ReplicationMonitoringLog__c  repObj = new ReplicationMonitoringLog__c();
                repObj.ObjectID__c = PartNetRecConnObj.id;
                repObj.LocalRecordID__c = PartNetRecConnObj.LocalRecordId;
                repObj.PartnerNetworkRecord_StartDate__c = PartNetRecConnObj.StartDate;
                repObj.ObjectType__c = ObjectType;
                system.debug('Start===Date'+PartNetRecConnObj.StartDate); 
                repObj.RequestDateTime__c = DateTime.now();
                replicationLogList.add(repObj); 
            }
        }
        system.debug('replicationLogList==>'+replicationLogList);
        if(replicationLogList.size()>0){ 
            insert replicationLogList;
        }
        }catch(Exception e){
          system.debug('inside Exception' +e.getMessage());
        }
    }
    
    
    // this is to invoke the stop sharing records (bulk) - generic
    public static void deleteShares(List<PartnerNetworkRecordConnection> pnrcList, String clsName, String procType) {
        if(!pnrcList.isEmpty()) {
            Database.DeleteResult[] results = Database.delete(pnrcList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.DeleteResult sr: results) { 
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(prepareLogEntry(err.getMessage(), String.valueOf(err.getStatusCode()), err.getMessage(), 
                                                    clsName, procType));
                        //System.debug(err.getStatusCode(), err.getMessage(), err.getFields())
                        //to capture them in custom object TSM_App_Log__c for reference
                    }
                }
            }
            if(!logList.isEmpty())
                Database.insert(logList, false);
        }
    }
    
    // this is to prepare the sharing record - generic
    public static PartnerNetworkRecordConnection prepareShare(Id recordId, Id connectionId, Id parentRecordId) {
        PartnerNetworkRecordConnection newShare = new PartnerNetworkRecordConnection();
        newShare.ConnectionId = connectionId;
        newShare.LocalRecordId = recordId;
        newShare.SendEmails = false;
        newShare.SendClosedTasks = false;
        newShare.SendOpenTasks = false;
        newShare.ParentRecordId = parentRecordId;
        return newShare;
    }
    // return the network id of the accepted/active connection for PNC object
    public static Id getNetworkId(String connectionName) {
        List<PartnerNetworkConnection> connList = new List<PartnerNetworkConnection>();
        connList = [SELECT Id FROM PartnerNetworkConnection
                    WHERE connectionStatus = 'Accepted' 
                    AND connectionName = :connectionName LIMIT 1];
        return (!connList.isEmpty() ? connList[0].Id : null);        
    }
    
    // return the account segment types
    public static Map<String, String> getAccountSegments() {
        Map<String, String> segmentMap = new Map<String, String>();
        segmentMap.put('Accounting Firms', 'Accounting Firms');
        segmentMap.put('Legal Professionals', 'Legal Professionals');
        segmentMap.put('Financial and Estate Planners','Financial and Estate Planners');
        segmentMap.put('Retail Tax Preparers', 'Retail Tax Preparers');
        return segmentMap;
    }
    
    // prepare the app log record
    public static TSM_App_Log__c prepareLogEntry(String errMsg, String recId, String errDesc, String clsName, String procType) {
        TSM_App_Log__c logEntry = new TSM_App_Log__c();
        logEntry.Error_Message__c = errMsg;
        logEntry.Error_Description__c = errDesc;
        logEntry.Process_Type__c = procType;
        logEntry.Name = errMsg;
        logEntry.Record_Id__c = recId;
        logEntry.Stack_Trace__c = clsName;
        return logEntry;
    }
    
    // utility method for fetching the trigger off flag for each object
    public static Boolean fetchTriggerOffFlag(String objName) {
        Map<String, TSM_Trigger_Control__c> controlMap = TSM_Trigger_Control__c.getAll();
        Boolean isTriggerOff = false;
        if(!controlMap.isEmpty() && controlMap.containsKey(objName)) {
            isTriggerOff = controlMap.get(objName).TriggerOff__c;
        }
        return isTriggerOff;
    }
}