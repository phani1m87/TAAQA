trigger EOI_WebserviceRetryLogTrigger on EOI_Retry_Log__c (after insert) 
{
    EOI_Retry_Log__c webserviceLogEntry = Trigger.New[0];
    //if(webserviceLogEntry.)
    
    EOI_OrderAutomationSchedular SC = new EOI_OrderAutomationSchedular();
    SC.OrderId = webserviceLogEntry.ERPOrderId__c;
    //sc.NoOfRetry = this.Interval + 1;
    DateTime newDateTime = system.now().addMinutes(Integer.valueOf(WK_Utility.ServiceIntegrations().RetryInterval_Timeout__c));
    String strDateTime = '0 ' + string.valueOf(newDateTime.minute()) + ' ' + string.valueOf(newDateTime.hour()) + ' ' + string.valueOf(newDateTime.day()) + ' ' + string.valueOf(newDateTime.month()) + ' ?' + ' ' + string.valueOf(newDateTime.year());
    System.schedule('OrderAutomationInt_'+webserviceLogEntry.Name, strDateTime, SC);
}