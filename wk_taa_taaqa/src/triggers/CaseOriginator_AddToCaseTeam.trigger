trigger CaseOriginator_AddToCaseTeam on Case (after insert) {

    Id caseTeamRoleId= [SELECT Id FROM CaseTeamRole WHERE Name = 'Case Originator' LIMIT 1].id;

    List<CaseTeamMember> catmList=new List<CaseTeamMember>();

    for(Case cs:Trigger.new ){

        CaseTeamMember tm=new CaseTeamMember();
        tm.ParentId=cs.Id;
        tm.MemberId=cs.OwnerId;
        tm.TeamRoleId =caseTeamRoleId;
        catmList.add(tm);
    }

    if(!catmList.isEmpty()){

        Try{
            Insert catmList;

        }catch(DmlException de){

            System.debug(de);
        }
    }
}