/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 11/28/2017 SHIVAJI           1.0          ATA 2.0
 * ------------------------------------------------------------------------- */

trigger AccountTrigger on Account (before insert, after insert, before update, after update) 
{
  // *** This trigger is used to update Market Segment and Sub Segment on Account based on SIC code for Prospect accounts exported from Data.com
  // *** and to also determine and post Account Team Members
   
    // **** Trigger ATA 2.0
    if(!ATA_Utility.ATACustomSettings().IsTriggerOff__c)
    {
      List<Account> filteredNewList = new List<Account>();
      if(trigger.isBefore)
      {
            //**** Set Named_Account__c based on the value of Named_Account_Type__c
            for(Account obj : trigger.new)
            {
              System.debug('###: ' + obj.Named_Account_Type__c);
              if(String.isBlank(obj.Named_Account_Type__c)){
                obj.Named_Account__c = false;  
              }else{
                obj.Named_Account__c = true;
              } // end if then else
              System.debug('###: ' + obj.Named_Account__c);
            } // end for
            
            //**** populate segment & sub-segment based on SIC Code
            // this is required for the accounts coming from data.com
            AccountTriggerHandler handler = new AccountTriggerHandler();
            handler.onBeforeInsert(trigger.new);
            
            String excludeRecordTypeId;
            //SMS - 1040: Populate Default Owner
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
                List<Account> accountList = Trigger.new;
                for(Account account: accountList)
                {
                    // exclude the accounts based on record type filters & exclude account automation flag
                    if(account.RecordTypeId != excludeRecordTypeId && account.Exclude_Account_Automation__c == false)
                    {
                        filteredNewList.add(account);
                    } // end if 
                } // end for
            } // end if
            ATA_AccountTriggerHandler.setDefaultAccountOwnerBefore(filteredNewList);
      } // end if
      
      if(trigger.isAfter && CheckRecursive.runOnce())
      {
        // generate account team and log
        ATA_AccountTriggerHandler.generateAccountTeam(trigger.newMap, trigger.oldMap);
        System.debug('###: ' + trigger.new[0].Named_Account_Type__c);
        System.debug('###: ' + trigger.new[0].Named_Account__c);
      } // end if
    } // end if
}