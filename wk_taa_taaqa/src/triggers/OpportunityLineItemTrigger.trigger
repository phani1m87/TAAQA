trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert) {
    
    //prepare line Item list which does not include opportunity renewal type 
    List <OpportunityLineItem> oppLineItemList=new List<OpportunityLineItem>();
    for(OpportunityLineItem oppLineItem:trigger.new)
    {
        oppLineItemList.add(oppLineItem);
    }
    
    //recursive prevention
    if( trigger.isInsert && !OpportunityLineItemHelper.opportunityLineItemTriggerMap.get('beforeinsert'))
    {
        if(!oppLineItemList.isEmpty())
        {
        OpportunityLineItemHelper OPLIHelper=new OpportunityLineItemHelper();
        OPLIHelper.adjustOppyLineItemPrices(oppLineItemList);
        //OPLIHelper.includeInReporting(trigger.new);
        OpportunityLineItemHelper.opportunityLineItemTriggerMap.put('beforeinsert',true); 
        }        
    }
    

}

/*
 to dos
 
 Check if the quote line can be synched multiple times for the same quote.
 what happens to the existing oppy lines if quote lines are re-synched
 
 1. If they are deleted and created agiain. The trigger works as is
 2. If the existing oppy linea are updated 
 
whenever quote lines are synched with the opportunity, the existing opportunity lines are deleted and quotelines are being copied over to the realted opportunity. So the update version of the trgger
not required to update the amount.
 
 Validation rule on the opportunity has been de-activated. It is throwing an error


*/