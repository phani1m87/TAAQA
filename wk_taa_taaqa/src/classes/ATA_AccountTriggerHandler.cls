/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
public without sharing class ATA_AccountTriggerHandler 
{
    public static Boolean hasDefaultOwnerProcessFailed{get;set;}
    
    //**** Logic to create/update the account team for given accounts    
    public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap)
    {
        // *** invoke delegator method to generate Account Team
        // * trigger newMap 
        // * trigger oldMap 
        // * boolean : decides whether delete all and recreate or just insert / update 
        
        Map<Id, Account> filteredNewMap = new Map<Id, Account>();
        String excludeRecordTypeId;     // recordTypeId to exclude
        
        // read record type to be exluded and find recordTypeId
        if(ATA_Utility.ATACustomSettings() != NULL && String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
        {
            if(String.isNotBlank(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c))
            {
                excludeRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ATA_Utility.ATACustomSettings().ATA_ExcludeAccountRecordType__c).getRecordTypeId();
            } // end if
        } // end if
        
        // filter out the accounts with record type to be excluded
        if(String.isNotBlank(excludeRecordTypeId))
        {       
            for(Id accountId : newMap.keySet())
            {
                // exclude the accounts based on record type filters & exclude account automation flag
                if(newMap.get(accountId).RecordTypeId != excludeRecordTypeId && newMap.get(accountId).Exclude_Account_Automation__c == false)
                {
                    filteredNewMap.put(accountId, newMap.get(accountId));
                } // end if 
            } // end for
        } // end if
        
        if(filteredNewMap.size() > 0)
        {
            ATA_AccountTeamHandler.generateAccountTeam(filteredNewMap, oldMap, true);
            //SMS-1040
            ATA_AccountTriggerHandler.createLogsForDefaultOwnerProcess(filteredNewMap.values());
        }   
    }
    
    //SMS - 1040 : Populate Default Owner
    //This function is used to set the default owner in case owner is inactive or custom seting not configured properly; then log.
    //Usage: This method is used in Before triggers.setDefaultAccountOwnerBefore(Pass the new account list)
    public static void setDefaultAccountOwnerBefore(List<Account> acctList){        
        String defaultOwnerId =  ATA_Utility.ATACustomSettings()!=null?ATA_Utility.ATACustomSettings().Default_Account_UserId__c:'';
        if(String.IsNotBlank(defaultOwnerId)){
            List<User> usersList = new List<User>([Select Id from User where Id =: defaultOwnerId and IsActive = true]);
            if(usersList!=null && usersList.size() > 0){                
                hasDefaultOwnerProcessFailed = false;
                for(Account newAccount : acctList){
                    newAccount.OwnerId = defaultOwnerId;
                }
            }else{
                hasDefaultOwnerProcessFailed = true;
            }
        }else{
             hasDefaultOwnerProcessFailed = true;   
        }
        
        //Note****: In the future if account skews becomes a problem; then we have to introduce logic to calculate the account owner //which amongst the set.
        //return anLogList;
    }
    
    //SMS - 1040 : Populate Default Owner
    //This function is used to create Monitoring logs
    public static void createLogsForDefaultOwnerProcess(List<Account> acctList){
        list<Monitoring_Log__c> anLogList = new list<Monitoring_Log__c>();
        if(hasDefaultOwnerProcessFailed){
            for(Account account : acctList){
                anLogList.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_AccountTeamHandler', 'setDefaultAccountOwner',ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET, String.valueOf(account.Id), ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET_CODE));
            }
            if(anLogList!=null && anLogList.size()>0){
                insert anLogList;
            }
        }
    }
}