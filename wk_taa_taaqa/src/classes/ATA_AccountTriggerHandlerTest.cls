/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/27/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
@isTest(seeAllData = false)
private class ATA_AccountTriggerHandlerTest 
{
    // *** test class for ATA_AccountTriggerHandler
    
    /**** data preparation ****/    
    @testSetup static void testDataFactory() 
    {
        // create test account
        Account objAccount = ATA_TestDataFactory.create_Account();
        insert objAccount;
        
        // create ATA custom setting        
        ATA_TestDataFactory.create_ATACustomSetting();
        
        // ATA Rules
        ATA_TestDataFactory.create_ATARule('TAA_Software_New_Sales__c');
        ATA_TestDataFactory.create_ATARule('R_L_New_Sales__c');
        ATA_TestDataFactory.create_ATARule('R_L_Retention_Owner_ATA__c');
        
        // **** add rest of the driver fields into ATA Rule
        
        // ATA Assignment Types
        ATA_TestDataFactory.create_ATAAssignmentType('ATA1', 'ATA', 'TAA_Software_New_Sales', 'TAA_Software_New_Sales__c', 'National Accounts');
        ATA_TestDataFactory.create_ATAAssignmentType('ATA2', 'ATA', 'R_L_New_Sales', 'R_L_New_Sales__c', 'R&L Field Sales');
        ATA_TestDataFactory.create_ATAAssignmentType('ATA3', 'ATA', 'R_L_Retention_Owner_ATA', 'R_L_Retention_Owner_ATA__c', 'R&L Retention');
        
        // **** add rest of the driver fields into ATA Assignment Type
        
        // ATA Role Assignments
        ATA_TestDataFactory.create_ATARoleAssignment('ATA1', 'Named / National', 'National Solution Consultant', 'Name Match');
        ATA_TestDataFactory.create_ATARoleAssignment('ATA2', 'Segment SalesOwnership', 'RSC - R&L Field', 'Geographic PostalCode');
        ATA_TestDataFactory.create_ATARoleAssignment('ATA3', 'Segment SalesOwnership', 'RC - R&L Retention', 'Geographic PostalCode');
        ATA_TestDataFactory.create_ATARoleAssignment('ATA3', 'Segment SalesOwnership', 'RSC - Small Market Field', 'Geographic PostalCode');
        
        // **** add rest of the roles
        
        //Create ATA_Role_to_DTN_Field_Mapping__c Records
        List<ATA_Role_to_DTN_Field_Mapping__c> atListToinsert = new List<ATA_Role_to_DTN_Field_Mapping__c>();
            ATA_Role_to_DTN_Field_Mapping__c ataRoleToDTNMapping1 = ATA_TestDataFactory.createATARoleToDTNFM('RSC - R&L Field','ATA_R_L_New_Sales_DTN__c','1');
            atListToinsert.add(ataRoleToDTNMapping1);
            ATA_Role_to_DTN_Field_Mapping__c ataRoleToDTNMapping2 = ATA_TestDataFactory.createATARoleToDTNFM('RC - R&L Retention',' ATA_R_L_Retention_Owner_DTN__c','2');
            atListToinsert.add(ataRoleToDTNMapping2);
        insert atListToinsert;
    }
    
    /**** Non Geo Assignment Tests ****/
       
    // non geo assignment: test # 1 
    static testmethod void testNongeographicAssignment_Positive()
    {
        Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
        User u = ATA_TestDataFactory.create_NewUser('ATA46',22);
        Test.startTest();
        ATA_TestDataFactory.create_ATANongeographicAssignment('AccountTeam', 'Name', objAccount.Name, 'National Solution Consultant', 'ATA46', 'Named / National');
        
        objAccount.Named_Account_Type__c = 'National';
        objAccount.Named_Account__c = true;
        
        update objAccount;
        System.debug('==ACT M=='+[Select Id,AccountId, TeamMemberRole, User.Id from AccountTeamMember where AccountId = : objAccount.id]);
        Test.stopTest();    
    }
    
    // non geo assignment: test # 2 
    static testmethod void testNongeographicAssignment_NoActiveUser()
    {
        Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        Test.startTest();
        ATA_TestDataFactory.create_ATANongeographicAssignment('AccountTeam', 'Name', objAccount.Name, 'National Solution Consultant', '990A', 'Named / National');
        
        objAccount.Named_Account_Type__c = 'National';
        objAccount.Named_Account__c = true;
        
        update objAccount;
        Test.stopTest();    
    }
    
    // non geo assignment: test # 3 
    static testmethod void testNongeographicAssignment_MissingNongeoAssignment()
    {
        Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        Test.startTest();
        objAccount.Named_Account_Type__c = 'National';
        objAccount.Named_Account__c = true;
        
        update objAccount;  
        Test.stopTest();
    }
    
    // non geo assignment: test # 4 
    static testmethod void testNongeographicAssignment_NonMandatoryRole()
    {
        Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        Test.startTest();
        AccountAutomationSetting__c cust = AccountAutomationSetting__c.getOrgDefaults();
        cust.Terminate_Account_Team_Role_Names__c = '["Strategic Solution Consultant"]';
        update cust;
        
        objAccount.Named_Account_Type__c = 'National';
        objAccount.Named_Account__c = true;
        
        update objAccount;
        Test.stopTest();
    }
    
    /**** Geo Assignment Tests ****/
    
    // geo assignment: test # 1 
    static testmethod void testGeographicAssignment_Positive()
    {
        Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
        User u = ATA_TestDataFactory.create_NewUser('ATA46',22);
        User u1 = ATA_TestDataFactory.create_NewUser('ATA99',25);
        
        Test.startTest();
        ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', 'ATA46');
        ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - R&L Field', 'ATA99');
        
        objAccount.Name = 'ATA_TEST_ACCOUNT_1';
        objAccount.Named_Account_Type__c = '';
        objAccount.Named_Account__c = false;
        
        update objAccount;
         
        Test.stopTest();
    }
    
    
    static testmethod void testGeographicAssignment_PositiveScenario1(){        
        Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
        
        Test.startTest();
            User u = ATA_TestDataFactory.create_NewUser('ATA46',22);
            User u1 = ATA_TestDataFactory.create_NewUser('ATA99',23);
            User u2 = ATA_TestDataFactory.create_NewUser('ATA67',25);
            ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', 'ATA46');
            ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - R&L Field', 'ATA99');        
            ATA_Geographic_Assignment__c objGeoAssignment  = ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - Small Market Field', 'ATA67');
            AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'RC - R&L Retention', UserId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
            insert objATM;
            
            u2.Custodial_Rep__c = u1.Id;
            update u2;
            
            objAccount.Name = 'ATA_TEST_ACCOUNT_2';
            objAccount.Named_Account_Type__c = '';
            objAccount.Named_Account__c = false;            
            update objAccount;  
        Test.stopTest();        
    }
    
    static testmethod void testGeographicAssignment_PositiveScenario2(){        
        Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
        
        Test.startTest();
            User u = ATA_TestDataFactory.create_NewUser('ATA61',22);
            User u1 = ATA_TestDataFactory.create_NewUser('ATA99',23);
            User u2 = ATA_TestDataFactory.create_NewUser('ATA67',25);
            ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', 'ATA99');
            ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - R&L Field', 'ATA61');        
            ATA_Geographic_Assignment__c objGeoAssignment  = ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - Small Market Field', 'ATA67');
            AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'RC - R&L Retention', UserId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
            insert objATM;
            objAccount.Name = 'ATA_TEST_ACCOUNT_2';
            objAccount.Named_Account_Type__c = '';
            objAccount.Named_Account__c = false;
            update objAccount;
        Test.stopTest();        
    }
    
    static testmethod void testGeographicAssignment_PositiveScenario3(){        
        Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
        
        Test.startTest();
            User u = ATA_TestDataFactory.create_NewUser('ATA99',23);
            User u2 = ATA_TestDataFactory.create_NewUser('ATA67',25);
            ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', 'ATA67');
            
            AccountTeamMember objATM = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'RC - R&L Retention', UserId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
            insert objATM;
            
            User u1 = ATA_TestDataFactory.create_NewUser('ATA36',22);
            AccountTeamMember objATM1 = new AccountTeamMember(AccountId = objAccount.Id, TeamMemberRole = 'RSC - R&L Field', UserId = u1.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' );
            insert objATM1;
            
            objAccount.Name = 'ATA_TEST_ACCOUNT_2';
            objAccount.Named_Account_Type__c = '';
            objAccount.Named_Account__c = false;
            
            update objAccount;
        Test.stopTest();        
    }
    
    /**** ATA Other ****/
    
    // ATA Other : test # 1 
    static testmethod void testATA_InvalidFieldRule()
    {
        Test.startTest();
        ATA_TestDataFactory.create_ATARule('TestField__c');
        
        Account objAccount = ATA_TestDataFactory.create_Account();
        insert objAccount;
        Test.stopTest();
    }
    
    // ATA Other: test # 2 
    static testmethod void testATA_WebserviceMethod()
    {
        Test.startTest();
              Account objAccount = [SELECT Id, Name,BillingPostalCode FROM Account LIMIT 1];
              ATA_AccountTeamHandler.reCreateAccountTeamInteractive(String.valueOf(objAccount.Id));
        Test.stopTest();
    }
    
    // geo assignment: test # 4 
    static testmethod void testGeographicAssignment_NonMandatoryRole()
    {
        Account objAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        Test.startTest();
        
        Test.stopTest();
    }
    
    //This method is used to test ATA_ManageBatchAccountTeamUpdates class and its corresponding batch class
    static testmethod void testgeographicPreprocess_MassUpdate(){
          //Query Account object BillingPostalCode
          Account objAccount = [SELECT Id, Name, BillingPostalCode FROM Account LIMIT 1];
          User u = ATA_TestDataFactory.create_NewUser('ATA99',23);
          User u2 = ATA_TestDataFactory.create_NewUser('ATA67',25);
          
          //Create multiple Geographic assigment instances
          ATA_Geographic_Assignment__c objGeoAssignment1 = ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RC - R&L Retention', 'ATA99');
          ATA_Geographic_Assignment__c objGeoAssignment2 = ATA_TestDataFactory.create_ATAGeographicAssignment(objAccount.BillingPostalCode.subString(0,5), 'RSC - R&L Field', 'ATA67');
          
          //Make some changes in Geographic assignments and set the IsUpdated__c flag to true so that we can fetch the record //for batch processing
          List<ATA_Geographic_Assignment__c> objGeoAssignmentListToUpdate = new List<ATA_Geographic_Assignment__c>();
          objGeoAssignment1.Role_Name__c = 'RSC - Small Market Field';
          objGeoAssignment1.IsUpdated__c = true;
          objGeoAssignment2.Role_Name__c = 'RSC - Microsoft';
          objGeoAssignment2.IsUpdated__c = true;
          objGeoAssignmentListToUpdate.add(objGeoAssignment1);
          objGeoAssignmentListToUpdate.add(objGeoAssignment2);
          if(objGeoAssignmentListToUpdate!=null && objGeoAssignmentListToUpdate.size()>0){
            update objGeoAssignmentListToUpdate;
          }
          
          Test.startTest();
            ATA_ManageBatchAccountTeamUpdates.geographicPreprocess_MassUpdate(true);
          Test.stopTest();
    }
    
    //This method is used to test QueryServiceClass
    static testmethod void testQueryService(){
          Test.startTest();
            set<String>setDirtyZipcodeDTN = new Set<String>();
            setDirtyZipcodeDTN.add('7767');
            QueryServiceClass.dirtyDTNAccounts(setDirtyZipcodeDTN);
            
            QueryServiceClass.getAccountXReferenceHistory('2013-10-11T16:36:06.000+0000');
            QueryServiceClass.getAccountXReferenceHistoryCount('2013-10-11T16:36:06.000+0000');
            QueryServiceClass.getReplicationMonitorLogQuery();
          Test.stopTest();
    }
    
    static testmethod void testCoverOwnerDefaultSneario1(){
        List<AccountAutomationSetting__c> accountAutomation = [Select Id,Default_Account_UserId__c from AccountAutomationSetting__c limit 1];
        
        User u = ATA_TestDataFactory.create_NewUser('ATA61',22);
        accountAutomation[0].Default_Account_UserId__c = u.Id;
        update accountAutomation;
        
        // create test account
        Account objAccount = ATA_TestDataFactory.create_Account();
        insert objAccount;          
    }
    
    static testmethod void testCoverOwnerDefaultSneario2(){
        List<AccountAutomationSetting__c> accountAutomation = [Select Id,Default_Account_UserId__c from AccountAutomationSetting__c limit 1];
        
        accountAutomation[0].Default_Account_UserId__c = '005883jkfs27asj32n';
        update accountAutomation;
        
        // create test account
        Account objAccount = ATA_TestDataFactory.create_Account();
        insert objAccount;          
    }
    

}