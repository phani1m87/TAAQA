/**
 * This class contains unit tests for validating the behavior of
 *Apex class : UtilDTNStampingAndTeamMemberCreation
 *and trigger : AccountTrigger
 *
 
 */
@isTest(SeeAllData= false)
private class TestUtilDTNStampingAndTeamMemberCreation {
    //setup for test to be executed
   static void setup(){
        system.debug('inside setup==>');
        list<Market_Segment_Mapping__c> msmList = TestDataFactory.marketSegmetMappings();
        list<Market_Segment_Rules__c> msrList = TestDataFactory.marketSegmentRules();
        list<Market_Sub_Segment_Mapping__c> mssmList = TestDataFactory.marketSubSegmentMappings();
        User u1 = TestDataFactory.newUser('2111',1);
        User u2 = TestDataFactory.newUser('2112',2);
        User u3 = TestDataFactory.newUser('2113',3);
        User u4 = TestDataFactory.newUser('2114',4);
        User u5 = TestDataFactory.newUser('2115',5);
        User uSAM = TestDataFactory.newUser('2116',6);
        User uSA = TestDataFactory.newUser('2117',7);
        User uCNAM = TestDataFactory.newUser('2118',8);
        User uNAM = TestDataFactory.newUser('2119',9);
        system.debug(loggingLevel.Error,'----u5----::'+[Select id,Name,DTN__c from user where DTN__c='2115']);
        list<ZipCodeDTN__c>zipCodeDTNlist = new list<ZipCodeDTN__c>();
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('55555', '2111', '2112'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('66666', '2113', '2114'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('44444','222a', '222b'));
        
        /*zipCodeDTN with having values for all fields*/
       ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('77777', '2220', '2221');
        z.ASR_Indirect_Corp_Software__c='2111';
        z.Corp_Direct__c = '2112';
        z.Corp_Indirect__c = '2113';
        z.ISR_Indirect__c = '2114';
        z.NAM_SAM_CNAM__c = '2115';
        z.Pro_SW_FSR__c = '2116';
        z.Pro_SW_ISR__c = '2117';
        z.R_L_ASR__c = '2118';
        z.R_L_FSR__c = '2119';
        z.Service_Source__c = '2110';
        
        //z.SW_ASR__c = '2222';
        update z;
        zipCodeDTNlist.add(z);
        
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Banks and Financial Institutions','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Corp Nat','Corp','Corporate National','CAM - Corporate Account Manager'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','National','National','NAM - National Accounts'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','Strategic','Strategic','SAM - Strategic Account Manager'));
        String username = [Select id,Name,DTN__c from user where DTN__c='2115'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','2116',uSA,uSAM);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', uCNAM, '2118');
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '2119', uNAM);
        ServiceSource_Role_DTN__c ss= TestDataFactory.newSS('DemoSS','2117',uSA);
        system.debug('end inside setup==>');
        
    }
    
    /*static testMethod void assignValueOnTheBasisOfSIC() {
        setup();
        List<Account> newAccountList = new List<Account>();
        Account acct1 = new Account(Name='myAcct1', Sic = '0092', AccountSource = 'Data.com', AnnualRevenue=0, NumberOfEmployees=0);    
        newAccountList.add(acct1);
        Account acct2 = new Account(Name='myAcct2', Sic = '0092', AccountSource = 'Data.com', AnnualRevenue=4999999, NumberOfEmployees=498);   
        newAccountList.add(acct2);
        Account acct3 = new Account(Name='myAcct3', Sic = '0092', AccountSource = 'Data.com', AnnualRevenue=500000001, NumberOfEmployees=5001); 
        newAccountList.add(acct3);      
        Account acct4 = new Account(Name='myAcct4', Sic = '0011', AccountSource = 'Data.com', NumberOfEmployees=0);   
        newAccountList.add(acct4);
        Account acct5 = new Account(Name='myAcct5', Sic = '0011', AccountSource = 'Data.com', NumberOfEmployees=18);   
        newAccountList.add(acct5);
        Account acct6 = new Account(Name='myAcct6', Sic = '0011', AccountSource = 'Data.com', NumberOfEmployees=101);
        newAccountList.add(acct6);   
        Account acct7 = new Account(Name='myAcct7', Sic = '0092', AccountSource = 'Data.com', AnnualRevenue=0, NumberOfEmployees=50001);   
        newAccountList.add(acct7);
        Account acct8 = new Account(Name='myAcct8', Sic = '0092', AccountSource = 'Data.com', NumberOfEmployees=6000);   
        newAccountList.add(acct8);  
        Account acct9 = new Account(Name='myAcct9', Sic = '0092', AccountSource = 'Data.com', NumberOfEmployees=5001);   
        newAccountList.add(acct9);              
        
        Test.startTest();           
            insert newAccountList;  
        Test.stopTest();
        
        list<Account> accounts = [Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account ];
        List<Monitoring_Log__c> loglist=[Select Name,Account__c,Class__c,Detail__c,Type__c from Monitoring_Log__c where createdDate= today];
        //System.assert(loglist.size()==9);
        system.debug(loggingLevel.Error,'--account size::'+accounts.size()+'--::'+accounts);
    }*/
    
    //verify if account has zip code
    static testMethod void accountWithCorrectzip(){
        setup();
        system.debug(loggingLevel.Error,'-----taa------::'+[Select id,Default_Account_Custodian__c,IsTriggerOff__c from AccountAutomationSetting__c].Default_Account_Custodian__c);
        system.debug(logginglevel.Error,'-------c------::'+UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c);
        system.debug(loggingLevel.Error,'------cu-----::'+[Select id,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c]);
        Account acct1 = new Account(Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        Test.startTest();
        insert acct1;
        Test.stopTest();
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAcct1' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
       
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        User u1 = TestDataFactory.newUser('6781',10);
        
        AccountTeamMember AccountTeamMemberObj = new AccountTeamMember(UserId = u1.id,accountid = a.id);
        insert AccountTeamMemberObj;
        
        system.debug('account TEAM==>1'+[Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]);
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assertEquals('2111',a.AISR__c);
       // system.assertEquals('2112',a.QP__c);
        //system.assertEquals(1,atmMap.size());
       // system.assertEquals('Testing10',atmMap.get('6781').user.Name);
       
        //Monitoring_log__c ml=[Select Name,Account__c,Class__c,Detail__c,Type__c from Monitoring_Log__c where Account__c= :a.id];
        //system.assertEquals('ATA_TEAM_MEMBER_CREATED',ml.Type__c);
    }
    //verify if account is assigned with dtn but user is not present into the system
    static testMethod void accountWithDelinquentDTN(){
        setup();
        System.debug('<<<<accountWithDelinquentDTN>>>>');
        Account acct1 = new Account(Name='myAccount1',billingPostalCode='44444',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        Test.startTest();
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAccount1' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assertEquals('2220',a.AISR__c);
        //system.assertEquals('2221',a.QP__c);
        system.assert(atmMap.size()==0);
        //system.assertEquals('Testing5',atmMap.get('2115').user.Name);
        //List<Monitoring_log__c> ml=[Select Name,Account__c,Class__c,Detail__c,Type__c from Monitoring_Log__c where Type__c='ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM' Or Type__c='ATA_CODE_ERROR'];
        //system.assert(ml.size()>0);
    }
    //verify if account is assigned with deliquent billing postal code
    static testMethod void accountWithDelinquentBillingPostalCode(){
        setup();
        Account acct1 = new Account(Name='myAccount',billingPostalCode='wrongzip',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        Test.startTest();
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        system.assertEquals(0,atmMap.size());
        //Monitoring_log__c ml=[Select Name,Account__c,Class__c,Detail__c,Type__c from Monitoring_Log__c where Account__c= :a.id];
        //system.assertequals('ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM',ml.Type__c);
    }
    //verify if account is Named Account and present in National Account
    static testMethod void namedAccountInNationalAccount(){
        setup();
        Account acct1 = new Account(Name='DemoNAM',billingPostalCode='55555',Market_Segment__c='General Corporate', Market_Sub_Segment__c='Global Enterprise',Named_Account__c=true,Named_Account_Type__c='National');
        Test.startTest();
        System.debug('Inactive Value Check===='+acct1.Inactive__c);
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='DemoNAM' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        
    }
    
        //verify if zipcodeDtn has value for all fields
    static testMethod void zipcodedtnWithValuesforAllField(){
        setup();
        Account acct1 = new Account(Name='myAccount',billingPostalCode='77777',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        system.debug(loggingLevel.Error,'-----------------:::'+[Select ASR_Indirect_Corp_Software__c,Corp_Direct__c,Corp_Indirect__c,NAM_SAM_CNAM__c,Pro_SW_ISR__c from Assignment_Matrix__c where Market_Segment__c='Accounting Firms']);
        system.debug(loggingLevel.Error,'-----------------:::'+[Select ASR_Indirect_Corp_Software__c,Corp_Direct__c,Corp_Indirect__c,NAM_SAM_CNAM__c,Pro_SW_ISR__c from ZipCodeDTN__c where Name='77777']);
        Test.startTest();
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,SW_ASR__c,
                    Service_Source__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assert(atmMap.size()>0);
    }
    //verify the change in zipcode will change the dtn assignment
    static testMethod void zipcodeChange(){
        setup();
        system.debug(loggingLevel.Error,'-----taa------::'+[Select id,Default_Account_Custodian__c,IsTriggerOff__c from AccountAutomationSetting__c].Default_Account_Custodian__c);
        system.debug(logginglevel.Error,'-------c------::'+UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c);
        system.debug(loggingLevel.Error,'------cu-----::'+[Select id,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c]);
        Account acct1 = new Account(Name='myAccount', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert acct1;
        
        Account ab =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+ab);
        
         User u1 = TestDataFactory.newUser('6731',11);
        
        AccountTeamMember AccountTeamMemberObj = new AccountTeamMember(UserId = u1.id,accountid = ab.id);
        insert AccountTeamMemberObj;
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:ab.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
       // system.assertEquals(1,atmMap.size());
        system.assertEquals('Testing11',atmMap.get('6731').user.Name);
        //system.assertEquals('Testing2',atmMap.get('2112').user.Name);
        
        Test.startTest();
        acct1.billingPostalCode = '66666';
        update acct1;
        Test.stopTest();
        
        Account aa =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+aa);
        map<String,AccountTeamMember>atmMapa = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:aa.id]){
            atmMapa.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMapa);
        /*system.assertEquals(2,atmMapa.size());
        system.assertEquals('Testing3',atmMapa.get('2113').user.Name);
        system.assertEquals('Testing4',atmMapa.get('2114').user.Name);*/
    }
    //verify change in segment and subsegment will change the dtn assignment
    static testMethod void segmentChange(){
        setup();
        system.debug(loggingLevel.Error,'-----taa------::'+[Select id,Default_Account_Custodian__c,IsTriggerOff__c from AccountAutomationSetting__c].Default_Account_Custodian__c);
        system.debug(logginglevel.Error,'-------c------::'+UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c);
        system.debug(loggingLevel.Error,'------cu-----::'+[Select id,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c]);
        Account acct1 = new Account(Name='myAccount', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert acct1;
        
        Account ab =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+ab);
       
    User u1 = TestDataFactory.newUser('6331',12);
        
        AccountTeamMember AccountTeamMemberObj = new AccountTeamMember(UserId = u1.id,accountid = ab.id);
        insert AccountTeamMemberObj;
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:ab.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assertEquals(1,atmMap.size());
        system.assertEquals('Testing12',atmMap.get('6331').user.Name);
        //system.assertEquals('Testing2',atmMap.get('2112').user.Name);
        
        Test.startTest();
        acct1.Market_Segment__c = 'Legal Professionals';
        acct1.Market_Sub_Segment__c= 'Law Firm 1-3 Attorneys';
        update acct1;
        Test.stopTest();
        
        Account aa =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+aa);
        map<String,AccountTeamMember>atmMapa = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:aa.id]){
            atmMapa.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMapa);
        //system.assertEquals(1,atmMapa.size());
        //system.assertEquals('Testing1',atmMapa.get('2111').user.Name);
        //system.assertEquals('Testing2',atmMap.get('2112').user.Name);
    }
    //if named account is unchecked the account will behave normally
    /*static testMethod void uncheckedNamedAccount(){
        setup();
        Account acct1 = new Account(Name='DemoNAM',billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='National');
        insert acct1;
        
        Account ab =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='DemoNAM' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+ab);
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:ab.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        system.assertEquals(1,atmMap.size());
        system.assertEquals('Testing9',atmMap.get('2119').user.Name);
        
        Test.startTest();
        acct1.Named_Account__c = false;
        update acct1;
        Test.StopTest();
        
        Account aa =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c from Account where name='DemoNAM' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+aa);
        map<String,AccountTeamMember>atmMapa = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:aa.id]){
            atmMapa.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMapa);
        system.assertEquals(2,atmMapa.size());
        system.assertEquals('Testing1',atmMapa.get('2111').user.Name);
        system.assertEquals('Testing2',atmMapa.get('2112').user.Name);
    }*/
      //verify if assignmentMatrix subsegment ALl value
    static testMethod void accountWithSegmentALLsubsegment(){
        setup();
         //zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('55555', '1111', '1112'));
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Banks and Financial Institutions','All'));
        System.debug('????????????????????????????'+assignmentMatrix);
        system.debug(loggingLevel.Error,'-----taa------::'+[Select id,Default_Account_Custodian__c,IsTriggerOff__c from AccountAutomationSetting__c].Default_Account_Custodian__c);
        system.debug(logginglevel.Error,'-------c------::'+UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c);
        system.debug(loggingLevel.Error,'------cu-----::'+[Select id,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c]);
        Account acct1 = new Account(Name='myAcct1', billingPostalCode='77777',Market_Segment__c='Schools and Libraries', Market_Sub_Segment__c='Law Schools',Named_Account__c=false);
        Test.startTest();
        insert acct1;
        Test.stopTest();
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAcct1' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
       // system.assertEquals('2111',a.AISR__c);
        //system.assertEquals('2112',a.QP__c);
        //system.assert(atmMap.size()>0);
        //system.assertEquals('Testing1',atmMap.get('2111').user.Name);
        //system.assertEquals('Testing2',atmMap.get('2112').user.Name);

   }
   
   static testMethod void updateAccountZipCode(){
        setup();
        
        Account acct1 = new Account(Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        Test.startTest();
        insert acct1;
        Test.stopTest();
        
        //system.debug(loggingLevel.Error,'-----------::'+a);
        //acct1 .Market_Segment__c='Banks and Financial Institutions';
        //acct1 .Market_Sub_Segment__c='Size TBD';
        acct1 .billingPostalCode='66666';
        //a.Exclude_Account_Automation__c=false;
        CheckRecursive.run=true;
        update acct1 ;
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAcct1' limit 1];
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assertEquals('2113',a.AISR__c);
        //system.assertEquals('2114',a.QP__c);
        //system.assertEquals(2,atmMap.size());
        //system.assertEquals('Testing3',atmMap.get('2113').user.Name);
        //system.assertEquals('Testing4',atmMap.get('2114').user.Name);
        //Monitoring_log__c ml=[Select Name,Account__c,Class__c,Detail__c,Type__c from Monitoring_Log__c where Account__c= :a.id];
        //system.assertEquals('ATA_TEAM_MEMBER_CREATED',ml.Type__c);
    }
     static testMethod void namedAccountINStrategicAccount(){
        setup();
        Account acct1 = new Account(Name='DemoSAM',billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='2-4 Total Employees',Named_Account__c=true,Named_Account_Type__c='Strategic');
        Test.startTest();
        System.debug('Inactive Value Check===='+acct1.Inactive__c);
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='DemoSAM' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
       
    }
         static testMethod void namedAccountINServiceSource(){
        setup();
        Account acct1 = new Account(Name='DemoSS',billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='Sole Proprietor',
        Named_Account__c=true,Named_Account_Type__c='Service Source',Service_Source__c ='2110');
        Test.startTest();
        System.debug('Inactive Value Check===='+acct1.Inactive__c);
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='DemoSS' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        
    }    
    
    static testMethod void namedAccountCorporateNational(){
        setup();
        Account acct1 = new Account(Name='DemoCNR',billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='Sole Proprietor',Named_Account__c=true,Named_Account_Type__c='Corporate National');
        Test.startTest();
        System.debug('Inactive Value Check===='+acct1.Inactive__c);
        insert acct1;
        Test.StopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='DemoCNR' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        
    }    
    
    static testMethod void nam_SAM(){
        setup();
        Account acct1 = new Account(Name='myAccount',NAM_SAM_CNAM__c='2115',billingPostalCode='77777',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false
        );
        system.debug(loggingLevel.Error,'-----------------:::'+[Select ASR_Indirect_Corp_Software__c,Corp_Direct__c,Corp_Indirect__c,NAM_SAM_CNAM__c,Pro_SW_ISR__c from Assignment_Matrix__c where Market_Segment__c='Accounting Firms']);
        system.debug(loggingLevel.Error,'-----------------:::'+[Select ASR_Indirect_Corp_Software__c,Corp_Direct__c,Corp_Indirect__c,NAM_SAM_CNAM__c,Pro_SW_ISR__c from ZipCodeDTN__c where Name='77777']);
        Test.startTest();
        insert acct1;
        Test.StopTest();
        
        system.debug('acct1**'+acct1);
        
        Account a =[Select id,Name,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,SW_ASR__c,
                    Service_Source__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        //system.assert(atmMap.size()>0);
    }
    
    
     static testMethod void deleteAccount(){
         setup();
         system.debug('inside delete account===>');
         List<Account> listAccount=new List<Account>();
         map<Id,Account>accmMap = new map<Id,Account>();
     
         RecordType rtypes = [Select Name, Id From RecordType 
         where sObjectType='Account' and isActive=true limit 1];
          
          //User testUser1 = TestDataFactory.newUser('44448',1);
         User testUser1 =[SELECT Name,DTN__c FROM User where UserRoleId In(Select Id from UserRole where Name='Sales Consultant - AISR') and IsActive=true limit 1];
         system.debug('test user===>'+testUser1);
         Account acct = new Account(Name='myAcct1',billingPostalCode='55555',Exclude_Account_Automation__c=false,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='All',Named_Account__c=false,Named_Account_Type__c='Strategic',
         NAM_SAM_CNAM__c=testUser1.DTN__c);
         insert acct;
         
         
         
         AccountTeamMember atmOld1= new AccountTeamMember(AccountId=acct.Id, UserId=testUser1.Id,TeamMemberRole='QP Specialist');
         insert atmOld1;
         
          AccountTeamMember atmOld2= new AccountTeamMember(AccountId=acct.Id, UserId=testUser1.Id,TeamMemberRole='Strategic Account Manager');
  
         insert atmOld2;
         
         system.debug('inside account ===>'+acct);
         accmMap.put(acct.Id,acct);
         
         
          system.debug('accmMap ====>'+accmMap);
         Account acct2 = new Account(billingPostalCode='66666',Market_Segment__c='Accounting Firms',NAM_SAM_CNAM__c='',Named_Account__c=false, 
         Market_Sub_Segment__c='All',Named_Account_Type__c='Strategic', Id=acct.id,RecordTypeId=rtypes.Id);
         update acct2;
      
         listAccount.add(acct2);
           
         AccountTeamMember atm= new AccountTeamMember(AccountId=acct2.Id, UserId=testUser1.Id,TeamMemberRole='QP Specialist');
         insert atm;
         
         AccountTeamMember atm2= new AccountTeamMember(AccountId=acct2.Id, UserId=testUser1.Id,TeamMemberRole='Strategic Account Manager');
         insert atm2;
      
         map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
         map<Id,map<String,AccountTeamMember>> availabelATMs   = new map<Id,map<String,AccountTeamMember>>(); 
         for(AccountTeamMember atm3: [Select id,user.Name,user.DTN__c,TeamMemberRole,accountid from AccountTeamMember where accountid=:accmMap.keySet()]){
           atmMap.put(atm3.user.DTN__c,atm2);
           availabelATMs.put(atm3.accountid,new map<String,AccountTeamMember>{atm3.User.DTN__c => atm3});
         }
      
         system.debug('listAccount.size()****'+listAccount.size());
         system.debug('accmMap****'+accmMap.size());
         
     FederalRoleManager__c customSetting = new FederalRoleManager__c(DTN__c = '0111',Role__c = 'National Solution Consultant');
     insert customSetting;
     
         UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(listAccount,accmMap);
         utilDTNStampingAndTeamMemberCreation.deleteAccountTeamMembers(listAccount,accmMap);
         
         utilDTNStampingAndTeamMemberCreation.assignDTNToDTNFieldsOnAccount(listAccount,accmMap);
     
         //utilDTNStampingAndTeamMemberCreation.federalAccountTeamAssignMent(acct2);
         
         
         Account newValue1 = new Account(Named_Account_Type__c= 'Strategic',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
         insert newValue1;
 
         Account newValue2 = new Account(Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
         insert newValue2;
         Account newValue3 = new Account(Named_Account_Type__c= 'Corporate National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
         insert newValue3;

         listAccount.add(newValue1);
         listAccount.add(newValue2);
         listAccount.add(newValue3);
         
         utilDTNStampingAndTeamMemberCreation.assignDTNToDTNFieldsOnAccount(listAccount,accmMap);

        }
     
     static testMethod void deleteAccount2(){
         setup();
         List<Account> listAccount=new List<Account>();
         map<Id,Account>accmMap = new map<Id,Account>();
         set<String> dtnList=new set<String>();
     
         RecordType rtypes = [Select Name, Id From RecordType 
         where sObjectType='Account' and isActive=true limit 1];
      
         User testUser1 = TestDataFactory.newUser('abcgj',28);
         //User testUser1 =[SELECT Name,DTN__c FROM User where UserRoleId In(Select Id from UserRole where Name='Sales Consultant - AISR') and IsActive=true limit 1];
      
         Account acct = new Account(Name='myAcct1',billingPostalCode='55555',Exclude_Account_Automation__c=false,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='Strategic',
         Service_Source__c=testUser1.DTN__c);
         insert acct;
         
         
         accmMap.put(acct.Id,acct);
      
         Account acct2 = new Account(billingPostalCode='66666',Market_Segment__c='Accounting Firms',Service_Source__c='',Named_Account__c=false, 
         Market_Sub_Segment__c='5-9 Total Employees',Named_Account_Type__c='Strategic', Id=acct.id,RecordTypeId=rtypes.Id);
         update acct2;
         
         
         Account acctNamedAccount = new Account(Name='myAcct2',billingPostalCode='55555',Exclude_Account_Automation__c=true,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Banks and Financial Institutions', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='Strategic',
         Service_Source__c='2112');
         insert acctNamedAccount ;
      
         listAccount.add(acct2);
         dtnList.add(acct.Service_Source__c);
         dtnList.add(acct2.Service_Source__c);
            
         AccountTeamMember atm= new AccountTeamMember(AccountId=acct.Id, UserId=testUser1.Id,TeamMemberRole='QP Specialist');
         insert atm;
      
         map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
         map<Id,map<String,AccountTeamMember>> availabelATMs   = new map<Id,map<String,AccountTeamMember>>(); 
         for(AccountTeamMember atm2: [Select id,user.Name,user.DTN__c,TeamMemberRole,accountid from AccountTeamMember where accountid=:accmMap.keySet()]){
            atmMap.put(atm2.user.DTN__c,atm2);
            availabelATMs.put(atm2.accountid,new map<String,AccountTeamMember>{atm2.User.DTN__c => atm2});
          }
         
         Account newValue = new Account(Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
         insert newValue;
        
         Account oldValue = new Account(Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
         insert oldValue;
         
         
         system.debug('listAccount.size()****'+listAccount.size());
         system.debug('accmMap****'+accmMap.size());
         
          UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(listAccount,accmMap);
          utilDTNStampingAndTeamMemberCreation.deleteAccountTeamMembers(listAccount,accmMap);
          utilDTNStampingAndTeamMemberCreation.dtnMakeupString(dtnList);
          utilDTNStampingAndTeamMemberCreation.deleteAccountTeamMembers(listAccount,null);
          
          
          utilDTNStampingAndTeamMemberCreation.assignAssignmentMatrixKey(acctNamedAccount);
          utilDTNStampingAndTeamMemberCreation.getAssignmentMatrix(acctNamedAccount);
          utilDTNStampingAndTeamMemberCreation.blankCorrespondingDtnFields(acctNamedAccount);
          utilDTNStampingAndTeamMemberCreation.assignZipAMWithDtnToRole(listAccount);
          utilDTNStampingAndTeamMemberCreation.assignOldZipAMWithDtnToRole(listAccount);
          utilDTNStampingAndTeamMemberCreation.createDtnSetToCreateATMs(acct,acct2);
          utilDTNStampingAndTeamMemberCreation.assignAccountTeamAndSharingRules(listAccount,accmMap);
          utilDTNStampingAndTeamMemberCreation.assignAccountTeamAndSharingRules(listAccount,accmMap);
          list<Account> accLst = new list<Account>();
          accLst.add(newValue);
          
          utilDTNStampingAndTeamMemberCreation.assignAccountTeamAndSharingRules(accLst,null);
          utilDTNStampingAndTeamMemberCreation.createDtnSet(newValue,oldValue);
     
          
      
     }
     
    /* static testMethod void coverBlankMapNAMANDSS(){
         setup();
         List<Account> listAccount=new List<Account>();
         List<Account>BlankNamedAccountList=new List<Account>();
         map<Id,Account>accmMap = new map<Id,Account>();
         set<String> dtnList=new set<String>();
     
         RecordType rtypes = [Select Name, Id From RecordType 
         where sObjectType='Account' and isActive=true limit 1];
      
         User testUser1 = TestDataFactory.newUser('abcgk',30);
         //User testUser1 =[SELECT Name,DTN__c FROM User where UserRoleId In(Select Id from UserRole where Name='Sales Consultant - AISR') and IsActive=true limit 1];
      
         Account acct = new Account(Name='myAcct1',billingPostalCode='55555',Exclude_Account_Automation__c=false,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Named Accounts', Market_Sub_Segment__c='Strategic',Named_Account__c=false,Named_Account_Type__c='Strategic',
         Service_Source__c='',NAM_SAM_CNAM__c='');
         insert acct;
         
         accmMap.put(acct.Id,acct);
      
         Account acct2 = new Account(billingPostalCode='',Market_Segment__c='Named Corp Nat',Service_Source__c=testUser1.DTN__c,Named_Account__c=true, 
         Market_Sub_Segment__c='Strategic',Named_Account_Type__c='Strategic', Id=acct.id,RecordTypeId=rtypes.Id,NAM_SAM_CNAM__c=testUser1.DTN__c);
         update acct2;
         listAccount.add(acct2);
         
         Account blankNamedAccount = new Account(billingPostalCode='',Market_Segment__c='Named Corp Nat',Service_Source__c=testUser1.DTN__c,Named_Account__c=true, 
         Market_Sub_Segment__c='Strategic',Named_Account_Type__c='', Id=acct.id,RecordTypeId=rtypes.Id,NAM_SAM_CNAM__c=testUser1.DTN__c);
         update acct2;
         BlankNamedAccountList.add(blankNamedAccount);
         
         
         
         UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(listAccount,accmMap);
         UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation2=new UtilDTNStampingAndTeamMemberCreation(BlankNamedAccountList,accmMap);
       
     }*/
     
     
     
     static testMethod void accountWithCorrectzip2(){
        setup();
        system.debug(loggingLevel.Error,'-----taa------::'+[Select id,Default_Account_Custodian__c,IsTriggerOff__c from AccountAutomationSetting__c].Default_Account_Custodian__c);
        system.debug(logginglevel.Error,'-------c------::'+UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c);
        system.debug(loggingLevel.Error,'------cu-----::'+[Select id,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c]);
        Account acct1 = new Account(Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
       
        insert acct1;
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAcct1' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        system.debug('account TEAM==>'+[Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]);
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        
        Test.startTest();
        acct1.billingPostalCode = '';
        update acct1;
        Test.stopTest();
        
    }
    
    static testMethod void deleteAccount3(){
        setup();
        RecordType rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1];
        
        Account newValue4 = new Account(Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue4;
        
        Account newValue5 = new Account(Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue5;
        
        Account newValue6 = new Account(Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue6;
        
        //Account newValue9 = new Account(Sic = '45634',Named_Account_Type__c= 'Service Source',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
      //  insert newValue9;
        
        Strategic_Account_RoleDTN__c StratAcc = new Strategic_Account_RoleDTN__c(Account__c = newValue6.id,DTN__c = '44456');
     insert StratAcc;
     
     Account newValue7 = new Account(Sic = '34566',Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue7;
         
        National_Account_Management__c nationAcc = new National_Account_Management__c(DTN__c = '12345',Account__c = newValue7.id);
        insert nationAcc;
         
        Account newValue8 = new Account(Named_Account_Type__c= 'Corporate National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue8;
         
        Corporate_National_Role_DTN__c CorporateAcc = new Corporate_National_Role_DTN__c(DTN__c = '12343',Account__c = newValue8.id);
    insert CorporateAcc;
     
        List<Account> accLst = new List<Account>();
        accLst.add(newValue4);
        accLst.add(newValue5);
        accLst.add(newValue6);
        accLst.add(newValue7);
        accLst.add(newValue8);
        
       
        
        UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(accLst,null);
      //  utilDTNStampingAndTeamMemberCreation.taaCusFedSet =null;
        utilDTNStampingAndTeamMemberCreation.assignDTNToDTNFieldsOnAccount(accLst,null);
      
     
    }
  
  static testMethod void deleteAccount4(){
    setup();
    
    RecordType rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1];
    
    Account newValue7 = new Account(Sic = '3456',Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue7;
        
        Account newValue9 = new Account(Sic = '4563',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue9;
        
        Account newValue11 = new Account(Sic = '4563',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Name='myAcct1', billingPostalCode='2223',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue11;
        
        List<Account> accLst = new List<Account>();
        accLst.add(newValue7);
        accLst.add(newValue9);
    
    
    Market_Segment_Mapping__c marketSegmentObj = new Market_Segment_Mapping__c(name='2',Segment__c = 'Accounting Firms',SIC_Code__c = '4163');
        insert marketSegmentObj;
    
    UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(accLst,null);
    utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue7,newValue9);
      utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue7,null);
      utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue7,newValue11);
      
      Account newValue10 = new Account(Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='All',Named_Account__c=false);
        insert newValue10;
        
      utilDTNStampingAndTeamMemberCreation.getAssignmentMatrix(newValue9);
    
      
  }
  
    static testMethod void deleteAccount5(){ 
      setup();
    
    RecordType rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1];
    
        Account newValue12 = new Account(Sic = '34566',Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='677',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue12;
        
        List<Account> accLst = new List<Account>();
        accLst.add(newValue12);
       
        
        UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(accLst,null);
      utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue12,null);
      Account newValue14 = new Account(Sic = '45634',Named_Account_Type__c= '',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Named_Account__c=false);
        insert newValue14;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue14,newValue12);
        
        Account newValue13 = new Account(Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue13;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue13,newValue12);
        
        /*Account newValue15 = new Account(Named_Account_Type__c ='Service Source',Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue15;
        
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue15,newValue12);
        
        Account newValue16 = new Account(Named_Account_Type__c ='National',Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue16;
        
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue16,newValue12);
        
        /*newValue13.Named_Account__c = true;
        update newValue13;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue13,newValue7);*/
    }
    
    
        static testMethod void deleteAccount9(){ 
      setup();
    
    RecordType rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1];
    
        Account newValue12 = new Account(Sic = '34566',Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='677',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue12;
        
        List<Account> accLst = new List<Account>();
        accLst.add(newValue12);
       
        
        UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(accLst,null);
      //utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue12,null);
     /* Account newValue14 = new Account(Sic = '45634',Named_Account_Type__c= '',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Named_Account__c=false);
        insert newValue14;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue14,newValue12);
        
        Account newValue13 = new Account(Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue13;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue13,newValue12);*/
        
        Account newValue15 = new Account(Named_Account_Type__c ='Service Source',Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue15;
        
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue15,newValue12);
        
        Account newValue16 = new Account(Named_Account_Type__c ='National',Sic = '45634',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='', Market_Sub_Segment__c='',Named_Account__c=true);
        insert newValue16;
        
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue16,newValue12);
        
        /*newValue13.Named_Account__c = true;
        update newValue13;
        utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue13,newValue7);*/
    }
    static testMethod void deleteAccount6(){
      List<Account> listAccount=new List<Account>();
         map<Id,Account>accmMap = new map<Id,Account>();
         set<String> dtnList=new set<String>();
     
         RecordType rtypes = [Select Name, Id From RecordType 
         where sObjectType='Account' and isActive=true limit 1];
      
         User testUser1 = TestDataFactory.newUser('abcgj',28);
         //User testUser1 =[SELECT Name,DTN__c FROM User where UserRoleId In(Select Id from UserRole where Name='Sales Consultant - AISR') and IsActive=true limit 1];
      
         Account acct = new Account(NAM_SAM_CNAM__c = '39456',Name='myAcct1',billingPostalCode='55555',Exclude_Account_Automation__c=false,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='Service Source',
         Service_Source__c=testUser1.DTN__c);
         insert acct;
         
         Account acct1 = new Account(NAM_SAM_CNAM__c = '39456',Name='myAcct1',billingPostalCode='55555',Exclude_Account_Automation__c=false,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='National',
         Service_Source__c=testUser1.DTN__c);
         insert acct1;
         
         accmMap.put(acct.Id,acct);
      
         Account acct2 = new Account(NAM_SAM_CNAM__c = '36456',billingPostalCode='66666',Market_Segment__c='Accounting Firms',Service_Source__c='',Named_Account__c=false, 
         Market_Sub_Segment__c='5-9 Total Employees',Named_Account_Type__c='Service Source', Id=acct.id,RecordTypeId=rtypes.Id);
         update acct2;
         
         
         Account acctNamedAccount = new Account(NAM_SAM_CNAM__c = '23456',Name='myAcct2',billingPostalCode='55555',Exclude_Account_Automation__c=true,Inactive__c=false,RecordTypeId=rtypes.Id,
         Market_Segment__c='Banks and Financial Institutions', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true,Named_Account_Type__c='Service Source',
         Service_Source__c='2112');
         insert acctNamedAccount ;
      
         listAccount.add(acct2);
         listAccount.add(acct1);
         
         dtnList.add(acct.Service_Source__c);
         dtnList.add(acct2.Service_Source__c);
            
         AccountTeamMember atm= new AccountTeamMember(AccountId=acct.Id, UserId=testUser1.Id,TeamMemberRole='QP Specialist');
         insert atm;
      
         map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
         map<Id,map<String,AccountTeamMember>> availabelATMs   = new map<Id,map<String,AccountTeamMember>>(); 
         for(AccountTeamMember atm2: [Select id,user.Name,user.DTN__c,TeamMemberRole,accountid from AccountTeamMember where accountid=:accmMap.keySet()]){
            atmMap.put(atm2.user.DTN__c,atm2);
            availabelATMs.put(atm2.accountid,new map<String,AccountTeamMember>{atm2.User.DTN__c => atm2});
          }
      
      Account newValue1 = new Account(Named_Account_Type__c = 'Service Source',Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='55555',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue1;
        
        accmMap.put(newValue1.Id,newValue1);
        
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting('abcgj');
        
      UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(listAccount,accmMap);
    //utilDTNStampingAndTeamMemberCreation.taaCusFedSet = null;
      list<Account> accLst = new list<Account>();
        accLst.add(newValue1);
      utilDTNStampingAndTeamMemberCreation.assignAccountTeamAndSharingRules(accLst,null);
      utilDTNStampingAndTeamMemberCreation.assignAccountTeamAndSharingRules(accLst,accmMap);
    }
    
    static testMethod void deleteAccount7(){
    setup();
    
    RecordType rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 1];
    
    Account newValue7 = new Account(Sic = '34566',Named_Account_Type__c= 'National',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '23455',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='',Market_Segment__c='Accounting Firms', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=true);
        insert newValue7;
        
        Account newValue9 = new Account(Sic = '456346',Name='myAcct1', billingPostalCode='22234',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue9;
        
        Account newValue11 = new Account(Sic = '4563',Named_Account_Type__c= '',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue11;
        
        List<Account> accLst = new List<Account>();
        accLst.add(newValue7);
        accLst.add(newValue9);
        
        Market_Segment_Mapping__c marketSegmentObj = new Market_Segment_Mapping__c(name = '1',Segment__c = 'Accounting Firms',SIC_Code__c = '4583');
        insert marketSegmentObj;
        
    UtilDTNStampingAndTeamMemberCreation utilDTNStampingAndTeamMemberCreation=new UtilDTNStampingAndTeamMemberCreation(accLst,null);
    utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue7,newValue9);
    
    Account newValue12 = new Account(Sic = '45634',Named_Account_Type__c= '',Inactive__c = false,Exclude_Account_Automation__c = false,RecordTypeId=rtypes.Id,Service_Source__c = '',SW_ASR__c = '23444',R_L_FSR__c = '13578',R_L_ASR__c = '12345',Pro_SW_FSR__c = '23455',NAM_SAM_CNAM__c = '33456' ,ISR_Indirect__c = '12222',Inside_Sales__c = 'test', Corp_Indirect__c = '233333',Corp_Direct__c= '222222',Name='myAcct1', billingPostalCode='2223',Market_Segment__c='Federal Government', Market_Sub_Segment__c='5-9 Total Employees',Named_Account__c=false);
        insert newValue12;
        
    utilDTNStampingAndTeamMemberCreation.checkChangesOnAccount(newValue7,newValue12);
    
  }
    
}