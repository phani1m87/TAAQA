trigger Update_X_Reference on Opportunity (before update) {
        for(Opportunity Opp : Trigger.new){
        if(opp.is_ams_renewal__c)
         {
       
Opportunity oldOpp = Trigger.oldMap.get(opp.Id);  
Account_x_reference__c xref = [select ID,ams_renewal_email__C,X2017_AMS_Additional_Discount__c, ams_renewal_contact__c from account_x_reference__c where ID = :Opp.Account_X_Reference__c LIMIT 1];

    if(oldOpp.AMS_Renewal_contact__c !=opp.AMS_renewal_contact__c){
    xref.ams_renewal_contact__c = opp.ams_renewal_contact__c;
    
    }
if(oldOpp.ams_renewal_email__c != opp.ams_renewal_email__c)
{
    xref.AMS_renewal_email__c = opp.ams_renewal_email__c;
}
if(oldOpp.X2017_AMS_Additional_Discount__C != opp.X2017_AMS_Additional_Discount__C)
{
    xref.X2017_AMS_Additional_Discount__C = opp.X2017_AMS_Additional_Discount__C;
}

update xref;
}
{
return;
}
}
}