/*
 * trigger handler class for trigger TSM_CampaignMemberTrigger on CampaignMember Object.
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 12/16/2016 Vinay				1.0			Initial draft 
 * 05/05/2017 Piyush			1.1			SMS-753 Campaign Member Code Error
 * 06/26/2017 Piyush			1.2         SMS-857 Prevent new Lead creation when Sales Alignment is blank
 * 07/27/2017 Shivaji			1.2         SMS-866
 * ------------------------------------------------------------------------- */
public class TSM_CampaignMemberTriggerHandler {
   
	//set the Sales Alignment field from related contact on create.
	//public static void setFieldsOnCreate(List<CampaignMember> newCampaignMembers, Boolean isNewRecord) {
	public static void setFieldsOnCreate(List<CampaignMember> newCampaignMembers) {	
		if(newCampaignMembers != null && !newCampaignMembers.isEmpty()){
    		List<Id> contactIdList = new List<Id>();
    		List<Id> leadIdList = new List<Id>();
    		for(CampaignMember cm : newCampaignMembers){
    			if(/*(cm.Is_Latest_Record__c || isNewRecord) && */ cm.ContactId != null){
    				contactIdList.add(cm.ContactId);
    			} else if(cm.LeadId != null) {
    				leadIdList.add(cm.LeadId);
    			}
			}
			if(contactIdList != null && !contactIdList.isEmpty()){
				Map<Id, Contact> contactMap = new Map<Id, Contact>([Select Id, Sales_Alignment_Staging__c 
																				from Contact where Id IN :contactIdList
																				and Sales_Alignment_Staging__c != null]);																																					
 
				if(contactMap != null && !contactMap.isEmpty()){
					for(CampaignMember cm : newCampaignMembers){
						if(cm.ContactId != null && contactMap.containsKey(cm.ContactId)){
							cm.Sales_Alignment__c = contactMap.get(cm.ContactId).Sales_Alignment_Staging__c;
						}
					}
				}
			} else if(leadIdList != null && !leadIdList.isEmpty()){
				Map<Id, Lead> leadMap = new Map<Id, Lead>([Select Id, Sales_Alignment_Staging__c 
																				from Lead where Id IN :leadIdList
																				and Sales_Alignment_Staging__c != null]);
																				
				if(leadMap != null && !leadMap.isEmpty()){
					for(CampaignMember cm : newCampaignMembers){
						if(cm.LeadId != null && leadMap.containsKey(cm.LeadId)){
							cm.Sales_Alignment__c = leadMap.get(cm.LeadId).Sales_Alignment_Staging__c;
						}
					}
				}																
			}																																			
		}
	} 
    
	// for lead creation for campaign members created via marketing automation - hubspot
    public static void generateLead(List<CampaignMember> newCampaignMembers) 
    {
    	List<Id> leadCampaignMemberIdToUpdate = new List<Id>();
    	List<Id> campaignMembersToCreateLead = new List<Id>();
    	Set<Id> campaignMembersToExcludeFromReporting = new Set<Id>();
    	Map<CampaignMember, Id> leadCampaignMembersMap = new Map<CampaignMember, Id>();
		List<Id> campaignMemberList = new List<Id>();	//SMS-753
		Set<Id> CmLeadError = new Set<Id>();	//SMS-753  
    	//check criteria for lead creation from campaign member
    	if(newCampaignMembers != null && !newCampaignMembers.isEmpty())
    	{
    		for(CampaignMember cm : newCampaignMembers)
    		{
                system.debug('@@ CM - '+ cm.Status + ' - '+ cm.MQL_Rating__c + ' - '+ Label.TSM_CreateLead_CMRating);
    			if(cm.MQL_Rating__c != null && Label.TSM_CreateLead_CMRating != null && Label.TSM_CreateLead_CMRating.containsIgnoreCase(cm.MQL_Rating__c) && cm.Sales_Alignment__c != null)
    			{
    				if(cm.ContactId != null) campaignMembersToCreateLead.add(cm.Id);
    				if(cm.LeadId != null) leadCampaignMembersMap.put(cm, cm.LeadId);
    				leadCampaignMemberIdToUpdate.add(cm.Id);
    			}
    		}
    	}

    	//if campaign member is associated to lead check additional conditions to check if new lead should be created.
    	if(leadCampaignMembersMap != null && !leadCampaignMembersMap.isEmpty())
    	{
    		//first query for open lead status
    		List<String> openLeadStatusList = new List<String>();
    		List<LeadStatus> leadStatusList = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted=false];
    		if(leadStatusList != null && !leadStatusList.isEmpty()){
    			for( LeadStatus ls: leadStatusList)	openLeadStatusList.add(ls.MasterLabel);
    		}

            openLeadStatusList.addAll(String.ValueOF(Label.TSM_CreateLead_ReopenStatus).split(','));
    		//query to get the lead fields 
    		Map<Id, Lead> leadMap = new Map<Id, Lead>([Select Id, Status, Rating, Sales_Alignment__c, Sales_Alignment_Staging__c, Reason__c 
    										FROM Lead
    										WHERE Id IN: leadCampaignMembersMap.values()
    										AND Status IN: openLeadStatusList]);
			
            system.debug('leadMap: ' + leadMap);
    		List<Lead> leadListToUpdate = new List<Lead>();
            for(CampaignMember cm : leadCampaignMembersMap.keySet()) 
            {
    			Lead existingLead = leadMap.get(cm.LeadId);
                system.debug('existingLead: ' + existingLead);
                system.debug('Label.TSM_CreateLead_ReopenStatus: ' + Label.TSM_CreateLead_ReopenStatus);
                system.debug('@@Values'+cm.Sales_Alignment__c+' '+existingLead.Sales_Alignment_Staging__c+' '+existingLead.Sales_Alignment__c);
    			//if Lead if Unqualified the Lead should be reopened and assigned to the correct sales rep
				if(existingLead != null && String.valueOf(Label.TSM_CreateLead_ReopenStatus).containsIgnoreCase(existingLead.Status))
				{
					existingLead.Status = Label.TSM_CreateLead_DefaultStatus;
					existingLead.Reason__c = null;
					existingLead.Sales_Alignment__c = cm.Sales_Alignment__c;
                    
					//Ensure the auto-assignment trigger is on to trigger Lead Assignment
					existingLead.LeadOwnerAssignmentTriggerOff__c = false;

					leadListToUpdate.add(existingLead);

				//}else if(existingLead != null && cm.Sales_Alignment__c != null && 
				}else if((existingLead != null && cm.Sales_Alignment__c != null && // Added a bracket SMS-857
                    ((existingLead.Sales_Alignment_Staging__c != null && existingLead.Sales_Alignment__c != null &&
                      existingLead.Sales_Alignment_Staging__c == existingLead.Sales_Alignment__c) 
                     || (existingLead.Sales_Alignment__c != null  
    				&& TSM_LeadGeneration_SalesAlignmentMapping__c.getInstance(existingLead.Sales_Alignment__c) != null
    				&& TSM_LeadGeneration_SalesAlignmentMapping__c.getInstance(existingLead.Sales_Alignment__c).Campaign_Member_Sales_Alignment__c != null
    				&& String.valueOf(TSM_LeadGeneration_SalesAlignmentMapping__c.getInstance(existingLead.Sales_Alignment__c).Campaign_Member_Sales_Alignment__c).containsIgnoreCase(cm.Sales_Alignment__c)
                    )))|| (existingLead != null && String.isBlank(existingLead.Sales_Alignment__c)))
                {  //SMS-857
    				system.debug('@@Inside first else if'); 
    				//open lead matches - update fields
    				existingLead.Rating = cm.MQL_Rating__c;
    				leadListToUpdate.add(existingLead);
    				
    			}else{
    				//existing lead doesn't match the campaign's sales alignment, create a new lead
    				campaignMembersToCreateLead.add(cm.Id);
    				//SMS-866
    				campaignMembersToExcludeFromReporting.add(cm.Id);
    				//SMS-866
                    System.debug('campaignMembersToCreateLead: '+campaignMembersToCreateLead);
    			}
    		}

    		if(leadListToUpdate != null && !leadListToUpdate.isEmpty()){
    			update leadListToUpdate;
    		}
    	}

    	if(campaignMembersToCreateLead != null && !campaignMembersToCreateLead.isEmpty())
    	{
    		//requery to get the related objects fields data - Build the query fields from custom setting 'TSM_LeadGeneration_Mapping'
    		List<TSM_LeadGeneration_Mapping__c> leadGenerationMapping = TSM_LeadGeneration_Mapping__c.getall().values();

    		String queryFields =  '';
    		if(leadGenerationMapping != null && !leadGenerationMapping.isEmpty())
    		{
    			for( TSM_LeadGeneration_Mapping__c mapping: leadGenerationMapping)
    			{
    				if(mapping.CM_Contact_FieldName__c != null && mapping.CM_Contact_FieldName__c != '' 
    					&& !queryFields.containsIgnoreCase(mapping.CM_Contact_FieldName__c+', ')){
    					queryFields += mapping.CM_Contact_FieldName__c + ', ';
    				}

    				if(mapping.CM_Lead_FieldName__c != null && mapping.CM_Lead_FieldName__c != '' 
    					&& !queryFields.containsIgnoreCase(mapping.CM_Lead_FieldName__c+', ')){
    					queryFields += mapping.CM_Lead_FieldName__c + ', ';
    				}
    			}
                
    			//add the fields from Lead Owner assignment custom setting to query.
				List<TSM_LeadGeneration_OwnerMapping__c> leadOwnerMapping = TSM_LeadGeneration_OwnerMapping__c.getall().values();
				if(leadOwnerMapping != null && !leadOwnerMapping.isEmpty())
				{
	    			for( TSM_LeadGeneration_OwnerMapping__c mapping: leadOwnerMapping)
	    			{
	    				if(mapping.OwnerField__c != null && mapping.OwnerField__c != '' 
	    					&& !queryFields.containsIgnoreCase(mapping.OwnerField__c+', ')){
	    					queryFields += mapping.OwnerField__c + ', ';
	    				}
					}
				}

    			if(!queryFields.containsIgnoreCase('ContactId')) queryFields += 'ContactId, ';
    			if(!queryFields.containsIgnoreCase('LeadId')) queryFields += 'LeadId, ';
                if(!queryFields.containsIgnoreCase(', Sales_Alignment__c')) queryFields += 'Sales_Alignment__c, ';

    			String soql = 'Select '+queryFields+' Id From CampaignMember WHERE Id IN :campaignMembersToCreateLead';
                System.debug('campaignMembersQueried SOQL: '+soql);   
    			List<CampaignMember> campaignMembersQueried = database.query(soql);

    			if(campaignMembersQueried != null && !campaignMembersQueried.isEmpty())
    			{
    				Map<Id, Lead> cmIdToleadsToCreateMap = new Map<Id, Lead>();
    				for( CampaignMember cm : campaignMembersQueried)
    				{
    					Lead newLead = instantiateLead(cm, leadGenerationMapping);
    					if(newLead != null) cmIdToleadsToCreateMap.put(cm.Id, newLead);
    				}
                    System.debug('cmIdToleadsToCreateMap: '+cmIdToleadsToCreateMap);
                    //SMS-753 Start
                    for(Id CampMemberId:cmIdToleadsToCreateMap.keyset()){
                    	campaignMemberList.add(CampMemberId);
                    }
                    //SMS-753 End
    				if(cmIdToleadsToCreateMap != null && !cmIdToleadsToCreateMap.isEmpty())
    				{
    					//insert cmIdToleadsToCreateMap.values();
    					System.debug('@@Lead val'+cmIdToleadsToCreateMap.values());
						//Database.saveResult[] srList = Database.insert(cmIdToleadsToCreateMap.values(), true);	//SMS-753
						Database.saveResult[] srList = Database.insert(cmIdToleadsToCreateMap.values(), false);	//SMS-753
                        Set<Id> newLeadIds = new Set<Id>();
                        Boolean isCMLeadProcessed = false;
                        //for(Database.SaveResult sr: srList) {	//SMS-753
                        for(Integer i=0 ; i<srList.size(); i++) {	//SMS-753
                        	Database.SaveResult sr = srList.get(i);	//SMS-753
                            if(sr.isSuccess()) {
                                isCMLeadProcessed = true;
                                newLeadIds.add(sr.getId());
                            }
                            else {
                                for(Database.Error err: sr.getErrors()) {
                                    System.debug('Error has occured in Lead creation from CampaignMember');
                                    System.debug(err.getStatusCode()+': '+err.getMessage());
                                   //SMS-753 Start 
                                   CmLeadError.add(campaignMemberList.get(i));
                                   System.debug('@@'+CmLeadError);
                                   //SMS-753 End
                                }
                            }
                        }
                        // processing logic for clone - BEGIN
                        System.debug('newleadIds size:'+newLeadIds.size());
						cloneCampaignMembers(cmIdToleadsToCreateMap.keySet(), newLeadIds);
						// processing logic for clone - END
    					/*
    					for(CampaignMember cm : campaignMembersQueried){
    						if(cmIdToleadsToCreateMap.containsKey(cm.Id) && cmIdToleadsToCreateMap.get(cm.Id).Id != null )
    						cm.LeadId = cmIdToleadsToCreateMap.get(cm.Id).Id;
    					}
    					update campaignMembersQueried;
    					*/ 
					}
    			}
    		}
    	}
    	if(leadCampaignMemberIdToUpdate != null && !leadCampaignMemberIdToUpdate.isEmpty()){
    	// Indicate the Campaign Members that have been processed
    		 List<CampaignMember> leadCampaignMembersToUpdate = new List<CampaignMember>();
                for(Id cmId : leadCampaignMemberIdToUpdate) {
                	System.debug('@@'+cmId);	
                	if(!CmLeadError.contains(cmId)){	//SMS-753
                		CampaignMember cm = new CampaignMember(id = cmId);
                		//SMS-866
                		if(campaignMembersToExcludeFromReporting.contains(cmId)){
                			cm.Exclude_From_Reporting__c = true;
                		}
                		//SMS-866
                    	cm.Is_CM_Lead_Processed__c = true;
                    	leadCampaignMembersToUpdate.add(cm);
                	}
                }
                if(!leadCampaignMembersToUpdate.isEmpty())
    				update leadCampaignMembersToUpdate;
    	}
    }

    public static Lead instantiateLead(CampaignMember cm, List<TSM_LeadGeneration_Mapping__c> leadGenerationMapping) {
    	Lead newLead;
    	if(cm != null && leadGenerationMapping != null && !leadGenerationMapping.isEmpty() ){
    		newLead = new Lead();
    		//Map fields from custom setting
    		for(TSM_LeadGeneration_Mapping__c mapping : leadGenerationMapping){
	    		if(cm.ContactId != null){
	    			// map the contact conversion field or default value
	    			if(mapping.CM_Contact_FieldName__c != null && mapping.CM_Contact_FieldName__c != ''){
	    				if(!String.ValueOf(mapping.CM_Contact_FieldName__c).contains('.')){
	    					//not a reference field, directly get the value from campaign member.
	    					newLead.put(mapping.Name, (String) cm.get(mapping.CM_Contact_FieldName__c));
	    				}else{
	    					//reference field, can't get value directly instead need to get reference object and then value.
	    					List<String> parsedFieldNames = String.valueOf(mapping.CM_Contact_FieldName__c).split('\\.');
	    					if(parsedFieldNames != null && !parsedFieldNames.isEmpty()){
	    						if(parsedFieldNames.size() == 4){
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).getSobject(parsedFieldNames[1]).getSobject(parsedFieldNames[2]).get(parsedFieldNames[3]));
	    						}else if(parsedFieldNames.size() == 3){
	    							System.debug('@@parsedFieldNames'+parsedFieldNames);
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).getSobject(parsedFieldNames[1]).get(parsedFieldNames[2]));
	    						}else if(parsedFieldNames.size() == 2){
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).get(parsedFieldNames[1]));
	    						}
	    					}
	    				}
	    			} else if(mapping.Default_Value__c != null){
	    				newLead.put(mapping.Name, mapping.Default_Value__c);
	    			}
	    		}else if(cm.LeadId != null){
	    			// map the Lead conversion field or default value
	    			if(mapping.CM_Lead_FieldName__c != null && mapping.CM_Lead_FieldName__c != ''){
	    				if(!String.ValueOf(mapping.CM_Lead_FieldName__c).contains('.')){
	    					//not a reference field, directly get the value from campaign member.
	    					newLead.put(mapping.Name, (String) cm.get(mapping.CM_Lead_FieldName__c));
	    				}else{
	    					//reference field, can't get value directly instead need to get reference object and then value.
	    					List<String> parsedFieldNames = String.valueOf(mapping.CM_Lead_FieldName__c).split('\\.');
	    					if(parsedFieldNames != null && !parsedFieldNames.isEmpty()){
	    						if(parsedFieldNames.size() == 4){
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).getSobject(parsedFieldNames[1]).getSobject(parsedFieldNames[2]).get(parsedFieldNames[3]));
	    						}else if(parsedFieldNames.size() == 3){
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).getSobject(parsedFieldNames[1]).get(parsedFieldNames[2]));
	    						}else if(parsedFieldNames.size() == 2){
	    							newLead.put(mapping.Name, (String) cm.getSobject(parsedFieldNames[0]).get(parsedFieldNames[1]));
	    						}
	    					}
	    				}
	    			} else if(mapping.Default_Value__c != null){
	    				newLead.put(mapping.Name, mapping.Default_Value__c);
	    			}
	    		}
    		}

    		if(cm.ContactId != null && cm.Sales_Alignment__c != null){
    			//set owner based on Sales alignment.
    			
    			TSM_LeadGeneration_OwnerMapping__c ownerMapping = TSM_LeadGeneration_OwnerMapping__c.getinstance(cm.Sales_Alignment__c);
    			if(ownerMapping != null && ownerMapping.OwnerField__c != null){
    				List<String> parsedFieldNames = String.valueOf(ownerMapping.OwnerField__c).split('\\.');
    				if(parsedFieldNames.size() == 2){
						newLead.put('OwnerId', (String) cm.getSobject(parsedFieldNames[0]).get(parsedFieldNames[1]));
					}
					else if(parsedFieldNames.size() == 1){
						newLead.put('OwnerId', (String) cm.get(parsedFieldNames[0]));
					}
					newLead.LeadOwnerAssignmentTriggerOff__c = true;
    			}
    			
    		}
    	}
    	return newLead;
	}
    // method to clone the campaignmember to link them to newly created leads
    @future
    public static void cloneCampaignMembers(Set<Id> cmIds, Set<Id> newLeadIds) {
    	List<CampaignMember> clonedList = new List<CampaignMember>();
        List<CampaignMember> recsToDelete = new List<CampaignMember>();
        Set<Id> contIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        Map<Id, CampaignMember> contactMap = new Map<Id, CampaignMember>();
        Map<Id, CampaignMember> leadMap = new Map<Id, CampaignMember>();
        // fetch the respective campaignmembers        
        for(CampaignMember cm: [SELECT Id, ContactId, CampaignId, Sales_Alignment__c, LeadId FROM CampaignMember
                               WHERE Id IN :cmIds]) {
        	if(cm.ContactId != null) {                
            	contIds.add(cm.ContactId);
                contactMap.put(cm.ContactId, cm);
            } else if (cm.LeadId != null) {
                leadIds.add(cm.LeadId);
                leadMap.put(cm.LeadId, cm);
            }  
        }
        // fetch the existing leads and emails
        Map<String, Lead> oldLeadMap = new Map<String, Lead>();
        for(Lead oldlead : [SELECT Id, Name, Email FROM Lead WHERE Id IN :leadIds AND Email != null]) {
        	oldLeadMap.put(oldlead.Email, oldlead);    
        }
        // fetch the respective new leads of the campaignmembers       
        for(Lead lead: [SELECT Id, Name, Email, Related_Contact__c FROM Lead WHERE 
                        Id IN :newLeadIds]) {
            // for cloning the campaign member related to existing contact
            if(lead.Related_Contact__c != null  && contactMap.containsKey(lead.Related_Contact__c)) {
                CampaignMember cmOld = contactMap.get(lead.Related_Contact__c);                
                // records to create
                //SMS-866: added third boolean parameter 
                clonedList.add(prepareClone(cmOld, lead.Id, true));
                //SMS-866: added third boolean parameter	
                // records to delete
                recsToDelete.add(cmOld);
            }
            // for cloning the campaignmember related to existing lead
            else if(lead.Email != null && oldLeadMap.containsKey(lead.email) && 
                    leadMap.containsKey(oldLeadMap.get(lead.email).Id)) {
            	CampaignMember cmOld = leadMap.get(oldLeadMap.get(lead.email).Id);                
                // records to create
                //SMS-866: added third boolean parameter
                clonedList.add(prepareClone(cmOld, lead.Id, false));
                //SMS-866: added third boolean parameter	
                // records to delete
                recsToDelete.add(cmOld);      
            }
        } 
        TSM_CampaignMemberTriggerHandler.alreadyProcessed = true;
        if(!clonedList.isEmpty())
            Database.insert(clonedList, true);
        //This code deletes existing CM related to Contact. 
        //It's been commented out due to Hubspot Sync that recreate a new CM record
        /*if(!recsToDelete.isEmpty())
            Database.delete(recsToDelete, true); */
    }
    // for recursion control
    public static boolean alreadyProcessed = false;
    // for clone record prepare
    public static CampaignMember prepareClone(CampaignMember cmOld, Id leadId, Boolean excludeFromReporting) {
        CampaignMember cm = new CampaignMember();
        cm = cmOld.clone(false, true, false, false);
        cm.CampaignId = cmOld.CampaignId;
        cm.Sales_Alignment__c = cmOld.Sales_Alignment__c;
        cm.ContactId = null;
        cm.LeadId = leadId;
        //SMS-866
        cm.Exclude_From_Reporting__c = excludeFromReporting;
        //SMS-866
        return cm;
    }

}