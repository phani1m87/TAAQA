trigger EOI_ERPOrderLineItemTrigger on ERP_Order_Line_Item__c (after insert) 
{
	EOI_ERPOrderLineItemTriggerHandler handler = new EOI_ERPOrderLineItemTriggerHandler();   
    handler.updateERPOrderStatus(Trigger.New); 
}