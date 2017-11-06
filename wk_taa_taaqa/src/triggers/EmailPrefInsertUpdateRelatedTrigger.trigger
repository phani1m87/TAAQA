/*
    ###########################################################################
    # File..................: Trigger - EmailPrefInsertUpdateRelatedTrigger
    # Created by............: The Hunley Group
    # Created Date..........: 1/1/2016
    # Description...........: Trigger used to support the Force.com Sites Email Preference
								center. When a new Email Preferences record is inserted, the 
								data is pushed up to the associated lead or contact.
    ########################################################################### */
trigger EmailPrefInsertUpdateRelatedTrigger on Email_Preferences__c (after insert) {
    
    Contact contactToUpdate = new Contact();
    List<Contact> contactsToUpdate = new List<Contact>();
    Lead leadToUpdate = new Lead();
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Email_Preferences__c> tobedeleted = new List<Email_Preferences__c>();
    
    Map<Id, Email_Preferences__c> contEPMap 
                    = new Map<Id, Email_Preferences__c>([SELECT Id, Contact__r.Email, Lead__r.Email 
                                                    FROM Email_Preferences__c 
                                                    WHERE Id IN :Trigger.New]);
    
    for(Email_Preferences__c ep : trigger.new){
    	Email_Preferences__c emailPref = contEPMap.get(ep.id);
        if (ep.Contact__c != null){
            contactsToUpdate = [SELECT Id, FirstName, LastName, Title, MobilePhone, SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c,
                           NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                           RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                           SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail from Contact WHERE Email = :emailPref.Contact__r.Email ];
            
            for (Contact c : contactsToUpdate){
                c.FirstName = ep.FirstName__c;
                c.LastName = ep.LastName__c;
                c.Title = ep.Title__c;
                c.MobilePhone = ep.MobilePhone__c;
                c.HasOptedOutOfEmail = ep.GOO__c;
                c.SP_CFM__c = ep.SP_CFM__c;
                c.SP_AAW__c=ep.SP_AAW__c;
                c.NA_CCC__c=ep.NA_CCC__c;
                c.NA_IFT__c=ep.NA_IFT__c;
                c.NA_TNH__c=ep.NA_TNH__c;
                c.RL_AAR__c=ep.RL_AAR__c;
                c.RL_FEPR__c=ep.RL_FEPR__c;
                c.RL_FTR__c=ep.RL_FTR__c;
                c.RL_ITR__c=ep.RL_ITR__c;
                c.RL_SAA__c=ep.RL_SAA__c;
                c.RL_SFE__c=ep.RL_SFE__c;
                c.RL_SFI__c=ep.RL_SFI__c;
                c.RL_SIT__c=ep.RL_SIT__c;
                c.RL_SST__c=ep.RL_SST__c;
                c.RL_STR__c=ep.RL_STR__c;
                c.SP_CDT__c=ep.SP_CDT__c;
                c.SP_CFT__c=ep.SP_CFT__c;
                c.SP_CIT__c=ep.SP_CIT__c;
            }    
            update contactsToUpdate;
            
            leadsToUpdate = [SELECT Id, FirstName, LastName, Title, MobilePhone, SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c,
                           NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                           RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                           SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail from Lead WHERE Email = :emailPref.Contact__r.Email AND IsConverted != true];

            for (Lead l : leadsToUpdate){
                l.FirstName = ep.FirstName__c;
                l.LastName = ep.LastName__c;
                l.Title = ep.Title__c;
                l.MobilePhone = ep.MobilePhone__c;
                l.HasOptedOutOfEmail = ep.GOO__c;
                l.SP_CFM__c = ep.SP_CFM__c;
                l.SP_AAW__c=ep.SP_AAW__c;
                l.NA_CCC__c=ep.NA_CCC__c;
                l.NA_IFT__c=ep.NA_IFT__c;
                l.NA_TNH__c=ep.NA_TNH__c;
                l.RL_AAR__c=ep.RL_AAR__c;
                l.RL_FEPR__c=ep.RL_FEPR__c;
                l.RL_FTR__c=ep.RL_FTR__c;
                l.RL_ITR__c=ep.RL_ITR__c;
                l.RL_SAA__c=ep.RL_SAA__c;
                l.RL_SFE__c=ep.RL_SFE__c;
                l.RL_SFI__c=ep.RL_SFI__c;
                l.RL_SIT__c=ep.RL_SIT__c;
                l.RL_SST__c=ep.RL_SST__c;
                l.RL_STR__c=ep.RL_STR__c;
                l.SP_CDT__c=ep.SP_CDT__c;
                l.SP_CFT__c=ep.SP_CFT__c;
                l.SP_CIT__c=ep.SP_CIT__c;
            }
            if (leadsToUpdate.size()>0){
            	update leadsToUpdate;
            }
        } else if (ep.Lead__c != null){
            leadsToUpdate = [SELECT Id, FirstName, LastName, Title, MobilePhone, SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c,
                           NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                           RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                           SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail from Lead WHERE Email = :emailPref.Lead__r.Email AND IsConverted != true];
            
            for (Lead l : leadsToUpdate){
                l.FirstName = ep.FirstName__c;
                l.LastName = ep.LastName__c;
                l.Title = ep.Title__c;
                l.MobilePhone = ep.MobilePhone__c;
                l.HasOptedOutOfEmail = ep.GOO__c;
                l.SP_CFM__c = ep.SP_CFM__c;
                l.SP_AAW__c=ep.SP_AAW__c;
                l.NA_CCC__c=ep.NA_CCC__c;
                l.NA_IFT__c=ep.NA_IFT__c;
                l.NA_TNH__c=ep.NA_TNH__c;
                l.RL_AAR__c=ep.RL_AAR__c;
                l.RL_FEPR__c=ep.RL_FEPR__c;
                l.RL_FTR__c=ep.RL_FTR__c;
                l.RL_ITR__c=ep.RL_ITR__c;
                l.RL_SAA__c=ep.RL_SAA__c;
                l.RL_SFE__c=ep.RL_SFE__c;
                l.RL_SFI__c=ep.RL_SFI__c;
                l.RL_SIT__c=ep.RL_SIT__c;
                l.RL_SST__c=ep.RL_SST__c;
                l.RL_STR__c=ep.RL_STR__c;
                l.SP_CDT__c=ep.SP_CDT__c;
                l.SP_CFT__c=ep.SP_CFT__c;
                l.SP_CIT__c=ep.SP_CIT__c;
            }
            update leadsToUpdate;
            
            contactsToUpdate = [SELECT Id, FirstName, LastName, Title, MobilePhone, SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c,
                           NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                           RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                           SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail from Contact WHERE Email = :emailPref.Lead__r.Email ];
            
            for (Contact c : contactsToUpdate){
                c.FirstName = ep.FirstName__c;
                c.LastName = ep.LastName__c;
                c.Title = ep.Title__c;
                c.MobilePhone = ep.MobilePhone__c;
                c.HasOptedOutOfEmail = ep.GOO__c;
                c.SP_CFM__c = ep.SP_CFM__c;
                c.SP_AAW__c=ep.SP_AAW__c;
                c.NA_CCC__c=ep.NA_CCC__c;
                c.NA_IFT__c=ep.NA_IFT__c;
                c.NA_TNH__c=ep.NA_TNH__c;
                c.RL_AAR__c=ep.RL_AAR__c;
                c.RL_FEPR__c=ep.RL_FEPR__c;
                c.RL_FTR__c=ep.RL_FTR__c;
                c.RL_ITR__c=ep.RL_ITR__c;
                c.RL_SAA__c=ep.RL_SAA__c;
                c.RL_SFE__c=ep.RL_SFE__c;
                c.RL_SFI__c=ep.RL_SFI__c;
                c.RL_SIT__c=ep.RL_SIT__c;
                c.RL_SST__c=ep.RL_SST__c;
                c.RL_STR__c=ep.RL_STR__c;
                c.SP_CDT__c=ep.SP_CDT__c;
                c.SP_CFT__c=ep.SP_CFT__c;
                c.SP_CIT__c=ep.SP_CIT__c;
            }    
            update contactsToUpdate;
        }
    }
}