/**
 * This class contains unit tests for validating the behavior of
 *Apex class : CustodialLeadBatch
 */
@isTest(SeeAllData=false)
private class TestCustodialLeadBatch {
   
    
      static testmethod void testleadnewRep(){
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
     // TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        list<Lead>leads = new list<Lead>();
        leads.add(TestDataFactory.newLead('Test1'));
        leads.add(TestDataFactory.newLead('Test2'));
        leads.add(TestDataFactory.newLead('Test3'));
        for(Lead l : leads){
           //Lead l= leads[0];
            l.ownerId= u1.id;
          }  
        update leads;
        System.debug('>>>>>>>Lead List<<<<<<<<'+leads);
        System.debug('>>>>>>User Info<<<<<<'+u1 + u2);
        String DTN_Current_Rep=u1.DTN__c;
        String DTN_new_Rep=u2.DTN__c;
        String q = 'Select id,Name,OwnerID,IsConverted from Lead' /*where OwnerId like'+'\'%'+u1.id+'%'+'\' Limit 200'*/;
        System.debug('<<<<Query Called>>>>>>'+q);
        Custodial__c cust= new Custodial__c();
        cust.DTN_Current_Rep__c=DTN_Current_Rep;
        cust.DTN_new_Rep__c=DTN_new_Rep;
        insert cust;
        
        Test.starttest();
        CustodialLeadBatch clb= new CustodialLeadBatch(cust.id,DTN_Current_Rep,DTN_new_Rep,q,null);
        Database.executebatch(clb,200);
        Test.stoptest();
        List<Lead>leadlist= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u2.Id];
        //System.assert(leadlist.size()>0);
        //System.assertequals(leadlist[0].custodian__C ,false);
        //System.assertequals(leadlist[0].OwnerId,u2.Id);
        List<Lead>leadlist2= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u1.Id];
        System.assert(leadlist2.size()==0);
      }
      static testmethod void testleadcustodialRep(){
    
           User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username );
        AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        list<Lead>leads = new list<Lead>();
        leads.add(TestDataFactory.newLead('Test1'));
        leads.add(TestDataFactory.newLead('Test2'));
        leads.add(TestDataFactory.newLead('Test3'));
        for(Lead l : leads){
           //Lead l= leads[0];
            l.ownerId= u1.id;
          }  
        update leads;
        String DTN_Current_Rep=u1.DTN__c;
        String DTN_custodial_Rep=u2.DTN__c;
         String q = 'Select id,Name,OwnerID,IsConverted from Lead' /*where OwnerId like'+'\'%'+u1.id+'%'+'\' Limit 200'*/;
        Custodial__c cust= new Custodial__c();
        cust.DTN_Current_Rep__c=DTN_Current_Rep;
        cust.DTN_custodial_Rep__c=DTN_custodial_Rep;
        insert cust;
        CustodialLeadBatch clb= new CustodialLeadBatch(cust.id,DTN_Current_Rep,null,q,DTN_custodial_Rep);
        Test.starttest();
        Database.executebatch(clb,200);
        Test.stoptest();
        List<Lead>leadlist= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u2.Id];
        //System.assert(leadlist.size()>0);
        //System.assertequals(leadlist[0].custodian__C ,true);
        //System.assertequals(leadlist[0].OwnerId,u2.Id);
        List<Lead>leadlist2= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u1.Id];
        System.assert(leadlist2.size()==0);
      }
       static testmethod void testException(){
        
        User u1 = TestDataFactory.newUser('111a',1);
        User u2 = TestDataFactory.newUser('111b',2);
        String username = [Select id,Name,DTN__c from user where DTN__c='111a'].Name;
        //TAACustomSetting__c taa = TestDataFactory.newTaaCustomSetting(username );
         AccountAutomationSetting__c taa = TestDataFactory.newTaaCustomSetting(username);
        list<Lead>leads = new list<Lead>();
        //List<sObject> ls = Test.loadData(Lead.sObjectType, 'testdatalead');
        leads.add(TestDataFactory.newLead('Test1'));
        leads.add(TestDataFactory.newLead('Test2'));
        leads.add(TestDataFactory.newLead('Test3'));
        for(Lead l : leads){
           //Lead l= leads[0];
            l.ownerId= u1.id;
          }  
        update leads;
        String DTN_Current_Rep=u1.DTN__c;
        String DTN_custodial_Rep=u2.DTN__c;
         String q = 'Select id,Name,OwnerID,IsConverted from Lead' /*where OwnerId like'+'\'%'+u1.id+'%'+'\' Limit 200'*/;
        Custodial__c cust= new Custodial__c();
        cust.DTN_Current_Rep__c=DTN_Current_Rep;
        cust.DTN_custodial_Rep__c=DTN_custodial_Rep;
        insert cust;
        CustodialLeadBatch clb= new CustodialLeadBatch(cust.id,'7777',null,q,'6666');
        Test.starttest();
        Database.executebatch(clb,200);
        Test.stoptest();
        List<Lead>leadlist= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u2.Id];
        System.assert(leadlist.size()==0);
        //System.assertequals(leadlist[0].custodian__C ,false);
       // System.assertequals(leadlist[0].OwnerId,u1.Id);
        List<Lead>leadlist2= [Select Id,Name,custodian__C,OwnerId from Lead where OwnerID=:u1.Id];
        //System.assert(leadlist2.size()>0);
      }
      
   }