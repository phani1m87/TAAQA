@isTest(seeAllData=false)
private class Test_LeadTriggerHandler{
    static testMethod void Test_LeadTriggerHandler(){
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '2221');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Sales_Alignment__c sa1=TestDataFactory.insertSalesAlignment('R&L','FSR - Research and Learning');
        Sales_Alignment__c sa2=TestDataFactory.insertSalesAlignment('R&L ASR','ASR - Research and Learning');
        Sales_Alignment__c sa3=TestDataFactory.insertSalesAlignment('FSR - Indirect (Corp Software - Core STG)','FSR - Indirect (Corp Software)');
        Sales_Alignment__c sa4=TestDataFactory.insertSalesAlignment('ISR - Indirect (Corp Software - Core STG)','ISR - Indirect (Corp Software)');
        Sales_Alignment__c sa5=TestDataFactory.insertSalesAlignment('QP','QP Rep');
        Sales_Alignment__c sa6=TestDataFactory.insertSalesAlignment('FSR - Software (Professional)','FSR - Professional Software');
        Sales_Alignment__c sa7=TestDataFactory.insertSalesAlignment('ISR','ISR - Professional Software + ISR Research and Learning');
        Sales_Alignment__c sa8=TestDataFactory.insertSalesAlignment('CAM','FSR - (Corp Direct Software)');
        Sales_Alignment__c sa9=TestDataFactory.insertSalesAlignment('R&L T&C','Training & Consulting Rep - Research & Learning');
       Test.startTest();
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='General Corporate';
        l.Market_Sub_Segment__c='Mid Enterprise';
        l.Sales_Alignment__c=sa1.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        //Test.startTest();
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa2.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa3.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa4.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa5.Sales_Alignment__c;
        update l;
        Test.stopTest();
        l.Sales_Alignment__c=sa6.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa7.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa8.Sales_Alignment__c;
        update l;
        l.Sales_Alignment__c=sa9.Sales_Alignment__c;
        update l;
        
    }
    
   
    static testMethod void Test_LeadTriggerHandler2(){
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        User u4 = TestDataFactory.newUser('111i',14);
        User u5 = TestDataFactory.newUser('111h',15);
        
        User u6 = TestDataFactory.newUser('111c',24);
        User u7 = TestDataFactory.newUser('111d',25);
        User u8 = TestDataFactory.newUser('111f',26);
        User u9 = TestDataFactory.newUser('333b',27);
        
        User u10 = TestDataFactory.newUser('111k',28);
        User u11 = TestDataFactory.newUser('111g',29);
        User u12 = TestDataFactory.newUser('111n',30);
        User u14 = TestDataFactory.newUser('111l',31);
        User u15 = TestDataFactory.newUser('111m',32);
        
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '2221');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.QP__c= '111n';
        z.TC__c= '111l';
        z.SW_ASR__c = '222a';
        z.R_L_ISR__c='111m';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('R_L_FSR__c','RSC - Research & Learning');
        Sales_Alignment__c sa1=TestDataFactory.insertSalesAlignment('R_L_ASR__c','RC - Research & Learning');
        Sales_Alignment__c sa2=TestDataFactory.insertSalesAlignment('Corp_Indirect__c','RSC - Corp Software Indirect');
        Sales_Alignment__c sa3=TestDataFactory.insertSalesAlignment('ISR_Indirect__c','ISC - Corp Software Indirect');
        Sales_Alignment__c sa4=TestDataFactory.insertSalesAlignment('Pro_SW_FSR__c','RSC - Professional Software');
        Sales_Alignment__c sa5=TestDataFactory.insertSalesAlignment('AISR__c','ISC - Books & Journals');
        
        Sales_Alignment__c sa6=TestDataFactory.insertSalesAlignment('QP__c','QP Specialist');
        Sales_Alignment__c sa7=TestDataFactory.insertSalesAlignment('Pro_SW_ISR__c','ISC - Professional Software');
        Sales_Alignment__c sa8=TestDataFactory.insertSalesAlignment('Corp_Direct__c','RSC - Corp Software Direct');
        Sales_Alignment__c sa9=TestDataFactory.insertSalesAlignment('TC__c','T&C - Research & Learning');
        Sales_Alignment__c sa10=TestDataFactory.insertSalesAlignment('R_L_ISR__c','ISC - Research & Learning');
        
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='General Corporate';
        l.Market_Sub_Segment__c='Mid Enterprise';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        //Test.startTest();
        l.Sales_Alignment__c=sa1.Sales_Alignment__c;
        update l;
        
        l.Sales_Alignment__c=sa2.Sales_Alignment__c;
        update l;
        
         l.Sales_Alignment__c=sa4.Sales_Alignment__c;
        update l;
        
        l.Sales_Alignment__c=sa3.Sales_Alignment__c;
        update l;
        
        l.Sales_Alignment__c=sa5.Sales_Alignment__c;
        update l;
        
         l.Sales_Alignment__c=sa6.Sales_Alignment__c;
        update l;
        
         l.Sales_Alignment__c=sa7.Sales_Alignment__c;
        update l;
        
         l.Sales_Alignment__c=sa8.Sales_Alignment__c;
        update l;
        
         l.Sales_Alignment__c=sa9.Sales_Alignment__c;
        update l;
        
        l.Sales_Alignment__c=sa10.Sales_Alignment__c;
        update l;
        
      
        
    } 
    
    static testMethod void Test_LeadTriggerHandlerConvert2(){
     User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '2221');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
        }
        
         static testMethod void Test_LeadTriggerHandlerConvertnamedAccount(){
         
         User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
         User uSAM = TestDataFactory.newUser('111f',6);
        User uSA = TestDataFactory.newUser('111g',7);
        User uCNAM = TestDataFactory.newUser('111h',8);
        User uNAM = TestDataFactory.newUser('111i',9);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '2221');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
         list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','111f',uSA,uSAM);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', uCNAM, '111h');
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '111i', uNAM);
        Account acct1 = new Account(Name='DemoNAM',billingPostalCode='05257',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        Test.startTest();
        insert acct1;
       
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**
        lc.setAccountId(acct1.Id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
      
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
        
         
         }
         
    static testMethod void Test_LeadTriggerHandlerNullZipCodeCheck(){
     User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '222a');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        //l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
    
    }
     static testMethod void Test_LeadTriggerHandlerCustodialUserCheck(){
     User u1 = TestDataFactory.newUser('111a',1);
       // User u2 = TestDataFactory.newUser('1112',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
  
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
       
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
    
    }
    static testMethod void Test_LeadTriggerHandlerAsignmentMAtrixAllCheck(){
     User u1 = TestDataFactory.newUser('111b',1);
       // User u2 = TestDataFactory.newUser('1112',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111b'].Name;
  
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
       
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Schools and Libraries';
        l.Market_Sub_Segment__c='Law Schools';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '222a');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
    
    }
    
    static testMethod void Test_LeadTriggerHandlerDefaultLeadCustodian(){
     
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        system.debug('IsUserActive**'+u1.IsActive);
        system.debug('IsUserActive2**'+u2.IsActive);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '222a');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('AISR','AISR');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        //l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
        }
        
        private static AccountAutomationSetting__c newTaaCustomSetting(String username){
           AccountAutomationSetting__c t = new AccountAutomationSetting__c(); 
            t.BatchJobAdmin__c = 'kant.ra@hcl.com';
            t.Default_Account_Custodian__c = username;
            //t.Default_Lead_Custodian__c=username;
            t.ExcludedAccountRecordTypeForUpdate__c = 'Partner Account';
            t.GeneralDataSizeInBatchJob__c = 1000;
            t.IsTriggerOff__c = false;
            //t.ServiceSourceRole__c ='ASR - R&L Service Source';
            t.ServiceSourceRole__c='RC - R&L ServiceSource';
            insert t;
            return t;
      }
      
      private static User newUser(String dtn,Integer i){
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
        u.IsActive=false;
        insert u;
        return u;
    }
    
     static testMethod void Test_LeadTriggerHandlerToEnterOtherIf(){
     
        User u1 = newUser('111a',1);
        User u2 = newUser('111b',2);
        User u4 = newUser('111i',4);
        system.debug('IsUserActive**'+u1.IsActive);
        system.debug('IsUserActive2**'+u2.IsActive);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = newTaaCustomSetting(username);
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '222a');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('R_L_FSR__c','RSC - Research & Learning');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
        }
        
        static testMethod void Test_UserMapNotHavingDTN_TXT(){
     
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 =  TestDataFactory.newUser('111b',2);
       
        system.debug('IsUserActive**'+u1.IsActive);
        system.debug('IsUserActive2**'+u2.IsActive);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('05257', '2307', '222a');
        z.ASR_Indirect_Corp_Software__c='111a';
        z.Corp_Direct__c = '111b';
        z.Corp_Indirect__c = '111c';
        z.ISR_Indirect__c = '111d';
        z.NAM_SAM_CNAM__c = '111e';
        z.Pro_SW_FSR__c = '111f';
        z.Pro_SW_ISR__c = '111g';
        z.R_L_ASR__c = '111h';
        z.R_L_FSR__c = '111i';
        z.Service_Source__c = '111j';
        z.SW_ASR__c = '222a';
        z.AISR__C='333b';
        update z;
        Sales_Alignment__c sa=TestDataFactory.insertSalesAlignment('R_L_FSR__c','RSC - Research & Learning');
        Lead l=new lead();
        l.LastName='Test';
        l.Company='HCL';
        l.Market_Segment__c='Accounting Firms';
        l.Market_Sub_Segment__c='5-9 Total Employees';
        l.Sales_Alignment__c=sa.Sales_Alignment__c;
        l.PostalCode='05257';
        insert l;
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Banks and Financial Institutions','All'));
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(l.Id);
          lc.setDoNotCreateOpportunity(True); //**IMPORTANT METHOD HERE**

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.StopTest();
        }
    
}