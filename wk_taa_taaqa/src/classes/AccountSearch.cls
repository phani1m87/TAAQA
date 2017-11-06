public without sharing class AccountSearch 
{
    public String searchAccountName {get;set;}
    public String searchFirstName {get;set;}
    public String searchLastName {get;set;}
    public String searchPhone {get;set;}
    public String searchWebsite {get;set;}
    public String searchAddress {get;set;}
    public String searchEmail {get;set;}
    public String viewType {get;set;}
    public String searchSAPAccountNo {get;set;}
    public Boolean showSAPAccountNo = false;
    public Boolean showAccountTable = false;
    public Boolean showContactTable = false;
    public Boolean showConvertLeadButton = false;
    public List<Account> Act_List = new List<Account>(); // The list of Accounts to be displayed on the Page
    public List<Contact> Con_List = new List<Contact>(); // The list of Contacts to be displayed on the Page
    public List<AccountTeamMember> ActTeam_List = new List<AccountTeamMember>(); // The list of Accounts to be displayed on the Page
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public String countAccount {get;set;}
    public String countContact {get;set;}
    
    public AccountSearch() 
    {
       String LeadId = System.currentPageReference().getParameters().get('LeadId');
       if(LeadId != null)
       {
           Lead[] objLd = Database.Query('Select FirstName, LastName, Company, Email, Website, Phone From Lead Where Id =\'' + LeadId + '\'');
           if(objLd.size() > 0)
           {
               searchAccountName = objLd[0].Company;
               searchFirstName = objLd[0].FirstName;
               searchLastName = objLd[0].LastName;
               searchEmail = objLd[0].Email;
               searchWebsite = objLd[0].Website;
               searchPhone = objLd[0].Phone;
           
               makeLeadAccountSearchQuery();
               makeLeadContactSearchQuery();
               showConvertLeadButton = true;
           }
       }
       
       
       System.debug('HELLO RAJ!!!'+ LeadId);
    }
    public PageReference AttachtoExistingAccount() 
    {
        String LeadId = System.currentPageReference().getParameters().get('LeadId');
        if(LeadId != null)
        {
            PageReference pageRef = new PageReference('/lead/leadconvert.jsp?retURL=%2F'+LeadId+'&id='+LeadId);
            return pageRef;
        }
        return null;
    }
    public PageReference ConvertLead() 
    {
        String LeadId = System.currentPageReference().getParameters().get('LeadId');
        if(LeadId != null)
        {
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(LeadId);
            //lc.setDoNotCreateOpportunity(True);
            

            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            String objActId = lcr.getAccountId();
            if(objActId != null)
            {
                PageReference pageRef = new PageReference('/'+objActId);
                return pageRef;
            }    
        }
        return null;    
    }
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    public String sortExpression
    {
        get{return sortExp;}
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
           
           sortExp = value;
        }
     }
    public PageReference AMSSAPAccountNo() 
    {
        showSAPAccountNo = true;
        return null;
    } 
    public PageReference NewContact() 
    {
        PageReference newContactPage = new PageReference('/003/e?retURL=%2F003%2Fo');
        newContactPage.setRedirect(true);
        return newContactPage;
        //return null;
    }
    public PageReference NewAccount() 
    {
        PageReference newAccountPage = new PageReference('001/e?retURL=%2F001%2Fo');
        newAccountPage.setRedirect(true);
        return newAccountPage;
        //return null;
    }
    public PageReference Search() 
    {       
        if(isValid())
        {
            if(viewType == 'All')
            {
                makeAccountQuery();
                makeContactQuery();
            }
            else if (viewType == 'Account')
            {
                makeAccountQuery();
                showContactTable = false;
            }
            else if (viewType == 'Contact')
            {
                makeContactQuery();
                showAccountTable = false;
            }
        } 
        
        return null;       
    }
    public PageReference searchAccount() 
    {
        makeAccountQuery();
        return null;
    }
    public PageReference searchContact() 
    {
        makeContactQuery();
        return null;
    }
    public PageReference Clear() 
    {
        //searchName = '';
        //searchCompany = '';
        
        searchAccountName = '';
        searchFirstName = '';
        searchLastName = '';
        searchPhone = '';
        searchWebsite = '';
        searchAddress = '';
        searchEmail = '';
        searchSAPAccountNo = '';
        showAccountTable = false;
        showContactTable = false;
        return null;         
    }    
    public void makeAccountQuery()
    {
        //try
        //{   
            act_List.clear();
            showAccountTable = true;            
            List<Account> accts = new List<Account>();
            
            //build the full sort expression
            String sortFullExp = sortExpression  + ' ' + sortDirection;
            if(searchSAPAccountNo != '')
            {
                Set<Id> AccountIds = new Set<Id>();
                String sapAccountNoStr = '';
                
                sapAccountNoStr = '%' + searchSAPAccountNo + '%';
                Account_X_Reference__c[] objAMSSAP= Database.Query('Select ApplicationID__c, Account__c From Account_X_Reference__c Where ApplicationID__c like \'' + sapAccountNoStr + '\' LIMIT 100');
                if(objAMSSAP.size() > 0)
                {
                    for(Integer i=0; i < objAMSSAP.size(); i++) 
                    {
                        AccountIds.add( objAMSSAP[i].Account__c);
                    }
                    if(AccountIds.size() > 0)
                    {
                        //Act_List = Database.Query('SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, Website, Market_Segment__c, Market_Sub_Segment__c, Named_Account__c, Named_Account_Type__c, SFDC_Account__c FROM Account Where Id = \'' + objAMSSAP[0].Account__c + '\'');
                        //Act_List = Database.Query('SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, Website, Market_Segment__c, Market_Sub_Segment__c, Named_Account__c, Named_Account_Type__c, SFDC_Account__c FROM Account Where Id in :AccountIds');
                        Act_List = new List<Account>([SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, Website, Market_Segment__c, Market_Sub_Segment__c, Named_Account__c, Named_Account_Type__c, SFDC_Account__c FROM Account Where Id in :AccountIds]);
                        searchAccountName = '';
                        searchPhone = '';
                        searchWebsite = '';
                        searchAddress = '';
                        countAccount = string.valueof(Act_List.size());
                    }
                }
            }
            
            String query = 'SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, Website, Market_Segment__c, Market_Sub_Segment__c, Named_Account__c, Named_Account_Type__c, SFDC_Account__c FROM Account ';
            String queryWhere = 'WHERE';
            String orderLimit = ' ORDER BY '+sortFullExp+' LIMIT 1000';
            String accountNameStr = '';
            String firstNameStr = '';
            String lastNameStr = '';
            String phoneStr = '';
            String websiteStr = '';
            String addressStr = '';
            String emailStr = '';
            
            //Build Dynamic Query
            if(searchAccountName != ''){
              accountNameStr = '%' + searchAccountName + '%';
              queryWhere = queryWhere + ' Name LIKE \'' + accountNameStr + '\'';
            }
            if((searchPhone != '') && (searchAccountName != '')){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' AND Phone_Text__c LIKE \'' + phoneStr + '\'';
            }else if(searchPhone != ''){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' Phone_Text__c LIKE \'' + phoneStr + '\'';
            }
            if((searchWebsite != '') && (searchAccountName != '' || searchPhone != '')){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' AND Website LIKE \'' + websiteStr +'\'';
            }else if(searchWebsite != ''){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' Website LIKE \'' + websiteStr +'\'';
            }
            if((searchAddress != '') && (searchAccountName != '' || searchPhone != '' || searchWebsite != ''))
            {
              addressStr = '%' + searchAddress + '%';
              queryWhere = queryWhere + ' AND (BillingStreet LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingCity LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingState LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingPostalCode LIKE \'' + addressStr +'\''; 
              queryWhere = queryWhere + ')';             
            }else if(searchAddress != '')
            {
              addressStr = '%' + searchAddress + '%';
              queryWhere = queryWhere + ' (BillingStreet LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingCity LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingState LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR BillingPostalCode LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ')';               
            }
            
            system.debug('-----tmpStr: ' + query + queryWhere + orderLimit);
            
            //query for accounts 
            if((searchAccountName != '' || searchPhone != '' || searchWebsite != '' || searchAddress != ''))
            {
              queryWhere = queryWhere + ' AND RecordTypeId != \'012i0000000Ou0D\'';
              Act_List = Database.Query(query + queryWhere + orderLimit);
            }
            countAccount = string.valueof(Act_List.size());
            if (Act_List.size() > 990)
                countAccount = 'Too Many';
            
            system.debug('Raj Accounts Query: ' + query + queryWhere + orderLimit);
            system.debug('-----results: ' + Act_List);
        
        /* 
        }
        catch(Exception e) 
        {
            System.debug('Error Occured : '+e.getMessage());
            String ErrorComment;
            String SourceRecords='Global Account Name: ';
            
            ErrorComment  = 'User :'+UserInfo.getName();                        
            ErrorLog.RecordLog('AccountLeadSearch', e.getMessage(), ErrorComment, e.getTypeName(),SourceRecords);
            showAccounttable = false;         
        }
        */           
    }
    public void makeContactQuery()
    {
        //try
        //{   
            con_List.clear();
            showContactTable = true;
            
            //build the full sort expression
            String sortFullExp = sortExpression  + ' ' + sortDirection;
                        
            
            String query = 'SELECT Id, Name, Account.Name, MailingStreet, Account.Website, Account.Market_Segment__c, Account.Market_Sub_Segment__c, Account.Named_Account__c, Account.SFDC_Account__c, Account.Named_Account_Type__c, Email FROM Contact ';
            String queryWhere = 'WHERE';
            String orderLimit = ' ORDER BY '+sortFullExp+' LIMIT 1000';
            //String nameStr = '';
            //String companyStr = '';
            String accountNameStr = '';
            String firstNameStr = '';
            String lastNameStr = '';
            String phoneStr = '';
            String websiteStr = '';
            String addressStr = '';
            String emailStr = '';
            
             //Build Dynamic Query
            if(searchAccountName != ''){
              accountNameStr  = '%' + searchAccountName + '%';
              queryWhere = queryWhere + ' Account.Name LIKE \'' + accountNameStr + '\'';
            }
            if((searchFirstName != '') && (searchAccountName != '')){
              firstNameStr = '%' + searchFirstName + '%';
              queryWhere = queryWhere + ' AND FirstName LIKE \'' + firstNameStr + '\'';
            }else if(searchFirstName != ''){
              firstNameStr = '%' + searchFirstName + '%';
              queryWhere = queryWhere + ' FirstName LIKE \'' + firstNameStr + '\'';
            }
            if((searchLastName != '') && (searchAccountName != '' || searchFirstName != '')){
              lastNameStr = '%' + searchLastName + '%';
              queryWhere = queryWhere + ' AND LastName LIKE \'' + lastNameStr + '\'';
            }else if(searchLastName != ''){
              lastNameStr = '%' + searchLastName + '%';
              queryWhere = queryWhere + ' LastName LIKE \'' + lastNameStr + '\'';
            }
            if((searchAddress != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '')){
              addressStr = '%' + searchAddress + '%';
              queryWhere = queryWhere + ' AND (MailingStreet LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingCity LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingState LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingPostalCode LIKE \'' + addressStr +'\''; 
              queryWhere = queryWhere + ')'; 
              
            }else if(searchAddress != '')
            {
              addressStr = '%' + searchAddress + '%';
              queryWhere = queryWhere + ' (MailingStreet LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingCity LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingState LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ' OR MailingPostalCode LIKE \'' + addressStr +'\'';
              queryWhere = queryWhere + ')'; 
            }
            if((searchPhone != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '')){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' AND Phone_Text__c LIKE \'' + phoneStr + '\'';
            }else if(searchPhone != ''){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' Phone_Text__c LIKE \'' + phoneStr + '\'';
            }
            if((searchEmail != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '' || searchPhone != '')){
              emailStr = '%' + searchEmail + '%';
              queryWhere = queryWhere + ' AND Email LIKE \'' + emailStr + '\'';
            }else if(searchEmail != ''){
              emailStr = '%' + searchEmail + '%';
              queryWhere = queryWhere + ' Email LIKE \'' + emailStr + '\'';
            }
            if((searchWebsite  != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '' || searchPhone != '' || searchEmail != '')){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' AND Account.Website LIKE \'' + websiteStr +'\'';
            }else if(searchWebsite != ''){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' Account.Website LIKE \'' + websiteStr +'\'';
            }
            
            system.debug('-----tmpStr: ' + query + queryWhere + orderLimit);
            
            //query for accounts 
            if((searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchPhone != '' || searchWebsite != '' || searchAddress != '' || searchEmail != ''))
            {
              queryWhere = queryWhere + ' AND Account.RecordTypeId != \'012i0000000Ou0D\'';
              Con_List = Database.Query(query + queryWhere + orderLimit);
            }
            
            countContact = string.valueof(Con_List.size());
            if (Con_List.size() > 990)
                countContact = 'Too Many';    
            
            system.debug('Raj Contacts Query: ' + query + queryWhere + orderLimit);    
            system.debug('-----results: ' + Con_List);
                  
    }
    public void makeLeadAccountSearchQuery()
    {
        act_List.clear();
        showAccountTable = true;            
        List<Account> accts = new List<Account>();
            
        //build the full sort expression
        String sortFullExp = sortExpression  + ' ' + sortDirection;
            
        String query = 'SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, Website, Market_Segment__c, Market_Sub_Segment__c, Named_Account__c, Named_Account_Type__c, SFDC_Account__c FROM Account ';
        String queryWhere = 'WHERE';
        String orderLimit = ' ORDER BY '+sortFullExp+' LIMIT 1000';
        String accountNameStr = '';
        String firstNameStr = '';
        String lastNameStr = '';
        String phoneStr = '';
        String websiteStr = '';
        String addressStr = '';
        String emailStr = '';
            
            
        searchAccountName = formatNullField(searchAccountName);
        searchPhone = formatNullField(searchPhone);
        searchWebsite = formatNullField(searchWebsite);    
            
        //Build Dynamic Query
        if(searchAccountName != ''){
          accountNameStr = '%' + searchAccountName + '%';
        queryWhere = queryWhere + ' Name LIKE \'' + accountNameStr + '\'';
        }
        if((searchPhone != '') && (searchAccountName != '')){
          phoneStr = '%' + searchPhone + '%';
          phoneStr = formatPhone(phoneStr);  
          queryWhere = queryWhere + ' OR Phone_Text__c LIKE \'' + phoneStr + '\'';
        }else if(searchPhone != ''){
          phoneStr = '%' + searchPhone + '%';
          phoneStr = formatPhone(phoneStr);  
          queryWhere = queryWhere + ' Phone_Text__c LIKE \'' + phoneStr + '\'';
        }
        if((searchWebsite != '') && (searchAccountName != '' || searchPhone != '')){
          websiteStr = '%' + searchWebsite + '%';
          queryWhere = queryWhere + ' OR Website LIKE \'' + websiteStr +'\'';
        }else if(searchWebsite != ''){
          websiteStr = '%' + searchWebsite + '%';
          queryWhere = queryWhere + ' Website LIKE \'' + websiteStr +'\'';
        }
        
        system.debug('-----tmpStr: ' + query + queryWhere + orderLimit);
            
        //query for accounts 
        if((searchAccountName != '' || searchPhone != '' || searchWebsite != ''))
        {
          //queryWhere = queryWhere + ' AND RecordTypeId != \'012i0000000Ou0D\'';
          system.debug('Raj LeadAccounts Query: ' + query + queryWhere + orderLimit);
          Act_List = Database.Query(query + queryWhere + orderLimit);
          countAccount = string.valueof(Act_List.size());
          if (Act_List.size() > 990)
              countAccount = 'Too Many'; 
        }
        else
        {
          //Act_List = Database.Query(query + orderLimit);
        }
        system.debug('Raj Accounts Query: ' + query + queryWhere + orderLimit);
        system.debug('-----results: ' + Act_List);
    }
    public void makeLeadContactSearchQuery()
    {
        //try
        //{   
            con_List.clear();
            showContactTable = true;
            
            //build the full sort expression
            String sortFullExp = sortExpression  + ' ' + sortDirection;
                        
            
            String query = 'SELECT Id, Name, Account.Name, MailingStreet, Account.Website, Account.Market_Segment__c, Account.Market_Sub_Segment__c, Account.Named_Account__c, Account.SFDC_Account__c, Account.Named_Account_Type__c, Email FROM Contact ';
            String queryWhere = 'WHERE';
            String orderLimit = ' ORDER BY '+sortFullExp+' LIMIT 1000';
            String accountNameStr = '';
            String firstNameStr = '';
            String lastNameStr = '';
            String phoneStr = '';
            String websiteStr = '';
            String addressStr = '';
            String emailStr = '';
            
            searchAccountName = formatNullField(searchAccountName);
            searchFirstName = formatNullField(searchFirstName);
            searchLastName = formatNullField(searchLastName);
            searchPhone = formatNullField(searchPhone);
            searchEmail = formatNullField(searchEmail);
            searchWebsite = formatNullField(searchWebsite);
            
            
            
             //Build Dynamic Query
            if(searchAccountName != ''){
              accountNameStr  = '%' + searchAccountName + '%';
              queryWhere = queryWhere + ' Account.Name LIKE \'' + accountNameStr + '\'';
            }
            if((searchFirstName != '') && (searchAccountName != '')){
              firstNameStr = '%' + searchFirstName + '%';
              queryWhere = queryWhere + ' OR (FirstName LIKE \'' + firstNameStr + '\'';
            }else if(searchFirstName != ''){
              firstNameStr = '%' + searchFirstName + '%';
              queryWhere = queryWhere + ' FirstName LIKE \'' + firstNameStr + '\'';
            }
            if((searchLastName != '') && (searchAccountName != '' || searchFirstName != '')){
              lastNameStr = '%' + searchLastName + '%';
              queryWhere = queryWhere + ' AND LastName LIKE \'' + lastNameStr + '\')';
            }else if(searchLastName != ''){
              lastNameStr = '%' + searchLastName + '%';
              queryWhere = queryWhere + ' LastName LIKE \'' + lastNameStr + '\'';
            }
            if((searchPhone != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '')){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' OR Phone_Text__c LIKE \'' + phoneStr + '\'';
            }else if(searchPhone != ''){
              phoneStr = '%' + searchPhone + '%';
              phoneStr = formatPhone(phoneStr);  
              queryWhere = queryWhere + ' Phone_Text__c LIKE \'' + phoneStr + '\'';
            }
            if((searchEmail != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '' || searchPhone != '')){
              emailStr = '%' + searchEmail + '%';
              queryWhere = queryWhere + ' OR Email LIKE \'' + emailStr + '\'';
            }else if(searchEmail != ''){
              emailStr = '%' + searchEmail + '%';
              queryWhere = queryWhere + ' Email LIKE \'' + emailStr + '\'';
            }
            if((searchWebsite  != '') && (searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchAddress != '' || searchPhone != '' || searchEmail != '')){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' OR Account.Website LIKE \'' + websiteStr +'\'';
            }else if(searchWebsite != ''){
              websiteStr = '%' + searchWebsite + '%';
              queryWhere = queryWhere + ' Account.Website LIKE \'' + websiteStr +'\'';
            }
            
            system.debug('Raj Lead Contact Search Query: ' + query + queryWhere + orderLimit);
            
            //query for accounts 
            if((searchAccountName != '' || searchFirstName != '' || searchLastName != '' || searchPhone != '' || searchWebsite != '' || searchEmail != ''))
            {
              Con_List = Database.Query(query + queryWhere + orderLimit);
              countContact = string.valueof(Con_List.size());
              if (Con_List.size() > 990)
                  countContact = 'Too Many';
            }
            else
            {
              //Con_List = Database.Query(query + orderLimit);
            }    
            system.debug('Raj Lead Contacts Query: ' + query + queryWhere + orderLimit);    
            system.debug('-----results: ' + Con_List);
    }
    private String formatNullField(String fld)
    {
    if(fld == null)
        return '';
    else
        return fld;     
    }
    
    private String formatPhone(String phone)
    {
        phone = phone.replaceAll('\\+','');
        phone = phone.replaceAll('\\(','');
        phone = phone.replaceAll('\\)','');
        phone = phone.replaceAll(' ','');
        phone = phone.replaceAll('\\-','');
        phone = phone.replaceAll('\\.','');

        return phone;
    }    
    private Boolean isValid()
    {
        if((searchAccountName == '') && (searchFirstName == '') && (searchLastName == '') && (searchPhone == '') && (searchWebsite == '') && (searchAddress == '') && (searchEmail == '') && (searchSAPAccountNo == ''))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter at least one field to search.'));
            return false;   
        }
        else    
            return true;  
    }
    public PageReference trackVisits() 
    {
        String pgURL = ApexPages.currentPage().getUrl(); 
        VF_Tracking__c newTracking = new VF_Tracking__c(User__c=UserInfo.getUserId(),VF_Page_Visited__c=pgURL,Datetime_Visited__c=datetime.now());
        insert newTracking;
        return null;
        
    }
    public boolean displayPopup {get; set;}
    public boolean displayNoTeam {get; set;}     
    
    public void closePopup() 
    {        
        displayPopup = false;    
    }     
    public void showPopup() 
    {        
        ActTeam_List.clear();
        String AccountId = Apexpages.CurrentPage().getParameters().get('AccountId');
        String query = 'SELECT AccountId,TeamMemberRole,UserId,User.Name, User.Phone FROM AccountTeamMember ';
        String queryWhere = 'WHERE AccountId=\'' + AccountId +'\'';
        ActTeam_List = Database.Query(query + queryWhere);
            
            
        system.debug('Raj Account Team' + ActTeam_List);
        
        if(ActTeam_List.size() == 0)
            displayNoTeam = true;
        else
            displayNoTeam  = false;
        
        displayPopup = true;    
    }
    public List<Account> getAct_List(){ return act_List;}
    public List<Contact> getCon_List(){ return con_List;}
    public List<AccountTeamMember> getActTeam_List(){ return actTeam_List;}
    public Boolean getShowAccountTable() {return showAccountTable;}    
    public Boolean getShowContactTable() {return showContactTable;}
    public Boolean getShowSAPAccountNo() {return showSAPAccountNo;} 
    public Boolean getShowConvertLeadButton() {return showConvertLeadButton;}
    
    
    public static testMethod void testAccountSearch()
    {
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'standt', email='test@testorg.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', username='test@testorg.com.wktaadev');
        
        System.runAs(u)
        {
            Lead testLead = new Lead(Company='Test', Firstname='Test First Name', Lastname='Test Last Name', Market_Segment__c = 'Accounting Firms', Market_Sub_Segment__c = 'Sole Proprietor');
            insert testLead;
            
            Account testAccount = new Account(name='Test Company Name');
            insert testAccount;
            
            Contact testContact = new Contact(Firstname='Test First Name', Lastname='Test Last Name', AccountId = testAccount.Id);
            insert testContact;
            
            //PageReference newLeadSerachPage = new PageReference('/apex/AccountSearch?LeadId='+testLead.id);
             ApexPages.currentPage().getParameters().put('LeadId', testLead.id);
            
            
            AccountSearch objAC = new AccountSearch();
            objAC.searchAccountName = 'Test';
            objAC.searchFirstName = 'First';
            objAC.searchLastName = 'Last';
            objAC.searchPhone = '123';
            objAC.searchWebsite = 'Test';
            objAC.searchAddress = 'Test';
            objAC.searchEmail = 'Test';            
            objAC.ViewType = 'All';
            objAC.Search();
            
            objAC.ViewType = 'Account';
            objAC.Search();
            
            objAC.ViewType = 'Contact';
            objAC.Search();
            
            objAC.searchAccount(); 
            objAC.searchContact();            
            
            objAC.NewContact();
            objAC.NewAccount();
            
            objAC.Clear();
            objAC.searchAddress = 'Test';
            objAC.makeAccountQuery();
            objAC.makeContactQuery();
            
            objAC.Clear();
            objAC.searchPhone = '1234567890';
            objAC.makeAccountQuery();
            objAC.makeContactQuery();
            
            objAC.Clear();
            objAC.searchWebsite = 'Test';
            objAC.makeAccountQuery();
            objAC.makeContactQuery();
            
            objAC.AttachtoExistingAccount();
            objAC.ConvertLead();
            String strSort = objAC.getSortDirection();
            objAC.AMSSAPAccountNo();
            
            Account_X_Reference__c testActX = new Account_X_Reference__c(ApplicationID__c='3210',Account__c=testAccount.Id);
            insert testActX;
            objAC.searchSAPAccountNo = '3210';
             
        }
    }
}