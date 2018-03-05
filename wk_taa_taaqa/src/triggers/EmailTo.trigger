trigger EmailTo on Apttus_Proposal__Proposal__c (before update) {
    for(apttus_proposal__proposal__c Proposal:trigger.new){
    if(proposal.order_redirected__c <> true || proposal.order_redirected__c == null){
    if (proposal.has_site_builder__c == true)
    {
    proposal.email_to__c = 'TC-SiteBuilderSupport@wolterskluwer.com';
    proposal.email_cc_1__c = 'TC-Orders@wolterskluwer.com';
    proposal.sap_order_processing_stage__c = 'Complete';
    } 
    else
    if (proposal.has_Outsource__c == true)
    {
    proposal.email_to__c = 'TC-Orders@wolterskluwer.com';
    proposal.email_cc_1__c = 'mike.gamble@wolterskluwer.com';
    
    } 
    else
    if (proposal.has_FAM__c == true)
    {
    proposal.email_to__c = 'TC-Orders@wolterskluwer.com' ;
    //proposal.sap_order_processing_stage__c = 'Complete';
    } 
    else
        if ((proposal.Has_Tax_Lines__c == true && 
        (proposal.cons_code__c == '028' || proposal.cons_code__c == '043'
         || proposal.ams_special_agreement__C == 'N' || proposal.ams_special_agreement__C == 'M' ||
          proposal.ams_special_agreement__C == 'W' || proposal.ams_special_agreement__C == 'X')) || 
          proposal.named_account_type__c == 'Strategic' || proposal.named_account_type__c == 'National' || proposal.named_account_type__c == 'Global' )
        {
            proposal.email_to__c = 'tc-orders@wolterskluwer.com';
            proposal.Email_CC_1__c = '';
            proposal.email_CC_2__c = '';
            
        }
        else
        if(proposal.rush_order__c == 'Yes')
        {
        proposal.email_to__c = 'sorder.rush.taa@wolterskluwer.com';
        proposal.email_cc_1__c = 'tc-orders@wolterskluwer.com';
        proposal.email_cc_2__c = 'taaordermanagement@wolterskluwer.com';
       
        }
        else
        if(proposal.rush_order__c != 'Yes')
        {
        proposal.email_to__c = 'sorder.taa@wolterskluwer.com';
        proposal.email_cc_1__c = 'tc-orders@wolterskluwer.com';
        proposal.email_cc_2__c = 'taaordermanagement@wolterskluwer.com';
        
        }
    
    }
}
}