public with sharing class CBIController {

    Public  CBI_form__C cbi{get;set;}    
 Public opportunity opp{get;set;}
 Public Account acc{get;set;}
  Public List<Contact> con{get;set;}
  Public User usr{get;set;}
  Public User arch{get;set;}
 
    public CBIController() 
  {
  GetCBI();
  GetOpp();
  GetUsr();
  GetArch();
  GetAcc();
  GetCon();
  
  }
  public void GetCBI()
  {
cbi = [SELECT Name, CreatedById, CreatedDate, IsDeleted, SA_Email_Warning__c, Account__c,
Appointment_Goals__c, Attendees__c, Audit_Fines__c, Competitor_use_proposed_solution__c,
Consolidations_of_fixed_assets_needed__c, Current_Client_Challenges__c, Current_document_management__c,
Current_GL_package_TB_format__c,Current_process_for_sign_off_and_review__c,Current_TB_process_managing__c,
Increased_Risk_of_Data_Breach__c,Department_implementing_WPM__c, Do_XBRL_reporting_How__c,
Do_you_use_Outloook_for_your_email__c, Efile_returns_or_send_offsite_for_review__c, 
Experience_Pfx_Engagement_E_Paper__c, Firm_Organization_Objectives__c, Lower_Profit_Margins__c,
Hot_Buttons_Critical_Pain_Points__c, How_are_we_countering__c, How_do_we_match_our_selling_process_to_i__c,
How_many_users_of_the_system__c, How_they_trial_balance_amounts_in_return__c, How_tracking_FA_is_being_done__c,
Impacts_of_those_Challenges__c,Is_Partner_included_in_the_demo__c,
Key_Process_Workflow__c, Location__c, Maintain_historical_document_versions__c, Manager_Email__c,
Membership_Groups_Different__c, Moving_to_Paperless_system__c, Number_of_Assets_add_during_the_year__c,
Number_of_assets_added_during_the_year__c, Number_of_fixed_assets_for_each_company__c, Opportunity__c,
Other_needs_for_fixed_asset_tracking__c, Outside_auditor_CPA_use_ProSystem_Tax__c,
Pain_points_complexities_to_discuss__c, Perform_consolidations_Which_ones__c, Perform_interim_reporting_Frequency__c,
Post_Call_Completed__c, Post_Call_Completed_Date__c, Potential_Objections__c, Pre_Call_Completed__c,
Pre_Call_Completed_Date__c, Prepare_foreign_forms_Which_ones__c, Presentation_Date__c, Presentation_Focus__c,
Presentation_Type__c, Presenting_Bundle__c, Product_Category__c, Products_Currently_Used__c, Products_to_Present__c,
Proposed_Demo_Flow__c, ProSystem_Tax_experience_If_so_who__c, provide_current_workpaper_structure__c,
Provide_sample_financial_or_other_report__c, Report_on_a_consolidated_basis__c, 
Reports_on_calendar_month_quarter_year__c, Response_to_Objections__c, Sales_Rep__c, SA_Manager_Email__c,
Search_capability_importance__c, Solution_Architect__c, Solution_Blue_Print_Age__c,
Solutions_needed_for_existing_problems__c, state_calculations_being_maintained__c, States_Currently_Filing_In__c,
Status__c, Strategy_for_defeating_the_competition__c, Lower_Realization_Rates__c, Tax_Competitor__c,
Tax_Competitor_End_Date__c, Technology_Comments__c, Total_Cost_of_Ownership__c, Types_of_Return_Currently_Filing__c,
User_and_office_count_roles_utilizing__c, Users_needing_access_to_software__c, Using_now_for_tax_and_fixed_assets__c,
What_are_our_blind_spots_Critical__c, What_are_the_competition_s_strategies__c, What_are_your_retention_policies__c,
What_don_t_we_know__c, What_is_the_buying_process__c, What_bad_thing_happens_if_they_do_not__c,
Who_is_SAP_Microsoft_NetSuite_Partner__c,risk__c, expertise__c, productivity__c, primary_contact__c,Primary_Contact_Role__c,
Demo2Win_Considerations__c,Seller_s_Strategy_on_the_Buyer_s_Stage__c,Customers_Stage_in_the_Buyers_Process__c,
DSM_Blueprint_Rating__c,DSM_Director_Blueprint_Review_Notes__c,SA_Note_s__c
FROM CBI_Form__c WHERE Id = :ApexPages.currentPage().getParameters().get('id') LIMIT 1];
}
   Public void GetOpp()
   {    
opp = [Select name,accountid,ownerid,closedate,amount from opportunity where id = :cbi.opportunity__c];
}
Public Void GetUsr()
{
usr = [Select name from user where id = :opp.OwnerId];
}
Public Void GetArch()
{

arch =[Select name from user where id = :cbi.Solution_Architect__c];

}
Public Void GetAcc()
{
acc = [select NON_INDIV_RETURNS_PERCENT_RANGE_c__c, X2013_User_Conference_Attendee__c, 
CONSULT_CFO_WORK_PERCENT_GTRTEN_c__c, Description, Fax, Id, Name, AccountNumber, Phone, Rating, Site, 
Type, Accounting_and_Audit_Total__c, Active_Data_Total__c, Add_Ons_Total__c, jsImpacts__Added_from_Data_com__c,
AnnualRevenue, Audit_Competitor__c, FEE_PER_RETURN_AVG_c__c, Axcess_Document_Total__c, Axcess_Practice_Total__c,
Axcess_Tax_Total__c, Axcess_Workstream_Competitor__c, Axcess_Workstream_Total__c, Bank_Products__c, CPA_Led__c,
Came_from_Lead__c, BillingCity, Compliance_Services_Total__c, Corp_Filer_Type__c,
Numb_Countries_Do_Business_In__c, BillingCountry, Billing_County__c, CreatedById, CreatedDate,
Customer_Segmentation__c, NumberOfEmployees, jsImpacts__Data_com_does_not_auto_update__c,
jsImpacts__Data_com_Managed__c, jsImpacts__Data_com_Matched__c, Database_Lookup_RADAR_Total__c, IsDeleted,
Document_Competitor__c, Document_Foundation_Total__c, Document_On_Premise_Total__c, ERO_1040__c,
ERO_1041__c, ERO_1065__c, ERO_1120__c, ERO_941__c, ERO_990__c, ERO_EFFDT__c, ERP_Technology__c,
ERP_Vendor_Account1__c, ERP_Vendor_Account_Flag__c, Electronic_Filing_Total__c, Engagement_Competitor__c,
Engagement_Total__c, CUSTID__c, FYE_Date__c, Federal_Add_On_Total__c, Firm_Affiliation__c,
Firm_Networks__c, Scale__c, Fixed_Assets_Competitor__c, Fixed_Assets_Total__c,
Global_Integrator_Total__c, GlobalFx_Total__c, Growth_Aspiration__c, Headquarter_Country__c,
HQ_State__c, Has_ARM__c, Has_Accounting_Auditing_Internet__c, Has_Active_Data__c,
Has_Axcess_Document__c, Has_Axcess_Practice__c, Has_Axcess_Tax__c, Has_Axcess_Workstream__c,
Has_CCH_Expert_Treatises__c, Has_COMPL1_Master_Tax_Guide__c, Has_COMPL2_PTE_Single_TPP__c,
Has_COMPL3_PTE_Core_TPP__c, Has_CORPC_MTG_PTP_3_Full_or_5_Lite_Stat__c, Has_CORPP_MTG_TRC_50_States_Lite_Forms__c,
Has_CORPS1_MTG_FED_TRC_50_States_Full__c, Has_CORPS2_MTG_FED_TRC_All_States_Mu__c, Has_ClientRelate__c,
Has_Compliance_Services__c, Has_Database_Lookup_RADAR__c, Has_Document__c, Has_Document_ASP__c,
Has_Document_On_Premise__c, Has_Engagement__c, Has_Entity_Planning__c, Has_Federal_Add_Ons__c,
Has_Financial_and_Estate_Tax__c, Has_Fixed_Assets__c, Has_Fixed_Assets_Manager__c, Has_GFX__c,
Has_IntelliForms__c, Has_International_Tax__c, Has_Journals__c, Has_Knowledge_Coach__c,
Has_Knowledge_Connect__c, Has_Knowledge_Tools__c, Has_Learning_and_Seminars__c, Has_Load_Utilities__c,
Has_Outsource__c, Has_PDFlyer__c, Has_PROP1_PTP_Core_TPP__c, Has_PROS4_Standard_FED__c,
Has_PROS6_FED_Federal_TPP_1_State__c, Has_PROT2_TRC_Lite_Core_TPP__c, Has_PROT3_TRC__c,
Has_PROT5_TRC_Federal_TPP_1_State__c, Has_Portal_SaaS__c, Has_Practice__c, Has_Practice_Management__c,
Has_Practice_Manager__c, Has_Returns__c, Has_Sales_Tax_Office__c, Has_Sales_Tax_Online_CORE__c, Has_Scan__c,
Has_Scan_SaaS__c, Has_Schools__c, Has_Specialty_Planning__c, Has_State_Tax_Reporters__c,
Has_State_Tax_Specialty__c, Has_SureTax__c, Has_TAX0_TRC_and_FED__c, Has_TAX1_TRC_FED_Federal_TPP_1_State__c,
Has_TAX2A_TRC_FED_Fed_TPP_1_State_Enti__c, Has_Tax__c, Has_Tax_Prep_Partner__c,
Has_Telecom_DB_Lookup_RADAR_Flag__c, Has_Trial_Balance__c, Has_Utility_DB_Lokup_RADAR_Flag__c,
Has_POS_Tax_Portal__c, Inactive__c, Industry, International_Associations__c, International_Total__c,
Knowledge_Coach_Total__c, Knowledge_Connect_On_Premise_Total__c, Knowledge_Connect_SaaS_Total__c, 
Knowledge_Management_Competitor__c, Knowledge_Tools_Total__c, Large_Corps_Total__c, 
Last_AMS_Inventory_Stop_Date__c, Last_AMS_Non_Sub_Order_Date__c, Last_AMS_Product_Date__c, LastActivityDate, 
LastModifiedById, LastModifiedDate, Last_SAP_Inventory_Stop_Date__c, Last_SAP_Non_Sub_Order_Date__c, 
Last_SAP_Product_Date__c, Learning_Total__c, Load_Utilities_Total__c, MassMerge_Batch_Id_used_by_MassMerge__c, 
MasterRecordId, Merge_To_Account_used_by_MassMerge__c, Mid_Corps_Total__c, MultiNational_Company__c, 
Named_Account__c, Named_Account_Type__c, Number_of_Audits__c, NO_FTE_c__c, Numb_States_Located__c, 
Organizer_Proforma_Total__c, outsource_competitor__c, Outsource_Total__c, OwnerId, Ownership, 
POS_Tax_Portal_Total__c, Portal_Competitor__c, Portal_Total__c, Practice_Competitor__c, 
Practice_Management_Total__c, Practice_Manager_Total__c, Practice_Total__c, Provisioning_Competitor__c, 
RecordTypeId, Research_2nd_Competitor__c, research_competitor__c, Return_Vol__c, Returns_Total__c, 
SFDC_Account__c, Sic, STG_Calculation_Competitor__c, STG_Compliance_Competitor__c, STG_database_Competitor__c, 
STG_Number_of_Returns__c, STG_States_with_Nexus__c, STG_Supported_Products__c, 
Sales_Tax_Office_Online_CORE_Total__c, Sales_Tax_Office_Total__c, Sales_and_Use_Competitor__c, 
Scan_Competitor__c, Scan_SaaS_Total__c, Scan_Total__c, Schools_Total__c, Market_Segment__c, Segment_Status__c, 
Segmentation_Validated__c, Business_Mix__c, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, 
ShippingPostalCode, Professional_Revenue_Total__c, State_Add_On_Total__c, BillingState, 
Numb_States_Do_Business_In__c, BillingStreet, Market_Sub_Segment__c, Supported_Platform__c, Suretax_Total__c, 
SystemModstamp, Tax_Competitor__c, Tax_Compliance_Library_Total__c, Tax_Consultant_Library_Total__c, 
Tax_Professional_Library_Total__c, Tax_Second_Competitor__c, Tax_Total__c, Tech_Appetite__c, 
Telecom_DB_Lookup_total__c, TickerSymbol, Trial_Balance_Competitor__c, Trial_Balance_Total__c, 
Utility_DB_Lookup_RADAR_Total__c, VAR_Account1__c, VAR_Account_Flag__c, VAR_Customer__c, Website, 
website_competitor__c, Workpaper_Manager_Total__c, YTD_TRNMT_RET_c__c, BillingPostalCode from Account where id = :opp.accountid]; 
 }
 Public Void GetCon()
 {
con = [Select name,email,phone,X2014_User_Conference_Attendee__c,X2015_User_Conference_Attendee__c from Contact where id in (select contactid from opportunityContactRole where opportunityid = :cbi.opportunity__c)];
    }
    }