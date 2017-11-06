/*
 * test utility class to perform the S2S records replication from TAA org to SFS org  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 09/20/2017 Raj  Gonola     1.0      Initial draft
 * ------------------------------------------------------------------------- */
@isTest
public class S2S_TestDataUtil {
    public static List<Account> createAccounts(Integer numAccts, Integer numConts, Integer numOpps, Boolean selectedSegment) {
        // create the new accounts
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i < numAccts; i++) {
            if(selectedSegment == false)
                accounts.add(new Account(Name='Test'+i));
            else {       
                Integer reminder = Math.mod(i,2);
                if(reminder == 0)
                  accounts.add(new Account(Name='Test'+i,Market_Segment__c='Legal Professionals',
                                        Market_Sub_Segment__c='Law Firm 1-3 Attorneys'));
                else
                    accounts.add(new Account(Name='Test'+i,Market_Segment__c='Accounting Firms',
                                        Market_Sub_Segment__c='Size TBD'));
            }    
        }
        insert accounts;
        // insert the contacts for all accounts
        List<Contact> contacts = new List<Contact>();
        for(Account acct: accounts) {
          for(Integer j=0;j< numConts; j++) {
                String emailFormat = acct.Name+j+'@testwk.com';
              contacts.add(new Contact(FirstName='testFName'+j,LastName='testLName'+j, 
                                         email=emailFormat, AccountId = acct.Id));
          }
        }
        insert contacts;
        // insert the opportunities for all accounts
        List<Opportunity> opps = new List<Opportunity>();
        for(Account acct: accounts) {
            for(Integer k=0;k< numOpps; k++) {
                opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acct.Id, Name=acct.Id+'OpptyTest'+k,
                                       Primary_Contact_for_Proposal__c=contacts[k].Id,
                                       CPQ_Quote__c='Steelbrick'));
            }
        }
        insert opps;
      return accounts;
    }  
    // for inserting contacts for one account
    public static List<Contact> createContacts(Id acctId, Integer numConts) {
        List<Contact> contacts = new List<Contact>();
        for(Integer j=0;j< numConts; j++) {
          String emailFormat = acctId+'@testwk.com'+j;
            contacts.add(new Contact(FirstName='testFName'+j,LastName='testLName'+j, 
                                         email=emailFormat, AccountId = acctId));
        }        
        insert contacts;
        return contacts;
    }
    // for inserting opportunities for accounts 
    public static List<Opportunity> createOpportunities(Id acctId, Id contactId, Integer numOpps, Boolean isSteelbrick) {
       List<Opportunity> opps = new List<Opportunity>();
       String cpQuote = null;
           if(isSteelbrick == true)
               cpQuote = 'Steelbrick';
             else
                cpQuote = 'Apttus';   
       for(Integer k=0;k< numOpps; k++) {
           opps.add(new Opportunity(StageName='1. Gain Accesss',CloseDate=System.today()+30,
                                       AccountId=acctId, Name=acctId+'OpptyTest'+k,
                                       Primary_Contact_for_Proposal__c=contactId,
                                       CPQ_Quote__c=cpQuote));
               
       }
       insert opps;
       return opps;
    }

    // for inserting leads
    public static List<Lead> createLeads(Integer numConts) {
        List<Lead> leads = new List<Lead>();
        for(Integer j=0;j< numConts; j++) {
          leads.add(new Lead(FirstName='testFName'+j,LastName='testLName'+j, 
                                         Company='testComp',Market_Segment__c='Legal Professionals',
                                        Market_Sub_Segment__c='Law Firm 1-3 Attorneys'));
        }        
        insert leads;
        return leads;
    }

    // for inserting campaign 
    public static List<Campaign> createCampaigns(Integer numConts) {
        List<Campaign> campaigns = new List<Campaign>();
        for(Integer j=0;j< numConts; j++) {
          campaigns.add(new Campaign(Name='testCampaign'+j, isActive = true));
        }        
        insert campaigns;
        return campaigns;
    }
    
     // for inserting oppty products
    public static List<OpportunityLineItem> createOpptyProducts(Id opptyId, Id pbEntryId, Integer numConts) {
        List<OpportunityLineItem> opptyProds = new List<OpportunityLineItem>();
        for(Integer j=0;j< numConts; j++) {
          opptyProds.add(new OpportunityLineItem(OpportunityId=opptyId, PricebookEntryId=pbEntryId, Description='testOpptyLine'+j,SFS_Opportunity_Product_Record_ID__c='00000000000000000'+j, Quantity=j+1));
        }        
        insert opptyProds;
        return opptyProds;
    }
    
      // for inserting oppty products
    public static List<TSM_Shared_Product__c> createSharedProducts(Integer numConts) {
        List<TSM_Shared_Product__c> sharedProds = new List<TSM_Shared_Product__c>();
        for(Integer j=0;j< numConts; j++) {
          sharedProds.add(new TSM_Shared_Product__c(SFS_Oppty_Product_Record_ID__c='00000000000000000'+j,Quantity__c=j+1));
        }        
        insert sharedProds;
        return sharedProds;
    }
}