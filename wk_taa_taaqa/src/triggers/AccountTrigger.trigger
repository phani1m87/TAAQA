/*
    **************************************************************************
    Name    :   AccountTrigger
    Usage   :   This trigger is used to update Market Segment and Sub Segment on Account based on SIC code for Prospect accounts exported from Data.com 
    
    Version    |    Name            |    Date           
    1.0             Rajesh Meti          09-June-2015  
    
    Trigger : AccountTrigger on Account (before insert, before update)
    
    ***************************************************************************
*/

trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    
    UtilDTNStampingAndTeamMemberCreation dtnHandler = new UtilDTNStampingAndTeamMemberCreation(trigger.new, trigger.oldMap); 
    system.debug('TAA Custom setting Status :: ' +UtilCustomSettings.TAACustomSetting().IsTriggerOff__c);
    
    if(UtilCustomSettings.TAACustomSetting().IsTriggerOff__c == false){
        //for before insert event
        system.debug('Inside ::');
        list<Monitoring_Log__c> monitoringLogslist = new list<Monitoring_Log__c>();
        String errorType =null;
        if(trigger.isBefore ){
            //AccountTriggerHandler handler = new AccountTriggerHandler();
            //handler.onBeforeInsert(trigger.new,null);
            if(trigger.isInsert){
                //assign the dtns string to DTN_Makeup__c
                //dtnHandler.assignDTNToDTNMakeUp(trigger.new, Null);
                //assign dtn to corresponding fields on Account
                dtnHandler.assignDTNToDTNFieldsOnAccount(trigger.new, Null);
                
                //assign default owner
                dtnHandler.assignDefaultAccountOwner(trigger.new, Null);
            }
            if(trigger.isUpdate){
                //assign the dtns string to DTN_Makeup__c
                 //dtnHandler.assignDTNToDTNMakeUp(trigger.new, trigger.oldMap);
                //assign dtn to corresponding fields on Account
                 dtnHandler.assignDTNToDTNFieldsOnAccount(trigger.new, trigger.oldMap);
                 //assign default owner
                dtnHandler.assignDefaultAccountOwner(trigger.new, trigger.oldMap);
            }
        }//end of isBefore
        
        if(trigger.isAfter && CheckRecursive.runOnce()){
            
            if(trigger.isInsert){
                try{
                    monitoringLogslist.addAll(dtnHandler.assignAccountTeamAndSharingRules(trigger.new,trigger.oldMap));
                }catch(Exception ex){
                    Monitoring_Log__c m = new Monitoring_Log__c();
                    m.Detail__c = ex.getTypeName()+'::line no::'+ex.getLineNumber()+'::Error message::'+ex.getMessage();
                    m.Type__c = WK_Constants.ATA_CODE_ERROR;
                    monitoringLogslist.add(m);
                }
            }
            if(trigger.isUpdate){
                //delete already existing account teammembers to update with new one
                map<id,String> deletedMonitors = new map<id,String>();
                try{
                    deletedMonitors.putAll(dtnHandler.deleteAccountTeamMembers(trigger.new, trigger.oldMap));
                }catch(Exception ex){
                    Monitoring_Log__c m = new Monitoring_Log__c();
                    m.Detail__c = ex.getTypeName()+'::line no::'+ex.getLineNumber()+'::Error message::'+ex.getMessage();
                    m.Type__c = WK_Constants.ATA_CODE_ERROR;
                    monitoringLogslist.add(m);
                }
                //create Account team members and sharing of corresponding Account, Opportunity and Case
                try{
                     monitoringLogslist.addAll(dtnHandler.assignAccountTeamAndSharingRules(trigger.new,trigger.oldMap));
                     if(monitoringLogslist.size()>0){
                        for(Monitoring_Log__c m : monitoringLogslist){
                            if(m.Account__c != null && deletedMonitors.containsKey(m.Account__c) && (m.Type__c != 'ATA_USER_NOT_ACTIVE_OR_PRESENT_FOR_NAMED_ACCOUNT' || m.Type__c != 'ATA_TEAM_MEMBER_NOT_CREATED_FOR_NAMED_ACCOUNT'
                                || m.Type__c != 'ATA_TEAM_MEMBER_NOT_CREATED'
                                || m.Type__c != 'ATA_ZIPCODE_SET_TO_NULL'
                                || m.Type__c != 'ATA_DTN_ROLE_NOT_CHANGED')){
                                m.Detail__c +=  deletedMonitors.get(m.Account__c);
                            }
                        }
                     }
                     
                 }catch(Exception ex){
                            Monitoring_Log__c m = new Monitoring_Log__c();
                            m.Detail__c = ex.getTypeName()+'::line no::'+ex.getLineNumber()+'::Error message::'+ex.getMessage();
                            m.Type__c = WK_Constants.ATA_CODE_ERROR;
                            monitoringLogslist.add(m);
                }
            }
            if(monitoringLogslist.size()>0){
                Database.SaveResult[] monitorslst = Database.insert(monitoringLogslist,false);
            }
        }
    }
}