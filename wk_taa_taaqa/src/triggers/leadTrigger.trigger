trigger leadTrigger on Lead (before insert,after insert,before update, after update) {
  List<Lead> newLeadlist= new List<Lead>();
//LeadTriggerHandler objHandler=new LeadTriggerHandler();
//for before insert even
LeadTriggerHandler objHandler;
  for(Lead l:trigger.new){
    if(!l.LeadOwnerAssignmentTriggerOff__c)
      newLeadList.add(l);
  }    
  if (newLeadList.size()>0)
    objHandler=new LeadTriggerHandler(newLeadList,trigger.oldmap);
  if(trigger.isBefore && trigger.isInsert){
    if(newLeadList.size()>0){
      objHandler.updateOwner(newLeadList, null);
    }
       
  }   
  if(trigger.isBefore && trigger.isUpdate){    
    if (newLeadList.size()>0){
      objHandler.updateOwner(newLeadList,trigger.oldMap);
    } 
  }
  if(trigger.isAfter){    
    if (newLeadList.size()>0){
       objHandler.monitoringlogs(newLeadList,trigger.oldMap);
    }
  }
  /*if(trigger.isAfter && trigger.isUpdate){
     List<Id> convertedAccountIdList= new List<Id>();
      for(Lead l : trigger.new){
       if(l.isconverted && l.convertedAccountId != null){
         convertedAccountIdList.add(l.convertedAccountId);
       }
      }
      if(convertedAccountIdList.size()>0)
      LeadTriggerHandler.assignAccountTeamAndSharingRules(convertedAccountIdList);
    }
*/
}