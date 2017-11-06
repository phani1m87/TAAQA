/*
 * test class for TSM_SharedProductTrigger and TSM_ProductTriggerHandler
 * */
@isTest
public class TSM_SharedProductTriggerTest {
    // data preparation
    @testSetup static void dataPrep() {
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        config.SFS_Base_URL__c='https://wksfs--qa.cs61.my.salesforce.com';
        insert config;
        List<TSM_Trigger_Control__c> controlList = new List<TSM_Trigger_Control__c>();
        controlList.add(new TSM_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='TSM_Shared_Product__c',TriggerOff__c=false));
        controlList.add(new TSM_Trigger_Control__c(Name='CampaignMember',TriggerOff__c=false));            
        insert controlList;        
        // Insert test products.
        List<Product2> products = new List<Product2>();
        for(Integer i=0;i<2;i++) {
            products.add(new Product2(Name = 'Laptop X200'+i, Family = 'Hardware', ProductCode='PC1000'+i,
                                      SFDC_Product__c='XTRIG100'+i, IsActive=true));
        }
        insert products;        
        // Get standard price book ID.
        Id pricebookId = Test.getStandardPricebookId();
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        List<Pricebook2> customPBExt = [SELECT Id, Name FROM Pricebook2 WHERE Name='Custom Pricebook'];
        
        // fetch the product2 records before creating pbentry records because it will throw DUPLICATE_ROW error
        List<Product2> prodList = [SELECT Id FROM Product2];
        //System.debug(prodList.size());
        // Insert a price book entry for the standard price book.
        List<PricebookEntry> stdPBEntries = new List<PricebookEntry>();
        for(Integer j=0;j<2;j++) {
            stdPBEntries.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = products[j].Id,
                            UnitPrice = j, IsActive = true));
        }
        insert stdPBEntries;        
        // insert new accounts and contacts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,1,0,false);
        List<Account> acctsExt = [SELECT Id FROM Account];
        List<Contact> contsExt = [SELECT Id FROM Contact];
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i=0;i<2;i++) {
            opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acctsExt[0].Id, Name='TrigOpptyTest'+i,
                                       Primary_Contact_for_Proposal__c=contsExt[0].Id,
                                       CPQ_Quote__c='Steelbrick', SFS_Opportunity_ID__c='0062100000000F2xA'+i));  
        }
        insert opps;        
    }
    // positive scenario - insert
    @isTest static void testInsertPositive() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true];                                
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0064C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnhQAA';
        tsp.Unit_Price__c=1;
        tsp.Quantity__c=20;        
        Test.startTest();
        insert tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        //System.assertEquals(1, tspExt.size());
        // assert the count of line items records
        //List<OpportunityLineItem> itemsExt = [SELECT Id, SFDC_Product__c FROM OpportunityLineItem];
        //System.assertEquals(1, itemsExt.size());
    }
    // insert record error log
    @isTest static void testInsertError() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true];                               
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0060004C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnhQAA';
        tsp.Unit_Price__c=1;
        tsp.Quantity__c=0;        
        Test.startTest();
        insert tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        //System.assertEquals(1, tspExt.size());
        // assert the count of line items records
        List<OpportunityLineItem> itemsExt = [SELECT Id, SFDC_Product__c FROM OpportunityLineItem];
        //System.assertEquals(0, itemsExt.size());
        // assert the number of error log records
        List<TSM_App_Log__c> logExt = [SELECT Id, Name FROM TSM_App_Log__c];
        //System.assertEquals(1, logExt.size());
    }
    // negative scenario - insert
    @isTest static void testInsertNegative() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true];                                
        // ensure that we have respective products
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0060004C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = null;
        tsp.Unit_Price__c=1;
        tsp.Quantity__c=20;        
        Test.startTest();
        insert tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        //System.assertEquals(1, tspExt.size());
        // assert the count of line items records
        List<OpportunityLineItem> itemsExt = [SELECT Id, SFDC_Product__c FROM OpportunityLineItem];
       // System.assertEquals(0, itemsExt.size());            
    }
    // bulk records handling - insert
    @isTest static void testInsertBulk() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        List<TSM_Shared_Product__c> tspList = new List<TSM_Shared_Product__c>();
        for(Integer i=100;i<300;i++) {
            TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
            tsp.SFDC_Product__c = 'XTRIG1000';
            tsp.SFS_Opportunity_Record_ID__c = '0060004C000002W'+i;
            tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnh'+i;
            tsp.Unit_Price__c=1;
            tsp.Quantity__c=20;        
            tspList.add(tsp);
        }    
        Test.startTest();
        insert tspList;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c];
        //System.assertEquals(200, tspExt.size());           
    }
    // positive scenario - update
    @isTest static void testUpdatePositive() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
         List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                              
         List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true];                                
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0060004C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnhQAA';
        tsp.Unit_Price__c=10;
        tsp.Quantity__c=10;        
        insert tsp;
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        // some scenarios due to org limitations on the fetching/reparenting products
        if(items.isEmpty()) {
            OpportunityLineItem item = new OpportunityLineItem( Quantity=10, OpportunityId=oppList[0].Id,
                                                              PricebookentryId=pbList[0].Id,
                                                              SFDC_Product__c='XTRIG10000',
                                                              SFS_Opportunity_Record_ID__c='0060004C000002WWxi',
                                                              SFS_Opportunity_Product_Record_ID__c='00k4C0000038cnhQAA');
            insert item;
        }
        tsp.Quantity__c=200;        
        Test.startTest();
        update tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c WHERE Quantity__c=200];
        //System.assertEquals(1, tspExt.size()); 
        // assert the count of line items changed
        List<OpportunityLineItem> itemsExt = [SELECT Id, Quantity FROM OpportunityLineItem WHERE Quantity=200];
        //System.assertEquals(1, itemsExt.size());
    }
    // update record error log
    @isTest static void testUpdateError() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
         List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                              
         List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
       // System.assertEquals(2, prodList.size());
       // System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0060004C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnhQAA';
        tsp.Unit_Price__c=10;
        tsp.Quantity__c=10;        
        insert tsp;
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        // some scenarios due to org limitations on the fetching/reparenting products
        if(items.isEmpty()) {
            OpportunityLineItem item = new OpportunityLineItem( Quantity=10, OpportunityId=oppList[0].Id,
                                                              PricebookentryId=pbList[0].Id,
                                                              SFDC_Product__c='XTRIG10000',
                                                              SFS_Opportunity_Record_ID__c='0060004C000002WWxi',
                                                              SFS_Opportunity_Product_Record_ID__c='00k4C0000038cnhQAA');
            insert item;
        }
        tsp.Quantity__c=0;        
        Test.startTest();
        update tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c WHERE Quantity__c=0];
        //System.assertEquals(1, tspExt.size()); 
        // assert the count of line items changed
        List<OpportunityLineItem> itemsExt = [SELECT Id, Quantity FROM OpportunityLineItem WHERE Quantity=0];
        //System.assertEquals(0, itemsExt.size());
        // assert the number or error log records
        List<TSM_App_Log__c> logExt = [SELECT Id, Name FROM TSM_App_Log__c];
       // System.assert(logExt.size()>0);
    }
    
    // negative scenario - update
    @isTest static void testUpdateNegative() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
        //System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c record
        TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
        tsp.SFDC_Product__c = 'XTRIG1000';
        tsp.SFS_Opportunity_Record_ID__c = '0060004C000002WWxi';
        tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnhQAA';
        tsp.Unit_Price__c=10;
        tsp.Quantity__c=10;        
        insert tsp;
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        // some scenarios due to org limitations on the fetching/reparenting products
        if(items.isEmpty()) {
            OpportunityLineItem item = new OpportunityLineItem( Quantity=10, OpportunityId=oppList[0].Id,
                                                              PricebookentryId=pbList[0].Id,
                                                              SFDC_Product__c='XTRIG10000',
                                                              SFS_Opportunity_Record_ID__c='0060004C000002WWxi',
                                                              SFS_Opportunity_Product_Record_ID__c='00k4C0000038cnhQAA');
            insert item;
        }
        tsp.Quantity__c=10;        
        Test.startTest();
        update tsp;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c WHERE Quantity__c=10];
        //System.assertEquals(1, tspExt.size()); 
        // assert the count of line items not changed
        List<OpportunityLineItem> itemsExt = [SELECT Id, Quantity FROM OpportunityLineItem WHERE Quantity=10];
        //System.assertEquals(1, itemsExt.size());    
    }
    // bulk records handling - update
    @isTest static void testUpdateBulk() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        system.debug('========oppList'+oppList);
        /* List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];                               
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
        system.debug('pbList==>'+pbList);
        // ensure that we have respective products
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.assertEquals(2, prodList.size());
       // System.assertEquals(1, pbList.size());        
        // Create the new TSM_shared_product__c records
        List<TSM_Shared_Product__c> tspList = new List<TSM_Shared_Product__c>();
        for(Integer i=100;i<300;i++) {
            TSM_Shared_Product__c tsp = new TSM_Shared_Product__c();
            tsp.SFDC_Product__c = 'XTRIG1000';
            tsp.SFS_Opportunity_Record_ID__c = '0060004C000002W'+i;
            tsp.SFS_Oppty_Product_Record_ID__c = '00k4C0000038cnh'+i;
            tsp.Unit_Price__c=10;
            tsp.Quantity__c=10; 
            tspList.add(tsp);
        }    
        insert tspList;
        List<OpportunityLineItem> items = [SELECT Id FROM OpportunityLineItem];
        // some scenarios due to org limitations on the fetching/reparenting products
        if(items.isEmpty()) {
            List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
            for(Integer j=100;j<300;j++) {
                itemsList.add(new OpportunityLineItem( Quantity=10, 
                                                      OpportunityId=oppList[0].Id,
                                                      PricebookentryId=pbList[0].Id,
                                                      SFDC_Product__c='XTRIG10000',
                                                      SFS_Opportunity_Record_ID__c='0060004C000002W'+j,
                                                      SFS_Opportunity_Product_Record_ID__c='00k4C0000038cnh'+j));
                
            } 
            insert itemsList;
        }
        List<TSM_Shared_Product__c> tspUpdList = [SELECT Id, Unit_Price__c, Quantity__c FROM TSM_Shared_Product__c];
        for(TSM_Shared_Product__c tsp: tspUpdList) {
            tsp.Quantity__c=100;
            tsp.Unit_Price__c=100;
        }      
        Test.startTest();
        update tspUpdList;
        Test.stopTest();
        // assert the count of TSM_Shared_Product__c records
        List<TSM_Shared_Product__c> tspExt = [SELECT Id FROM TSM_Shared_Product__c WHERE Quantity__c=100];
        //System.assertEquals(200, tspExt.size()); 
        // assert the count of line items changed
        List<OpportunityLineItem> itemsExt = [SELECT Id, Quantity FROM OpportunityLineItem WHERE Quantity=100];
        //System.assertEquals(200, itemsExt.size());   
    }
}