@isTest
private class EOI_Test_OrderAutomationScheduler 
{
    static testMethod void myUnitTest() 
    {
        //EOI_Test_QuoteProposalTriggerHandler.myUnitTest();
        //ERP_Order__c obj = new ERP_Order__c(Contract_Start_Date__c = System.Today());
        //insert obj;
        Test.startTest();
        EOI_OrderAutomationSchedular objScheduler = new EOI_OrderAutomationSchedular();
        //objScheduler.OrderId = obj.Id;
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Schedule', sch, objScheduler); 
        Test.stopTest();
    }
}