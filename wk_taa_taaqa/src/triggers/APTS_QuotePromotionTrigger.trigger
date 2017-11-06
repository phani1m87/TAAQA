trigger APTS_QuotePromotionTrigger on Quote_Promotion__c (before insert, before update, after insert, after update, after delete, after undelete) {
	system.debug('APTS_QuotePromotionTriggerHelper.isBeforeQuotePromotionTgrRan  ::::::::::::::::::::::::: ' + APTS_QuotePromotionTriggerHelper.isBeforeQuotePromotionTgrRan );
	system.debug('APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan  ::::::::::::::::::::::::: ' + APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan );
	
	if(Trigger.isBefore) {
		if(APTS_QuotePromotionTriggerHelper.isBeforeQuotePromotionTgrRan == false) {
			APTS_QuotePromotionTriggerHelper.isBeforeQuotePromotionTgrRan = true;
			APTS_QuotePromotionTriggerHelper.setAccountAttributeFlag(Trigger.new);
		}
	} else {
		Set<Id> proposalIdSet = new Set<Id>();
    
	    if((Trigger.isInsert && APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan == false) || (Trigger.isUndelete && APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan == false)) {
	        for(Quote_Promotion__c quotePromotion : Trigger.new) {
	        	if(quotePromotion.Promotion__c != null) {
	        		proposalIdSet.add(quotePromotion.Quote_Proposal__c);
	        	}
	        }    
	    } else if(Trigger.isDelete && APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan == false) {
	        for(Quote_Promotion__c quotePromotion : Trigger.old) {
	            proposalIdSet.add(quotePromotion.Quote_Proposal__c);    
	        } 
	    } else if(Trigger.isUpdate && APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan == false) {
	        for(Quote_Promotion__c quotePromotion : Trigger.new) {
	            Quote_Promotion__c oldQuotePromotion = Trigger.oldMap.get(quotePromotion.Id);
	            
	            if(oldQuotePromotion != null && oldQuotePromotion.Promotion__c != quotePromotion .Promotion__c) {
	                proposalIdSet.add(quotePromotion.Quote_Proposal__c);    
	            }            
	        }
	    }
	    
	    APTS_QuotePromotionTriggerHelper.isAfterQuotePromotionTgrRan = true;
	    
	    if(!proposalIdSet.isEmpty()) {
	        APTS_QuotePromotionTriggerHelper.setEnforceRepricingFlag(proposalIdSet);
	    }
	}

}