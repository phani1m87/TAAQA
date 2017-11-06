public with sharing class oppContactRoleHelper {
	public static string debugString{get;set;}
	public class UserException Extends Exception{}
    public Opportunity opp;
    public oppContactRoleHelper( ApexPages.StandardController stdController ) {
        opp = ( Opportunity )stdController.getRecord();        
    }
    public void rollupOppContacts(){
        oppContactRoleHelper.rollupOppContactsFuture( opp.Id );    
    }
    //@future 
    public static void rollupOppContactsFuture( Id oppId ) {
        Contact[] contactList = [ SELECT Id,email,phone,name
                                  
                                  FROM Contact
                             WHERE Id IN ( SELECT ContactId FROM OpportunityContactRole
                                         WHERE OpportunityId = :oppId and IsPrimary=true ) ];
        Opportunity opp = [ SELECT Id 
                            ,Primary_Contact_for_Proposal__c 
                            FROM Opportunity WHERE Id = :oppId ];
        
        boolean requireOppUpdate = false;
        //opp.Primary_Contact_for_Proposal__c=null;
        //throw new UserException('no contact');
        for( Contact contact : contactList ) {
        	debugString='Opportunity Primary Contact:'+opp.Primary_Contact_for_Proposal__c+'-- Contact Id'+Contact.id;
        	if(contact.id==opp.Primary_Contact_for_Proposal__c)
        	   return;        	
            opp.Primary_Contact_for_Proposal__c=contact.id;
            //opp.Primary_Contact_Email__c=contact.email;
            //opp.Primary_Contact_Phone__c=contact.phone;
            //opp.Primary_Contact_Name__c=contact.name;
            requireOppUpdate = true;
        }

        if(requireOppUpdate) 
        update opp;
    }


}