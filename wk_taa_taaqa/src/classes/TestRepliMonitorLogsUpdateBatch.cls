@isTest
public class TestRepliMonitorLogsUpdateBatch 
{
    @testsetup static void startup()
	{
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c = 'CCH SFS';
        config.SFS_Base_URL__c = 'https://wksfs--qa.cs61.my.salesforce.com';
        insert config;
        
        List<TSM_Trigger_Control__c> controlList = new List<TSM_Trigger_Control__c>();
        controlList.add(new TSM_Trigger_Control__c(Name = 'Account', TriggerOff__c = false));
        controlList.add(new TSM_Trigger_Control__c(Name='Contact', TriggerOff__c = false));
        controlList.add(new TSM_Trigger_Control__c(Name='Opportunity', TriggerOff__c = false));
        insert controlList;        

        // insert new accounts and contacts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,1,0,false);
        List<Account> acctsExt = [SELECT Id FROM Account];
        List<Contact> contsExt = [SELECT Id FROM Contact];
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < 2; i++){
        	opps.add(new Opportunity(StageName = '1. Gain Accesss', CloseDate = System.today()+30,
                                       AccountId = acctsExt[0].Id, Name = 'TrigOpptyTest' + i,
                                       Primary_Contact_for_Proposal__c = contsExt[0].Id,
                                       CPQ_Quote__c = 'Steelbrick', SFS_Opportunity_ID__c = '0062100000F2xA' + i));  
        }
        insert opps;
	}
	
	@isTest
    static void testBatch() 
    {
    	Test.startTest();
    	RepliMonitorLogsUpdateBatchScheduler obj = new RepliMonitorLogsUpdateBatchScheduler();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Replication Monitor Logs Update Check', sch, obj); 
		Test.stopTest();
    }
}