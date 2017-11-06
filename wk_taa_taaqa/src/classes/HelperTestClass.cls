public class HelperTestClass {
    //Account
    public static Account accountNew(){
        Account a = new Account();
        a.Name = 'Demo Account';
        //a.AD_Request_date__c=Date.ValueOf('06/06/201');
        //a.AnnualRevenue=1000/0;
        insert a;
        return a;
    }
    //Account X Reference without address
    public static Account_X_Reference__c xAccountWithAMS(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
     public static Account_X_Reference__c xAccountWithSFS(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
        public static Account_X_Reference__c xAccountWithSFSZipCode(Account a){
	        Account_X_Reference__c ax = new Account_X_Reference__c();
	        ax.Name = 'Demo xAccount with SFS';
	        ax.Application__c = 'SFS';
	        ax.SFS_Office_Number__c = '0';
	        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '550151234';
	        ax.Account__c = a.id;
	        insert ax;
	        return ax;
       }
       
       public static Account_X_Reference__c xAccountWithSFSCountryChange(Account a){
       	    Account_X_Reference__c ax = new Account_X_Reference__c();
	        ax.Name = 'Demo xAccount with SFS';
	        ax.Application__c = 'SFS';
	        ax.SFS_Office_Number__c = '0';
	        ax.Ship_To_Street_Line_1__c = 'street1';
	        ax.Ship_To_Street_Line_2__c = 'street2';
        	ax.Ship_To_City__c = 'SITYtEST';
        	ax.Ship_To_State__c = 'MA';
        	ax.Ship_To_Country__c = 'UK';
        	ax.Ship_To_Zip_Postal_Code__c = '13456';
            ax.Account__c = a.id;
	        insert ax;
	        return ax;
       }
      
      public static Account_X_Reference__c xAccountWithSFSCountryChange_otherCountry(Account a){
       	    Account_X_Reference__c ax = new Account_X_Reference__c();
	        ax.Name = 'Demo xAccount with SFS';
	        ax.Application__c = 'SFS';
	        ax.SFS_Office_Number__c = '0';
	        ax.Ship_To_Street_Line_1__c = 'street1';
	        ax.Ship_To_Street_Line_2__c = 'street2';
        	ax.Ship_To_City__c = 'SITYtEST';
        	ax.Ship_To_State__c = 'MA';
        	ax.Ship_To_Country__c = 'US';
        	ax.Ship_To_Zip_Postal_Code__c = '13456';
            ax.Account__c = a.id;
	        insert ax;
	        return ax;
       }
    public static Account_X_Reference__c xAccountWithSAPZipCode(Account a){
	        Account_X_Reference__c ax = new Account_X_Reference__c();
	        ax.Name = 'Demo xAccount with SAP';
	        ax.Application__c = 'SAP';
	       // ax.SFS_Office_Number__c = '0';
	        ax.POSTALCODE__C = '550151234';
	        ax.Account__c = a.id;
	        insert ax;
	        return ax;
       }
       
    public static Account_X_Reference__c xAccountWithSFSZipCode_zip(Account a){
	        Account_X_Reference__c ax = new Account_X_Reference__c();
	        ax.Name = 'Demo xAccount with SFS';
	        ax.Application__c = 'SFS';
	        ax.SFS_Office_Number__c = '0';
	        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '5501565';
	        ax.Account__c = a.id;
	        insert ax;
	        return ax;
       }
    
    //Account X Reference with postal address address
    public static Account_X_Reference__c xAccountWithAMSPostal(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    //Account X Reference with po box address only
    public static Account_X_Reference__c xAccountWithAMSBlankValue(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = '';
        ax.Ship_To_Street_Line_2__c = '';
        ax.Ship_To_City__c = '';
        ax.Ship_To_State__c = '';
        ax.Ship_To_Country__c = '';
        ax.Ship_To_Zip_Postal_Code__c = '';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithAMSPoBox(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'PO BOX 123';
        ax.Ship_To_Street_Line_2__c = 'Demo Street Line 2';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Dem State';
        ax.Ship_To_Country__c = 'Demo Country';
        ax.Ship_To_Zip_Postal_Code__c = '12345';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    //Account X Reference with Street 1 and Street 2 address and other address
    public static Account_X_Reference__c xAccountWithAMSAndAddress(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo Street 1';
        ax.Ship_To_Street_Line_2__c = 'Demo Street 2';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'US';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
     public static Account_X_Reference__c xAccountSAP(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = 'Demo Street 1 Demo Street 2';
        //ax.Ship_To_Street_Line_2__c = 'Demo Street 2';
        ax.City__c = 'Demo City';
        ax.State__c = 'Demo State';
        ax.Country__c = 'US';
        ax.PostalCode__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    
    public static Account_X_Reference__c xAccountWithAMSsameSAP(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo Street 1';
        ax.Ship_To_Street_Line_2__c = 'Demo Street 2';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'US';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithDiffCountry(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo Street 1';
        ax.Ship_To_Street_Line_2__c = 'Demo Street 2';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'DemoCountry';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithAMSAndAddress2(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo';
        ax.Ship_To_Street_Line_2__c = 'Demo';
        ax.Ship_To_City__c = 'City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'US';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    //Account X Reference with Street 2 address and other address
    public static Account_X_Reference__c xAccountWithAMSAndStreet2Address(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        //ax.Ship_To_Street_Line_1__c = '';
        ax.Ship_To_Street_Line_2__c = 'Demo Street 2';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'Demo Country';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    //x Account WithSAP And po box Address only
    public static Account_X_Reference__c xAccountWithSAPBlankValue(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SAP';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = '';
        ax.City__c = '';
        ax.State__c = '';
        ax.PostalCode__c = '';
        ax.Country__c = '';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithSAPPoBox(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SAP';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = 'po box 123';
        ax.City__c = 'Demo City';
        ax.State__c = 'Demo State';
        ax.PostalCode__c = '45455';
        ax.Country__c = 'Demo Country';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    //x Account WithSAP And Address
    public static Account_X_Reference__c xAccountWithSAPAndAddress(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SAP';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = 'Demo Street Address';
        ax.City__c = 'Demo City';
        ax.State__c = 'Demo State';
        ax.PostalCode__c ='*****';
        ax.Country__c = 'US';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithSAPAndAddress2(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SAP';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = 'Demo Street Address';
        ax.City__c = 'City';
        ax.State__c = 'State';
        ax.PostalCode__c = 'Demo123';
        ax.Country__c = 'US';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    
     //Account X Reference with Street 1 and Street 2 address and other address
    public static Account_X_Reference__c xAccountWithoutAMSStreetAddress(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo Street 1';
        ax.Ship_To_Street_Line_2__c = '';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'US';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static List<Account_X_Reference__History> xAccountWithAMSAndAddressHistory(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithAMSAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_STREET_LINE_1__C';
        
        
        system.debug('***accXrefHistoryList***'+accXrefHistoryList.size()); 
        
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    public static Account accountWithAddress(){
        Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='55015';
        a.BillingCountry='US';
        insert a;
        return a;
    }
    
     public static Account accountWithAddress_pobox(){
        Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet po box';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='55015';
        a.BillingCountry='US';
        insert a;
        return a;
    }
    
     public static Account accountWithAddress_OtherCountry(){
        Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='55015';
        a.BillingCountry='UK';
        insert a;
        return a;
    }
     public static Account accountWithAddress_zip(){
        Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='5502564';
        a.BillingCountry='US'; 
        insert a;
        return a;
    }
    
    public static Account accountWithdifferntCountry(){
        Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='55015';
        a.BillingCountry='Demo Country';
        insert a;
        return a;
    }
    
    public static Account_X_Reference__c xAccountWithoutAMSUSStreetAddress(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with AMS';
        ax.Application__c = 'AMS';
        ax.Ship_To_Street_Line_1__c = 'Demo Street 1';
        ax.Ship_To_Street_Line_2__c = '';
        ax.Ship_To_City__c = 'Demo City';
        ax.Ship_To_State__c = 'Demo State';
        ax.Ship_To_Country__c = 'US';
        ax.Ship_To_Zip_Postal_Code__c = 'Demo123';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithSAPWithDifferentCountry(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SAP';
        ax.Application__c = 'SAP';
        ax.Street_Address__c = 'Demo Street Address';
        ax.City__c = 'Demo City';
        ax.State__c = 'Demo State';
        ax.PostalCode__c = 'Demo123';
        ax.Country__c = 'Canada';
        ax.Account__c = a.id;
        insert ax;
        return ax;
    }
    
    public static List<Account_X_Reference__History> xAccountWithAMSWithoutStreetLine(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithoutAMSStreetAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> xAccountWithAMSWithCountryChanges(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithoutAMSUSStreetAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> xAccountWithAMSWithPOBox(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithAMSPoBox(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    
    public static List<Account_X_Reference__History> withSAPAccounts(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithSAPAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> withSAPPOBOXAccounts(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithSAPPoBox(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    public static List<Account_X_Reference__History> withSAPDifferetCoutry(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        ax=HelperTestClass.xAccountWithSAPWithDifferentCountry(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> withAMSMultipleAddress(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
         Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        Account_X_Reference__c ax2=new Account_X_Reference__c();
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithAMSAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_STREET_LINE_1__C';
        accXrefHistoryList.add(axhistory);
        
        ax2=HelperTestClass.xAccountWithAMSAndAddress2(a);
        axhistory2.parentId=ax2.Id;
        axhistory2.field='SHIP_TO_STREET_LINE_1__C';
        accXrefHistoryList.add(axhistory2);
        
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
   
    public static List<Account_X_Reference__History> withSAPMultipleAddress(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory3 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        Account_X_Reference__c ax2=new Account_X_Reference__c();
        Account_X_Reference__c ax3=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithSAPAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        
        ax2=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory2.parentId=ax2.Id;
        axhistory2.field='CITY__C';
        accXrefHistoryList.add(axhistory2);
        
       /* ax3=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory3.parentId=ax3.Id;
        axhistory3.field='STATE__C';
        accXrefHistoryList.add(axhistory3);*/
        
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
    
   public static List<Account_X_Reference__History> withSAPAllBlankValues(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
         Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithSAPBlankValue(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    public static List<Account_X_Reference__History> withSAPPostOfficeChanges(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
         Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory.parentId=ax.Id;
        axhistory.field='POSTALCODE__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
    
    
    public static List<Account_X_Reference__History> withAMSAllBlankValues(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
         Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithAMSBlankValue(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_STREET_LINE_1__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> withAMSwithDifferentCoutry(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
         Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__c ax=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithDiffCountry(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_STREET_LINE_1__C';
        accXrefHistoryList.add(axhistory);
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
     public static List<Account_X_Reference__History> withSAPMultipleAddressWithdiffentField(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory3 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory4 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory5 = new Account_X_Reference__History ();
        
        Account_X_Reference__c ax=new Account_X_Reference__c();
        Account_X_Reference__c ax2=new Account_X_Reference__c();
        Account_X_Reference__c ax3=new Account_X_Reference__c();
        Account_X_Reference__c ax4=new Account_X_Reference__c();
        Account_X_Reference__c ax5=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithSAPAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='CITY__C';
        accXrefHistoryList.add(axhistory);
        
        ax2=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory2.parentId=ax2.Id;
        axhistory2.field='POSTALCODE__C';
        accXrefHistoryList.add(axhistory2);
        
        ax3=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory3.parentId=ax3.Id;
        axhistory3.field='STATE__C';
        accXrefHistoryList.add(axhistory3);
        
        ax4=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory4.parentId=ax4.Id;
        axhistory4.field='POSTALCODE__C';
        accXrefHistoryList.add(axhistory4);
        
        ax5=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory5.parentId=ax5.Id;
        axhistory5.field='Country__c';
        accXrefHistoryList.add(axhistory5);
       
       
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
     public static List<Account_X_Reference__History> withSAPAMSMultipleAddress(Account a){
        Account_X_Reference__History axhistory = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory2 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory3 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory4 = new Account_X_Reference__History ();
        Account_X_Reference__History axhistory5 = new Account_X_Reference__History ();
        
        Account_X_Reference__c ax=new Account_X_Reference__c();
        Account_X_Reference__c ax2=new Account_X_Reference__c();
        Account_X_Reference__c ax3=new Account_X_Reference__c();
        Account_X_Reference__c ax4=new Account_X_Reference__c();
        Account_X_Reference__c ax5=new Account_X_Reference__c();
        
        List<Account_X_Reference__History> accXrefHistoryList=new List<Account_X_Reference__History>();
        
        ax=HelperTestClass.xAccountWithAMSAndAddress(a);
        axhistory.parentId=ax.Id;
        axhistory.field='SHIP_TO_STREET_LINE_1__C';
        accXrefHistoryList.add(axhistory);
        
        ax2=HelperTestClass.xAccountWithSAPAndAddress2(a);
        axhistory2.parentId=ax2.Id;
        axhistory2.field='POSTALCODE__C';
        accXrefHistoryList.add(axhistory2);
        
        insert accXrefHistoryList;
        
        return accXrefHistoryList;
    }
    
    public static List<Account_X_Reference__History> withSFSBlankAddress(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFS(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'Created';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
     public static List<Account_X_Reference__History> withSFSZipCodeAddress(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFSZipCode(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'SHIP_TO_ZIP_POSTAL_CODE__C';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
     public static List<Account_X_Reference__History> withSFSCountryChange(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFSCountryChange(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'Ship_To_Country__c';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> withSFSCountryChange_OtherCountry(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFSCountryChange_otherCountry(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'Ship_To_Country__c';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
     public static List<Account_X_Reference__History> withSFSZipCodeAddress_zip(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFSZipCode(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'SHIP_TO_ZIP_POSTAL_CODE__C';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
    
    
    public static List<Account_X_Reference__History> SFSAllFieldValues(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSFSRec(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
    	axHistory.Field = 'Created';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> SFS_AMS_SAPFieldValues(Account a){
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithSFSRec(a);
    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSAPRec(a);
    	Account_X_Reference__c ax3 = HelperTestClass.xAccountWithAMSRec(a);
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
    	axHistory1.Field = 'Created';
        axHistory1.parentId = ax1.id;
        historyList.add(axHistory1);
        
    	Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
    	axHistory2.Field = 'Created';
        axHistory2.parentId = ax2.id;
        historyList.add(axHistory2);
        
    	Account_X_Reference__History axHistory3 = new Account_X_Reference__History();
    	axHistory3.Field = 'Created';
        axHistory3.parentId = ax3.id;
        historyList.add(axHistory3);
        
        insert axHistory1;
        insert axHistory2;
        insert axHistory3;
        
        return historyList;
    }
    
    
    
    public static Account_X_Reference__c xAccountWithSFSRec(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street1';
        ax.SHIP_TO_STREET_LINE_2__C = 'street2';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '12345';
        
        insert ax;
        return ax;
    }
    
     public static Account_X_Reference__c xAccountWithAMSRec(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'AMS';
        //ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11';
        ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '12345';
        
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithAMSRecsameSFS(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11';
        ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '12345';
        
        insert ax;
        return ax;
    }
    
    public static Account_X_Reference__c xAccountWithSFSandAMSSameRec(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11';
        ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '12345';
        
        insert ax;
        return ax;
    }
     public static Account_X_Reference__c xAccountWithSAPRec(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SAP';
        //ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.STREET_ADDRESS__C = 'street1221';
        ax.CITY__C = 'street2S3';
        ax.STATE__C = 'CityTest';
        ax.POSTALCODE__C = '12345';
        ax.Country__c = 'US';
        insert ax;
        return ax;
    }
    
     public static List<Account_X_Reference__History> withSAPZipCodeAddress(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax = HelperTestClass.xAccountWithSAPZipCode(a);
    	
    	Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'POSTALCODE__C';
        axHistory.parentId = ax.id;
        historyList.add(axHistory);
        insert axHistory;
        
        return historyList;
    }
    
  
    
    public static List<Account_X_Reference__History> withSFSandAMSSame(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithAMSRec(a);
        Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSFSandAMSSameRec(a);
        
        Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'SHIP_TO_STREET_LINE_1__C';
        axHistory.parentId = ax1.id;
        insert axHistory;
        historyList.add(axHistory);
        
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax2.id;
        insert axHistory1;
        historyList.add(axHistory1);
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> SFSPoBox(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithSFSpoBox(a);
       
        
        Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'SHIP_TO_STREET_LINE_1__C';
        axHistory.parentId = ax1.id;
        historyList.add(axHistory);
        insert axHistory;
        return historyList;
    }
    
    //AMS AND SFS PO BOX
    public static List<Account_X_Reference__History> AMSandSFSPoBox(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithSFSpoBox(a);
        Account_X_Reference__c ax2 = HelperTestClass.xAccountWithAMSPoBox(a);
        Account_X_Reference__c ax3 = HelperTestClass.xAccountWithSAPRec(a);
        
        Account_X_Reference__History axHistory = new Account_X_Reference__History();
        axHistory.Field = 'Created';
        axHistory.parentId = ax1.id;
        historyList.add(axHistory);
        insert axHistory;
        
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax3.id;
        historyList.add(axHistory2);
        
        insert axHistory2;
        
        return historyList;
    }
    
    
    public static Account_X_Reference__c xAccountWithSFSpoBox(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11 PO BOX';
        ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '12345';
        
        insert ax;
        return ax;
    }
    
     
    
    public static List<Account_X_Reference__History> zipCodeTest(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSFSZipCodeTest(a);
 
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'SHIP_TO_ZIP_POSTAL_CODE__C';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        return historyList;
    }
    
     public static Account_X_Reference__c xAccountWithSFSZipCodeTest(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11 PO BOX';
        ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '5501598';
        
        insert ax;
        return ax;
    }
    
    
     public static List<Account_X_Reference__History> zipCodeTestNew(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSFSZipCodeTestNew(a);
 
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'SHIP_TO_ZIP_POSTAL_CODE__C';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        return historyList;
    }
    
     public static Account_X_Reference__c xAccountWithSFSZipCodeTestNew(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SFS';
        ax.SFS_Office_Number__c = '0';
        ax.Account__c = a.id;
        ax.SHIP_TO_STREET_LINE_1__C = 'street11 PO BOX';
        //ax.SHIP_TO_STREET_LINE_2__C = 'street23';
        ax.SHIP_TO_CITY__C = 'CityTest';
        ax.SHIP_TO_STATE__C = 'NA';
        ax.Ship_To_Country__c = 'US';
        ax.SHIP_TO_ZIP_POSTAL_CODE__C = '5501598';
        
        insert ax;
        return ax;
    }
    
      public static List<Account_X_Reference__History> zipCodeTestSAP(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSAPZipCodeTest(a);
 
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'POSTALCODE__C';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> TwoTestSAP(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountSAP(a);
 		Account_X_Reference__c ax3 = HelperTestClass.xAccountSAP(a);
 		
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax3.id;
        historyList.add(axHistory2);
        insert axHistory2;
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> TwoTestSFS(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithSFSRec(a);
 		Account_X_Reference__c ax3 = HelperTestClass.xAccountWithSFSRec(a);
 		
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax3.id;
        historyList.add(axHistory2);
        insert axHistory2;
        
        return historyList;
    }
    
      public static List<Account_X_Reference__History> TwoTestAMS(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();

    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithAMSRec(a);
 		Account_X_Reference__c ax3 = HelperTestClass.xAccountWithAMSRec(a);
 		
        Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax2.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax3.id;
        historyList.add(axHistory2);
        insert axHistory2;
        
        return historyList;
    }
    
    public static List<Account_X_Reference__History> AMSandSFSRecord(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithAMSRec(a);
    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithAMSRecsameSFS(a);
    	Account_X_Reference__c ax3 = HelperTestClass.xAccountWithSAPRec(a);
    	
    	Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax1.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax2.id;
        historyList.add(axHistory2);
        insert axHistory2;
        
        Account_X_Reference__History axHistory3 = new Account_X_Reference__History();
        axHistory3.Field = 'Created';
        axHistory3.parentId = ax3.id;
        historyList.add(axHistory3);
        insert axHistory3;
        
        return historyList;	
    }
    
    public static List<Account_X_Reference__History> AMSandSAPRecord(Account a){
    	List<Account_X_Reference__History> historyList = new List<Account_X_Reference__History>();
    	Account_X_Reference__c ax1 = HelperTestClass.xAccountWithAMSsameSAP(a);
    	Account_X_Reference__c ax2 = HelperTestClass.xAccountWithAMSRecsameSFS(a);
    	Account_X_Reference__c ax3 = HelperTestClass.xAccountSAP(a);
    	
    	Account_X_Reference__History axHistory1 = new Account_X_Reference__History();
        axHistory1.Field = 'Created';
        axHistory1.parentId = ax1.id;
        historyList.add(axHistory1);
        insert axHistory1;
        
        Account_X_Reference__History axHistory2 = new Account_X_Reference__History();
        axHistory2.Field = 'Created';
        axHistory2.parentId = ax2.id;
        historyList.add(axHistory2);
        insert axHistory2;
        
        Account_X_Reference__History axHistory3 = new Account_X_Reference__History();
        axHistory3.Field = 'Created';
        axHistory3.parentId = ax3.id;
        historyList.add(axHistory3);
        insert axHistory3;
        
        return historyList;	
    
    }
    
     public static Account_X_Reference__c xAccountWithSAPZipCodeTest(Account a){
        Account_X_Reference__c ax = new Account_X_Reference__c();
        ax.Name = 'Demo xAccount with SFS';
        ax.Application__c = 'SAP';
        ax.STREET_ADDRESS__C = 'street1221';
        ax.CITY__C = 'street2S3';
        ax.STATE__C = 'CityTest';
        ax.POSTALCODE__C = '5501598';
        ax.Country__c = 'US';
        
        insert ax;
        return ax;
    }
    
    public static Account accountWithAddress_zipCode(){
    	Account a = new Account();
        a.Name = 'Demo Account';
        a.BILLINGSTREET='BillingStreet';
        a.BILLINGCITY='BillingCity';
        a.BILLINGSTATE='BillingState';
        a.BILLINGPOSTALCODE='5501565';
        a.BillingCountry='US';
        insert a;
        return a;
    }
   
}