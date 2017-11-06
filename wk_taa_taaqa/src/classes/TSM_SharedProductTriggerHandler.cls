/*
 * Helper class for TSM_SharedProductTrigger on custom object TSM_Shared_Product__c
 * This will create the opportunity product records in TAA org based on TSM_Shared_Product__c records
 * */
public class TSM_SharedProductTriggerHandler {
	// method for processing new records
    public static void onAfterInsert(List<TSM_Shared_Product__c> newRecords) {
  		List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
        for(TSM_Shared_Product__c tsp : newRecords) {
            if(tsp.SFS_Opportunity_Record_Id__c != null && tsp.SFDC_Product__c != null && 
              tsp.SFS_Oppty_Product_Record_ID__c != null) {
                itemsList.add(new OpportunityLineItem(SFDC_Product__c=tsp.SFDC_Product__c,
                                                     SFS_Opportunity_Record_Id__c=tsp.SFS_Opportunity_Record_Id__c,
                                                     SFS_Opportunity_Product_Record_ID__c=tsp.SFS_Oppty_Product_Record_ID__c,
                                                     UnitPrice=tsp.Unit_Price__c,
                                                     Steelbrick_Quote__c=true, 
                                                     Quantity=tsp.Quantity__c));
            }    
        }
        //insert the records
        if(!itemsList.isEmpty()) {
            try {
                insert itemsList;  
            } catch(DmlException e) {
    			System.debug('The following exception has occurred: ' + e.getMessage());
                List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();    
                logList.add(TSM_Util.prepareLogEntry(e.getMessage(), 
                                                             String.valueOf(e.getLineNumber()), 
                                                             e.getStackTraceString(), 'TSM_SharedProductTrigger', 'onAfterInsert'));      
			}
                     
            /* Database.SaveResult[] results = Database.insert(itemsList, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.SaveResult sr: results) {
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(TSM_Util.prepareLogEntry(err.getMessage(), 
                                                             String.valueOf(err.getStatusCode()), 
                                                             err.getMessage(), 'TSM_SharedProductTrigger', 'onAfterInsert'));
                    }
                }
            }
            if(!logList.isEmpty())
            	Database.insert(logList, false); */
        }        
    }
    // method for processing the updated records
    public static void onAfterUpdate(Map<Id, TSM_Shared_Product__c> newMap, Map<Id, TSM_Shared_Product__c> oldMap) {
    	List<OpportunityLineItem> itemsToUpdate = new List<OpportunityLineItem>();
        Set<String> oppItemIds = new Set<String>();
        Map<String, TSM_Shared_Product__c> processMap = new Map<String, TSM_Shared_Product__c>();
        for(TSM_Shared_Product__c tsp: newMap.values()) {
            if((tsp.Unit_Price__c !=  null && tsp.Unit_Price__c != oldMap.get(tsp.Id).Unit_Price__c) ||
              (tsp.Quantity__c != null && tsp.Quantity__c !=  oldMap.get(tsp.Id).Quantity__c)) {
                oppItemIds.add(tsp.SFS_Oppty_Product_Record_ID__c.substring(0,18));
                processMap.put(tsp.SFS_Oppty_Product_Record_ID__c.substring(0,18), tsp);
            }
        }
        // fetch the respective opportunty line items
        for(OpportunityLineItem item: [SELECT Id, SFS_Opportunity_Record_Id__c, UnitPrice, 
                                       Quantity, SFDC_Product__c, SFS_Opportunity_Product_Record_ID__c 
                                       FROM OpportunityLineItem 
                                       WHERE SFS_Opportunity_Product_Record_ID__c IN :oppItemIds]) {
        	if(item.SFDC_Product__c != null && 
               item.SFDC_Product__c == processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).SFDC_Product__c) {
        		item.UnitPrice = processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).Unit_Price__c;
            	item.Quantity = processMap.get(item.SFS_Opportunity_Product_Record_ID__c.substring(0,18)).Quantity__c;
                itemsToUpdate.add(item);
            }                                   
        }
        // update the line items (oppty products) to reflect the changes
        if(!itemsToUpdate.isEmpty()) {
            Database.SaveResult[] results = Database.update(itemsToUpdate, false);
            List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();                    
            for(Database.SaveResult sr: results) {
                if(!sr.isSuccess()) {
                    for(Database.Error err: sr.getErrors()) {
                        logList.add(TSM_Util.prepareLogEntry(err.getMessage(), 
                                                             String.valueOf(err.getStatusCode()), 
                                                             err.getMessage(), 'TSM_SharedProductTrigger', 'Trigger'));
                    }
                }
            }
            if(!logList.isEmpty())
            	Database.insert(logList, false);
        }
        // Process deleted oppty products
        List<String> sfsDelOppItemIds = new List<String>();
        List<Id> oppItemForDeleteIds = new List<Id>();
        System.debug('TSM Shared Product Map (New): '+newMap.values());
        System.debug('TSM Shared Product Map (Old): '+oldMap.values());
        List<TSM_App_Log__c> logList = new List<TSM_App_Log__c>();    
        logList.add(TSM_Util.prepareLogEntry('Debug Output', null, 'TSM Shared Product Map (New): '+newMap.values()+ ' '+'TSM Shared Product Map (Old): '+oldMap.values(), 
                		'TSM_SharedProductTrigger', 'onAfterInsert'));      
        for(TSM_Shared_Product__c tsp: newMap.values()) {
            if(tsp.ConnectionReceivedId ==  null && oldMap.get(tsp.Id).ConnectionReceivedId != null && tsp.SFS_Oppty_Product_Record_ID__c != null) {
                sfsDelOppItemIds.add(tsp.SFS_Oppty_Product_Record_ID__c.substring(0,18));
            }
        }
        if(!sfsDelOppItemIds.isEmpty()) {
         	// fetch the respective opportunty line items
        	for(OpportunityLineItem item: [SELECT Id 
                                       FROM OpportunityLineItem 
                                       WHERE SFS_Opportunity_Product_Record_ID__c IN :sfsDelOppItemIds]) {
            	 oppItemForDeleteIds.add(item.Id);                        
        	}
        }
        if(!oppItemForDeleteIds.isEmpty()) {
        	Database.delete(oppItemForDeleteIds, false);
        }
    }
}