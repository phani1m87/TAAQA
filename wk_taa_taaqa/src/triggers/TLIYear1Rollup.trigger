trigger TLIYear1Rollup on Template_Line_item__c (after insert, after update) {

    Map<ID, Apttus_Proposal__Proposal__c> parentProposal = new Map<ID, Apttus_Proposal__Proposal__c>();
    List<Id> listIds = new List<Id>();
    List<Id> LineItems = new List<Id>();

    for (Template_Line_item__c childObj : Trigger.new) {
        listIds.add(childObj.Quote_Proposal__c);
        LineItems.add(childObj.Id);
    }
  
    parentProposal = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT id,Year_2_Rollup__c ,Year_3_Rollup__c ,Year_4_Rollup__c ,Year_5_Rollup__c ,(Select id, Year_2_Price_Form__c, Year_3_Price_Form__C, Year_4_Price_Form__c, Year_5_Price_Form__C from Template_Line_Items__r where line_type__c = 'Product/Service') FROM Apttus_Proposal__Proposal__c WHERE ID IN :listIds]);
    //Please use child relationship name in place of Apttus_Proposal__Proposal_Line_Items__r
    for (Template_Line_item__c TemplateLineItem: Trigger.new){
         Apttus_Proposal__Proposal__c myParentProposal = parentProposal.get(TemplateLineItem.Quote_Proposal__c);
        if(parentProposal.containsKey(TemplateLineItem.Quote_Proposal__c) && parentProposal.get(TemplateLineItem.Quote_Proposal__c).Template_Line_Items__r.size() > 0)
        {
            myParentProposal.Year_2_Rollup__c=0;
            myParentProposal.Year_3_Rollup__c=0;
            myParentProposal.Year_4_Rollup__c=0;
            myParentProposal.Year_5_Rollup__c=0;
            for(Template_Line_Item__c tempLineItem : parentProposal.get(TemplateLineItem.Quote_Proposal__c).Template_Line_Items__r){
                
                myParentProposal.Year_2_Rollup__c=myParentProposal.Year_2_Rollup__c+tempLineItem.Year_2_Price_Form__c;
                myParentProposal.Year_3_Rollup__c=myParentProposal.Year_3_Rollup__c+tempLineItem.Year_3_Price_Form__c;
                myParentProposal.Year_4_Rollup__c=myParentProposal.Year_4_Rollup__c+tempLineItem.Year_4_Price_Form__c;
                myParentProposal.Year_5_Rollup__c=myParentProposal.Year_5_Rollup__c+tempLineItem.Year_5_Price_Form__c;

        }
        }
        else
        {
            myParentProposal.Year_2_Rollup__c = 0 ;
            myParentProposal.Year_3_Rollup__c = 0 ;
            myParentProposal.Year_4_Rollup__c = 0 ;
            myParentProposal.Year_5_Rollup__c = 0 ;
        }
        
    }
    update parentProposal.values();
 }