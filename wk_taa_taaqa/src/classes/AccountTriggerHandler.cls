/*
    **************************************************************************
    Name    :   AccountTriggerHandler 
    Usage   :   This class is invoked in trigger AccountTrigger and used to populate Market Segment and Sub Segment on Account based on SIC code for Prospect accounts exported from        Data.com 
                
    Version    |    Name            |    Date           
    1.0             Rajesh Meti          09-June-2015  
    
    Trigger : AccountTrigger on Account (before insert, before update)   
    ***************************************************************************
*/

public class AccountTriggerHandler {  

    //for before insert event    
    public void onBeforeInsert(List<Account> newAccountList) {  
        Map<String, Market_Segment_Mapping__c> marketSegmentMap = new Map<String, Market_Segment_Mapping__c>();
        Map<String, Market_Segment_Rules__c> marketSegmentRuleMap = new Map<String, Market_Segment_Rules__c>();
        List<Market_Sub_Segment_Mapping__c> allMarketSubSegmentList = Market_Sub_Segment_Mapping__c.getAll().values();
        
        for(Market_Segment_Mapping__c ms : Market_Segment_Mapping__c.getAll().values()) {
            marketSegmentMap.put(ms.SIC_Code__c, ms);
        }
        
        for(Market_Segment_Rules__c msr : Market_Segment_Rules__c.getAll().values()) {
            marketSegmentRuleMap.put(msr.Segment__c, msr);
        }        
        
        for(Account acc : newAccountList) {  
        	
            if(/*acc.AccountSource == 'Data.com' &&*/acc.id ==null && String.isNotBlank(acc.Sic) && marketSegmentMap.containsKey(acc.Sic) && String.isBlank(acc.Market_Segment__c)) {
            	system.debug(loggingLevel.Error,'-------Checking if I am inside onBeforeInsert------');
                system.debug(marketSegmentMap.get(acc.Sic).Segment__c);
                acc.Market_Segment__c = marketSegmentMap.get(acc.Sic).Segment__c;   
                
                for(Market_Sub_Segment_Mapping__c mss : allMarketSubSegmentList) {
                    if(marketSegmentRuleMap.get(acc.Market_Segment__c).IsSubSegmentBasedOnAnnualRevenue__c == True) {
                        
                        if(acc.AnnualRevenue > 0 && acc.AnnualRevenue != null) {
                            if(acc.AnnualRevenue >= mss.GTE_AnnualRevenue__c && acc.AnnualRevenue <= mss.LTE_AnnualRevenue__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                            else if(acc.AnnualRevenue >= mss.GTE_AnnualRevenue__c && mss.LTE_AnnualRevenue__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                        }                       
                        else if(acc.NumberOfEmployees > 0 && acc.NumberOfEmployees != null) {
                            if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && acc.NumberOfEmployees <= mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                            else if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && mss.LTE_NumberOfEmployees__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                        }
                        else if((acc.AnnualRevenue == null || acc.AnnualRevenue == 0) && (acc.NumberOfEmployees == null || acc.NumberOfEmployees == 0 )) {
                            if((acc.AnnualRevenue == mss.GTE_AnnualRevenue__c || acc.AnnualRevenue == mss.LTE_AnnualRevenue__c) && 
                               (acc.NumberOfEmployees == mss.GTE_NumberOfEmployees__c || acc.NumberOfEmployees == mss.LTE_NumberOfEmployees__c)
                               && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                        }
                    }
                    
                    if(marketSegmentRuleMap.get(acc.Market_Segment__c).IsSubSegmentBasedOnAnnualRevenue__c == False) {
                        
                        if(acc.NumberOfEmployees > 0 && acc.NumberOfEmployees != null) {
                            if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && acc.NumberOfEmployees <= mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                            else if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && mss.LTE_NumberOfEmployees__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                        }
                        else if(acc.NumberOfEmployees == null || acc.NumberOfEmployees == 0 ) {
                            if(acc.NumberOfEmployees == mss.GTE_NumberOfEmployees__c || acc.NumberOfEmployees == mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
                                //break;
                            }
                        }
                    }   
                }                  
            }
            
        }                
    }    
    
    //to assign updated segments    
    /*public void assignUpdatedVlaues(List<Account> newAccountList, Map<Id, Account> oldAccountMap) {  
        Map<String, Market_Segment_Mapping__c> marketSegmentMap = new Map<String, Market_Segment_Mapping__c>();
        Map<String, Market_Segment_Rules__c> marketSegmentRuleMap = new Map<String, Market_Segment_Rules__c>();
        List<Market_Sub_Segment_Mapping__c> allMarketSubSegmentList = Market_Sub_Segment_Mapping__c.getAll().values();
        
        for(Market_Segment_Mapping__c ms : Market_Segment_Mapping__c.getAll().values()) {
            marketSegmentMap.put(ms.SIC_Code__c, ms);
        }
        
        for(Market_Segment_Rules__c msr : Market_Segment_Rules__c.getAll().values()) {
            marketSegmentRuleMap.put(msr.Segment__c, msr);
        }        
        
        for(Account acc : newAccountList) {  
        	if(String.isNotBlank(acc.sic) &&
        		(acc.sic != oldAccountMap.get(acc.id).sic 
        			|| acc.AnnualRevenue != oldAccountMap.get(acc.id).AnnualRevenue
        			|| acc.NumberOfEmployees != oldAccountMap.get(acc.id).NumberOfEmployees)){
        				system.debug(loggingLevel.Error,'-------Checking if I am inside assignUpdatedVlaues------');
	            if(marketSegmentMap.containsKey(acc.Sic) ) {
	                system.debug(marketSegmentMap.get(acc.Sic).Segment__c);
	                acc.Market_Segment__c = marketSegmentMap.get(acc.Sic).Segment__c;   
	                
	                for(Market_Sub_Segment_Mapping__c mss : allMarketSubSegmentList) {
	                    if(marketSegmentRuleMap.get(acc.Market_Segment__c).IsSubSegmentBasedOnAnnualRevenue__c == True) {
	                        
	                        if(acc.AnnualRevenue > 0 && acc.AnnualRevenue != null) {
	                            if(acc.AnnualRevenue >= mss.GTE_AnnualRevenue__c && acc.AnnualRevenue <= mss.LTE_AnnualRevenue__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                            else if(acc.AnnualRevenue >= mss.GTE_AnnualRevenue__c && mss.LTE_AnnualRevenue__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                        }                       
	                        else if(acc.NumberOfEmployees > 0 && acc.NumberOfEmployees != null) {
	                            if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && acc.NumberOfEmployees <= mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                            else if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && mss.LTE_NumberOfEmployees__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                        }
	                        else if((acc.AnnualRevenue == null || acc.AnnualRevenue == 0) && (acc.NumberOfEmployees == null || acc.NumberOfEmployees == 0 )) {
	                            if((acc.AnnualRevenue == mss.GTE_AnnualRevenue__c || acc.AnnualRevenue == mss.LTE_AnnualRevenue__c) && 
	                               (acc.NumberOfEmployees == mss.GTE_NumberOfEmployees__c || acc.NumberOfEmployees == mss.LTE_NumberOfEmployees__c)
	                               && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                        }
	                    }
	                    
	                    if(marketSegmentRuleMap.get(acc.Market_Segment__c).IsSubSegmentBasedOnAnnualRevenue__c == False) {
	                        
	                        if(acc.NumberOfEmployees > 0 && acc.NumberOfEmployees != null) {
	                            if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && acc.NumberOfEmployees <= mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                            else if(acc.NumberOfEmployees >= mss.GTE_NumberOfEmployees__c && mss.LTE_NumberOfEmployees__c == null && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                        }
	                        else if(acc.NumberOfEmployees == null || acc.NumberOfEmployees == 0 ) {
	                            if(acc.NumberOfEmployees == mss.GTE_NumberOfEmployees__c || acc.NumberOfEmployees == mss.LTE_NumberOfEmployees__c && marketSegmentMap.get(acc.Sic).Segment__c == mss.Segment__c) {
	                                acc.Market_Sub_Segment__c = mss.Sub_Segment__c;
	                                //break;
	                            }
	                        }
	                    }   
	                }                  
	            }
        	}  
        }                
    }*/    
}