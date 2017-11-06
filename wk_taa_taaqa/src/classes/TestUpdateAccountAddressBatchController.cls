@isTest(SeeAllData=false)
private class TestUpdateAccountAddressBatchController {
    
     static testMethod void processAccountXrefHistoryWithoutStreetAddress2() {
        
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];  
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.xRefOnlyWithPOBox('Street Address PO BOX');
        Account a = HelperTestClass.accountWithAddress();
        
        updateJobController.processAccountXReferenceHistory(HelperTestClass.xAccountWithAMSWithoutStreetLine(a),asyncJob);
        
        test.stopTest();
    } 
    
    static testMethod void processAccountXrefHistoryWithCountryChang() {
        
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];  
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.xRefOnlyWithPOBox('Street Address PO BOX');
        Account a = HelperTestClass.accountWithdifferntCountry();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.xAccountWithAMSWithCountryChanges(a),asyncJob);
        
        test.stopTest();
    }       
    
    
    static testMethod void processAccountXrefHistoryWithPOBoxAddress() {
        
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a =HelperTestClass.accountNew(); 
        updateJobController.processAccountXReferenceHistory(HelperTestClass.xAccountWithAMSWithPOBox(a),asyncJob);
        
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistoryWithSAPAccount() {
        
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a =HelperTestClass.accountWithdifferntCountry(); 
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPAccounts(a),asyncJob);
        
        test.stopTest();
    }  
    
    static testMethod void processAccountXrefHistoryWithSAPPOBOXAccount() {
        
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a =HelperTestClass.accountWithAddress(); 
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPPOBOXAccounts(a),asyncJob);
        
        test.stopTest();
    }    
    
    static testMethod void processAccountXrefHistoryWithDifferentCountry() {
        
        test.startTest();
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job); 
        
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a =HelperTestClass.accountWithdifferntCountry(); 
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPDifferetCoutry(a),asyncJob);
        
        test.stopTest();
    }    
    
    
    static testMethod void processAccountXrefHistoryWithUSCountry() {
        
        test.startTest();
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a =HelperTestClass.accountWithAddress(); 
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPDifferetCoutry(a),asyncJob);
        
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistorywithAMSMultiPleList() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.xRefOnlyWithPOBox('Street Address PO BOX');
        Account a = HelperTestClass.accountWithAddress();
        
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withAMSMultipleAddress(a),asyncJob);
        
        
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistorywithSAPMultiPleList() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
        
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId]; 
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 5;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.xRefOnlyWithPOBox('Street Address PO BOX');
        Account a = HelperTestClass.accountWithAddress();
        
      
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPMultipleAddress(a),asyncJob);
        
        
        test.stopTest();
    }   
    
   
   static testMethod void processAccountXrefHistorywithMoreRecords() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        Account a = HelperTestClass.accountWithAddress();
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withAMSMultipleAddress(a),asyncJob);
        
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPPostOfficeChanges(a),asyncJob);
        
        test.stopTest();
    }   
    
    
    static testMethod void processAccountXrefHistorywithAMSAllBlank() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        Account a = HelperTestClass.accountWithAddress();
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withAMSAllBlankValues(a),asyncJob);
        
        
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistorywithSAPAllBlank() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        Account a = HelperTestClass.accountWithAddress();
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPAllBlankValues(a),asyncJob);
        
        
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistorywithAMSDiffCountry() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        Account a = HelperTestClass.accountWithAddress();
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withAMSwithDifferentCoutry(a),asyncJob);
        test.stopTest();
    }   
   
    static testMethod void processAccountXrefHistorywithAMSSAP() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        Account a = HelperTestClass.accountWithAddress();
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPAMSMultipleAddress(a),asyncJob);
        test.stopTest();
    }   
    
    static testMethod void processAccountXrefHistorywithSFSBlank() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a = HelperTestClass.accountNew();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSBlankAddress(a),asyncJob);
        test.stopTest();
    } 
    
    static testMethod void processAccountXrefHistorywithSFSPusFourZipCode() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a = HelperTestClass.accountWithAddress();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSZipCodeAddress(a),asyncJob);
        Account acc = HelperTestClass.accountWithAddress_zip();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSZipCodeAddress_zip(acc),asyncJob);
        test.stopTest();
    } 
    
      static testMethod void processAccountXrefHistorywithSAPPusFourZipCode() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a = HelperTestClass.accountWithAddress();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.withSAPZipCodeAddress(a),asyncJob);
        //Account acc = HelperTestClass.accountWithAddress_zip();
       // updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSZipCodeAddress_zip(acc),asyncJob);
        test.stopTest();
    } 
    
     static testMethod void processAccountXrefHistorywithSFSAllData() {
        test.startTest();
        
        UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        Account a = HelperTestClass.accountNew();
        updateJobController.processAccountXReferenceHistory(HelperTestClass.SFSAllFieldValues(a),asyncJob);
        test.stopTest();
    } 
    
    static testMethod void processAccountXrefHistorywithSFS_AMS_SFS_data() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountNew();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.SFS_AMS_SAPFieldValues(a),asyncJob);  
    	test.stopTest(); 
    } 
    
     static testMethod void processAccountXrefHistorySFS_CountryChange() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountWithAddress();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSCountryChange(a),asyncJob);  
    	test.stopTest(); 
    }
    
    static testMethod void processAccountXrefHistorySFS_CountryChangeReverse() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountWithAddress_OtherCountry();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSCountryChange_OtherCountry(a),asyncJob);  
    	test.stopTest(); 
    }
    
    static testMethod void processAccountXrefHistorySameSFS_AMS() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountWithAddress_OtherCountry();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.withSFSandAMSSame(a),asyncJob); 
    }
    
    
    static testMethod void processAccountXrefHistorySFS_POBOX() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountWithAddress();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.SFSPoBox(a),asyncJob); 
    }
    
    static testMethod void processAccountXrefHistoryAMSndSFS_POBOX() {
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
    	Account a = HelperTestClass.accountWithAddress_pobox();
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.AMSandSFSPoBox(a),asyncJob); 
    }
    
    static testMethod void processAccountXrefHistory_zipCode() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountWithAddress_zipCode(); 
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.zipCodeTest(a),asyncJob);  
    }
    
    static testMethod void processAccountXrefHistory_SAPtwoRecord() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountNew(); 
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.TwoTestSAP(a),asyncJob);  
    	//updateJobController.processAccountXReferenceHistory(HelperTestClass.TwoTestSFS(a),asyncJob);  
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.TwoTestAMS(a),asyncJob);
    	
    	Account_X_Reference__c ax2 = HelperTestClass.xAccountSAP(a);
    	
    	
    	Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'STATE__C';
        axHistory1.parentId = ax2.id;
        insert axHistory1; 
        
        updateJobController.getChangedSAPFields(axHistory1,ax2);
        
    	test.stopTest();
    }
    
    
      static testMethod void processAccountXrefHistory_SfstwoRecord() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountNew(); 
    	 
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.TwoTestSFS(a),asyncJob);  
    	
        Account_X_Reference__c ax1 = HelperTestClass.xAccountWithSFSRec(a);
        Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSFSRec(a);
        
        set<Account_X_Reference__c> setax = new set<Account_X_Reference__c>();
        setax.add(ax1); 
        setax.add(ax2);
    	UpdateAccountAddressBatchController.comapreAMSorSFSList(setax);
        
    	test.stopTest();
    }
    
    
     static testMethod void processAccountXrefHistory_compare() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountNew(); 
    	
    	set<Account_X_Reference__c> SFSset = new set<Account_X_Reference__c>();
    	Account_X_Reference__c ax1= HelperTestClass.xAccountWithSFSRec(a);
    	SFSset.add(ax1);
    	
    	set<Account_X_Reference__c> AMSset = new set<Account_X_Reference__c>();
    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithAMSRec(a);
		AMSset.add(ax2);
		
		updateJobController.compareAMSWithSFS(AMSset,SFSset);
		
    	test.stopTest();
    }
    
    
     static testMethod void processAccountXrefHistory_SFS() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountWithAddress(); 
    	
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.zipCodeTestNew(a),asyncJob);  
    	test.stopTest();
    }
    
       static testMethod void processAccountXrefHistory_SAPTwo() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountWithAddress(); 
    	
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.TwoTestSAP(a),asyncJob);  
    	test.stopTest();
    }
    
      static testMethod void processAccountXrefHistory_AMSandSFS() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountWithAddress(); 
    	
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.AMSandSFSRecord(a),asyncJob);  
    	test.stopTest();
    }
    
    
    static testMethod void processAccountXrefHistory_AMSandSAP() {
    	
    	test.startTest();
    	 
    	UpdateAccountAddressBatch job = new UpdateAccountAddressBatch();
        
        job.query = QueryServiceClass.getAccountXReferenceHistory(String.ValueOf(Date.Today()));
      
        Id BatchId=Database.executeBatch(job);
         
        AsyncApexJob  asyncJob= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedDate ,CompletedDate, CreatedBy.Email,ExtendedStatus from 
        AsyncApexJob where Id =:BatchId];
        
        Account_Address_Automation__c taaCusSet = new Account_Address_Automation__c();
        taaCusSet.maxDailyLimit__c= 1;
        taaCusSet.ExcludeCustomerRecordTYpe__c= 'Customer Account';
        insert taaCusSet;
        
        UpdateAccountAddressBatchController updateJobController= new UpdateAccountAddressBatchController();
        
    	Account a = HelperTestClass.accountWithAddress(); 
    	
    	updateJobController.processAccountXReferenceHistory(HelperTestClass.AMSandSAPRecord(a),asyncJob); 
    	set<String> zip = new set<String>(); 
    	zip.add('abc');
    	QueryServiceClass.dirtyDTNAccounts(zip);
//    	UpdateAccountAddressBatch.monitoringLog('test',1,'test1');
    	test.stopTest();
    }
    
    
       
    
}