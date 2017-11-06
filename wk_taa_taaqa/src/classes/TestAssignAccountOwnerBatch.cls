/*
 * Test class for AssignAccountOwnerBatch.
 * Account Owner Fields Assignment: SMS-858  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 07/05/2017 PIYUSH            1.0          Initial draft
 * ------------------------------------------------------------------------- */
@isTest(seeAllData=false)
public class TestAssignAccountOwnerBatch {
	public static User uSFS;
	public static User u1;
	public static User u2;
	public static User u3;
	public static User u4;
	public static User u5;
	public static User uSAM;
	public static User uSA;
	public static User uCNAM;
	public static User uNAM;
	static void setup(){
        Market_Segment_Mapping__c msm = new Market_Segment_Mapping__c(Name='Test0092',Segment__c='Accounting Firms',SIC_Code__c='0092');
        insert msm;
        Market_Segment_Rules__c msr =new Market_Segment_Rules__c(Name='Test1',Segment__c='Accounting Firms',IsSubSegmentBasedOnAnnualRevenue__c=True, IsSubSegmentBasedOnEmployeeCount__c=True);
        insert msr;
        Market_Sub_Segment_Mapping__c mss =new Market_Sub_Segment_Mapping__c(Name='Test1',Segment__c='Accounting Firms',Sub_Segment__c='5-9 Total Employees',GTE_AnnualRevenue__c=null,LTE_AnnualRevenue__c=0,GTE_NumberOfEmployees__c=null,LTE_NumberOfEmployees__c=0);
        insert mss;
        List<account_owner_mapping__c> OwnerMappingList = new List<account_owner_mapping__c>();
        account_owner_mapping__c aom1 = new account_owner_mapping__c(Name = 'Indirect Owner_1',DisplayOrder__c=1,Owner__c='Indirect_Owner__c',RoleField__c='RSC - Corp Software Indirect');
        account_owner_mapping__c aom2 = new account_owner_mapping__c(Name = 'Indirect Owner_2',DisplayOrder__c=2,Owner__c='Indirect_Owner__c',RoleField__c='ISC - Corp Software Indirect');
        account_owner_mapping__c aom3 = new account_owner_mapping__c(Name = 'R&L Ret Owner_1',DisplayOrder__c=1,Owner__c='R_L_Retention_Owner__c',RoleField__c='RC - Research & Learning');
        account_owner_mapping__c aom4 = new account_owner_mapping__c(Name = 'R&L Ret Owner_2',DisplayOrder__c=2,Owner__c='R_L_Retention_Owner__c',RoleField__c='RC - R&L ServiceSource');
        account_owner_mapping__c aom5 = new account_owner_mapping__c(Name = 'Software Owner_1',DisplayOrder__c=1,Owner__c='software_owner__c',RoleField__c='National Solution Consultant');
        account_owner_mapping__c aom6 = new account_owner_mapping__c(Name = 'Software Owner_5',DisplayOrder__c=5,Owner__c='software_owner__c',RoleField__c='RSC - Professional Software');
        account_owner_mapping__c aom7 = new account_owner_mapping__c(Name = 'R&L Owner_1',DisplayOrder__c=1,Owner__c='r_l_owner__c',RoleField__c='National Solution Consultant');
        account_owner_mapping__c aom8 = new account_owner_mapping__c(Name = 'R&L Owner_5',DisplayOrder__c=5,Owner__c='r_l_owner__c',RoleField__c='RSC - Research & Learning');
        account_owner_mapping__c aom9 = new account_owner_mapping__c(Name = 'RC Small Firm_1',DisplayOrder__c=1,Owner__c='RC_Small_Firm__c',RoleField__c='RC - Small Firm Software');
        OwnerMappingList.add(aom1);
        OwnerMappingList.add(aom2);
        OwnerMappingList.add(aom3);
        OwnerMappingList.add(aom4);
        OwnerMappingList.add(aom5);
        OwnerMappingList.add(aom6);
        OwnerMappingList.add(aom7);
        OwnerMappingList.add(aom8);
        OwnerMappingList.add(aom9);
        insert OwnerMappingList;
        u1 = TestDataFactory.newUser('222a',1);
        u2 = TestDataFactory.newUser('222b',2);
        u3 = TestDataFactory.newUser('222c',3);
        u4 = TestDataFactory.newUser('222d',4);
        u5 = TestDataFactory.newUser('222e',5);
        uSAM = TestDataFactory.newUser('222f',6);
        uSA = TestDataFactory.newUser('222g',7);
        uCNAM = TestDataFactory.newUser('222h',8);
        uNAM = TestDataFactory.newUser('222i',9);
        uSFS = TestDataFactory.newUser('222x',10);
        system.debug(loggingLevel.Error,'----u5----::'+[Select id,Name,DTN__c from user where DTN__c='222e']);
        list<ZipCodeDTN__c>zipCodeDTNlist = new list<ZipCodeDTN__c>();
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('55555', '222a', '222b'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('66666', '222c', '222d'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('wrongDTN', '2220', '222a'));
        ZipCodeDTN__c z = TestDataFactory.zipCodeDtn('77777', '2220', '2221');
        z.ASR_Indirect_Corp_Software__c='222a';
        z.Corp_Direct__c = '222b';
        z.Corp_Indirect__c = '222c';
        z.ISR_Indirect__c = '222d';
        z.NAM_SAM_CNAM__c= '222e';
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
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','222f',uSA,uSAM);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', uCNAM, '222h'); 
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '222i', uNAM);
    }
	static testMethod void runPositiveTest() {
		setup();
		List<Account> acctList = new List<Account> ();
		for(integer i=0;i<5;i++) {
			Account myAccount = new Account(Name='myAccount'+i,Market_Segment__c='Accounting Firms',
        	Market_Sub_Segment__c='5-9 Total Employees', IsMassUpdated__c=true, billingPostalCode='77777', AnnualRevenue=0, NumberOfEmployees=0);
			acctList.add(myAccount);
		}
        insert acctList; 
        AccountTeamMember atm = new AccountTeamMember(AccountId=acctList.get(0).Id,TeamMemberRole='RC - Small Firm Software', UserId=uSFS.Id);
        insert atm; 
		//System.debug('@@@ '+myAccount.software_owner__r.Id+' '+myAccount.RC_Small_Firm__c+' '+myAccount.R_L_Retention_Owner__c+' '+myAccount.r_l_owner__c+' '+myAccount.Indirect_Owner__c);
        Test.startTest();
        System.debug('### ' + [SELECT Count(Id) FROM AccountTeamMember]);
        AssignAccountOwnerBatch actBatch = new AssignAccountOwnerBatch();
		Database.executeBatch(actBatch,50);
        //System.debug('@@@ '+myAccount.software_owner__r.Id+' '+myAccount.RC_Small_Firm__c+' '+myAccount.R_L_Retention_Owner__c+' '+myAccount.r_l_owner__c+' '+myAccount.Indirect_Owner__c);
        Test.stopTest();
        //System.assertEquals(myAccount.software_owner__c,uCNAM.Id);
	}
}