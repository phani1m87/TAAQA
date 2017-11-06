trigger EOI_ERPOrderTrigger on ERP_Order__c (after update) 
{
	//ERP_Order_Integrations_CS__c orderSetting = ERP_Order_Integrations_CS__c.getInstance();
   	if(WK_Utility.ServiceIntegrations().IsERPOrderIntegrationOn__c)
   	{  
    	EOI_ERPOrderTriggerHandler handler = new EOI_ERPOrderTriggerHandler();
    	if(Trigger.isAfter && Trigger.isUpdate)
        	handler.EOI_placeOrderToIIB();
   	}
        
}