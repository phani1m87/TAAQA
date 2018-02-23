/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/29/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */
global without sharing class ATA_AccountTeamHandler 
{
    //SMS - 1040 updated class from with sharing to without sharing to avoid insufficient priviledges issues
    //***** This class works as delegator for Account Team Automation functionality
    public static Set<Monitoring_Log__c> lstGlobalMonitoringLog = new Set<Monitoring_Log__c>();
    
    public static String apexJobId;
    
    public static void generateAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap, Boolean isDeleteExistingNRecreate)
    {
        
        // #### COMPOSE ACCOUNT TEAM
        // **** pass the newMap and oldMap to ATA_ComposeAccountTeam    
        ATA_ComposeAccountTeam obj = new ATA_ComposeAccountTeam(newMap, oldMap);
        // **** this method delegates the tasks and gathers returned information
        Map<Id, List<AccountTeamMember>> accountNRuleDerivedAccountTeamMap = ATA_ComposeAccountTeam.composeAccountTeam();
        // **** read all monitoring logs that accumulated during compose account team       
        lstGlobalMonitoringLog.addAll(ATA_ComposeAccountTeam.lstMonitoringLog);
        ATA_ComposeAccountTeam.lstMonitoringLog.clear();
        System.debug('ATA_ComposeAccountTeam====='+accountNRuleDerivedAccountTeamMap);
        if(accountNRuleDerivedAccountTeamMap != NULL && accountNRuleDerivedAccountTeamMap.size() > 0)
        {
            // #### CURRENT ACCOUNT TEAM
            // **** gets the current / existing Account Teams for the accounts
            Map<Id, List<AccountTeamMember>> accountNCurrentAccountTeamMap = ATA_CurrentAccountTeam.getCurrentAccountTeam(newMap.keySet());
            
            // #### POST ACCOUNT TEAM
            // **** set flag if delete all & recreate
            ATA_PostAccountTeam.isDeleteExistingNRecreate = isDeleteExistingNRecreate;
            
            // **** compare existing and derived account team and perform appropriate DML (insert / delete)
            List<Monitoring_Log__c> lstMonitoringLog = ATA_PostAccountTeam.constructAccountTeam(accountNCurrentAccountTeamMap, accountNRuleDerivedAccountTeamMap, ATA_ComposeAccountTeam.newMapAccounts);
            
            if(lstMonitoringLog != NULL){
                lstGlobalMonitoringLog.addAll(lstMonitoringLog);
            }
        }
        
        System.debug('###: ' + lstGlobalMonitoringLog);
        
        // DML: Monitoring Log 
        if(lstGlobalMonitoringLog.size() > 0)
        {
            if(String.isNotBlank(apexJobId))
            {
                for(Monitoring_Log__c objLog : lstGlobalMonitoringLog)
                {
                    objLog.Apex_Job_ID__c = apexJobId;
                }   
            }
            
            Database.SaveResult[] saveResults = Database.insert(new List<Monitoring_Log__c>(lstGlobalMonitoringLog), false);
            
            // **** DML error handling ***** //
        }
    }
    
    //SMS - 1040 : Populate Default Owner
    //This function is used to set the default owner in case owner is inactive or custom seting not configured properly; then log.
    public static list<Monitoring_Log__c> setDefaultAccountOwner(Map<Id, Account> newMap){
        list<Monitoring_Log__c> anLogList = new list<Monitoring_Log__c>();
        String defaultOwnerId =  ATA_Utility.ATACustomSettings()!=null?ATA_Utility.ATACustomSettings().Default_Account_UserId__c:'';
        if(String.IsNotBlank(defaultOwnerId)){
            List<User> usersList = new List<User>([Select Id from User where Id =: defaultOwnerId and IsActive = true]);
            if(usersList!=null && usersList.size() > 0){                
                for(Account newAccount : newMap.values()){
                    newAccount.OwnerId = defaultOwnerId;
                }
            }else{
                for(Id accountId : newMap.keySet()){
                    anLogList.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_AccountTeamHandler', 'setDefaultAccountOwner',ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET, String.valueOf(accountId), ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET_CODE));
                }
            }
        }else{
            for(Id accountId : newMap.keySet()){
                anLogList.add(ATA_LogUtil.createMonitoringLog(ATA_Constants.ATA_PROCESS_NAME, 'ATA_AccountTeamHandler', 'setDefaultAccountOwner',ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET, String.valueOf(accountId), ATA_Constants.ATA_DEFAULT_ACCOUNT_OWNER_NOT_SET_CODE));
            }
        }
        //Note****: In the future id account skews becomes a problem; then we have to introduce logic to calculate the account owner //which amongst the set.
        return anLogList;
    }
        
    
    // **** this method is called from UI (Account Page Layout: Re-create Account Team Button)
    webservice static void reCreateAccountTeamInteractive(String accountId)
    {
        Map<Id, Account> mapAccountIdNAccount = new Map<Id, Account>([SELECT Id, RecordTypeId, Exclude_Account_Automation__c FROM Account WHERE Id =: accountId]);
        
        // feed account back to the generateAccountTeam method
        if(mapAccountIdNAccount != NULL && mapAccountIdNAccount.size() > 0){
            generateAccountTeam(mapAccountIdNAccount, null, true);  
        } // end if
    } 
    
    // **** this method is called from batch (ATA_AccountTeamUpdateBatch)
    public static void generateAccountTeam(List<Account> lstAffectedAccounts, Boolean isDeleteExistingNRecreate)
    {
        Map<Id, Account> mapAccountIdNAccount = new Map<Id, Account>();
        
        for(Account objAccount : lstAffectedAccounts)
        {
            mapAccountIdNAccount.put(objAccount.Id, objAccount);    
        }
        
        // feed account back to the generateAccountTeam method
        if(mapAccountIdNAccount != NULL && mapAccountIdNAccount.size() > 0){
            generateAccountTeam(mapAccountIdNAccount, null, isDeleteExistingNRecreate); 
        } // end if
    }    
}