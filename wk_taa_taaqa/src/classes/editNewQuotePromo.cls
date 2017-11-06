public with sharing class editNewQuotePromo {
	
	public Id QuoteId{get;set;}
	Apttus_Proposal__Proposal__c proposal;
	Id QuotePromotionId;
	apexpages.standardController stdController;
	pageReference QuotePromotionEditURL;
	
	public editNewQuotePromo()
	{
	 this.QuoteId=Apexpages.currentpage().getparameters().get('proposalId');
	 if(QuoteId!=null)
	 this.proposal=[select id from Apttus_Proposal__Proposal__c where id=:QuoteId];
	 this.QuotePromotionId=Apexpages.currentpage().getparameters().get('QuotePromotionId');
	 //apexpages.addMessage(new apexpages.message(apexpages.severity.info,'-->'+QuoteId));
	}
	public pageReference Initiator()
	{
	 Quote_Promotion__c newQuotePromotion=new Quote_Promotion__c();
	 newQuotePromotion.Quote_Proposal__c=QuoteId;
	 insert newQuotePromotion;
	 pageReference pref=new pageReference('/'+newQuotePromotion.id+'/e'+'?retURL=%2F'+QuoteId+'&cancelURL=/apex/Aptps_QuotePromotionCancelInterceptor?RollBackId='+newQuotePromotion.id+'%26proposalId='+QuoteId+'%26QuotePromotionId='+newQuotePromotion.id);
	 
	 return pref;
	} 
	
	public pageReference doOK()
	{
	 pageReference pref;
	 try{
	 
     Id proposalId=Apexpages.currentPage().getParameters().get('proposalId');
     Id RollBackId=Apexpages.Currentpage().getParameters().get('RollBackId');
     Quote_Promotion__c quotePromotion=[select id from Quote_Promotion__c where id=:RollBackId];
     delete quotePromotion;
	 //proposal=[select id from Apttus_Proposal__Proposal__c where id=:proposalId];
	 //apexpages.standardController stdController=new apexpages.standardController(proposal);
	 pref=new pageReference('/'+proposalId);
	 }
	 catch(Exception Ex)
	 {
	  return new pageReference('/home/home.jsp');	
	 }
	 return pref;
	}

    public pageReference doCancel()
    {
     Id RollBackId=Apexpages.Currentpage().getParameters().get('RollBackId');
     Id proposalId=Apexpages.Currentpage().getParameters().get('proposalId');
     Id QuotePromotionId=Apexpages.Currentpage().getParameters().get('QuotePromotionId');
     
     //Quote_Promotion__c quotePromotion=[select id from Quote_Promotion__c where id=:RollBackId];
     pageReference pref=new pageReference('/'+QuotePromotionId+'/e'+'?retURL=%2F'+QuoteId+'&cancelURL=/apex/Aptps_QuotePromotionCancelInterceptor?RollBackId='+RollBackId+'%26proposalId='+proposalId+'%26QuotePromotionId='+QuotePromotionId);
	 return pref; 
     
    }
}