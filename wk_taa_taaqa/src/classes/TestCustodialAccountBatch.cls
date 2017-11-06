@isTest(SeeAllData=false)
private class TestCustodialAccountBatch {
  static void setup(){
    list<Assignment_Matrix__c>assignmentMatrix = new list<Assignment_Matrix__c>();
    assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Accounting Firms','5-9 Total Employees'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixWithLessRolls('Legal Professionals','Law Firm 1-3 Attorneys'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Schools and Libraries','All'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixWithAF('Banks and Financial Institutions','All'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Corp Nat','Corp','Corporate National','CAM - Corporate Account Manager'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','National','National','NAM - National Accounts'));
    assignmentMatrix.add(TestDataFactory.assignmentMatrixForNamedAccount('Named Accounts','Strategic','Strategic','SAM - Strategic Account Manager'));
  }
  static testmethod void testnewRep(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2); 
    //User testUser3 = TestDataFactory.newUser('6666',3);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser2.Id ,TeamMemberRole='QA Specialist');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_new_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_new_Rep);
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_new_Rep__c=DTN_new_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,null,DTN_Current_Rep,DTN_new_Rep,q,dtnUsers,null,null);
    Database.executebatch(cb,200);
    test.stoptest();
    system.debug('DTN_new_Rep****'+DTN_new_Rep);
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_new_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_new_Rep);
    }
    static testmethod void testCustodialRep1(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='QP Specialist');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_Custodial_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Custodial_Rep);
    Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
    currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
  
  static testmethod void testCustodialRep2(){
   setup();
   ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
   Account a = new Account();
   a.Name= 'Test Account';
   a.RecordTypeId=prospecrAccountRecordTypeID;
   a.Market_Segment__c='Accounting Firms';
   a.Market_Sub_Segment__c='5-9 Total Employees';
   insert a;
   User testUser1 = TestDataFactory.newUser('4444',1);
   User testUser2 = TestDataFactory.newUser('5555',2);
   //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
   AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Cust-Test Role');
   insert atm;
   AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
   insert as1;
   String DTN_Current_Rep=testUser1.DTN__c;
   String DTN_Custodial_Rep=testUser2.DTN__c;
   String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
   Set<String> dtnUsers= new Set<String>();
   dtnUsers.add(DTN_Custodial_Rep);
   Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
   currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
   Custodial__c cust= new Custodial__c();
   cust.DTN_Current_Rep__c=DTN_Current_Rep;
   cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
   insert cust;
   test.starttest();
   CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
   Database.executebatch(cb,200);
   test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
  static testmethod void testCustodialRep3(){
   setup();
   ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
   Account a = new Account();
   a.Name= 'Test Account';
   a.RecordTypeId=prospecrAccountRecordTypeID;
     a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
   insert a;
   User testUser1 = TestDataFactory.newUser('4444',1);
   User testUser2 = TestDataFactory.newUser('5555',2);
   //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
   AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='CAM - Corporate Account Manager');
   insert atm;
   AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
   insert as1;
   String DTN_Current_Rep=testUser1.DTN__c;
   String DTN_Custodial_Rep=testUser2.DTN__c;
   String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
   Set<String> dtnUsers= new Set<String>();
   dtnUsers.add(DTN_Custodial_Rep);
   Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
   currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
   Custodial__c cust= new Custodial__c();
   cust.DTN_Current_Rep__c=DTN_Current_Rep;
   cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
   insert cust;
   test.starttest();
   CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
   Database.executebatch(cb,200);
   test.stoptest();
   List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C,TeamMemberRole from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
   System.assert(at.size()>0);
   System.assertequals(at[0].AccountId,a.ID);
   System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
   System.debug('Actual Team Member Role======='+at[0].TeamMemberRole);
   System.assertequals(at[0].TeamMemberRole,'C-4444-CAM - Corporate Account Manager');
 }
 static testmethod void testCustodialException(){
   setup();
   ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
   Account a = new Account();
   a.Name= 'Test Account';
   a.RecordTypeId=prospecrAccountRecordTypeID;
   a.Market_Segment__c='Accounting Firms';
   a.Market_Sub_Segment__c='5-9 Total Employees';
   insert a;
   User testUser1 = TestDataFactory.newUser('4444',1);
   User testUser2 = TestDataFactory.newUser('5555',2);
   //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
   AccountTeamMember atm= new AccountTeamMember(AccountId= a.ID,UserId=testUser1.Id ,TeamMemberRole='Test Team Member Role length greater tha');
   insert atm;
   AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id, AccountId=a.Id );
   insert as1;
   String DTN_Current_Rep=testUser1.DTN__c;
   String DTN_Custodial_Rep=testUser2.DTN__c;
   String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
   Set<String> dtnUsers= new Set<String>();
   dtnUsers.add(DTN_Custodial_Rep);
   Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
   currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
   Custodial__c cust= new Custodial__c();
   cust.DTN_Current_Rep__c=DTN_Current_Rep;
   cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
   insert cust;
   test.starttest();
   CustodialAccountBatch cb= new CustodialAccountBatch(null,currentwithCustodailReps,'3897',null,q,dtnUsers,DTN_Custodial_Rep,null);
   Database.executebatch(cb,200);
   test.stoptest();
   List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
   // System.assert(at.size()==0);
   // System.assertequals(at[0].AccountId,a.ID);
    //System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
  static testmethod void testCustodialRevertAccess(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
      a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Cust-5555-Test Role');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();    
    String DTN_new_Rep=testUser2.DTN__c;
    dtnUsers.add(DTN_new_Rep);
    Custodial__c cust1= new Custodial__c();
    cust1.DTN_Current_Rep__c=DTN_Current_Rep;
    cust1.DTN_new_Rep__c=DTN_new_Rep;
    insert cust1;
    Test.StartTest();
    CustodialAccountBatch  cb= new CustodialAccountBatch(cust1.Id,null,DTN_Current_Rep,DTN_new_Rep,q,dtnUsers,null,null);
    Database.executebatch(cb,200);
    Test.StopTest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C,TeamMemberRole from AccountTeamMember where User.DTN__C=:DTN_new_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_new_Rep);
    System.debug('Actual Team Member Role======='+at[0].TeamMemberRole);
    System.assertequals(at[0].TeamMemberRole,'Test Role');    
 } 
  static testmethod void testCustodialException2(){
   setup();
   ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
   Account a = new Account();
   a.Name= 'Test Account';
   a.RecordTypeId=prospecrAccountRecordTypeID;
     a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
   insert a;
   User testUser1 = TestDataFactory.newUser('4444',1);
   User testUser2 = TestDataFactory.newUser('5555',2);
   //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
   AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Test Team Member Role length greater tha');
   insert atm;
   AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
   insert as1;
   String DTN_Current_Rep=testUser1.DTN__c;
   String DTN_Custodial_Rep=testUser2.DTN__c;
   String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
   Set<String> dtnUsers= new Set<String>();
   dtnUsers.add(DTN_Custodial_Rep);
   Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
   currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
   Custodial__c cust= new Custodial__c();
   cust.DTN_Current_Rep__c=DTN_Current_Rep;
   cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
   insert cust;
   ApexClass ac= [Select Name,Status from ApexClass where Name='LoggerUtil'];
   ac.status = 'Deleted';
  
   test.starttest();
   CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
   Database.executebatch(cb,200);
   test.stoptest();
   List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
    //System.assert(at.size()==0);
   // System.assertequals(at[0].AccountId,a.ID);
    //System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
 static testmethod void testnewRepwithinvalidAData(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='Test Segment';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='QP Specialist');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_new_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_new_Rep);
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_new_Rep__c=DTN_new_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,null,DTN_Current_Rep,DTN_new_Rep,q,dtnUsers,null,null);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_new_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_new_Rep);
    }
    static testmethod void testCustodialRepwithinvalidAData(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='Test Segment';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='QP Specialist');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_Custodial_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Custodial_Rep);
    Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
    currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
  
   static testmethod void testOpenTerritory(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='QP Specialist');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_Custodial_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Custodial_Rep);
    Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
    currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,null,DTN_Custodial_Rep);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
 
 static testmethod void testCustodialAlreadyAdded(){
   setup();
   ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
   Account a = new Account();
   a.Name= 'Test Account';
   a.RecordTypeId=prospecrAccountRecordTypeID;
   a.Market_Segment__c='Accounting Firms';
   a.Market_Sub_Segment__c='5-9 Total Employees';
   insert a;
   User testUser1 = TestDataFactory.newUser('4444',1);
   User testUser2 = TestDataFactory.newUser('5555',2);
   //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
   AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='5555');
   insert atm;
   AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
   insert as1;
   String DTN_Current_Rep=testUser1.DTN__c;
   String DTN_Custodial_Rep=testUser1.DTN__c;
   String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
   Set<String> dtnUsers= new Set<String>();
   dtnUsers.add(DTN_Custodial_Rep);
   Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
   currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
   Custodial__c cust= new Custodial__c();
   cust.DTN_Current_Rep__c=DTN_Current_Rep;
   cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
   insert cust;
   test.starttest();
   CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
   Database.executebatch(cb,200);
   test.stoptest();
   List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
   System.assert(at.size()>0);
   System.assertequals(at[0].AccountId,a.ID);
   System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
 
 static testmethod void testnewRepCustodial(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //User testUser3 = TestDataFactory.newUser('6666',3);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Cust-QP Specialist');
    insert atm;
    
    AccountTeamMember atm2= new AccountTeamMember(AccountId=a.Id, UserId=testUser2.Id ,TeamMemberRole='Cust-QP Specialist');
    insert atm2; 
    
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_new_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Current_Rep);
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_new_Rep__c=DTN_new_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,null,DTN_Current_Rep,DTN_new_Rep,q,dtnUsers,null,null);
    Database.executebatch(cb,200);
    test.stoptest();
    
    
    
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_new_Rep];
    system.debug('at.size()****'+at);
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_new_Rep);
    }
    
    static testmethod void testnewRepCustodial1(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //User testUser3 = TestDataFactory.newUser('6666',3);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Cust-QP Specialist');
    insert atm;
    
    AccountTeamMember atm2= new AccountTeamMember(AccountId=a.Id, UserId=testUser2.Id ,TeamMemberRole='Cust-QP Specialist');
    insert atm2; 
    
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_new_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Current_Rep);
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_new_Rep__c=DTN_new_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,null,DTN_Current_Rep,DTN_new_Rep,q,dtnUsers,null,null);
    cb.custodialAccessRevert = true;
    Database.executebatch(cb,200);
    test.stoptest();
    
    
    
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_new_Rep];
    system.debug('at.size()****'+at);
    System.assert(at.size()>0);
    System.assertequals(at[0].AccountId,a.ID);
    System.assertequals(at[0].User.DTN__C,DTN_new_Rep);
    }
  
static testmethod void testCustodialRep1_test(){
    setup();
    ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    //SMS-777 Start
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Test';
    update  testUser1;
    update  testUser2;
    //SMS-777 End
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='C- test 5555');
    insert atm;
    AccountShare as1= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =testUser1.Id , AccountId = a.Id);
    insert as1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_Custodial_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Custodial_Rep);
    Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
    currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Custodial_Rep});
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_Custodial_Rep__c=DTN_Custodial_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,DTN_Custodial_Rep,null);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Custodial_Rep];
   // System.assert(at.size()>0);
  //  System.assertequals(at[0].AccountId,a.ID);
  //  System.assertequals(at[0].User.DTN__C,DTN_Custodial_Rep);
 }
 //SMS-777 Start
 static testmethod void testCustodialRep2_test(){
 	setup();
 	ID prospecrAccountRecordTypeID= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospect_Account'].ID;
    Account a = new Account();
    a.Name= 'Test Account';
    a.RecordTypeId=prospecrAccountRecordTypeID;
    a.Market_Segment__c='Accounting Firms';
    a.Market_Sub_Segment__c='5-9 Total Employees';
    insert a;
    Account a1 = new Account();
    a1.Name= 'Test Account 1';
    a1.RecordTypeId=prospecrAccountRecordTypeID;
    a1.Market_Segment__c='Accounting Firms';
    a1.Market_Sub_Segment__c='5-9 Total Employees';
    insert a1;
    User testUser1 = TestDataFactory.newUser('4444',1);
    User testUser2 = TestDataFactory.newUser('5555',2);
    User testUser3 = TestDataFactory.newUser('1010',5);
    testUser1.FirstName = 'Test';
    testUser2.FirstName = 'Territory_Test';
    testUser2.custodial_rep__c = testUser3.Id;
    update  testUser1;
    update  testUser2;
    update  testUser3;
    AccountTeamMember atm= new AccountTeamMember(AccountId=a.Id, UserId=testUser1.Id ,TeamMemberRole='Cust- ISC - Corp Software Indirect');
    insert atm;
	AccountTeamMember atm1= new AccountTeamMember(AccountId=a1.Id, UserId=testUser1.Id ,TeamMemberRole='ISC - Corp Software Indirect');
	insert atm1;
    String DTN_Current_Rep=testUser1.DTN__c;
    String DTN_Open_Territory_Rep=testUser2.DTN__c;
    String q = 'Select id,UserId,AccountId,TeamMemberRole,User.DTN__c,User.Name from AccountTeamMember where User.DTN__c ='+'\''+DTN_Current_Rep+'\'';
    Set<String> dtnUsers= new Set<String>();
    dtnUsers.add(DTN_Open_Territory_Rep);
    Map<String,List<String>> currentwithCustodailReps= new Map<String,List<String>>();
    currentwithCustodailReps.put(DTN_Current_Rep, new List<String>{DTN_Open_Territory_Rep});
    Custodial__c cust= new Custodial__c();
    cust.DTN_Current_Rep__c=DTN_Current_Rep;
    cust.DTN_Open_Territory_User__c=DTN_Open_Territory_Rep;
    insert cust;
    test.starttest();
    CustodialAccountBatch cb= new CustodialAccountBatch(cust.Id,currentwithCustodailReps,DTN_Current_Rep,null,q,dtnUsers,null,DTN_Open_Territory_Rep);
    Database.executebatch(cb,200);
    test.stoptest();
    List<AccountTeamMember> at= [Select Id, AccountId,User.Name, User.DTN__C from AccountTeamMember where User.DTN__C=:DTN_Open_Territory_Rep];
    System.debug('@@ATM '+ at);
    System.assertEquals(at.size(),2);
 }
 //SMS-777 End
}