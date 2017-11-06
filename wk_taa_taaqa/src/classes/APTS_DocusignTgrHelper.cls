public with sharing class APTS_DocusignTgrHelper {
	
	
	
	public static map<string,boolean> docuSignEnvMap=new map<string,boolean>{'AfterInsert'=>false,
																			 'AfterUpdate'=>false};
																			 
    
    public APTS_DocusignTgrHelper()
    {
    
    }
    
    public void updateQuote(map<Id,Apttus_DocuApi__DocuSignEnvelope__c> newDSEnvMap)
    {
     set<Id> proposalIds=new set<Id>();
     for(Id dsEnvId:newDSEnvMap.keyset())
     {
      Apttus_DocuApi__DocuSignEnvelope__c currentDSEnv=newDSEnvMap.get(dsEnvId);
      //currentDSEnv.addError('test');
      if(currentDSEnv.Apttus_DocuApi__Status__c!=null &&
         currentDSEnv.Apttus_DocuApi__Status__c.equalsIgnoreCase('sent')){
         proposalIds.add(currentDSEnv.Apttus_QPDSign__QuoteProposal__c);
      }
     }
     
     if(proposalIds.size()==0){
     	return;
     }
     
     list<Apttus_Proposal__Proposal__c> proposals=[select id,Apttus_Proposal__Approval_Stage__c
                                                          from Apttus_Proposal__Proposal__c
                                                          where id in:proposalIds ];
                                                          
     for(Apttus_Proposal__Proposal__c proposal:proposals)
     {
      proposal.Apttus_Proposal__Approval_Stage__c='In Signatures';
     }  
     
     update proposals;                                       
                                                          
    }  
	

}