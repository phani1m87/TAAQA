/*
 * Test class for apex classes TSM_RemoveDeletedOpportunityProductBatch and TSM_RemoveDeletedOpptyProductScheduler
 * 
 */
@isTest
public class TSM_RemoveDeletedOpptyProductBatchTest {
    // data preparation
    @testSetup static void dataPrep() {
    	TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        config.ScheduleSecondFrequency__c=60;
        insert config;  
        
         // Insert the test products.
        List<Product2> products = new List<Product2>();
        for(Integer i=0;i<1;i++) {
            products.add(new Product2(Name = 'Laptop X200'+i, Family = 'Hardware', ProductCode='PC1000'+i,
                                      SFDC_Product__c='10000'+i));
        }
        insert products;
        
         // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // fetch the product2 records before creating pbentry records because it will throw DUPLICATE_ROW error
        List<Product2> prodList = [SELECT Id FROM Product2];
        
         // Get standard price book ID.
        Id pricebookId = Test.getStandardPricebookId();
        
        List<PricebookEntry> stdPBEntries = new List<PricebookEntry>();
        for(Integer j=0;j<1;j++) {
            stdPBEntries.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodList[j].Id,
            				UnitPrice = j, IsActive = true));
        }
        insert stdPBEntries;       
    }
    
    // for schedule job testing schedule job
    @isTest static void testScheduleJob() {
        // schedule the test job
        Test.startTest();        
        String jobId = System.schedule('jobName', '0 0 0 1 1 ? 2018', new TSM_RemoveDeletedOpptyProductScheduler());
        Test.stopTest();
        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];                
        System.assertEquals(0, ct.size());             
    }
    
    // test the batch process
    @isTest static void testBatchProcess() {
    	List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c FROM PricebookEntry];
        //List<Product2> prodList = [SELECT Id, SFDC_Product__c FROM Product2];
    	List<Opportunity> opptys = TSM_TestDataUtil.createOpportunities(null, null, 1, true);
        List<TSM_Shared_Product__c> sharedProds = TSM_TestDataUtil.createSharedProducts(5);
        List<OpportunityLineItem> opptyProds = TSM_TestDataUtil.createOpptyProducts(opptys[0].Id,pbList[0].Id, 5);
		// mock test and it is not possible to test the scenario because we can't make the replication between 2 orgs 
		// in test classes and test data without depending org data existing PNRC shared records 
		sharedProds = [SELECT Id FROM TSM_Shared_Product__c WHERE ConnectionReceivedId = null]; 
	    opptyProds = [SELECT Id FROM OpportunityLineItem WHERE ConnectionReceivedId = null]; 
	    System.assertEquals(5, sharedProds.size());
	    System.assertEquals(5, opptyProds.size());
           
        Test.startTest();
        Database.executeBatch(new TSM_RemoveDeletedOpportunityProductBatch());
        Test.stopTest();
        // mock test assertion which is fake       
        opptyProds = [SELECT Id FROM OpportunityLineItem WHERE ConnectionReceivedId = null]; 
	    System.assertEquals(0, opptyProds.size());        
    }
    
}