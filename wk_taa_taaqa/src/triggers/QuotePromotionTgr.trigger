/*

Author: 
Venkata Sabbella
Apttus
11/12/2014.


*/

trigger QuotePromotionTgr on Quote_Promotion__c (before insert, before update,after update) {
    
    
    set<Id> ProposalIdset=new set<Id>();
    for(Quote_Promotion__c quotePromotion:trigger.new)
    {
     ProposalIdset.add(quotePromotion.Quote_Proposal__c);
    }
    
    
    map<Id,Apttus_Proposal__Proposal__c> proposalMap=new map<Id,Apttus_Proposal__Proposal__c>([select id, Apttus_QPConfig__PriceListId__c
                                                                              from Apttus_Proposal__Proposal__c 
                                                                              where Id IN:ProposalIdset]);
                                                                              
                                                                             
    if(trigger.isInsert && trigger.isbefore){
    
      for(Quote_Promotion__c quotePromotion:trigger.new)
      {
       Apttus_Proposal__Proposal__c queriedPromo=proposalMap.get(quotePromotion.Quote_Proposal__c);
     
       if(queriedPromo!=null)    
       quotePromotion.Price_List__c=queriedPromo.Apttus_QPConfig__PriceListId__c;
      }
    }
    
    
    if(trigger.isUpdate && trigger.isbefore)
    {
        for(Quote_Promotion__c quotePromotion:trigger.new)
        {
         Apttus_Proposal__Proposal__c queriedPromo=proposalMap.get(quotePromotion.Quote_Proposal__c);
     
         if(queriedPromo!=null)  
         quotePromotion.Price_List__c=queriedPromo.Apttus_QPConfig__PriceListId__c;
        }
     
    }
    
   


}

/*
 shell trigger created to default the pricelist on proposal 
 Does not handle recursive prevention or order of execution.

*/