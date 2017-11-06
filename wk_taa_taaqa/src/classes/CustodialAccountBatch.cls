global class CustodialAccountBatch implements Database.Batchable < SObject > , Database.Stateful {
 global map < String, list < String >> currentWithCustodialReps;
 global String dtn_Current_Rep;
 global String query;
 global String dtn_new_Rep;
 global Id custodailrecordId;
 global integer noOfRecordsprocessed;
 //global list<ErrorRecord__c> errorRecordslist;
 String custodialrepDTN;
 String openTerritory;
 global Id accountId;
 global Boolean custodialAccessRevert;
 //global String new_Representative;
 //global String custodial_Repersentative;
 //global String current_Representative;
 global set < String > dtnUsers;
 global boolean custodiarevertfailed;
 global String originalTerritory;
 global String processName;
 global String failedrevokedaccessAccountList;
 //map<String,User>dtnUserMap = new map<String,User>();
 global CustodialAccountBatch(Id custodailrecordId, map < String, list < String >> currentwithCustodailReps, String DTN_Current_Rep, String DTN_new_Rep, String q, Set < String > dtnUsers, String custodialrepDTN, String openTerritory) {
  this.currentWithCustodialReps = currentwithCustodailReps;

  this.dtn_Current_Rep = DTN_Current_Rep;
  this.custodailrecordId = custodailrecordId;
  this.custodialrepDTN = custodialrepDTN;
  this.openTerritory=openTerritory;
  this.dtn_new_Rep = DTN_new_Rep;
  this.query = q;
  this.dtnUsers = dtnUsers;
  this.noOfRecordsprocessed = 0;
  this.custodialAccessRevert = false;
  this.custodiarevertfailed= false;
  this.originalTerritory='';
  failedrevokedaccessAccountList='';
 }
 global Database.QueryLocator start(Database.BatchableContext BC) {

  return Database.getQueryLocator(query);
 }
 global void execute(Database.BatchableContext BC, List < AccountTeamMember > accountTeamMember) {
   AsyncApexJob  job= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email,ExtendedStatus from AsyncApexJob where Id = :bc.getJobId()];  
   list < AccountTeamMember > oldaccountTeamMembers = new list < AccountTeamMember > ();
   list < AccountTeamMember > newaccountTeamMembers = new list < AccountTeamMember > ();
   list < Monitoring_Log__c > monitoringLogList = new list < Monitoring_Log__c > ();
   //list < AccountShare > sharingRules = new list < AccountShare > ();	SMS-777
   map < String, User > dtnUserMap = new map < String, User > ();
   List < Id > accountIdList = new List < Id > ();
   UtilDTNStampingAndTeamMemberCreation assignmentMartixCheckHandler;
   List < Account > accountList = new List < Account > ();
   Map < Id, Account > accountMap = new Map < Id, Account > ();
   String checkRoleValidity = '';
   String notValidAssignmentMatrixforAccount='';
   String teamMemberRole;
   Boolean validRole = false;
   //String newDtn=(String.isNotBlank(custodialrepDTN) ? custodialrepDTN : dtn_new_Rep);
   String newDtn;
   String OpportunityAccess;
   if(String.isNotBlank(custodialrepDTN)){
     newDtn=custodialrepDTN;
   }
   else if(String.isNotBlank(dtn_new_Rep)){
    newDtn=dtn_new_Rep;
   }
   else if(String.isNotBlank(openTerritory)){
    newDtn=openTerritory;
   }
 
   list < String > fieldsAssignment = new list < String > (Assignment_Matrix__c.SObjectType.getDescribe().fields.getMap().keySet());
   if (dtnUsers.size() > 0) {
    for (User u: [Select id, DTN__c, Name, FirstName, Custodial_Rep__c from user where DTN__c in : dtnUsers and IsActive = true]) {
     dtnUserMap.put(u.DTN__c, u);
    }
    System.debug('dtnUserMap'+ dtnUserMap);
   }
   
   //Define process either Custodial Assignment/ New Rep Assignment
   //processName=(String.isNotBlank(custodialrepDTN) ? 'Custodial Assignment' : 'New Rep Assignment');
   
   if(String.isNotBlank(custodialrepDTN)){
    processName='Custodial Assignment';
   }
   
   else if(String.isNotBlank(dtn_new_Rep)){
    processName='New Rep Assignment';
   }
   
   else if(String.isNotBlank(openTerritory)){
    processName='Open Territory';
   }
   
   for (AccountTeamMember a: accountTeamMember) {
    
    accountIdList.add(a.accountId);
    //Check whether New Rep DTN equal Original DTN to revoke custodail access from current DTN
    if (dtn_Current_Rep != null && dtn_new_Rep != null && dtn_Current_Rep == a.User.DTN__c) {
     if (a.TeamMemberRole.contains(dtn_new_Rep) && (a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-'))) {
     System.debug('@@'+a.TeamMemberRole);
         custodialAccessRevert = true;     
     }
    }
   }
   list < String > fieldsAccount = new list < String > (Account.SObjectType.getDescribe().fields.getMap().keySet());
   if (accountIdList.size() > 0) {
    System.debug('------Inside first check------');
    
    String soqlAccount = 'Select' + ' ' + String.join(fieldsAccount, ',') + ' ' +
     'from Account' + ' ' +
     'where Id in:accountIdList';
    accountList = Database.query(soqlAccount);
   }
   if (accountList.size() > 0) {
    
    for (Account acc: accountList) {
     if (!(accountMap.get(acc.id) != null)) {
      accountMap.put(acc.id, acc);
     }
     
    }
   }
   if (accountList.size() > 0) {
    assignmentMartixCheckHandler = new UtilDTNStampingAndTeamMemberCreation(accountList, accountMap);
   }
   for (AccountTeamMember a: accountTeamMember) {
    validRole = false;
    checkRoleValidity = '';
    Assignment_Matrix__c am ;
    try{
      am = assignmentMartixCheckHandler.getAssignmentMatrix(accountMap.get(a.accountId));
    }catch(Exception e){
          Monitoring_Log__c m = new Monitoring_Log__c();
          /*String newDtn='';
          if(String.IsNotEmpty(custodialrepDTN)){
              newDtn=custodialrepDTN;
          }else if(String.IsNotEmpty(dtn_new_Rep)){
              newDtn=dtn_new_Rep;
          }*/
          m.Name=processName;
          m.Detail__c = 'Exception Type:: '+e.getTypeName() + '::line no::' + e.getLineNumber() + '::Error message::' + e.getMessage()+'\n'+'Exception occur for Account :: '+accountMap.get(a.AccountId).Name+' while running Batch job requested by ::'+ Userinfo.getName()+ '\n'+'Current dtn:'+ dtn_Current_Rep +'\n'+ 'NewDtn/Custodial DTN:: '+ newDtn;
          m.Type__c = WK_Exception.ATA_CODE_ERROR;
          m.Custodial__c= custodailrecordId;
          m.Account__c=a.accountId;
          m.Apex_Job_ID__c= job.id;
          monitoringLogList.add(m);
    }
    
    teamMemberRole = a.TeamMemberRole;
    if(a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')){
    teamMemberRole = roleAfterremovalofCust(a.TeamMemberRole);
    originalTerritory=(a.TeamMemberRole.SubStringAfter('-')).left(4);
    }
    
    for (String fieldname: fieldsAssignment) {
     if (am != null) {
      if (am.get(fieldname) != null) {
      
       if (String.valueOf(am.get(fieldname)).equals(teamMemberRole)) {
          System.debug('::FieldName::'+fieldname+'  :::Field value in AM'+am.get(fieldname));
          validRole = true;
       }
      }
     }else{
    
     notValidAssignmentMatrixforAccount='Assignemnt Matrix Rule not found for the Account:: '+accountMap.get(a.accountId).Name + 'for Market Segment:: '+accountMap.get(a.accountId).Market_Segment__c +' and Market Sub Segment:: ' +accountMap.get(a.accountId).Market_Sub_Segment__c+' for Role ::' +teamMemberRole +' while running Batch job '+ processName+' requested by : '+ UserInfo.getName()+'\n'+'Current DTN:: '+dtn_Current_Rep+'DTN Current Rep/ DTN New Rep:: '+newDtn;
     system.debug('notValidAssignmentMatrixforAccount****'+notValidAssignmentMatrixforAccount);
     }
    }
    if (!validRole) {
     checkRoleValidity = 'Role :' + a.TeamMemberRole + ' ' + 'is no longer valid for the Account as per Assignment Matrix';
     System.debug('1::::::::Validity Role Check String Message:::: '+checkRoleValidity);
    }
   System.debug('@@currentWithCustodialReps'+ currentWithCustodialReps);
   //Custodial Assignment Process Start--------
    if (currentWithCustodialReps != null) {
     if (currentWithCustodialReps.size() > 0 && currentWithCustodialReps.containsKey(a.User.DTN__c)) {
     /* */  String role,assignmentType,typeOfException;
            if(processName=='Custodial Assignment'){
            	OpportunityAccess='Edit'; //SMS-777
             role='Cust-' + a.User.DTN__c + '-' + teamMemberRole;
             if (role.length() > 40) {
              role = 'C-' + a.User.DTN__c + '-' + teamMemberRole;
             }
             assignmentType='Custodial Assignmment';
             typeOfException=WK_Exception.ATA_CUSTODIAL_ASSIGNMENT;
        }
        else if(processName=='Open Territory'){
        	OpportunityAccess='Read';	//SMS-777
            role=teamMemberRole;
            assignmentType='Open Territory';    
            typeOfException=WK_Exception.ATA_OPEN_TERRITORY_ASSIGNMENT;  
        }
        /* */
        System.debug('@@role'+role);
      if (a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')) {
            if(processName=='Custodial Assignment'){
                role=a.TeamMemberRole;  
            }
        
        for (String s: currentWithCustodialReps.get(a.User.DTN__c)) {
            System.debug('@@s '+s);
          if(!a.TeamMemberRole.contains(s)){
            if (dtnUserMap.containskey(s)) {
            	System.debug('@@Inside Cust process '+dtnUserMap.get(s).FirstName+' '+dtnUserMap.get(s).Custodial_Rep__c+' '+processName);
             //SMS-777 Start
             //newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = a.TeamMemberRole, UserId = dtnUserMap.get(s).id));
             //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = dtnUserMap.get(s).id, AccountId = a.AccountId));
             newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = a.TeamMemberRole, UserId = dtnUserMap.get(s).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = OpportunityAccess, CaseAccessLevel = 'None'));
             if(dtnUserMap.get(s).FirstName.contains('Territory') && dtnUserMap.get(s).Custodial_Rep__c!=null && processName=='Open Territory') {
        	newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = 'Cust-'+dtnUserMap.get(s).DTN__c+'-'+role, UserId = dtnUserMap.get(s).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
        	monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch','Account'+' '+ assignmentType+' '+ 'access is assigned for role:: ' + 'Cust-'+dtnUserMap.get(s).DTN__c+'-'+a.TeamMemberRole + ' ' + 'from dtn:: ' + a.User.DTN__c + ':: ' + a.User.Name + ' to dtn:: ' + s + ':: ' + dtnUserMap.get(s).Name + '  by batch process requested by:: ' + UserInfo.getName() + '  at ' + System.now() + '\n \r' + checkRoleValidity, 'CustodialAccountBatch ', a.AccountId,typeOfException,job.id));
        }
             //SMS-777 End
                monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch', 'Account'+' '+assignmentType+' '+'access is reassigned for role:: ' + a.TeamMemberRole + ' ' + 'from dtn:: ' + a.User.DTN__c + ' :: ' + a.User.Name + ' to dtn:: ' + s + '::' + dtnUserMap.get(s).Name + ' by batch process requested by ::' + UserInfo.getName() + ' at ' + System.now() + '\n \r' + checkRoleValidity, 'CuatodialAccountBatch ', a.AccountId,typeOfException,job.id));
                  if (checkRoleValidity != '' && notValidAssignmentMatrixforAccount=='')
                    monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch', checkRoleValidity +'/n'+'Batch job requested by:: '+Userinfo.getName()+'\n'+'DTN Current Rep:: '+dtn_Current_Rep+'DTN Custodail Rep:: '+newDtn, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_CUSTODIAL_ASSIGNMENT_MATRIX_DATA,job.id));
                  if(checkRoleValidity != '' && notValidAssignmentMatrixforAccount!='')
                    monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch', notValidAssignmentMatrixforAccount, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT,job.id));
            }
        }else{Monitoring_Log__c m = new Monitoring_Log__c();
          m.Detail__c ='DTN: '+ dtn_Current_Rep+ '  for Role:: '+ a.TeamMemberRole+ ' can not be assigned custodial for DTN: '+ s +'\n'+'DTN:  '+s+ ' is alredy assigned custodial for Current DTN :: '+dtn_Current_Rep+ '\n'+'  Custodial Batch job is requested by: '+ Userinfo.getName() ;
          m.Type__c = WK_Exception.ATA_CUSTODIAL_ACCESS_REVERT_FAILED;
          m.Account__c=a.accountId;
          m.Name=processName;
          m.Apex_Job_ID__c= job.id;
          monitoringLogList.add(m);
            
            
        }
       }
           
      } else {
          System.debug('@@Inside Else '+a.User.DTN__c);
          System.debug('@@currentWithCustodialReps '+currentWithCustodialReps);
       for (String s: currentWithCustodialReps.get(a.User.DTN__c)) {
        if (dtnUserMap.containskey(s)) {
         //SMS-777 Start
         //newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = role, UserId = dtnUserMap.get(s).id));
         //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = dtnUserMap.get(s).id, AccountId = a.AccountId));
        newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = role, UserId = dtnUserMap.get(s).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = OpportunityAccess, CaseAccessLevel = 'None'));
        System.debug('newaccountTeamMembers1 '+newaccountTeamMembers);
        if(dtnUserMap.get(s).FirstName.contains('Territory') && dtnUserMap.get(s).Custodial_Rep__c!=null && processName=='Open Territory') {
        	newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, TeamMemberRole = 'Cust-'+dtnUserMap.get(s).DTN__c+'-'+role, UserId = dtnUserMap.get(s).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
        	monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch','Account'+' '+ assignmentType+' '+ 'access is assigned for role:: ' + 'Cust-'+dtnUserMap.get(s).DTN__c+'-'+a.TeamMemberRole + ' ' + 'from dtn:: ' + a.User.DTN__c + ':: ' + a.User.Name + ' to dtn:: ' + s + ':: ' + dtnUserMap.get(s).Name + '  by batch process requested by:: ' + UserInfo.getName() + '  at ' + System.now() + '\n \r' + checkRoleValidity, 'CustodialAccountBatch ', a.AccountId,typeOfException,job.id));
        }
        System.debug('newaccountTeamMembers2 '+newaccountTeamMembers);
        System.debug('@@checkRoleValidity '+checkRoleValidity+' '+notValidAssignmentMatrixforAccount);
        //SMS-777 End 
          monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch','Account'+' '+ assignmentType+' '+ 'access is assigned for role:: ' + a.TeamMemberRole + ' ' + 'from dtn:: ' + a.User.DTN__c + ':: ' + a.User.Name + ' to dtn:: ' + s + ':: ' + dtnUserMap.get(s).Name + '  by batch process requested by:: ' + UserInfo.getName() + '  at ' + System.now() + '\n \r' + checkRoleValidity, 'CustodialAccountBatch ', a.AccountId,typeOfException,job.id));
          if (checkRoleValidity != '' && notValidAssignmentMatrixforAccount=='')
           monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch', checkRoleValidity+'/n'+'Batch job requested by:: '+Userinfo.getName()+'\n'+'DTN Current Rep:: '+dtn_Current_Rep+'DTN Custodail Rep:: '+newDtn, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_CUSTODIAL_ASSIGNMENT_MATRIX_DATA,job.id));
          if(checkRoleValidity != '' && notValidAssignmentMatrixforAccount!='')
          monitoringLogList.add(createMonitoringLog(assignmentType, 'CustodialAccountBatch', notValidAssignmentMatrixforAccount, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT,job.id));
      
        }
       }
       
      } //end of else
     }
    }
    
    
    
    //New Rep Assignment Process
    
    if (dtn_Current_Rep != null && dtn_new_Rep != null && dtn_Current_Rep == a.User.DTN__c){
        System.debug('@@a.TeamMemberRole'+a.TeamMemberRole+' '+dtn_new_Rep+' '+dtn_Current_Rep);
     // Code to revert back custodial access to new account
     //**Revert Back Custodial Access. When new Rep DTN is the original dtn .Only Account teamember with role like Cust-New DTN-...OR C-New DTN-...) are assigned back to New DTN. Other team members are not touched either those are custodial to some other DTN or general teammembers**/
     if (a.TeamMemberRole.contains(dtn_new_Rep) && (a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')) && custodialAccessRevert) {
      System.debug('@@Inside 1');
         if (dtnUserMap.containskey(dtn_new_Rep)) {
             System.debug('@@Inside 2');
	   //SMS-777 Start
       //newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, UserId = dtnUserMap.get(dtn_new_Rep).id, TeamMemberRole = roleAfterremovalofCust(a.TeamMemberRole )));
       //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = dtnUserMap.get(dtn_new_Rep).id, AccountId = a.AccountId));
       newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, UserId = dtnUserMap.get(dtn_new_Rep).id, TeamMemberRole = roleAfterremovalofCust(a.TeamMemberRole ),AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None'));
       //SMS-777 End
       //try {
        monitoringLogList.add(createMonitoringLog('New Rep Assignment', 'CustodialAccountBatch', 'Account Custodial access is revoked for role:: ' + a.TeamMemberRole + ' ' + ' from dtn:: ' + a.User.DTN__c + ':: ' + a.User.Name + ' to dtn:: ' + dtn_new_Rep + '::' + dtnUserMap.get(dtn_new_Rep).Name + ' by batch process requested by:: ' + UserInfo.getName() + ' at ' + System.now() + '\n \r' + checkRoleValidity, 'CustodialAccountBatch', a.AccountId, WK_Exception.ATA_CUSTODIAL_ACCESS_REMOVED,job.id));
        if (checkRoleValidity != '' && notValidAssignmentMatrixforAccount=='')
         monitoringLogList.add(createMonitoringLog('New Rep Assignment', 'CustodialAccountBatch', checkRoleValidity+'\n'+'Batch job requested by:: '+Userinfo.getName()+'\n'+'DTN Current Rep:: '+dtn_Current_Rep+' \n'+'DTN New Rep:: '+newDtn, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_CUSTODIAL_ASSIGNMENT_MATRIX_DATA,job.id));
       if(checkRoleValidity != '' && notValidAssignmentMatrixforAccount!='')
          monitoringLogList.add(createMonitoringLog('New Rep Assignment', 'CustodialAccountBatch', notValidAssignmentMatrixforAccount, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT,job.id));  
      
      }
      if (!a.User.Name.startsWithIgnoreCase('Territory')) {
       
       oldaccountTeamMembers.add(a);
      }

     } 
     // Code to log custodial assignment restricted   when new Rep not equals Original Rep DTN
     else if(!a.TeamMemberRole.contains(dtn_new_Rep) && (a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')) && custodialAccessRevert){
          Monitoring_Log__c m = new Monitoring_Log__c();
          m.Detail__c ='Custodial Access of  Account for Role:: '+ a.TeamMemberRole+ ' is not revoked ,assigned to territory :'+dtn_Current_Rep+ 'to  new Territory '+ dtn_new_Rep+'\n'+'Original Territory missmatch found. New Territory: '+dtn_new_Rep+' is not equal to Original Terrirtory:'+originalTerritory+'\n'+'Custodial Batch job is requested by: '+ Userinfo.getName() ;
          m.Type__c = WK_Exception.ATA_CUSTODIAL_ACCESS_REVERT_FAILED;
          m.Account__c=a.accountId;
          m.Name=processName;
          m.Apex_Job_ID__c= job.id;
          monitoringLogList.add(m);
          custodiarevertfailed= true;
          failedrevokedaccessAccountList=(String.isNotBlank(failedrevokedaccessAccountList)? failedrevokedaccessAccountList+', '+accountMap.get(a.accountId).Name : accountMap.get(a.accountId).Name);
         
     }
     // Assign New Rep and Delete Current Rep when role is not Custodial and Custodial Access Revert is not true.
     else if (!(a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')) && !custodialAccessRevert) {
      if (dtnUserMap.containskey(dtn_new_Rep)) {
       //SMS-777 Start
       //newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, UserId = dtnUserMap.get(dtn_new_Rep).id, TeamMemberRole = a.TeamMemberRole));
       //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = dtnUserMap.get(dtn_new_Rep).id, AccountId = a.AccountId));
	   newaccountTeamMembers.add(new AccountTeamMember(AccountId = a.AccountId, UserId = dtnUserMap.get(dtn_new_Rep).id, TeamMemberRole = a.TeamMemberRole, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None'));
	   //SMS-777 End
       //try {
        monitoringLogList.add(createMonitoringLog('New Rep Assignmenmt', 'CustodialAccountBatch', 'Account  Team member is reassigned for role:: ' + a.TeamMemberRole + ' ' + 'from dtn:: ' + a.User.DTN__c + ': ' + a.User.Name + ' to dtn:: ' + dtn_new_Rep + ':: ' + dtnUserMap.get(dtn_new_Rep).Name + ' by batch process requested by ' + UserInfo.getName() + ' at ' + System.now() + '\n \r' + checkRoleValidity, 'CustodialAccountBatch', a.AccountId, WK_Exception.ATA_DTN_REASSIGNMENT,job.id));
        if (checkRoleValidity != '' && notValidAssignmentMatrixforAccount=='')
         monitoringLogList.add(createMonitoringLog('Custodial Assignmment', 'CustodialAccountBatch', checkRoleValidity+'/n'+'Batch job requested by:: '+Userinfo.getName()+'\n'+'DTN Current Rep:: '+dtn_Current_Rep+'DTN New Rep:: '+newDtn, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_CUSTODIAL_ASSIGNMENT_MATRIX_DATA,job.id));
        if(checkRoleValidity != '' && notValidAssignmentMatrixforAccount!='')
          monitoringLogList.add(createMonitoringLog('Custodial Assignmment', 'CustodialAccountBatch', notValidAssignmentMatrixforAccount, 'CuatodialAccountBatch ', a.AccountId, WK_Exception.ATA_ASSIGNMENT_MATRIX_RULE_NOT_IDENTIFIED_FOR_ACCOUNT,job.id));  
      
      }
      if (!a.User.Name.startsWithIgnoreCase('Territory')) {
       System.debug('-------------Inside Delete list log------------');
       oldaccountTeamMembers.add(a);
      }
     }
     // Custodial Access should not be transferred to New DTN . They can be revoked only for original DTN
     else if((a.TeamMemberRole.startsWithIgnoreCase('Cust-') || a.TeamMemberRole.startsWithIgnoreCase('C-')) && !custodialAccessRevert){
         Monitoring_Log__c m = new Monitoring_Log__c();
         m.Name=processName;
         m.Detail__c = 'Account Team Member for Role:: '+ a.TeamMemberRole +' DTN :'+ dtn_Current_Rep+' is not replaced with DTN:: '+ newDtn+'\n'+ 'Original Territory missmatch found. New Territory: '+dtn_new_Rep+' is not equal to Original Terrirtory:'+originalTerritory+'\n'+'Batch job requested by ::'+ Userinfo.getName()+ '\n'+'Current dtn:'+ dtn_Current_Rep +'\n'+ 'DTN New Rep\\DTN Custodial Rep:: '+ newDtn;
        m.Type__c = WK_Exception.ATA_CUSTODIAL_ACCESS_REVERT_FAILED;
        m.Account__c=a.accountId;
        m.Apex_Job_ID__c= job.id;
        monitoringLogList.add(m);
        custodiarevertfailed= true;
        failedrevokedaccessAccountList=(String.isNotBlank(failedrevokedaccessAccountList)? failedrevokedaccessAccountList+', '+accountMap.get(a.accountId).Name : accountMap.get(a.accountId).Name);
         
     }

    }// end of New Rep Assignment Process
    
   } // end of for loop
   //List<Lead>updateOwnerLst= new List<Lead>();
   list < Monitoring_Log__c > errorRecordslist = new list < Monitoring_Log__c > ();
 
   if (newaccountTeamMembers.size() > 0) {
    noOfRecordsprocessed = noOfRecordsprocessed + newaccountTeamMembers.size();
    Database.SaveResult[] memberslst = Database.insert(newaccountTeamMembers, false);
    for (Database.SaveResult sr: memberslst) {
    	System.debug('@@ '+memberslst+' '+newaccountTeamMembers);
     if (!sr.isSuccess()) {
      String errorMsg = '';
      for (Database.Error err: sr.getErrors()) {
       errorMsg += err.getStatusCode() + ': ' + err.getMessage() + ':: while creating Accountteam member  ' + '\n';
      }

      try {
       errorRecordslist.add(LoggerUtil.createBatchErrorRecord('CustodialAccountBatch', 'CustodialController', custodailrecordId, dtn_Current_Rep, dtn_new_Rep, custodialrepDTN, errorMsg, WK_Exception.ATA_CODE_ERROR,job.id));
      } catch (WK_Exception e) {
       Monitoring_Log__c m = new Monitoring_Log__c();
       m.name=processName;
       m.Detail__c = '::Current Rep DTN::' + dtn_Current_Rep;
       if (custodialrepDTN != null) {
        m.Detail__c = m.Detail__c + '::Custodial Rep DTN::' + custodialrepDTN;
       }
       if (dtn_new_Rep != null) {
        m.Detail__c = m.Detail__c + '::DTN New REP::' + dtn_new_Rep;
       }
       m.Detail__c = m.Detail__c + ':::::::::' + e.getTypeName() + '::line no::' + e.getLineNumber() + '::Error message::' + e.getMessage();
       m.Type__c = WK_Exception.ATA_CODE_ERROR;
       m.Apex_Job_ID__c= job.id;
       m.Custodial__c = custodailrecordId;
       errorRecordslist.add(m);

      }

     }
    }
   }
   /* SMS-777 Start
   if (sharingRules.size() > 0) {
    Database.SaveResult[] sharingRuleslst = Database.insert(sharingRules, false);
    SMS-777 End*/
    /*for (Database.SaveResult sr: sharingRuleslst) {
     if (!sr.isSuccess()) {
      String errorMsg = '';
      for (Database.Error err: sr.getErrors()) {
       errorMsg += err.getStatusCode() + ': ' + err.getMessage() + ':: while creating AccountShare Records member  ' + '\n';
      }

      try {
       errorRecordslist.add(LoggerUtil.createBatchErrorRecord('CustodialAccountBatch', 'CustodialController', custodailrecordId, dtn_Current_Rep, dtn_new_Rep, custodialrepDTN, errorMsg, WK_Exception.ATA_CODE_ERROR));
      } catch (WK_Exception e) {
       Monitoring_Log__c m = new Monitoring_Log__c();
       m.Name=processName;
       m.Detail__c = '::Current Rep DTN::' + dtn_Current_Rep;
       if (custodialrepDTN != null) {
        m.Detail__c = m.Detail__c + '::Custodial Rep DTN::' + custodialrepDTN;
       }
       if (dtn_new_Rep != null) {
        m.Detail__c = m.Detail__c + '::DTN New REP::' + dtn_new_Rep;
       }
       m.Detail__c = m.Detail__c + ':::::::::' + e.getTypeName() + '::line no::' + e.getLineNumber() + '::Error message::' + e.getMessage();
       m.Type__c = WK_Exception.ATA_CODE_ERROR;
       m.Custodial__c = custodailrecordId;
       errorRecordslist.add(m);

      }

     }
    }*/
    /* SMS-777 Start
    for(Integer i=0;i<sharingRules.size();i++){
        Database.SaveResult sr= sharingRuleslst[i];
        AccountShare accsh= sharingRules[i];
        if(!sr.isSuccess()){
        String errorMsg = '';
        for (Database.Error err: sr.getErrors()) {
          errorMsg += 'Status Code::'+err.getStatusCode() + '  :::Error Message::::: ' + err.getMessage() + ' :::: while creating AccountShare Records member  ' + '\n';
          }
          errorMsg= errorMsg+'\n \r'+ 'Account Details ::ID::: '+accsh.AccountId+' Account Name:::'+accountMap.get(accsh.AccountId).Name;
          
           try {
             errorRecordslist.add(LoggerUtil.createBatchErrorRecord('CustodialAccountBatch', 'CustodialController', custodailrecordId, dtn_Current_Rep, dtn_new_Rep, custodialrepDTN, errorMsg, WK_Exception.ATA_CODE_ERROR, job.id));
            } catch (WK_Exception e) {
           Monitoring_Log__c m = new Monitoring_Log__c();
           m.Name=processName;
           m.Detail__c = '::Current Rep DTN::' + dtn_Current_Rep;
           if (custodialrepDTN != null) {
           m.Detail__c = m.Detail__c + '::Custodial Rep DTN::' + custodialrepDTN;
         }
          if (dtn_new_Rep != null) {
           m.Detail__c = m.Detail__c + '::DTN New REP::' + dtn_new_Rep;
          }
          m.Detail__c = m.Detail__c + ':::::::::' + e.getTypeName() + '::line no::' + e.getLineNumber() + '::Error message::' + e.getMessage();
          m.Type__c = WK_Exception.ATA_CODE_ERROR;
          m.Custodial__c = custodailrecordId;
          m.Apex_Job_ID__c= job.id;
          errorRecordslist.add(m);

         }
          
        }
    
    }

   }SMS-777 End*/
   if (oldaccountTeamMembers.size() > 0) {
    System.debug('---------Inside deleteing accountteam member records');
    Database.DeleteResult[] oldMemberslst = Database.delete(oldaccountTeamMembers, false);
    for (Database.DeleteResult sr: oldMemberslst) {
     if (!sr.isSuccess()) {
      String errorMsg = '';
      for (Database.Error err: sr.getErrors()) {
       errorMsg += err.getStatusCode() + ': ' + err.getMessage() + ':: while deleting  AccountteamMember Records   ' + '\n';
      }

      try {
       errorRecordslist.add(LoggerUtil.createBatchErrorRecord('CustodialAccountBatch', 'CustodialController', custodailrecordId, dtn_Current_Rep, dtn_new_Rep, custodialrepDTN, errorMsg, WK_Exception.ATA_CODE_ERROR, job.id));
      } catch (WK_Exception e) {
       Monitoring_Log__c m = new Monitoring_Log__c();
       m.name=processName;
       m.Detail__c = '::Current Rep DTN::' + dtn_Current_Rep;
       if (custodialrepDTN != null) {
        m.Detail__c = m.Detail__c + '::Custodial Rep DTN::' + custodialrepDTN;
       }
       if (dtn_new_Rep != null) {
        m.Detail__c = m.Detail__c + '::DTN New REP::' + dtn_new_Rep;
       }
       m.Detail__c = m.Detail__c + ':::::::::' + e.getTypeName() + '::line no::' + e.getLineNumber() + '::Error message::' + e.getMessage();
       m.Type__c = WK_Exception.ATA_CODE_ERROR;
       m.Apex_Job_ID__c= job.id;
       errorRecordslist.add(m);
      }

     }
    }
   }
      if (errorRecordslist.size() > 0) {
    Database.SaveResult[] er = Database.insert(errorRecordslist, false);
   }
   if (monitoringLogList.size() > 0) {
    Database.SaveResult[] er = Database.insert(monitoringLogList, false);
   }
  } // end of execute method
 global void finish(Database.BatchableContext bc) {
  AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
   TotalJobItems, CreatedBy.Email, ExtendedStatus
   from AsyncApexJob where Id = : bc.getJobId()
  ];
  Monitoring_Log__c er = new Monitoring_Log__c();

  er.Type__c = WK_Exception.ATA_CUSTODIAL_ACCOUNT_BATCH_JOB;
  er.Custodial__c = custodailrecordId;
  er.Name = processName;
  er.Class__c = 'CustodialProcess';
  er.Apex_Job_ID__c= a.id;
  System.debug('@@@'+custodialrepDTN+' '+a.NumberOfErrors);
  if (custodialrepDTN != null) {
   if (!(a.NumberOfErrors > 0)) {
    
    er.Detail__c = 'Custodial Access for all Accounts assigned to  territory ' + dtn_Current_Rep + ' is granted to territory ' + custodialrepDTN + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   } else {
    er.Detail__c = 'Error occurs while assigning Custodial Access for Accounts assigned to  territory ' + dtn_Current_Rep + ' to Territory ' + custodialrepDTN + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;

   }
  }
  
 if (openTerritory != null) {
   if (!(a.NumberOfErrors > 0)) {
    
    er.Detail__c = 'Open Territory Access for all Accounts assigned to  territory ' + dtn_Current_Rep + ' is granted to territory ' + openTerritory + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   } else {
    er.Detail__c = 'Error occurs while assigning Open Territory Access for Accounts assigned to  territory ' + dtn_Current_Rep + ' to Territory ' + openTerritory + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;

   }
  }
   
  if (dtn_new_Rep != null && !custodialAccessRevert) {
   if (!(a.NumberOfErrors > 0)) {
    er.Detail__c = 'Accounts assigned to territory ' + dtn_Current_Rep + ' are  assigned to territory ' + dtn_new_Rep + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   } else {
    er.Detail__c = 'Error occurs while  assigning Accounts  assigned to territory ' + dtn_Current_Rep + ' to territory ' + dtn_new_Rep + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   }
  }

  if (dtn_new_Rep != null && custodialAccessRevert && !custodiarevertfailed) {
   if (!(a.NumberOfErrors > 0)) {
    er.Detail__c = 'Custodial Access of all Accounts for territory ' + dtn_Current_Rep + ' is revoked and assigned back to original territory  ' + dtn_new_Rep + '  by a batch job requested by ' + UserInfo.getName() + 'at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   } else {
    er.Detail__c = 'Error occurs while  assigning Accounts  assigned to territory ' + dtn_Current_Rep + ' to territory ' + dtn_new_Rep + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   }
  }
  if(dtn_new_Rep != null  && custodiarevertfailed){
      if (!(a.NumberOfErrors > 0)) {
    er.Detail__c = 'Custodial Access of  Accounts  not revoked ,assigned to territory :'+dtn_Current_Rep+ 'to  new Territory '+ dtn_new_Rep+'\n'+'Original Territory missmatch found. New Territory: '+dtn_new_Rep+' is not equal to Original Terrirtory:'+originalTerritory+'\n'+'Custodial Batch job is requested by: '+ Userinfo.getName()+'\n' +'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus+'\n\r'+ 'List Of Account Names:: '+failedrevokedaccessAccountList;
   } else {
    er.Detail__c = 'Error occurs while  assigning Accounts  assigned to territory ' + dtn_Current_Rep + ' to territory ' + dtn_new_Rep + ' by a batch job requested by ' + UserInfo.getName() + ' at' + System.now() + '\n' +
     'The batch Apex job processed ' + a.TotalJobItems +
     ' batches with ' + a.NumberOfErrors + ' failures.' + '::Total No Of Records Processed::' + noOfRecordsprocessed + 'ExtendedStatus: ' + a.ExtendedStatus;
   }
      
  }

  insert er;
  

  // Email the Batch Job's submitter that the Job is finished.
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  String[] toAddresses = new String[] {
   a.CreatedBy.Email
  };
  mail.setToAddresses(toAddresses);
  mail.setSubject('CustodialBatchJob Status: ' + a.Status);
  mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
 }
 public String roleAfterremovalofCust(String teamMemberRole){
 String role=teamMemberRole.substringAfter('-');
 List<String>roleList= new List<String>();
 for(String s: role.split('-')){
   if(!s.isNumeric()){
     roleList.add(s);
   }
 }
 if(roleList.size()>0){
 role=String.join(roleList,'-');
 }
 return role;
 }
 public Monitoring_Log__c  createMonitoringLog(String processName, String className, String detail, String methodName, String accountId, String errorType,String jobId){
        Monitoring_Log__c  er = new Monitoring_Log__c ();
        er.Name = processName;
        er.Class__c = className;
        er.Detail__c = detail;
        er.Method__c = methodName;
        er.Account__c = accountId;
        er.Type__c = errorType;
        er.Apex_Job_ID__c= jobId;
        return er;
    }
}