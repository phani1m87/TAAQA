@isTest(SeeAllData= false)
private class TestDTNMakeupFieldAssignment{
    //setup for test to be executed
   static void setup(){
        list<Market_Segment_Mapping__c> msmList = TestDataFactory.marketSegmetMappings();
        list<Market_Segment_Rules__c> msrList = TestDataFactory.marketSegmentRules();
        list<Market_Sub_Segment_Mapping__c> mssmList = TestDataFactory.marketSubSegmentMappings();
        User u1 = TestDataFactory.newUser('211a',1);
        User u2 = TestDataFactory.newUser('211b',2);
        User u3 = TestDataFactory.newUser('211c',3);
        User u4 = TestDataFactory.newUser('211d',4);
        User u5 = TestDataFactory.newUser('211e',5);
        User u6 = TestDataFactory.newUser('211f',6);
        User u7 = TestDataFactory.newUser('211g',7);
        User u8 = TestDataFactory.newUser('211h',8);
        User u9 = TestDataFactory.newUser('211i',9);
        User u10 = TestDataFactory.newUser('211j',10);
        User u11 = TestDataFactory.newUser('211k',11);
        User u12= TestDataFactory.newUser('211l',12);
        User u13 = TestDataFactory.newUser('211m',13);
        User u14 = TestDataFactory.newUser('211n',14);
        ZipCodeDTN__c z=TestDataFactory.zipCodeDtn('55555', '211a', '211b');
        z.ASR_Indirect_Corp_Software__c='211c';
        z.Corp_Direct__c = '211d';
        z.Corp_Indirect__c = '211e';
        z.ISR_Indirect__c = '211f';
        z.NAM_SAM_CNAM__c = '211g';
        z.Pro_SW_FSR__c = '211h';
        z.Pro_SW_ISR__c = '211i';
        z.R_L_ASR__c = '211j';
        z.R_L_FSR__c = '211k';
        z.SW_ASR__c='211l';
        z.Service_Source__c = '211m';
        z.R_L_ISR__c='211n';
        update z;
        List<Assignment_Matrix__c>assignmentMatrix = new List<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','National','National','National Solution Consultant'));
        String username = [Select id,Name,DTN__c from user where DTN__c='211a'].Name;
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','211j',u10,u10);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', u11, '211k');
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '211g', u12);
        ServiceSource_Role_DTN__c ss= TestDataFactory.newSS('DemoSS','211m',u13);
    }
    static testMethod void testTNMakeupFieldAssignment1() {
        setup();
        Account acct1 = new Account(Name='myAccount', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        
        insert acct1;
        Account a=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='myAccount' Limit 1];
        a.AISR__c='';
        a.Corp_Direct__c='';
        a.Corp_Indirect__c='';
        a.Inside_Sales__c='';
        a.NAM_SAM_CNAM__c='';
        a.Pro_SW_FSR__c='';
        a.QP__c='';
        a.R_L_ASR__c='';
        a.R_L_FSR__c='';
        a.R_L_ISC__c='';
        a.SW_ASR__c='';
        a.Service_Source__c='';
        update a;
        Test.startTest();
        DTNMakeupFieldAssignment dmf= new DTNMakeupFieldAssignment();
        Database.executebatch(dmf);
        Test.stopTest();
        Account ac=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='myAccount' Limit 1];
       // system.assertEquals('211a',ac.AISR__c);
        //system.assertEquals('211b',ac.QP__c);'
        //system.assertEquals('211m',ac.Service_Source__c);
    }
    static testMethod void testTNMakeupFieldAssignmentforNamedAccount() {
        setup();
        Account acct1 = new Account(Name='DemoNAM', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='National');
        
        insert acct1;
        Account a=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='DemoNAM' Limit 1];
        a.AISR__c='';
        a.Corp_Direct__c='';
        a.Corp_Indirect__c='';
        a.Inside_Sales__c='';
        a.NAM_SAM_CNAM__c='';
        a.Pro_SW_FSR__c='';
        a.QP__c='';
        a.R_L_ASR__c='';
        a.R_L_FSR__c='';
        a.R_L_ISC__c='';
        a.SW_ASR__c='';
        a.Service_Source__c='';
        update a;
        Test.startTest();
        DTNMakeupFieldAssignment dmf= new DTNMakeupFieldAssignment();
        Database.executebatch(dmf);
        Test.stopTest();
        Account ac=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='DemoNAM' Limit 1];
       // system.assertEquals('211a',ac.AISR__c);
        //system.assertEquals('211b',ac.QP__c);
        System.assertEquals('211g',ac.NAM_SAM_CNAM__c);
    }
      static testMethod void testTNMakeupFieldAssignmentServiceSource() {
        setup();
        Account acct1 = new Account(Name='DemoSS', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='Service Source');
        
        insert acct1;
        Account a=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='DemoSS' Limit 1];
        a.AISR__c='';
        a.Corp_Direct__c='';
        a.Corp_Indirect__c='';
        a.Inside_Sales__c='';
        a.NAM_SAM_CNAM__c='';
        a.Pro_SW_FSR__c='';
        a.QP__c='';
        a.R_L_ASR__c='';
        a.R_L_FSR__c='';
        a.R_L_ISC__c='';
        a.SW_ASR__c='';
       // a.Service_Source__c='';
        update a;
        Test.startTest();
        DTNMakeupFieldAssignment dmf= new DTNMakeupFieldAssignment();
        Database.executebatch(dmf);
        Test.stopTest();
        Account ac=[Select Name,billingPostalCode, Market_SegMEnt__c,Market_Sub_Segment__c,Named_Account__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,R_L_ISC__c,SW_ASR__c,Service_Source__c from Account where name='DemoSS' Limit 1];
       // system.assertEquals('211a',ac.AISR__c);
        system.assertEquals('211b',ac.QP__c);
        system.assertEquals('211m',ac.Service_Source__c);
    }
}