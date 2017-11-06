trigger Sales411Assignment on Case (after insert) {
    
    ID rectypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales411').getRecordTypeId();
    Group U = [select id from group where name='sales411'];
   
 List<Case> CaseRecordTypeOwner = [select OwnerId,RecordTypeId from  Case where Id IN:Trigger.newMap.keyset()];
    
 {
     for(Case c :CaseRecordTypeOwner)
 
 {
     if (c.RecordTypeId == rectypeid )
     {
         If(c.OwnerId <> u.Id)
     {
         c.OwnerId = U.Id;
             }
         
         }
         update CaseRecordTypeOwner;
 }
}
}