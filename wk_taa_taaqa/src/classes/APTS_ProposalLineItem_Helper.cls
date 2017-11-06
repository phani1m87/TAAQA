/*************************************************************************************************************
@Name: APTS_ProposalLineItem_Helper
@Author: Bogdan Botcharov
@Created Date: July 29, 2015
@Description: Helper class for the Apttus_Proposal__Proposal_Line_Item__c
@Used By: Apttus_Proposal__Proposal_Line_Item__c
*************************************************************************************************************/
public with sharing class APTS_ProposalLineItem_Helper {

	public APTS_ProposalLineItem_Helper() {
		
	}

	public void triggerOpportunityWorkflows(Apttus_Proposal__Proposal_Line_Item__c[] objects){
		System.debug('****************objects entering method: '+objects);
		//Proposal IDs
		Set<Id> proposalIds = new Set<Id>();
		//Opportunity IDs
		Set<Id> opptyWonIds = new Set<Id>();
		Set<Id> opptyPartialWonIds = new Set<Id>();
		Set<Id> opptyLostIds = new Set<Id>();

		for(Apttus_Proposal__Proposal_Line_Item__c pli : objects){
			//Add to Proposal ID set
			proposalIds.add(pli.Apttus_Proposal__Proposal__c);
		}

		System.debug('*******************proposalIds: '+proposalIds);

		//List of Proposals
		List<Apttus_Proposal__Proposal__c> listProposals = [SELECT Id, Apttus_Proposal__Opportunity__c 
															FROM Apttus_Proposal__Proposal__c 
															WHERE Id IN : proposalIds];
		System.debug('******************listProposals: '+listProposals);

		//List of Proposal Line Items
		List<Apttus_Proposal__Proposal_Line_Item__c> listPLineItems = [SELECT Id, Apttus_QPConfig__LineStatus__c, Apttus_Proposal__Proposal__c
																		FROM Apttus_Proposal__Proposal_Line_Item__c
																		WHERE Apttus_Proposal__Proposal__c IN : proposalIds];

		System.debug('*********************listPLineItems: '+listPLineItems);
		for(Apttus_Proposal__Proposal__c proposal : listProposals){

			//Count of Line Statuses per Proposal
			Integer counterNew = 0;
			Integer counterCancelled = 0;
			Integer counterRenewed = 0;
			//Count of Line Items per Proposal
			Integer counterLineItems = 0;

			for(Apttus_Proposal__Proposal_Line_Item__c pli : listPLineItems){
				System.debug('************************pli: '+pli);
				if(proposal.Id == pli.Apttus_Proposal__Proposal__c){

					counterLineItems += 1;

					if(pli.Apttus_QPConfig__LineStatus__c == 'Cancelled'){
						counterCancelled += 1;
					}
				}
			}

			System.debug('****************************counterCancelled: '+counterCancelled);
			System.debug('****************************counterLineItems: '+counterLineItems);

			if(counterCancelled == 0){
				opptyWonIds.add(proposal.Apttus_Proposal__Opportunity__c);
			}

			if(counterCancelled>0 && counterCancelled<counterLineItems){
				opptyPartialWonIds.add(proposal.Apttus_Proposal__Opportunity__c);
			}
			if(counterCancelled>0 && counterCancelled == counterLineItems){
				opptyLostIds.add(proposal.Apttus_Proposal__Opportunity__c);
			}
		}

		System.debug('***************opptyWonIds: '+opptyWonIds);
		System.debug('***************opptyPartialWonIds: '+opptyPartialWonIds);
		System.debug('***************opptyLostIds: '+opptyLostIds);

		List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

		if(opptyPartialWonIds.size()>0){
			for(Opportunity partialWonOpp : [SELECT Id, Opportunity_Partial_Won__c, Opportunity_Closed_Won__c, Opportunity_Closed_Lost__c FROM
												Opportunity WHERE Id IN: opptyPartialWonIds]){
				if(partialWonOpp.Opportunity_Partial_Won__c != true){
					partialWonOpp.Opportunity_Partial_Won__c = true;
					if(partialWonOpp.Opportunity_Closed_Lost__c == true || partialWonOpp.Opportunity_Closed_Won__c == true){
						partialWonOpp.Opportunity_Closed_Lost__c = false;
						partialWonOpp.Opportunity_Closed_Won__c = false;
					}
					System.debug('***********************partialWonOpp: '+partialWonOpp);
					opportunitiesToUpdate.add(partialWonOpp);
				}
			}
		}

		if(opptyLostIds.size()>0){
			for(Opportunity lostOpp : [SELECT Id, Opportunity_Closed_Lost__c, Opportunity_Partial_Won__c, Opportunity_Closed_Won__c FROM
											Opportunity WHERE Id IN: opptyLostIds]){
				if(lostOpp.Opportunity_Closed_Lost__c != true){
					lostOpp.Opportunity_Closed_Lost__c = true;
					if(lostOpp.Opportunity_Partial_Won__c == true || lostOpp.Opportunity_Closed_Won__c == true){
						lostOpp.Opportunity_Partial_Won__c = false;
						lostOpp.Opportunity_Closed_Won__c = false;
					}
					System.debug('***********************lostOpp: '+lostOpp);
					opportunitiesToUpdate.add(lostOpp);
				}
			}
		}

		if(opptyWonIds.size()>0){
			for(Opportunity wonOpp : [SELECT Id, Opportunity_Closed_Lost__c, Opportunity_Partial_Won__c, Opportunity_Closed_Won__c 
											FROM Opportunity WHERE Id IN: opptyWonIds]){
				if(wonOpp.Opportunity_Closed_Won__c != true){
					wonOpp.Opportunity_Closed_Won__c = true;
					if(wonOpp.Opportunity_Partial_Won__c == true || wonOpp.Opportunity_Closed_Lost__c == true){
						wonOpp.Opportunity_Partial_Won__c = false;
						wonOpp.Opportunity_Closed_Lost__c = false;
					}
					System.debug('*********************wonOpp: '+wonOpp);
					opportunitiesToUpdate.add(wonOpp);
				}
			}
		}

		System.debug('**************************************opportunitiesToUpdate: '+opportunitiesToUpdate);
		if(opportunitiesToUpdate.size()>0){
			try{
				update opportunitiesToUpdate;
			} catch(DmlException e){
				System.debug('The following error has occurred: '+e.getMessage());
			}
		}
	}
}