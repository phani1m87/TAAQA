/**
 * This class contains unit tests for validating the behavior of
 *Apex class : MassUpdateAccountBatchController, MassUpdateAccountBatch
 */
@isTest(SeeAllData=false)
private class TestMassUpdateAccountBatch {
    /*
    @method : setup
    @description : to setup the require data for other test methods
    */
    static void setup(){
        Market_Segment_Mapping__c msm = new Market_Segment_Mapping__c(Name='Test0092',Segment__c='Accounting Firms',SIC_Code__c='0092');
        insert msm;
        Market_Segment_Rules__c msr =new Market_Segment_Rules__c(Name='Test1',Segment__c='Accounting Firms',IsSubSegmentBasedOnAnnualRevenue__c=True, IsSubSegmentBasedOnEmployeeCount__c=True);
        insert msr;
        Market_Sub_Segment_Mapping__c mss =new Market_Sub_Segment_Mapping__c(Name='Test1',Segment__c='Accounting Firms',Sub_Segment__c='5-9 Total Employees',GTE_AnnualRevenue__c=null,LTE_AnnualRevenue__c=0,GTE_NumberOfEmployees__c=null,LTE_NumberOfEmployees__c=0);
        insert mss;
        User u1 = TestDataFactory.newUser('222a',1);
        User u2 = TestDataFactory.newUser('222b',2);
        User u3 = TestDataFactory.newUser('222c',3);
        User u4 = TestDataFactory.newUser('222d',4);
        User u5 = TestDataFactory.newUser('222e',5);
        User uSAM = TestDataFactory.newUser('222f',6);
        User uSA = TestDataFactory.newUser('222g',7);
        User uCNAM = TestDataFactory.newUser('222h',8);
        User uNAM = TestDataFactory.newUser('222i',9);
        system.debug(loggingLevel.Error,'----u5----::'+[Select id,Name,DTN__c from user where DTN__c='222e']);
        list<ZipCodeDTN__c>zipCodeDTNlist = new list<ZipCodeDTN__c>();
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('55555', '222a', '222b'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('66666', '222c', '222d'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('wrongDTN', '2220', '222a'));
        /*zipCodeDTN with having values for all fields*/
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('77777', '2220', '2221');
        z.ASR_Indirect_Corp_Software__c='222a';
        z.Corp_Direct__c = '222b';
        z.Corp_Indirect__c = '222c';
        z.ISR_Indirect__c = '222d';
        z.NAM_SAM_CNAM__c = '222e';
        z.Pro_SW_FSR__c = '222f';
        z.Pro_SW_ISR__c = '222g';
        z.R_L_ASR__c = '222h';
        z.R_L_FSR__c = '222i';
        z.Service_Source__c = '221j';
        z.SW_ASR__c = '222a';
        update z;
        zipCodeDTNlist.add(z);
        
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        String username = [Select id,Name,DTN__c from user where DTN__c='222e'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','222f',uSA,uSAM);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', uCNAM, '222h');
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '222i', uNAM);
    }
    /*
    @method: setSegment
    @description : set the segment, sub-segment as well dtns and team members on the basis of sic code.
    */
    static testMethod void setSegment() {
        Account myAccount = new Account(Name='myAccount',Market_Segment__c='Accounting Firms',Market_Sub_Segment__c='5-9 Total Employees'/*Sic = '0092'*/, IsMassUpdated__c=true, billingPostalCode='55555', AnnualRevenue=0, NumberOfEmployees=0);
        insert myAccount; 
        setup();
        Test.startTest();
            MassUpdateAccountBatch job = new MassUpdateAccountBatch();
            Database.executeBatch(job);
        Test.stopTest();
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c,IsMassUpdated__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'>>>>>>>>>>>>>>>>-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        system.assertEquals(false, a.IsMassUpdated__c);
        system.assertEquals('Accounting Firms', a.Market_Segment__c);
        system.assertEquals('5-9 Total Employees', a.Market_Sub_Segment__c);
        system.assertEquals('222a',a.AISR__c);
        system.assertEquals('222b',a.QP__c);
       // system.assertEquals(2,atmMap.size());
        //system.assertEquals('Testing1',atmMap.get('222a').user.Name);
       // system.assertEquals('Testing2',atmMap.get('222b').user.Name);
    }
    
    /*
    @method: updateAccountWithZipCodeDTNChange
    @description: update the account with respect to change of zipcodeDTN tab
    */
    static testMethod void updateAccountWithZipCodeDTNChange(){
        setup();
        Account myAccount = new Account(Name='myAccount', Sic = '0092', billingPostalCode='55555', AnnualRevenue=0, NumberOfEmployees=0, Inactive__c=false);
        insert myAccount;
        
        ZipCodeDTN__c zipCode = [Select id,Name,AISR__c,QP__c,IsUpdated__c from ZipCodeDTN__c where Name='55555' limit 1];
        zipCode.AISR__c = '222c';
        zipCode.QP__c = '222d';
        zipCode.IsUpdated__c = true;
        update zipCode;
        
        Account a =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c,Inactive__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+a);
        
        map<String,AccountTeamMember>atmMap = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:a.id]){
            atmMap.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        system.assertEquals('Accounting Firms', a.Market_Segment__c);
        system.assertEquals('5-9 Total Employees', a.Market_Sub_Segment__c);
        system.assertEquals('222a',a.AISR__c);
        system.assertEquals('222b',a.QP__c);
        //system.assertEquals(2,atmMap.size());
        system.assertEquals('Testing1',atmMap.get('222a').user.Name);
        system.assertEquals('Testing2',atmMap.get('222b').user.Name);
        
        Test.startTest();
            MassUpdateAccountBatch job = new MassUpdateAccountBatch();
            Database.executeBatch(job);
        Test.stopTest();
        
        Account ab =[Select id,Name,AISR__c,QP__c,Market_Segment__c,Market_Sub_Segment__c,DTN_Makeup__c from Account where name='myAccount' limit 1];
        system.debug(loggingLevel.Error,'-----------::'+ab);
        
        map<String,AccountTeamMember>atmMapa = new map<String,AccountTeamMember>();
        for(AccountTeamMember atm: [Select id,user.Name,user.DTN__c,TeamMemberRole from AccountTeamMember where accountid=:ab.id]){
            atmMapa.put(atm.user.DTN__c,atm);
        }
        system.debug(loggingLevel.Error,'-----atmMap------::'+atmMap);
        system.assertEquals('222c',ab.AISR__c);
        system.assertEquals('222d',ab.QP__c);
        //system.assertEquals(2,atmMapa.size());
        system.assertEquals('Testing3',atmMapa.get('222c').user.Name);
        system.assertEquals('Testing4',atmMapa.get('222d').user.Name);
        
        //verify the change on zipCodeDTN
        ZipCodeDTN__c zipCodeAfter = [Select id,Name,AISR__c,QP__c,IsUpdated__c from ZipCodeDTN__c where Name='55555' limit 1];
        system.assertEquals(false,zipCodeAfter.IsUpdated__c);
    }
}