/*
 *  Author: Salesforce Services
 *  Description: Test class for Test_WK_TAA_RelatedAccountsExtension
 */
@isTest
public class Test_WK_TAA_RelatedAccountsExtension{
  public static testMethod void testgetRelatedAccounts()
  {
      Account acct = new Account(Name='Test Account');      
      insert acct;
      ApexPages.StandardController sc = new ApexPages.StandardController(acct);
      WK_TAA_RelatedAccountsExtension controller = new WK_TAA_RelatedAccountsExtension(sc);
      List<Account> accounts = controller.getRelatedAccounts();
      System.assertEquals(accounts.size(), 0);
  }
}