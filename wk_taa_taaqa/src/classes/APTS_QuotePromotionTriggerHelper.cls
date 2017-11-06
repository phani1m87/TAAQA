public with sharing class APTS_QuotePromotionTriggerHelper {  
    
    public static Boolean isBeforeQuotePromotionTgrRan = false;
    public static Boolean isAfterQuotePromotionTgrRan = false;
    
    public static void setAccountAttributeFlag(List<Quote_Promotion__c> quotePromotionList) {
    	List<APTS_Account_Attributes__c> accountAttributesCSList = APTS_Account_Attributes__c.getall().values();
    	
    	for(Quote_Promotion__c quotePromotionObj : quotePromotionList) {
    		Boolean isAccountAttributeMatch = false;
    		
    		for(APTS_Account_Attributes__c accountAttributeCS : accountAttributesCSList) {
    			if(quotePromotionObj.get(accountAttributeCS.Quote_Account_Attribute_API_Name__c) == true && quotePromotionObj.get(accountAttributeCS.Promotion_Account_Attribute_API_Name__c) == true) {
    				isAccountAttributeMatch = true;
    				break;
    			}
	    	}
	    	
	    	quotePromotionObj.Account_Attribute_Match__c = isAccountAttributeMatch;
    	}
    }
    
    public static void setEnforceRepricingFlag(Set<Id> proposalIdSet) {
        if(!proposalIdSet.isEmpty()) {
            List<Apttus_Proposal__Proposal__c> proposalList = [Select APTS_Enforce_Repricing__c From Apttus_Proposal__Proposal__c Where Id IN :proposalIdSet];
            
            system.debug('proposalList  :::::::::::::::;' + proposalList );
            
            if(!proposalList.isEmpty()) {
                for(Apttus_Proposal__Proposal__c proposalObj : proposalList) {
                    proposalObj.APTS_Enforce_Repricing__c = true;
                }
                
                update proposalList;
            }
        }
    }
}