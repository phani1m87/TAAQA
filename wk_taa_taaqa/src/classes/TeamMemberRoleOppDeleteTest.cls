@isTest 
private class TeamMemberRoleOppDeleteTest {

    static testMethod void validateTeamMemberRoleOppDelete() {
    
    Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco' );
        insert A;

 Opportunity O = new Opportunity(
        Name = 'TestOpp',
        accountId = A.Id,
        type = 'New to Existing',
        Closedate = Date.today().addYears(1),
        stagename = '1. Gain Access',
        product_category__c = 'Med/Large Software',
        Amount = 1.00,
        product_Sub_Category__c = 'Tax');
        insert O;
       
         
OpportunityTeamMember M = new OpportunityTeamMember(opportunityid =o.Id, UserID= '005i0000004TuQ0AAK', TeamMemberRole = 'RC - R&L Retention');
 

       
       insert M;
    try{
                delete m;
            }catch(Exception e) {
                system.assert(e.getMessage().contains('This contact cannot be Deleted. please contact the Administration Department. Thank you.'));
            }
          
     
         }
}