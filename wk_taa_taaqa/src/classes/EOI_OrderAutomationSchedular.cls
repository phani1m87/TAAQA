global with sharing class EOI_OrderAutomationSchedular implements Schedulable
{
  public Integer NoOfRetry = 1;
  public Id OrderId;
  global void execute(SchedulableContext sc) 
  {
      List<Id> ERPOrderIdList = new List<Id>();
      ERPOrderIdList.add(OrderId);
      EOI_OrderAutomation.EOI_PlaceOrder(ERPOrderIdList);
  }
    
}