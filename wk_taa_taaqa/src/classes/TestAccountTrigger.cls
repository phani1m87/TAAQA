/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
//@isTest(SeeAllData = false)
public class TestAccountTrigger {/*
    static void setup(){
        list<ZipCodeDTN__c>zipCodeDTNlist = new list<ZipCodeDTN__c>();
        list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
        
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('55555', '2111', '2112'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('66666', '2113', '2114'));
        zipCodeDTNlist.add(TestDataFactory.zipCodeDtn('wrongDTN', '2220', '2221'));
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
        
        //Assignment Matrixes
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Schools and Libraries','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Banks and Financial Institutions','All'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Corp Nat','Corp','Corporate National','CAM - Corporate Account Manager'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','National','National','NAM - National Accounts'));
        assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','Strategic','Strategic','SAM - Strategic Account Manager'));
        
        //Users
        User u1 = TestDataFactory.newUser('2111',1);
        User u2 = TestDataFactory.newUser('2112',2);
        User u3 = TestDataFactory.newUser('2113',3);
        User u4 = TestDataFactory.newUser('2114',4);
        User u5 = TestDataFactory.newUser('2115',5);
        User uSAM = TestDataFactory.newUser('2116',6);
        User uSA = TestDataFactory.newUser('2117',7);
        User uCNAM = TestDataFactory.newUser('2118',8);
        User uNAM = TestDataFactory.newUser('2119',9);
        
        //Custom Settings
        String username = [Select id,Name,DTN__c from user where DTN__c='2115'].Name;
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        
        //Named Accounts
        Strategic_Account_RoleDTN__c sam = TestDataFactory.newSAR('DemoSAM','2116',uSA,uSAM);
        Corporate_National_Role_DTN__c cnr = TestDataFactory.newCNR('DemoCNR', uCNAM, '2118');
        National_Account_Management__c nam = TestDataFactory.newNAM('DemoNAM', '2119', uNAM);
        ServiceSource_Role_DTN__c ss= TestDataFactory.newSS('DemoSS','2117',uSA);
        
    }
    static testMethod void CreateAccountTeamMembersTest() {
        setup();
        list<Account> toInsertAccounts = new list<Account>();
        for(Integer i=0 ; i<5000 ;i++){
            Account a = new Account();
            a.Name = 'TestAccount'+ '-'+i;
            a.BillingPostalCode = 'wrongDTN';
            a.Market_Segment__c = 'Accounting Firms';
            a.Market_Sub_Segment__c = '5-9 Total Employees';
            
            toInsertAccounts.add(a);
        }
        insert toInsertAccounts;
    }
    */
}