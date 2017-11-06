public with sharing class updateProposalController {
    
    public boolean hasErrors{get;set;}
    apttus_proposal__proposal__c proposal{get;set;}
    apexpages.standardController proposalStandardController;
    public updateProposalController(apexpages.standardController apsc)
    { 
     proposalStandardController =apsc;
     proposal=(apttus_proposal__proposal__c)apsc.getRecord();
    }
    
    /*public pageReference UpdateRecord()
    {
     //proposal.Apttus_Proposal__Approval_Stage__c='Submitted to COP';
     //pagereference pref=new pageReference('/apex/updateApprovalStage?Id='+proposal.id);
    //https://cs15.salesforce.com/
    pagereference pref=new pageReference('/'+proposal.id+'/e?00Ne0000000tJqg=Submitted to COP');
     
     return pref;
    }*/
    
    public pageReference doCancel()
    {
        
     return proposalStandardController.cancel();
    }
    
    public pageReference doSubmitToCOP()
    {
        try{
        proposal.Apttus_Proposal__Approval_Stage__c='Submitted to COP';
                update proposal;
        ID oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal Opportunity').getRecordTypeId(); 
        
        Opportunity oppo=[select Id,name,StageName,RecordTypeId from Opportunity where id=:proposal.Apttus_Proposal__Opportunity__c];
        if(oppo.RecordTypeId == oppRecType){
            oppo.StageName='Renewal Won';
            oppo.Closed_Reason__c='Renewal';
            update oppo;
        }
        return proposalStandardController.view();
        }
        catch(Exception Ex){
        //apexpages.addMessage(new apexpages.message(apexpages.severity.warning,'Validatin Error'));
        hasErrors=true;
        }
        return null;
    }
    

}