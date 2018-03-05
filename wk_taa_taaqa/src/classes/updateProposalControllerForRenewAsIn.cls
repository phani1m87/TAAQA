public with sharing class updateProposalControllerForRenewAsIn {
    
    public boolean hasErrors{get;set;}
    apttus_proposal__proposal__c proposal{get;set;}
    apexpages.standardController proposalStandardController;
    public updateProposalControllerForRenewAsIn(apexpages.standardController apsc)
    { 
     proposalStandardController =apsc;
     proposal=(apttus_proposal__proposal__c)apsc.getRecord();
    }
    
   
    public pageReference doCancel()
    {
        
     return proposalStandardController.cancel();
    }
    
    public pageReference doSubmitToCOP()
    {
        try{
        ID propRecType = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').getDescribe().getRecordTypeInfosByName().get('AMS Renewals').getRecordTypeId();
        ID propRecType2 = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').getDescribe().getRecordTypeInfosByName().get('AMS Proposal').getRecordTypeId();
     
        Apttus_Proposal__Proposal__c prop=[select id,name,RecordTypeId from Apttus_Proposal__Proposal__c where id=:proposal.id];
        if(prop.RecordTypeId == propRecType || prop.RecordTypeId == propRecType2)
        {
        proposal.Apttus_Proposal__Approval_Stage__c='Submitted to COP';
        proposal.SAP_Order_Processing_Stage__c = 'Sent for Auto-Confirm';
        }
        else
        {
        proposal.Apttus_Proposal__Approval_Stage__c='Submitted to COP';
        proposal.SAP_Order_Processing_Stage__c = 'Submitted to COP';
        }
        Opportunity oppo=[select Id,name,StageName,ignoreSubmitToCopValidations__c,Closed_Reason__c from Opportunity where id=:proposal.Apttus_Proposal__Opportunity__c];
        oppo.ignoreSubmitToCopValidations__c=True;
        update oppo;
        update proposal;
        oppo.StageName='Renewal Won';
        oppo.Closed_Reason__c='Renewal';
        oppo.ignoreSubmitToCopValidations__c=False;
        update oppo;
        return proposalStandardController.view();
        }
        catch(Exception Ex){
        apexpages.addMessage(new apexpages.message(apexpages.severity.warning,Ex.getMessage()));
        hasErrors=true;
        }
        return null;
    }
    

}