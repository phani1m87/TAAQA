trigger APTS_ProposalLineItem on Apttus_Proposal__Proposal_Line_Item__c (after insert, after update) {

    APTS_ProposalLineItem_Handler handler = new APTS_ProposalLineItem_Handler();
    
        /* Before Insert */
        //if(Trigger.isInsert && Trigger.isBefore){
            
        //}
    
        /* After Insert */
        if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new);
            System.debug('*****************AFTER INSERT Trigger.new: '+trigger.new);
        }
    
        /* Before Update */
        //else if(Trigger.isUpdate && Trigger.isBefore){
        //    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        //    System.debug('*****************BEFORE UPDATE Trigger.new: '+trigger.new);     
        //}
    
        /* After Update */
        else if(Trigger.isUpdate && Trigger.isAfter){
              handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
              System.debug('****************AFTER UPDATE Trigger.new: '+trigger.new);
        }
        
        //makes proposal trigger to execute on insert or update of Proposal line item
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem=Trigger.new[0];

            Apttus_Proposal__Proposal__c parentProposal =[select id,name,LineItemToProposalTrigger__c from Apttus_Proposal__Proposal__c where id=:proposalLineItem.Apttus_Proposal__Proposal__c];        
        
        if(parentProposal.LineItemToProposalTrigger__c)
               parentProposal.LineItemToProposalTrigger__c=false;
        else
               parentProposal.LineItemToProposalTrigger__c=true;
        
        update parentProposal;
        
        /* Before Delete */
        //else if(Trigger.isDelete && Trigger.isBefore){
        //    System.debug('trigger.old for attachments' +trigger.old);
            //handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        //}
    
        /* After Delete */
        //else if(Trigger.isDelete && Trigger.isAfter){
            //handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        //}
    
        /* After Undelete */
        //else if(Trigger.isUnDelete){
            //handler.OnUndelete(Trigger.new);
        //}
}