/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @istest(seeAllData=false)
 private class TestCustodialProcess{
            static testMethod void leadCustodialAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
               

                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='1111'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                objLead.ownerId=objUser1.id;
                update objLead;
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }

            static testMethod void leadRepAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);               
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');  
                objLead.ownerid=objUser1.id;
                update objLead;
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_New_Rep__c='111b';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='New Rep';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            static testMethod void emptyCustodialDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.searchUserDetail();
                
            }
             static testMethod void equalCustodialDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111a';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.searchUserDetail();
                
             
            }
            static testMethod void emptyNewRepDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='New Rep';
                objCust.showDTN();
                objCust.searchUserDetail();
                
            }
             static testMethod void equalNewRepDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_New_Rep__c='111b';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='New Rep';
                objCust.showDTN();
                objCust.searchUserDetail();
                
             
            }
            static testMethod void AccountCustodialAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                List<User> userList = new List<User>(); //SMS-777
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                //SMS-777 Start 
                objUser1.FirstName = 'Testing1';
                objUser2.FirstName = 'Testing2';
                userList.add(objUser1);
                userList.add(objUser2);
                update userList;
                //SMS-777 End
                
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
                //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                objLead.ownerId=objUser1.id;
                update objLead;
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            
            static testMethod void BothCustodialAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                List<User> userList = new List<User>(); //SMS-777
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                
                //SMS-777 Start
                objUser1.FirstName = 'Testing1';
                objUser2.FirstName = 'Testing2';
                userList.add(objUser1);
                userList.add(objUser2);
                update userList;
                //SMS-777 End

                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
                
                
                //AccountAutomationSetting__c aas = ATA_TestDataFactory.create_ATACustomSettingForCustodian(3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                objLead.ownerId=objUser1.id;
                update objLead;
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='Both';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            static testMethod void NoLeadforAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2);
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='LeadProcess';
                objCust.optSelectedRep='Custodial';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            static testMethod void NoAccountforAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
               

                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser2.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                 AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Custodial';
                objcust.CountAccTeamMember=0;
                objCust.custodialid='';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            static testMethod void NoAccountLeadforAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
               
              
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser2.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                 AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='both';
                objcust.CountAccTeamMember=0;
                objcust.CountLead=0;
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.custodialid='';
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            static testMethod void Calloutexception() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
 
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                
               
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser2.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
               // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                 AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Custodial_Rep__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.testCallout=false;
                objCust.optSelectedRep='both';
                objcust.CountAccTeamMember=0;
                objcust.CountLead=0;
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.custodialid='';
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            
            static testMethod void AccountOpenTerritoryAssignment() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                List<User> userList = new List<User>(); //SMS-777
                Account objAccount = new Account();
                objAccount.Name= 'Test Account';
                objAccount.RecordTypeId='012i0000000Ou0E';
                insert objAccount;

                User objUser1 = TestDataFactory.newUser('111a',1);
                User objUser2 = TestDataFactory.newUser('111b',2); 
                User objUser3 = ATA_TestDataFactory.create_NewUser('ATA87',3);
                
                //SMS-777 Start
                objUser1.FirstName = 'Testing1';
                objUser2.FirstName = 'Testing2';
                userList.add(objUser1);
                userList.add(objUser2);
                update userList;
                //SMS-777 End
                ATA_TestDataFactory.create_ATANongeographicAssignment('LeadOwnership', 'Domain__c', 'example.com', '', 'ATA87', '');
                
                AccountTeamMember objAccTeamMember= new AccountTeamMember(AccountId=objAccount.Id, UserId=objUser1.Id ,TeamMemberRole='Test Role');
                insert objAccTeamMember;

                AccountShare objAccountShare= new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId =objUser1.Id , AccountId =objAccount.Id);
                insert objAccountShare;

                String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
                //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
                Lead objLead = TestDataFactory.newLead('Test1');   
                objLead.ownerId=objUser1.id;
                update objLead;
                    
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Open_Territory_User__c='111b';
                insert objCustodial;
                
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Open Territory';
                objCust.showDTN();
                objCust.getRadioValues();
                objCust.getRadioValuesRep();
                objCust.searchUserDetail();
                objCust.SubmitRequest();
                objCust.close();
                objCust.CancelRequest();
                objCust.showAssgnmentBlock();
                objCust.reset();
                
                System.assertequals(objAccount.name,'Test Account');
                System.assertequals(objAccTeamMember.Accountid,objAccount.ID);
                System.assertequals(objUser1.DTN__c,'111a');
            }
            
            static testMethod void equalAccountNewRepDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_New_Rep__c='111a';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='New Rep';
                objCust.showDTN();
                objCust.searchUserDetail();
            }
            
             static testMethod void equalAccounOpenTerritoryDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='111a';
                objCustodial.DTN_Open_Territory_User__c='111a';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Open Territory';
                objCust.showDTN();
                objCust.searchUserDetail();
            }
            
            static testMethod void emptyOpenTerritoryDTNValue() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Open Territory';
                objCust.showDTN();
                objCust.searchUserDetail();
                
            }
            
            
            static testMethod void noUserAssociated() 
            {
                PageReference pageRef = page.CustodialProcess;
                Test.setCurrentPage(pageRef);
                Custodial__c objCustodial = new Custodial__c();
                objCustodial.DTN_Current_Rep__c='%%@$$$$$$';
                objCustodial.DTN_Open_Territory_User__c='%%@$$$$$$';
                insert  objCustodial;
                ApexPages.StandardController sc = new ApexPages.StandardController(objCustodial);
                Custodialprocess objCust = new Custodialprocess(sc);
                objCust.optSelected='AccountProcess';
                objCust.optSelectedRep='Open Territory';
                objCust.showDTN();
                objCust.searchUserDetail();
            }
}