trigger APTPS_OpportunityUpdate on Opportunity (before insert,before update) {
	
	
	//Recursive Prevention
	if(!APTPS_OpportunityHelper.opportunityTriggerMap.get('beforeinsert'))
	{
	 APTPS_OpportunityHelper.opportunityTriggerMap.put('beforeinsert',true); 
	 list<Opportunity> OppysWoPricebooks=new list<Opportunity>();
	 for(Opportunity opp:trigger.new)
	     {
	      if(opp.PriceBook2Id==null)
	      {
	       OppysWoPricebooks.add(opp);
	      }
	     }
	     
	 if(OppysWoPricebooks.size()>0){
	       
	 //Query for the standard Pricebook
	 list<pricebook2> stdpricebooklist=[select id,name 
	                         from pricebook2
	                         where IsStandard = TRUE limit 1];
	 if(!stdpricebooklist.isEmpty())
	   {
	    if(trigger.isbefore && trigger.isinsert){
	     for(Opportunity opp:OppysWoPricebooks)
	     {
	      opp.PriceBook2Id=stdpricebooklist[0].id;
	     }
	    }
	  }
	 }
	}
	/*if(!APTPS_OpportunityHelper.opportunityTriggerMap.get('beforeupdate'))
	{
	 APTPS_OpportunityHelper.opportunityTriggerMap.put('beforeupdate',true); 
	 
	 //Query for the standard Pricebook
	 pricebook2 stdpricebook=[select id,name 
	                         from pricebook2
	                         where IsStandard = TRUE limit 1];
	 if(stdpricebook!=null)
	   {
	    if(trigger.isbefore && trigger.isinsert){
	     for(Opportunity opp:trigger.new)
	     {
	      if(opp.StageName!=null
	         && !(opp.StageName.equals('6. Closed Lost')
	             ||opp.StageName.equals('7. Closed Won') ))	
	      opp.PriceBook2Id=stdpricebook.id;
	     }
	    }
	  }
	}*/
	

}