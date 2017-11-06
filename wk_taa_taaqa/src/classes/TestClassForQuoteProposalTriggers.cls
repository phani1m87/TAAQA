/*
    **************************************************************************
    Name    :   TestClassForQuoteProposalTriggers 
    Usage   :   Class is used to cover the code coverage of the trigger 'QuoteProposalTrigger'
    
    Version    |    Name            |    Date           
    1.0             Rajesh Meti          01-Dec-2014  
    2.0             Rajesh Meti          27-Jan-2015
    
    Trigger : QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update)
    
    ***************************************************************************
*/

@isTest(seeAlldata=false)
public class TestClassForQuoteProposalTriggers 
{
    @testsetup static void testQuoteProposalTriggerHandler() 
    {
        Map<String, RecordType> quoteProposalRecordTypeMap = new Map<String,RecordType>();
        for(RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType='Apttus_Proposal__Proposal__c']) {
            quoteProposalRecordTypeMap.put(rt.Name, rt);
        }
        
        Account AcctObj = new Account(  Name = 'myAcct', 
                                BillingStreet='25 Upland Drive',
                                BillingPostalCode='94127',
                                BillingCountry='United States',
                                BillingCity='San Francisco',
                                BillingState='CA',
                                Phone = '555555555');
        insert AcctObj;        
        
        Opportunity OpptyObj = new Opportunity( Name = 'CPQ Test Oppty', AccountId = AcctObj.Id, 
                                                CloseDate = date.today()+30, StageName = '5. Time to Buy',
                                                Forecast_Type__c = 'Low (<50%)' );
        insert OpptyObj;
        
        Account AcctObj1 = new Account(  Name = 'myAcct1', 
                                BillingStreet='25 Upland Drive',
                                BillingPostalCode='94127',
                                BillingCountry='United States',
                                BillingCity='San Francisco',
                                BillingState='CA',
                                Phone = '555555555');
        insert AcctObj1;
        
         Opportunity OpptyObj1 = new Opportunity( Name = 'CPQ Test Oppty1', AccountId = AcctObj1.Id, 
                                                CloseDate = date.today()+30, StageName = '5. Time to Buy',
                                                Forecast_Type__c = 'Low (<50%)' );
        insert OpptyObj1;

        Apttus_Config2__PriceList__c pricelistforAMSProposal = new Apttus_Config2__PriceList__c(Name ='Professional Software Price List', Apttus_Config2__Active__c = true);
        insert pricelistforAMSProposal;
        
        Apttus_Config2__PriceList__c pricelistforSAPProposal = new Apttus_Config2__PriceList__c(Name ='R&L Price List', Apttus_Config2__Active__c = true);
        insert pricelistforSAPProposal;
        
        Account_X_Reference__c SAPXRefAccObj = new Account_X_Reference__c( Name = '4441026029', Account__c = AcctObj.Id, ApplicationID__c = '4441026029', 
                                                                            Application__c = 'SAP', ERP_Account_Name__c = 'WEISER MAZARS', Bill_To_Street_Line_1__c = '135 W 50TH ST',
                                                                            Bill_To_Contact_Name__c = 'WENDY STEVENS', Bill_To_City__c = 'NEW YORK', Bill_To_State__c = 'NY', 
                                                                            Bill_To_Zip_Postal_Code__c = '10020-1201', Bill_To_Country__c = 'US', Ship_To_Contact_Name__c = 'VICTORIA PITKIN', 
                                                                            Ship_To_City__c = 'NEW YORK', Ship_To_Street_Line_1__c = '135 W 50TH ST', Ship_To_State__c = 'NY', 
                                                                            Ship_To_Zip_Postal_Code__c = '10020-1201', Ship_To_Country__c = 'US', AMS_Special_Agreement__c = 'Test', 
                                                                            AMS_Account_Grouping__c = 'Test', Bill_To_Street_Line_2__c = '135 W 50TH STREET', Ship_To_Street_Line_2__c = '135 W 50TH STREET',
                                                                            Ship_To_Partner_Number__c = '4441320673', Bill_To_Partner_Number__c = '4441320694', Street_Address__c = '135 W 50TH ST', 
                                                                            City__c = 'NEW YORK', State__c = 'NY', PostalCode__c = '10020-1201', Country__c = 'US');
        insert SAPXRefAccObj;

        Account_X_Reference__c AMSXRefAccObj = new Account_X_Reference__c( Name = '999999', Account__c = AcctObj.Id, ApplicationID__c = '999999',
                                                                            Application__c = 'AMS', ERP_Account_Name__c = 'WEISERMAZARS LLP', Bill_To_Street_Line_1__c = '12TH FLOOR',
                                                                            Bill_To_Contact_Name__c = 'JONATHAN GOLD', Bill_To_City__c = 'NEW YORK', Bill_To_State__c = 'NY',
                                                                            Bill_To_Zip_Postal_Code__c = '10020-1201', Bill_To_Country__c = 'US', Ship_To_Contact_Name__c = 'JONATHAN GOLD',
                                                                            Ship_To_City__c = 'NEW YORK', Ship_To_Street_Line_1__c = '12TH FLOOR', Ship_To_State__c = 'NY',
                                                                            Ship_To_Zip_Postal_Code__c = '10020-1201', Ship_To_Country__c = 'US', AMS_Special_Agreement__c = 'M',
                                                                            AMS_Account_Grouping__c = 'N', Bill_To_Street_Line_2__c = '135 W 50TH STREET', Ship_To_Street_Line_2__c = '135 W 50TH STREET',
                                                                            Ship_To_Partner_Number__c = '999999', Bill_To_Partner_Number__c = '999999', Street_Address__c = '135 W 50TH ST',
                                                                            City__c = 'NEW YORK', State__c = 'NY', PostalCode__c = '10020-1201', Country__c = 'US', Email__c ='test@test.com',
                                                                            Phone__c = '55555555', Authentication_Type__c = 'Standard', Max_IDs_Allowed__c = 999, IDs_Issued__c = 100);
        insert AMSXRefAccObj;       

                                
        Apttus_Proposal__Proposal__c SAPQuotePropObj = new Apttus_Proposal__Proposal__c( Apttus_Proposal__Proposal_Name__c = 'myProposal',SAP_Contact_Channel__c= 'Field Sales Rep',SAP_Sales_Channel__c ='Field Sales rep',  Apttus_Proposal__Opportunity__c = OpptyObj.Id, 
                                                                                        Apttus_Proposal__Primary__c = false, Apttus_QPConfig__ConfigurationFinalizedDate__c = null, 
                                                                                        ERP_Account__c = SAPXRefAccObj.Id, Apttus_Proposal__Account__c = AcctObj.Id, RecordTypeId = quoteProposalRecordTypeMap.get('SAP Subscription').Id, 
                                                                                        Apttus_QPConfig__PriceListId__c = pricelistforSAPProposal.Id
                                                                                    );
        insert SAPQuotePropObj; 
        
        Apttus_Proposal__Proposal__c SAPQuotePropObj1 = new Apttus_Proposal__Proposal__c( Apttus_Proposal__Proposal_Name__c = 'myProposal',SAP_Contact_Channel__c= 'Field Sales Rep',SAP_Sales_Channel__c ='Field Sales rep', Apttus_Proposal__Opportunity__c = OpptyObj1.Id, 
                                                                                        Apttus_Proposal__Primary__c = false, Apttus_QPConfig__ConfigurationFinalizedDate__c = null, 
                                                                                        Apttus_Proposal__Account__c = AcctObj1.Id, RecordTypeId = quoteProposalRecordTypeMap.get('SAP Subscription').Id, 
                                                                                        Apttus_QPConfig__PriceListId__c = pricelistforSAPProposal.Id
                                                                                    );
        insert SAPQuotePropObj1; 
        

        Apttus_Proposal__Proposal__c AMSQuotePropObj = new Apttus_Proposal__Proposal__c( Apttus_Proposal__Proposal_Name__c = 'myProposal', Apttus_Proposal__Opportunity__c = OpptyObj.Id, 
                                                                                        Apttus_Proposal__Primary__c = false, Apttus_QPConfig__ConfigurationFinalizedDate__c = null, 
                                                                                        ERP_Account__c = AMSXRefAccObj.Id, Apttus_Proposal__Account__c = AcctObj.Id, RecordTypeId = quoteProposalRecordTypeMap.get('AMS Proposal').Id, 
                                                                                        Apttus_QPConfig__PriceListId__c = pricelistforAMSProposal.Id
                                                                                    );
        insert AMSQuotePropObj;      
              
        Account_X_Reference__c SAPXRefAccObj1 = new Account_X_Reference__c( Name = '4441026030', Account__c = AcctObj.Id, ApplicationID__c = '4441026030', 
                                                                            Application__c = 'SAP', ERP_Account_Name__c = 'WEISER MAZARS1', Bill_To_Street_Line_1__c = '135 W 50TH ST',
                                                                            Bill_To_Contact_Name__c = 'WENDY STEVENS1', Bill_To_City__c = 'NEW YORK', Bill_To_State__c = 'NY', 
                                                                            Bill_To_Zip_Postal_Code__c = '10020-1201', Bill_To_Country__c = 'US', Ship_To_Contact_Name__c = 'VICTORIA PITKIN1', 
                                                                            Ship_To_City__c = 'NEW YORK', Ship_To_Street_Line_1__c = '135 W 50TH ST', Ship_To_State__c = 'NY', 
                                                                            Ship_To_Zip_Postal_Code__c = '10020-1201', Ship_To_Country__c = 'US', AMS_Special_Agreement__c = 'Test', 
                                                                            AMS_Account_Grouping__c = 'Test', Bill_To_Street_Line_2__c = '135 W 50TH STREET', Ship_To_Street_Line_2__c = '135 W 50TH STREET',
                                                                            Ship_To_Partner_Number__c = '4441320674', Bill_To_Partner_Number__c = '4441320695', Street_Address__c = '135 W 50TH ST', 
                                                                            City__c = 'NEW YORK', State__c = 'NY', PostalCode__c = '10020-1201', Country__c = 'US', Email__c ='test@test.com',
                                                                            Phone__c = '55555555', Authentication_Type__c = 'Standard', Max_IDs_Allowed__c = 999, IDs_Issued__c = 100);
        insert SAPXRefAccObj1;     
    }
    
    static testmethod void testBeforeUpdate()
    {
    	Map<String, RecordType> quoteProposalRecordTypeMap = new Map<String,RecordType>();
        for(RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType='Apttus_Proposal__Proposal__c']) {
            quoteProposalRecordTypeMap.put(rt.Name, rt);
        }
    	
    	Account AcctObj1 = [SELECT Id FROM Account WHERE Name = 'myAcct1'];	
		Account_X_Reference__c SAPXRefAccObj1 = [SELECT Id FROM Account_X_Reference__c WHERE Name =: '4441026030'];
    	Apttus_Proposal__Proposal__c SAPQuotePropObj = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE RecordTypeId =: quoteProposalRecordTypeMap.get('SAP Subscription').Id LIMIT 1];
    	Account_X_Reference__c SAPXRefAccObj = [SELECT Id FROM Account_X_Reference__c WHERE Name =: '4441026029'];
    	
    	Test.startTest();
    	SAPQuotePropObj.Apttus_Proposal__Account__c = AcctObj1.Id;
        SAPQuotePropObj.ERP_Account__c = SAPXRefAccObj1.Id;
        update SAPQuotePropObj;
        
        SAPQuotePropObj.ERP_Account__c = SAPXRefAccObj.Id;
        SAPQuotePropObj.Ship_To_ERP_Account__c = null;
        update SAPQuotePropObj;
        
        Apttus_Proposal__Proposal__c AMSQuotePropObj = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE RecordTypeId =: quoteProposalRecordTypeMap.get('AMS Proposal').Id LIMIT 1];
        Account_X_Reference__c AMSXRefAccObj = [SELECT Id FROM Account_X_Reference__c WHERE Name =: '999999'];
        AMSQuotePropObj.ERP_Account__c = AMSXRefAccObj.Id;
        update AMSQuotePropObj;
        Test.stopTest();          
    }
}