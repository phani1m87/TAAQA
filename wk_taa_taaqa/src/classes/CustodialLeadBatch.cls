global class CustodialLeadBatch implements Database.Batchable <SObject>,Database.Stateful{
//global map<String,list<String>>currentWithCustodialReps ;
global String dtn_Current_Rep;
global String query;
global String dtn_new_Rep;
global integer noOfRecordsprocessed;
global list<Monitoring_Log__c> errorRecordslist;
global Id custodailrecordId;
String custodialrepDTN;
global set<String>dtnUsers;
//map<String,User>dtnUserMap = new map<String,User>();
global CustodialLeadBatch(Id custodailrecordId,String DTN_Current_Rep, String DTN_new_Rep, String q,String custodialrepDTN )
{//this.currentWithCustodialReps=currentwithCustodailReps;
this.dtn_Current_Rep=DTN_Current_Rep;
this.custodailrecordId=custodailrecordId;
this.custodialrepDTN=custodialrepDTN;
this.dtn_new_Rep=DTN_new_Rep;
this.query=q;
this.noOfRecordsprocessed=0;
//errorRecordslist= new list<ErrorRecord__c>();
//this.dtnUsers=dtnUsers;
}
global Database.QueryLocator start(Database.BatchableContext bc){

      return Database.getQueryLocator(query);
   }
global void execute(Database.BatchableContext bc,List<Lead> leadlist){
AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
    TotalJobItems, CreatedBy.Email, ExtendedStatus  
  from AsyncApexJob where Id = :bc.getJobId()];  
 
     List<Lead>updateOwnerLst= new List<Lead>();
     User custodial_Repersentative;
     User new_Representative;
     User current_Representative;
     List<User>userlist= new List<User>();
     if(custodialrepDTN!=null ){
        userlist= [Select id,DTN__c,Name from user where DTN__c= :custodialrepDTN]; 
        if(userlist.size()>0)
        custodial_Repersentative=userlist.get(0);
     }
     if(dtn_new_Rep!=null){
          userlist=[Select id,DTN__c,Name from user where DTN__c= :dtn_new_Rep];
          if(userlist.size()>0)
          new_Representative=userlist.get(0);
     }
     if(dtn_Current_Rep!=null){
         userlist =[Select id,DTN__c,Name from user where DTN__c= :dtn_Current_Rep];
         if(userlist.size()>0)
         current_Representative=userlist.get(0);
     }
     
     list<Monitoring_Log__c> errorRecordslist = new list<Monitoring_Log__c>();
      list<Monitoring_Log__c> monitoringLogList = new list<Monitoring_Log__c>();
     list<lead>updateOwnerAssignmentFlagList= new List<Lead>(); 
     // update LeadOwnerAssignmentTriggerOff value to true 
     for (lead l: leadlist){
       if(!l.isconverted){
          l.LeadOwnerAssignmentTriggerOff__c=true;   
          updateOwnerAssignmentFlagList.add(l);       
         }
      }
      if(updateOwnerAssignmentFlagList.size()>0)
      update updateOwnerAssignmentFlagList;
     
        for(lead l: leadlist){
         if(!l.isconverted){
        if(current_Representative!=null && custodial_Repersentative!=null && new_Representative==null){
            l.ownerId=custodial_Repersentative.Id;
            l.custodian__C=true;
            Monitoring_Log__c m=new Monitoring_Log__c();
            m.Detail__c = 'Lead is assigned  from user :: '+current_Representative.Name +' to User :: '+custodial_Repersentative.Name+ ' as Custodial by batch process requested by ::' +Userinfo.getName();
            m.Type__c = WK_Exception.ATA_LEAD_ASSIGNMENT_ACROSS_DTN;
            m.Lead__c=l.Id;
            m.Name='Lead Custodial Assignment';
            m.Class__c='LeadCustodialBatch';
            m.Apex_Job_ID__c= a.id;
            monitoringLogList.add(m);
        }
        else if(current_Representative!=null && custodial_Repersentative==null && new_Representative!=null){
            l.custodian__C=false;
            l.ownerId=new_Representative.id;
            Monitoring_Log__c m=new Monitoring_Log__c();
            m.Detail__c = 'Lead is assigned  from user : '+current_Representative.Name +' to User '+new_Representative.Name+ ' by batch process requested by ::' +Userinfo.getName();
            m.Type__c = WK_Exception.ATA_LEAD_ASSIGNMENT_ACROSS_DTN;
            m.Lead__c=l.Id;
            m.Name='Lead New Rep Assignment';
            m.Class__c='LeadCustodialBatch';
            m.Apex_Job_ID__c= a.id;
            monitoringLogList.add(m);
            
        }
         updateOwnerLst.add(l);
         }
       }
  if(updateOwnerLst.size()>0){
      noOfRecordsprocessed=noOfRecordsprocessed+updateOwnerLst.size();
            Database.SaveResult[] leadOwnerLst = Database.update(updateOwnerLst,false);
            for(Database.SaveResult sr : leadOwnerLst ){
                if(!sr.isSuccess()){
                    String errorMsg = '';
                    for(Database.Error err : sr.getErrors()){
                        errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while updating Lead Owner'+'\n';
                    }
                    try{
                        errorRecordslist.add(LoggerUtil.createBatchErrorRecord('CustodialLeadBatch', 'CustodialProcess',custodailrecordId,dtn_Current_Rep,dtn_new_Rep,custodialrepDTN, errorMsg,WK_Constants.ATA_CODE_ERROR,a.id));
                    }catch(WK_Exception e){
                     Monitoring_Log__c m = new Monitoring_Log__c();
                     m.Detail__c ='::Current Rep DTN::'+dtn_Current_Rep;
                     if(custodialrepDTN!= null){
                     m.Detail__c = m.Detail__c+'::Custodial Rep DTN::'+custodialrepDTN;
                     }
                     if(dtn_new_Rep!=null){
                     m.Detail__c= m.Detail__c+'::DTN New REP::'+dtn_new_Rep;
                     }
                     m.Detail__c= m.Detail__c+':::::::::'+e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                     m.Type__c = WK_Constants.ATA_CODE_ERROR;
                     m.Custodial__c=custodailrecordId;
                     m.Apex_Job_ID__c= a.id;
                     errorRecordslist.add(m);
                    
                    }
                }
            }
        }
       if( monitoringLogList.size()>0){
            Database.SaveResult[] er = Database.insert(monitoringLogList,false);
       }
        if(errorRecordslist.size()>0 ){
            Database.SaveResult[] er = Database.insert(errorRecordslist,false);
        }     
  }// end of execute method
global void finish(Database.BatchableContext bc) 
{/*
  Custodial__c custodial = new Custodial__c();
    if(dtn_Current_Rep!=null)
    custodial.DTN_Current_Rep__c=dtn_Current_Rep;
    if(custodialrepDTN!=null)
    custodial.DTN_Custodial_Rep__c=custodialrepDTN;
    if(dtn_new_Rep!=null)
    custodial.DTN_new_Rep__c=dtn_new_Rep;
    insert custodial;
    if(errorRecordslist.size()>0 ){
    
        for(ErrorRecord__c er :errorRecordslist){
          er.Custodial__c= custodial.id;
        }
      }      
    if(errorRecordslist.size()>0 ){
        Database.SaveResult[] er = Database.insert(errorRecordslist,false);
       }
  */
   AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
    TotalJobItems, CreatedBy.Email, ExtendedStatus  
  from AsyncApexJob where Id = :bc.getJobId()];  
       Monitoring_Log__c er = new Monitoring_Log__c();
       er.Apex_Job_ID__c= a.id;
       er.Type__c=WK_Exception.ATA_CUSTODIAL_LEAD_BATCH_JOB;
       er.Custodial__c=custodailrecordId;
       er.Name = 'CustodialLeadBatch';
       er.Detail__c= '::Current REP DTN::'+ dtn_Current_Rep;
       if(custodialrepDTN!=null){
       er.Detail__c= 'All Leads assigned to territory  '+dtn_Current_Rep+ ' are assigned  to territory ' +custodialrepDTN+' as custodail ' ;       
       }if(dtn_new_Rep!=null){
        er.Detail__c= 'All Leads assigned to territory  '+dtn_Current_Rep+ ' are assigned  to territory ' +dtn_new_Rep+' ' ;  
       }
       er.Detail__c=er.Detail__c+'::::::::'+'The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.'+ '::Total No Of Records Processed::'+noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
       insert er;
 // Email the Batch Job's submitter that the Job is finished.  
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
 String[] toAddresses = new String[] {a.CreatedBy.Email};  
 mail.setToAddresses(toAddresses);  
 mail.setSubject('CustodialBatchJob Status: ' + a.Status);  
 mail.setPlainTextBody('The batch Apex job CustodialLeadBatch processed ' + a.TotalJobItems +  
  ' batches with '+ a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);  
    
 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
 }
}