trigger AccountScoring on Account (before insert, before update) {
for (Account A : trigger.New){

decimal pTotal = 0;
    if (a.Has_Accounting_Auditing_Internet__c == true)
    {
        pTotal = pTotal+1;
            }
    if(a.Has_Active_Data__c == true)
    {
        pTotal = pTotal+1;
            }
    if(a.Has_AnswerConnect__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_ARM__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_ATX__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Axcess_Document__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Axcess_Practice__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Axcess_Tax__c == true)
    {
        pTotal = pTotal+1;
    }
   if(a.Has_Axcess_Workstream__c == true)
   {
       pTotal = pTotal+1;
   }
    if(a.Has_CCH_Expert_Treatises__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_ClientRelate__c == true)
    {
       pTotal = pTotal+1;
    }
    if(a.Has_COMPL1_Master_Tax_Guide__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_COMPL2_PTE_Single_TPP__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_COMPL3_PTE_Core_TPP__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Compliance_Services__c == true)
    {
        pTotal = pTotal+1;
    }
    if (a.Has_CORPC_MTG_PTP_3_Full_or_5_Lite_Stat__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_CORPP_MTG_TRC_50_States_Lite_Forms__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_CORPS1_MTG_FED_TRC_50_States_Full__c == true)
    {
       pTotal = pTotal+1; 
    }
    if(a.Has_CORPS2_MTG_FED_TRC_All_States_Mu__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Database_Lookup_RADAR__c == true)
    {
     pTotal = pTotal+1;   
    }
    if(a.Has_Document__c == true)
    {
      pTotal = pTotal+1;  
    }
    if(a.Has_Document_ASP__c == true)
    {
      pTotal = pTotal+1;  
    }
    if(a.Has_Document_On_Premise__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Engagement__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Entity_Planning__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Federal_Add_Ons__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Financial_and_Estate_Tax__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Fixed_Assets__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Fixed_Assets_Manager_OP__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Fixed_Assets_Manager_SaaS__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_GFX__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_IC__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_IFirm__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_IntelliForms__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_International_Tax__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Journals__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Knowledge_Coach__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Knowledge_Connect__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Knowledge_Tools__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Learning_and_Seminars__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Load_Utilities__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Open_Integrator__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Outsource__c == true)
      
       {
           pTotal = pTotal+1;
       }
    if(a.Has_PDFlyer__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Portal_SaaS__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_POS_Tax_Portal__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Practice__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Practice_Management__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Practice_Manager__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_PROP1_PTP_Core_TPP__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_PROS4_Standard_FED__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_PROS6_FED_Federal_TPP_1_State__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_PROT2_TRC_Lite_Core_TPP__c == true)
    {
        pTotal = pTotal+1;
    }
    if (a.Has_PROT3_TRC__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_PROT5_TRC_Federal_TPP_1_State__c == true)
    {
        pTotal = pTotal+1;
    }
        if(a.Has_Returns__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Sales_Tax_Office__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Sales_Tax_Online_CORE__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Scan__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Scan_SaaS__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Schools__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_SFS_Other_Ancillary__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_SFS_Research__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Specialty_Planning__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_State_Tax_Reporters__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_State_Tax_Specialty__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_SureTax__c == true)
    {
        pTotal = pTotal+1;
    }
        if(a.Has_TAX0_TRC_and_FED__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_TAX1_TRC_FED_Federal_TPP_1_State__c)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_TAX2A_TRC_FED_Fed_TPP_1_State_Enti__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Tax__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Tax_Prep_Partner__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_TaxWise__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Telecom_DB_Lookup_RADAR_Flag__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Trial_Balance__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Utility_DB_Lokup_RADAR_Flag__c == true)
    {
        pTotal = pTotal+1;
    }
    if(a.Has_Workpaper_Manager__c == true)
    {
        pTotal = pTotal+1;
    }   
    
    
   a.total_product_count__c = pTotal; 

                if(a.RecordTypeId == '012i0000000Ou0CAAS'){
       for (AccountScoring__c CP : AccountScoring__c.getAll().values()) {

                if(a.Market_Sub_Segment__c == null || a.Market_Sub_Segment__c =='')
                {
                a.account_scoring_subsegment_points__c = 0;
                }
                else
                if(CP.Subsegment__c==a.Market_Sub_Segment__c){
                a.account_scoring_subsegment_points__c = cp.CustomerPoints__c;               
                }
                if(a.account_Scoring_tenure__c == null || a.account_Scoring_tenure__c == '')
                {
                a.Account_Scoring_Tenure_Points__c = 0;
                }
                else                
                if(CP.CustomerYears__c == a.account_Scoring_tenure__c){
                a.Account_Scoring_Tenure_Points__c = CP.CustomerPoints__c;
                }
                if(a.Account_scoring_product_Count__c == null || a.Account_scoring_product_Count__c == '')
                {
                a.account_scoring_product_points__c = 0;
                }
                else
                if(CP.Product_Count__c == a.account_scoring_product_count__c){
                a.account_scoring_product_points__c = cp.customerpoints__c;
                }
                if(a.account_scoring_YTD_returns__c == null || a.account_scoring_YTD_returns__c =='')
                {
                a.account_scoring_YTD_return_Points__c =0;
                }
                else
                if(cp.numberofreturns__c == a.account_scoring_YTD_returns__c){
                a.account_scoring_YTD_return_Points__c = cp.customerpoints__c;
                }
                if(a.customer_segmentation__c == null || a.customer_segmentation__c =='')
                {
                a.account_scoring_Cust_Segmentation_points__c = 0;
                }
                else                
                if(cp.customersegmentation__c == a.customer_segmentation__c){
                a.account_scoring_Cust_Segmentation_points__c = cp.customerpoints__c;
                }
                

            
       }       
    }
        else 
            if(a.RecordTypeId == '012i0000000Ou0EAAS'){
            for (AccountScoring__c CP : AccountScoring__c.getAll().values()) {
            if(a.Market_Sub_Segment__c==null || a.Market_Sub_Segment__c=='')
            { 
                a.account_scoring_subsegment_points__c=0;
            }
            else
            if(CP.Subsegment__c==a.Market_Sub_Segment__c){
                a.account_scoring_subsegment_points__c =cp.ProspectPoints__c;
                }
                if (a.customer_segmentation__c==null || a.customer_segmentation__c=='')
                {
                a.account_scoring_Cust_Segmentation_points__c = 0;
                }
                else
                
            if(cp.customersegmentation__c == a.customer_segmentation__c){
                a.account_scoring_Cust_Segmentation_points__c = cp.prospectpoints__c;
                }

       }
    }
    
    
   }      
}