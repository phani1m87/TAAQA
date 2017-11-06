/*
 * Author: Salesforce Services
 * Test class for Mass Account Merge.
 */
@isTest
public class Test_MassAccountMerge{
    /*
     *  Test to make sure multiple accounts get migrated to one account.
     */
    public static testMethod void testMultipleSourceToSingleDest() {    
        String batchId = 'ACCOUNT_MASS_MERGE_' + Date.today().format() + '_01';

        Account destAccount = new Account(Name='Test Dest Account', CustId__c='DEST_CUSTID');
        insert destAccount;
        
        List<Account> acctList = new List<Account>();
        for(integer i = 0; i<10; i++){
            Account a = new Account(Name='testSrcAccount'+ i, 
                                    CustId__c = 'SRC_CUSTID' + i,
                                   Merge_To_Account_used_by_MassMerge__c= destAccount.Id,
                                    MassMerge_Batch_Id_used_by_MassMerge__c = batchId); 
            acctList.add(a);
        }   
        insert acctList;
        Test.StartTest();
        MassAccountMerge massAccountMerge = new MassAccountMerge(batchId);
        ID batchprocessid = Database.executeBatch(massAccountMerge, 100);
        Test.StopTest();
        System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Account WHERE MassMerge_Batch_Id_used_by_MassMerge__c=\'' + batchId + '\''),
               0);  
        
    }
    
    /*
     *  Test to make sure child objects merge.
     *  Create a source with one contact in it, Create a destination account with one contact in it.
     *  After merging, there should be two contacts in destination account and zero contacts in source account.
     */    
    public static testMethod void testChildObjectMergeBatch() {    
        String batchId = 'ACCOUNT_MASS_MERGE_' + Date.today().format() + '_02';
         
        // Create Destination account and contact first.
        Account destAccount = new Account(Name='Test Dest Account', CustId__c='DEST_CUSTID');
        insert destAccount;
        Contact destContact = new Contact(LastName='Dest Contact', AccountId= destAccount.Id);
        insert destContact;    
        
        // Create Source account and contact, include batch id and destination account id in appropriate fields.
        Account srcAccount = new Account(Name='Test Dest Account', 
                                         CustId__c='DEST_CUSTID',
                                         Merge_To_Account_used_by_MassMerge__c= destAccount.Id,
                                         MassMerge_Batch_Id_used_by_MassMerge__c = batchId);
        insert srcAccount;       
        Contact srcContact = new Contact(LastName='Src Contact', AccountId= srcAccount.Id);
        insert srcContact;
         
        // Run the batch merge process
        Test.StartTest();
        MassAccountMerge massAccountMerge = new MassAccountMerge(batchId);
        ID batchprocessid = Database.executeBatch(massAccountMerge, 100);
        Test.StopTest();
        System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Account WHERE MassMerge_Batch_Id_used_by_MassMerge__c=\'' + batchId + '\''),
               0);
        System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Contact WHERE AccountId=\'' + srcAccount.Id + '\''),
               0);
        System.AssertEquals(
               database.countquery('SELECT COUNT()'
                  +' FROM Contact WHERE AccountId=\'' + destAccount.Id + '\''),
               2);
             
     }
    
}