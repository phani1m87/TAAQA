/*
 *  Trigger to automatically update Forecast Category of an Opportunity 
 *  based on the Forecast Type value regardless of the Stage that is selected.
 */
trigger WK_TAA_OpporunityCategoryUpdate on Opportunity (before insert,before update) {
    // Initialize what's new and what's already in database during update.
    Opportunity[] newOpportunities = Trigger.new;
    Map<Id, Opportunity> oldOppMap = Trigger.oldMap;
    Map<String, WK_TAA_Opp_ForecaseType_Category_Map__c> typeCategoryMap = WK_TAA_Opp_ForecaseType_Category_Map__c.getAll();
    for(Opportunity opp:newOpportunities){
        // Handle Inserts
       if(oldOppMap ==null)
        {
            // Update only when Forecast type is changed or Forecast category is changed!
            if(opp.Forecast_Type__c != '' && typeCategoryMap.containsKey(opp.Forecast_Type__c))
            {
                opp.ForecastCategoryName = typeCategoryMap.get(opp.Forecast_Type__c).Forecast_Category__c;
            }           
        } else {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            If(opp.Forecast_Type__c != oldOpp.Forecast_Type__c ||
                 opp.ForecastCategoryName != oldOpp.ForecastCategoryName)
            {
                // Update only if an appropriate map is available in custom setting!
                if(opp.Forecast_Type__c != '' && typeCategoryMap.containsKey(opp.Forecast_Type__c))
                {
                    opp.ForecastCategoryName = typeCategoryMap.get(opp.Forecast_Type__c).Forecast_Category__c;
                }
            }            
        }
           
    }
}