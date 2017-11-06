/*
 * Test class for S2S_OpportunityLineItemTrigger
 * 
 * */
@isTest
public class S2S_OpportunityLineItemTriggerTest {
    // for data preparation
    @testSetup static void dataPrep() {
        TSM_Custom_Settings__c config = new TSM_Custom_Settings__c();
        config.ConnectionName__c='CCH SFS';
        config.SFS_Base_URL__c='https://wksfs--qa.cs61.my.salesforce.com';
        insert config;
        List<S2S_Trigger_Control__c> controlList = new List<S2S_Trigger_Control__c>();
        controlList.add(new S2S_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='TSM_Shared_Product__c',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='CampaignMember',TriggerOff__c=false));            
        insert controlList;        
        // Insert test products.
        List<Product2> products = new List<Product2>();
        for(Integer i=0;i<200;i++) {
            String prod = 'XTRIG100'+i;
            products.add(new Product2(Name = 'Laptop X200'+i, Family = 'Hardware', ProductCode='PC1000'+i,
                                      SFDC_Product__c=prod, IsActive=true));
        }
        insert products;  
        System.debug('Display 1st product: '+products[0]);    
        // Get standard price book ID.
        Id pricebookId = Test.getStandardPricebookId();
        System.debug('Display StandardPricebookId: '+pricebookId);  
        //Pricebook2 pb = [SELECT Id, IsActive FROM Pricebook2 WHERE isStandard=true AND Id = :pricebookId];
        //pb.isActive = true;
        //update pb;
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        List<Pricebook2> customPBExt = [SELECT Id, Name FROM Pricebook2 WHERE Name='Custom Pricebook'];
        
        // fetch the product2 records before creating pbentry records because it will throw DUPLICATE_ROW error
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE IsActive=true];
        //System.debug(prodList.size());
        // Insert a price book entry for the standard price book.
        List<PricebookEntry> stdPBEntries = new List<PricebookEntry>();
        for(Integer j=0;j<200;j++) {
            stdPBEntries.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = products[j].Id,
                            UnitPrice = j+1, IsActive = false));
            stdPBEntries.add(new PricebookEntry(Pricebook2Id = customPBExt[0].Id, Product2Id = products[j].Id,
                            UnitPrice = (j+1)*10, IsActive = true));
        }
        insert stdPBEntries;   
        System.debug('Display 1st PriceBookEntry: '+stdPBEntries[0]);       
        // insert new accounts and contacts for data
        List<Account> accounts = TSM_TestDataUtil.createAccounts(1,1,0,false);
        List<Account> acctsExt = [SELECT Id FROM Account];
        List<Contact> contsExt = [SELECT Id FROM Contact];
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i=0;i<2;i++) {
            opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acctsExt[0].Id, Name='TrigOpptyTest'+i,
                                       Primary_Contact_for_Proposal__c=contsExt[0].Id,
                                       CPQ_Quote__c='Steelbrick', SFS_Opportunity_ID__c='0062100000F2xA'+i));  
        }
        insert opps;
        
    }
    // for the scenario where we have steelbrick opportunity with respective sfdc_product__c values in product2 object
    @isTest
    static void testPositive() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true];*/
                                                                     
         List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];
         System.debug('Display Product2 Index 1: '+prodList2[0]);  
         List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
                                                                     
        // ensure that we have respective products
        System.assertEquals(1, pbList.size());
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId = null,
                                        PricebookentryId = pbList[0].Id,
                                        //PricebookentryId = null,
                                        UnitPrice = null, Quantity = 10, TotalPrice=10,
                                        SFS_Opportunity_Record_Id__c = oppList[0].SFS_Opportunity_ID__c,
                                        SFDC_Product__c= prodList2[0].SFDC_Product__c);
                                        //SFDC_Product__c='XTRIG1000');
                                        
        System.debug('testPositive() - Display PriceBookEntry ID: '+ pbList[0].Id);                                 
        Test.startTest();        
        insert item;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, PricebookentryId, OpportunityId, 
                                             SFS_Opportunity_Record_Id__c, SFDC_Product__c
                                             FROM OpportunityLineItem WHERE OpportunityId = :oppList[0].Id];
        // assert the number of line items are created
        System.assertEquals(1, itemExt.size());
        // assert the opportunity id is matched
        System.assertEquals(oppList[0].Id, itemExt[0].OpportunityId);
        // assert pricebookentry is matched
        System.assertEquals(pbList[0].Id, itemExt[0].PricebookentryId);
        // assert the sfdc_product__c is matching
        System.assertEquals(itemExt[0].SFDC_Product__c, pbList[0].Product2.SFDC_Product__c);
    }
    
    // for the scenario where there is no steelbrick opportunity and respective sfdc_product__c values
    @isTest static void testNegative() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        /*List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c='XTRIG1000' AND IsActive=true]; */
        
         List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];
         System.debug('Display Product2 Index 1: '+prodList2[0]);  
         List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.Id=:prodList2[0].Id AND IsActive=true]; 
                                       
        // ensure that we have respective products
        System.assertEquals(1, pbList.size());
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId = oppList[0].id,
                                        PricebookentryId = pbList[0].Id,
                                        UnitPrice = null, Quantity = 10, TotalPrice=10,
                                        SFS_Opportunity_Record_Id__c = null,
                                        SFDC_Product__c=null);
        Test.startTest();        
        insert item;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, PricebookentryId, OpportunityId, 
                                             SFS_Opportunity_Record_Id__c, SFDC_Product__c
                                             FROM OpportunityLineItem WHERE OpportunityId = :oppList[0].Id];
        // assert the number of line items are created
        System.assertEquals(1, itemExt.size());
        // assert the opportunity id is matched
        System.assertEquals(oppList[0].Id, itemExt[0].OpportunityId);
        // assert pricebookentry is matched
        System.assertEquals(pbList[0].Id, itemExt[0].PricebookentryId);
        // assert the sfdc_product__c is null
        System.assertEquals(null, itemExt[0].SFDC_Product__c);
        // assert the sfs opportunity id is null
        System.assertEquals(null, itemExt[0].SFS_Opportunity_Record_Id__c);
    } 
    
    // for the bulk records scenario
    @isTest static void testBulk() {
        // fetch the records
        List<Opportunity> oppList = [SELECT Id, SFS_Opportunity_ID__c FROM Opportunity 
                                     WHERE Name like 'TrigOpptyTest%' LIMIT 1];
        List<PricebookEntry> pbList = [SELECT Id, Product2Id, Product2.SFDC_Product__c, IsActive 
                                       FROM PricebookEntry 
                                       WHERE Product2.SFDC_Product__c!=null AND IsActive=true];
        //List<Product2> prodList2 = [SELECT Id, SFDC_Product__c, IsActive FROM Product2 WHERE IsActive=true];
        // ensure that we have respective products
        System.assertEquals(200, pbList.size());
        List<OpportunityLineItem> itemsList = new List<OpportunityLineItem>();
        for(Integer i=0;i<200;i++) {
            OpportunityLineItem item = new OpportunityLineItem(OpportunityId = null,
                                        //PricebookentryId = pbList[i].Id,
                                        PricebookentryId = null,
                                        UnitPrice = null, Quantity = 10, TotalPrice=10,
                                        SFS_Opportunity_Record_Id__c = oppList[0].SFS_Opportunity_ID__c,
                                        SFDC_Product__c=pbList[i].Product2.SFDC_Product__c);
            itemsList.add(item);
        }
        Test.startTest();        
        insert itemsList;
        Test.stopTest();
        List<OpportunityLineItem> itemExt = [SELECT Id, PricebookentryId, OpportunityId, 
                                             SFS_Opportunity_Record_Id__c, SFDC_Product__c
                                             FROM OpportunityLineItem WHERE OpportunityId = :oppList[0].Id];
        // assert the number of line items are created and linked to opportunity/product
        System.assertEquals(200, itemExt.size());            
    }
    
}