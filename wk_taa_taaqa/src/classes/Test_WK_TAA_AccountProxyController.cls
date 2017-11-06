/*
 * Author: Salesforce Services
 * Test class for WK_TAA_AccountProxyController apex class.
 */
@isTest
public class Test_WK_TAA_AccountProxyController{
    public static testMethod void testCheckRoleCreate()
    {
        // Run without any data in Custom setting - By default no data will be available in custom setting in test class.
        PageReference pageRef = Page.WK_TAA_AccountCreateProxy;
        Test.setCurrentPage(pageRef);
        Account acct = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        WK_TAA_AccountProxyController controller = new WK_TAA_AccountProxyController(sc);
        PageReference nextPage = controller.checkRolesForCreate();
        System.assertNotEquals(nextPage, null);
        
        // Insert current User profile into custom setting and run again!
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String currentProfile = PROFILE[0].Name;      
        WK_TAA_AccountCreateProfilePermissionMap__c permissionMap = new WK_TAA_AccountCreateProfilePermissionMap__c(Name=currentProfile);
        insert permissionMap;
        nextPage = controller.checkRolesForCreate();
        System.assertEquals(nextPage, null);
    }
}