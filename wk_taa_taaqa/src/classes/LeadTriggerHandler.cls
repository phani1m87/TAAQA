/*
###########################################################################
# File..................: <<Class - LeadTriggerHandler>>
# Version...............: <<1>>
# Created by............: <<HCL Technologies>>
# Created Date..........: <<10/12/2015>
# Description...........: << Class used to update the lead owner on the basis of Zip code and sales alignment value>>
# Created by the HCL Tech. Modification must retain the above copyright notice.
# Permission is not granted to anyone to use this software for commercial uses.
# Company URL : http://www.HCLTech.com
########################################################################### */
    
public class LeadTriggerHandler{
    map<String,ZipCodeDTN__c> zipCodeMap = new map<String,ZipCodeDTN__c>();
    Static Set<String> zipCodeSet=new Set<String>();
    Set<String> dtnSet=new Set<String>();
    map<String,User> userMap  = new map<String,User>();
    string defaultOwner;
    static  map<String,String> dtnWithRoleMap = new map<String,String>();
    map<String,Sales_Alignment__c> AlignmentMap=new map<String,Sales_Alignment__c>();  
    static map<String,String>namedAccountRoleDTN = new map<String,String>();
    static  map<String, String> namedAccountDTNmap = new map<String, String>();
    static  map<String,ZipCodeDTN__c>zipCodeMap2 = new map<String,ZipCodeDTN__c>();
    static  map<String,Assignment_Matrix__c>assignmentMatrixMap = new map<String,Assignment_Matrix__c>();
    public LeadTriggerHandler (list<lead> newLeadList,Map<Id,Lead>oldMap){
       System.debug('Inside Lead Trigger Handler Constructor::::::::::');
    String zip='';
        for(lead l:newLeadList){
            if(l.PostalCode!=null)
                zip= l.PostalCode;
                if(zip.length()>4){
                    zip=zip.substring(0,5);
                }
            zipCodeSet.add(zip);
            System.debug('###&&&'+zipCodeSet);
        }
        if(!zipCodeSet.isEmpty()&& zipCodeSet!=null && zipCodeSet.size()>0){
            List<String> fields = new List<String>(ZipCodeDTN__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soql = '' + ' select ' + String.join(fields, ',')
                        + ' from ZipCodeDTN__c'
                        + ' where Name in:zipCodeSet';
            System.debug('!!!!'+soql);
            for(ZipCodeDTN__c z : Database.query(soql)){
                zipCodeMap.put(z.Name,z);
            }
        }
        System.debug('Constructor$$$$$$ZipCodeMAp$$$$$$$'+zipCodeMap);
        for(Sales_Alignment__c align: [select id,Sales_Rep_Role__c,Sales_Alignment__c from Sales_Alignment__c])
        AlignmentMap.put(align.Sales_Alignment__c,align);
        
        
    }
    
    public void updateOwner(list<lead> newLeadList,Map<Id,Lead> oldMap){
        WK_Exception wkException = new WK_Exception();
        Sales_Alignment__c salesAlignment;	//SMS-753
       // list<Monitoring_Log__c> monitoringLogslist = new list<Monitoring_Log__c>();
       
       //SMS-684 change  
       //System.debug('Sales Alignmnet MAp :::::::'+AlignmentMap);
         
        for(Lead l:newLeadList){
            /*try{
             if(String.isEmpty(l.PostalCode) || String.isBlank(l.PostalCode)){
              wkException.setMessage(WK_Exception.LA_MISSING_ZIP_CODE);
             throw wkException;
             }
            }catch (Wk_Exception ex){
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Zip Code is missing while inserting/Updatig Lead:: '+ l.lastName+' by '+UserInfo.getName()+ ' at '+ System.Now();
                er.Method__c = 'Insert/Update';
                er.Type__c = WK_Exception.LA_MISSING_ZIP_CODE;
                insert er;   
            }
            try{
             if(AlignmentMap.size()==0){
                 //wkException.setMesaage(WK_Exception.ATA_RECORDS_NOT_EXISTS);
                 wkException.setMessage(WK_Exception.ATA_RECORDS_NOT_EXISTS);
                 throw wkException;
                }
            }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Exception occurs while inserting/Updatig Lead:: '+ l.lastName+' by '+UserInfo.getName()+ ' at '+ System.Now()+'\n'+'Error Cause:: No record Exixts in Salesforce for SalesAllignment Object';
                er.Method__c = 'Insert/Update';
                er.Type__c = WK_Exception.ATA_RECORDS_NOT_EXISTS;
                insert er;         
            }
            try{
              if(String.IsNotEmpty(l.PostalCode) && !zipCodeMap.containsKey(l.PostalCode)){
                wkException.setMessage(WK_Exception.LA_UNABLE_TO_DETERMINE_LEAD_OWNER);
                throw wkException;
                 }
            }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Invalid Zipcode is entered by '+UserInfo.getName()+ ' while inserting/updating Lead at '+ System.Now()+'\n'+'Error Cause:: Zip Code is not present in the Zip Code table';
                er.Method__c = 'Insert/Update';
                er.Type__c = WK_Exception.LA_UNABLE_TO_DETERMINE_LEAD_OWNER;
                insert er;  
            }*/
            
            System.debug('@@AlignmentMap'+AlignmentMap);
            System.debug('@@l.Sales_Alignment__c'+l.Sales_Alignment__c);
            System.debug('@@AlignmentMap.get(l.Sales_Alignment__c)'+AlignmentMap.get(l.Sales_Alignment__c));
            if((oldMap==null || oldMap.get(l.Id).Sales_Alignment__c!= l.Sales_Alignment__c )&& l.Sales_Alignment__c!=null && AlignmentMap.size()>0){
                //SMS-753 Start
                //l.Sale_Rep_Role__c=AlignmentMap.get(l.Sales_Alignment__c).Sales_Rep_Role__c;
                salesAlignment=AlignmentMap.get(l.Sales_Alignment__c);
                if(salesAlignment!= null) {
                	l.Sale_Rep_Role__c=salesAlignment.Sales_Rep_Role__c;
                }
                //SMS-753 End
            }
        }
        
        
       /* if(zipCodeMap.size()>0 && zipCodeMap!=null){
            for(Lead l:newLeadList){
                l.DTN_Text__c='';
                 if(String.isNotBlank(l.PostalCode)){
                if(oldMap==null || oldMap.get(l.Id).Sales_Alignment__c!= l.Sales_Alignment__c || oldMap.get(l.Id).PostalCode!=l.PostalCode|| oldMap.get(l.Id).Market_Segment__c!=l.Market_Segment__c || oldMap.get(l.Id).Market_Sub_Segment__c!=l.Market_Sub_Segment__c){
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Research and Learning')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).R_L_FSR__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ASR - Research and Learning')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).R_L_ASR__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Indirect (Corp Software)')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Corp_Indirect__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ISR - Indirect (Corp Software)')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).ISR_Indirect__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='QP Rep')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).QP__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='AISR')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).AISR__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Professional Software')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Pro_SW_FSR__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ISR - Professional Software + ISR Research and Learning')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Pro_SW_ISR__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - (Corp Direct Software)')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Corp_Direct__c;
                if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='Training & Consulting Rep - Research & Learning')
                l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Training_Consulting_Rep_Research__c;
                if(l.DTN_Text__c !=null){
                    dtnSet.add(l.DTN_Text__c);
                }
             }   
            }
          } 
        }*/
        dtnSet=getDTNSet(newLeadList,oldMap);
        system.debug('DTNSET*'+dtnSet);
    
     System.debug('DTNSet%%%%%%%%%%%%%'+dtnSet);
        AccountAutomationSetting__c cs;
        cs=UtilCustomSettings.TAACustomSetting();
        
        if(cs.Default_Lead_Custodian__c!=null){
            defaultOwner=[select id from user where name=:cs.Default_Lead_Custodian__c].Id;
            System.debug('Default Owner as Per custom setting====='+defaultOwner);       
        }else{
            defaultOwner=UserInfo.getUserId();
        }
        System.debug('Default Owner====='+defaultOwner);  
        if(!dtnSet.isEmpty() && dtnSet.size()>0){
            for(User u:[Select id,DTN__c,IsActive,Name from User where  /*IsActive=true and*/ DTN__c IN: dtnSet])
            userMap.put(u.dtn__C,u);
        }                
        System.debug('USerMAp&&&&&&'+userMap);
        for(Lead l:newLeadList){
            system.debug('Lname*'+l.lastName);
            system.debug('l.DTN_Text__c*'+l.DTN_Text__c);
           // system.debug('IsActive**'+UserMap.get(l.DTN_Text__c).IsActive);
            //system.debug('l.SA*'+l.DTN_Text__c);
           // system.debug('IsActive*'+UserMap.get(l.DTN_Text__c).IsActive);
            
           if(String.IsNotEmpty(l.PostalCode)) {
               if(oldMap==null || oldMap.get(l.Id).Sales_Alignment__c!= l.Sales_Alignment__c || oldMap.get(l.Id).PostalCode!=l.PostalCode|| oldMap.get(l.Id).Market_Segment__c!=l.Market_Segment__c || oldMap.get(l.Id).Market_Sub_Segment__c!=l.Market_Sub_Segment__c){
                  if(userMap.size()>0 && userMap!=null && String.IsNotEmpty(l.DTN_Text__c)){
                      if(UserMap.get(l.DTN_Text__c).IsActive){
                      	System.debug('DTN: '+l.DTN_Text__c+'User: '+userMap.get(l.DTN_Text__c));
                         l.ownerId=userMap.get(l.DTN_Text__c).Id;
                        }else{
                        System.debug('Not able to find the active user ');
                        l.ownerId=defaultOwner;
                        }         
                    }else{
                      l.ownerId=defaultOwner;
                    }           
                }    
            } else{ 
           l.ownerId=defaultOwner; 
           }
        }  
    }   
 public void monitoringlogs(list<lead> newLeadList,Map<Id,Lead> oldMap){
     Set<String>setOfDtn= new Set<String>();
     //SMS-753 Start
     Set<Id>ownerIdSet = new Set<Id>();
     Map<Id,String> ownerMap = new Map<Id,String>(); 
     //SMS-753 End
     String zip='';
     for(Lead l:newLeadList){
         setOfDtn.add(l.DTN_Text__c);
         ownerIdSet.add(l.OwnerId);	//SMS-753
     }
     //SMS-753 Start
     if(!ownerIdSet.isEmpty() && ownerIdSet.size()>0){
     	for(User u:[Select id,Name from User where Id IN :ownerIdSet]) {
     		ownerMap.put(u.id,u.name);
     	}
     }
     //SMS-753 End
       if(!setOfDtn.isEmpty() && setOfDtn.size()>0){
            for(User u:[Select id,DTN__c,IsActive,Name from User where  /*IsActive=true and*/ DTN__c IN: setOfDtn])
            userMap.put(u.dtn__C,u);
        }     
      WK_Exception wkException = new WK_Exception();
      String leadEvent;
      List<Monitoring_Log__c> loglist = new List<Monitoring_Log__c>();
      for(Lead l:newLeadList){
         if(String.IsNotEmpty(l.DTN_Text__c)){
          System.debug('DTN Text::::::::::'+l.DTN_Text__c);
         }
         if(!userMap.isEmpty()){
          System.debug('User Map$$$$$$$$'+userMap);
         }
         if(!zipCodeMap.isEmpty()){
           System.debug('ZIP Code MAp$$$$$'+zipCodeMap);
         }
          if(String.IsNotEmpty(l.PostalCode)){
          System.debug('PostalCode::::::::::'+l.PostalCode);
              zip= l.PostalCode;
              if(zip.length()>4)
                  zip=zip.substring(0,5);
         }
          if(oldMap==null || oldMap.get(l.Id).Sales_Alignment__c!= l.Sales_Alignment__c || oldMap.get(l.Id).PostalCode!=l.PostalCode|| oldMap.get(l.Id).Market_Segment__c!=l.Market_Segment__c || oldMap.get(l.Id).Market_Sub_Segment__c!=l.Market_Sub_Segment__c) {
              if(oldMap==null)
                  leadEvent='Insert';
              else
                  leadEvent='Update';
            try{
             if(String.isEmpty(l.PostalCode) || String.isBlank(l.PostalCode)){
              wkException.setMessage(WK_Exception.ATA_MISSING_ZIP_CODE_LEAD_ASSIGNMENT);
             throw wkException;
             }
            }catch (Wk_Exception ex){
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Zip Code is missing while '+leadEvent+ ' Lead';
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_MISSING_ZIP_CODE_LEAD_ASSIGNMENT;
                er.Lead__c=l.Id;
               //insert er; 
                loglist.add(er);               
            }
            try{
             if(AlignmentMap.size()==0){
                 //wkException.setMesaage(WK_Exception.ATA_RECORDS_NOT_EXISTS);
                 wkException.setMessage(WK_Exception.ATA_RECORDS_NOT_EXISTS);
                 throw wkException;
                }
            }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Exception occurs while '+leadEvent+' Lead:: '+ l.lastName+'\n'+'Error Cause:: No record Exixts in Salesforce for SalesAllignment Object';
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_RECORDS_NOT_EXISTS;
                er.Lead__c=l.Id;
                //insert er;
                loglist.add(er);                
            }
            try{
              if(String.IsNotEmpty(zip)&& !zipCodeMap.containsKey(zip)){
                 
                  wkException.setMessage(WK_Exception.ATA_INVALID_ZIP_CODE_LEAD_ASSIGNMENT);
                  throw wkException;
                
                 }
            }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Invalid Zipcode is entered by '+UserInfo.getName()+ ' while'+leadEvent +' Lead '+'\n'+'Error Cause:: Provided Zip Code  '+ l.PostalCode +' is not present in the Zip Code table';
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_INVALID_ZIP_CODE_LEAD_ASSIGNMENT;
                er.Lead__c=l.id;
                //insert er;  
                loglist.add(er);
            }
     try{
         system.debug('l.PostalCode%%%%%'+l.PostalCode);
         system.debug('l.DTN_Text__c'+l.DTN_Text__c);
         system.debug('userMap'+userMap);
         system.debug('zipCodeMap'+l.PostalCode);
         
         if(String.IsNotEmpty(l.PostalCode) && String.IsNotEmpty(l.DTN_Text__c) && !userMap.containsKey(l.DTN_Text__c) && !zipCodeMap.ISEmpty()){
             wkException.setMessage(WK_Exception.ATA_USER_NOT_EXISTS_IN_THE_SYSTEM_FOR_DTN);
             throw wkException;          
           }
         }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Unable to assign Lead owner according to Lead Assignment rules defined as the User is not present in the system for DTN: '+l.DTN_Text__c;
                er.Method__c = leadEvent;
                er.Lead__c=l.Id;
                er.Type__c = WK_Exception.ATA_USER_NOT_EXISTS_IN_THE_SYSTEM_FOR_DTN;
                //insert er;  
                loglist.add(er);
            }
            
            try{
                system.debug('l.PostalCode**'+l.PostalCode);
                system.debug('.DTN_Text__c**'+l.DTN_Text__c);
                system.debug('UserMap**'+userMap.get(l.DTN_Text__c));
                //system.debug('IsActive**'+userMap.get(l.DTN_Text__c).ISActive);
                system.debug('ZipCode**'+zipCodeMap);
         if(String.IsNotEmpty(l.PostalCode) && String.IsNotEmpty(l.DTN_Text__c) && userMap.containsKey(l.DTN_Text__c) && userMap.get(l.DTN_Text__c).ISActive==false && !zipCodeMap.ISEmpty()){
             wkException.setMessage(WK_Exception.ATA_USER_IS_NOT_ACTIVE);
             throw wkException;          
           }
         }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Unable to assign Lead owner according to Lead Assignment rules defined as the User is not active in the system for DTN: '+l.DTN_Text__c;
                er.Method__c = leadEvent;
                er.Lead__c=l.Id;
                er.Type__c = WK_Exception.ATA_USER_IS_NOT_ACTIVE;
                //insert er;  
                loglist.add(er);
            }
             try{
              if(String.IsEmpty(l.Sales_Alignment__c) || String.isBlank(l.Sales_Alignment__c)){
                wkException.setMessage(WK_Exception.ATA_MISSING_SALES_ALLIGNMENT);
                throw wkException;
                 }
            }catch(Wk_Exception ex){            
                Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Sales Allignment is missing  while inserting/updating Lead by  '+ Userinfo.getName()+ 'at '+ System.now() ;
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_MISSING_SALES_ALLIGNMENT;
                er.Lead__c=l.id;
                //insert er;  
                loglist.add(er);
            }
            //SMS-753 Start
            try{
            if(String.IsEmpty(l.Sale_Rep_Role__c) || String.isBlank(l.Sale_Rep_Role__c)){
            	wkException.setMessage(WK_Exception.ATA_MISSING_SALES_REP_ROLE);
            	throw wkException;
            }
            } catch(Wk_Exception ex){
            	System.debug('@@@'+l);
            	String Detail='Created by='+UserInfo.getName()+', Lead Source='+l.LeadSource+', Lead Status='+l.status+', Campaign Name='+l.Campaign_Name__c+', Sales Alignment='+l.Sales_Alignment__c+', Sales Alignment Staging='+l.Sales_Alignment_Staging__c+'.\r\n';
            	Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = Detail+' Sales Rep Role value is missing in Lead. Lead Owner assigned to default owner in custom setting: Owner Name='+ownerMap.get(l.ownerId);
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_MISSING_SALES_REP_ROLE;
                er.Lead__c=l.id;
                //insert er;  
                loglist.add(er);
            }
            //SMS-753 End
            if(String.isNotBlank(l.PostalCode) && String.isNotBlank(l.Sales_Alignment__c)&& zipCodeMap.containsKey(zip)&& userMap.containsKey(l.DTN_Text__c)&& userMap.get(l.DTN_Text__c).IsActive){
                 Monitoring_Log__c  er = new Monitoring_Log__c ();
                er.Name = 'Lead Assignment';
                er.Class__c = 'LeadTriggerHandler';
                er.Detail__c = 'Lead is Assigned to User:'+userMap.get(l.DTN_Text__c).Name +' DTN:'+userMap.get(l.DTN_Text__c).DTN__c;
                er.Method__c = leadEvent;
                er.Type__c = WK_Exception.ATA_LEAD_OWNER_IS_ASSIGNED_LEAD_ASSIGNMENT_RULE;
                er.Lead__c=l.id;
                //insert er;  
                loglist.add(er);
                
            } 
            
            
        }
      } 
      if(loglist.size()>0){
          insert loglist;
      }
    }    
public Set<String> getDTNSet(List<Lead>newLeadList,Map<Id,Lead>oldMap){
    Set<String>setDTN= new Set<String>();
    if(zipCodeMap.size()>0 && zipCodeMap!=null){
            for(Lead l:newLeadList){
                l.DTN_Text__c='';
                 if(String.isNotBlank(l.PostalCode)){
                if(oldMap==null || oldMap.get(l.Id).Sales_Alignment__c!= l.Sales_Alignment__c || oldMap.get(l.Id).PostalCode!=l.PostalCode|| oldMap.get(l.Id).Market_Segment__c!=l.Market_Segment__c || oldMap.get(l.Id).Market_Sub_Segment__c!=l.Market_Sub_Segment__c){
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Research and Learning')
                system.debug('Inside getDTNSetLoop');
                system.debug('zipCodeMap**'+zipCodeMap);
                system.debug('l.PostalCode**'+l.PostalCode);
                system.debug('l.Sale_Rep_Role__c**'+l.Sale_Rep_Role__c);
                String zip= l.PostalCode;
                if(zip.length()>4)
                    zip=zip.substring(0,5);
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='RSC - Research & Learning')
                l.DTN_Text__c=zipCodeMap.get(zip).R_L_FSR__c;
               // if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ASR - Research and Learning')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='RC - Research & Learning')
                l.DTN_Text__c=zipCodeMap.get(zip).R_L_ASR__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Indirect (Corp Software)')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='RSC - Corp Software Indirect')      
                l.DTN_Text__c=zipCodeMap.get(zip).Corp_Indirect__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ISR - Indirect (Corp Software)')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - Corp Software Indirect')    
                l.DTN_Text__c=zipCodeMap.get(zip).ISR_Indirect__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='QP Rep')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='QP Specialist')         
                l.DTN_Text__c=zipCodeMap.get(zip).QP__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='AISR')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - Books & Journals')    
                l.DTN_Text__c=zipCodeMap.get(zip).AISR__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - Professional Software')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='RSC - Professional Software')
                l.DTN_Text__c=zipCodeMap.get(zip).Pro_SW_FSR__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='ISR - Professional Software + ISR Research and Learning')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - Professional Software')
                l.DTN_Text__c=zipCodeMap.get(zip).Pro_SW_ISR__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='FSR - (Corp Direct Software)')
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='RSC - Corp Software Direct')
                l.DTN_Text__c=zipCodeMap.get(zip).Corp_Direct__c;
                //if(zipCodeMap.containsKey(l.PostalCode) && l.Sale_Rep_Role__c=='Training & Consulting Rep - Research & Learning')
                //l.DTN_Text__c=zipCodeMap.get(l.PostalCode).Training_Consulting_Rep_Research__c;
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='T&C - Research & Learning')
                l.DTN_Text__c=zipCodeMap.get(zip).TC__c;   
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - Research & Learning')
                l.DTN_Text__c=zipCodeMap.get(zip).R_L_ISR__c;  
                
                //SMS-684 #technicaldebt
                // these need to be added ISC - N2N Professional Software, ISC - N2E Professional Software

                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - N2N Professional Software')
                l.DTN_Text__c=zipCodeMap.get(zip).ISC_N2N_Professional_Software__c;
            
                if(zipCodeMap.containsKey(zip) && l.Sale_Rep_Role__c=='ISC - N2E Professional Software')
                l.DTN_Text__c=zipCodeMap.get(zip).ISC_N2E_Professional_Software__c;
            
                // End SMS-684
                
                if(l.DTN_Text__c !=null){
                    setDTN.add(l.DTN_Text__c);
                }
             }   
            }
          } 
        }
    return setDTN;
    
}   
    /******
    @future
    public static void assignAccountTeamAndSharingRules(list<Id> convertedAccountIdList){
        List<Account> convertedAccountList=[Select Id,Name,Inactive__c,BillingPostalCode,Named_Account__c,Market_Segment__c,Market_Sub_Segment__c,AISR__c,Corp_Direct__c,Corp_Indirect__c,Inside_Sales__c,NAM_SAM_CNAM__c,Pro_SW_FSR__c,QP__c,R_L_ASR__c,R_L_FSR__c,SW_ASR__c,Service_Source__c from Account where Id In :convertedAccountIdList];
        System.debug('Inside method assignAccountTeamAndSharingRulesLead???????????????????????????????');
        Set<String> dtnSet2 = new Set<String>();
        list<User> userList = new list<User>();
        map<String,User> userMap = new map<String,User>();
        list<AccountTeamMember>members = new list<AccountTeamMember>();
        list<AccountShare>sharingRules = new list<AccountShare>();
        list<Monitoring_Log__c> errorRecordslist = new list<Monitoring_Log__c>();
        //map<String,String> dtnWithRoleMap = new map<String,String>();
       
      
          //static map<String,String>namedAccountRoleDTN = new map<String,String>();
        User cutodialUser = new user();
        if(String.isNotEmpty(UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c)){
            cutodialUser = [Select id,Name,DTN__c from User where Name=:UtilCustomSettings.TAACustomSetting().Default_Account_Custodian__c];
        }
        //create map for Strategic Account Role-DTN as account and rep
        for(Strategic_Account_RoleDTN__c s : [Select Account__c,DTN__c,Strategic_Account_Manager__c from Strategic_Account_RoleDTN__c]){
            namedAccountRoleDTN.put(s.Account__c,s.Strategic_Account_Manager__c);
            namedAccountDTNmap.put(s.Account__c, s.DTN__c);
        }
        //create map for Corporate National Role-DTN as account and rep
        for(Corporate_National_Role_DTN__c c : [Select Account__c,DTN__c,Corporate_National_Account_Manager__c from Corporate_National_Role_DTN__c]){
            namedAccountRoleDTN.put(c.Account__c,c.Corporate_National_Account_Manager__c);
            namedAccountDTNmap.put(c.Account__c, c.DTN__c);
        }
        //create map for Strategic Account Role-DTN as account and rep
        for(National_Account_Management__c n : [Select Account__c,DTN__c,NationalAccountManager__c from National_Account_Management__c]){
            namedAccountRoleDTN.put(n.Account__c,n.NationalAccountManager__c);
            namedAccountDTNmap.put(n.Account__c, n.DTN__c);
        }
            
        list<String>fieldsAssignment = new list<String>(Assignment_Matrix__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlAssignment = 'Select'+' '+String.join(fieldsAssignment,',')+' '+
                                'from Assignment_Matrix__c';
        for(Assignment_Matrix__c am : Database.query(soqlAssignment)){
            // Code modified to handle All scenario in Assignment MAtrix for Market_Sub_Segment__c value.
            String key='';
            if(am.Market_Sub_Segment__c.equals('All')){
                key=am.Market_Segment__c;
             }else{
                key = am.Market_Segment__c+'_'+am.Market_Sub_Segment__c;
             }
            assignmentMatrixMap.put(key,am);
        }
        set<String>zipCodeSet2 = new set<String>();
        for(Account acc : convertedAccountList){
            if(String.isNotBlank(acc.BillingPostalCode) ){//&& acc.BillingPostalCode.contains('-')
                zipCodeSet2.add(acc.BillingPostalCode.substringBefore('-'));
            }
        }
        system.debug(loggingLevel.Error,'--2---'+zipCodeSet);
        list<String>fieldsZipCodeDTN2 = new list<String>(ZipCodeDTN__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soqlZipCodeDTN2 ='Select'+' '+String.join(fieldsZipCodeDTN2,',')+' '+
                                'from ZipCodeDTN__c'+' '+
                                'where Name in:zipCodeSet2'; 
        for(ZipCodeDTN__c z : Database.query(soqlZipCodeDTN2)){
            zipCodeMap2.put(z.Name,z);
        }
        dtnWithRoleMap = assignDtnWithRole(convertedAccountList);
        for(Account acc : convertedAccountList){
            if(acc.Named_Account__c == false &&
               acc.BillingPostalCode != null &&
               acc.Market_Segment__c !=null &&
               acc.Market_Sub_Segment__c != null
                ){
                dtnSet2.addAll(createDtnSet(acc));
            }
        }
        if(dtnSet2.size() > 0){
            System.debug('???????????????????????????????????????????'+dtnSet2);
            userList = [Select id,Name,DTN__c from User where  DTN__c in: dtnSet2 and isActive=true];//isActive=true and
        }
        if(userList.size()>0){
            System.debug('????????????USer list size is'+userList.size());
            System.debug('????????????USer list  is'+userList);
            for(User u : userList){
                userMap.put(u.DTN__c,u);
            }
            System.debug('User MAp is '+userMap);
        }
        //create list of Account team Members and their Access to Account, Opportunity, case
        for(Account a : convertedAccountList){
            if(a.Named_Account__c == false && a.BillingPostalCode != Null &&
                a.Market_Segment__c !=null &&
                a.Market_Sub_Segment__c != null
                ){
                    system.debug(loggingLevel.Error,'--inside first--');
                if(dtnSet2.size()>0 ){
                    System.debug('?????????????????????????Inside Dtn size Check');
                    for(String s : new list<String>(createDtnSet(a))){
                        if(userMap.containsKey(s) ){
                            System.debug('----------Inside 1st check------------');
                            members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = dtnWithRoleMap.get(s+'_'+a.BillingPostalCode.substringBefore('-')), UserId =userMap.get(s).id ));
                            sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = userMap.get(s).id, AccountId = a.id));
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',userMap.get(s).Name+':created on'+' '+a.Name+'::'+a.id ,'assignAccountTeamAndSharingRules',a.id,'Error'));
                        }else{
                            System.debug('?????????????????????????Inside Cutodial assintion  Check');
                            members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = 'Cust-'+s+dtnWithRoleMap.get(s+'_'+a.BillingPostalCode.substringBefore('-')), UserId =cutodialUser.Id ));
                            sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = cutodialUser.Id, AccountId = a.id));
                            errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',cutodialUser.Name+':created on'+' '+a.Name+'::'+a.id ,'assignAccountTeamAndSharingRules', a.id,'Error'));
                        }
                    }
                }else{
                     System.debug('?????????????????????????Inside Cutodial assintion  Check--2--------');
                    members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = 'Repersentative', UserId =cutodialUser.Id ));
                    sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = cutodialUser.Id, AccountId = a.id));
                    errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',cutodialUser.Name+':created on'+' '+a.Name+'::'+a.id ,'assignAccountTeamAndSharingRules',a.id,'Error'));
                }
            }else if(a.Named_Account__c == true && namedAccountRoleDTN.containsKey(a.Name)){
                members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = 'Repersentative', UserId =namedAccountRoleDTN.get(a.Name) ));
                sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = namedAccountRoleDTN.get(a.Name), AccountId = a.id));
                errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',namedAccountRoleDTN.get(a.Name)+':created on'+' '+a.Name+'::'+a.id , 'assignAccountTeamAndSharingRules', a.id,'Error'));
            }else if(a.Named_Account__c == false && a.BillingPostalCode == Null ){
                system.debug(loggingLevel.Error,'--inside second--');
                members.add(new AccountTeamMember(AccountId = a.id, TeamMemberRole = 'Repersentative', UserId =cutodialUser.Id ));
                sharingRules.add(new AccountShare(AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'None', UserOrGroupId = cutodialUser.Id, AccountId = a.id));
                errorRecordslist.add(LoggerUtil.createMonitoringLog('Account automation', 'UtilDTNStampingAndTeamMemberCreation',cutodialUser.Name+':created on'+' '+a.Name+'::'+a.id , 'assignAccountTeamAndSharingRules', a.id,'Error'));
            }
        }
        //insert account Team Member if any
        if(members.size()>0){
            System.debug('????????????Inside members size check?????????');
            System.debug('>>>>>>>>>>>>>>>'+members);
            Database.SaveResult[] memberslst = Database.insert(members,false);
            System.debug('>>>>>>>>>>>>>>> memberslst'+memberslst);
            if(!Test.isRunningTest()){
                for(Database.SaveResult sr : memberslst){
                    if(!sr.isSuccess()){
                        System.debug('???????------Inside Error-------??????????');
                        String errorMsg = '';
                        for(Database.Error err : sr.getErrors()){
                            //errorRecordslist.add(LoggerUtil.createErrorRecord(String className, String methodName, String));
                            errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while creating accountTeamMember'+'\n';
                        }
                        errorRecordslist.add(LoggerUtil.createErrorRecord('Account automation', 'LeadTriggerHandler', 'onAfter', errorMsg));
                    }
                    if(sr.isSuccess()){
                    System.debug('??????????????????Successfully inswrted Account team member.....'+sr.getId());
                    }
                }
            }
        }
        //insert sharing Rules if any
        if(sharingRules.size()>0){
            System.debug('????????????Inside sharing Rules  size check?????????');
            System.debug('<<<<<<<<<<'+sharingRules);
            Database.SaveResult[] sharingRuleslst = Database.insert(sharingRules,false);
            System.debug('<<<<<<<<<< sharingRuleslst'+sharingRuleslst);
    
            if(!Test.isRunningTest()){
                for(Database.SaveResult sr : sharingRuleslst){
                    if(!sr.isSuccess()){
                        System.debug('???????------Inside Sharing Rules Error-------??????????');
                        String errorMsg = '';
                        for(Database.Error err : sr.getErrors()){
                            //errorRecordslist.add(LoggerUtil.createErrorRecord(String className, String methodName, String));
                            errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while creating sharingRules'+'\n';
                        }
                        errorRecordslist.add(LoggerUtil.createErrorRecord('Account automation', 'LeadTriggerHandler', 'onAfter', errorMsg));
                    }
                }
            }
        }
            
        //insert error of records in Error Records object if any
        if(!Test.isRunningTest()){
            if(errorRecordslist.size()>0 ){
                Database.SaveResult[] er = Database.insert(errorRecordslist,false);
            }
        }
    }
    //method will create set of dtn
    /*
    @method: createDtnSet
    @description: method will create set of dtn on the basis of Corresponding fields on Account
    @params: Account
    */
    /*
    public Static Set<String> createDtnSet(Account acc){
        Set<String>dtnSet = new Set<String>();
        if(acc.AISR__c !=null){
            dtnSet.add(acc.AISR__c);
        }
        if(acc.Corp_Direct__c !=null){
            dtnSet.add(acc.Corp_Direct__c);
        }
        if(acc.Corp_Indirect__c !=null){
            dtnSet.add(acc.Corp_Indirect__c);
        }
        if(acc.Inside_Sales__c !=null){
            dtnSet.add(acc.Inside_Sales__c);
        }
        if(acc.NAM_SAM_CNAM__c !=null){
            dtnSet.add(acc.NAM_SAM_CNAM__c);
        }
        if(acc.Pro_SW_FSR__c !=null){
            dtnSet.add(acc.Pro_SW_FSR__c);
        }
        if(acc.QP__c !=null){
            dtnSet.add(acc.QP__c);
        }
        if(acc.R_L_ASR__c !=null){
            dtnSet.add(acc.R_L_ASR__c);
        }
        if(acc.R_L_FSR__c !=null){
            dtnSet.add(acc.R_L_FSR__c);
        }
        if(acc.SW_ASR__c !=null){
            dtnSet.add(acc.SW_ASR__c);
        }
        if(acc.Service_Source__c !=null){
            dtnSet.add(acc.Service_Source__c);
        }
        return dtnSet;
    }
    public static map<String,String> assignDtnWithRole(list<Account> newAccountList){
        //AccountTriggerHandler handler = new AccountTriggerHandler();
        //handler.onBeforeInsert(newAccountList,null);
        for(Account acc : newAccountList){
            if(acc.Named_Account__c == false && String.isNotBlank(acc.BillingPostalCode) && String.isNotBlank(acc.Market_Segment__c) && String.isNotBlank(acc.Market_Sub_Segment__c) && acc.Inactive__c==false){
                String zip = acc.BillingPostalCode.substringBefore('-');
                String keyOfAssignmentMatrix1 = acc.Market_Segment__c+'_'+acc.Market_Sub_Segment__c;
                // altenate key is added to handle 'All' subsegment values.
                String keyOfAssignmentMatrix2= acc.Market_Segment__c;
                if(zipCodeMap2.containsKey(zip) && (assignmentMatrixMap.containsKey(keyOfAssignmentMatrix1)||assignmentMatrixMap.containsKey(keyOfAssignmentMatrix2))){
                    if(assignmentMatrixMap.containsKey(keyOfAssignmentMatrix1)){
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).AISR__c != Null && zipCodeMap2.get(zip).AISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).AISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).AISR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).ASR_Indirect_Corp_Software__c != Null && zipCodeMap2.get(zip).ASR_Indirect_Corp_Software__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).ASR_Indirect_Corp_Software__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).ASR_Indirect_Corp_Software__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).Corp_Direct__c != Null && zipCodeMap2.get(zip).Corp_Direct__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Corp_Direct__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).Corp_Direct__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).Corp_Indirect__c != Null && zipCodeMap2.get(zip).Corp_Indirect__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Corp_Indirect__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).Corp_Indirect__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).ISR_Indirect__c != Null && zipCodeMap2.get(zip).ISR_Indirect__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).ISR_Indirect__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).ISR_Indirect__c);
                        }
                        
                        /***if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).NAM_SAM_CNAM__c != Null && zipCodeMap2.get(zip).NAM_SAM_CNAM__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).NAM_SAM_CNAM__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).NAM_SAM_CNAM__c);
                        }***/
                    
                        /*if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).Pro_SW_FSR__c != Null && zipCodeMap2.get(zip).Pro_SW_FSR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Pro_SW_FSR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).Pro_SW_FSR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).Pro_SW_ISR__c != Null && zipCodeMap2.get(zip).Pro_SW_ISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Pro_SW_ISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).Pro_SW_ISR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).QP__c != Null && zipCodeMap2.get(zip).QP__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).QP__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).QP__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).R_L_ASR__c != Null && zipCodeMap2.get(zip).R_L_ASR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_ASR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).R_L_ASR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).R_L_FSR__c != Null && zipCodeMap2.get(zip).R_L_FSR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_FSR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).R_L_FSR__c);
                        }
                    
                        /*if(assignmentMatrixMap.get(keyOfAssignmentMatrix).R_L_ISR__c != Null && zipCodeMap2.get(zip).R_L_ISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_ISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix).R_L_ISR__c);
                        }*/
                        
                      /*  if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).SW_ASR__c != Null && zipCodeMap2.get(zip).SW_ASR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).SW_ASR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).SW_ASR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix1).Service_Source__c != Null && zipCodeMap2.get(zip).Service_Source__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Service_Source__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix1).Service_Source__c);
                        }
                    } // end of key1 check
                    if(assignmentMatrixMap.containsKey(keyOfAssignmentMatrix2)){
                    
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).AISR__c != Null && zipCodeMap2.get(zip).AISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).AISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).AISR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).ASR_Indirect_Corp_Software__c != Null && zipCodeMap2.get(zip).ASR_Indirect_Corp_Software__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).ASR_Indirect_Corp_Software__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).ASR_Indirect_Corp_Software__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).Corp_Direct__c != Null && zipCodeMap2.get(zip).Corp_Direct__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Corp_Direct__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).Corp_Direct__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).Corp_Indirect__c != Null && zipCodeMap2.get(zip).Corp_Indirect__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Corp_Indirect__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).Corp_Indirect__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).ISR_Indirect__c != Null && zipCodeMap2.get(zip).ISR_Indirect__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).ISR_Indirect__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).ISR_Indirect__c);
                        }
                        
                        /***if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).NAM_SAM_CNAM__c != Null && zipCodeMap2.get(zip).NAM_SAM_CNAM__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).NAM_SAM_CNAM__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).NAM_SAM_CNAM__c);
                        }
                        ***/
                      /*  if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).Pro_SW_FSR__c != Null && zipCodeMap2.get(zip).Pro_SW_FSR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Pro_SW_FSR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).Pro_SW_FSR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).Pro_SW_ISR__c != Null && zipCodeMap2.get(zip).Pro_SW_ISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Pro_SW_ISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).Pro_SW_ISR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).QP__c != Null && zipCodeMap2.get(zip).QP__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).QP__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).QP__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).R_L_ASR__c != Null && zipCodeMap2.get(zip).R_L_ASR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_ASR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).R_L_ASR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).R_L_FSR__c != Null && zipCodeMap2.get(zip).R_L_FSR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_FSR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).R_L_FSR__c);
                        }
                        
                        /*if(assignmentMatrixMap.get(keyOfAssignmentMatrix).R_L_ISR__c != Null && zipCodeMap2.get(zip).R_L_ISR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).R_L_ISR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix).R_L_ISR__c);
                        }*/
                        
                       /* if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).SW_ASR__c != Null && zipCodeMap2.get(zip).SW_ASR__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).SW_ASR__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).SW_ASR__c);
                        }
                        
                        if(assignmentMatrixMap.get(keyOfAssignmentMatrix2).Service_Source__c != Null && zipCodeMap2.get(zip).Service_Source__c != Null){
                            dtnWithRoleMap.put(zipCodeMap2.get(zip).Service_Source__c+'_'+zip, assignmentMatrixMap.get(keyOfAssignmentMatrix2).Service_Source__c);
                        }
                        
                    
                    
                    }// end of key 2 check to handle All
                
                
                }// end of main if
            }
        }
        return dtnWithRoleMap;
    }
    /*
    
    
    
  /*  public void getSegmentNonSegmentValues(List<Lead> newLeadList) {
        Map<String, Market_Segment_Mapping__c> marketSegmentMap = new Map<String, Market_Segment_Mapping__c>();
        Map<String, Market_Segment_Rules__c> marketSegmentRuleMap = new Map<String, Market_Segment_Rules__c>();
        List<Market_Sub_Segment_Mapping__c> allMarketSubSegmentList = new List<Market_Sub_Segment_Mapping__c>();
        for(Market_Sub_Segment_Mapping__c msm:Market_Sub_Segment_Mapping__c.getAll().values()){
            allMarketSubSegmentList.add(msm);
        }
        for(Market_Segment_Mapping__c ms : Market_Segment_Mapping__c.getall().values()) {
            marketSegmentMap.put(ms.SIC_Code__c, ms);
        }
        for(Market_Segment_Rules__c msr : Market_Segment_Rules__c.getall().values()) {
            marketSegmentRuleMap.put(msr.Segment__c, msr);
        }
        for(Lead l : newLeadList) {
            AccountTriggerHandlerNew objAcntTrigger=new AccountTriggerHandlerNew ();
            l.Market_Segment__c=objAcntTrigger.populateSegmentField(l.SIC_Code__c,l.Market_Segment__c,marketSegmentMap);
            if(l.Market_Segment__c!=NULL)
            l.Market_Sub_Segment__c=objAcntTrigger.populateNonSegmentField(l.SIC_Code__c,l.Market_Segment__c,l.AnnualRevenue,l.NumberOfEmployees,marketSegmentMap,marketSegmentRuleMap,allMarketSubSegmentList)  ;
        }
    }*/

}