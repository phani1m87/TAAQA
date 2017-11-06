/*************************************************************************************************************
@Name: APTS_ProposalLineItem_Handler
@Author: Bogdan Botcharov
@Created Date: July 29, 2015
@Description: Handler class for the Apttus_Proposal__Proposal_Line_Item__c
@Used By: Apttus_Proposal__Proposal_Line_Item__c
*************************************************************************************************************/
public with sharing class APTS_ProposalLineItem_Handler {

	public APTS_ProposalLineItem_Handler() {
		
	}

	//BEFORE INSERT LOGIC
	//public void OnBeforeInsert(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
		
    //}

    //AFTER INSERT LOGIC
    public void OnAfterInsert(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
        APTS_ProposalLineItem_Helper helper = new APTS_ProposalLineItem_Helper();
        helper.triggerOpportunityWorkflows(newObjects);
   	}

	//BEFORE UPDATE LOGIC
    //public void OnBeforeUpdate(Apttus_Proposal__Proposal_Line_Item__c[] oldObjects, 
    //							Apttus_Proposal__Proposal_Line_Item__c[] updatedObjects, Map<Id, Apttus_Proposal__Proposal_Line_Item__c> 
    //							oldObjectMap, Map<Id, Apttus_Proposal__Proposal_Line_Item__c> newObjectMap){
    //    APTS_ProposalLineItem_Helper helper = new APTS_ProposalLineItem_Helper();
    //    helper.triggerOpportunityWorkflows(updatedObjects);
    //	
    //}

	//AFTER UPDATE LOGIC
    public void OnAfterUpdate(Apttus_Proposal__Proposal_Line_Item__c[] oldObjects, Apttus_Proposal__Proposal_Line_Item__c[] updatedObjects, 
    							Map<Id, Apttus_Proposal__Proposal_Line_Item__c> objectMap, Map<Id, Apttus_Proposal__Proposal_Line_Item__c> objectNewMap){ 
        APTS_ProposalLineItem_Helper helper = new APTS_ProposalLineItem_Helper();
        helper.triggerOpportunityWorkflows(updatedObjects);
    }

	//BEFORE DELETE LOGIC
    //public void OnBeforeDelete(Apttus_Proposal__Proposal_Line_Item__c[] objectsToDelete, 
    //							Map<Id, Apttus_Proposal__Proposal_Line_Item__c> objectMap){  
    //}

    //AFTER DELETE LOGIC
    //public void OnAfterDelete(Apttus_Proposal__Proposal_Line_Item__c[] deletedObjects, 
    //							Map<Id, Apttus_Proposal__Proposal_Line_Item__c> objectMap){ 
    //}

    //AFTER UNDELETE LOGIC
    //public void OnUndelete(Apttus_Proposal__Proposal_Line_Item__c[] restoredObjects){
    //}
}