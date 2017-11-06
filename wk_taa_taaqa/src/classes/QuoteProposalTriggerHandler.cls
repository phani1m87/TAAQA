/*
    **************************************************************************
    Name    :   QuoteProposalTriggerHandler 
    Usage   :   This class is invoked in trigger QuoteProposalTrigger and used to populate Ship To/Bill To on Quote/Proposal based on ERP Account/Ship To Account is populated
                Added logic to populate ERP Account on Quote Proposal for below conditions:
                    1. When Quote/Proposal Record Type = SAP Subscription or SAP Books and associated Account having one SAP X-Reference Account attached to it else no need to populate ERP Account
                    2. When Quote/Proposal Record Type = AMS and associated Account having one AMS X-Reference Account attached to it else no need to populate ERP Account  
                SMS-82-> Added additional 10 more fields to populate information from X-Ref Account to Quote/Proposal
                CPQ-209-> Replaced below ICAdmin fields 
                    a. ERP Authentication Type(ERP_Authentication_Type__c)
                    b. ERP IDs Issued(ERP_IDs_Issued__c)
                    c. ERP Max IDs Allowed(ERP_Max_IDs_Allowed__c)
                   with:
                    a. New Authentication Type(New_Authentication_Type__c)  
                    b. New IDs Issued(New_IDs_Issued__c)
                    c. New Max IDs Allowed(New_Max_IDs_Allowed__c)
                SMS-98-> Added below fields to populate Sold To Information from associated X-Ref Account/Account
                    1. Sold_To_Street_Address__c
                    2. Sold_To_City__c
                    3. Sold_To_State__c
                    4. Sold_To_Postalcode__c
                    5. Sold_To_Country__c
                    6. Sold_To_Phone__c
                    7. Sold_To_Email__c
                SMS-113-> Added logic to update IC Admin Quote(IC_Admin_Quote__c) as checked upon update of field Approval Stage to “Submitted to COP” when Quote/Proposal has IC Admin products attached
        
    Version    |    Name            |    Date           
    1.0             Rajesh Meti          17-Nov-2014  
    2.0             Rajesh Meti          10-Dec-2014 
    3.0             Rajesh Meti          17-Dec-2014 
    4.0             Rajesh Meti          20-Jan-2015
    5.0             Rajesh Meti          27-Jan-2015
    6.0             Rajesh Meti          07-Apr-2015
    7.0             Jack Melim           27-Oct-2015 changed  to add 'SAP Cancellations' Recordtype Awareness
    8.0             SHIVAJI              11-Oct-2017 AOP2.0 Changes (SMS-930 IC Admin)
    
    Trigger : QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert, before update)
    
    ***************************************************************************
*/

public class QuoteProposalTriggerHandler { 
    
    //Added By line 43-51 Praveen Bala. Date 10/22/2015
    public static boolean hasAlreadyRun = false;
    
    public static boolean hasAlreadyRunMethod(){
        return hasAlreadyRun;
    }
    
    public static void setAlreadyRunMethod(){
        hasAlreadyRun = true;
    } 

    //for before insert event    
    public void onBeforeInsert(List<Apttus_Proposal__Proposal__c> newQuotes, Map<ID, Apttus_Proposal__Proposal__c> newQuoteMap) {  
        
        Map<Id, RecordType> quoteProposalRecordTypeMap = new Map<Id,RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType='Apttus_Proposal__Proposal__c']);
        
        Map<Id, Apttus_Config2__PriceList__c> priceListMap = new Map<Id, Apttus_Config2__PriceList__c>([SELECT Id, Name FROM Apttus_Config2__PriceList__c]);
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> SAPaccountIds = new Set<Id>();
        Set<Id> AMSaccountIds = new Set<Id>();
        Set<Id> XRefSAPaccountIds = new Set<Id>();
        Set<Id> XRefAMSaccountIds = new Set<Id>();      
        Set<Id> accountXReferenceIds = new Set<Id>();
        Map<Id,Id> SAPaccountIdXRefAccountIdMap = new Map<Id,Id>();
        Map<Id,Id> AMSaccountIdXRefAccountIdMap = new Map<Id,Id>();
        Map<Id,Id> ProposalToOppIdMap = new Map<Id,Id>();
        Map<Id,Integer> OpportunityNumberofQuotesMap= new Map<Id,Integer>();   
        
        for(Apttus_Proposal__Proposal__c quote : newQuotes) {     
          if(quote.Apttus_Proposal__Opportunity__c != null) {
                opportunityIds.add(quote.Apttus_Proposal__Opportunity__c);
            }
        }
        
        if(opportunityIds.size()>0)
        {
         AggregateResult[] groupedResults=[select Apttus_Proposal__Opportunity__c,count(Id) from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c In:opportunityIds  group by Apttus_Proposal__Opportunity__c];
         For(AggregateResult ar:groupedResults)
         {
          OpportunityNumberofQuotesMap.put((ID)ar.get('Apttus_Proposal__Opportunity__c'),(Integer)ar.get('expr0'));
         }
        }
        
        for(Apttus_Proposal__Proposal__c quote : newQuotes) {  
            
           if(OpportunityNumberofQuotesMap.get(quote.Apttus_Proposal__Opportunity__c)>0)
            quote.Apttus_Proposal__Primary__c=false;
           
            
            if(quote.Apttus_Proposal__Account__c != null) {
                accountIds.add(quote.Apttus_Proposal__Account__c);
            }
            
            
            //changed 10/27/2015 to add 'SAP Cancellations'
            if(quote.Apttus_Proposal__Account__c != null && 
              (quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name =='SAP Books' || 
               quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Subscription' ||
               quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Cancellations')) 
            {
                SAPaccountIds.add(quote.Apttus_Proposal__Account__c);
            }
            
            if(quote.Apttus_Proposal__Account__c != null && quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'AMS Proposal') {
                AMSaccountIds.add(quote.Apttus_Proposal__Account__c);
            }     
        }
        
        
        
        for(AggregateResult ar : [SELECT count(Id) SAPxrefcount, Application__c, Account__c FROM Account_X_Reference__c WHERE Application__c = 'SAP' AND Account__c IN :SAPaccountIds GROUP BY Application__c, Account__c]) {
            if(ar.get('SAPxrefcount') == 1) {
                XRefSAPaccountIds.add((Id)ar.get('Account__c'));
            }           
        }
        
        for(AggregateResult ar : [SELECT count(Id) AMSxrefcount, Application__c, Account__c FROM Account_X_Reference__c WHERE Application__c = 'AMS' AND Account__c IN :AMSaccountIds GROUP BY Application__c, Account__c]) {
            if(ar.get('AMSxrefcount') == 1) {
                XRefAMSaccountIds.add((Id)ar.get('Account__c'));
            }           
        }           
                
        for(Account_X_Reference__c SAPxref : [SELECT Id, Account__c FROM Account_X_Reference__c WHERE Application__c = 'SAP' AND Account__c IN :XRefSAPaccountIds]) {
            SAPaccountIdXRefAccountIdMap.put(SAPxref.Account__c, SAPxref.Id);
            accountXReferenceIds.add(SAPxref.Id);
        }
        
        for(Account_X_Reference__c AMSxref : [SELECT Id, Account__c FROM Account_X_Reference__c WHERE Application__c = 'AMS' AND Account__c IN :XRefAMSaccountIds]) {
            AMSaccountIdXRefAccountIdMap.put(AMSxref.Account__c, AMSxref.Id);
            accountXReferenceIds.add(AMSxref.Id);
        } 
        
        Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Phone FROM Account 
                                                             WHERE Id IN: accountIds]);
                                                             
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity> ([SELECT Id, Primary_Contact_for_Proposal__r.Email FROM Opportunity WHERE Id IN: opportunityIds]);
        
        Map<Id, Account_X_Reference__c> accountXReferenceMap = new Map<Id,Account_X_Reference__c>([SELECT Id, AMS_Account_Grouping__c, AMS_Special_Agreement__c, 
                                                                Bill_To_Partner_Number__c,  Bill_To_City__c, Bill_To_Contact_Name__c, Bill_To_Country__c, Bill_To_State__c, Bill_To_Street_Line_1__c, Bill_To_Street_Line_2__c, Bill_To_Zip_Postal_Code__c, ERP_Account_Name__c, Ship_To_Partner_Number__c, Ship_To_City__c, Ship_To_Contact_Name__c, Ship_To_Country__c, Ship_To_State__c, 
                                                                Ship_To_Street_Line_1__c, Ship_To_Street_Line_2__c, Ship_To_Zip_Postal_Code__c, Bill_To_Phone__c, Bill_To_Fax__c, 
                                                                Bill_To_Account_Name__c, Ship_To_Phone__c, Ship_To_Fax__c, Ship_To_Account_Name__c, IP_Prompt__c, Authentication_Type__c, 
                                                                Max_IDs_Allowed__c, IDs_Issued__c, Street_Address__c, City__c, State__c, Postalcode__c, Country__c, Phone__c, Email__c,
                                                                /*SAP_IC_Trial_Account_Number__c,*/ IC_Contact_First_Name__c, IC_Contact_Last_Name__c, IC_Contact_Email__c, IC_Contact_Phone__c, Access_Type__c, New_Authentication_Type__c, New_Max_IDs_Allowed__c, New_IDs_Issued__c 
                                                                FROM Account_X_Reference__c WHERE Id IN :accountXReferenceIds]);
        
        for(Apttus_Proposal__Proposal__c quote : newQuotes) {
            Id XRefAccountId = null;
            //changed 10/27/2015 to add 'SAP Cancellations'
            if(quote.Apttus_Proposal__Account__c != null && SAPaccountIdXRefAccountIdMap.containsKey(quote.Apttus_Proposal__Account__c) && 
              (quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name =='SAP Books' || 
               quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Subscription' ||
               quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Cancellations')) 
            {
                XRefAccountId = SAPaccountIdXRefAccountIdMap.get(quote.Apttus_Proposal__Account__c);                    
            }
            
            if(quote.Apttus_Proposal__Account__c != null && AMSaccountIdXRefAccountIdMap.containsKey(quote.Apttus_Proposal__Account__c) && quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'AMS Proposal') {
                XRefAccountId = AMSaccountIdXRefAccountIdMap.get(quote.Apttus_Proposal__Account__c);
            }           
            //logic to populate ERP Account and Ship To/ Bill To information
            if(accountXReferenceMap.containsKey(XRefAccountId)) {
                quote.ERP_Account__c = XRefAccountId;
                quote.AMS_Account_Grouping__c = accountXReferenceMap.get(XRefAccountId).AMS_Account_Grouping__c;
                quote.AMS_Special_Agreement__c = accountXReferenceMap.get(XRefAccountId).AMS_Special_Agreement__c;
                quote.SAP_Bill_To_Partner_Number__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Partner_Number__c;
                quote.ERP_Bill_To_City__c = accountXReferenceMap.get(XRefAccountId).Bill_To_City__c;
                quote.ERP_Bill_To_Contact_Name__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Contact_Name__c;
                quote.ERP_Bill_To_Country__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Country__c;
                quote.ERP_Bill_To_State__c = accountXReferenceMap.get(XRefAccountId).Bill_To_State__c;
                quote.ERP_Bill_To_Street_1__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Street_Line_1__c;
                quote.ERP_Bill_To_Street_2__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Street_Line_2__c;
                quote.ERP_Bill_To_Zip_Postal_Code__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Zip_Postal_Code__c;
                quote.ERP_Account_Name__c = accountXReferenceMap.get(XRefAccountId).ERP_Account_Name__c;                 
                quote.SAP_Ship_To_Partner_Number__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Partner_Number__c;
                quote.ERP_Ship_To_City__c = accountXReferenceMap.get(XRefAccountId).Ship_To_City__c;
                quote.ERP_Ship_To_Contact_Name__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Contact_Name__c;
                quote.ERP_Ship_To_Country__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Country__c;
                quote.ERP_Ship_To_State__c = accountXReferenceMap.get(XRefAccountId).Ship_To_State__c;
                quote.ERP_Ship_To_Street_1__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Street_Line_1__c;
                quote.ERP_Ship_To_Street_2__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Street_Line_2__c;
                quote.ERP_Ship_To_Zip_Postal_Code__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Zip_Postal_Code__c;    
                quote.ERP_Bill_To_Phone__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Phone__c;
                quote.ERP_Bill_To_Fax__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Fax__c;
                quote.ERP_Bill_To_Account_Name__c = accountXReferenceMap.get(XRefAccountId).Bill_To_Account_Name__c; 
                quote.ERP_Ship_To_Phone__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Phone__c;
                quote.ERP_Ship_To_Fax__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Fax__c;
                quote.ERP_Ship_To_Account_Name__c = accountXReferenceMap.get(XRefAccountId).Ship_To_Account_Name__c;
                quote.ERP_IP_Prompt__c = accountXReferenceMap.get(XRefAccountId).IP_Prompt__c; 
                quote.New_Authentication_Type__c = accountXReferenceMap.get(XRefAccountId).Authentication_Type__c;
                
                //*** 10/23 Commented since validation rules were breaking - changed during Prod issue troubleshoot
                /*
                if(accountXReferenceMap.get(XRefAccountId).Max_IDs_Allowed__c != null)
                    quote.New_Max_IDs_Allowed__c = accountXReferenceMap.get(XRefAccountId).Max_IDs_Allowed__c;
                if(accountXReferenceMap.get(XRefAccountId).IDs_Issued__c != null)
                    quote.New_IDs_Issued__c = accountXReferenceMap.get(XRefAccountId).IDs_Issued__c;
                */    
                quote.Sold_To_Street_Address__c = accountXReferenceMap.get(XRefAccountId).Street_Address__c; 
                quote.Sold_To_City__c = accountXReferenceMap.get(XRefAccountId).City__c; 
                quote.Sold_To_State__c = accountXReferenceMap.get(XRefAccountId).State__c; 
                quote.Sold_To_Postalcode__c = accountXReferenceMap.get(XRefAccountId).Postalcode__c; 
                quote.Sold_To_Country__c = accountXReferenceMap.get(XRefAccountId).Country__c; 
                quote.Sold_To_Phone__c = accountXReferenceMap.get(XRefAccountId).Phone__c; 
                quote.Sold_To_Email__c = accountXReferenceMap.get(XRefAccountId).Email__c;
                
                System.debug('### : ' + quote.RecordTypeId);
                System.debug('### : ' + quote.Apttus_QPConfig__PriceListId__c);
                System.debug('### : ' + quoteProposalRecordTypeMap);
                System.debug('### : ' + priceListMap);
                
                // *** SMS-930 IC Admin: populate values from X-Ref
                if((quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Subscription' || quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Renewals') && quote.Apttus_QPConfig__PriceListId__c != NULL && priceListMap.get(quote.Apttus_QPConfig__PriceListId__c).Name == 'R&L Price List')
                {
                    // quote.SAP_IC_Trial_Account_Number__c = accountXReferenceMap.get(XRefAccountId).SAP_IC_Trial_Account_Number__c; 
                    quote.IC_Contact_First_Name__c = accountXReferenceMap.get(XRefAccountId).IC_Contact_First_Name__c;
                    quote.IC_Contact_Last_Name__c = accountXReferenceMap.get(XRefAccountId).IC_Contact_Last_Name__c;
                    quote.IC_Contact_Email__c = accountXReferenceMap.get(XRefAccountId).IC_Contact_Email__c;
                    quote.IC_Contact_Phone__c = accountXReferenceMap.get(XRefAccountId).IC_Contact_Phone__c;
                    quote.Access_Type__c = accountXReferenceMap.get(XRefAccountId).Access_Type__c;
                    quote.New_Authentication_Type__c = accountXReferenceMap.get(XRefAccountId).New_Authentication_Type__c;
					
					//*** 10/23 Added below condition since validation rules were breaking - changed during Prod issue troubleshoot
                    if(!String.isBlank(quote.New_Authentication_Type__c) && quote.New_Authentication_Type__c.contains('Standard')){
                    	quote.New_Max_IDs_Allowed__c = accountXReferenceMap.get(XRefAccountId).New_Max_IDs_Allowed__c;
                    	if(quote.Access_Type__c != 'All-Link'){
                    		quote.New_IDs_Issued__c = accountXReferenceMap.get(XRefAccountId).New_IDs_Issued__c;
                    	}
                    }
                }
                 
            }
            
            if(!accountXReferenceMap.containsKey(XRefAccountId) && accountMap.containsKey(quote.Apttus_Proposal__Account__c)) {
                quote.Sold_To_Street_Address__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingStreet; 
                quote.Sold_To_City__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingCity; 
                quote.Sold_To_State__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingState; 
                quote.Sold_To_Postalcode__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingPostalCode; 
                quote.Sold_To_Country__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingCountry; 
                quote.Sold_To_Phone__c = accountMap.get(quote.Apttus_Proposal__Account__c).Phone; 
                quote.Sold_To_Email__c = opportunityMap.get(quote.Apttus_Proposal__Opportunity__c).Primary_Contact_for_Proposal__r.Email;               
            }
        }                       
    }
    
    //for before update event    
    public void onBeforeUpdate(List<Apttus_Proposal__Proposal__c> newQuotes, List<Apttus_Proposal__Proposal__c> oldQuotes, Map<ID, Apttus_Proposal__Proposal__c> newQuoteMap, Map<ID, Apttus_Proposal__Proposal__c> oldQuoteMap) {
        
        Map<Id, RecordType> quoteProposalRecordTypeMap = new Map<Id,RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType='Apttus_Proposal__Proposal__c']);
        Map<Id, Apttus_Config2__PriceList__c> priceListMap = new Map<Id, Apttus_Config2__PriceList__c>([SELECT Id, Name FROM Apttus_Config2__PriceList__c]);
        Set<Id> accountIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> accountXReferenceIds = new Set<Id>();
        set<Id> quoteIds = new Set<Id>();
        set<Id> intelliConnectQuoteIds = new Set<Id>();
        String icProduct = 'Intelliconnect';
        
        for(Apttus_Proposal__Proposal__c quote : newQuotes) {
            if(quote.Apttus_Proposal__Account__c != null) {
                accountIds.add(quote.Apttus_Proposal__Account__c);
            }
            
            if(quote.Apttus_Proposal__Opportunity__c != null) {
                opportunityIds.add(quote.Apttus_Proposal__Opportunity__c);
            }
        
            if(quote.ERP_Account__c != null) {
                accountXReferenceIds.add(quote.ERP_Account__c);
            }
            
            if(quote.Ship_To_ERP_Account__c != null) {
                accountXReferenceIds.add(quote.Ship_To_ERP_Account__c);
            }       

            if(quote.Apttus_Proposal__Approval_Stage__c == 'Submitted to COP' && quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Subscription') {
                quoteIds.add(quote.Id);
            }
        }    
        
        Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Phone FROM Account 
                                                             WHERE Id IN: accountIds]);
                                                             
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity> ([SELECT Id, Primary_Contact_for_Proposal__r.Email FROM Opportunity WHERE Id IN: opportunityIds]);
        
        Map<Id, Account_X_Reference__c> accountXReferenceMap = new Map<Id,Account_X_Reference__c>([SELECT Id, AMS_Account_Grouping__c, AMS_Special_Agreement__c, Bill_To_Partner_Number__c,
                                                                Bill_To_City__c, Bill_To_Contact_Name__c, Bill_To_Country__c, Bill_To_State__c, Bill_To_Street_Line_1__c, Bill_To_Street_Line_2__c, Bill_To_Zip_Postal_Code__c, ERP_Account_Name__c, Ship_To_Partner_Number__c, 
                                                                Ship_To_City__c, Ship_To_Contact_Name__c, Ship_To_Country__c, Ship_To_State__c, Ship_To_Street_Line_1__c, 
                                                                Ship_To_Street_Line_2__c, Ship_To_Zip_Postal_Code__c, Bill_To_Phone__c, Bill_To_Fax__c, Bill_To_Account_Name__c, 
                                                                Ship_To_Phone__c, Ship_To_Fax__c, Ship_To_Account_Name__c, IP_Prompt__c, Authentication_Type__c, Max_IDs_Allowed__c,  
                                                                IDs_Issued__c, Street_Address__c, City__c, State__c, Postalcode__c, Country__c, Phone__c, Email__c, 
                                                                /*SAP_IC_Trial_Account_Number__c,*/ IC_Contact_First_Name__c, IC_Contact_Last_Name__c, IC_Contact_Email__c, IC_Contact_Phone__c, Access_Type__c, New_Authentication_Type__c, New_Max_IDs_Allowed__c, New_IDs_Issued__c  
                                                                FROM Account_X_Reference__c WHERE Id IN :accountXReferenceIds]);
                                                               
        for(AggregateResult ar : [SELECT count(Id) inetlliConnectCount, Apttus_Proposal__Proposal__c FROM Apttus_Proposal__Proposal_Line_Item__c 
                                  WHERE Apttus_Proposal__Product__r.Platform__c = :icProduct AND Apttus_Proposal__Proposal__c IN : quoteIds GROUP BY Apttus_Proposal__Proposal__c]) {
            if(Integer.valueOf(ar.get('inetlliConnectCount')) > 0) {
                intelliConnectQuoteIds.add((Id)ar.get('Apttus_Proposal__Proposal__c'));
            }           
        }      
        
        for(Apttus_Proposal__Proposal__c quote : newQuotes) {
        
            // Updates Bill To whenever ERP Account is populated
            if((quote.ERP_Account__c != null && accountXReferenceMap.containsKey(quote.ERP_Account__c)) && quote.ERP_Account__c != oldQuoteMap.get(quote.Id).ERP_Account__c) {
                
                quote.AMS_Account_Grouping__c = accountXReferenceMap.get(quote.ERP_Account__c).AMS_Account_Grouping__c;
                quote.AMS_Special_Agreement__c = accountXReferenceMap.get(quote.ERP_Account__c).AMS_Special_Agreement__c;
                quote.SAP_Bill_To_Partner_Number__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Partner_Number__c;
                quote.ERP_Bill_To_City__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_City__c;
                quote.ERP_Bill_To_Contact_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Contact_Name__c;
                quote.ERP_Bill_To_Country__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Country__c;
                quote.ERP_Bill_To_State__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_State__c;
                quote.ERP_Bill_To_Street_1__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Street_Line_1__c;
                quote.ERP_Bill_To_Street_2__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Street_Line_2__c;
                quote.ERP_Bill_To_Zip_Postal_Code__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Zip_Postal_Code__c;
                quote.ERP_Account_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).ERP_Account_Name__c;  
                quote.ERP_Bill_To_Phone__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Phone__c;
                quote.ERP_Bill_To_Fax__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Fax__c;
                quote.ERP_Bill_To_Account_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).Bill_To_Account_Name__c;    
                quote.ERP_IP_Prompt__c = accountXReferenceMap.get(quote.ERP_Account__c).IP_Prompt__c;                                        
                quote.New_Authentication_Type__c = accountXReferenceMap.get(quote.ERP_Account__c).Authentication_Type__c;
                //*** 10/23 Commented since validation rules were breaking - changed during Prod issue troubleshoot
                /*
                if(accountXReferenceMap.get(quote.ERP_Account__c).Max_IDs_Allowed__c != null)
                    quote.New_Max_IDs_Allowed__c = accountXReferenceMap.get(quote.ERP_Account__c).Max_IDs_Allowed__c;
                if(accountXReferenceMap.get(quote.ERP_Account__c).IDs_Issued__c != null)
                    quote.New_IDs_Issued__c = accountXReferenceMap.get(quote.ERP_Account__c).IDs_Issued__c;
                */
                    
                quote.Sold_To_Street_Address__c = accountXReferenceMap.get(quote.ERP_Account__c).Street_Address__c; 
                quote.Sold_To_City__c = accountXReferenceMap.get(quote.ERP_Account__c).City__c; 
                quote.Sold_To_State__c = accountXReferenceMap.get(quote.ERP_Account__c).State__c; 
                quote.Sold_To_Postalcode__c = accountXReferenceMap.get(quote.ERP_Account__c).Postalcode__c; 
                quote.Sold_To_Country__c = accountXReferenceMap.get(quote.ERP_Account__c).Country__c; 
                quote.Sold_To_Phone__c = accountXReferenceMap.get(quote.ERP_Account__c).Phone__c; 
                quote.Sold_To_Email__c = accountXReferenceMap.get(quote.ERP_Account__c).Email__c;
                
                // *** SMS-930 IC Admin: populate values from X-Ref
                if((quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Subscription' || quoteProposalRecordTypeMap.get(quote.RecordTypeId).Name == 'SAP Renewals') && quote.Apttus_QPConfig__PriceListId__c != NULL && priceListMap.get(quote.Apttus_QPConfig__PriceListId__c).Name == 'R&L Price List')
                {
                    // quote.SAP_IC_Trial_Account_Number__c = accountXReferenceMap.get(quote.ERP_Account__c).SAP_IC_Trial_Account_Number__c;
                    quote.IC_Contact_First_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).IC_Contact_First_Name__c;
                    quote.IC_Contact_Last_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).IC_Contact_Last_Name__c;
                    quote.IC_Contact_Email__c = accountXReferenceMap.get(quote.ERP_Account__c).IC_Contact_Email__c;
                    quote.IC_Contact_Phone__c = accountXReferenceMap.get(quote.ERP_Account__c).IC_Contact_Phone__c;
                    quote.Access_Type__c = accountXReferenceMap.get(quote.ERP_Account__c).Access_Type__c;
                    quote.New_Authentication_Type__c = accountXReferenceMap.get(quote.ERP_Account__c).New_Authentication_Type__c;
                    //*** 10/23 Added below condition since validation rules were breaking - changed during Prod issue troubleshoot
                    if(!String.isBlank(quote.New_Authentication_Type__c) && quote.New_Authentication_Type__c.contains('Standard')){
                    	quote.New_Max_IDs_Allowed__c = accountXReferenceMap.get(quote.ERP_Account__c).New_Max_IDs_Allowed__c;
                    	if(quote.Access_Type__c != 'All-Link'){
                    		quote.New_IDs_Issued__c = accountXReferenceMap.get(quote.ERP_Account__c).New_IDs_Issued__c;
                    	}
                    }
                } 
                
                // Updates Ship To whenever ERP Account is populated and Shi To Account Account is not populated
                if(quote.Ship_To_ERP_Account__c == null) {
                
                    quote.SAP_Ship_To_Partner_Number__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Partner_Number__c;
                    quote.ERP_Ship_To_City__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_City__c;
                    quote.ERP_Ship_To_Contact_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Contact_Name__c;
                    quote.ERP_Ship_To_Country__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Country__c;
                    quote.ERP_Ship_To_State__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_State__c;
                    quote.ERP_Ship_To_Street_1__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Street_Line_1__c;
                    quote.ERP_Ship_To_Street_2__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Street_Line_2__c;
                    quote.ERP_Ship_To_Zip_Postal_Code__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Zip_Postal_Code__c;                   
                    quote.ERP_Ship_To_Phone__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Phone__c;
                    quote.ERP_Ship_To_Fax__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Fax__c;
                    quote.ERP_Ship_To_Account_Name__c = accountXReferenceMap.get(quote.ERP_Account__c).Ship_To_Account_Name__c;
                }
            }
            
            // Updates Ship To whenever Ship To Account is populated
            if((quote.Ship_To_ERP_Account__c != null && accountXReferenceMap.containsKey(quote.Ship_To_ERP_Account__c)) && quote.Ship_To_ERP_Account__c != oldQuoteMap.get(quote.Id).Ship_To_ERP_Account__c) { 
                           
                quote.SAP_Ship_To_Partner_Number__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Partner_Number__c;
                quote.ERP_Ship_To_City__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_City__c;
                quote.ERP_Ship_To_Contact_Name__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Contact_Name__c;
                quote.ERP_Ship_To_Country__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Country__c;
                quote.ERP_Ship_To_State__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_State__c;
                quote.ERP_Ship_To_Street_1__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Street_Line_1__c;
                quote.ERP_Ship_To_Street_2__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Street_Line_2__c;
                quote.ERP_Ship_To_Zip_Postal_Code__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Zip_Postal_Code__c;                   
                quote.ERP_Ship_To_Phone__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Phone__c;
                quote.ERP_Ship_To_Fax__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Fax__c;
                quote.ERP_Ship_To_Account_Name__c = accountXReferenceMap.get(quote.Ship_To_ERP_Account__c).Ship_To_Account_Name__c;             
            }    

            if((!accountXReferenceMap.containsKey(quote.ERP_Account__c) && accountMap.containsKey(quote.Apttus_Proposal__Account__c)) && (quote.Apttus_Proposal__Account__c != null && quote.Apttus_Proposal__Account__c != oldQuoteMap.get(quote.Id).Apttus_Proposal__Account__c)) {
                quote.Sold_To_Street_Address__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingStreet; 
                quote.Sold_To_City__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingCity; 
                quote.Sold_To_State__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingState; 
                quote.Sold_To_Postalcode__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingPostalCode; 
                quote.Sold_To_Country__c = accountMap.get(quote.Apttus_Proposal__Account__c).BillingCountry; 
                quote.Sold_To_Phone__c = accountMap.get(quote.Apttus_Proposal__Account__c).Phone; 
                quote.Sold_To_Email__c = opportunityMap.get(quote.Apttus_Proposal__Opportunity__c).Primary_Contact_for_Proposal__r.Email;               
            }
            
            if(intelliConnectQuoteIds.contains(quote.Id)) {
                quote.IC_Admin_Quote__c = true;
            }
        }                               
    }
}