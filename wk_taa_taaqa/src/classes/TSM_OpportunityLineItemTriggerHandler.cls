/*
 * helper class to replicate the opportuntiy products from SFS -> TAA
 * */
public class TSM_OpportunityLineItemTriggerHandler {
	// method for processing the records
    public static void onBeforeInsert(List<OpportunityLineItem> newRecords) {
    	Set<String> oppTextIds = new Set<String>();
        Set<String> prodCodes = new Set<String>();
        Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
        Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>();
        Map<String, Product2> prodMap = new Map<String, Product2>();
        Set<Id> prodIds = new Set<Id>();
        for(OpportunityLineItem item: newRecords) {
            // capture the opportunity ids
            if(item.SFS_Opportunity_Record_Id__c != null) {
                oppTextIds.add(item.SFS_Opportunity_Record_Id__c.substring(0,item.SFS_Opportunity_Record_Id__c.length()));
            }
            // capture the SFDC_product__c (matching key between 2 orgs)
            if(item.SFDC_Product__c != null) {
                prodCodes.add(item.SFDC_Product__c);
            }
        }
        // capture the respective opportunity ids
        for(Opportunity opp : [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                               WHERE SFS_Opportunity_ID__c IN : oppTextIds 
                               AND CPQ_Quote__c = 'Steelbrick']) {
            oppMap.put(opp.SFS_Opportunity_ID__c, opp);
        }
        // capture the respective product2 entries for matching key
        for(Product2 prod : [SELECT Id, SFDC_Product__c FROM Product2 WHERE SFDC_Product__c IN :prodCodes
                             AND IsActive=true]) {
        	prodMap.put(prod.SFDC_Product__c, prod);
            prodIds.add(prod.Id);
      	}
        // capture the respective pricebookentryid for the matching product
        for(PriceBookEntry pb: [SELECT Id, Product2Id, Pricebook2Id 
                                FROM PricebookEntry 
                  				WHERE Product2Id IN :prodIds AND IsActive=true AND Pricebook2.IsActive=true]) {
            //PriceBookEntry pb = (pb.Product2Id != null) ? pb : new PriceBookEntry();
        	pbeMap.put(pb.Product2Id, pb);
        }
        
        // assign the respective relationship fields 
        for(OpportunityLineItem item: newRecords) {
            if(item.SFS_Opportunity_Record_Id__c != null && 
               oppMap.containsKey(item.SFS_Opportunity_Record_Id__c.substring(0,item.SFS_Opportunity_Record_Id__c.length()))) {
                item.OpportunityId = oppMap.get(item.SFS_Opportunity_Record_Id__c.substring(0,item.SFS_Opportunity_Record_Id__c.length())).Id;
            }
            // capture the SFDC_product__c (matching key between 2 orgs)
            if(item.SFDC_Product__c != null && prodMap.containsKey(item.SFDC_Product__c)) {
                Id prodId = prodMap.get(item.SFDC_Product__c).Id;
                /* introduced for coverage but it is not required
                Id pbId = (pbeMap.containsKey(prodId)) ? pbeMap.get(prodId).Id : item.PricebookEntryId;
                item.PricebookEntryId = pbId;
                */
                if(pbeMap.containsKey(prodId)) {
                	item.PricebookEntryId = pbeMap.get(prodId).Id;
                }				
            }
        }
    }
}