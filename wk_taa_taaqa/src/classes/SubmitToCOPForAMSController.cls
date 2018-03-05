public with sharing class SubmitToCOPForAMSController {
    
    public boolean hasErrors{get;set;}
    apttus_proposal__proposal__c proposal{get;set;}
    apexpages.standardController proposalStandardController;
    
    public SubmitToCOPForAMSController(apexpages.standardController apsc) {
       proposalStandardController =apsc;
     proposal=(apttus_proposal__proposal__c)apsc.getRecord();
    }
    
    public pageReference doCancel()
    {
        
     return proposalStandardController.cancel();
    }
    
    public pageReference doSubmitToCOPForAMS()
    {
        try{
        
        proposal.sap_order_processing_stage__c = 'Submitted to COP';
        proposal.apttus_proposal__approval_stage__c = 'Submitted to COP';
                
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
        //apexpages.addMessage(new apexpages.message(apexpages.severity.warning,'Validatin Error'));
        hasErrors=true;
        System.debug('in catch test');
        }
        System.debug('returning null test');
        return null;
    }
    

}