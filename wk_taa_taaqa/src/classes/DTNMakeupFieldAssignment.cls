global class DTNMakeupFieldAssignment implements Database.Batchable<sObject>{

   global final String Query;
   global set<id> set_account = new set<id>();
   global list<Account> list_Account = new list<Account>();
   global Map<id,list<AccountTeamMember>> mapAccountWithTeam = new map<id,list<AccountTeammember>>();
   global list<Account> list_Acc_update = new list<Account>();
   global Map<Id,Account> accountMap= new Map<Id,Account>();
   global Set<String>ZipCodeSet = new Set<String>();
   global Map<String,ZipCodeDTN__c> ZipCodeMap= new Map<String,ZipCodeDTN__c>();
    map<String,Strategic_Account_RoleDTN__c>stratgiecAccountMap     = new map<String,Strategic_Account_RoleDTN__c>();
    map<String,Corporate_National_Role_DTN__c>corNationalMap        = new map<String,Corporate_National_Role_DTN__c>();
    map<String,National_Account_Management__c>nationalAccountMap    = new map<String,National_Account_Management__c>();
   global DTNMakeupFieldAssignment()   
   {
      list<String>fieldsAssignment = new list<String>(Account.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlAssignment = 'Select'+' '+String.join(fieldsAssignment,',')+' '+
                                'from Account where Named_Account_Type__c!=\'Federal Government\' And Market_Segment__c!=null AND Market_Sub_Segment__c!=null AND BillingPostalCode!=null';
        
      //Query='Select id,name from Account';
      Query=soqlAssignment;
      System.debug('>>>>>>>'+Query+'<<<<<<<<<<<<');
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Account> listAccount){
   AsyncApexJob  job= [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email,ExtendedStatus from AsyncApexJob where Id = :bc.getJobId()];  
   set<String> nationalSet = new set<String>();
   set<String> corpNationalSet = new set<String>();
   set<String> strategicSet = new set<String>();
     for(Account a : listAccount)
     {
         set_account.add( a.id);
         list_Account.add(a);
         accountMap.put(a.Id,a);
         if(String.isNotBlank(a.BillingPostalCode) && a.BillingPostalCode.length()>4){
              zipCodeSet.add(a.BillingPostalCode.substring(0,5));
            }
         if(a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c)){
            if(a.Named_Account_Type__c.equals('National')){
                 nationalSet.add(a.Name);
            }if(a.Named_Account_Type__c.equals('Strategic')){
                 strategicSet.add(a.Name);
            }if(a.Named_Account_Type__c.equals('Corporate National')){
                corpNationalSet.add(a.Name);            
            }   
          }
     }  
     list<String>fieldsZipCodeDTN = new list<String>(ZipCodeDTN__c.SObjectType.getDescribe().fields.getMap().keySet());
     String soqlZipCodeDTN ='Select'+' '+String.join(fieldsZipCodeDTN,',')+' '+
                                'from ZipCodeDTN__c'+' '+
                                'where Name in:zipCodeSet'; 
        for(ZipCodeDTN__c z : Database.query(soqlZipCodeDTN)){
            zipCodeMap.put(z.Name,z);
        }
        //create map for Strategic Account Role-DTN as account and rep
        if(strategicSet.size()>0){
            for(Strategic_Account_RoleDTN__c s : [Select Name,Account__c,DTN__c,Strategic_Account_Manager__c,Sfdc_Custid__c from Strategic_Account_RoleDTN__c where Account__c in: strategicSet]){
                stratgiecAccountMap.put(s.Account__c, s);
            }
        }
        //create map for Corporate National Role-DTN as account and rep
        if(corpNationalSet.size()>0){
            for(Corporate_National_Role_DTN__c c : [Select Name,Account__c,DTN__c,Corporate_National_Account_Manager__c,Sfdc_Custid__c from Corporate_National_Role_DTN__c where Account__c in: corpNationalSet]){
                corNationalMap.put(c.Account__c,c);
            }
        }
        //create map for Strategic Account Role-DTN as account and rep
        if(nationalSet.size()>0){
            for(National_Account_Management__c n : [Select Name,Account__c,DTN__c,NationalAccountManager__c,Sfdc_Custid__c from National_Account_Management__c where Account__c in: nationalSet]){
                nationalAccountMap.put(n.Account__c,n);
            }
        }
      UtilDTNStampingAndTeamMemberCreation assignmentMartixCheckHandler= new UtilDTNStampingAndTeamMemberCreation(list_Account, accountMap);
     system.debug('Set Account ::' +set_account);
     system.debug('List Account ::' +list_Account);
     System.debug('stratgiecAccountMap Size======='+stratgiecAccountMap.size());
     System.debug('corNationalMap Size======='+corNationalMap.size());
     System.debug('nationalAccountMap Size======='+nationalAccountMap.size());
     
    for(AccountTeamMember AccTeam:[Select id,AccountId,TeamMemberRole,UserId,User.dtn__c from AccountTeamMember where AccountId in: set_account])
    {

        if(mapAccountWithTeam.get(AccTeam.AccountId) == null)
        {
          mapAccountWithTeam.put(AccTeam.AccountId,new list<AccountTeamMember>());
        }
        mapAccountWithTeam.get(AccTeam.AccountId).add(AccTeam);   
    
    }
    system.debug('Map Account Team::' +mapAccountWithTeam);

    for(Account acc:list_Account)
    {   String zip='';
        Assignment_Matrix__c am= assignmentMartixCheckHandler.getAssignmentMatrix(Acc);
        list<AccountTeamMember> list_accTeamMember = new list<AccountTeamMember>();
        list_accTeamMember=mapAccountWithTeam.get(Acc.id);
        if(String.isNotBlank(acc.BillingPostalCode) && acc.BillingPostalCode.length() >4){
            zip = acc.BillingPostalCode.substring(0,5);
        }
        system.debug('List Account Team Member::' +list_accTeamMember);
        if(list_accTeamMember!=null && am!= null && acc.Market_Segment__c!= null && acc.Market_Sub_Segment__c!=null && acc.BillingPostalCode!=null)
        {
        
        for(AccountTeamMember AccTeam:list_accTeamMember)
        {
                String s=AccTeam.TeamMemberRole;
                system.debug('Team Member Role::' +s);
                if(String.isNotBlank(zip) && zipCodeMap.containsKey(zip)){
                //will assign to QP of Account
                   if(s=='QP Specialist' && String.IsNotEmpty(am.QP__c) &&  zipCodeMap.get(zip).QP__c != Null)
                    {
                       system.debug('Inside If');
                      // Acc.QP__c=AccTeam.user.DTN__c;
                       acc.Qp__c=zipCodeMap.get(zip).QP__c;
                    
                    }
                   else if((s=='ASR - Research and Learning' || s=='RC - Research and Learning' || s=='RC - Research & Learning')&& String.IsNotEmpty(am.R_L_ASR__c)&& zipCodeMap.get(zip).R_L_ASR__c!=null)
                    {
                      //Acc.R_L_ASR__c=AccTeam.user.DTN__c;
                      Acc.R_L_ASR__c= zipCodeMap.get(zip).R_L_ASR__c;
                    }
                   else if((s=='FSR - Research and Learning' || s=='RSC - Research & Learning')&& String.IsNotEmpty(am.R_L_FSR__c)&& zipCodeMap.get(zip).R_L_FSR__c != Null)
                   { 
                      //Acc.R_L_FSR__c=AccTeam.user.DTN__c;
                      Acc.R_L_FSR__c=zipCodeMap.get(zip).R_L_FSR__c ;
                   }
                   else if((s=='ASR - Software (Professional)' || s=='RC - Professional Software')&& String.IsNotEmpty(am.SW_ASR__c) && zipCodeMap.get(zip).SW_ASR__c!= Null )
                   {
                      //Acc.SW_ASR__c=AccTeam.user.DTN__c;
                      Acc.SW_ASR__c=zipCodeMap.get(zip).SW_ASR__c;
                   }
                   else if((s=='ASR - R&L - Service Source'|| s=='RC - R&L ServiceSource') && String.IsNotEmpty(am.Service_Source__c)&& zipCodeMap.get(zip).Service_Source__c!= Null)
                   {
                      //Acc.Service_Source__c=AccTeam.user.DTN__c;
                      Acc.Service_Source__c=zipCodeMap.get(zip).Service_Source__c;
                   }
                   else if((s=='AISR' || s=='ISC - Books & Journals')&& String.IsNotEmpty(am.AISR__c)&& zipCodeMap.get(zip).AISR__c!= Null)
                   {
                      //Acc.AISR__c=AccTeam.user.DTN__c;
                      Acc.AISR__c=zipCodeMap.get(zip).AISR__c;
                   }
                  else if((s=='FSR - Software(Professional)' || s=='RSC - Professional Software') && String.IsNotEmpty(am.Pro_SW_FSR__c)&& zipCodeMap.get(zip).Pro_SW_FSR__c!= Null)
                  {
                    //Acc.Pro_SW_FSR__c=AccTeam.user.DTN__c;
                    Acc.Pro_SW_FSR__c=zipCodeMap.get(zip).Pro_SW_FSR__c;
                  }
                  else if(/*s=='ISR - Software(Professional)*/s=='ISC - Corp Software Indirect' && String.IsNotEmpty(am.ISR_Indirect__c) && zipCodeMap.get(zip).ISR_Indirect__c!= null )
                  {
                    //Acc.Pro_SW_ISR__c=AccTeam.user.DTN__c;
                    /*if(acc.Inside_Sales__c !=null)
                      {
                                      acc.Inside_Sales__c += ','+AccTeam.user.DTN__c;
                       }else
                        {
                                       acc.Inside_Sales__c = AccTeam.user.DTN__c;
                        }*/
                     //acc.Inside_Sales__c = AccTeam.user.DTN__c;
                     acc.ISR_Indirect__c=zipCodeMap.get(zip).ISR_Indirect__c;
                  }
                  else if(/*s=='FSR - Indirect (Corp Sotware)'*/ s=='RSC - Corp Software Indirect' && String.isnotEmpty(am.Corp_Indirect__c) && zipCodeMap.get(zip).Corp_Indirect__c!= Null)
                  {
                     //Acc.Corp_Indirect__c=AccTeam.user.DTN__c;
                     Acc.Corp_Indirect__c=zipCodeMap.get(zip).Corp_Indirect__c;
                  }
               /* else if(s=='ISR - Indirect (Corp Software)')
                {
                    if(acc.Inside_Sales__c !=null)
                      {
                                      acc.Inside_Sales__c += ','+AccTeam.user.DTN__c;
                       }else
                        {
                                       acc.Inside_Sales__c = AccTeam.user.DTN__c;
                        }
                }*/
                  else if(s=='National Solution Consultant' || s=='Strategic Solution Consultant' || s=='Corp Nat\'l Solution Consultant' && String.isnotEmpty(am.NAM_SAM_CNAM__c))
                  {       
                      if(acc.Named_Account__c == true && acc.Named_Account_Type__c != null && acc.Named_Account_Type__c.equals('National') && nationalAccountMap.containsKey(acc.Name))
                      {
                         //Acc.NAM_SAM_CNAM__c=AccTeam.user.DTN__c;
                         Acc.NAM_SAM_CNAM__c=nationalAccountMap.get(acc.Name).DTN__c;
                      }
                      if(acc.Named_Account__c == true && acc.Named_Account_Type__c != null && acc.Named_Account_Type__c.equals('Strategic') && stratgiecAccountMap.containsKey(acc.Name))
                      {
                         //Acc.NAM_SAM_CNAM__c=AccTeam.user.DTN__c;
                         Acc.NAM_SAM_CNAM__c=stratgiecAccountMap.get(acc.Name).DTN__c;
                      }
                      if(acc.Named_Account__c == true && acc.Named_Account_Type__c != null && acc.Named_Account_Type__c.equals('Corporate National') && corNationalMap.containsKey(acc.Name))
                      {
                         //Acc.NAM_SAM_CNAM__c=AccTeam.user.DTN__c;
                         Acc.NAM_SAM_CNAM__c=corNationalMap.get(acc.Name).DTN__c;
                      }
                      
                  }  
                  else if(/*s=='FSR - Direct (Corp Software)'*/ s=='RSC - Corp Software Direct' && String.isnotEmpty(am.Corp_Direct__c) && zipCodeMap.get(zip).Corp_Direct__c != Null)
                  {
                     //Acc.Corp_Direct__c=AccTeam.user.DTN__c;
                     Acc.Corp_Direct__c=zipCodeMap.get(zip).Corp_Direct__c;
                  }
                  else if(s=='ISC - Research & Learning' && String.isnotEmpty(am.R_L_ISR__c)&& zipCodeMap.get(zip).R_L_ISR__c!= Null)
                  {
                    //Acc.R_L_ISC__c = AccTeam.user.DTN__c;
                    Acc.R_L_ISC__c=zipCodeMap.get(zip).R_L_ISR__c;
                  }
                  else if(s=='ISC - Professional Software' && String.isnotEmpty(am.Pro_SW_ISR__c) && zipCodeMap.get(zip).Pro_SW_ISR__c!= null)
                  {
                    acc.Inside_Sales__c=zipCodeMap.get(zip).Pro_SW_ISR__c;
                  }   
                }         
        }
         list_Acc_update.add(Acc);
    }
    }   Database.SaveResult[] srList;
        List<Monitoring_Log__c>errorRecordslist= new List<Monitoring_Log__c>();
        if(list_Acc_update.size()>0){  
       
                srList=Database.update(list_Acc_update, false);
            
          
               //System.debug('Inside Exception'+e.getmessage());
               for(integer i=0;i<srList.size();i++){
                if (!srList.get(i).isSuccess()){             
                    System.debug('Exception found in Account while running batch script');
                    Monitoring_Log__c m = new Monitoring_Log__c();
                    m.Name = 'DTNMakeupFieldAssignment_Batch';
                  //m.Account__c = a.id;
                    String errormsg='';
                    String errormsg2='';
                    for (Database.Error err : srList.get(i).getErrors()){
                       errormsg=errormsg+' '+err.getMessage()+' '+err.getFields();
    
                    }
                    m.Apex_Job_ID__c=job.id;
                    m.Detail__c = errormsg;
                    m.Type__c = 'ATA_Script_Exception';
                    m.Account__c=list_Acc_update.get(i).id;
                    errorRecordslist.add(m);
                }
            }
            
        }
        
        if(errorRecordslist.size()>0){
            Database.insert(errorRecordslist,false);
        }
        
   }    
   global void finish(Database.BatchableContext BC){
   }
}