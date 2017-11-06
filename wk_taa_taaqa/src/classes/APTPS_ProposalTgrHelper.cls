/*
 Author: Venkata R Sabbella
 Last Modified date 01/13/2014
  
*/

public with sharing class APTPS_ProposalTgrHelper {  
    
    public static map<string,boolean> proposalTriggerMap= new map<string,boolean>{'beforeinsert'=>false, 
                                                                                  'beforeupdate'=>false,          
                                                                                  'afterupdate'=>false
                                                                                   };  
            
   //get the contact information 
    public static map<id,Contact> getNewContactInfo(list<Apttus_Proposal__Proposal__c> NewProposalList)
    {
     map<Id,Contact> contactInfoMap;
     set<Id> ContactIds=new set<Id>();
     for(Apttus_Proposal__Proposal__c proposal:NewProposalList )
     {
      //if(proposal.Apttus_Proposal__Primary_Contact__c!=null)
      //ContactIds.add(proposal.Apttus_Proposal__Primary_Contact__c);
      
      if(proposal.Aptps_Training_Contact__c!=null)
      ContactIds.add(proposal.Aptps_Training_Contact__c);
      
      if(proposal.Aptps_Conversion_Contact__c!=null)
      ContactIds.add(proposal.Aptps_Conversion_Contact__c);
     }
     if(ContactIds.size()>0)
     contactInfoMap=new map<Id,Contact>([select id,name,
                                                Phone,
                                                email                                   
                                                from contact where id In:ContactIds ]); 
     else  contactInfoMap=new map<Id,contact>();                                                   
      
     return contactInfoMap;
    } 
    
    //get the Opportunity information 
    /*public static map<id,Opportunity> getNewOpportunityInfo(list<Apttus_Proposal__Proposal__c> NewProposalList)
    {
      map<Id,Opportunity> OppyInfoMap;
     set<Id> OpportunityIds=new set<Id>();
     for(Apttus_Proposal__Proposal__c proposal:NewProposalList )
     {
      if(proposal.Apttus_Proposal__Opportunity__c!=null)
      OpportunityIds.add(proposal.Apttus_Proposal__Opportunity__c);      
     }
     if(OpportunityIds.size()>0)
      OppyInfoMap=new map<Id,Opportunity>([select id,name,
                                                  ERP_Account__c, AMS_Account_Grouping__c, 
                                                  AMS_Special_Agreement__c,
                                                  Account.Named_Account_Type__c                                          
                                                  from Opportunity where id In:OpportunityIds ]);
     else
     OppyInfoMap=new map<Id,Opportunity>();
     
     return OppyInfoMap;
    }*/
    
    public static void defaultPriceList(list<Apttus_Proposal__Proposal__c> newProposalList){
        Map<String,String> rolePriceListId = new Map<String,String>();
        Map<String,String> proposalRecordTypeMap = new Map<String,String>();
        String userRole;
        String uniqueIdentifier;
        
        userRole = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId()].Name;
        
        // Construct the proposalRecordTypeMap.
        for(RecordType rec:[Select Id, Name From Recordtype Where SObjectType = 'Apttus_Proposal__Proposal__c']){
            proposalRecordTypeMap.put(rec.Id, rec.Name);
        }
        
        // Constructthe Map from Custom Settings.
        for(Price_List_Defaulting__c pl: Price_List_Defaulting__c.getAll().values()){
            rolePriceListId.put(pl.Role__c + APTSConstants.CommaDelimeter + pl.Quote_Header_Record_Type__c, pl.Price_List_ID__c);
        }
        
        
        for(Apttus_Proposal__Proposal__c prop: newProposalList){
            uniqueIdentifier = userRole + APTSConstants.CommaDelimeter + proposalRecordTypeMap.get(prop.RecordTypeId);
            
            if(rolePriceListId.keySet().contains(uniqueIdentifier)){
                prop.Apttus_QPConfig__PriceListId__c = rolePriceListId.get(uniqueIdentifier);
            }
            
            uniqueIdentifier = '';
            //prop.Apttus_QPConfig__PriceListId__c = rolePriceListId.get(userRole);
        }
    }
    
    //get the User information 
   /* public static map<id,User> getNewUserInfo(list<Apttus_Proposal__Proposal__c> NewProposalList)
    {
     map<Id,User> userInfoMap;
     set<Id> UserIds=new set<Id>();
     for(Apttus_Proposal__Proposal__c proposal:NewProposalList )
     {
      UserIds.add(proposal.OwnerId);      
     }
      if(UserIds.size()>0)
      userInfoMap=new map<Id,User>([select id,name,
                                                              Email,phone,userrole.name,manager.name,manager.manager.name                                          
                                                              from user where id In:UserIds ]);
      else userInfoMap=new map<Id,User>();                                                        
      
     return userInfoMap;
    }*/
    
    //Called from the trigger.
    public static void applyInformation(list<Apttus_Proposal__Proposal__c> newProposalList)//map<Id,Apttus_Proposal__Proposal__c> newProposalmap
    {
        if(newProposalList==null || (newProposalList!=null && newProposalList.size()==0)) return;
        
        map<Id,Contact> contactmap=getNewContactInfo(newProposalList); //newProposalmap.values()
        //map<Id,Opportunity> opportunityMap=getNewOpportunityInfo(newProposalList); //newProposalmap.values()                                                  
        //map<Id,User> UserMap=getNewUserInfo(newProposalList); //newProposalmap.values()
        
        for(Apttus_Proposal__Proposal__c proposal1:newProposalList)//Id propId: newProposalmap.keyset()
         {
          
          
          Contact conv_contact=(contactmap.containsKey(proposal1.Aptps_Conversion_Contact__c))?contactmap.get(proposal1.Aptps_Conversion_Contact__c):new Contact(email='',phone='');
          Contact train_contact=(contactmap.containsKey(proposal1.Aptps_Training_Contact__c))?contactmap.get(proposal1.Aptps_Training_Contact__c):new Contact(email='',phone='');
          //Contact primary_contact=(contactmap.ContainsKey(proposal1.Apttus_Proposal__Primary_Contact__c))?contactmap.get(proposal1.Aptps_Training_Contact__c):new Contact(email='',phone=''); 
          
          
         //Opportunity prop_Opportunity=opportunityMap.get(proposal1.Apttus_Proposal__Opportunity__c);
         //User prop_Owner=(UserMap.ContainsKey(proposal1.OwnerId))?UserMap.get(proposal1.OwnerId):new user(Email='',Phone='');
          
         
          
          /*if(prop_Opportunity!=null)
          {
           proposal1.Cons_Code_New__c =prop_Opportunity.AMS_Account_Grouping__c;
           proposal1.RFX_New__c=prop_Opportunity.AMS_Special_Agreement__c;
           proposal1.New_Account_New__c=(prop_Opportunity.ERP_Account__c==null)?true:false ;
           //proposal1.Account_Strategic__c              =prop_Opportunity.Account.Named_Account_Type__c;       
          }*/
          
                  
          //update trining contact
          if(train_contact!=null){
          proposal1.Training_Contact_Email__c         =train_contact.Email;
          proposal1.Training_Contact_Phone__c         =train_contact.Phone;}
          
          //update conversion contact
          if(conv_contact!=null){
          proposal1.Conversion_Contact_Email__c=conv_contact.email;
          proposal1.Conversion_Contact_Phone__c=conv_contact.Phone;}
         
         
        
          /*if(proposal1.OwnerId!=null){
           proposal1.Level_1_Approver_New__c=prop_Owner.manager.name;
           proposal1.Level_2_Approver_New__c=prop_Owner.manager.manager.name;
           
           proposal1.Sales_Rep_Email_New__c=prop_Owner.email;
           proposal1.Sales_Rep_Phone_New__c=prop_Owner.Phone;
           proposal1.Sales_Rep_Role_New__c=prop_Owner.userrole.name;
           
           }*/
           
          
         } 
         
    }
    
    public static void updatePaymentTermsType(List<Apttus_Proposal__Proposal__c> newproposals, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
        
        Set<Id> proposalIds = new Set<Id>();
        Map<Id, List<APTS_Payment_Term_Detail__c>> paymentTermListMap = new Map<Id, List<APTS_Payment_Term_Detail__c>>();
        List<APTS_Payment_Term_Detail__c> updatedList = new List<APTS_Payment_Term_Detail__c>();
        Map<Id, String> newPaymentTermsMap = new Map<Id, String>();
        for(Apttus_Proposal__Proposal__c prop: newproposals){
            if(prop.Order_Type__c == 'SAP'){
                if(prop.SAP_Payment_Terms__c != oldMap.get(prop.Id).SAP_Payment_Terms__c){
                    newPaymentTermsMap.put(prop.Id, prop.SAP_Payment_Terms__c);    
                }
            }
        }
        
        if(newPaymentTermsMap.keySet().size()>0){
            for(APTS_Payment_Term_Detail__c payTerms: [Select Id, APTS_Quote_Proposal__c, APTS_Payment_Term__c From APTS_Payment_Term_Detail__c Where APTS_Quote_Proposal__c IN: newPaymentTermsMap.keySet()]){
                payTerms.APTS_Payment_Term__c = newPaymentTermsMap.get(payTerms.APTS_Quote_Proposal__c);
                updatedList.add(payTerms);
            }
        }
        
        if(updatedList.size()>0){
            update updatedList;
        }
    }
    
    
    public static map<Id,Apttus_Proposal__Proposal__c> QueryProposalInfo(list<Apttus_Proposal__Proposal__c> newProposalList){
        //select id,Apttus_Proposal__Proposal__c,Apttus_Proposal__Product__c,Apttus_QPConfig__NetPrice__c,Apttus_QPConfig__OptionId__c,APTS_AMS_Product_Category__c
        
        
        map<Id,Apttus_Proposal__Proposal__c> proposalLinesMap=new map<Id,Apttus_Proposal__Proposal__c>([select id,name,(select id,Product_Type__c,Product_Family__c,
                                                                                                                             //Apttus_QPConfig__OptionId__c,
                                                                                                                             //Apttus_Proposal__Product__c,
                                                                                                                              MYA_Total_Price__c,
                                                                                                                              MYA_All_Years_Total_Price__c,
                                                                                                                              MYA_Year_2_Price__c,Year_2_Price__c,
                                                                                                                              MYA_Year_3_Price__c,Year_3_Price__c,
                                                                                                                              MYA_Year_4_Price__c,Year_4_Price__c,
                                                                                                                              MYA_Year_5_Price__c,Year_5_Price__c,
                                                                                                                              Apttus_QPConfig__NetAdjustmentPercent__c,
                                                                                                                              Apttus_Proposal__Proposal__c,Apttus_Proposal__Product__c,
                                                                                                                              Apttus_Proposal__Product__r.name,
                                                                                                                              Apttus_QPConfig__NetPrice__c,Apttus_QPConfig__OptionId__c,
                                                                                                                              APTS_AMS_Product_Category__c,
                                                                                                                              Apttus_QPConfig__ListPrice__c,Apttus_QPConfig__AdjustmentAmount__c,
                                                                                                                              Apttus_QPConfig__LineType__c,My_Line_Discount__c,
                                                                                                                              //Apttus_QPConfig__NetAdjustmentPercent__c,
                                                                                                                              Apttus_QPConfig__AdjustedPrice__c,Apttus_QPConfig__BaseExtendedPrice__c,
                                                                                                                              //Apttus_QPConfig__NetPrice__c
                                                                                                                              Apttus_QPConfig__BasePrice__c,
                                                                                                                              Apttus_QPConfig__LineNumber__c,
                                                                                                                              //Apttus_QPConfig__LineType__c,
                                                                                                                              APTS_Year__c
                                                                                                                         from  Apttus_Proposal__R00N70000001yUfBEAU__r)
                                                                                                     from Apttus_Proposal__Proposal__c 
                                                                                                     where id In:newProposalList]
                                                                                                    );
        return  proposalLinesMap;                                                                                   
    
    }
    
    public static void resetProposalStatus(map<Id,Apttus_Proposal__Proposal__c> newMap,map<Id,Apttus_Proposal__Proposal__c> oldMap)
    {
     for(Id propId:newMap.keyset())
     {
      Apttus_Proposal__Proposal__c oldproposal=oldMap.get(propId);
      Apttus_Proposal__Proposal__c newproposal=newMap.get(propId);
      if(newProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c)
      {
       newProposal.Apttus_Proposal__Approval_Stage__c='Draft';
      }
     }
    }
    
    
    //Update the training and consulting CheckBox
    public static void updateTrainingConsulting(list<Apttus_Proposal__Proposal__c> newProposalList)
    {
     
     map<Id,Apttus_Proposal__Proposal__c> queiredproposalInfo=QueryProposalInfo(newProposalList);
                                                                                                    
     for(Apttus_Proposal__Proposal__c proposal:newProposalList ) 
     {
      Apttus_Proposal__Proposal__c queriedProposal= queiredproposalInfo.get(proposal.id); 
      //proposal.addError(''+queriedProposal);
      Proposal.Quote_Total__c=0;
      proposal.Training_and_Consulting__c=false;
      proposal.STG_Compliance__c=false;
      proposal.Has_Discount__c=false;
      list<Apttus_Proposal__Proposal_Line_Item__c> proposalLines=queriedProposal.getSObjects('Apttus_Proposal__R00N70000001yUfBEAU__r');
      if(proposalLines!=null && proposalLines.size()>0){
         //proposal.addError(''+proposalLines.size());
         proposal.Training_and_Consulting__c=processProposalLinesForT_C(proposalLines);
         proposal.STG_Compliance__c=processProposalLinesforSTG(proposalLines);
         proposal.Has_Discount__c=processProposalLinesdiscount(proposalLines);
         Proposal.Quote_Total__c=aggregateMultiyearPrices(proposalLines);
         //updateMultiYearPrices(proposalLines);
         //proposal.COP_Template_Product_List__c=summarizeProductsOnProposal(proposalLines);
         /*if(!string.isEmpty(proposal.MYA_Term__c))
          {
           proposal.Min_Uplift_on_proposal_lines__c=processProposalLinesForMYATerm(proposal);
          }*/
         proposal.COP_Template_Product_List__c =summarizeProductsOnProposal(proposalLines);
      }
      
     }  
     
    
     return; 
    }
    
    
    
    public static void processproposalsForMinUplift(list<Apttus_Proposal__Proposal__c> newproposals)
    {
     for(Apttus_Proposal__Proposal__c proposal: newproposals)
     {
        /*if(!string.isEmpty(proposal.MYA_Term__c))
          {}*/
            proposal.Min_MYA_Uplift__c=calculateMinUplift(proposal);
            //proposal.addError('MYA'+proposal.MYA_Term__c);
          
     }
    }
    
    
    
    public static decimal calculateMinUplift( Apttus_Proposal__Proposal__c proposal)
    {
    Decimal MinimumUplift=0;
      /*for(Apttus_Proposal__Proposal__c proposal: proposalLines)
     {}*/
        /*//APTS_Year__c 
        if(proposalLine.APTS_Year__c==null || proposalLine.APTS_Year__c==1)
          continue;
        if(MinimumUplift<proposalLine.Apttus_QPConfig__NetAdjustmentPercent__c)
           MinimumUplift=proposalLine.Apttus_QPConfig__NetAdjustmentPercent__c;*/
          Decimal year2uplift=proposal.MYA_Uplift_Year_2__c!=null? proposal.MYA_Uplift_Year_2__c:0;           
          Decimal year3uplift=proposal.MYA_Uplift_Year_3__c!=null? proposal.MYA_Uplift_Year_3__c:0;   
          Decimal year4uplift=proposal.MYA_Uplift_Year_4__c!=null? proposal.MYA_Uplift_Year_4__c:0;   
          Decimal year5uplift=proposal.MYA_Uplift_Year_5__c!=null? proposal.MYA_Uplift_Year_5__c:0;   
           
           
           list<Decimal> minlist;
           
           if(proposal.MYA_Term_New__c=='5')
           minlist=new list<Decimal>{year2uplift,
                                     year3uplift,
                                     year4uplift,
                                     year5uplift};                                     
           else if(proposal.MYA_Term_New__c=='4')
           minlist=new list<Decimal>{year2uplift,
                                     year3uplift,
                                     year4uplift
                                     }; 
           else if (proposal.MYA_Term_New__c=='3')
           minlist=new list<Decimal>{year2uplift,
                                     year3uplift                                     
                                     };
           else if (proposal.MYA_Term_New__c=='2')
           minlist=new list<Decimal>{year2uplift                                                                        
                                     };                          
           else
           minlist=new list<Decimal>{null                                    
                                     };                          
                                                              
                                     
           minlist.sort();
           //proposal.Min_MYA_Uplift__c=minlist[0];                                        
           MinimumUplift=minlist[0];    
     
     
     return MinimumUplift;
    }
    
   
   
    public static boolean processProposalLinesForT_C(list< Apttus_Proposal__Proposal_Line_Item__c> proposalLines)
    {
     for(Apttus_Proposal__Proposal_Line_Item__c proposalLine: proposalLines)
     {
          if(string.isEmpty(proposalLine.Product_Type__c) 
              || proposalLine.Product_Type__c!=APTSConstants.Training_Consulting)
              Continue;
              
              Double NetAdjustment= (proposalLine.Apttus_QPConfig__NetAdjustmentPercent__c!=null)?proposalLine.Apttus_QPConfig__NetAdjustmentPercent__c:0;
              if(NetAdjustment<0)
              {  
               return true; 
              }
     }
     
     return false;
    }
    
    public static boolean processProposalLinesforSTG(list< Apttus_Proposal__Proposal_Line_Item__c> proposalLines)
    {
     for(Apttus_Proposal__Proposal_Line_Item__c proposalLine: proposalLines)
     {
          if(proposalLine.Product_Family__c==APTSConstants.Compliance_Services)
          {
            return true;
          }
     }
     
     return false;
    }
    
    public static boolean processProposalLinesdiscount(list< Apttus_Proposal__Proposal_Line_Item__c> proposalLines)
    {
     for(Apttus_Proposal__Proposal_Line_Item__c proposalLine: proposalLines)
     {
          if(proposalLine.Apttus_QPConfig__NetAdjustmentPercent__c<0)
          {
            return true;
          }
     }
     
     return false;
    }
    
   /*
     Mehtod: processproposalLinesUpdates
     Purpose: Copy over the formula fields values into the decimal fields for the purpose of syncying with opportunity lines.
   */

    /* public static void processproposalLinesUpdates(map<Id,Apttus_Proposal__Proposal__c> newProposalMap,map<Id,Apttus_Proposal__Proposal__c> oldProposalmap)
    {
        
        if(newProposalMap.keyset()==null && newProposalMap.keyset().size()==0)
        return;
        
        set<Id> draftProposals=new set<Id>();
        for(Id propId:newProposalMap.keyset())
        {
         Apttus_Proposal__Proposal__c newProposal=newProposalMap.get(propId);
         Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         
         //Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         //newProposal.addError('test');
         
         if(newProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c
            
            ) 
         {
          //newProposal.Apttus_Proposal__Approval_Stage__c='Draft';
          draftProposals.add(newProposal.id);
         }
        }
        map<Id,Apttus_Proposal__Proposal__c> QueryProposalMap=QueryProposalInfo( newProposalMap.values());
        list<Apttus_Proposal__Proposal__c> aggregateproposals= new list<Apttus_Proposal__Proposal__c>();
        list<Apttus_Proposal__Proposal_Line_Item__c> AllproposalLinesList=new list<Apttus_Proposal__Proposal_Line_Item__c>();
        for(Id propId:draftProposals)
        {
         Apttus_Proposal__Proposal__c newProposal=newProposalMap.get(propId);
         Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         Apttus_Proposal__Proposal__c queriedproposal=QueryProposalMap.get(propId);
         
         
            list<Apttus_Proposal__Proposal_Line_Item__c> proposalLinesList=queriedproposal.getSObjects('Apttus_Proposal__R00N70000001yUfBEAU__r');
            if(proposalLinesList!=null && proposalLinesList.size()>0)
            {
             list<Apttus_Proposal__Proposal_Line_Item__c> updatedProposalLinesList= updateMultiYearPrices(proposalLinesList);
             //newProposal.addError('Error Test 1');
             AllproposalLinesList.addAll(updatedProposalLinesList);
             newProposal.Quote_Total__c=aggregateMultiyearPrices(proposalLinesList);
             //aggregateproposals.add(newProposal);
            }
         }
       update  AllproposalLinesList;
       //update aggregateproposals;
    }
    
    
    public static list< Apttus_Proposal__Proposal_Line_Item__c> updateMultiYearPrices(list< Apttus_Proposal__Proposal_Line_Item__c> proposalLines)
    {
     decimal myaTotalPrice=0;
     for(Apttus_Proposal__Proposal_Line_Item__c proposalLine: proposalLines)
     {
      myaTotalPrice+=proposalLine.MYA_Total_Price__c;
      proposalLine.MYA_Year_2_Price__c=proposalLine.Year_2_Price__c;
      proposalLine.MYA_Year_3_Price__c=proposalLine.Year_3_Price__c;
      proposalLine.MYA_Year_4_Price__c=proposalLine.Year_4_Price__c;
      proposalLine.MYA_Year_5_Price__c=proposalLine.Year_5_Price__c;
      proposalLine.MYA_All_Years_Total_Price__c=     proposalLine.MYA_Total_Price__c;
     }
     return proposalLines;
    }
    
    */
    public static decimal aggregateMultiyearPrices(list< Apttus_Proposal__Proposal_Line_Item__c> proposalLines)
    {
     decimal myaTotalPrice=0;
     for(Apttus_Proposal__Proposal_Line_Item__c proposalLine: proposalLines)
     {
      if(proposalLine.Apttus_QPConfig__LineType__c=='Product/Service')  
        myaTotalPrice+=proposalLine.MYA_Total_Price__c;
     }
    return myaTotalPrice;
    }
    
    //For Creating the template lines associated with the proposal line items.
    public static void processproposalLinesforTemplates(map<Id,Apttus_Proposal__Proposal__c> newProposalMap,map<Id,Apttus_Proposal__Proposal__c> oldProposalmap)
    {
        if(newProposalMap.keyset()==null && newProposalMap.keyset().size()==0)
        return;
        
        set<Id> draftProposals=new set<Id>();
        for(Id propId:newProposalMap.keyset())
        {
         Apttus_Proposal__Proposal__c newProposal=newProposalMap.get(propId);
         Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         
         //Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         
         if(newProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c
            
            ) 
         {
          //newProposal.Apttus_Proposal__Approval_Stage__c='Draft';
          draftProposals.add(newProposal.id);
         }
        }
        map<Id,Apttus_Proposal__Proposal__c> QueryProposalMap=QueryProposalInfo( newProposalMap.values());
        delete [select id FROM Template_Line_item__c where Quote_Proposal__c In:draftProposals];
        list<Template_Line_item__c> AllTemplateLinesList=new list<Template_Line_item__c>();
        for(Id propId:draftProposals)
        {
         Apttus_Proposal__Proposal__c newProposal=newProposalMap.get(propId);
         Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         Apttus_Proposal__Proposal__c queriedproposal=QueryProposalMap.get(propId);
         //newProposal.addError('Error Test 1');
         
         list<Apttus_Proposal__Proposal_Line_Item__c> proposalLinesList=queriedproposal.getSObjects('Apttus_Proposal__R00N70000001yUfBEAU__r');
            if(proposalLinesList!=null && proposalLinesList.size()>0)
            {
            
             list<Template_Line_item__c> templatelinesforProposal=syncQuoteLineswithTemplateLines(proposalLinesList);
             AllTemplateLinesList.addAll(templatelinesforProposal);
            }
         
        }
        insert AllTemplateLinesList; 
     
    }
    
   
   //For Creating the template lines associated with the proposal line items.
    public static list<Template_Line_item__c> syncQuoteLineswithTemplateLines(list<Apttus_Proposal__Proposal_Line_Item__c> currentproposalLines)
      {
        
        
        list<Template_Line_item__c> TemplateLinesList=new list<Template_Line_item__c>();
        if(currentproposalLines!=null && currentproposalLines.size()>0){
         
          
          
         
          map<string,Apttus_Proposal__Proposal_Line_Item__c> OptionTotalMap=new map<string,Apttus_Proposal__Proposal_Line_Item__c>();
          map<string,Apttus_Proposal__Proposal_Line_Item__c> categorySubjectMap=new map<string,Apttus_Proposal__Proposal_Line_Item__c>();
          map<string,Apttus_Proposal__Proposal_Line_Item__c> bundleTotalsMap=new map<string,Apttus_Proposal__Proposal_Line_Item__c>();
          
          // process the proposal lines and create the template total lines.
          for(Apttus_Proposal__Proposal_Line_Item__c proposalLine:currentproposalLines)
          {
           Apttus_Proposal__Proposal_Line_Item__c totalPLIRecord=new Apttus_Proposal__Proposal_Line_Item__c();  
           string category_Bundle='';
           /*
           ** for creating template lines for subtotals with same bundles and categories
           **
           */
           if(!string.IsEmpty(proposalLine.Apttus_QPConfig__OptionId__c))
           { 
            /*Decimal CurrentAdjAmount=(proposalLine.Apttus_QPConfig__AdjustedPrice__c!=null?proposalLine.Apttus_QPConfig__AdjustedPrice__c:0)
                                      -(proposalLine.Apttus_QPConfig__BaseExtendedPrice__c!=null?proposalLine.Apttus_QPConfig__BaseExtendedPrice__c:0);
             */
              Decimal CurrentAdjAmount=(proposalLine.Apttus_QPConfig__BaseExtendedPrice__c!=null?proposalLine.Apttus_QPConfig__BaseExtendedPrice__c:0)
                                    -(proposalLine.Apttus_QPConfig__NetPrice__c!=null?proposalLine.Apttus_QPConfig__NetPrice__c:0);
                                       
                                      /*Apttus_QPConfig__NetPrice__c*/
            if(string.isEmpty(proposalLine.Apttus_Proposal__Product__c) || string.isEmpty(proposalLine.APTS_AMS_Product_Category__c))
            {
             //OptionTotalMap.put('Default',0);
             Continue;
            }
            string keystring=proposalLine.Apttus_Proposal__Product__c +'|'+proposalLine.APTS_AMS_Product_Category__c;
            if(OptionTotalMap.containsKey(keystring))
            {
             totalPLIRecord =OptionTotalMap.get(keystring);
             totalPLIRecord.Apttus_QPConfig__NetPrice__c=(totalPLIRecord.Apttus_QPConfig__NetPrice__c!=null)?totalPLIRecord.Apttus_QPConfig__NetPrice__c:0;
             
             Decimal optionAmount=(proposalLine.Apttus_QPConfig__NetPrice__c!=null)?proposalLine.Apttus_QPConfig__NetPrice__c:0;
             totalPLIRecord.Apttus_QPConfig__NetPrice__c=totalPLIRecord.Apttus_QPConfig__NetPrice__c+optionAmount;
             
            // Apttus_QPConfig__ListPrice__c,Apttus_QPConfig__AdjustmentAmount__c
            totalPLIRecord.Apttus_QPConfig__ListPrice__c=(totalPLIRecord.Apttus_QPConfig__ListPrice__c!=null)?totalPLIRecord.Apttus_QPConfig__ListPrice__c:0;
            Decimal optionListPrice=(proposalLine.Apttus_QPConfig__ListPrice__c!=null)?proposalLine.Apttus_QPConfig__ListPrice__c:0;
            totalPLIRecord.Apttus_QPConfig__ListPrice__c=totalPLIRecord.Apttus_QPConfig__ListPrice__c+optionListPrice;
            
            totalPLIRecord.Apttus_QPConfig__AdjustmentAmount__c=(totalPLIRecord.Apttus_QPConfig__AdjustmentAmount__c+CurrentAdjAmount); 
            
            //aggregate the base price
            Decimal optionbasePrice=(proposalLine.Apttus_QPConfig__BasePrice__c!=null)?proposalLine.Apttus_QPConfig__BasePrice__c:0; 
            totalPLIRecord.Apttus_QPConfig__BasePrice__c=totalPLIRecord.Apttus_QPConfig__BasePrice__c+optionbasePrice;   
             
             //totalPLIRecord.Apttus_QPConfig__NetPrice__c=totalPLIRecord.Apttus_QPConfig__NetPrice__c+optionAmount;
             OptionTotalMap.put(keystring,totalPLIRecord);
             
            }
            else
            {
             //populate ams category
             
             totalPLIRecord.Apttus_Proposal__Product__c=proposalLine.Apttus_Proposal__Product__c;
             totalPLIRecord.Apttus_Proposal__Proposal__c=proposalLine.Apttus_Proposal__Proposal__c;
             totalPLIRecord.Apttus_QPConfig__NetPrice__c=(proposalLine.Apttus_QPConfig__NetPrice__c!=null)?proposalLine.Apttus_QPConfig__NetPrice__c:0;
             totalPLIRecord.Apttus_QPConfig__ListPrice__c=(proposalLine.Apttus_QPConfig__ListPrice__c!=null)?proposalLine.Apttus_QPConfig__ListPrice__c:0;
             totalPLIRecord.Apttus_QPConfig__BasePrice__c=(proposalLine.Apttus_QPConfig__BasePrice__c!=null)?proposalLine.Apttus_QPConfig__BasePrice__c:0;
             //Decimal CurrentAdjAmount=proposalLine.Apttus_QPConfig__AdjustedPrice__c-proposalLine.Apttus_QPConfig__BaseExtendedPrice__c;
             totalPLIRecord.Apttus_QPConfig__AdjustmentAmount__c=CurrentAdjAmount;
             
             OptionTotalMap.put(keystring,totalPLIRecord);
            }
           }
           
          }
          
          map<string,Template_Line_item__c> TemplateLinesmap=new map<string,Template_Line_item__c>();
          /*TemplateLinesList.add(new Template_Line_item__c(name='Bundle Total Record Test'
                                                            ,Quote_Proposal__c=proposalLine1.Apttus_Proposal__Proposal__c
                                                            ));*/
          for(Apttus_Proposal__Proposal_Line_Item__c proposalLine:currentproposalLines)
          {
           
           Template_Line_item__c TLIforBundle= new Template_Line_item__c();
           TLIforBundle.Quote_Proposal__c=proposalLine.Apttus_Proposal__Proposal__c;
           //TLIforBundle.name='Bundle Total Record test';
           //TemplateLinesList.add(TLIforBundle);
           
           
           //if( string.IsEmpty(proposalLine.Apttus_QPConfig__OptionId__c)
             // )
              //continue;
            if(!string.isEmpty(proposalLine.Apttus_QPConfig__LineType__c)
               && proposalLine.Apttus_QPConfig__LineType__c!='Product/Service'
             )  
             Continue;
            if(!TemplateLinesmap.containsKey(proposalLine.Apttus_Proposal__Product__c)) { 
             
             TLIforBundle.name='Bundle Total Record';
             TLIforBundle.AMS_Product_Category__c='zzzzz';
             TLIforBundle.Quote_Proposal__c=proposalLine.Apttus_Proposal__Proposal__c;
             TLIforBundle.Product__c=proposalLine.Apttus_Proposal__Product__c;
             TLIforBundle.Bundle_Total_Net_Price__c=(proposalLine.Apttus_QPConfig__NetPrice__c!=null)?proposalLine.Apttus_QPConfig__NetPrice__c:0;
            TemplateLinesmap.put(proposalLine.Apttus_Proposal__Product__c,TLIforBundle);
            }
            else
            {
             TLIforBundle=TemplateLinesmap.get(proposalLine.Apttus_Proposal__Product__c);
             Decimal exBunldeTotal=(TLIforBundle.Bundle_Total_Net_Price__c!=null)?TLIforBundle.Bundle_Total_Net_Price__c:0;
             Decimal currentBunldeprice=(proposalLine.Apttus_QPConfig__NetPrice__c!=null)?proposalLine.Apttus_QPConfig__NetPrice__c:0;
             TLIforBundle.Bundle_Total_Net_Price__c=currentBunldeprice+exBunldeTotal;
             
             TemplateLinesmap.put(proposalLine.Apttus_Proposal__Product__c,TLIforBundle);
            
            }
            
            
            
           
          }
          
          if(TemplateLinesmap.values()!=null && TemplateLinesmap.values().size()>0)
          {
           TemplateLinesList.addALL(TemplateLinesmap.values());
          }
         
          
          //create template lines for each proposal line
          map<string,Template_Line_item__c> TLIMap=new map<string,Template_Line_item__c>();
          //Integer i=0;
          for(Apttus_Proposal__Proposal_Line_Item__c proposalLine:currentproposalLines)
          {
            string IdStr=(proposalLine.Apttus_QPConfig__LineType__c=='Product/Service' )?proposalLine.Apttus_Proposal__Product__c
                                                                                        :(proposalLine.Apttus_QPConfig__LineType__c=='Option')?(proposalLine.Apttus_QPConfig__OptionId__c):
                                                                                          'default';
            idStr=idStr+proposalLine.Apttus_QPConfig__LineNumber__c;                                                                              
            //i=i+1;                                                                              
            Template_Line_item__c TLI=new Template_Line_item__c();
            TLI.name='QLI-Record';
            TLI.Product__c=proposalLine.Apttus_Proposal__Product__c;
            TLI.Quote_Proposal__c=proposalLine.Apttus_Proposal__Proposal__c;
            TLI.Proposal_Line_Item__c=proposalLine.id;
            //templateLinesMap.put();
            TLIMap.put(IdStr,TLI);
            //TemplateLinesList.add(TLI);
           
          }
          if(TLIMap.values()!=null && TLIMap.values().size()>0)
          TemplateLinesList.addALL(TLIMap.values());
          
          for(string keystr:OptionTotalMap.keyset())
          {
           string str1=(keystr!=null)?keystr.substring(keystr.indexOf('|'),keystr.length()).replace('|',''):'';
           Apttus_Proposal__Proposal_Line_Item__c proposalLine1=OptionTotalMap.get(keystr);
            Template_Line_item__c TLI=new Template_Line_item__c();
            TLI.name='Total(AMS Product Category)';
            TLI.AMS_Product_Category__c=str1;
            TLI.Proposal_Line_Item__c=proposalLine1.id;
            TLI.Quote_Proposal__c=proposalLine1.Apttus_Proposal__Proposal__c;
            TLI.Product__c=proposalLine1.Apttus_Proposal__Product__c;
            TLI.Proposal_Line_Item__c=null;
            TLI.Total_Price__c=proposalLine1.Apttus_QPConfig__NetPrice__c;
            TLI.Total_List_Price__c=proposalLine1.Apttus_QPConfig__ListPrice__c;            
            TLI.Total_Base_Price__c=proposalLine1.Apttus_QPConfig__BasePrice__c;
            TLI.Total_Adjustment_Amount__c=proposalLine1.Apttus_QPConfig__AdjustmentAmount__c*-1; 
            //templateLinesMap.put();
            TemplateLinesList.add(TLI);
            
            Template_Line_item__c TLI1=new Template_Line_item__c();
            TLI1.name='Header AMS';
            TLI1.AMS_Product_Category__c=str1;
            TLI1.Display_AMS_product_Category__c=str1;
            TLI1.Proposal_Line_Item__c=proposalLine1.id;
            TLI1.Quote_Proposal__c=proposalLine1.Apttus_Proposal__Proposal__c;
            TLI1.Product__c=proposalLine1.Apttus_Proposal__Product__c;
            TLI1.Proposal_Line_Item__c=null;
            //TLI1.Total_Price__c=proposalLine1.Apttus_QPConfig__NetPrice__c;
            //templateLinesMap.put();
            TemplateLinesList.add(TLI1);
            
          }
         
          
        }
        
        return TemplateLinesList;
        
      } 
      
      
      
      public static void updateQuoteStage(list<Apttus_Proposal__Proposal__c> newList)
      {
       for(Apttus_Proposal__Proposal__c proposal: newList)
       {
        if(proposal.Apttus_Proposal__Approval_Stage__c!=null 
           && proposal.Apttus_Proposal__Approval_Stage__c.equals('Presented'))
           {
            proposal.Apttus_Proposal__Approval_Stage__c='Submitted to COP';
           }
       } 
      }
      
      /*public static void processProposalLinesforProductSummary(map<Id,Apttus_Proposal__Proposal_Line_Item__c> newProposalMap ,map<Id,Apttus_Proposal__Proposal_Line_Item__c> oldProposal)
      {
         Apttus_Proposal__Proposal__c newProposal=newProposalMap.get(propId);
         Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         
         //Apttus_Proposal__Proposal__c oldProposal=oldProposalmap.get(propId);
         
         if(newProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c
            
            ) 
         {
          //newProposal.Apttus_Proposal__Approval_Stage__c='Draft';
          draftProposals.add(newProposal.id);
         }
         map<Id,Apttus_Proposal__Proposal__c> QueryProposalMap=QueryProposalInfo( newProposalMap.values());
        }*/
        
      
      
      public static string summarizeProductsOnProposal(list<Apttus_Proposal__Proposal_Line_Item__c> newProposalLines)
      {
       string summaryList='';
       set<string> products=new set<string>();  
       for(Apttus_Proposal__Proposal_Line_Item__c proposalLine:newProposalLines)
       {
        if(proposalLine.Apttus_QPConfig__LineType__c!=null && proposalLine.Apttus_QPConfig__LineType__c.equals('Product/Service'))
        products.add(proposalLine.Apttus_Proposal__Product__r.name);
        //summaryList+=proposalLine.Apttus_Proposal__Product__r.name;
       }
       summaryList=(products.size()>0)?string.join(new list<string>(products),';'):'';
       // prevent the error
       if(summaryList.length()>32000)
       {
        summaryList=summaryList.substring(0,3200);
       }
       return summaryList;
      }
      
      public static void enforeRepricingLineItems(List<Apttus_Proposal__Proposal__c> proposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        Set<Id> proposalIdSet = new Set<Id>();
        
        system.debug('proposalList START :::::::::::::::::::::::::::::: ' + proposalList);
        
        for(Apttus_Proposal__Proposal__c proposalObj : proposalList) {
            Apttus_Proposal__Proposal__c oldProposalObj = oldProposalMap.get(proposalObj.Id);
            
            if(proposalObj.APTS_Enforce_Repricing__c != oldProposalObj.APTS_Enforce_Repricing__c && proposalObj.APTS_Enforce_Repricing__c == true) {
                proposalIdSet.add(proposalObj.Id);
            }
        }
        
        system.debug('proposalIdSet :::::::::::::::::::::::::' + proposalIdSet);
        
        if(proposalIdSet.isEmpty()) {
            return;
        }
        
        List<Apttus_Config2__ProductConfiguration__c> productConfigList = [Select Apttus_QPConfig__Proposald__c, 
            (Select Apttus_Config2__PricingStatus__c, Apttus_Config2__OptionId__c, Apttus_Config2__ProductId__c, APTS_Promo_Code__c, 
            APTPS_PromoDiscountApplied__c, APTS_Needs_Repricing__c, Apttus_Config2__LineNumber__c From Apttus_Config2__LineItems__r) 
            From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN :proposalIdSet AND 
            Apttus_Config2__Status__c NOT IN ('New', 'Superseded', 'Abandoned')];
            
        system.debug('productConfigList :::::::::::::::::::::: ' + productConfigList);
            
        if(productConfigList.isEmpty()) {
            for(Apttus_Proposal__Proposal__c proposalObj : proposalList) {
                Apttus_Proposal__Proposal__c oldProposalObj = oldProposalMap.get(proposalObj.Id);
                
                if(proposalObj.APTS_Enforce_Repricing__c != oldProposalObj.APTS_Enforce_Repricing__c && proposalObj.APTS_Enforce_Repricing__c == true) {
                    proposalObj.APTS_Enforce_Repricing__c = false;
                }
            }
            
            return;
        }
        
        Map<Id, List<Apttus_Config2__LineItem__c>> proposalWiseLineItemsMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        Map<Id,Id> ConfigToProposalMap=new Map<Id,Id>();
        
        for(Apttus_Config2__ProductConfiguration__c prodConfigObj : productConfigList) {
            List<Apttus_Config2__LineItem__c> lineItems = prodConfigObj.Apttus_Config2__LineItems__r;
            
            if(!lineItems.isEmpty()) {
                Id proposalId = prodConfigObj.Apttus_QPConfig__Proposald__c;
                ConfigToProposalMap.put(prodConfigObj.Id,proposalId);
                List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalId);
                
                if(proposalLineItems == null) {
                    proposalLineItems = new List<Apttus_Config2__LineItem__c>();
                    proposalWiseLineItemsMap.put(proposalId, proposalLineItems);
                }
                
                proposalLineItems.addAll(lineItems);
            }
        }
        
        system.debug('proposalWiseLineItemsMap ::::::::::::::::::::::::: ' + proposalWiseLineItemsMap);
        
        List<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
        
         List<Apttus_Config2__LineItem__c> proposalLineItemsForPromo=[ Select Apttus_Config2__PricingStatus__c,Apttus_Config2__ConfigurationId__c, Apttus_Config2__ChargeType__c, 
                                                            Apttus_Config2__ProductOptionId__c, Apttus_Config2__OptionId__c, APTS_Product_Configuration_Type__c, 
                                                            Apttus_Config2__ProductId__c, APTS_MYA_Lines_Unique_Key__c, Apttus_Config2__StartDate__c,
                                                            Apttus_Config2__EndDate__c, Apttus_Config2__SellingTerm__c, Apttus_Config2__LineNumber__c,
                                                            Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__Quantity__c, APTS_Promo_Code__c,
                                                            APTPS_PromoDiscountApplied__c,Has_Promotions__c
                                                            From Apttus_Config2__LineItem__c 
                                                            Where Apttus_Config2__ConfigurationId__c in : ConfigToProposalMap.keySet()];
                                                            
        Map<Id, List<Apttus_Config2__LineItem__c>> proposalWiseLineItemsMapForPromo = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        if(proposalLineItemsForPromo!=null)
        {
            for(Apttus_Config2__LineItem__c lineLocal:proposalLineItemsForPromo)
            {
                List<Apttus_Config2__LineItem__c> lineItems=proposalWiseLineItemsMapForPromo.get(ConfigToProposalMap.get(lineLocal.Apttus_Config2__ConfigurationId__c));
                if(lineItems==null)
                {
                   lineItems=new List<Apttus_Config2__LineItem__c>();
                   proposalWiseLineItemsMapForPromo.put(ConfigToProposalMap.get(lineLocal.Apttus_Config2__ConfigurationId__c),lineItems);
                }
                lineItems.add(lineLocal);
            }
        }
        
        
        for(Apttus_Proposal__Proposal__c proposalObj : proposalList) {
            Apttus_Proposal__Proposal__c oldProposalObj = oldProposalMap.get(proposalObj.Id);
            
            if(proposalObj.APTS_Enforce_Repricing__c != oldProposalObj.APTS_Enforce_Repricing__c && proposalObj.APTS_Enforce_Repricing__c == true) {
                List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalObj.Id);
                
                system.debug('proposalLineItems :::::::::::::::::::: ' + proposalLineItems);
                
                if(!proposalLineItems.isEmpty()) {
                    List<Id> lineItemIds=new List<Id>();
                    
                    List<Apttus_Config2__LineItem__c> updatedLineItems = APTS_Pricing_Helper.applyPromoCodes(proposalObj, proposalWiseLineItemsMapForPromo.get(proposalObj.Id));
                    
                    system.debug('updatedLineItems :::::::::::::::::::::::: ' + updatedLineItems);
                    
                    if(!updatedLineItems.isEmpty()) {
                        allLineItems.addAll(updatedLineItems);
                    }
                }
            }
            
            proposalObj.APTS_Enforce_Repricing__c = false;
        }
        
        system.debug('allLineItems :::::::::::::::::::: ' + allLineItems);
        
        if(!allLineItems.isEmpty()) {
            
            for(Apttus_Config2__LineItem__c lineItemObj : allLineItems) {
                lineItemObj.Apttus_Config2__PricingStatus__c = 'Pending';
                lineItemObj.APTS_Needs_Repricing__c = true;
            }
            
            update allLineItems;
        }
        
        system.debug('proposalList END :::::::::::::::::::::::::::::: ' + proposalList);
    }
    
    public static void enforcePricingForstubdateUpdates(map<Id,Apttus_Proposal__Proposal__c> NewProposalmap, map<Id,Apttus_Proposal__Proposal__c> OldProposalmap) {
        Set<Id> proposalIdSet = new Set<Id>();
        
        for(Id proposalId : NewProposalmap.keyset()) {
            Apttus_Proposal__Proposal__c newproposal = NewProposalmap.get(proposalId);
            Apttus_Proposal__Proposal__c oldproposal = OldProposalmap.get(proposalId);
            
            if((newproposal.Stub_Start_Date__c != oldproposal.Stub_Start_Date__c || newproposal.Stub_End_Date__c != oldproposal.Stub_End_Date__c ) || 
                (newproposal.Stubs_Year_Quote__c != oldproposal.Stubs_Year_Quote__c)) {
            
                proposalIdSet.add(proposalId);
            }
        }
        
        if(proposalIdSet.isEmpty()) {
            return;
        }
        
        List<Apttus_Config2__ProductConfiguration__c> productConfigList = [Select Apttus_QPConfig__Proposald__c, 
            (Select Apttus_Config2__PricingStatus__c, APTS_Needs_Repricing__c From Apttus_Config2__LineItems__r) 
            From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN :proposalIdSet AND 
            Apttus_Config2__Status__c NOT IN ('New', 'Superseded', 'Abandoned')];
            
        if(productConfigList.isEmpty()) {
            return;
        }
            
        Map<Id, List<Apttus_Config2__LineItem__c>> proposalWiseLineItemsMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        
        for(Apttus_Config2__ProductConfiguration__c prodConfigObj : productConfigList) {
            List<Apttus_Config2__LineItem__c> lineItems = prodConfigObj.Apttus_Config2__LineItems__r;
            
            if(!lineItems.isEmpty()) {
                Id proposalId = prodConfigObj.Apttus_QPConfig__Proposald__c;
                
                List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalId);
                
                if(proposalLineItems == null) {
                    proposalLineItems = new List<Apttus_Config2__LineItem__c>();
                    proposalWiseLineItemsMap.put(proposalId, proposalLineItems);
                }
                
                proposalLineItems.addAll(lineItems);
            }
        }
        
        List<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
        
        for(Id proposalId : NewProposalmap.keyset()) {
            Apttus_Proposal__Proposal__c newproposal = NewProposalmap.get(proposalId);
            Apttus_Proposal__Proposal__c oldproposal = OldProposalmap.get(proposalId);
            
            if(proposalIdSet.contains(proposalId)) {
                List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalId);
                
                for(Apttus_Config2__LineItem__c lineItemObj : proposalLineItems) {
                    lineItemObj.Apttus_Config2__PricingStatus__c = 'Pending';
                    lineItemObj.APTS_Needs_Repricing__c = true;
                }
                
                allLineItems.addAll(proposalLineItems);
            }
        }
        
        system.debug('allLineItems :::::::::::::::::::: ' + allLineItems);
        
        if(!allLineItems.isEmpty()) {
            update allLineItems;
        }
    }

    //Created by Kalyan for changes in Number_of_Concurrent_Users__c  
    public static void enforcePricingForConcurrentUsers(map<Id,Apttus_Proposal__Proposal__c> NewProposalmap, map<Id,Apttus_Proposal__Proposal__c> OldProposalmap) {
      Set<Id> proposalIdSet = new Set<Id>();
        
      for(Id proposalId : NewProposalmap.keyset()) {
          Apttus_Proposal__Proposal__c newproposal = NewProposalmap.get(proposalId);
          Apttus_Proposal__Proposal__c oldproposal = OldProposalmap.get(proposalId);
          
          if(newproposal.Number_of_Concurrent_Users__c != oldproposal.Number_of_Concurrent_Users__c || newproposal.Number_of_Concurrent_Users__c != oldproposal.Number_of_Concurrent_Users__c ) 
           {
          
            proposalIdSet.add(proposalId);
          }
      }
      
      if(proposalIdSet.isEmpty()) {
            return;
        }
        
        List<Apttus_Config2__ProductConfiguration__c> productConfigList = [Select Apttus_QPConfig__Proposald__c, 
            (Select Apttus_Config2__PricingStatus__c, APTS_Needs_Repricing__c From Apttus_Config2__LineItems__r) 
            From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN :proposalIdSet AND 
            Apttus_Config2__Status__c NOT IN ('New', 'Superseded', 'Abandoned')];
            
        if(productConfigList.isEmpty()) {
          return;
        }
            
        Map<Id, List<Apttus_Config2__LineItem__c>> proposalWiseLineItemsMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        
        for(Apttus_Config2__ProductConfiguration__c prodConfigObj : productConfigList) {
            List<Apttus_Config2__LineItem__c> lineItems = prodConfigObj.Apttus_Config2__LineItems__r;
            
            if(!lineItems.isEmpty()) {
                Id proposalId = prodConfigObj.Apttus_QPConfig__Proposald__c;
                
                List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalId);
                
                if(proposalLineItems == null) {
                    proposalLineItems = new List<Apttus_Config2__LineItem__c>();
                    proposalWiseLineItemsMap.put(proposalId, proposalLineItems);
                }
                
                proposalLineItems.addAll(lineItems);
            }
        }
        
        List<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
        
        for(Id proposalId : NewProposalmap.keyset()) {
          Apttus_Proposal__Proposal__c newproposal = NewProposalmap.get(proposalId);
          Apttus_Proposal__Proposal__c oldproposal = OldProposalmap.get(proposalId);
          
          if(proposalIdSet.contains(proposalId)) {
            List<Apttus_Config2__LineItem__c> proposalLineItems = proposalWiseLineItemsMap.get(proposalId);
            
            for(Apttus_Config2__LineItem__c lineItemObj : proposalLineItems) {
                  lineItemObj.Apttus_Config2__PricingStatus__c = 'Pending';
                  lineItemObj.APTS_Needs_Repricing__c = true;
              }
              
              allLineItems.addAll(proposalLineItems);
          }
        }
        
        system.debug('allLineItems :::::::::::::::::::: ' + allLineItems);
        
        if(!allLineItems.isEmpty()) {
            update allLineItems;
        }
    }
    
    /*
    public static void addRemoveMYALines(List<Apttus_Proposal__Proposal__c> proposalList, Map<Id, Apttus_Proposal__Proposal__c> newProposalMap, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        Set<Id> addProposalIdSet = new Set<Id>();
        Set<Id> removeProposalIdSet = new Set<Id>();
        
        for(Apttus_Proposal__Proposal__c proposalObj : proposalList) {
            Apttus_Proposal__Proposal__c oldProposalObj = oldProposalMap.get(proposalObj.Id);
            
            if(proposalObj.MYA_Term__c != oldProposalObj.MYA_Term__c && oldProposalObj.MYA_Term__c != null) {
                if(proposalObj.MYA_Term__c == null || proposalObj.MYA_Term__c == '') {
                    removeProposalIdSet.add(proposalObj.Id);
                } else if(proposalObj.MYA_Term__c < oldProposalObj.MYA_Term__c) {
                    removeProposalIdSet.add(proposalObj.Id);
                } else if(proposalObj.MYA_Term__c > oldProposalObj.MYA_Term__c) {
                    addProposalIdSet.add(proposalObj.Id);
                }
            }
        }
        
        if(addProposalIdSet.isEmpty() && removeProposalIdSet.isEmpty()) {
            return;
        }
        
        List<Apttus_Config2__ProductConfiguration__c> productConfigList = [Select Apttus_QPConfig__Proposald__c, 
            (Select Apttus_Config2__PricingStatus__c, Apttus_Config2__OptionId__c, Apttus_Config2__ProductId__c, APTS_Promo_Code__c, 
            APTPS_PromoDiscountApplied__c, Apttus_Config2__LineNumber__c, APTS_Product_Configuration_Type__c, Apttus_Config2__ProductOptionId__c,
            Apttus_Config2__Quantity__c,APTS_MYA_Lines_Unique_Key__c, Apttus_Config2__StartDate__c, Apttus_Config2__EndDate__c, Apttus_Config2__SellingTerm__c 
            From Apttus_Config2__LineItems__r Where APTS_Year__c = 1) 
            From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN :addProposalIdSet AND 
            Apttus_Config2__Status__c NOT IN ('New', 'Superseded', 'Abandoned')];
            
        if(productConfigList.isEmpty()) {
            return;
        }
        
        Map<Id, List<Apttus_Config2__LineItem__c>> proposalWiseLineItemsMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        
        for(Apttus_Config2__ProductConfiguration__c prodConfigObj : productConfigList) {
            List<Apttus_Config2__LineItem__c> lineItems = prodConfigObj.Apttus_Config2__LineItems__r;
            
            if(!lineItems.isEmpty()) {
                Id proposalId = prodConfigObj.Apttus_QPConfig__Proposald__c;
                Apttus_Proposal__Proposal__c oldProposalObj = oldProposalMap.get(proposalId);
                Apttus_Proposal__Proposal__c newProposalObj = newProposalMap.get(proposalId);
                
                Integer termsToAdd = Integer.valueOf(newProposalObj.MYA_Term__c) - Integer.valueOf(oldProposalObj.MYA_Term__c);
                
                if(termsToAdd > 0) {
                    APTS_Pricing_Helper.addAdditionalMYALines(lineItems, termsToAdd, newProposalObj.Stubs_Year_Quote__c, prodConfigObj.Id);
                }
            }
        }
    } 
    */ 
      
}