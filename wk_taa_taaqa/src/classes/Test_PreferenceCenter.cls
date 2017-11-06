/*
    ###########################################################################
    # File..................: Class - Test_PreferenceCenter
    # Created by............: The Hunley Group
    # Created Date..........: 1/1/2016
    # Description...........: Class used to test both the class PreferenceCenterController
                                and the trigger EmailPrefInsertUpdateRelated.
    ########################################################################### */
@isTest(seeAllData=false)
private class Test_PreferenceCenter {
    static testMethod void Test_PreferenceCenter(){
        Account a = new Account(Name='testaccount');
        insert a;
        Contact c = new Contact(LastName='testcontact',AccountId=a.Id,HasOptedOutOfEmail=false);
        insert c;
        /*User u1 = TestDataFactory.newUser('2221',1);
        String  = [Select id,Name,DTN__c from user where DTN__c='222a'].Name;
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);*/
        Lead l = new Lead(LastName='testlead',Company='test company',Status='Not Started',Market_Segment__c='General Corporate',HasOptedOutOfEmail=false);
        insert l;
        List<Email_Preferences__c> emailprefsList = new List<Email_Preferences__c>();
        List<Contact> contactsList = new List<Contact>();
        List<Lead> leadsList = new List<Lead>();
        
        test.startTest();
        
        PageReference wk_pref_page = Page.WK_Pref_Center;
        Test.setCurrentPage( wk_pref_page );
        
        //test contact scenario
        ApexPages.currentPage().getParameters().put( 'Id', c.id );
        PreferenceCenterController controller = new PreferenceCenterController();
        controller.getRandom();
        controller.LastName = 'testcontact';
        controller.GOO = true;
        controller.quickSave();
        
        //test to make sure email preference record is created
        emailprefslist = [
        SELECT Id, LastName__c, Contact__c, GOO__c
        FROM Email_Preferences__c
        WHERE Contact__c = :c.Id
        ];
        System.assertEquals(emailprefsList[0].Contact__c, c.Id);
        System.assertEquals(emailprefsList[0].LastName__c, controller.LastName);
        System.assertEquals(emailprefsList[0].GOO__c, controller.GOO);

        //test to make sure contact record is updated
        contactslist = [
        SELECT Id, LastName, HasOptedOutOfEmail
        FROM Contact
        WHERE Id = :c.Id
        ];
        System.assertEquals(contactslist[0].LastName, controller.LastName);
        //test lead scenario
        ApexPages.currentPage().getParameters().put( 'Id', l.id );
        controller = new PreferenceCenterController();
        controller.LastName = 'testlead';
        controller.GOO = true;
        controller.quickSave();
        
        //test to make sure email preference record is created
        emailprefslist = [
        SELECT Id, LastName__c, Lead__c, GOO__c
        FROM Email_Preferences__c
        WHERE Lead__c = :l.Id
        ];
        System.assertEquals(emailprefsList[0].Lead__c, l.Id);
        System.assertEquals(emailprefsList[0].LastName__c, controller.LastName);
        System.assertEquals(emailprefsList[0].GOO__c, true);

        //test to make sure lead record is updated
        leadslist = [
        SELECT Id, LastName, HasOptedOutOfEmail
        FROM Lead
        WHERE Id = :l.Id
        ];
        System.assertEquals(leadslist[0].LastName,'testlead');
        System.assertEquals(leadslist[0].HasOptedOutOfEmail,true);

        test.stopTest();
    }
}