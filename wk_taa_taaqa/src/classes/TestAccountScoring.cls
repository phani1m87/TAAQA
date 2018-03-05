@istest
public class TestAccountScoring {
    static testMethod void AccountScoringTest(){
    
    
    AccountScoring__c CP = new AccountScoring__c();
        CP.Name = '2-4 Total Employees';
        CP.Subsegment__c = '2-4 Total Employees';
        CP.CustomerPoints__c = 43.0;
        CP.ProspectPoints__c = 43.0;
        Insert CP;
        
        AccountScoring__c CP1 = new AccountScoring__c();
        CP1.Name = '1 Product';
        CP1.Product_Count__c = '1 Product';
        CP1.CustomerPoints__c = 1.0;
        Insert CP1;
        
        AccountScoring__c CP2 = new AccountScoring__c();
        CP2.Name = '0-500 Returns';
        CP2.NumberOfreturns__c = '0-500 Returns';
        CP2.CustomerPoints__c = 1.0;
        Insert CP2;
        
        AccountScoring__c CP3 = new AccountScoring__c();
        CP3.Name = 'Advanced';
        CP3.CustomerSegmentation__c = 'Advanced';
        CP3.CustomerPoints__c = 1.0;
        CP3.ProspectPoints__c = 1.0;
        Insert CP3;






Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco', 
            market_segment__c = 'Accounting Firms', 
            market_sub_segment__c = '2-4 Total Employees',
            has_axcess_tax__c = True,
            has_Axcess_Practice__c = True,
            has_Axcess_Document__c = true,
            has_Axcess_Workstream__c = true,
            has_document__c = True,
            has_engagement__c = true,
            has_trial_balance__c = true,
            has_fixed_assets__c = true,
            has_clientrelate__c = true,
            has_document_asp__c = true,
            has_tax__c = true,
            has_practice__c = true,
            has_practice_management__c = true,
            has_pdflyer__c = true,
            has_atx__c = true,
            Has_Compliance_Services__c  = true,
            Has_CORPC_MTG_PTP_3_Full_or_5_Lite_Stat__c  = true,
            Has_CORPP_MTG_TRC_50_States_Lite_Forms__c = true,
            Has_CCH_Expert_Treatises__c = true,
            Has_Document_On_Premise__c = true,
            Has_GFX__c = true,
            Has_IC__c = true,
            Has_Knowledge_Coach__c = true,
            Has_Knowledge_Tools__c = true,
            Has_Learning_and_Seminars__c = true,
            Has_Load_Utilities__c = true,
            Has_Open_Integrator__c = true,
            Has_Outsource__c = true,
            Has_International_Tax__c = true,
            Has_IntelliForms__c = true,
            Has_Journals__c = true,
            Has_Sales_Tax_Office__c = true,
            Has_PROT3_TRC__c  = true,
            Has_PROP1_PTP_Core_TPP__c = true,
            Has_Practice_Manager__c = true,
            Has_POS_Tax_Portal__c = true,
            Has_Portal_SaaS__c  = true,
            Has_Scan_SaaS__C = true,
            Has_SFS_Research__c = true,
            Has_Specialty_Planning__c = true,
            Has_State_Tax_Reporters__c = true,
            Has_Taxwise__c = true,
            Has_Tax_Prep_Partner__c = true,
            Has_SureTax__c = true,
            Has_Utility_DB_Lokup_RADAR_Flag__c = true,
            Has_Telecom_DB_Lookup_RADAR_Flag__c = true,
            Has_TAX2A_TRC_FED_Fed_TPP_1_State_Enti__c = true,
            Has_TAX1_TRC_FED_Federal_TPP_1_State__c = true,
            RecordTypeId = '012i0000000Ou0CAAS',
            YTD_TRNMT_RET_c__c = 250,
            customer_segmentation__c = 'Advanced' );
        insert A;
        
        Account A2 = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco', 
            market_segment__c = 'Accounting Firms', 
            market_sub_segment__c = '2-4 Total Employees',
            RecordTypeId = '012i0000000Ou0EAAS',
            customer_segmentation__c = 'Advanced' );
        insert A2;

        
                  
}
}