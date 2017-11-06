/*
 * Author: Salesforce Services
 * Description: Test class for apex trigger WK_TAA_OpportunityCategoryUpdate
 */
@isTest
private class Test_WK_TAA_OpportunityCategoryUpdate{
  static testMethod void validateForecastCategory()
  {
      // Initialize custom settings..
      List<WK_TAA_Opp_ForecaseType_Category_Map__c> forecastMapList = new List<WK_TAA_Opp_ForecaseType_Category_Map__c>();
      forecastMapList.add(new WK_TAA_Opp_ForecaseType_Category_Map__c(Name = 'High (>90%)',
                                                                      Forecast_Type__c = 'High (>90%)',
                                                                      Forecast_Category__c = 'High Probability'));
      forecastMapList.add(new WK_TAA_Opp_ForecaseType_Category_Map__c(Name = 'Medium (50-90%)',
                                                                      Forecast_Type__c = 'Medium (50-90%)',
                                                                      Forecast_Category__c = 'Medium Probability'));
      insert forecastMapList;
      
      // Create account
      Account acct = new Account(Name = 'Test Account');
      insert acct;
      // Create opportunity
      Opportunity opp = new Opportunity(Name = 'Test Opportunity',
                                        AccountId = acct.Id,
                                        CloseDate = Date.today(),
                                        StageName='1. Gain Access',
                                        ForecastCategoryName = 'Low Probability',
                                        Forecast_Type__c = 'High (>90%)');
      insert opp;
      
      // Validate forecast category during insert with stage set.
      Opportunity opp1 = [SELECT Id,ForecastCategoryName  FROM Opportunity WHERE Id =:opp.Id];    
      System.assertEquals('High Probability', opp1.ForecastCategoryName);
      
      // Update Forecast type
      opp1.Forecast_Type__c = 'Medium (50-90%)';
      update opp1;
      //Validate forecast category during Update.
      Opportunity opp2 = [SELECT Id,ForecastCategoryName  FROM Opportunity WHERE Id =:opp1.Id];
      System.assertEquals('Medium Probability', opp2.ForecastCategoryName);
      
  }
}