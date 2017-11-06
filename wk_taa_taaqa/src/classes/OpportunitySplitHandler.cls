/*
 * trigger handler class to perform below opportunity operation
 * 1. Overlay Opportunity Split: SMS-825  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 05/01/2017 SHIVAJI           1.0         Initial draft
 * ------------------------------------------------------------------------- */
public class OpportunitySplitHandler{
	
	// processing logic for after insert operation
	public static void onAfterInsert(List<Opportunity> lstNewRecords){
		// query overlay type of split type id 
	  	Id overlayOpptySplitTypeId = [SELECT Id,DeveloperName FROM OpportunitySplitType WHERE OpportunitySplitType.DeveloperName = 'Overlay'].Id;
	  	
	  	// query users with their DTN and fill in the maps 
	  	Map<Id, User> mapUser = new Map<Id, User>([SELECT Id FROM User]);

	  	// read custom setting to get mapping of owner and split assignee
	  	List<OpportunitySplit> lstOpptySplitInsert = new List<OpportunitySplit>(); 
	  	Map<String, Opportunity_Overlay_Split__c> mapOpptyOverlaySplitSetting = Opportunity_Overlay_Split__c.getAll();

	  	// loop through all opporunity being inserted
  		for(Opportunity objOppty : lstNewRecords){
  			//check if current opportunity owner is configured in Oppty Overlay Split Custom settting
	  		if(mapUser != NULL && mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)) != NULL && mapUser.get(mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)).Opportunity_Split_Assignee_Id__c) != NULL){
	  			// create new opportunity split for current opprtunity
	  			OpportunitySplit objOpptySplit = new OpportunitySplit();
	  			objOpptySplit.OpportunityId = objOppty.Id;
	  			objOpptySplit.SplitOwnerId = Id.valueOf(mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)).Opportunity_Split_Assignee_Id__c); 
	  			objOpptySplit.SplitPercentage = 100.0;
	  			objOpptySplit.SplitTypeID = overlayOpptySplitTypeId;
	  			//setOpptyIds.add(objOppty.Id);
	  			objOpptySplit.SplitNote = 'Added through Overlay Opportunity Split Function.';
	  			lstOpptySplitInsert.add(objOpptySplit);	
	  		}	
  		}
	  	try{
		  	// insert opportunity split records
		  	if(lstOpptySplitInsert != NULL && lstOpptySplitInsert.size() > 0){
		  		Database.SaveResult[] oppSplitSRList = Database.insert(lstOpptySplitInsert, false);
		  		List<OpportunityTeamMember> opptmList = new List<OpportunityTeamMember>();
		  		for(integer i = 0; i < lstOpptySplitInsert.size(); i++){
					Database.SaveResult sr = oppSplitSRList[i];
					if(sr.IsSuccess()){
				        OpportunityTeamMember otm = new OpportunityTeamMember();
				        otm.TeamMemberRole = 'Opportunity Owner';
				        otm.userID = lstOpptySplitInsert[i].SplitOwnerId;
				        otm.OpportunityAccessLevel = 'Edit';
				        otm.opportunityID = lstOpptySplitInsert[i].OpportunityId;
				        opptmList.add(otm);
			       }
		  		}
		  		
		  		if(opptmList != NULL && opptmList.size() > 0){
		  			insert opptmList;
		  		}    
		  	}
	  	}catch(Exception e){
	  		System.debug('Error while inserting opportunity split : ' + e.getMessage());
	  	}  	
	} 	
    
    // processing logic for after update operation
    public static void onAfterUpdate(List<Opportunity> lstNewRecords, Map<Id, Opportunity> oldRecordsMap){
		// query overlay type of split type id 
	  	Id overlayOpptySplitTypeId = [SELECT Id,DeveloperName FROM OpportunitySplitType WHERE OpportunitySplitType.DeveloperName = 'Overlay'].Id;
	  	
	  	// query users with their DTN and fill in the maps 
	  	Map<Id, User> mapUser = new Map<Id, User>([SELECT Id FROM User]);
	  	// read custom setting to get mapping of owner and split assignee
	  	List<OpportunitySplit> lstOpptySplitInsert = new List<OpportunitySplit>(); 
	  	Map<String, Opportunity_Overlay_Split__c> mapOpptyOverlaySplitSetting = Opportunity_Overlay_Split__c.getAll();
	  	Set<Id> setOpptyIds = new Set<Id>();
	  	// loop through all opporunity being inserted
  		for(Opportunity objOppty : lstNewRecords){
  			//check if current opportunity owner is configured in Oppty Overlay Split Custom settting
	  		if(oldRecordsMap.get(objOppty.Id).OwnerId != objOppty.OwnerId && mapUser != NULL && mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)) != NULL && mapUser.get(mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)).Opportunity_Split_Assignee_Id__c) != NULL){
	  			// create new opportunity split for current opprtunity
	  			OpportunitySplit objOpptySplit = new OpportunitySplit();
	  			objOpptySplit.OpportunityId = objOppty.Id;
	  			objOpptySplit.SplitOwnerId = Id.valueOf(mapOpptyOverlaySplitSetting.get(String.valueOf(objOppty.OwnerId).subString(0,15)).Opportunity_Split_Assignee_Id__c); 
	  			objOpptySplit.SplitPercentage = 100.0;
	  			objOpptySplit.SplitTypeID = overlayOpptySplitTypeId;
	  			setOpptyIds.add(objOppty.Id);
	  			objOpptySplit.SplitNote = 'Added through Overlay Opportunity Split Function.';
	  			lstOpptySplitInsert.add(objOpptySplit);	
	  		}	
  		}

  		if(setOpptyIds.size() > 0){
  			List<OpportunitySplit> lstOpptySplit = [SELECT Id FROM OpportunitySplit WHERE OpportunityId IN: setOpptyIds AND SplitTypeID =: overlayOpptySplitTypeId];
			if(lstOpptySplit != NULL && lstOpptySplit.size() > 0){
				delete lstOpptySplit;
			}  				
  		}
  		
	  	try{
		  	// insert opportunity split records
		  	if(lstOpptySplitInsert != NULL && lstOpptySplitInsert.size() > 0){
		  		Database.SaveResult[] oppSplitSRList = Database.insert(lstOpptySplitInsert, false);
		  		List<OpportunityTeamMember> opptmList = new List<OpportunityTeamMember>();
		  		for(integer i = 0; i < lstOpptySplitInsert.size(); i++){
					Database.SaveResult sr = oppSplitSRList[i];
					if(sr.IsSuccess()){
				        OpportunityTeamMember otm = new OpportunityTeamMember();
				        otm.TeamMemberRole = 'Opportunity Owner';
				        otm.userID = lstOpptySplitInsert[i].SplitOwnerId;
				        otm.OpportunityAccessLevel = 'Edit';
				        otm.opportunityID = lstOpptySplitInsert[i].OpportunityId;
				        opptmList.add(otm);
			       }
		  		}
		  		
		  		if(opptmList != NULL && opptmList.size() > 0){
		  			insert opptmList;
		  		}  	
		  	}
	  	}catch(Exception e){
	  		System.debug('Error while inserting opportunity split : ' + e.getMessage());
	  	} 
	}
}