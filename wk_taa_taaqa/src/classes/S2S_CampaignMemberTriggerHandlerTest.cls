/*
 * test class for S2S_CampaignMemberTriggerHandler class
 */
@isTest
private class S2S_CampaignMemberTriggerHandlerTest
{
  // test data
    @testSetup static void dataPrep() {
    List<S2S_Trigger_Control__c> controlList = new List<S2S_Trigger_Control__c>();
        controlList.add(new S2S_Trigger_Control__c(Name='Account',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Contact',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='Opportunity',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='OpportunityLineItem',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='TSM_Shared_Product__c',TriggerOff__c=false));
        controlList.add(new S2S_Trigger_Control__c(Name='CampaignMember',TriggerOff__c=false));            
        insert controlList;    
              
        // insert the new accounts for data
        List<Account> accounts = S2S_TestDataUtil.createAccounts(1,2,0,false);

        for(Account a : accounts){
            a.Software_Owner__c = UserInfo.getUserId();
        }
        update accounts;

        //insert the new test leads
        List<Lead> leads = S2S_TestDataUtil.createLeads(2);

        //insert the new test campaigns
        List<Campaign> campaigns = S2S_TestDataUtil.createCampaigns(1);

        //Insert campaign status
        CampaignMemberStatus newStatus = new CampaignMemberStatus( CampaignID=campaigns[0].id, Label='Considering', IsDefault=false,
                                    HasResponded=false, SortOrder=3);
    insert newStatus;

        //create custom setting data
        /*
        List<TSM_LeadGeneration_OwnerMapping__c> leadGenOwnerMappingList = new List<TSM_LeadGeneration_OwnerMapping__c>();
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'ISC - Corp Software Indirect', 
                                            OwnerField__c = 'Contact.Indirect_Owner__c'));
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'ISC - N2E Professional Software', 
                                            OwnerField__c = 'Contact.Software_Owner_Id__c'));
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'ISC - N2N Professional Software', 
                                            OwnerField__c = 'CreatedById'));
        */ 
        
        List<TSM_LeadGeneration_OwnerMapping__c> leadGenOwnerMappingList = new List<TSM_LeadGeneration_OwnerMapping__c>();
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'Indirect', 
                                            OwnerField__c = 'Contact.Indirect_Owner__c'));
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'Software', 
                                            OwnerField__c = 'Contact.Software_Owner_Id__c'));
        leadGenOwnerMappingList.add( new TSM_LeadGeneration_OwnerMapping__c(Name = 'R&L', 
                                            OwnerField__c = 'CreatedById'));                                    
        insert leadGenOwnerMappingList;
         /*
        List<TSM_LeadGeneration_SalesAlignmentMapping__c> leadGenSAMappingList = new List<TSM_LeadGeneration_SalesAlignmentMapping__c>();      
        leadGenSAMappingList.add( new TSM_LeadGeneration_SalesAlignmentMapping__c(Name = 'ISC - Corp Software Indirect', 
                                              Campaign_Member_Sales_Alignment__c = 'ISC - Corp Software Indirect'));
        leadGenSAMappingList.add( new TSM_LeadGeneration_SalesAlignmentMapping__c(Name = 'ISC - N2N Professional Software', 
                                                                                    Campaign_Member_Sales_Alignment__c = 'ISC - N2N Professional Software'));
        */                                                                           
        List<TSM_LeadGeneration_SalesAlignmentMapping__c> leadGenSAMappingList = new List<TSM_LeadGeneration_SalesAlignmentMapping__c>();
        leadGenSAMappingList.add( new TSM_LeadGeneration_SalesAlignmentMapping__c(Name = 'ISC - Corp Software Indirect', 
                                              Campaign_Member_Sales_Alignment__c = 'Indirect'));
        leadGenSAMappingList.add( new TSM_LeadGeneration_SalesAlignmentMapping__c(Name = 'ISC - N2N Professional Software', 
                                                                                    Campaign_Member_Sales_Alignment__c = 'Software'));
        leadGenSAMappingList.add( new TSM_LeadGeneration_SalesAlignmentMapping__c(Name = 'RSC - Research & Learning', 
                                                                                    Campaign_Member_Sales_Alignment__c = 'R&L'));                                                                                                                                                                              
        insert leadGenSAMappingList;


        List<TSM_LeadGeneration_Mapping__c> leadGenMappingList = new List<TSM_LeadGeneration_Mapping__c>();
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Related_Account__c', CM_Contact_FieldName__c = 'Contact.AccountId', 
                                       CM_Lead_FieldName__c = 'Lead.Related_Account__c'));        
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Related_Contact__c', CM_Contact_FieldName__c = 'ContactId', 
                                       CM_Lead_FieldName__c = 'Lead.Related_Contact__c'));        
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'FirstName', CM_Contact_FieldName__c = 'Contact.Account.Owner.FirstName', 
                                       CM_Lead_FieldName__c = 'Lead.CreatedBy.Name'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'LastName', CM_Contact_FieldName__c = 'Contact.LastName', 
                                       CM_Lead_FieldName__c = 'Lead.LastName'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Company', CM_Contact_FieldName__c = 'Contact.Account.Name', 
                                       CM_Lead_FieldName__c = 'Lead.Company'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Sales_Alignment__c', CM_Contact_FieldName__c = 'Contact.Sales_Alignment_Staging__c', 
                                       CM_Lead_FieldName__c = 'Lead.Sales_Alignment__c'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Market_Segment__c', CM_Contact_FieldName__c = 'Contact.Account.Market_Segment__c', 
                                       CM_Lead_FieldName__c = 'Lead.Market_Segment__c'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Market_Sub_Segment__c', CM_Contact_FieldName__c = 'Contact.Account.Market_Sub_Segment__c', 
                                       CM_Lead_FieldName__c = 'Lead.Market_Sub_Segment__c'));
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Rating', CM_Contact_FieldName__c = 'MQL_Rating__c', 
                                                                     CM_Lead_FieldName__c = 'MQL_Rating__c'));
        
        leadGenMappingList.add( new TSM_LeadGeneration_Mapping__c(Name = 'Status', Default_Value__c = Label.TSM_CreateLead_DefaultStatus));
        insert leadGenMappingList;

    }

    // test the setFieldsOnCreate - campaign member sales alignment
    @isTest static void testSetFieldsOnCreateAndLeadCreation() {
      //set the sales_alignment field for a contact
      List<Contact> contactList = [SELECT Id FROM Contact];
      Contact testContact = contactList[0];
      testContact.Sales_Alignment_Staging__c = 'Software';
      //testContact.Sales_Alignment_Staging__c = 'ISC - N2E Professional Software';
      update testContact;
      
      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];
      
      List<CampaignMember> campaignMembers = new List<CampaignMember>();

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.ContactId = testContact.Id;
        testCM.Status = 'Considering';
          testCM.Sales_Alignment__c = 'ISC - N2N Professional Software';
          campaignMembers.add(testCM);
        insert campaignMembers;

      Test.stopTest();
         
      //requery to assert the campaignmember
      List<CampaignMember> cmList = [Select Id, ContactId, Contact.Sales_Alignment_Staging__c, Sales_Alignment__c, Is_CM_Lead_Processed__c from CampaignMember where Id =: testCM.Id];
      system.assertNotEquals(null, cmList);
      system.assertNotEquals(null, cmList[0].ContactId);
      system.assertEquals(cmList[0].ContactId, contactList[0].Id);
      system.assertEquals(1, cmList.size());
      system.assertEquals('Software', cmList[0].Sales_Alignment__c);
      system.assertEquals(true, cmList[0].Is_CM_Lead_Processed__c);
  }
  
    // test the setFieldsOnCreate - campaign member sales alignment
    @isTest static void testSetFieldsOnCreateAndLeadCreation2() {
      //set the sales_alignment field for a contact
      List<Contact> contactList = [SELECT Id FROM Contact];
      Contact testContact = contactList[0];
      testContact.Sales_Alignment_Staging__c = 'Software';
      update testContact;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.ContactId = testContact.Id;
        testCM.Status = 'Considering';
          testCM.Sales_Alignment__c = 'ISC - N2E Professional Software';
        insert testCM;

      Test.stopTest();

      //assert the campaign member 
      List<CampaignMember> cmList = [Select Id, Sales_Alignment__c from CampaignMember where Id =: testCM.Id];
      //system.assertNotEquals(null, cmList);
      system.assertEquals(1, cmList.size()); 
      system.assertEquals('Software', cmList[0].Sales_Alignment__c);       
  }
    
    // test the setFieldsOnCreate - campaign member clone - for contact
    @isTest static void testSetFieldsOnCreateAndLeadCreationFuture() {
      //set the sales_alignment field for a contact
      List<Contact> contactList = [SELECT Id FROM Contact];
      Contact testContact = contactList[0];
      testContact.Sales_Alignment_Staging__c = 'ISC - N2N Professional Software';
      update testContact;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];
        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.ContactId = testContact.Id;
        testCM.Status = 'Considering';
        //testCM.MQL_Rating__c = 'HOT';
        testCM.Sales_Alignment__c = 'ISC - N2N Professional Software';
        insert testCM;
        //requery to assert sales alignment
      Map<Id, CampaignMember> cmMap = new Map<Id, CampaignMember>([Select Id, Sales_Alignment__c, ContactId, LeadId 
                                                                     from CampaignMember where Id =: testCM.Id]);

      system.assertNotEquals(null, cmMap);
      system.assertEquals(1, cmMap.size());
        Test.startTest();
    S2S_CampaignMemberTriggerHandler.cloneCampaignMembers(cmMap.keySet(), null);
      Test.stopTest();
        // assert the lead and campaign member cloned
    List<CampaignMember> cmExt = [SELECT Id, LeadId, ContactId FROM CampaignMember WHERE ContactId != null];
        System.assertEquals(1, cmExt.size());
        System.assertNotEquals(null, cmExt[0].ContactId);
        System.assertEquals(null, cmExt[0].LeadId);
  }
    // test the setFieldsOnCreate - campaign member clone - for lead
    @isTest static void testSetFieldsOnCreateAndLeadCreationFuture2() {
      //set the sales_alignment field for a lead
      List<Lead> leadList = [SELECT Id, status, email, sales_alignment__c FROM Lead WHERE FirstName='testFName0'];
      Lead testLead = leadList[0];
      testLead.Status = Label.TSM_CreateLead_DefaultStatus;
      //testLead.Sales_Alignment__c = 'ISC - N2N Professional Software';
        testLead.email='test1234tr@testwk1.com';
        //testLead.Name='test1234';
      update testLead;
        List<Lead> leadExt = [SELECT Id, status, email, sales_alignment__c FROM Lead WHERE FirstName='testFName0'];
    Lead newlead = new Lead();
        newlead.FirstName='testFName0';
        newlead.LastName='testLName0';
        newlead.email='test1234tr@testwk1.com';
        newlead.company='test';
        newlead.Status = Label.TSM_CreateLead_DefaultStatus;
        insert newlead;
      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];
        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.LeadId = leadExt[0].Id;
        testCM.Status = 'Considering';
        //testCM.MQL_Rating__c = 'HOT';
        //Test.startTest();
        insert testCM;
        //Test.stopTest();
        //requery to assert sales alignment
      Map<Id, CampaignMember> cmMap = new Map<Id, CampaignMember>([Select Id, Sales_Alignment__c, ContactId, LeadId 
                                                                     from CampaignMember where Id =: testCM.Id]);

      system.assertNotEquals(null, cmMap);
      system.assertEquals(1, cmMap.size());
        Map<Id,Lead> leadMap = new Map<Id, Lead>([SELECT Id, Name from Lead WHERE FirstName = 'testFName0' 
                                                  AND Id != :leadExt[0].Id]);
        System.assertEquals(1, leadMap.size());
        Test.startTest();
        S2S_CampaignMemberTriggerHandler.alreadyProcessed = false;
    S2S_CampaignMemberTriggerHandler.cloneCampaignMembers(cmMap.keySet(), leadMap.keySet());
      Test.stopTest();
        // assert the lead and campaign member cloned
    List<CampaignMember> cmExt = [SELECT Id, LeadId, ContactId FROM CampaignMember WHERE LeadId != null];
        System.assertEquals(2, cmExt.size());
        System.assertNotEquals(null, cmExt[0].LeadId);
        System.assertEquals(null, cmExt[0].ContactId);
  }
  // test Lead Reopen if CM is associated to existing lead.
    @isTest static void testExistingLeadReopen() {
      List<Lead> leadList = [SELECT Id FROM Lead];
      Lead testLead = leadList[0];
        testLead.Status = Label.TSM_CreateLead_ReopenStatus.split(',')[0];
      update testLead;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.LeadId = testLead.Id;
        testCM.Status = 'Considering';
          testCM.Sales_Alignment__c = 'ISC - N2E Professional Software';        
        insert testCM;

      Test.stopTest();

      //requery to assert 
      testLead  = [Select Id, Status, Reason__c, Sales_Alignment__c from Lead where Id =: testLead.Id];

      system.assertNotEquals(null, testLead);
      //system.assertEquals(Label.TSM_CreateLead_DefaultStatus, testLead.Status);
      system.assertNotEquals(Label.TSM_CreateLead_ReopenStatus, testLead.Status);
      system.assertEquals(null, testLead.Reason__c);
  }

  // test CM creation associated to existing lead with matching sales alignment.
    @isTest static void testExistingLeadSalesAlignmentMatch() {
      List<Lead> leadList = [SELECT Id FROM Lead];
      Lead testLead = leadList[0];
      testLead.Status = Label.TSM_CreateLead_DefaultStatus;
      testLead.Sales_Alignment__c = 'ISC - N2N Professional Software';
      testLead.Sales_Alignment_Staging__c = 'Software';
      update testLead;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.LeadId = testLead.Id;
        testCM.Status = 'Considering';
        testCM.Sales_Alignment__c = 'ISC - N2N Professional Software';
        insert testCM;

      Test.stopTest();

      //requery to assert 
      testLead  = [Select Id, Status, Reason__c, Sales_Alignment__c from Lead where Id =: testLead.Id];

      system.assertNotEquals(null, testLead);
      system.assertEquals(Label.TSM_CreateLead_DefaultStatus, testLead.Status);
      
      //requery to assert the campaignmember
      List<CampaignMember> cmList = [Select Id, Sales_Alignment__c from CampaignMember where Id =: testCM.Id];
      
      system.assertEquals('Software', cmList[0].Sales_Alignment__c);
      
  }

  // test CM creation associated to existing lead with no matching sales alignment
    @isTest static void testExistingLeadSalesAlignmentNonMatch() {
      List<Lead> leadList = [SELECT Id FROM Lead];
      Lead testLead = leadList[0];
      testLead.Status = Label.TSM_CreateLead_DefaultStatus;
      testLead.Sales_Alignment__c = 'ISC - N2E Professional Software';
      update testLead;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.LeadId = testLead.Id;
        testCM.Status = 'Considering';
        testCM.Sales_Alignment__c = 'Indirect';
        
        insert testCM;

      Test.stopTest();

      //requery to assert 
      testLead  = [Select Id, Status, Reason__c, Sales_Alignment__c from Lead where Id =: testLead.Id];

      system.assertNotEquals(null, testLead);
      system.assertEquals(Label.TSM_CreateLead_DefaultStatus, testLead.Status);
      
      //requery to assert the campaignmember
      List<CampaignMember> cmList = [Select Id, Sales_Alignment__c from CampaignMember where Id =: testCM.Id];
      
      system.assertEquals('Indirect', cmList[0].Sales_Alignment__c);
  }
    // test CM creation associated to existing lead with no matching sales alignment staging
    @isTest static void testExistingLeadSalesAlignmentStagingNonMatch() {
      List<Lead> leadList = [SELECT Id FROM Lead];
      Lead testLead = leadList[0];
        testLead.Status = Label.TSM_CreateLead_DefaultStatus;
        //testLead.Sales_Alignment_Staging__c = 'ISC - Corp Software Indirect'; 
        //unable to test it due to some flow-trigger errors internal to salesforce
          testLead.Sales_Alignment__c = 'ISC - N2E Professional Software';
      update testLead;

      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];

      Test.startTest();

        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.LeadId = testLead.Id;
        testCM.Status = 'Considering';
        testCM.Sales_Alignment__c = 'ISC - N2E Professional Software';
        insert testCM;

      Test.stopTest();

      //requery to assert 
      testLead  = [Select Id, Status, Reason__c, Sales_Alignment_Staging__c from Lead where Id =: testLead.Id];

      system.assertNotEquals(null, testLead);
      system.assertEquals(Label.TSM_CreateLead_DefaultStatus, testLead.Status);
  }
  
  
  //SMS-753 Start
  @isTest static void testLeadOwnerFromCampaignMember() {
    List<Contact> contactList = [SELECT Id,AccountId FROM Contact];
      Contact testContact = contactList[0];
      testContact.Sales_Alignment_Staging__c = 'Software';
      //testContact.Sales_Alignment_Staging__c = 'ISC - N2E Professional Software';
      update testContact;
      List<Account> accountList = [SELECT Id, Software_Owner__c FROM Account where Id =: testContact.AccountId];
      System.debug('@@accountList'+accountList+' '+testContact);
      Account acct = accountList[0];
      acct.Software_Owner__c = null;
      update acct;
      List<Campaign> campaignList = [SELECT Id FROM Campaign];
      Campaign testCampaign = campaignList[0];
      List<CampaignMember> campaignMembers = new List<CampaignMember>();
      Test.startTest();
        //insert a test campign member and confirm the sales alignment field is set.
        CampaignMember testCM = new CampaignMember();
        testCM.CampaignId = testCampaign.Id;
        testCM.ContactId = testContact.Id;
        testCM.Status = 'Considering';
          testCM.Sales_Alignment__c = 'RSC - Professional Software';
          campaignMembers.add(testCM);
        insert campaignMembers;
      Test.stopTest();
      List<CampaignMember> cmList = [Select Id, ContactId, Contact.Sales_Alignment_Staging__c, Sales_Alignment__c, Is_CM_Lead_Processed__c from CampaignMember where Id =: testCM.Id];
      system.assertNotEquals(null, cmList);
      system.assertNotEquals(null, cmList[0].ContactId);
      system.assertEquals(cmList[0].ContactId, contactList[0].Id);
      system.assertEquals(1, cmList.size());
      system.assertEquals('Software', cmList[0].Sales_Alignment__c);
      system.assertEquals(false, cmList[0].Is_CM_Lead_Processed__c);
  }
  //SMS-753 End
}