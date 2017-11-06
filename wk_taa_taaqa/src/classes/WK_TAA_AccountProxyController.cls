/*
 *  Author: Salesforce Services
 *  Description: Controller to assist WK_TAA_AccountCreateProxy page. Checks for valid profiles before
 *               redirecting users to Standard Account create page.
 */
public without sharing class WK_TAA_AccountProxyController{

  /*
   * Constructor
   */
  public WK_TAA_AccountProxyController(ApexPages.StandardController stdController){    
  }
  
  
  /*
   * Description: This method is invoked on load of the VF page. 
   *              If this method returns null, the VF page renders error message.
   */
  public PageReference checkRolesForCreate()
  {
      // Query Profile information
      List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
      String currentProfile = PROFILE[0].Name;
      
      // Check if profile exists in Custom Setting. 
      Map<String, WK_TAA_AccountCreateProfilePermissionMap__c> profileMap = WK_TAA_AccountCreateProfilePermissionMap__c.getAll();
      if(profileMap.containsKey(currentProfile))
      {
          return null;
      }
      
      // Redirect to Standard Account create page.
      return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&retURL=/' + Account.SObjectType.getDescribe().getKeyPrefix() + 
              '/o&nooverride=1&save_new_url=/'+ Account.SObjectType.getDescribe().getKeyPrefix() 
              + '/e?retURL=%2F' + Account.SObjectType.getDescribe().getKeyPrefix() + '%2Fo');
  }
  
}