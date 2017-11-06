trigger APTPS_DocusignEnvelopeTgr on Apttus_DocuApi__DocuSignEnvelope__c (after insert,after update) {
	
	if(trigger.isInsert && trigger.isAfter)
    {
     if(!APTS_DocusignTgrHelper.docuSignEnvMap.get('AfterInsert'))
     {
      APTS_DocusignTgrHelper.docuSignEnvMap.put('AfterInsert',true);
      APTS_DocusignTgrHelper dsEnvTgr=new APTS_DocusignTgrHelper();  
      dsEnvTgr.updateQuote(trigger.newmap);  
      
     }
    }
    if(trigger.isUpdate && trigger.isAfter)
    {
     if(!APTS_DocusignTgrHelper.docuSignEnvMap.get('AfterUpdate'))
     {
     	
      APTS_DocusignTgrHelper.docuSignEnvMap.put('AfterUpdate',true);
      APTS_DocusignTgrHelper dsEnvTgr=new APTS_DocusignTgrHelper();  
      dsEnvTgr.updateQuote(trigger.newmap);  
      
     }
    }

}