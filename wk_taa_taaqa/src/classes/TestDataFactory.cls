/*
*This class will be referenced to create row data
*/
@isTest
public class TestDataFactory {
    
    //Create sales alignment
    public static Sales_Alignment__c insertSalesAlignment(string salesAlignment, string salesRepRole)
    {
    Sales_Alignment__c sa=new Sales_Alignment__c();
    sa.Sales_Alignment__c=salesAlignment;
    sa.Sales_Rep_Role__c=salesRepRole;
    insert sa;
    return sa;
    }
    
    //Assignment Matrix 
    public static Assignment_Matrix__c assignmentMatrixWithAF(String marketSegment,String marketsubSegment){
        Assignment_Matrix__c am = new Assignment_Matrix__c();
        am.Name = 'Demo Assignment Matrix with Accounting Firms';
        am.Market_Segment__c = marketSegment;
        am.Market_Sub_Segment__c = marketsubSegment;
        am.Type__c = 'Professional';
        //am.AISR__c = 'AISR';
        am.AISR__c ='ISC - Books & Journals';
        //am.ASR_Indirect_Corp_Software__c ='Demo ASRICS';
        am.ASR_Indirect_Corp_Software__c='ISC - Corp Software Indirect';
        //am.Corp_Direct__c = 'Demo CD';
        am.Corp_Direct__c = 'RSC - Corp Software Direct';
        //am.Corp_Indirect__c = 'Demo CI';
        am.Corp_Indirect__c = 'RSC - Corp Software Indirect';
        //am.ISR_Indirect__c = 'ISR - Indirect (Corp Software)';
        am.ISR_Indirect__c='ISC - Corp Software Indirect';
        //am.NAM_SAM_CNAM__c = 'Demo named Account';
        //am.Pro_SW_FSR__c = 'FSR � Professional Software';
        am.Pro_SW_FSR__c ='RSC - Professional Software';
        am.Pro_SW_ISR__c = 'Demo PSI';
        am.QP__c = 'QP Specialist';
        //am.R_L_ASR__c = 'ASR � Research & Learning';
        am.R_L_ASR__c ='RC - Research & Learning';
        //am.R_L_FSR__c = 'FSR � Research & Learning';
        am.R_L_FSR__c ='RSC - Research & Learning';
        am.R_L_ISR__c = 'ISC - Research & Learning';
        //am.SW_ASR__c = 'ASR Professional Software';
        am.SW_ASR__c = 'RC - Professional Software';
        //am.Service_Source__c = 'ASR � R&L Service Source';
        am.Service_Source__c = 'RC - R&L ServiceSource';
        
        insert am;
        return am;
    }
    
    //Assignment Matrix for National Account
    public static Assignment_Matrix__c assignmentMatrixForNamedAccount(String marketSegment,String marketsubSegment, String namedAccountType,String NAM_SAM_CNAM){
        Assignment_Matrix__c am = new Assignment_Matrix__c();
        am.Name = 'Demo Assignment Mtrix for named Account';
        am.Market_Segment__c = marketSegment;
        am.Market_Sub_Segment__c = marketsubSegment;
        am.Type__c = 'Professional';
        //am.AISR__c = 'AISR';
        am.AISR__c = 'ISC - Books & Journals';
        am.IsNamedAccount__c = true;
        am.NamedAccountType__c = namedAccountType;
        am.NAM_SAM_CNAM__c= NAM_SAM_CNAM;
        insert am;
        return am;
    }
    
    //Assignment Matrix with less number of rolls
    public static Assignment_Matrix__c assignmentMatrixWithLessRolls(String marketSegment,String marketsubSegment){
        Assignment_Matrix__c am = new Assignment_Matrix__c();
        am.Name = 'Demo Assignment Matrix with Accounting Firms';
        am.Market_Segment__c = marketSegment;
        am.Market_Sub_Segment__c = marketsubSegment;
        am.Type__c = 'Professional';
        //am.AISR__c = 'AISR';
        am.AISR__c = 'ISC - Books & Journals';
        insert am;
        return am;
    }
    
    //create ZipCodeDTN with less value
    public static ZipCodeDTN__c zipCodeDtn(String zipcode, String AISR, String QP){
        ZipCodeDTN__c z = new ZipCodeDTN__c();
        z.Name=zipcode;
        z.City__c = 'NORTH BENNINGTON';
        z.County__c = 'BENNINGTON';
        z.State__c = 'VT';
        z.AISR__c = AISR;
        z.QP__c = QP;
        
        insert z;
        return z;
    }
    
    //Create user
    public static User newUser(String dtn,Integer i){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User();
        u.Alias = 'standt'+i;
        u.Email=i+'standarduser@test.com'; 
        u.EmailEncodingKey='UTF-8'; 
        u.LastName='Testing'+i; 
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US'; 
        u.ProfileId = p.Id; 
        u.TimeZoneSidKey='America/Los_Angeles'; 
        u.UserName=i+'standarduser@testorg.com';
        u.DTN__c=dtn; 
        u.High_Level_Division__c='Research and Learning';
        u.Division__c='Northeast';
        u.License_Charge_To__c='Sales';
        u.CostCenter__c='1110';
        insert u;
        return u;
    }
    //Create market segment mappings
    public static list<Market_Segment_Mapping__c> marketSegmetMappings(){
        List<Market_Segment_Mapping__c> msList= new List<Market_Segment_Mapping__c>();
        Market_Segment_Mapping__c ms1 =new Market_Segment_Mapping__c(Name='Test0092',Segment__c='TestGeneral Corporate',SIC_Code__c='0092');
        msList.add(ms1);        
        Market_Segment_Mapping__c ms2 =new Market_Segment_Mapping__c(Name='Test0011',Segment__c='TestAccounting Firms',SIC_Code__c='0011');
        msList.add(ms2);        
        insert msList;
        return msList;
    }
    //Create Market segment rules
    public static list<Market_Segment_Rules__c> marketSegmentRules(){
        List<Market_Segment_Rules__c> msrList= new List<Market_Segment_Rules__c>();
        Market_Segment_Rules__c msr1 =new Market_Segment_Rules__c(Name='Test1',Segment__c='TestGeneral Corporate',IsSubSegmentBasedOnAnnualRevenue__c=True, IsSubSegmentBasedOnEmployeeCount__c=True);
        msrList.add(msr1);      
        Market_Segment_Rules__c msr2 =new Market_Segment_Rules__c(Name='Test2',Segment__c='TestAccounting Firms',IsSubSegmentBasedOnAnnualRevenue__c=False, IsSubSegmentBasedOnEmployeeCount__c=True);
        msrList.add(msr2);      
        insert msrList;
        return msrList;
    }
    //Create Market sub segment mappings
    public static list<Market_Sub_Segment_Mapping__c> marketSubSegmentMappings(){
        List<Market_Sub_Segment_Mapping__c> mssList= new List<Market_Sub_Segment_Mapping__c>();
        Market_Sub_Segment_Mapping__c mss1 =new Market_Sub_Segment_Mapping__c(Name='Test1',Segment__c='TestGeneral Corporate',Sub_Segment__c='Size TBD',GTE_AnnualRevenue__c=null,LTE_AnnualRevenue__c=0,GTE_NumberOfEmployees__c=null,LTE_NumberOfEmployees__c=0);
        mssList.add(mss1);      
        Market_Sub_Segment_Mapping__c mss2 =new Market_Sub_Segment_Mapping__c(Name='Test2',Segment__c='TestGeneral Corporate',Sub_Segment__c='Small',GTE_AnnualRevenue__c=1,LTE_AnnualRevenue__c=49999999,GTE_NumberOfEmployees__c=1,LTE_NumberOfEmployees__c=499);
        mssList.add(mss2);      
        Market_Sub_Segment_Mapping__c mss3 =new Market_Sub_Segment_Mapping__c(Name='Test3',Segment__c='TestGeneral Corporate',Sub_Segment__c='Global Enterprise',GTE_AnnualRevenue__c=500000000,LTE_AnnualRevenue__c=null,GTE_NumberOfEmployees__c=5000,LTE_NumberOfEmployees__c=null);
        mssList.add(mss3);      
        Market_Sub_Segment_Mapping__c mss7 =new Market_Sub_Segment_Mapping__c(Name='Test7',Segment__c='TestGeneral Corporate',Sub_Segment__c='Global Enterprise',GTE_AnnualRevenue__c=0,LTE_AnnualRevenue__c=null,GTE_NumberOfEmployees__c=5000,LTE_NumberOfEmployees__c=null);
        mssList.add(mss7);   
        Market_Sub_Segment_Mapping__c mss8 =new Market_Sub_Segment_Mapping__c(Name='Test8',Segment__c='TestGeneral Corporate',Sub_Segment__c='Mid Enterprise',GTE_NumberOfEmployees__c=5000,LTE_NumberOfEmployees__c=50000);
        mssList.add(mss8); 
        Market_Sub_Segment_Mapping__c mss4 =new Market_Sub_Segment_Mapping__c(Name='Test4',Segment__c='TestAccounting Firms',Sub_Segment__c='Size TBD',GTE_NumberOfEmployees__c=null,LTE_NumberOfEmployees__c=0);
        mssList.add(mss4);      
        Market_Sub_Segment_Mapping__c mss5 =new Market_Sub_Segment_Mapping__c(Name='Test5',Segment__c='TestAccounting Firms',Sub_Segment__c='Sole Proprietor',GTE_NumberOfEmployees__c=1,LTE_NumberOfEmployees__c=19);
        mssList.add(mss5);      
        Market_Sub_Segment_Mapping__c mss6 =new Market_Sub_Segment_Mapping__c(Name='Test6',Segment__c='TestAccounting Firms',Sub_Segment__c='100+ Total Employees',GTE_NumberOfEmployees__c=100,LTE_NumberOfEmployees__c=null);
        mssList.add(mss6);      
        insert mssList;
        return mssList;
    }
    //Create Taa custom setting
    public static AccountAutomationSetting__c newTaaCustomSetting(String username){
        //TAACustomSetting__c t = new TAACustomSetting__c();
        AccountAutomationSetting__c t = new AccountAutomationSetting__c(); 
        t.BatchJobAdmin__c = 'kant.ra@hcl.com';
        t.Default_Account_Custodian__c = username;
        t.ExcludedAccountRecordTypeForUpdate__c = 'Partner Account';
        t.GeneralDataSizeInBatchJob__c = 1000;
        t.IsTriggerOff__c = false;
        //t.ServiceSourceRole__c ='ASR - R&L Service Source';
        t.ServiceSourceRole__c='RC - R&L ServiceSource';
        insert t;
        return t;
    }
    //Create Strategic_Account_RoleDTN__c
    public static Strategic_Account_RoleDTN__c newSAR(String accountName,String dtn,User sa,User sam){
        Strategic_Account_RoleDTN__c s = new Strategic_Account_RoleDTN__c();
        s.Account__c = accountName;
        s.Association__c = 'Praxity';
        s.City__c = 'Rockville';
        s.DTN__c = dtn;
        s.Offices__c = '1';
        s.Size__c = 216;
        s.Solution_Architect__c =  sa.id;
        s.State__c = 'MD';
        s.Strategic_Account_Manager__c = sam.id;
        insert s;
        return s;
    }
    //Create Corporate_National_Role_DTN__c
    public static Corporate_National_Role_DTN__c newCNR(String accountName, User userCNAM, String dtn){
        Corporate_National_Role_DTN__c c = new Corporate_National_Role_DTN__c();
        c.Account__c = accountName;
        c.Corporate_National_Account_Manager__c = userCNAM.id;
        c.DTN__c = dtn;
        insert c;
        return c;
    }
    //Create National_Account_Management__c
    public static National_Account_Management__c newNAM(String accountName, String dtn, User userNAM){
        National_Account_Management__c n = new National_Account_Management__c();
        n.Account__c = accountName;
        n.DTN__c = dtn;
        n.NationalAccountManager__c = userNAM.id;
        insert n;
        return n;
    }
    //Create Service_Source_Role_DTN__c
    public static ServiceSource_Role_DTN__c newSS(String accountName, String dtn, User userSS){
        ServiceSource_Role_DTN__c ss = new ServiceSource_Role_DTN__c();
        ss.Account__c = accountName;
        ss.DTN__c = dtn;
        ss.Service_Source_Manager__c= userSS.id;
        insert ss;
        return ss;
    }
    //Create Lead
    public static Lead newLead(String name){
        Lead l = new Lead();
        l.LastName=name;
        l.Company='HCL';
        l.email = 'test@example.com';
        l.Named_Account_Type__c = 'National';
        insert l;
        return l;
    }
}