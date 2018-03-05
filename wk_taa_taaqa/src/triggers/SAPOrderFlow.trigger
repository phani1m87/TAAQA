Trigger SAPOrderFlow on Apttus_Proposal__Proposal__c (before update) {
for(apttus_proposal__proposal__c Proposal:trigger.new){
 apttus_proposal__proposal__c oldProp = Trigger.oldMap.get(Proposal.Id);
 
 if(oldProp.sap_order_processor__c == null && proposal.SAP_Order_Processor__c !=null )
   {
      if(oldProp.sap_order_assigned_date__c == null)
      {
       proposal.SAP_Order_Assigned_Date__c = system.today();
       }
       proposal.sap_order_processing_stage__c = 'In Process';
       
      if(proposal.owner_full_name__C <> 'Integration User')
      {
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String messageBody;
        String getProcessor = [select name from user where Id = :trigger.new[0].sap_order_processor__c].Name;
        String getAccount = [select name from account where id = :trigger.new[0].apttus_proposal__account__c].name;
        //String getProposalId = [select name from proposal where id=:trigger.new[0].apttus_proposal__proposal__c].name;
        
        String[] Account = new String[] {getAccount};
        String[] Processor = new String[] {getProcessor};
        //String[] ProposalId = new String[] {getProposalId};
        
        messageBody = '<html><body>Order ' +Proposal.name+' has been assigned to: '+Processor+'</body></html>';
        
        mail.TargetObjectId = (proposal.ownerId);
        mail.setSubject('Order received for account: '+Account);
        mail.setHTMLBody(messageBody);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }  
   } 
   
   if((oldProp.sap_order_on_hold__c == null || oldProp.sap_order_on_hold__c == false) && proposal.sap_order_on_hold__c == true)
           {
               proposal.sap_order_processing_stage__c = 'On Hold';
               if(proposal.sap_order_on_hold_date__c == null)
               {
               proposal.sap_order_on_hold_date__c = system.today();
               }
               if(proposal.owner_full_name__C <> 'Integration User')
               {
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        String getProcessor = [select name from user where Id = :trigger.new[0].sap_order_processor__c].Name;
        String getAccount = [select name from account where id = :trigger.new[0].apttus_proposal__account__c].name;
        String getProposalName = [select apttus_proposal__proposal_name__c from apttus_proposal__proposal__c where id = :trigger.new[0].Id].apttus_proposal__proposal_name__c;
        
        String[] Account = new String[] {getAccount};
        String[] Processor = new String[] {getProcessor};
        String[] ProposalName = new String[] {getProposalName};
        
        mail.TargetObjectId = (proposal.ownerId);       
        mail.setSubject('Order on hold for account: '+Account);
        mail.setHTMLBody('<html><body>Order has been placed on hold. <a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+proposal.Id+'">Click here to link to order </a>');
        mail.setSaveAsActivity(false);    
          
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               
            }
            }
            
   
   if((oldProp.sap_order_rejected__c == null || oldProp.sap_order_rejected__c == false) && proposal.sap_order_rejected__c == true)
     {
     proposal.sap_order_processing_stage__c = 'Rejected';
     proposal.sap_order_corrected__c = false;
     proposal.apttus_proposal__approval_stage__c = 'Accepted';
     if (oldProp.sap_order_rejected_date__c == null)
     {
     proposal.sap_order_rejected_date__c = system.today();
     }
               
  
    }
    if((oldProp.sap_biller_rejected__c == null || oldProp.sap_biller_rejected__c == false) && proposal.sap_biller_rejected__c == true)
     {
     proposal.sap_order_processing_stage__c = 'Rejected';
     proposal.sap_order_corrected__c = false;
     proposal.apttus_proposal__approval_stage__c = 'Accepted';
     if (oldProp.sap_order_rejected_date__c == null)
     {
     proposal.sap_order_rejected_date__c = system.today();
     }
               
  
    }
     if((oldProp.sap_order_corrected__c == null || oldProp.sap_order_corrected__c == false) && proposal.sap_order_corrected__c == true)
     {
          if (oldProp.sap_order_corrected_date__c == null)
     {
     proposal.sap_order_corrected_date__c = system.today();
     }
     }

    
      
  if((oldProp.sap_order_complete__c == null || oldProp.sap_order_complete__c == false) && proposal.sap_order_complete__c == true)
  {
  proposal.sap_order_processing_stage__c = 'Complete';
  proposal.sap_order_corrected__c = false;
  proposal.sap_order_rejected__c = false;
  if(proposal.sap_order_entered_date__c == null)
  {
  proposal.sap_order_entered_date__c = system.today();
  }
  
  if(proposal.owner_full_name__C <> 'Integration User')
  {
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        
        String getAccount = [select name from account where id = :trigger.new[0].apttus_proposal__account__c].name;
        String getSAPOrderNo = [select sap_order_number__c from apttus_proposal__proposal__c where id = :trigger.new[0].Id].sap_order_number__c;
        String getAMSOrderNo = [select ams_order_number__c from apttus_proposal__proposal__c where id = :trigger.new[0].Id].ams_order_number__c;
  
                String[] Account = new String[] {getAccount};        
        String[] SAPOrderNumber = new String[] {getSAPOrderNo};
        String[] AMSOrderNumber = new String[] {getAMSOrderNo};
        
        mail.TargetObjectId = (proposal.ownerId);       
        mail.setSubject('Order completed for account: '+Account);
        mail.setHTMLBody('<html><body>Order has been completed. <a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+proposal.Id+'">Click here to link to order </a></br>'+'AMS Order No: '+AMSOrderNumber +' SAP Order Number: '+SAPOrderNumber);
        mail.setSaveAsActivity(false);    
          
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
   }
   }
              
     
}
}