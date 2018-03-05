global with sharing class TSM_QuoteUtil {
	
	// Class method to construct the SteelBrick Quote URL
	// Returns a string that represents selected Quote URL
	webservice static String loadOpportunity(Id opportunityId) {
		String result = null;
		// Query selected quote
		Opportunity oppty = [Select Id, 
		                            CPQ_Quote__c, 
		                            SFS_Opportunity_ID__c 
		                            FROM Opportunity 
		                            WHERE Id = :opportunityId LIMIT 1];
		List<PartnerNetworkRecordConnection> pnrc = [Select Id, 
		                                              LocalRecordId, 
		                                              PartnerRecordId 
		                                              FROM PartnerNetworkRecordConnection 
		                                              WHERE LocalRecordId = :opportunityId];
		System.debug('display Opportunity: '+ oppty);
		if(oppty.CPQ_Quote__c != 'Steelbrick')
			//result = 'Please select Steelbrick Quote';
			result = System.Label.TSM_SelectSteelbrick;
		//else if (oppty.SFS_Opportunity_ID__c == null) {
	    else if (pnrc.isEmpty() || (!pnrc.isEmpty() && pnrc[0].PartnerRecordId == null)) {
            result = System.Label.TSM_OpportunityProcessing;
			//result = 'Processing SFS Opportunity. Please try again in few minutes or contact Support if the problem persists.';
		} 
		else {
			//result = 'https://wksfs--qa.cs61.my.salesforce.com/' + oppty.SFS_Opportunity_ID__c;
			//TSM_Custom_Settings__c tsmCS = TSM_Custom_Settings__c.getInstance();
            //String baseURL = tsmCS.SFS_Base_URL__c;
            result = TSM_Custom_Settings__c.getInstance().SFS_Base_URL__c + '/' + pnrc[0].PartnerRecordId;
		}
		System.debug('display result: '+ result);
		return result;
	}
}