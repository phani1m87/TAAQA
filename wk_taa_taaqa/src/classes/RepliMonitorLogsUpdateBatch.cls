public class RepliMonitorLogsUpdateBatch implements Database.Batchable<sObject>
{
	public Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(QueryServiceClass.getReplicationMonitorLogQuery());
   	}

	public void execute(Database.BatchableContext BC, List<ReplicationMonitoringLog__c> scope)
	{
		List<ReplicationMonitoringLog__c> lstUpdateReplMonLog = new List<ReplicationMonitoringLog__c>(); 
		Set<Id> setReplMonLogsId = new Set<Id>();
		Map<Id, ReplicationMonitoringLog__c> mapReplicationMonLogs = new Map<Id, ReplicationMonitoringLog__c>();
		for(ReplicationMonitoringLog__c obj : scope){
			if(obj.ObjectID__c != NULL){
				setReplMonLogsId.add(obj.ObjectID__c);
				mapReplicationMonLogs.put(obj.ObjectID__c, obj);	
			}
		}
		
		Map<Id, PartnerNetworkRecordConnection> mapPartNwCon = new Map<Id, PartnerNetworkRecordConnection>([SELECT Id, LocalRecordId, StartDate, PartnerRecordId, Status FROM PartnerNetworkRecordConnection WHERE ID IN: setReplMonLogsId]);
		
		for(Id objId : mapReplicationMonLogs.keySet()){
			if(mapPartNwCon != NULL && mapPartNwCon.get(objId) != NULL){
				mapReplicationMonLogs.get(objId).PartnerNetworkRecord_StartDate__c = mapPartNwCon.get(objId).StartDate;
				lstUpdateReplMonLog.add(mapReplicationMonLogs.get(objId));	
			}
		}
		
		if(lstUpdateReplMonLog != NULL && lstUpdateReplMonLog.size() > 0)
		{
			upsert lstUpdateReplMonLog;
		}
    }

   	public void finish(Database.BatchableContext BC)
   	{
   	}   
}