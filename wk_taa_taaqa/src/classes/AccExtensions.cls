public class AccExtensions{
      transient Public List<Account> AHS{get;set;}
             
                 public AccExtensions(ApexPages.StandardController controller) {
          AHS=[select id,(select id,ActivityDate,short_notes__c,OwnerId, Owner.name,Activity_Type__c,description,subject,Who.Id,Who.Name from ActivityHistories where owner.id<>'005i0000001gIQJAA2' order by activitydate DESC ) from account where ID=:ApexPages.currentPage().getParameters().get('id') ];
                     
          System.Debug('AHS: ' + AHS.get(0));
        System.Debug('Activities: ' + AHS.get(0).ActivityHistories);
        
}

}