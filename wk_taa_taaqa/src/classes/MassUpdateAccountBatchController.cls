public class MassUpdateAccountBatchController {
    public void updateDTNAndSegmentAndSubsegment(list<Account>newAccountList, String jobId){
      Map<Id,Account> accountMap= new Map<Id,Account>();
      for(Account acc : newAccountList){
      accountMap.put(acc.Id,acc);
      }
      list<Monitoring_Log__c> monitoringLogslist = new list<Monitoring_Log__c>();
      map<id,String> deletedMonitors = new map<id,String>();
      
        UtilDTNStampingAndTeamMemberCreation dtnHandler = new UtilDTNStampingAndTeamMemberCreation(newAccountList,accountMap);
        //assign the dtns string to DTN_Makeup__c
        //dtnHandler.assignDTNToDTNMakeUp(newAccountList, Null);
        //assign dtn to corresponding fields on Account
        dtnHandler.assignDTNToDTNFieldsOnAccount(newAccountList, Null);
        dtnHandler.assignDefaultAccountOwner(newAccountList, Null);
        //deletedMonitors.putAll(dtnHandler.deleteAccountTeamMembers(newAccountList, Null));
        //unchecked the IsDirty__c field on Account
        turnOffFlagOnAccount(newAccountList);
        update newAccountList;
        //delete already existing account teammembers to update with new one
        deletedMonitors.putAll(dtnHandler.deleteAccountTeamMembers(newAccountList,Null));
        turnOffFlagOnZipcodeDTN();
        //create Account team members and sharing of corresponding Account, Opportunity and Case
        //monitoringLogslist.addAll(dtnHandler.assignAccountTeamAndSharingRules(newAccountList,Null));
        try{
           monitoringLogslist.addAll(dtnHandler.assignAccountTeamAndSharingRules(newAccountList,Null));
           if(monitoringLogslist.size()>0){
             for(Monitoring_Log__c m : monitoringLogslist){
                m.Apex_Job_ID__c= jobId;
                if(!m.Name.contains('Batch'))
                    m.Name= m.Name+'Batch';
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
            m.Apex_Job_ID__c= jobId;
            if(!m.Name.contains('Batch'))
            m.Name= m.Name+' '+'Batch';
            monitoringLogslist.add(m);
      }
        if(monitoringLogslist.size()>0){
          Database.SaveResult[] monitoringlogs = Database.insert(monitoringLogslist,false);
        }
    }
    //turn off IsDirty__c on Account
    private void turnOffFlagOnAccount(list<Account>newAccountList){
        for(Account a : newAccountList){
            a.IsMassUpdated__c= false;
        }
    }
    //turn off IsDirty__c on ZipcodeDTN
    private void turnOffFlagOnZipcodeDTN(){
      list<ZipCodeDTN__c>zipCodeDTNList = [Select id,IsUpdated__c from ZipCodeDTN__c where IsUpdated__c=true];
      if(zipCodeDTNList.size()>0){
          for(ZipCodeDTN__c z : zipCodeDTNList){
              z.IsUpdated__c= false;
          }
          update zipCodeDTNList;
      }
    }
    /*
    //@future
    public static void attachFileToMonitoringLog(String fileBody, Id mId){
      Attachment attachment = new Attachment();
      attachment.Body = Blob.valueOf(fileBody);
      attachment.Name = 'Records processed into Batch job.csv';
      attachment.ParentId = mId;
      insert attachment;
    }*/
}