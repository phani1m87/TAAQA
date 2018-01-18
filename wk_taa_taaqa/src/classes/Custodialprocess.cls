public with sharing class Custodialprocess 
{
    public Custodial__c CustodialRec {get; set;}
    public Custodial__c custObj;
    public List<Custodial__c> list_cust;
    public String msg;
    public Integer CountLead;
    public Integer CountAccTeamMember;
    public String custodialId;
    public List<User> list_CurrentUserDetail;
    public List<User> list_CutodialUserDetail;
    public List<User> list_NewrepUserDetail;
    public List<User> list_openTerritory;
    public User CurrentUserDetail {get; set;}
    public User OpenTerritoryUserDetail {get; set;}
    public User CutodialUserDetail {get; set;}
    public User NewrepUserDetail {get; set;}
    public User UserDetail {get; set;}
    public String DTN_Current_Rep;
    public String DTN_Custodial_Rep;
    public String DTN_New_Rep;
    public String DTN_Open_Territory;
    public Id CurrentRepUserId;
    public string Current_Rep {get; set;}
    public string New_Rep {get; set;}
    public string Assignment_Process {get; set;}
    public string Assignment_Type {get; set;}
    public String optSelected {get; set;}
    public String optSelectedRep {get; set;}
    public boolean showDTNvalue {get; set;}
    public boolean showOpenTerritory {get; set;}
    public boolean showRepvalue {get; set;}
    public boolean showDTNDetail {get; set;}
    public boolean showCustodialUserDetail {get; set;} 
    public boolean showCurrentUserDetail {get; set;}
    public boolean showNewReptUserDetail {get; set;} 
    public boolean showOpenterritoryUserDetail {get; set;}
    public boolean DisplayMessage {get; set;} 
    public boolean showAssBlock {get; set;} 
    public boolean showsubbtn {get; set;}
    public boolean showcancelbtn {get; set;}
    public boolean showClosebtn {get; set;}
    public boolean testCallout = false;
    
    Map<String,List<String>> currentWithCustodialReps = new Map<String,List<String>>();
    Map<String,String> currentWithNewReps = new Map<String,String>();
    Map<String,User> dtnUserMap = new Map<String,User>();
    Set<String> dtnUsers = new Set<String>();
    List<Custodial__c> listCustodial = new List<Custodial__c>();
    List<AccountTeamMember> listAccTeamMember = new List<AccountTeamMember>();
    Set<String> dtnCurrentReps = new Set<String>();
    String Accquery;
    String Leadquery;
    
    public List<SelectOption> getRadioValues() 
    {
        List<SelectOption> resList = new List<SelectOption>();
        resList.add(new SelectOption('LeadProcess', 'Lead'));
        resList.add(new SelectOption('AccountProcess', 'Account'));
        resList.add(new SelectOption('Both', 'Both'));
        return resList;
    }

    public List<SelectOption> getRadioValuesRep() 
    {
        List<SelectOption> resList = new List<SelectOption>();
        resList.add(new SelectOption('Custodial', 'Custodial Assignment'));
        resList.add(new SelectOption('New Rep', 'New Rep Assignment'));
        if(optSelected == 'AccountProcess'){
            resList.add(new SelectOption('Open Territory', 'Assign Open territory User'));
        }
        return resList;
    }
    
    public Custodialprocess(ApexPages.StandardController controller)
    {
        CustodialRec = (Custodial__c)controller.getRecord();
    }
    
    public pagereference showDTN()
    {
        if(!Test.isRunningtest()){
            reset();
        }   

        if(optSelectedRep == 'Custodial')
        {
            showDTNvalue = true;
            showRepvalue = false;
            showDTNDetail = true;
            showOpenTerritory = false;
        }else if(optSelectedRep == 'New Rep'){
             showDTNvalue = false;
             showRepvalue = true;
             showDTNDetail = true;
             showOpenTerritory = false;
        }else if(optSelectedRep == 'Open Territory'){
             showDTNvalue = false;
             showRepvalue = false;
             showOpenTerritory = true;
             showDTNDetail = true;
        }
        return null; 
    }
    
    public pagereference searchUserDetail()
    {
        showCurrentUserDetail = false;
        showCustodialUserDetail = false;
        showNewReptUserDetail = false;
        DisplayMessage = false;
        msg = '';
        showcancelbtn = false;
        showsubbtn = false;
        showClosebtn = false;
           
        if(showDTNvalue == true)
        {
            if(CustodialRec.DTN_Current_Rep__c == NULL || CustodialRec.DTN_Custodial_Rep__c == NULL){
                msg = 'DTN Current Rep Or Custodail Rep should not be empty for search';
            }else if(CustodialRec.DTN_Current_Rep__c == CustodialRec.DTN_Custodial_Rep__c){
                msg = 'DTN Current Rep should not be equal to Custodial Rep';
            }else{   
                list_CurrentUserDetail = new List<User>();
                list_CurrentUserDetail = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_Current_Rep__c];
                if(list_CurrentUserDetail.size() > 0)
                {
                    list_CutodialUserDetail = new List<User>();
                    list_CutodialUserDetail = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_Custodial_Rep__c];
                    if(list_CutodialUserDetail.size() > 0)
                    {
                        CurrentUserDetail = new user();
                        CutodialUserDetail = new user();
                        CurrentUserDetail = list_CurrentUserDetail[0];
                        CutodialUserDetail = list_CutodialUserDetail[0];
                        CurrentRepUserId = list_CurrentUserDetail[0].id;
                        Current_Rep = CustodialRec.DTN_Current_Rep__c;
                        New_Rep = CustodialRec.DTN_Custodial_Rep__c;
                        Assignment_Type = 'Custodial';
                    }else{
                        msg = 'There is no user associated with Custodial DTN';
                    }
                }else{
                    msg = 'There is no user associated with Current DTN';
                }
            }
            
            if(!string.isBlank(msg))  
            {
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, msg);
                apexpages.addMessage(myMsg);
            }     
        }else if(showRepvalue == true){
            system.debug('Current Rep::' +CustodialRec.DTN_Current_Rep__c);
            system.debug('New Rep ::' +CustodialRec.DTN_new_Rep__c);
           
            if(CustodialRec.DTN_Current_Rep__c == NULL || CustodialRec.DTN_new_Rep__c == NULL)
            {
                msg = 'DTN Current Rep Or New Rep should not be empty for search';
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,msg);
                apexpages.addMessage(myMsg);
            }else if(CustodialRec.DTN_Current_Rep__c == CustodialRec.DTN_new_Rep__c){
                msg = 'DTN Current Rep should not be equal to New Rep';
            }else{
                list_CurrentUserDetail = new List<user>();
                list_CurrentUserDetail = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_Current_Rep__c];
                if(list_CurrentUserDetail.size() > 0)
                {
                    list_NewrepUserDetail = new List<user>();
                    list_NewrepUserDetail = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_new_Rep__c];
                    if(list_NewrepUserDetail.size() > 0)
                    {
                        CurrentUserDetail = new User();
                        NewrepUserDetail = new User();
                        CurrentUserDetail = list_CurrentUserDetail[0];
                        NewrepUserDetail = list_NewrepUserDetail[0];
                        CurrentRepUserId = list_CurrentUserDetail[0].Id;
                        Current_Rep = CustodialRec.DTN_Current_Rep__c;
                        New_Rep = CustodialRec.DTN_new_Rep__c;
                        Assignment_Type = 'New Rep';
                    }else{
                        msg = 'There is no user associated with New Rep DTN';
                    }
                }else{
                    msg = 'There is no user associated with Current DTN';
                }
            }
            
            if(!string.isBlank(msg))  
            {
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,msg);
                apexpages.addMessage(myMsg);
            }     
        }else if(showOpenTerritory == true){
            if(CustodialRec.DTN_Current_Rep__c == NULL || CustodialRec.DTN_Open_Territory_User__c == NULL)
            {
                msg = 'DTN Current Rep Or Open territory user should not be empty for search';
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,msg);
                apexpages.addMessage(myMsg);
            }else if(CustodialRec.DTN_Current_Rep__c==CustodialRec.DTN_Open_Territory_User__c){
                msg = 'DTN Current Rep should not be equal to Open territory rep';
            }else{ 
                list_CurrentUserDetail = new List<User>();
                system.debug('DTN Current Rep' +CustodialRec.DTN_Current_Rep__c);
                system.debug('DTN Open Territory' +CustodialRec.DTN_Open_Territory_User__c);
                list_CurrentUserDetail = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_Current_Rep__c];
                if(list_CurrentUserDetail.size() > 0)
                {
                    list_openTerritory = new List<user>();
                    list_openTerritory = [SELECT Id, DTN__c, Name, City FROM User WHERE DTN__c =: CustodialRec.DTN_Open_Territory_User__c];
                    if(list_openTerritory.size() > 0)
                    {
                        //SMS-777 Start
                        if(!list_openTerritory[0].name.contains('Territory')) 
                        {
                            msg = 'The entered DTN: '+CustodialRec.DTN_Open_Territory_User__c+' is not a valid DTN Open Territory User.';
                        }
                        //SMS-777 End
                        else{
                            CurrentUserDetail = new user();
                            OpenTerritoryUserDetail = new user();
                            CurrentUserDetail = list_CurrentUserDetail[0];
                            OpenTerritoryUserDetail = list_openTerritory[0];
                            CurrentRepUserId = list_CurrentUserDetail[0].Id;
                            Current_Rep = CustodialRec.DTN_Current_Rep__c;
                            New_Rep = CustodialRec.DTN_Open_Territory_User__c;
                            Assignment_Type = 'Open Territory';
                            system.debug('Name' +CurrentUserDetail.Name);
                        }
                    }else{
                      msg = 'There is no user associated with Open Territory';
                    }
                }else{
                 msg = 'There is no user associated with Current DTN';
                }
            }
            
            if(!string.isBlank(msg))  
            {
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,msg);
                apexpages.addMessage(myMsg);
            }     
        }
       
        if(string.isBlank(msg))
        {
            DTN_Current_Rep = CustodialRec.DTN_Current_Rep__c;
            /*   
            HttpRequest req = new HttpRequest();
            req.setTimeout(60000);
            req.setEndpoint('https://'+URL.getSalesforceBaseUrl().getHost()+'/services/data/v30.0/query/?q=SELECT+Id+FROM+AccountteamMember+WHERE+User.DTN__c+='+'\''+DTN_Current_Rep+'\'');
            req.setMethod('GET');
            string auth = 'Bearer '+ userInfo.getsessionId();
            req.setHeader('Authorization', auth);
            
            Http http = new Http();
            try{
                if(!testCallout)
                {
                    HttpResponse res = http.send(req);
                    String response = res.getBody();
                    String total = response.substring(response.indexOf('totalSize":') + 11, response.indexOf(','));
                    CountAccTeamMember = integer.valueof(total);
                }
            }catch(Exception e){
                system.debug('Error ' + e.getMessage());
                msg = e.getMessage();
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,msg);
                apexpages.addMessage(myMsg);
            }
            */   
            CountAccTeamMember = [SELECT count() FROM AccountTeamMember WHERE User.DTN__c =: DTN_Current_Rep];
            if(optSelectedRep == 'Custodial'){
                CountLead = [SELECT count() FROM Lead WHERE OwnerId =: CurrentRepUserId AND IsConverted = false AND Status IN ('Gain Access','Not Started','Recognize Need')];
            }else{
                CountLead = [SELECT count() FROM Lead WHERE OwnerId =: CurrentRepUserId AND IsConverted = false];
            }   
            system.debug('Lead Count'+CountLead);
            system.debug('Account Team Member Count' +CountAccTeamMember);
            if(optSelected == 'LeadProcess')
            {    
                if(CountLead != 0)
                {
                   msg = 'Territory ' + DTN_Current_Rep + ' is associated with ' + CountLead + ' Leads records';
                   showsubbtn = true;
                   showcancelbtn = true;
                   Assignment_Process = 'Lead';                 
                }else{
                   msg = 'There is no Lead records associated with Territory ' + DTN_Current_Rep;
                   showsubbtn = false;
                   showcancelbtn = true; 
                }
            }else if(optSelected == 'AccountProcess'){
               if(CountAccTeamMember != 0)
               {
                   msg = 'Territory ' + DTN_Current_Rep + ' is associated with ' + CountAccTeamMember + ' Account Team records';
                   showsubbtn = true;
                   showcancelbtn = true;
                   Assignment_Process = 'Account';
               }else{
                   msg = 'There is no Account Team Member records associated with Territory ' + DTN_Current_Rep;
                   showsubbtn = false;
                   showcancelbtn = true;
               }
            }else{
               if(CountLead != 0 || CountAccTeamMember != 0)
               {
                   msg = 'Territory ' + DTN_Current_Rep + ' is associated with ' + CountAccTeamMember + ' Account Team records and ' + CountLead + ' Leads records';
                   showsubbtn = true;
                   showcancelbtn = true;
                   Assignment_Process = 'both';
               }else{
                   msg = 'There is no Account Team Member & no Lead records associated with Territory ' + DTN_Current_Rep;
                   showsubbtn = false;
                   showcancelbtn = true;
               }
            }
          
            if(showDTNvalue == true)
            {
               showCurrentUserDetail = true;
               showCustodialUserDetail = true;
            }else if(showRepvalue == true){
               showCurrentUserDetail = true;
               showNewReptUserDetail = true;
            }else if(showOpenTerritory == true){
               showCurrentUserDetail = true;
               showOpenterritoryUserDetail = true;
            }
            
            if(!String.isblank(msg) && showsubbtn == true)
            {
                String msg2 = 'If you want to continue then please click on submit button';
                msg = msg + '\n' + msg2;
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,msg);
                apexpages.addMessage(myMsg);
            }else{
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,msg);
                apexpages.addMessage(myMsg);
            }
        }
        return null;
    }
     
    public Pagereference SubmitRequest()
    {
        showDTNDetail = false;
        showClosebtn = true;
        custObj = new Custodial__c();
        list_cust = new List<Custodial__c>();
        custObj.DTN_Current_Rep__c = CustodialRec.DTN_Current_Rep__c;
        
        if(optSelectedRep == 'Custodial')
        {
            custObj.DTN_Custodial_Rep__c = CustodialRec.DTN_Custodial_Rep__c;
        }else if(optSelectedRep == 'New Rep'){
            custObj.DTN_new_Rep__c = CustodialRec.DTN_new_Rep__c;
        }else if(optSelectedRep == 'New Rep'){
            custObj.DTN_new_Rep__c = CustodialRec.DTN_new_Rep__c;
        }else if(optSelectedRep == 'Open Territory'){
            custObj.DTN_Open_Territory_User__c = CustodialRec.DTN_Open_Territory_User__c;
        } 
        
        list_cust.add(custObj);
        
        if(list_cust.size() > 0)
        {
            insert list_cust;
            custodialId = list_cust[0].id;
            if(custodialId != '')
            {
                listCustodial = [SELECT Id, CurrentRepresentative__c, CustodialRepersentative__c, DTN_Current_Rep__c, DTN_Custodial_Rep__c, DTN_new_Rep__c, NewRepresentative__c, DTN_Open_Territory_User__c 
                                    FROM Custodial__c 
                                    WHERE Id =: custodialId];
                    
                if(listCustodial.size() > 0)
                {
                    DTN_Current_Rep=listCustodial[0].DTN_Current_Rep__c;
                    DTN_Custodial_Rep=listCustodial[0].DTN_Custodial_Rep__c;
                    DTN_New_Rep=listCustodial[0].DTN_new_Rep__c;
                    DTN_Open_Territory=listCustodial[0].DTN_Open_Territory_User__c;
                    system.debug('listCustodial[0].DTN_Custodial_Rep__c**'+listCustodial[0].DTN_Custodial_Rep__c);
                    system.debug('listCustodial[0].DTN_new_Rep__c**'+listCustodial[0].DTN_new_Rep__c);
                    system.debug('listCustodial[0].DTN_Open_Territory_User__c**'+listCustodial[0].DTN_Open_Territory_User__c);
                    
                    if(listCustodial[0].DTN_Current_Rep__c != NULL && listCustodial[0].DTN_Custodial_Rep__c != NULL)
                    {
                        system.debug(logginglevel.Error,'-----1-----');
                        for(String s : listCustodial[0].DTN_Custodial_Rep__c.split('\\,'))
                        {
                            system.debug(logginglevel.Error,'-----2-----');
                            if(!currentWithCustodialReps.containsKey(listCustodial[0].DTN_Current_Rep__c))
                            {
                                system.debug(logginglevel.Error,'-----3-----');
                                currentWithCustodialReps.put(listCustodial[0].DTN_Current_Rep__c, new list<String>{s});
                                dtnUsers.add(s);
                            }else{
                                system.debug(logginglevel.Error,'-----4-----');
                                currentWithCustodialReps.get(listCustodial[0].DTN_Current_Rep__c).add(s);
                                dtnUsers.add(s);
                            }
                        }
                        dtnCurrentReps.add(listCustodial[0].DTN_Current_Rep__c);
                    }
                    
                    if(listCustodial[0].DTN_Current_Rep__c != NULL && listCustodial[0].DTN_new_Rep__c != NULL)
                    {
                        currentWithNewReps.put(listCustodial[0].DTN_Current_Rep__c,listCustodial[0].DTN_new_Rep__c);
                        dtnCurrentReps.add(listCustodial[0].DTN_Current_Rep__c);
                        dtnUsers.add(listCustodial[0].DTN_new_Rep__c);
                    }
            
                    if(listCustodial[0].DTN_Current_Rep__c != NULL && listCustodial[0].DTN_Open_Territory_User__c != NULL)
                    {
                        system.debug(logginglevel.Error,'-----1-----');
                        for(String s : listCustodial[0].DTN_Open_Territory_User__c.split('\\,'))
                        {
                            system.debug(logginglevel.Error,'-----2-----');
                            if(!currentWithCustodialReps.containsKey(listCustodial[0].DTN_Current_Rep__c))
                            {
                                system.debug(logginglevel.Error,'-----3-----');
                                currentWithCustodialReps.put(listCustodial[0].DTN_Current_Rep__c, new List<String>{s});
                                dtnUsers.add(s);
                            }else{
                                system.debug(logginglevel.Error,'-----4-----');
                                currentWithCustodialReps.get(listCustodial[0].DTN_Current_Rep__c).add(s);
                                dtnUsers.add(s);
                            }
                        }
                        dtnCurrentReps.add(listCustodial[0].DTN_Current_Rep__c);
                    }
                    
                    if(dtnUsers.size() > 0)
                    {
                        for(User u: [SELECT Id, DTN__c, Name FROM User WHERE DTN__c IN: dtnUsers AND IsActive = true])
                        {
                            dtnUserMap.put(u.DTN__c,u);
                        }
                    }
                }
            }
            
            if(optSelected == 'LeadProcess')
            {    
                if(CountLead != 0)
                {
                    User u = new User();
                    u = [SELECT Id FROM User WHERE DTN__c =: DTN_Current_Rep];
                    Id CurrentRepId = u.Id;
                    if(optSelectedRep == 'Custodial'){
                        Leadquery = 'SELECT Id, IsConverted, Custodian__c, Name, OwnerId FROM Lead WHERE OwnerId = '+'\''+CurrentRepId+'\' AND IsConverted = false AND Status IN (\'Gain Access\',\'Not Started\',\'Recognize Need\') ';
                    }else{
                        Leadquery = 'SELECT Id, IsConverted, Custodian__c, Name, Ownerid FROM Lead WHERE OwnerId = '+'\''+CurrentRepId+'\' AND IsConverted = false';
                        CustodialLeadBatch custLeadBatchObj = new  CustodialLeadBatch(custodialId, DTN_Current_Rep, DTN_New_Rep, Leadquery, DTN_Custodial_Rep);               
                        System.debug('##########Lead Query for batch ########'+Leadquery);
                        database.executebatch(custLeadBatchObj);
                    }
                }
            }else if(optSelected == 'Accountprocess'){   
                if(CountAccTeamMember != 0)
                {
                    Accquery = 'SELECT Id, UserId, AccountId, TeamMemberRole, User.DTN__c, User.Name FROM AccountTeamMember WHERE User.DTN__c = ' +'\''+DTN_Current_Rep +'\'';
                    CustodialAccountBatch custAccBatchObj= new CustodialAccountBatch(custodialId,currentWithCustodialReps,DTN_Current_Rep,DTN_New_Rep,Accquery,dtnUsers,DTN_Custodial_Rep,DTN_Open_Territory);
                    database.executebatch(custAccBatchObj);
                }
            }else if(optSelected == 'both'){
                if(CountAccTeamMember != 0)
                {
                    Accquery = 'SELECT Id, UserId, AccountId, TeamMemberRole, User.DTN__c, User.Name FROM AccountTeamMember WHERE User.DTN__c = ' +'\''+DTN_Current_Rep +'\'';
                    CustodialAccountBatch custAccBatchObj= new CustodialAccountBatch(custodialId, currentWithCustodialReps, DTN_Current_Rep, DTN_New_Rep, Accquery, dtnUsers, DTN_Custodial_Rep, DTN_Open_Territory);
                    database.executebatch(custAccBatchObj);
                }
                if(CountLead != 0)
                {
                    User u = new User();
                    u = [SELECT Id FROM User WHERE DTN__c =: DTN_Current_Rep];
                    Id CurrentRepId = u.Id;
                    Leadquery = 'SELECT Id, IsConverted, Custodian__c, Name, OwnerId FROM Lead WHERE OwnerId = ' +'\''+CurrentRepId+'\' AND IsConverted = false';
                    CustodialLeadBatch custLeadBatchObj = new  CustodialLeadBatch(custodialId,DTN_Current_Rep,DTN_New_Rep,Leadquery,DTN_Custodial_Rep);               
                    database.executebatch(custLeadBatchObj);
                }
            }
            msg = 'Thanks for submitting your request. Your Request in process we will notify via email once your request will completed successfully. If you are system administrator you can monitor status of your reuest here (Setup -> Monitoring ->Apex Job)';
            if(!String.isblank(msg))
            {
                DisplayMessage = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, msg);
                apexpages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    public Pagereference CancelRequest()
    {
        reset();
        return null;
    }
   
    public Pagereference showAssgnmentBlock()
    {
        reset();
        if(optSelected == 'LeadProcess' || optSelected == 'AccountProcess'|| optSelected == 'Both')
        {
            showAssBlock=true;
        }else{
            showAssBlock = false;
        }
        return null;
    }
    
    public void reset()
    {
        showCurrentUserDetail = false;
        showCustodialUserDetail = false;
        showNewReptUserDetail = false;
        showcancelbtn = false;
        showsubbtn = false;
        DisplayMessage = false;
        showClosebtn = false;
        msg = '';
        CustodialRec.DTN_Current_Rep__c = '';
        CustodialRec.DTN_new_Rep__c = '';
        CustodialRec.DTN_Custodial_Rep__c = '';
        currentWithCustodialReps.clear();
        currentWithNewReps.clear();
        dtnCurrentReps.clear();
        dtnUsers.clear();
        dtnUserMap.clear();
    }

    public pagereference close()
    {
        if(!string.isblank(custodialId))
        {
            PageReference pr = new PageReference('/'+custodialId);
            return pr;
        }else{
            PageReference pr = new PageReference('/apex/Custodialprocess');
            return pr;
        }
    }
}