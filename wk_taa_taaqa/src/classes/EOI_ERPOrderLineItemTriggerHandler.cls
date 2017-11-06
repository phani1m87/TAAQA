public with sharing class EOI_ERPOrderLineItemTriggerHandler
{
    public void updateERPOrderStatus(List<ERP_Order_Line_Item__c> ERPOrderLineItemsList)
    {
        Set<Id> ERPOrderIds = new Set<Id>();
        Set<Id> QuoteProposalIds = new Set<Id>();
        List<ERP_Order__c> ERPOrderListToUpdate = new List<ERP_Order__c>();
        for(ERP_Order_Line_Item__c newLineItem : ERPOrderLineItemsList)
        {
            ERPOrderIds.add(newLineItem.ERP_Order__c);
        }
        system.debug('ERP Order Line item trigger ::  ERPOrderIds - '+ERPOrderIds);
        List<ERP_Order__c> ERPOrderRelatedToItems =  [SELECT Id, Proposal__c, (SELECT Id FROM ERP_Order_Line_Items__r) FROM ERP_Order__c WHERE Id in :ERPOrderIds];
        system.debug('ERP Order Line item trigger ::  ERPOrderRelatedToItems - '+ERPOrderRelatedToItems);
        for(ERP_Order__c currentERPOrder : ERPOrderRelatedToItems)
            QuoteProposalIds.add(currentERPOrder.Proposal__c);
        Map<Id, Apttus_Proposal__Proposal__c> QuoteProposalWithItems = new Map<Id,Apttus_Proposal__Proposal__c>([SELECT Id, (SELECT Id FROM R00N70000001yUfBEAU__r) FROM Apttus_Proposal__Proposal__c WHERE Id in :QuoteProposalIds]);
        system.debug('ERP Order Line item trigger ::  QuoteProposalWithItems - '+QuoteProposalWithItems);
        for(ERP_Order__c currentERPOrder : ERPOrderRelatedToItems)
        {
        	//#Would this condition ever occured? Do we need to log alert?
        	if(QuoteProposalWithItems.isEmpty() || QuoteProposalWithItems.get(currentERPOrder.Proposal__c).R00N70000001yUfBEAU.isEmpty())
        		break;
        	system.debug('ERP Order Line item trigger :: currentERPOrder.ERP_Order_Line_Items__r.size()'+currentERPOrder.ERP_Order_Line_Items__r.size());
        	system.debug('ERP Order Line item trigger :: QuoteProposalWithItems.get(currentERPOrder.Proposal__c).Proposal_Line_Items__r.size()'+QuoteProposalWithItems.get(currentERPOrder.Proposal__c).R00N70000001yUfBEAU__r.size());
            if((currentERPOrder.ERP_Order_Line_Items__r.isEmpty() && QuoteProposalWithItems.get(currentERPOrder.Proposal__c).R00N70000001yUfBEAU__r.isEmpty()) || currentERPOrder.ERP_Order_Line_Items__r.size() == QuoteProposalWithItems.get(currentERPOrder.Proposal__c).R00N70000001yUfBEAU__r.size())
            {
                ERP_Order__c newERPOrder = new ERP_Order__c(Id=currentERPOrder.Id, Order_Submission_Status__c='Ready For Submission');
                ERPOrderListToUpdate.add(newERPOrder);
            }
        }
        system.debug('ERP Order Line item trigger ::  ERPOrderListToUpdate - '+ERPOrderListToUpdate);
        system.debug('ERP Order not updated');
        if(!ERPOrderListToUpdate.isEmpty())
        {
            update ERPOrderListToUpdate;
            system.debug('ERP Order updated');
        }
        
    }
}