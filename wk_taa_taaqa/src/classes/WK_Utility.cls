public with sharing class WK_Utility 
{
    public static String UUID_Generator()
    {
        Blob aes = Crypto.generateAesKey(128);
        String hex = EncodingUtil.convertToHex(aes);
        System.debug('uuid is ' + hex);
        
        return hex;
    }
    private static EOI_Order_Integration__c siCusSet;
    /*
    @method: ServiceIntegrations
    @description: the static method which will return hierarchical EOI_Order_Integration__c without soql. 
    @               To get the field value just impend the field with dot to method name.
    */
    public static EOI_Order_Integration__c ServiceIntegrations(){
        siCusSet = EOI_Order_Integration__c.getInstance();
        if(siCusSet == null){
            siCusSet = EOI_Order_Integration__c.getOrgDefaults();
        }
        return siCusSet;
    }
    
    /*
    @method: CreateCaseServiceIntegrations
    @description: the static method which will return hierarchical TAA_ServiceSiteCaseCreation__c without soql. 
    @               To get the field value just impend the field with dot to method name.
    */
    
    public static TAA_IIB_CreateCase_Credentials__c CreateCaseServiceIntegrations()
    {
        TAA_IIB_CreateCase_Credentials__c objCustSetting = TAA_IIB_CreateCase_Credentials__c.getInstance();
        if(objCustSetting == null){
            objCustSetting = TAA_IIB_CreateCase_Credentials__c.getOrgDefaults();
        }
        return objCustSetting;
    }
    
    public static List<SelectOption> sortSelectOptionList(List<SelectOption> source)
    {
        List<string> sortable = new  LIst<string>();
        for(SelectOption so : source)
        {
            // replace blank with '_!' so we know the final split will have two components
            sortable.Add((string.isblank(so.getLabel()) ? '_!' : so.getLabel()) + '@!@' + (string.isblank(so.getValue()) ? '_! ' : so.getValue()));
        }
        // sort the list
        sortable.sort();
        List<SelectOption> targetList = new  List<SelectOption>();
        // split the value/name components and re create the list
        for(string s: sortable)
        {
            targetList.Add(new  SelectOption(s.split('@!@')[1].replace('_!',''), s.split('@!@')[0].replace('_!','')));
        }
        return targetList;
    }
}