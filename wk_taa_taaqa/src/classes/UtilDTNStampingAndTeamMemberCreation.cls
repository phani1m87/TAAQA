/**
@Author: HCL Technologies Pvt. Ltd.
@Description: Class has methods to create Account team members and stamping DTNs on corresponding DTN fields on Account
*/
public class UtilDTNStampingAndTeamMemberCreation {
    map<String,Assignment_Matrix__c>assignmentMatrixMap             = new map<String,Assignment_Matrix__c>();
    
    map<String,ZipCodeDTN__c>zipCodeMap                             = new map<String,ZipCodeDTN__c>();
    map<String,Strategic_Account_RoleDTN__c>stratgiecAccountMap     = new map<String,Strategic_Account_RoleDTN__c>();
    map<String,Corporate_National_Role_DTN__c>corNationalMap        = new map<String,Corporate_National_Role_DTN__c>();
    map<String,National_Account_Management__c>nationalAccountMap    = new map<String,National_Account_Management__c>();
    map<String,ServiceSource_Role_DTN__c>serviceSourceMap           = new map<String,ServiceSource_Role_DTN__c>();
    map<String, Market_Segment_Mapping__c> marketSegmentsMap        = new map<String, Market_Segment_Mapping__c>();
    map<String,market_segment_rules__c>marketSegmentRulesMap        = new map <String,market_segment_rules__c>();
    map<String,User> userMap                                        = new map<String,User>();
    map<Id,map<String,AccountTeamMember>> availabelATMs             = new map<Id,map<String,AccountTeamMember>>();
    map<String,map<String,String>> availabelZipAMWithDtnToRole      = new map<String,map<String,String>>();
    map<String,map<String,String>> availabelOldZipAMWithDtnToRole   = new  map<String,map<String,String>>();
    Id excludeRecordType;
    public  FederalRoleManager__c taaCusFedSet;
    
    
    /*
    @constructor
    @description: Initialize the Account Manager for named Account in map,
    @               Custodial User,dtn with role on the basis of Assignment Matrix.
    @param: list of Accounts which will be included in the process.
    */
    public UtilDTNStampingAndTeamMemberCreation(list<Account>newAccountList, map<id, Account>oldMap){
      //check account record type to exclude in the process
      String recordTypeName;
      if(UtilCustomSettings.TAACustomSetting() !=null && String.isNotBlank(UtilCustomSettings.TAACustomSetting().ATA_ExcludeAccountRecordType__c)){
        recordTypeName = UtilCustomSettings.TAACustomSetting().ATA_ExcludeAccountRecordType__c;
      }
      if(String.isNotBlank(recordTypeName)){
        excludeRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
      }
      taaCusFedSet=FederalRoleManager__c.getInstance();
      
      if(taaCusFedSet== null){
            taaCusFedSet= FederalRoleManager__c.getOrgDefaults();
       }
        set<String> nationalSet = new set<String>();
        set<String> corpNationalSet = new set<String>();
        set<String> strategicSet = new set<String>();
        set<String> serviceSourceSet = new set<String>();
        Set<String> dtnSet = new Set<String>();
        list<User> userList = new list<User>();
        
        for(Market_Segment_Mapping__c m : Market_Segment_Mapping__c.getAll().values()){
            marketSegmentsMap.put(m.SIC_Code__c,m);  
              
        }
        
        for(market_segment_rules__c ms : market_segment_rules__c.getAll().values()){
            marketSegmentRulesMap.put(ms.Segment__c,ms);
        }
        
        for(Account a : newAccountList){
            
            if(a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c) && !a.Exclude_Account_Automation__c){
                if(a.Named_Account_Type__c.equals('National')){
                    nationalSet.add(a.Name);
                }if(a.Named_Account_Type__c.equals('Strategic')){
                    strategicSet.add(a.Name);
                }if(a.Named_Account_Type__c.equals('Corporate National')){
                    corpNationalSet.add(a.Name);
                }if(a.Named_Account_Type__c.equals('Service Source')){
                    serviceSourceSet.add(a.Name);
                }
            }
        }
        
        list<String>fieldsAssignment = new list<String>(Assignment_Matrix__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlAssignment = 'Select'+' '+String.join(fieldsAssignment,',')+' '+
                                'from Assignment_Matrix__c';
          
        for(Assignment_Matrix__c am : Database.query(soqlAssignment)){
            

            // Code modified to handle All scenario in Assignment MAtrix for Market_Sub_Segment__c value.
            String key='';
            if(am.Market_Sub_Segment__c.equals('All')){
                key=am.Market_Segment__c;
             }if(am.IsNamedAccount__c==true){
                key=am.NamedAccountType__c;
             }if(am.IsNamedAccount__c==false && am.Market_Sub_Segment__c !='All'){
                key = am.Market_Segment__c+'_'+am.Market_Sub_Segment__c;
             }
            
            assignmentMatrixMap.put(key,am);
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
                system.debug('nationalAccountMap****'+nationalAccountMap);
            }
        }
        //create map for ServiceSource Role-DTN as account and rep
        if(serviceSourceSet.size()>0){
            for(ServiceSource_Role_DTN__c ss : [Select Name,Account__c,DTN__c,Service_Source_Manager__c,Sfdc_Custid__c from ServiceSource_Role_DTN__c where Account__c in: serviceSourceSet]){
                serviceSourceMap.put(ss.Account__c,ss);
            }
        }
        
        set<String>zipCodeSet = new set<String>();
        for(Account acc : newAccountList){
            if(String.isNotBlank(acc.BillingPostalCode) && acc.BillingPostalCode.length()>4){//&& acc.BillingPostalCode.contains('-')
                //zipCodeSet.add(acc.BillingPostalCode.substringBefore('-'));
                zipCodeSet.add(acc.BillingPostalCode.substring(0,5));
            }
        }
        //add old zipcode to zipCodeSet
        if(oldMap !=null){
            for(Account acc : oldMap.values()){
                if(String.isNotBlank(acc.BillingPostalCode) && acc.BillingPostalCode.length()>4){//&& acc.BillingPostalCode.contains('-')
                    //zipCodeSet.add(acc.BillingPostalCode.substringBefore('-'));
                    zipCodeSet.add(acc.BillingPostalCode.substring(0,5));
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
        
        //dtnWithRoleMap = assignDtnWithRole(newAccountList);
        availabelZipAMWithDtnToRole = assignZipAMWithDtnToRole(newAccountList);
        
        if(oldMap !=null){
            
            availabelOldZipAMWithDtnToRole = assignOldZipAMWithDtnToRole(oldMap.values());
            
        }
        
        //Create Map of user which is going to be assigned as account team member
        for(Account acc : newAccountList){
            if(oldMap !=null && oldMap.get(acc.id) !=null){
                dtnSet.addAll(createDtnSet(acc, oldMap.get(acc.id)));
                
                
                if(String.isNotBlank(acc.NAM_SAM_CNAM__c) && (String.isBlank(oldMap.get(acc.id).NAM_SAM_CNAM__c) || acc.NAM_SAM_CNAM__c !=oldMap.get(acc.id).NAM_SAM_CNAM__c)){
                    dtnSet.add(acc.NAM_SAM_CNAM__c);
                }
                
                if(String.isNotBlank(acc.Service_Source__c) && (String.isBlank(oldMap.get(acc.id).Service_Source__c) || acc.Service_Source__c !=oldMap.get(acc.id).Service_Source__c)){
                    dtnSet.add(acc.Service_Source__c);
                }
            }else{
                dtnSet.addAll(createDtnSet(acc, null));
                if(String.isNotBlank(acc.NAM_SAM_CNAM__c)){
                    
                    dtnSet.add(acc.NAM_SAM_CNAM__c);
                }
                if(String.isNotBlank(acc.Service_Source__c)){
                    dtnSet.add(acc.Service_Source__c);
                }
            }
        }
        //SMS-734 Updated
        //for(User u : [Select id,Name,DTN__c from User where isActive=true]){
        for(User u : [Select id,Name,DTN__c,FirstName,Custodial_Rep__c from User where isActive=true]){
            userMap.put(u.DTN__c,u);
            
        }
        
        //Create map to check availabilty of account team members
        if(oldMap !=null){
        
            for(AccountTeamMember atm : [Select Id,User.DTN__c,User.Name, accountId,TeamMemberRole,account.Name from AccountTeamMember where accountId in: oldMap.keySet()]){
                
                if(String.isNotBlank(atm.User.DTN__c)){
                    if(availabelATMs.containsKey(atm.accountId)){
                        
                        if(!availabelATMs.get(atm.accountId).containsKey(atm.User.DTN__c)){
                           
                            availabelATMs.get(atm.accountId).put(atm.User.DTN__c,atm);
                        }
                    }else{
                        availabelATMs.put(atm.accountId, new map<String,AccountTeamMember>{atm.User.DTN__c => atm});
                        
                    }
                }
            }
        }
        
    }
    
    /*
    @method: assignAccountTeamAndSharingRules
    @description: Create Account Team Members and sharing rules.
    @               for sharing rules Account has edit while Case and opportunity are read only access.
    @params: list of all accounts and map of accounts
    */
    public list<Monitoring_Log__c> assignAccountTeamAndSharingRules(list<Account>newAccountList,Map<id,Account>oldMap){
        
        list<AccountTeamMember>members = new list<AccountTeamMember>();
        //list<AccountShare>sharingRules = new list<AccountShare>();	SMS-735
        list<Monitoring_Log__c> errorRecordslist = new list<Monitoring_Log__c>();
        list<AccountTeamMember> updateabelTeamMembers = new list<AccountTeamMember>();

        //create list of Account team Members and their Access to Account, Opportunity, case
        for(Account a : newAccountList){
            String keyOfAssignmentMatrix = getAssignmentMatrixKey(a);
            if(a.Exclude_Account_Automation__c == false && a.RecordTypeId != excludeRecordType && a.Inactive__c == false){
                String monitor = '';
                String info = '';
                //Issue 500 Start
                if(a.BillingPostalCode != null && a.Market_Segment__c !=null && a.Market_Sub_Segment__c!=null){
            
                
                if(a.BillingPostalCode != Null && a.BillingPostalCode.length() >4 &&
                    (oldMap ==Null ||
                    a.BillingPostalCode !=oldMap.get(a.id).BillingPostalCode || 
                    a.Market_Segment__c !=oldMap.get(a.id).Market_Segment__c || 
                    a.Market_Sub_Segment__c !=oldMap.get(a.id).Market_Sub_Segment__c ||
                    a.Sic != oldMap.get(a.id).Sic ||
                    a.NumberOfEmployees != oldMap.get(a.id).NumberOfEmployees ||
                    a.AnnualRevenue != oldMap.get(a.id).AnnualRevenue ||
                    (a.Named_Account__c && (String.isNotBlank(a.Named_Account_Type__c) && a.Named_Account_Type__c != oldMap.get(a.id).Named_Account_Type__c)) ||
                    a.Named_Account__c!=oldMap.get(a.id).Named_Account__c) || a.Name != oldMap.get(a.id).Name ){
                        
                        if(oldMap != null && oldMap.get(a.id) != null){
                            info += checkChangesOnAccount(a, oldMap.get(a.id));
                        }else{
                            info += checkChangesOnAccount(a,null);
                        }
                        
                        if(oldMap !=null && oldMap.get(a.id).BillingPostalCode !=null && String.isBlank(a.BillingPostalCode)){
                            
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',WK_Exception.ATA_ZIPCODE_CHANGED+ ' from '+oldMap.get(a.id).BillingPostalCode+ ' to null.', 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_ZIPCODE_SET_TO_NULL));
                        }
                      
                        list<String>dtnSetlst;
                        if(oldMap != null && oldMap.get(a.id) !=null){
                            dtnSetlst = new list<String>(createDtnSetToCreateATMs(a, oldMap.get(a.id)));
                        }else{
                            dtnSetlst = new list<String>(createDtnSetToCreateATMs(a, null));
                        }
                       
                        if(dtnSetlst.size()>0){
                            if(((a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c)) 
                                    && ((String.isNotBlank(a.NAM_SAM_CNAM__c) && userMap.containsKey(a.NAM_SAM_CNAM__c)) 
                                    || (String.isNotBlank(a.Service_Source__c) && userMap.containsKey(a.Service_Source__c))))==true 
                                || (!a.Named_Account__c && String.isBlank(a.Named_Account_Type__c)) ){
                                for(String s : dtnSetlst){
                                    if(userMap.containsKey(s) ){
                                    	//SMS-735 Start
                                        //members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s), UserId =userMap.get(s).id ));
                                        //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(s).id, AccountId = a.id));
										members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s), UserId =userMap.get(s).id, AccountAccessLevel = 'Edit',OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None'));
                                        monitor += userMap.get(s).Name+' with role '+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s)+' and dtn '+userMap.get(s).DTN__c+' created.' +'\r\n';
                                        //SMS-735 End
                                        //SMS-734 Start
                                        if(userMap.get(s).FirstName!=Null) {
                                        if(userMap.get(s).FirstName.contains('Territory') && userMap.get(s).Custodial_Rep__c!=null) {
                                            //SMS-735 Start
                                            //members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(s).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s), UserId =userMap.get(s).Custodial_Rep__c));
                                            //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(s).Custodial_Rep__c, AccountId = a.id));
											members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(s).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s), UserId =userMap.get(s).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
											//SMS-735 End
                                            monitor += userMap.get(s).Custodial_Rep__c+' with role '+ 'Cust-'+userMap.get(s).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s)+' and dtn '+userMap.get(s).DTN__c+' created.' +'\r\n';
                                        }
                                        }
                                        //SMS-734 End
                                    }else{
                                       
                                        String noUser = WK_Exception.ATA_USER_NOT_ACTIVE_OR_PRESENT+' For dtn '+ s + ' and role : ' + availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s) + '\r\n';
                                        if(a.Named_Account__c){
                                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',noUser, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_USER_NOT_ACTIVE_OR_PRESENT_FOR_NAMED_ACCOUNT));
                                        }else{
                                            monitor += noUser;
                                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',noUser, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_TEAM_MEMBER_NOT_CREATED));
                                        }
                                    }
                                }
                            }else{
                                String notCreating = 'Not creating account team member for '+ '\r\n';
                                for(String s : dtnSetlst){
                                    notCreating += 'DTN : '+ s + ' and Role : ' + availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(s) + '\r\n';
                                }
                                errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',notCreating, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_TEAM_MEMBER_NOT_CREATED_FOR_NAMED_ACCOUNT));
                            }
                        }
                        //updating team roles
                        if(((a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c)) 
                             && ((String.isNotBlank(a.NAM_SAM_CNAM__c) && userMap.containsKey(a.NAM_SAM_CNAM__c)) 
                                    || (String.isNotBlank(a.Service_Source__c) && userMap.containsKey(a.Service_Source__c))))==true 
                                 || (!a.Named_Account__c && String.isBlank(a.Named_Account_Type__c)) ){
                            if(oldMap !=null && oldMap.get(a.id) !=null){
                                
                                ATMSWithStatus aws = atmsToBeUpdatedForRole(oldMap.get(a.id),a);
                                
                                if(aws != null && aws.atmsupdatedWithRole !=null && aws.atmsupdatedWithRole.size()>0){
                                    updateabelTeamMembers.addAll(aws.atmsupdatedWithRole);
                                    monitor += aws.status;
                                }
                            }
                       }
                        
                    
                }
            
                if(oldMap == null && a.Named_Account__c == true && String.isNotBlank(a.Named_Account_Type__c) && a.Named_Account_Type__c !='Service Source' && a.NAM_SAM_CNAM__c !=null && userMap.get(a.NAM_SAM_CNAM__c) !=null){
                    //SMS-735 Start
                    //members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c, UserId =userMap.get(a.NAM_SAM_CNAM__c).id ));
                    //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.NAM_SAM_CNAM__c).id , AccountId = a.id));
					members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c, UserId =userMap.get(a.NAM_SAM_CNAM__c).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' ));
					//SMS-735 End
                    monitor += userMap.get(a.NAM_SAM_CNAM__c).Name+' with role '+assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c+' and dtn '+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+' created.' +'\r\n';
                    //SMS-734 Start
                    if(userMap.get(a.NAM_SAM_CNAM__c).FirstName!=Null){
                    if(userMap.get(a.NAM_SAM_CNAM__c).FirstName.contains('Territory') && userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c!=null) {
                                            //SMS-735 Start
                                            //members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c), UserId =userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c));
                                            //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c, AccountId = a.id));
                                            members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c), UserId =userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
                                     		//SMS-735 End
                                            monitor += userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c+' with role '+ 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c)+' and dtn '+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+' created.' +'\r\n';
                                        }
                    }
                    //SMS-734 End
                }
                system.debug(oldMap+'===named acc'+a.Named_Account__c+'==names type=='+a.Named_Account_Type__c+'service ===>'+a.Service_Source__c+'user==>'+userMap.get(a.Service_Source__c));
                if(oldMap == null && a.Named_Account__c == true && String.isNotBlank(a.Named_Account_Type__c) && a.Named_Account_Type__c.equals('Service Source') && a.Service_Source__c!=null && userMap.get(a.Service_Source__c) != null){
                    //SMS-735 Start
                    //members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = (UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative'), UserId =userMap.get(a.Service_Source__c).id ));
                    //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.Service_Source__c).id , AccountId = a.id));
                    members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = (UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative'), UserId =userMap.get(a.Service_Source__c).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None' ));
                    //SMS-735 End
                    monitor += userMap.get(a.Service_Source__c).Name+' with role '+(UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative')+' and dtn '+userMap.get(a.Service_Source__c).DTN__c+' created.' +'\r\n';
                    //SMS-734 Start
                    if(userMap.get(a.Service_Source__c).FirstName!=Null){
                       if(userMap.get(a.Service_Source__c).FirstName.contains('Territory') && userMap.get(a.Service_Source__c).Custodial_Rep__c!=null) {
                          //SMS-735 Start
                          //members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c), UserId =userMap.get(a.Service_Source__c).Custodial_Rep__c));
                          //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.Service_Source__c).Custodial_Rep__c, AccountId = a.id));
                          members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c), UserId =userMap.get(a.Service_Source__c).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
                          //SMS-735 End
                          monitor += userMap.get(a.Service_Source__c).Custodial_Rep__c+' with role '+ 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c)+' and dtn '+userMap.get(a.Service_Source__c).DTN__c+' created.' +'\r\n';
                          }
                    }
                    //SMS-734 End
                }
                
                
            
                if(oldMap !=null && 
                oldMap.get(a.id) != null && 
                a.NAM_SAM_CNAM__c !=null && 
                a.Named_Account__c == true &&
                String.isNotBlank(a.Named_Account_Type__c) && 
                a.Named_Account_Type__c !='Service Source' && 
                userMap.get(a.NAM_SAM_CNAM__c) !=null &&
                (a.NAM_SAM_CNAM__c != oldMap.get(a.id).NAM_SAM_CNAM__c ||
                    !availabelATMs.containsKey(a.Id) || !availabelATMs.get(a.Id).containsKey(a.NAM_SAM_CNAM__c))
                ){
                    //SMS-735 Start
                    //members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c, UserId =userMap.get(a.NAM_SAM_CNAM__c).id ));
                    //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.NAM_SAM_CNAM__c).id , AccountId = a.id));
                    members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c, UserId =userMap.get(a.NAM_SAM_CNAM__c).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None'));
  					//SMS-735 End
                    monitor += userMap.get(a.NAM_SAM_CNAM__c).Name+' with role '+assignmentMatrixMap.get(a.Named_Account_Type__c).NAM_SAM_CNAM__c+' and dtn '+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+' created.' +'\r\n';
                    //SMS-734 Start
                    if(userMap.get(a.NAM_SAM_CNAM__c).FirstName!=Null){
                                        if(userMap.get(a.NAM_SAM_CNAM__c).FirstName.contains('Territory') && userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c!=null) {
                                            //SMS-735
                                            //members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c), UserId =userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c));
                                            //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c, AccountId = a.id));
                                            members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c), UserId =userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
                                            //SMS-735
                                            monitor += userMap.get(a.NAM_SAM_CNAM__c).Custodial_Rep__c+' with role '+ 'Cust-'+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.NAM_SAM_CNAM__c)+' and dtn '+userMap.get(a.NAM_SAM_CNAM__c).DTN__c+' created.' +'\r\n';
                                        }
                    }
                    //SMS-734 End
                }
                if(oldMap !=null && 
                oldMap.get(a.id) != null && 
                a.Service_Source__c !=null && 
                a.Named_Account__c == true && 
                String.isNotBlank(a.Named_Account_Type__c) && 
                a.Named_Account_Type__c.equals('Service Source') && 
                userMap.get(a.Service_Source__c) != null && 
                (a.Service_Source__c != oldMap.get(a.id).Service_Source__c ||
                    !availabelATMs.containsKey(a.Id) || !availabelATMs.get(a.Id).containsKey(a.Service_Source__c))){
                    //SMS-735 Start
                    //members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = (UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative'), UserId =userMap.get(a.Service_Source__c).id ));
                    //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.Service_Source__c).id , AccountId = a.id));
                    members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = (UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative'), UserId =userMap.get(a.Service_Source__c).id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None'));
                    //SMS-735 End
                    monitor += userMap.get(a.Service_Source__c).Name+' with role '+(UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c !=null ? UtilCustomSettings.TAACustomSetting().ServiceSourceRole__c : 'Representative')+' and dtn '+userMap.get(a.Service_Source__c).DTN__c+' created.' +'\r\n';
                    //SMS-734 Start
                    if(userMap.get(a.Service_Source__c).FirstName!=Null){
                                        if(userMap.get(a.Service_Source__c).FirstName.contains('Territory') && userMap.get(a.Service_Source__c).Custodial_Rep__c!=null) {
                                            //SMS-735 Start
                                            //members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c), UserId =userMap.get(a.Service_Source__c).Custodial_Rep__c));
                                            //sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(a.Service_Source__c).Custodial_Rep__c, AccountId = a.id));
                                            members.add(new AccountTeamMember(AccountId = a.id,TeamMemberRole = 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c), UserId =userMap.get(a.Service_Source__c).Custodial_Rep__c, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit', CaseAccessLevel = 'None'));
                                            //SMS-735 End
                                            monitor += userMap.get(a.Service_Source__c).Custodial_Rep__c+' with role '+ 'Cust-'+userMap.get(a.Service_Source__c).DTN__c+'-'+availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).get(a.Service_Source__c)+' and dtn '+userMap.get(a.Service_Source__c).DTN__c+' created.' +'\r\n';
                                        }
                    }
                                          //SMS-734 End
                }
                
                try{
                    
                    if(String.isBlank(monitor) && String.isNotBlank(info)){
                       /* if( info.contains('Named account is missing')){
                            system.debug('Inside  No DTN change** ');
                           errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT));
                         }*/
                    
                        if(oldMap != null && a.BillingPostalCode !=null && a.BillingPostalCode.length() >4 && zipCodeMap.containsKey(a.BillingPostalCode.substring(0,5)) &&
                          assignmentMatrixMap.containsKey(keyOfAssignmentMatrix) && 
                             ((a.Named_Account__c && a.Named_Account_Type__c !=null && (String.isNotBlank(a.NAM_SAM_CNAM__c) || String.isNotBlank(a.Service_Source__c))) 
                            || (!a.Named_Account__c && a.Named_Account_Type__c ==null)) &&
                          checkforDTNRoleChange(a, oldMap.get(a.Id))==false){
                           errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_DTN_ROLE_NOT_CHANGED));
                          }
                        else if(a.Named_Account__c || String.isNotBlank(a.Named_Account_Type__c) || info.contains('Named account is missing')){
                           errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM_FOR_NAMED_ACCOUNT));
                        }
                        else{
                         errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_UNABLE_TO_DETERMINE_ACCOUNT_TEAM));
                        }
                    }
                    
                    if(String.isNotBlank(monitor) ){
                        info += monitor;
                        if(a.Named_Account__c || String.isNotBlank(a.Named_Account_Type__c)){
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_TEAM_MEMBER_CREATED_FOR_NAMED_ACCOUNT));
                        }else{
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info, 'assignAccountTeamAndSharingRules', a.id,WK_Exception.ATA_TEAM_MEMBER_CREATED));
                        }
                    }   
                }catch(WK_Exception e){
                    Monitoring_Log__c m = new Monitoring_Log__c();
                    m.Name = 'Account automation';
                    m.Account__c = a.id;
                    m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                    m.Type__c = WK_Exception.ATA_CODE_ERROR;
                    errorRecordslist.add(m);
                }
            }else{ // sms 500 Start 
                if(oldMap == null){
                     info += checkChangesOnAccount(a,null);
                }else{
                    info += checkChangesOnAccount(a,oldMap.get(a.id));
                }
                if(a.BillingPostalCode == null){
                    errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info , 'assignAccountTeamAndSharingRules',a.id,WK_Exception.ATA_MISSING_POSTALCODE));
                }
                else if(a.BillingPostalCode != null && (a.Market_Segment__c == null || a.Market_Sub_Segment__c == null)){
                    errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',info , 'assignAccountTeamAndSharingRules',a.id,WK_Exception.ATA_EXCEPTION_MISSING_FIELD));
                }
                // sms 500 Start 
             }
           }
        }
        //insert account Team Member if any
        if(members.size()>0){
            Database.SaveResult[] memberslst = Database.insert(members,false);
            //if(!Test.isRunningTest()){
                for(Integer i=0 ; i<memberslst.size(); i++){
                    if(!memberslst.get(i).isSuccess()){
                        String errorMsg = '';
                        String accID = members.get(i).AccountId;
                        for(Database.Error err : memberslst.get(i).getErrors()){
                            //errorRecordslist.add(LoggerUtil.createErrorRecord(String className, String methodName, String));
                            errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while creating accountTeamMember'+'\n';
                        }
                        try{
                            
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',errorMsg , 'assignAccountTeamAndSharingRules', accID,WK_Exception.ATA_TEAM_MEMBER_NOT_CREATED));
                        }catch(WK_Exception e){
                            Monitoring_Log__c m = new Monitoring_Log__c();
                            m.Name = 'Account automation';
                            m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                            m.Type__c = WK_Exception.ATA_CODE_ERROR;
                            errorRecordslist.add(m);
                        }
                    }
                }
            //}
        }
        /*SMS-735 Start
        //insert sharing Rules if any
        if(sharingRules.size()>0){
            
            Database.SaveResult[] sharingRuleslst = Database.insert(sharingRules,false);
            //if(!Test.isRunningTest()){
                for(Integer i=0 ; i<sharingRuleslst.size(); i++){
                    if(!sharingRuleslst.get(i).isSuccess()){
                        String errorMsg = '';
                        String accID = sharingRules.get(i).AccountId;
                        for(Database.Error err : sharingRuleslst.get(i).getErrors()){
                            //errorRecordslist.add(LoggerUtil.createErrorRecord(String className, String methodName, String));
                            errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while creating sharing rules'+'\n';
                        }
                        try{
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',errorMsg , 'assignAccountTeamAndSharingRules', accID,WK_Exception.ATA_SHARING_RULES_NOT_CREATED));
                        }catch(WK_Exception e){
                            Monitoring_Log__c m = new Monitoring_Log__c();
                            m.Name = 'Account automation';
                            m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                            m.Type__c = WK_Exception.ATA_CODE_ERROR;
                            errorRecordslist.add(m);
                        }
                    }
                }
            //}
        } SMS-735 End*/
        //update account team members role
        if(updateabelTeamMembers.size() >0){
            Database.SaveResult [] updateroles = Database.update(updateabelTeamMembers, false);
            for(Integer i=0 ; i<updateroles.size(); i++){
                if(!updateroles.get(i).isSuccess()){
                    String errorMsg = '';
                    String accID = updateabelTeamMembers.get(i).AccountId;
                    for(Database.Error err : updateroles.get(i).getErrors()){
                        //errorRecordslist.add(LoggerUtil.createErrorRecord(String className, String methodName, String));
                        errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while updating role'+'\n';
                    }
                    try{
                        errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',errorMsg , 'assignAccountTeamAndSharingRules', accID,WK_Exception.ATA_SHARING_RULES_NOT_CREATED));
                    }catch(WK_Exception e){
                        Monitoring_Log__c m = new Monitoring_Log__c();
                        m.Name = 'Account automation';
                        m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                        m.Type__c = WK_Exception.ATA_CODE_ERROR;
                        errorRecordslist.add(m);
                    }
                }
            }
        }
        
        return errorRecordslist;
    }
    
    
    
    /*
    @method: deleteAccountTeamMembers
    @description: method to delete already existing accountTeam member and sharing rules so that updated new can be created 
    @params: list of Accounts and map of accounts
    */
    public map<Id,String> deleteAccountTeamMembers(list<Account>newAccountList,Map<id,Account>oldMap){
        set<id>accountIdsSet = new set<id>();
        list<AccountTeamMember>deleteMembers = new list<AccountTeamMember>();
        list<AccountTeamMember> deleteaPresentMembers = new list<AccountTeamMember>();
        list<AccountShare>deleteSharingRules = new list<AccountShare>();
        list<Monitoring_Log__c> errorRecordslist = new list<Monitoring_Log__c>();
        map<Id,String> monitorLogsMap = new map<Id,String>();
        map<Id,list<AccountTeamMember>> accountWithTeamMember = new map<Id,list<AccountTeamMember>>();
        map<Id,list<String>> accountWithChangedDTN = new map<Id,list<String>>(); 
        
        for(Account a : newAccountList){
             
            if(a.Exclude_Account_Automation__c == false && oldMap != null && a.RecordTypeId !=excludeRecordType && a.Inactive__c == false){
                
              if(a.BillingPostalCode != Null && a.BillingPostalCode.length() >4 &&
               
                    (a.BillingPostalCode !=oldMap.get(a.id).BillingPostalCode               || 
                        a.Market_Segment__c !=oldMap.get(a.id).Market_Segment__c            || 
                        a.Market_Sub_Segment__c !=oldMap.get(a.id).Market_Sub_Segment__c    ||
                        a.Sic != oldMap.get(a.id).Sic                                       ||
                        a.NumberOfEmployees != oldMap.get(a.id).NumberOfEmployees           ||
                        a.AnnualRevenue != oldMap.get(a.id).AnnualRevenue                   ||
                        (a.Named_Account__c && (String.isNotBlank(a.Named_Account_Type__c) && a.Named_Account_Type__c != oldMap.get(a.id).Named_Account_Type__c)) ||
                       a.Named_Account__c!= oldMap.get(a.id).Named_Account__c )
                ){
                   
                    /*if(!a.Named_Account__c && String.isNotBlank(oldMap.get(a.Id).NAM_SAM_CNAM__c ) && (String.isBlank(a.NAM_SAM_CNAM__c) || oldMap.get(a.Id).NAM_SAM_CNAM__c  !=a.NAM_SAM_CNAM__c)){
                        deleteMembers.add(availabelATMs.get(a.Id).get(oldMap.get(a.Id).NAM_SAM_CNAM__c) );
                        
                    }*/ 
                    
                    if((String.isNotBlank(oldMap.get(a.Id).NAM_SAM_CNAM__c)) && (a.NAM_SAM_CNAM__c!=oldMap.get(a.Id).NAM_SAM_CNAM__c)){
                        deleteMembers.add(availabelATMs.get(a.Id).get(oldMap.get(a.Id).NAM_SAM_CNAM__c));
                    }
                    
                   /* if(!a.Named_Account__c && String.isNotBlank(oldMap.get(a.Id).Service_Source__c ) && (String.isBlank(a.Service_Source__c) || oldMap.get(a.Id).Service_Source__c  !=a.Service_Source__c)){
                       
                        deleteMembers.add(availabelATMs.get(a.Id).get(oldMap.get(a.Id).Service_Source__c) );
                        
                    }*/
                    
                    if((String.isNotBlank(oldMap.get(a.Id).Service_Source__c)) && (a.Service_Source__c!=oldMap.get(a.Id).Service_Source__c)){
                        deleteMembers.add(availabelATMs.get(a.Id).get(oldMap.get(a.Id).Service_Source__c));
                    }
                    
                    /* Commented below line for fixing SMS-475*/
                    
                    //deleteMembers.addAll(createDtnSetToDeleteATMs(oldMap.get(a.id),a));
                   
                    
                   /* Fix for defect SMS-470 -start*/
                   
                     String removeRLASR;
                     if(oldMap.get(a.Id).Id!=null &&  a!=null && availabelATMs.containsKey(oldMap.get(a.Id).Id) ){
                         
                         String newKeyOfAssignmentMatrix;
                         
                         if(a.Market_Segment__c==null || a.Market_Sub_Segment__c==null){
                            newKeyOfAssignmentMatrix=oldMap.get(a.Id).Market_Segment__c+'_'+oldMap.get(a.Id).Market_Sub_Segment__c;
                         }
                         else{
                            newKeyOfAssignmentMatrix = getAssignmentMatrixKey(a);
                         }
                         
                         String oldKeyOfAssignmentMatrix = getAssignmentMatrixKey(oldMap.get(a.Id));
                         Set<String>newDTNs = new Set<String>();
                         if(availabelZipAMWithDtnToRole.containsKey(a.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix)){
                            newDTNs = availabelZipAMWithDtnToRole.get(a.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).keySet().clone();
                         }
                        
                        if(a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c) && a.Named_Account_Type__c.equals('Service Source')
                        && zipCodeMap.get(a.BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                         
                         
                         removeRLASR = zipCodeMap.get(a.BillingPostalCode.substring(0,5)).R_L_ASR__c;
                        if(newDTNs.contains(removeRLASR)){
                           newDTNs.remove(removeRLASR); 
      
                        }
                      }
                      
                      if(a.Named_Account__c && String.isNotBlank(a.Named_Account_Type__c) && !a.Named_Account_Type__c.equals('Service Source')){
                         
                       if(String.isNotBlank(a.NAM_SAM_CNAM__c)){
                         
                         newDTNs.add(a.NAM_SAM_CNAM__c);
                       }
                     }
                   
                    
                 set<String>oldDTNs = new set<String>();
                 
                  if(String.isNotBlank(oldMap.get(a.Id).BillingPostalCode) && availabelOldZipAMWithDtnToRole.containsKey(oldMap.get(a.Id).BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix)){
                   
                   oldDTNs = availabelOldZipAMWithDtnToRole.get(oldMap.get(a.Id).BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix).keySet().clone();
                   
                  }
                  
                 if(oldMap.get(a.Id).Named_Account__c && String.isNotBlank(oldMap.get(a.Id).Named_Account_Type__c) && oldMap.get(a.Id).Named_Account_Type__c.equals('Service Source') && String.isNotBlank(oldMap.get(a.Id).BillingPostalCode)
                  && zipCodeMap.get(oldMap.get(a.Id).BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                     
                  removeRLASR = zipCodeMap.get(oldMap.get(a.Id).BillingPostalCode.substring(0,5)).R_L_ASR__c;
                  if(oldDTNs.contains(removeRLASR)){
                    
                    oldDTNs.remove(removeRLASR);
                  }
                }
             
                   oldDTNs.removeAll(newDTNs);  
               
              
               if(oldDTNs.size()>0){
                   for(String s:oldDTNs){
                    if(availabelATMs.get(oldMap.get(a.Id).Id).get(s)!=null){
                      deleteMembers.add(availabelATMs.get(oldMap.get(a.Id).Id).get(s));
                      
                     }
                   }
                }     
             }
             
             
             
                 
          

        }
        /* Usha Fix for defect SMS-505 - start */
      /*  if(a.BillingPostalCode == null && oldMap.get(a.Id).BillingPostalCode!=null){
            String oldKeyOfAssignmentMatrix = getAssignmentMatrixKey(oldMap.get(a.Id));
            set<String>oldDTNs = availabelOldZipAMWithDtnToRole.get(oldMap.get(a.Id).BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix).keySet().clone();
            if(oldDTNs.size()>0){
                   for(String s:oldDTNs){
                    if(availabelATMs.get(oldMap.get(a.Id).Id).get(s)!=null){
                      deleteMembers.add(availabelATMs.get(oldMap.get(a.Id).Id).get(s));
                      
                     }
                   }
             }
         }  */ 
        /* Usha Fix for defect SMS-505 - End */
           
        }else if(availabelATMs.size()>0 && oldMap==null){
            deleteMembers.addAll(createDtnSetToDeleteATMs(a,a));
           }
        }
        
         //End of creation of list of account team member to be deleted.   
          
            if(deleteMembers.size()>0){
              for(AccountTeamMember a :deleteMembers){
                String monitor = '';
                //system.debug(loggingLevel.Error,'--I am inside delete 2---'+a);
                try{
                    if(monitorLogsMap.containsKey(a.accountId)){
                        monitor += monitorLogsMap.get(a.accountId)+'\r\n'+
                            a.User.Name+' with role '+a.TeamMemberRole+' and dtn '+a.User.DTN__c+' deleted.' +'\r\n';
                            monitorLogsMap.put(a.accountId, monitor);
                    }else{
                        monitor += a.User.Name+' with role '+a.TeamMemberRole+' and dtn '+a.User.DTN__c+' deleted.'+'\r\n';
                        monitorLogsMap.put(a.accountId, monitor);
                    }
                    
                    errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',a.User.Name+':deleted on'+' '+a.account.Name+'::'+a.accountId , 'deleteAccountTeamMembers', a.accountId,null));
                    
                }catch(WK_Exception e){
                    
                    Monitoring_Log__c m = new Monitoring_Log__c();
                    m.Account__c = a.accountId;
                    m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                    m.Type__c = WK_Exception.ATA_CODE_ERROR;
                    errorRecordslist.add(m);
                }
              }
            }
        
        
        //delete team members if any
        if(deleteMembers.size()>0){
            Database.DeleteResult[] sharingRuleslst = Database.delete(deleteMembers,false);
            //if(!Test.isRunningTest()){
                for(Database.DeleteResult sr : sharingRuleslst){
                    if(!sr.isSuccess()){
                        String errorMsg = '';
                        for(Database.Error err : sr.getErrors()){
                            errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while deleting TeamMembers'+'\n';
                        }
                        try{
                        errorRecordslist.add(LoggerUtil.createErrorRecord('AccountTriggerHandler', 'DTNStampingAccountTriggerHandler', 'onAfter', errorMsg));
                        }catch(WK_Exception e){
                            Monitoring_Log__c m = new Monitoring_Log__c();
                            m.Name = 'Account automation';
                            m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                            m.Type__c = WK_Exception.ATA_CODE_ERROR;
                            errorRecordslist.add(m);
                        }
                    }
                }
           // }
        }
        
        return monitorLogsMap;
    }
    
    /*
    @method: assignDTNToDTNFieldsOnAccount
    @description: method to stamp dtn to corresponding dtn fields on accounts
    @params: list of accounts and map of accounts
    */
    public void assignDTNToDTNFieldsOnAccount(list<Account>newAccountList,Map<id,Account>oldMap){
        system.debug('Inside assignDTNToDTNFieldsOnAccount****');
        for(Account acc : newAccountList){
            if(acc.Exclude_Account_Automation__c == false  && acc.RecordTypeId !=excludeRecordType && acc.Inactive__c == false){
            if(String.isNotBlank(acc.BillingPostalCode) && acc.BillingPostalCode.length() >4 && acc.Inactive__c==false){
                    system.debug('Inside BillingStreet****');
                                        
                    if(oldMap ==Null || acc.BillingPostalCode !=oldMap.get(acc.id).BillingPostalCode || 
                        acc.Market_Segment__c !=oldMap.get(acc.id).Market_Segment__c || 
                        acc.Market_Sub_Segment__c !=oldMap.get(acc.id).Market_Sub_Segment__c ||
                        acc.Sic != oldMap.get(acc.id).Sic ||
                        acc.NumberOfEmployees != oldMap.get(acc.id).NumberOfEmployees ||
                        acc.AnnualRevenue != oldMap.get(acc.id).AnnualRevenue ||
                        acc.Name!=oldMap.get(acc.id).Name||
                        (acc.Named_Account__c && 
                            (String.isNotBlank(acc.Named_Account_Type__c) 
                            && acc.Named_Account_Type__c != oldMap.get(acc.id).Named_Account_Type__c)) ||
                        acc.Named_Account__c!=oldMap.get(acc.id).Named_Account__c){
                       
                        String zip = acc.BillingPostalCode.substring(0,5);
                        String keyOfAssignmentMatrix = getAssignmentMatrixKey(acc);
                        if(acc.Named_Account__c == true && acc.Named_Account_Type__c != null  && acc.Market_Segment__c!=null && acc.Market_Sub_Segment__c!=null ){
                          
                            if(acc.Named_Account_Type__c.equals('National')){
                                    
                                if(nationalAccountMap.containsKey(acc.Name)){
                                    
                                    acc.NAM_SAM_CNAM__c = nationalAccountMap.get(acc.Name).DTN__c;
                                    acc.Service_Source__c = null;
                                    
                                }
                            }
                            if(acc.Named_Account_Type__c.equals('Strategic')){
                                if(stratgiecAccountMap.containsKey(acc.Name)){
                                   acc.NAM_SAM_CNAM__c = stratgiecAccountMap.get(acc.Name).DTN__c;
                                   acc.Service_Source__c = null;
                                }
                            }
                            if(acc.Named_Account_Type__c.equals('Corporate National')){
                                if(corNationalMap.containsKey(acc.Name)){
                                    acc.NAM_SAM_CNAM__c = corNationalMap.get(acc.Name).DTN__c;
                                    acc.Service_Source__c = null;

                                }
                            }
                            
                           // system.debug(loggingLevel.Error,'-------test for service source value------3.1::'+zipCodeMap.get(zip).Service_Source__c);
                            if(acc.Named_Account_Type__c.equals('Service Source')){
                               
                                if(zipCodeMap.containsKey(zip) && String.isNotBlank(zipCodeMap.get(zip).Service_Source__c) ){
                                    acc.Service_Source__c = zipCodeMap.get(zip).Service_Source__c;
                                    
                                }
                                acc.NAM_SAM_CNAM__c = null;
                            }
                            }else if(oldMap !=null && oldMap.containsKey(acc.Id) && oldMap.get(acc.Id).Named_Account__c && oldMap.get(acc.Id).Named_Account_Type__c !=null){
                                if(acc.Named_Account__c ==false || acc.Named_Account_Type__c ==null){
                                    if(oldMap.get(acc.Id).Service_Source__c !=null){
                                        
                                          acc.Service_Source__c= null;
                                    }
                                    if(oldMap.get(acc.Id).NAM_SAM_CNAM__c !=null){
                                        
                                        //acc.NAM_SAM_CNAM__c = oldMap.get(acc.Id).NAM_SAM_CNAM__c;
                                        acc.NAM_SAM_CNAM__c =null;
                                    }
                                }
                          }else{
                          acc.NAM_SAM_CNAM__c = null;
                          acc.Service_Source__c = null;
                        }
                        //Assign dtn to corresponding dtn fields on Account
                        
                        assignDtnToAccountDtnFields(acc);
                       
                    }
                }
                
                if(acc.Named_Account__c == true && String.isBlank(acc.BillingPostalCode)){
                    
                    blankCorrespondingDtnFields(acc);
                    if(acc.Named_Account__c == true && acc.Named_Account_Type__c != null ){
                        
                            if(acc.Named_Account_Type__c.equals('National')){
                                if(nationalAccountMap.containsKey(acc.Name)){
                                    acc.NAM_SAM_CNAM__c = nationalAccountMap.get(acc.Name).DTN__c;
                                }
                            }
                            if(acc.Named_Account_Type__c.equals('Strategic')){
                                if(stratgiecAccountMap.containsKey(acc.Name)){
                                   acc.NAM_SAM_CNAM__c = stratgiecAccountMap.get(acc.Name).DTN__c;
                                }
                            }
                            if(acc.Named_Account_Type__c.equals('Corporate National')){
                                if(corNationalMap.containsKey(acc.Name)){
                                    acc.NAM_SAM_CNAM__c = corNationalMap.get(acc.Name).DTN__c;
                                }
                             }
                            
                        }
                    }
                    /* Fix for defect SMS-505 - START*/
                     // added by anjali for 505 2nd issue
                   /* if(acc.Named_Account__c == false && String.isBlank(acc.BillingPostalCode)){
                         blankCorrespondingDtnFields(acc);
                         acc.NAM_SAM_CNAM__c = null;
                    }*/
                    
                    /* Fix for defect SMS-505 -END*/
                    
               }
           }
        
        
    } // end of assignDTNToDTNFieldsOnAccount method
    
    /*
    @method: dtnMakeupString
    @description: method to create string for DTN makeup field
    @params: set of Strings
    */
    @testVisible
    private String dtnMakeupString(set<String>dtnMakeup){
        String dtn = '';
        list<String> dtnlist = new list<String>(dtnMakeup);
        for(String s : dtnlist){
            dtn += s+',';
        }
        dtn =dtn.removeEnd(',');
        return dtn;
    }
    
    /*
    @method:    
    @description: method to return dtn with role and will be called in constructor
    @params: list of accounts
    */
    
    
    /*
    @method:    
    @description: method to return dtn with role and will be called in constructor
    @params: list of accounts
    */
    @TestVisible
    private map<String,map<String,String>> assignZipAMWithDtnToRole(list<Account>newAccountList){
        map<String,map<String,String>>assignZipAMWithDtnToRole = new map<String,map<String,String>>();
        AccountTriggerHandler handler = new AccountTriggerHandler();
        handler.onBeforeInsert(newAccountList);
        for(Account acc : newAccountList){
            String zip;
            if(acc.BillingPostalCode !=null && acc.BillingPostalCode.length() >4){
                zip = acc.BillingPostalCode.substring(0,5);
            }
            
            String keyOfAssignmentMatrix = '';
            if(getAssignmentMatrixKey(acc) !=null){
                keyOfAssignmentMatrix = getAssignmentMatrixKey(acc);
                
            }
            
            if(String.isNotBlank(zip) 
                && String.isNotBlank(keyOfAssignmentMatrix) 
                && zipCodeMap.containsKey(zip) 
                && (assignmentMatrixMap.containsKey(keyOfAssignmentMatrix))){
                    
                assignZipAMWithDtnToRole.putAll(filterZipAMWithDtnToRole(keyOfAssignmentMatrix, zip));
            }
        }
        
        
        return assignZipAMWithDtnToRole;
    }
    
    /*
    @method:    
    @description: method to return dtn with role and will be called in constructor
    @params: list of accounts
    */
    @TestVisible
    private map<String,map<String,String>> assignOldZipAMWithDtnToRole(list<Account>oldAccountList){
        map<String,map<String,String>>assignZipAMWithDtnToRole = new map<String,map<String,String>>();
        
        for(Account acc : oldAccountList){
            String zip;
            if(acc.BillingPostalCode !=null && acc.BillingPostalCode.length() >4){
                zip = acc.BillingPostalCode.substring(0,5);
            }
            String keyOfAssignmentMatrix = '';
            if(getAssignmentMatrixKey(acc) !=null){
                keyOfAssignmentMatrix = getAssignmentMatrixKey(acc);
            }
            
           
            if(String.isNotBlank(zip) 
                && String.isNotBlank(keyOfAssignmentMatrix) 
                && zipCodeMap.containsKey(zip) 
                && assignmentMatrixMap.containsKey(keyOfAssignmentMatrix)){
                    
                assignZipAMWithDtnToRole.putAll(filterZipAMWithDtnToRole(keyOfAssignmentMatrix, zip));
            }
        }
        system.debug(loggingLevel.Error,'-----------------inside assignOldZipAMWithDtnToRole last -----------'+assignZipAMWithDtnToRole);
        return assignZipAMWithDtnToRole;
    }
    //method will create set of dtn to create account teammembers
    /*
    @method: createDtnSetToCreateATMs
    @description: method will create set of dtns to for teammembers creation on the basis of Corresponding fields on Account
    @params: old Account value and new Account value
    */
    @TestVisible
    private Set<String> createDtnSetToCreateATMs(Account newValue, Account oldValue){
        Set<String>dtnSet = new Set<String>();
        String keyOfAssignmentMatrix = getAssignmentMatrixKey(newValue);
        String removeRLASR ;
        //remove dtn of R_L_ASR for service source 
        if(String.isNotBlank(newValue.BillingPostalCode) && newValue.BillingPostalCode.length() >4 && String.isNotBlank(keyOfAssignmentMatrix)
            && availabelZipAMWithDtnToRole.containskey(newValue.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix)){
            if(String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source')){
                removeRLASR = zipCodeMap.get(newValue.BillingPostalCode.substring(0,5)).R_L_ASR__c;
            }
            if(oldValue !=null ){
                list<String> newDtns = new list<String>(availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).keySet());
                for(String s : newDtns){
                    if(!availabelATMs.containsKey(newValue.Id) ||
                        (availabelATMs.containsKey(newValue.Id) && 
                        !availabelATMs.get(newValue.Id).containsKey(s))){
                        dtnSet.add(s);
                    }
                }
                /*End of new logic*/
                
            }else{
               dtnSet=availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+keyOfAssignmentMatrix).keySet();
            }
        }
        if(String.isNotBlank(removeRLASR) && dtnSet.contains(removeRLASR)){
            dtnSet.remove(removeRLASR);
        }
        return dtnSet;
    }
    
    //method will create list of account teammembers to delete 
    /*
    @method: createDtnSetToDeleteATMs
    @description: method will create set of dtns for teammembers deletion on the basis of Corresponding fields on Account
    @params: old Account value and new Account value
    */
    private list<AccountTeamMember> createDtnSetToDeleteATMs(Account oldValue, Account newValue){
        list<AccountTeamMember>deleteableAtms = new list<AccountTeamMember>();
        String newKeyOfAssignmentMatrix;
        String removeRLASR;
        if(newValue !=null){
          newKeyOfAssignmentMatrix = getAssignmentMatrixKey(newValue);
        }
        
        if(oldValue !=null && String.isNotBlank(newKeyOfAssignmentMatrix) && String.isNotBlank(oldValue.BillingPostalCode) && oldValue.BillingPostalCode.length() >4 && 
           availabelATMs.containsKey(oldValue.Id) && availabelZipAMWithDtnToRole.containsKey(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix)){
            String oldKeyOfAssignmentMatrix = getAssignmentMatrixKey(oldValue);
            Set<String>newDTNs = new Set<String>();
            Set<String>newRoles = new Set<String>();
            if(String.isNotBlank(newKeyOfAssignmentMatrix)){
              newDTNs = availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).keySet();
              
              newRoles.addAll(availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).values());
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c)&& newValue.NAM_SAM_CNAM__c!= null && assignmentMatrixMap.containsKey(newValue.Named_Account_Type__c)){
                newRoles.add(assignmentMatrixMap.get(newValue.Named_Account_Type__c).NAM_SAM_CNAM__c);
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source')
              && zipCodeMap.get(newValue.BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                  system.debug(loggingLevel.Error,'----------------checking value in update method---11-'+newValue.Named_Account__c);
                removeRLASR = zipCodeMap.get(newValue.BillingPostalCode.substring(0,5)).R_L_ASR__c;
                
                if(newDTNs.contains(removeRLASR)){
                    newDTNs.remove(removeRLASR);
                }
                
            }
            
            set<String> oldDTNs = new set<String>();
            if(String.isNotBlank(oldKeyOfAssignmentMatrix) && 
               availabelOldZipAMWithDtnToRole.containsKey(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix)){
              oldDTNs.addAll(availabelOldZipAMWithDtnToRole.get(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix).keySet());
            }
            if(oldValue.Named_Account__c && String.isNotBlank(oldValue.Named_Account_Type__c) && oldValue.Named_Account_Type__c.equals('Service Source')
              && zipCodeMap.get(oldValue.BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                removeRLASR = zipCodeMap.get(oldValue.BillingPostalCode.substring(0,5)).R_L_ASR__c;
                if(oldDTNs.contains(removeRLASR)){
                    oldDTNs.remove(removeRLASR);
                }
            }
           
          if(availabelATMs.containsKey(oldValue.Id) && !oldDTNs.isEmpty() && oldDTNs.size()>0){
              
            for(String s : new list<String>(availabelATMs.get(oldValue.Id).keySet())){
                
              if(oldDTNs.contains(s) && (newDTNs.isEmpty() || !newDTNs.contains(s)) && !((availabelATMs.get(oldValue.Id).get(s)).User.Name.contains('Territory'))) {
                deleteableAtms.add(availabelATMs.get(oldValue.Id).get(s));
              }
              
              if(!oldDTNs.contains(s) && (newDTNs.isEmpty() || !newDTNs.contains(s)) && !((availabelATMs.get(oldValue.Id).get(s)).User.Name.contains('Territory'))){
                  
                if(!newRoles.isEmpty() && newRoles.contains(availabelATMs.get(oldValue.Id).get(s).TeamMemberRole)){
                  deleteableAtms.add(availabelATMs.get(oldValue.Id).get(s));
                  
                }
              }
            }
            
          }
        }
            
        return deleteableAtms;
    }
    
    /*
    @method: atmsToBeUpdatedForRole
    @description: method will update the role of existing account team members on Account
    @params: new Account, old Account
    */
    private ATMSWithStatus atmsToBeUpdatedForRole(Account oldValue, Account newValue){
        ATMSWithStatus aws = new ATMSWithStatus();
        aws.atmsupdatedWithRole = new list<AccountTeamMember>();
        String status = '';
        
        if(oldValue !=null && newValue !=null && availabelATMs.containsKey(oldValue.Id) ){
            String newKeyOfAssignmentMatrix = getAssignmentMatrixKey(newValue);
            String oldKeyOfAssignmentMatrix = getAssignmentMatrixKey(oldValue);
            Set<String>newDTNs;
            if(availabelZipAMWithDtnToRole.containsKey(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix)){
                newDTNs = availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).keySet();                
            }
            
            list<String>oldDTNs ;
            if(String.isNotBlank(oldValue.BillingPostalCode)&& availabelOldZipAMWithDtnToRole.containsKey(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix)){
                oldDTNs = new list<String>(availabelOldZipAMWithDtnToRole.get(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix).keySet());
            }
           
            if(oldDTNs != null && oldDTNs.size()>0 && newDTNs !=null && newDTNs.size()>0){
                for(String s : oldDTNs){
                    
                    if(newDTNs.contains(s) &&
                        availabelATMs.containsKey(oldValue.Id) && 
                        availabelATMs.get(oldValue.Id).containsKey(s) &&
                        (availabelZipAMWithDtnToRole.containsKey(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix) &&
                         availabelATMs.get(oldValue.Id).get(s).TeamMemberRole != availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).get(s)) &&
                        !(availabelATMs.get(oldValue.Id).get(s).TeamMemberRole.startsWithIgnoreCase('C-') ||
                        availabelATMs.get(oldValue.Id).get(s).TeamMemberRole.startsWithIgnoreCase('Cust-'))
                        ){
                            availabelATMs.get(oldValue.Id).get(s).TeamMemberRole = availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).get(s);
                            aws.atmsupdatedWithRole.add(availabelATMs.get(oldValue.Id).get(s));
                            status += s+' is updated with new role: '+ availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).get(s) +'\r\n';
                    }
                }
                aws.status = status;
            }
        }
        return aws;
    }
    
        
    /*
    @method: checkforDTNRoleChange
    @description: method will check if there is change on role and dtns on account
    @params: new Account, old Account
    */
    private Boolean checkforDTNRoleChange(Account newValue, Account oldValue){
        
        Boolean changeOnDTNOrRole = false;
        String removeRLASR;
        if(oldValue !=null && newValue !=null && availabelATMs.containsKey(oldValue.Id) ){
            
            
            String newKeyOfAssignmentMatrix = getAssignmentMatrixKey(newValue);
            String oldKeyOfAssignmentMatrix = getAssignmentMatrixKey(oldValue);
            
            //instance of new DTN
            Set<String>newDTNs = new Set<String>();
            
            //ANJALI added newValue.BillingPostalCode !=null) condition
            if(newValue.BillingPostalCode !=null){
                if(availabelZipAMWithDtnToRole.containsKey(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix)){
                    
                    newDTNs = availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).keySet().clone();                
                }
            }
            
            //ANJALI added newValue.BillingPostalCode !=null) condition
            if(newValue.BillingPostalCode !=null){
                if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source')
                  && zipCodeMap.get(newValue.BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                       
                    removeRLASR = zipCodeMap.get(newValue.BillingPostalCode.substring(0,5)).R_L_ASR__c;
                    if(newDTNs.contains(removeRLASR)){
                        newDTNs.remove(removeRLASR);
                    }
                }
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && !newValue.Named_Account_Type__c.equals('Service Source')){
                 
                if(String.isNotBlank(newValue.NAM_SAM_CNAM__c)){
                    newDTNs.add(newValue.NAM_SAM_CNAM__c);
                }
            }
           
           //ANJALI added instance of old DTN
            set<String>oldDTNs = new set<String>();
            if(String.isNotBlank(oldValue.BillingPostalCode) && availabelOldZipAMWithDtnToRole.containsKey(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix)){
                 
                oldDTNs = availabelOldZipAMWithDtnToRole.get(oldValue.BillingPostalCode.substring(0,5)+'_'+oldKeyOfAssignmentMatrix).keySet().clone();
            }
            if(oldValue.Named_Account__c && String.isNotBlank(oldValue.Named_Account_Type__c) && oldValue.Named_Account_Type__c.equals('Service Source') && String.isNotBlank(oldValue.BillingPostalCode)
              && zipCodeMap.get(oldValue.BillingPostalCode.substring(0,5)).R_L_ASR__c != null){
                removeRLASR = zipCodeMap.get(oldValue.BillingPostalCode.substring(0,5)).R_L_ASR__c;
                 
                if(oldDTNs.contains(removeRLASR)){
                    oldDTNs.remove(removeRLASR);
                }
            }
            
            if(oldValue.Named_Account__c && String.isNotBlank(oldValue.Named_Account_Type__c) && !oldValue.Named_Account_Type__c.equals('Service Source')){
               
                if(String.isNotBlank(oldValue.NAM_SAM_CNAM__c)){
                    
                    oldDTNs.add(oldValue.NAM_SAM_CNAM__c);
                }
            }
            
            
            if(oldDTNs != null && oldDTNs.size()>0 && newDTNs !=null && newDTNs.size()>0 && !oldDTNs.equals(newDTNs)){
              
                changeOnDTNOrRole = true;
            }
          
            if(oldDTNs != null && oldDTNs.size()>0 && newDTNs !=null && newDTNs.size()>0 && oldDTNs.equals(newDTNs)){
                
                for(String s : new list<String>(oldDTNs)){
                   
                   
                    if( availabelATMs.containsKey(oldValue.Id) && 
                        availabelATMs.get(oldValue.Id).containsKey(s) &&
                        (availabelZipAMWithDtnToRole.containsKey(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix) &&
                         availabelATMs.get(oldValue.Id).get(s).TeamMemberRole != availabelZipAMWithDtnToRole.get(newValue.BillingPostalCode.substring(0,5)+'_'+newKeyOfAssignmentMatrix).get(s)) &&
                        !(availabelATMs.get(oldValue.Id).get(s).TeamMemberRole.startsWithIgnoreCase('C-') ||
                        availabelATMs.get(oldValue.Id).get(s).TeamMemberRole.startsWithIgnoreCase('Cust-')) && (!newValue.Named_Account__c)
                        ){
                           
                            changeOnDTNOrRole=true;
                    }
                }
            }
        }
        
        return changeOnDTNOrRole;
    }
    
    /*
  inner class to return account team members to be updated as well as string for status update
  */
    public class ATMSWithStatus{
        public String status                 {get;set;}
        public list<AccountTeamMember> atmsupdatedWithRole  {get;set;}
    }
    
    //method will create set of dtn
    /*
    @method: createDtnSet
    @description: method will create set of dtn on the basis of Corresponding fields on Account
    @params: Account
    */
    @TestVisible
    private Set<String> createDtnSet(Account newValue, Account oldValue){
        Set<String>dtnSet = new Set<String>();
        
        if(oldValue !=null){
            
            
            if(String.isNotBlank(newValue.AISR__c) && (String.isBlank(oldValue.AISR__c) || newValue.AISR__c !=oldValue.AISR__c)){
                dtnSet.add(newValue.AISR__c);
            }
            if(String.isNotBlank(newValue.Corp_Direct__c) && (String.isEmpty(oldValue.Corp_Direct__c) || newValue.Corp_Direct__c !=oldValue.Corp_Direct__c)){
                dtnSet.add(newValue.Corp_Direct__c);
            }
            if(String.isNotBlank(newValue.Corp_Indirect__c) && (String.isBlank(oldValue.Corp_Indirect__c) || newValue.Corp_Indirect__c !=oldValue.Corp_Indirect__c)){
                dtnSet.add(newValue.Corp_Indirect__c);
            }
            if(String.isNotBlank(newValue.Inside_Sales__c) && (String.isBlank(oldValue.Inside_Sales__c) || newValue.Inside_Sales__c !=oldValue.Inside_Sales__c)){
                dtnSet.add(newValue.Inside_Sales__c);
            }
            if(String.isNotBlank(newValue.ISR_Indirect__c) && (String.isBlank(oldValue.ISR_Indirect__c) || newValue.ISR_Indirect__c !=oldValue.ISR_Indirect__c)){
                dtnSet.add(newValue.ISR_Indirect__c);
            }
            
            if(String.isNotBlank(newValue.NAM_SAM_CNAM__c) && (String.isBlank(oldValue.NAM_SAM_CNAM__c) || newValue.NAM_SAM_CNAM__c !=oldValue.NAM_SAM_CNAM__c)){
                
                dtnSet.add(newValue.NAM_SAM_CNAM__c);
            }
            if(String.isNotBlank(newValue.Pro_SW_FSR__c) && (String.isBlank(oldValue.Pro_SW_FSR__c) || newValue.Pro_SW_FSR__c !=oldValue.Pro_SW_FSR__c)){
                dtnSet.add(newValue.Pro_SW_FSR__c);
            }
            if(String.isNotBlank(newValue.QP__c) && (String.isBlank(oldValue.QP__c) || newValue.QP__c !=oldValue.QP__c)){
                dtnSet.add(newValue.QP__c);
            }
            if(String.isNotBlank(newValue.R_L_ASR__c) && (String.isBlank(oldValue.R_L_ASR__c) || newValue.R_L_ASR__c !=oldValue.R_L_ASR__c)){
                dtnSet.add(newValue.R_L_ASR__c);
            }
            if(String.isNotBlank(newValue.R_L_FSR__c) && (String.isBlank(oldValue.R_L_FSR__c) || newValue.R_L_FSR__c !=oldValue.R_L_FSR__c)){
                dtnSet.add(newValue.R_L_FSR__c);
            }
            if(String.isNotBlank(newValue.SW_ASR__c) && (String.isBlank(oldValue.SW_ASR__c) || newValue.SW_ASR__c !=oldValue.SW_ASR__c)){
                dtnSet.add(newValue.SW_ASR__c);
            }
        }else{
            if(String.isNotBlank(newValue.AISR__c)){
                dtnSet.add(newValue.AISR__c);
            }
            if(String.isNotBlank(newValue.Corp_Direct__c)){
                dtnSet.add(newValue.Corp_Direct__c);
            }
            if(String.isNotBlank(newValue.Corp_Indirect__c)){
                dtnSet.add(newValue.Corp_Indirect__c);
            }
            if(String.isNotBlank(newValue.Inside_Sales__c)){
                dtnSet.add(newValue.Inside_Sales__c);
            }
            if(String.isNotBlank(newValue.Pro_SW_FSR__c)){
                dtnSet.add(newValue.Pro_SW_FSR__c);
            }
            if(String.isNotBlank(newValue.QP__c)){
                dtnSet.add(newValue.QP__c);
            }
            if(String.isNotBlank(newValue.R_L_ASR__c)){
                dtnSet.add(newValue.R_L_ASR__c);
            }
            if(String.isNotBlank(newValue.R_L_FSR__c)){
                dtnSet.add(newValue.R_L_FSR__c);
            }
            if(String.isNotBlank(newValue.SW_ASR__c)){
                dtnSet.add(newValue.SW_ASR__c);
            }
            if(String.isNotBlank(newValue.ISR_Indirect__c)){
                dtnSet.add(newValue.ISR_Indirect__c);
            }
        }
       
        return dtnSet;
    }
    
    /*
    @method: blankCorrespondingDtnFields
    @description: Method to blank the DTN Corresponding section fields before update 
    @               so that existing value can be removed with null in case field has no value at update time
    @params: Account
    */
    public void blankCorrespondingDtnFields(Account acc){
        acc.AISR__c = null;
        acc.Corp_Direct__c = null;
        acc.Corp_Indirect__c = null;
        acc.Inside_Sales__c = null;
        acc.NAM_SAM_CNAM__c = null;
        acc.Pro_SW_FSR__c = null;
        acc.QP__c = null;
        acc.R_L_ASR__c = null;
        acc.R_L_FSR__c = null;
        acc.SW_ASR__c = null;
        acc.Service_Source__c = null;
        acc.ISR_Indirect__c = null;
        /* Fix for defect SMS-507 - START*/
        acc.R_L_ISC__c = null;
        /* Fix for defect SMS-507 - END*/
    }
    /*
    @method: filterDtnWithRole
    @description: method to filter the dtn with role for fields present on zipcodeDTN to Assignment Matrix
    @params:
    */
   
    
    /*
    @method: filterZipAMWithDtnToRole
    @description: method to filter the zipcode with respect to Assignment Matrix for dtn corresponding to role on zipcodeDTN to Assignment Matrix
    @params:
    */
    private map<String,map<String,String>> filterZipAMWithDtnToRole(String assignmentMatrixMapKey, String zip){
        map<String,map<String,String>>dtnRoleMap = new map<String,map<String,String>>();
         
        if(assignmentMatrixMap.containsKey(assignmentMatrixMapKey) && zipCodeMap.containsKey(zip)){
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).AISR__c != Null && zipCodeMap.get(zip).AISR__c != Null){
                
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).AISR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).AISR__c});
                    
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).AISR__c)){
                    
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).AISR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).AISR__c);
                    
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).ASR_Indirect_Corp_Software__c != Null && zipCodeMap.get(zip).ASR_Indirect_Corp_Software__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).ASR_Indirect_Corp_Software__c => assignmentMatrixMap.get(assignmentMatrixMapKey).ASR_Indirect_Corp_Software__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).AISR__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).ASR_Indirect_Corp_Software__c, assignmentMatrixMap.get(assignmentMatrixMapKey).ASR_Indirect_Corp_Software__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Direct__c != Null && zipCodeMap.get(zip).Corp_Direct__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).Corp_Direct__c => assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Direct__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).Corp_Direct__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).Corp_Direct__c, assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Direct__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Indirect__c != Null && zipCodeMap.get(zip).Corp_Indirect__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).Corp_Indirect__c => assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Indirect__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).Corp_Indirect__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).Corp_Indirect__c, assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Indirect__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).ISR_Indirect__c != Null && zipCodeMap.get(zip).ISR_Indirect__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).ISR_Indirect__c => assignmentMatrixMap.get(assignmentMatrixMapKey).ISR_Indirect__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).ISR_Indirect__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).ISR_Indirect__c, assignmentMatrixMap.get(assignmentMatrixMapKey).ISR_Indirect__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_FSR__c != Null && zipCodeMap.get(zip).Pro_SW_FSR__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).Pro_SW_FSR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_FSR__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).Pro_SW_FSR__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).Pro_SW_FSR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_FSR__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_ISR__c != Null && zipCodeMap.get(zip).Pro_SW_ISR__c != Null){
                
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).Pro_SW_ISR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_ISR__c});
                    
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).Pro_SW_ISR__c)){
                    
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).Pro_SW_ISR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_ISR__c);
                    
                }
            }
        
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).QP__c != Null && zipCodeMap.get(zip).QP__c != Null){
                
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).QP__c => assignmentMatrixMap.get(assignmentMatrixMapKey).QP__c});
                    
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).QP__c)){
                    
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).QP__c, assignmentMatrixMap.get(assignmentMatrixMapKey).QP__c);
                    
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ASR__c != Null && zipCodeMap.get(zip).R_L_ASR__c != Null){
                
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).R_L_ASR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ASR__c});
                    
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).R_L_ASR__c)){
                    
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).R_L_ASR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ASR__c);
                    
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_FSR__c != Null && zipCodeMap.get(zip).R_L_FSR__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).R_L_FSR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_FSR__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).R_L_FSR__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).R_L_FSR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_FSR__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ISR__c != Null && zipCodeMap.get(zip).R_L_ISR__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).R_L_ISR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ISR__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).R_L_ISR__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).R_L_ISR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ISR__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).STG_Vertical__c != Null && zipCodeMap.get(zip).STG_Vertical__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).STG_Vertical__c => assignmentMatrixMap.get(assignmentMatrixMapKey).STG_Vertical__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).STG_Vertical__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).STG_Vertical__c, assignmentMatrixMap.get(assignmentMatrixMapKey).STG_Vertical__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).SW_ASR__c != Null && zipCodeMap.get(zip).SW_ASR__c != Null){
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                    dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).SW_ASR__c => assignmentMatrixMap.get(assignmentMatrixMapKey).SW_ASR__c});
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).SW_ASR__c)){
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).SW_ASR__c, assignmentMatrixMap.get(assignmentMatrixMapKey).SW_ASR__c);
                }
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).TC__c != Null && zipCodeMap.get(zip).TC__c != Null){
                
                if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                   
                   dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{zipCodeMap.get(zip).TC__c => assignmentMatrixMap.get(assignmentMatrixMapKey).TC__c});
                   
                }
                else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(zipCodeMap.get(zip).TC__c)){
                    
                    dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(zipCodeMap.get(zip).TC__c, assignmentMatrixMap.get(assignmentMatrixMapKey).TC__c);
                    
                }
            }
            
           
           
           if(assignmentMatrixMapKey.contains('_')){
                String[] marketSegment=assignmentMatrixMapKey.split('_');
                if(marketSegment[0]=='Federal Government'){
                    if(!dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey)){
                        
                        dtnRoleMap.put(zip+'_'+assignmentMatrixMapKey,new map<String,String>{taaCusFedSet.DTN__C=> taaCusFedSet.Role__c});
                        
                    }
                    else if(dtnRoleMap.containsKey(zip+'_'+assignmentMatrixMapKey) && !dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).containsKey(taaCusFedSet.DTN__C)){
                        
                        dtnRoleMap.get(zip+'_'+assignmentMatrixMapKey).put(taaCusFedSet.DTN__C, taaCusFedSet.Role__c);
                        
                    }
                
                }
            
            }
            
        }
        
        return dtnRoleMap;
    }
    
    /*
    @method: assignDtnToAccountDtnFields
    @description: method to filter the zipcode with respect to Assignment Matrix for dtn corresponding to role on zipcodeDTN to Assignment Matrix
    @params:
    */
    private void assignDtnToAccountDtnFields(Account acc){
        String zip;
        String assignmentMatrixMapKey ;
        if(acc.BillingPostalCode !=null && acc.BillingPostalCode.length() >4){
            zip = acc.BillingPostalCode.substring(0,5);
        }
        
        if(getAssignmentMatrixKey(acc) !=null){
            assignmentMatrixMapKey = getAssignmentMatrixKey(acc);
        }
        
        
        if(String.isNotBlank(zip) && String.isNotBlank(assignmentMatrixMapKey) && assignmentMatrixMap.containsKey(assignmentMatrixMapKey) && zipCodeMap.containsKey(zip)){
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).AISR__c != Null && zipCodeMap.get(zip).AISR__c != Null){
                acc.AISR__c = zipCodeMap.get(zip).AISR__c;
            }else{
              acc.AISR__c = null;
            }
            
            //added by Anjali 507
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ISR__c != Null && zipCodeMap.get(zip).R_L_ISR__c != Null){
                acc.R_L_ISC__c = zipCodeMap.get(zip).R_L_ISR__c;
            }else{
              acc.R_L_ISC__c = null;
            }
            
            /*if(assignmentMatrixMap.get(assignmentMatrixMapKey).ASR_Indirect_Corp_Software__c != Null && zipCodeMap.get(zip).ASR_Indirect_Corp_Software__c != Null){
                
            }*/
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Direct__c != Null && zipCodeMap.get(zip).Corp_Direct__c != Null){
                acc.Corp_Direct__c = zipCodeMap.get(zip).Corp_Direct__c;
            }else{
              acc.Corp_Direct__c = null;
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Corp_Indirect__c != Null && zipCodeMap.get(zip).Corp_Indirect__c != Null){
                acc.Corp_Indirect__c = zipCodeMap.get(zip).Corp_Indirect__c;
            }else{
              acc.Corp_Indirect__c = null;
            }
            
          
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).ISR_Indirect__c != Null && zipCodeMap.get(zip).ISR_Indirect__c != Null){
                
               acc.ISR_Indirect__c=zipCodeMap.get(zip).ISR_Indirect__c;
            }else{acc.ISR_Indirect__c = null;
              
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_FSR__c != Null && zipCodeMap.get(zip).Pro_SW_FSR__c != Null){
                acc.Pro_SW_FSR__c = zipCodeMap.get(zip).Pro_SW_FSR__c;
            }else{
              acc.Pro_SW_FSR__c = null;
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).Pro_SW_ISR__c != Null && zipCodeMap.get(zip).Pro_SW_ISR__c != Null){
                
                acc.Inside_Sales__c  = zipCodeMap.get(zip).Pro_SW_ISR__c;
            }else{
              acc.Inside_Sales__c  = null;
            }
        
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).QP__c != Null && zipCodeMap.get(zip).QP__c != Null){
                acc.QP__c = zipCodeMap.get(zip).QP__c;
            }else{
              acc.QP__c = null;
            }
            
            if(acc.Named_Account_Type__c !='Service Source' && assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_ASR__c != Null && zipCodeMap.get(zip).R_L_ASR__c != Null){
                acc.R_L_ASR__c = zipCodeMap.get(zip).R_L_ASR__c;
            }else{
              acc.R_L_ASR__c = null;
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).R_L_FSR__c != Null && zipCodeMap.get(zip).R_L_FSR__c != Null){
                acc.R_L_FSR__c = zipCodeMap.get(zip).R_L_FSR__c;
            }else{
              acc.R_L_FSR__c = null;
            }
            
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).SW_ASR__c != Null && zipCodeMap.get(zip).SW_ASR__c != Null){
                acc.SW_ASR__c = zipCodeMap.get(zip).SW_ASR__c;
            }else{
              acc.SW_ASR__c = null;
            }
            
            if(assignmentMatrixMap.get(assignmentMatrixMapKey).SW_ASR__c != Null && zipCodeMap.get(zip).SW_ASR__c != Null){
                acc.SW_ASR__c = zipCodeMap.get(zip).SW_ASR__c;
            }else{
              acc.SW_ASR__c = null;
            }
            
        }
    }
    
    //method to check changes on account
   @TestVisible
    private String checkChangesOnAccount(Account newValue, Account oldValue){
        system.debug(loggingLevel.Error,'---newVlaue ::'+newValue+' '+'oldVlaue ::'+oldValue+'----'+newValue.Named_Account__c+':::'+newValue.Named_Account_Type__c);
        String changesOnAccount = '';
        String presentOnAccount = '';
        String keyOfAssignmentMatrix = '';
        
        if(oldValue != null){
            // sms - 500 start
            if(String.isBlank(newValue.BillingPostalCode)){
                system.debug(loggingLevel.Error,'-----newValue.BillingPostalCode-----'+newValue.BillingPostalCode);
                changesOnAccount += WK_Exception.ATA_MISSING_ZIPCODE+'\r\n';
            }
            // sms - 500 End
            if(newValue.BillingPostalCode != oldValue.BillingPostalCode){
                changesOnAccount += WK_Exception.ATA_ZIPCODE_CHANGED +' from '+ oldValue.BillingPostalCode +' to '+newValue.BillingPostalCode +'\r\n';
            }
            if(String.isNotBlank(newValue.BillingPostalCode) && (newValue.BillingPostalCode.length() <5 || (newValue.BillingPostalCode.length() >4 && !zipCodeMap.containsKey(newValue.BillingPostalCode.substring(0,5))))){
                presentOnAccount += 'Zipcode is not present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode +'\r\n';
            }
            if(newValue.BillingPostalCode != oldValue.BillingPostalCode && String.isNotBlank(newValue.BillingPostalCode) && newValue.BillingPostalCode.length() >4 && zipCodeMap.containsKey(newValue.BillingPostalCode.substring(0,5))){
                if(newValue.BillingPostalCode.length() >5 ){
                    presentOnAccount += 'Zipcode is present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode + ' value truncated to '+newValue.BillingPostalCode.substring(0,5)+' to match reocrd.'+'\r\n';
                }else{
                    presentOnAccount += 'Zipcode is present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode.substring(0,5) +'\r\n';
                }
            }
            if(newValue.Market_Segment__c != oldValue.Market_Segment__c){
                changesOnAccount += WK_Exception.ATA_MARKET_SEGMENT_CHANGED +' from '+ oldValue.Market_Segment__c +' to '+newValue.Market_Segment__c +'\r\n';
            }
            if(newValue.Market_Sub_Segment__c != oldValue.Market_Sub_Segment__c){
                changesOnAccount += WK_Exception.ATA_MARKET_SUB_SEGMENT_CHANGED +' from '+ oldValue.Market_Sub_Segment__c +' to '+newValue.Market_Sub_Segment__c +'\r\n';
            }
            if(newValue.Name != oldValue.Name){
                changesOnAccount += WK_Exception.ATA_ACCOUNT_NAME_CHANGED +' from '+ oldValue.Name +' to '+newValue.Name +'\r\n';
            }
            
            /*if(newValue.CUSTID__c != oldValue.CUSTID__c){
                changesOnAccount += WK_Exception'Enterprise id changed from '+ oldValue.CUSTID__c +' to '+newValue.CUSTID__c +'\r\n';
            }*/
            if(newValue.Named_Account_Type__c != oldValue.Named_Account_Type__c){
                changesOnAccount += WK_Exception.ATA_NAMED_ACCOUNT_TYPE_CHANGED +' from '+ oldValue.Named_Account_Type__c +' to '+newValue.Named_Account_Type__c +'\r\n';
            }if(newValue.Named_Account__c != oldValue.Named_Account__c){
                changesOnAccount += WK_Exception.ATA_NAMED_ACCOUNT_CHANGED +' from '+ oldValue.Named_Account__c +' to '+newValue.Named_Account__c +'\r\n';
            }
            if(!newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c)){
                changesOnAccount  += WK_Exception.ATA_UNCHECKED_NAMED_ACCOUNT+'\r\n';
            }
            if(newValue.Named_Account__c && String.isBlank(newValue.Named_Account_Type__c)){
                changesOnAccount += WK_Exception.ATA_MISSING_NAMED_ACCOUNT_TYPE+'\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && !newValue.Named_Account_Type__c.equals('Service Source') && String.isBlank(newValue.NAM_SAM_CNAM__c)){
                changesOnAccount += newValue.Name +' ' +newValue.Named_Account_Type__c+ ' ' +WK_Exception.ATA_MISSING_NAMED_ACCOUNT+'\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source') && String.isBlank(newValue.Service_Source__c)){
                changesOnAccount += newValue.Name +' ' +WK_Exception.ATA_MISSING_SERVIC_SOURCE+'\r\n';
            }
            
            /*Fix for SMS-480 Start*/  
            //if(String.isBlank(newValue.Market_Segment__c)){
              //  changesOnAccount += WK_Exception.ATA_MISSING_MARKET_SEGMENT+'\r\n';
           // }
            if(String.isNotBlank(newValue.Market_Segment__c)){
                if(String.isNotBlank(newValue.sic) && marketSegmentsMap.containsKey(newValue.Sic) && marketSegmentsMap.get(newValue.Sic).Segment__c == newValue.Market_Segment__c){
                    presentOnAccount += 'Market Segment is present due to sic code rule. '+'Value = '+ newValue.Market_Segment__c +'\r\n';
                }else{
                    presentOnAccount += 'Market Segment is present. '+'Value = '+ newValue.Market_Segment__c +'\r\n';
                }
            }
            
            if(String.isBlank(newValue.Market_Segment__c)){
                changesOnAccount += WK_Exception.ATA_MISSING_MARKET_SEGMENT+'\r\n';
            }
            
            if(String.isBlank(newValue.Market_Sub_Segment__c)){
                changesOnAccount += WK_Exception.ATA_MISSING_MARKET_SUB_SEGMENT+'\r\n';
            }
            
            
            
            if(String.isNotBlank(newValue.Market_Sub_Segment__c)){
                presentOnAccount += 'Market Sub-Segment is present. '+'Value = '+ newValue.Market_Sub_Segment__c +'\r\n';
              
            }
            
          /*Fix for SMS-480 End*/  
  
           /* if(!assignmentMatrixMap.containsKey(getAssignmentMatrixKey(newValue))){
                system.debug('In line number 1568***');
                changesOnAccount += WK_Exception.ATA_MISSING_ASSIGNMENTMATRIX + '\r\n';
            }*/
            
            system.debug('change in account==>'+checkforDTNRoleChange(newValue, oldValue)); 
            
            if(checkforDTNRoleChange(newValue, oldValue)==false){
                changesOnAccount += WK_Exception.ATA_UNCHANGED_DTNS + '\r\n';
                system.debug('changesOnAccount======>'+changesOnAccount);
            }
            
            if(newValue.Sic != oldValue.Sic){
                changesOnAccount += WK_Exception.ATA_SIC_CHANGED +' from '+ oldValue.Sic +' to '+newValue.Sic +'\r\n';
                 
            }
            
          
            if(newValue.Sic != null && newValue.Sic != oldValue.Sic){
                
                if(!marketSegmentsMap.containsKey(newValue.Sic)){
                    changesOnAccount += WK_Exception.ATA_NOT_PRESENT_SIC+'\r\n';
                }else{
                    presentOnAccount += 'Sic code is present in the Market Segment Mapping custom setting . '+ 'Value = '+ newValue.Sic +'\r\n';
                }
                if(marketSegmentsMap.containsKey(newValue.Sic) && String.isBlank(newValue.Market_Segment__c) && marketSegmentRulesMap.containsKey(marketSegmentsMap.get(newValue.Sic).Segment__c)){
                    if(marketSegmentRulesMap.get(marketSegmentsMap.get(newValue.Sic).Segment__c).IsSubSegmentBasedOnAnnualRevenue__c ==false && newValue.NumberOfEmployees ==null){
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_NUNMBEROFEMPLOYEES+'\r\n';
                    }else{
                        presentOnAccount += 'Employees no is present. '+ 'Value = '+ newValue.NumberOfEmployees +'\r\n';
                    }
                }
                if(marketSegmentsMap.containsKey(newValue.Sic) && String.isBlank(newValue.Market_Segment__c) && marketSegmentRulesMap.containsKey(marketSegmentsMap.get(newValue.Sic).Segment__c)){
                    if(marketSegmentRulesMap.get(marketSegmentsMap.get(newValue.Sic).Segment__c).IsSubSegmentBasedOnAnnualRevenue__c ==true && newValue.NumberOfEmployees ==null && newValue.AnnualRevenue ==null){
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_ANNUALREVENUE+'\r\n';
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_NUNMBEROFEMPLOYEES+'\r\n';
                    }else{
                        presentOnAccount += 'Employees no and revenue no are present. '+'Employee no = '+ newValue.NumberOfEmployees + ' revenue no = '+ newValue.AnnualRevenue +'\r\n';
                    }
                }
            }
            
        }if(oldValue ==null){
            
            if(String.isBlank(newValue.BillingPostalCode)){
                
                changesOnAccount += WK_Exception.ATA_MISSING_ZIPCODE+'\r\n';
            }
            if(String.isNotBlank(newValue.BillingPostalCode) && newValue.BillingPostalCode.length() >4 && zipCodeMap.containsKey(newValue.BillingPostalCode.substring(0,5))){
                if(newValue.BillingPostalCode.length() >5 ){
                    presentOnAccount += 'Zipcode is present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode + ' value truncated to '+newValue.BillingPostalCode.substring(0,5)+' to match reocrd.'+'\r\n';
                }else{
                    presentOnAccount += 'Zipcode is present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode.substring(0,5) +'\r\n';
                }
            }
            if(String.isNotBlank(newValue.BillingPostalCode) && (newValue.BillingPostalCode.length() <5 || (newValue.BillingPostalCode.length() >4 && !zipCodeMap.containsKey(newValue.BillingPostalCode.substring(0,5))))){
                presentOnAccount += 'Zipcode is not present in Zip Codes DTN table. '+ 'Value = '+ newValue.BillingPostalCode +'\r\n';
            }
            
            if(String.isBlank(newValue.Market_Segment__c)){
                changesOnAccount += WK_Exception.ATA_MISSING_MARKET_SEGMENT+'\r\n';
            }
            if(String.isNotBlank(newValue.Market_Segment__c)){
                if(String.isNotBlank(newValue.sic) && marketSegmentsMap.containsKey(newValue.Sic) && marketSegmentsMap.get(newValue.Sic).Segment__c == newValue.Market_Segment__c){
                    presentOnAccount += 'Market Segment is present due to sic code rule. '+'Value = '+ newValue.Market_Segment__c +'\r\n';
                }else{
                    presentOnAccount += 'Market Segment is present. '+'Value = '+ newValue.Market_Segment__c +'\r\n';
                }
            }
            
            if(String.isBlank(newValue.Market_Sub_Segment__c)){
                                changesOnAccount += WK_Exception.ATA_MISSING_MARKET_SUB_SEGMENT+'\r\n';
            }
            if(String.isNotBlank(newValue.Market_Sub_Segment__c)){
                
                    presentOnAccount += 'Market Sub-Segment is present. '+'Value = '+ newValue.Market_Sub_Segment__c +'\r\n';
              
            }
            
            
            if(getAssignmentMatrixKey(newValue) == null ){
                presentOnAccount += WK_Exception.ATA_MISSING_ASSIGNMENTMATRIX + '\r\n';
            }
            if(getAssignmentMatrixKey(newValue) != null && assignmentMatrixMap.containsKey(getAssignmentMatrixKey(newValue))){
                presentOnAccount += 'Assignment matrix is available in Assignment Matrix table. '+ 'Value = '+ assignmentMatrixMap.get(getAssignmentMatrixKey(newValue)).Name+ '\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && !newValue.Named_Account_Type__c.equals('Service Source') && String.isBlank(newValue.NAM_SAM_CNAM__c)){
                changesOnAccount += newValue.Name + newValue.Named_Account_Type__c+ ' ' +WK_Exception.ATA_MISSING_NAMED_ACCOUNT+'\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && !newValue.Named_Account_Type__c.equals('Service Source') && String.isNotBlank(newValue.NAM_SAM_CNAM__c)){
                presentOnAccount += newValue.Name + newValue.Named_Account_Type__c+' named account is available. '+'\r\n';
            }
            
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source') && String.isBlank(newValue.Service_Source__c)){
                changesOnAccount += newValue.Name + WK_Exception.ATA_MISSING_SERVIC_SOURCE+'\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c) && newValue.Named_Account_Type__c.equals('Service Source') && String.isNotBlank(newValue.Service_Source__c)){
                presentOnAccount += newValue.Name + ' service source is available. '+'\r\n';
            }
            
            if(newValue.Named_Account__c && String.isBlank(newValue.Named_Account_Type__c)){
                changesOnAccount += WK_Exception.ATA_MISSING_NAMED_ACCOUNT_TYPE+'\r\n';
            }
            if(newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c)){
                presentOnAccount += 'Named account type is present. '+ 'Value= '+ newValue.Named_Account_Type__c + '\r\n';
                presentOnAccount += 'Named Account Checkbox is checked. '+'\r\n';
            }
            
            if(!newValue.Named_Account__c && String.isNotBlank(newValue.Named_Account_Type__c)){
                changesOnAccount += WK_Exception.ATA_UNCHECKED_NAMED_ACCOUNT+'\r\n';
            }
            
            if(String.isBlank(newValue.Market_Segment__c) && (newValue.NumberOfEmployees != null || newValue.AnnualRevenue != null) && String.isBlank(newValue.Sic)){
                changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_SIC+'\r\n';
            }
            if(newValue.Sic != null){
                if(!marketSegmentsMap.containsKey(newValue.Sic)){
                    changesOnAccount += WK_Exception.ATA_NOT_PRESENT_SIC+ ' Value = '+ newValue.Sic +'\r\n';
                }else{
                    presentOnAccount += 'Sic code is present in the Market Segment Mapping custom setting. '+ 'Value = '+ newValue.Sic +'\r\n';
                }
                if(marketSegmentsMap.containsKey(newValue.Sic) && String.isBlank(newValue.Market_Segment__c) && marketSegmentRulesMap.containsKey(marketSegmentsMap.get(newValue.Sic).Segment__c)){
                    if(marketSegmentRulesMap.get(marketSegmentsMap.get(newValue.Sic).Segment__c).IsSubSegmentBasedOnAnnualRevenue__c ==false && newValue.NumberOfEmployees ==null){
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_NUNMBEROFEMPLOYEES+'\r\n';
                    }else{
                        presentOnAccount += 'Employees no is present. '+ 'Value = '+ newValue.NumberOfEmployees +'\r\n';
                    }
                }
                if(marketSegmentsMap.containsKey(newValue.Sic) && String.isBlank(newValue.Market_Segment__c) && marketSegmentRulesMap.containsKey(marketSegmentsMap.get(newValue.Sic).Segment__c)){
                    if(marketSegmentRulesMap.get(marketSegmentsMap.get(newValue.Sic).Segment__c).IsSubSegmentBasedOnAnnualRevenue__c ==true && newValue.NumberOfEmployees ==null && newValue.AnnualRevenue ==null){
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_ANNUALREVENUE+'\r\n';
                        changesOnAccount += WK_Exception.ATA_MISSING_RULES_FIELD_NUNMBEROFEMPLOYEES+'\r\n';
                    }else{
                        presentOnAccount += 'Employees no and revenue no are present. '+'Employee no = '+ newValue.NumberOfEmployees + ' revenue no = '+ newValue.AnnualRevenue +'\r\n';
                    }
                }
            }
        }
       
        if(String.isNotBlank(presentOnAccount)){
            
            changesOnAccount = presentOnAccount + changesOnAccount;
        }
         
        
        return changesOnAccount;
    }
    
    //method to create assignment Matrix key
      @TestVisible
     private String assignAssignmentMatrixKey(Account acc){
        String keyOfAssignmentMatrix = '';
        if(!acc.Named_Account__c &&String.isNotBlank(acc.Market_Segment__c) && String.isNotBlank(acc.Market_Sub_Segment__c)){
             keyOfAssignmentMatrix = acc.Market_Segment__c+'_'+acc.Market_Sub_Segment__c;
             
        }
        if(acc.Named_Account__c && String.isNotBlank(acc.Named_Account_Type__c)){
            if(acc.Named_Account_Type__c != 'Service Source'){
                keyOfAssignmentMatrix = acc.Named_Account_Type__c;
                
            }else if(String.IsNotBlank(acc.Market_Segment__c) && String.IsNotBlank(acc.Market_Sub_Segment__c)){
                keyOfAssignmentMatrix = acc.Market_Segment__c+'_'+acc.Market_Sub_Segment__c;
                
            }
        }
        
        return keyOfAssignmentMatrix;
    }
    
    //method to create assignment matrix key for account
    private String getAssignmentMatrixKey(Account acc){
        
        String key = '';
        
        if(assignmentMatrixMap.containsKey(assignAssignmentMatrixKey(acc))){      
            key = assignAssignmentMatrixKey(acc);
            
       }else if(assignAssignmentMatrixKey(acc) !=null && assignAssignmentMatrixKey(acc).contains('_')){
            key= assignAssignmentMatrixKey(acc).substringbefore('_');
            
            if (assignmentMatrixMap.containsKey(key) && assignmentMatrixMap.get(key).Market_Sub_Segment__c=='All'){
                key = assignAssignmentMatrixKey(acc).substringbefore('_');
                
            }else{
                key = null;
                
            }        
       }
      
       return key;
    }
    
    //Method to assign Default account owner
    public void assignDefaultAccountOwner(list<Account>newAccountList,map<id,Account>oldMap){
        
        for(Account acc: newAccountList){
            if(acc.RecordTypeId != excludeRecordType) {
            list<String>dtnSetlst;
            Boolean teamMemberAssigned = false;
            if(oldMap != null && oldMap.get(acc.id) !=null){
                dtnSetlst = new list<String>(createDtnSet(acc, oldMap.get(acc.id)));
            }else{
                dtnSetlst = new list<String>(createDtnSet(acc, null));
            }
            if(!acc.Named_Account__c && String.isBlank(acc.Named_Account_Type__c)){
                
                for(String s : dtnSetlst){
                    if(userMap.containsKey(s)){
                        
                        teamMemberAssigned = true;
                    }
                }
            }
            if(acc.Named_Account__c && String.isNotBlank(acc.Named_Account_Type__c)){
                
                if(acc.Named_Account_Type__c.equals('Service Source') && userMap.containsKey(acc.Service_Source__c)){
                    
                    teamMemberAssigned = true;
                }
                
                if(!acc.Named_Account_Type__c.equals('Service Source') && userMap.containsKey(acc.NAM_SAM_CNAM__c)){
                    
                    teamMemberAssigned = true;
                }
            }
            //Change Account owner
            if(teamMemberAssigned && String.isNotBlank(UtilCustomSettings.TAACustomSetting().Default_Account_UserId__c)){
                
                acc.OwnerId = UtilCustomSettings.TAACustomSetting().Default_Account_UserId__c;
            }
        }
        }
    }
    
    //Method to check role for Account team member
    public Assignment_Matrix__c getAssignmentMatrix(Account acc){
      
      String key = assignAssignmentMatrixKey(acc);
      Assignment_Matrix__c assignmentMatrix;
      if(assignmentMatrixMap.get(key)!=null){      
        assignmentMatrix =  assignmentMatrixMap.get(key);
        
        return assignmentMatrix;
       }else{
         if(key.contains('_')){
            key= key.substringbefore('_');
            
            if(assignmentMatrixMap.get(key)!= null){
            assignmentMatrix =  assignmentMatrixMap.get(key);
            
            if (assignmentMatrix.Market_Sub_Segment__c=='All')
             
              return assignmentMatrix; 
              else
              return null; 
            }       
           }
        }
     return assignmentMatrix;
   }
   

   
  }