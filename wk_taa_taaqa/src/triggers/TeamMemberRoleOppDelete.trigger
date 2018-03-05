trigger TeamMemberRoleOppDelete on OpportunityTeamMember (before delete) {




set<Id> setOpp = new set<Id>();

set<Id> setOTM = new set<Id>();

 

 
for (OpportunityTeamMember oppTeam : trigger.old) { 

  setOpp.add(oppTeam.OpportunityId);

  setOTM.add(oppTeam.id);

  }


 

list<OpportunityTeamMember> listOTM  = new list<OpportunityTeamMember>      

    ([

SELECT Id, UserId, OpportunityId,  TeamMemberRole, User.Name FROM OpportunityTeamMember WHERE Id in :setOTM AND

                         (TeamMemberRole =

'RC - R&L Retention' OR TeamMemberRole = 'T&C - Research and Learning' OR TeamMemberRole = 'RC - R&L ServiceSource') ]);

 

                                                    

 

  Map<Id,Opportunity> mapOpps = new map<Id, Opportunity>([SELECT Id FROM Opportunity Where Id = :setOpp ]) ; 

  

Opportunity tempOpp; 

 

   



for(OpportunityTeamMember otm : listOTM ){

        tempOpp = mapOpps.get(otm.OpportunityId);

         

if(otm.TeamMemberRole == 'RC - R&L Retention') {

              tempOpp.has_asr_opportunity_team__c = false;

          }
if(otm.TeamMemberRole == 'RC - R&L ServiceSource') {

              tempOpp.has_asr_opportunity_team__c = false;

          }

if(otm.TeamMemberRole == 'T&C - Research and Learning') {

              tempOpp.has_tc_opportunity_team__c = false;

             }
 }
              

  



  

update mapOpps.values();

}