/**
@Author:HCL Technologies Pvt. Ltd.
@Description: Util class to access custom settings
*/
public class UtilCustomSettings {
    //private static TAACustomSetting__c taaCusSet;
    private static AccountAutomationSetting__c taaCusSet;
    /*
    @method: TAACustomSetting
    @description: the static method which will return hierarchical TAACustomSetting without soql. 
    @               To get the field value just impend the field with dot to method name.
    */
    public static AccountAutomationSetting__c TAACustomSetting(){
    String Profile_Id= UserInfo.getProfileId();
    System.debug('Profile Id ::'+Profile_Id);
        //taaCusSet = AccountAutomationSetting__c.getInstance(Profile_Id);
        taaCusSet = AccountAutomationSetting__c.getInstance();
        System.debug('taaCusSet  ::'+taaCusSet);
        System.debug('taaCusSet  Is triggerOff ::'+taaCusSet.isTriggerOff__c);
        if(taaCusSet == null)
        {
        
            System.debug('Inside Org Default::');
            taaCusSet = AccountAutomationSetting__c.getOrgDefaults();
        }
        return taaCusSet;
    }
}