trigger Two_Trial_Campaign_ID on Contact (before insert, before Update) {


  Map<String,String> CampaignLookup = new Map<String,String>();
  Set<String> CampaignName = new Set<String>();    

  for(Contact c:Trigger.new) {
    CampaignName.add(c.twotrial_campaign_name__c);
    
  }
 
  
  
  
  for(Campaign CC:

    [SELECT      name,Id
     FROM        Campaign
     WHERE       name IN :CampaignName]) {

     CampaignLookup.put(CC.name, CC.Id);
  }

  for(Contact c:Trigger.new) {

    if(CampaignLookup.containsKey(c.twotrial_campaign_name__c)) {
      c.twotrial_campaign_Id__c = CampaignLookup.get(c.twotrial_campaign_name__c);
    }
  }
}