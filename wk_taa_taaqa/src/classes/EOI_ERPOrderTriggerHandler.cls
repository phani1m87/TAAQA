public with sharing class EOI_ERPOrderTriggerHandler 
{
	public void EOI_placeOrderToIIB()
	{
		List<Id> ERPOrderIdList = new List<Id>();
		for(ERP_Order__c currentERPOrder  : (List<ERP_Order__c>)Trigger.new)
		{
			if(((ERP_Order__c)Trigger.oldMap.get(currentERPOrder.Id)).Order_Submission_Status__c != 'Ready For Submission' && currentERPOrder.Order_Submission_Status__c == 'Ready For Submission')
				ERPOrderIdList.add(currentERPOrder.Id);
		}
		if(!ERPOrderIdList.isEmpty())
		{
			system.debug('Inside EOI_ERPOrderTriggerHandler :: '+ERPOrderIdList);
			EOI_OrderAutomation.EOI_PlaceOrder(ERPOrderIdList);
		}
	}
}