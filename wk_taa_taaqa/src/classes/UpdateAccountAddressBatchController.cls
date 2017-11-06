public with sharing class UpdateAccountAddressBatchController {   
    public Account_Address_Automation__c taaCusSet;
    //constructor
    public UpdateAccountAddressBatchController(){
      taaCusSet = Account_Address_Automation__c.getInstance();
       if(taaCusSet == null){
          taaCusSet = Account_Address_Automation__c.getOrgDefaults();
        } 
    }
    
    //check if SAP x reference accounts only contain PO BOX as street address
    @TestVisible
    private boolean xRefOnlyWithPOBox(String poBox){
        System.debug('<<<<<<<<<'+ poBox);
        String s = poBox.toLowerCase();
        //boolean flag = Pattern.matches('^(?:post (?:office )?|p[. ]?o\\.? )?box #?([0-9]+)', s);
        boolean flag = s.contains('po box');
        return flag;
    }
    
    @TestVisible
     private boolean AMSOrSFSXrefOnlyWithPOBox(Account_X_Reference__c ax){
        boolean isStrretLine1POAddress= false;
        boolean isStreetLine2POAddress=false;
        if(ax.Ship_To_Street_Line_1__c!= null && ax.Ship_To_Street_Line_1__c.length()>0) {
           
             isStrretLine1POAddress =xRefOnlyWithPOBox(ax.Ship_To_Street_Line_1__c);
         }
         if(ax.Ship_To_Street_Line_2__c!= null && ax.Ship_To_Street_Line_2__c.length()>0){
             isStreetLine2POAddress =xRefOnlyWithPOBox(ax.Ship_To_Street_Line_2__c);
               System.debug('????????????'+ax.Ship_To_Street_Line_2__c);
         }
         if(isStrretLine1POAddress || isStreetLine2POAddress){
        
            return true;    
        }else{
            return false;
        }
    }
    
    @TestVisible
    private boolean SAPXrefOnlyWithPOBox(Account_X_Reference__c ax){
        if((String.isEmpty(ax.Street_Address__c) || xRefOnlyWithPOBox(ax.Street_Address__c))){
            return true;
        }else{
            return false;
        }
    }
    
    
    public void processAccountXReferenceHistory(List<Account_X_Reference__History>updateAbleAccountXRefsLst, AsyncApexJob  job){
        system.debug('Inside processAccountXReferenceHistory**1');
        Set<Id>parentIds=new Set<Id>();
        Set<Id> accountIds=new Set<Id>();
        Set<Id>historyIds=new Set<Id>();
        Set<Account_X_Reference__c> AccXRefresults=new Set<Account_X_Reference__c>();
        Set<Id> detectedXrefIdList=new Set<Id>();
        List<Account> accountList=new List<Account>();
        List<Account> accountUpdateList=new List<Account>();
        List <Monitoring_Log__c> errorRecordslist= new List <Monitoring_Log__c>();
        Map<Id,Set<Account_X_Reference__c>> accountWithXreferenceMap=new Map<Id,Set<Account_X_Reference__c>>();
        Map<Id,Account_X_Reference__History> accXrefHistoryMap=new Map<Id,Account_X_Reference__History>();
        
        List<Account_X_Reference__c> SAPPostCodeChanges=new List<Account_X_Reference__c>();
        List<Account_X_Reference__c> SFSPostCodeChanges=new List<Account_X_Reference__c>();
        
        /*For getting which exact data is changed*/
        Map<Id,String> accAMSXrefChangedData=new Map<Id,String>();
        Map<Id,String> accSAPXrefChangedData=new Map<Id,String>();
        Map<Id,String> accSFSXrefChangedData=new Map<Id,String>();
        
        List<Account_X_Reference__c> allAccXRefresults;
        
        Set<String> USCountryList=getUScountryList();
        
        for(Account_X_Reference__History accXrefHistory : updateAbleAccountXRefsLst){
            parentIds.add(accXrefHistory.parentId);
        }
         
        if(parentIds.size() > 0)
        {
           
            List<Account_X_Reference__c> accXefListValues = [SELECT Account__c,SFS_Office_Number__c,Application__c,Bill_To_Account_Name__c,Bill_To_City__c,Bill_To_Contact_Name__c,Bill_To_Country__c,
            Bill_To_State__c,Bill_To_Street_Line_1__c,Bill_To_Street_Line_2__c,Bill_To_Zip_Postal_Code__c,City__c,Country__c,CreatedDate,PostalCode__c,
            Ship_To_City__c,Ship_To_Country__c,Ship_To_State__c,Ship_To_Street_Line_1__c,Ship_To_Street_Line_2__c,Ship_To_Zip_Postal_Code__c,State__c,Name,
            Street_Address__c FROM Account_X_Reference__c where Id In:parentIds];
            
            Map<Id, Account_X_Reference__c> mapAccAccountXreference = new map<Id, Account_X_Reference__c>();
            
            // Include Account X-Ref for SFS Only if SFS_Office_Number__c = 0
            for(Account_X_Reference__c accXefObj: accXefListValues){
                  if(accXefObj.Application__c != 'SFS'){
                        system.debug('Not in SFS=======>');
                        mapAccAccountXreference.put(accXefObj.id,accXefObj);
                  }else if(accXefObj.Application__c == 'SFS' && accXefObj.SFS_Office_Number__c == '0'){
                        system.debug('inside SFS=====>');
                        mapAccAccountXreference.put(accXefObj.id,accXefObj);
                  }
            
            }
                  system.debug('====mapAccAccountXreference=====>'+mapAccAccountXreference);
                  
            for(Id accXrefMap : mapAccAccountXreference.keyset())
            {
                String changedFields = '';
                String changedSAPFields = '';
                //for SFS 
                String changedSFSFields = '';
                
                for(Account_X_Reference__History accXrefHistory : updateAbleAccountXRefsLst)
                {
                    System.debug('##: ' + accXrefMap + ' ## ' + accXrefHistory.parentId);
                    if(accXrefMap == accXrefHistory.parentId)
                    {
                        Account_X_Reference__c accXref = mapAccAccountXreference.get(accXrefHistory.parentId);
                        
                        if((accXrefHistory.field == 'SHIP_TO_STREET_LINE_1__C' || accXrefHistory.field == 'SHIP_TO_STREET_LINE_2__C' || accXrefHistory.field == 'SHIP_TO_ZIP_POSTAL_CODE__C' ||
                            accXrefHistory.field == 'SHIP_TO_CITY__C'|| accXrefHistory.field == 'SHIP_TO_STATE__C'|| accXrefHistory.field == 'Ship_To_Country__c' || 
                            accXrefHistory.field == 'Created') && accXref.Application__c == 'AMS')
                        {
                            AccXRefresults.add(accXref);
                            /*For getting which exact data is changed* - start*/
                            changedFields=getChangedAMSOrSFSFields(accXrefHistory,accXref);
                      
                            accAMSXrefChangedData.put(accXref.Account__c,changedFields+' '+ 'In Account-X reference Name='+accXref.Name+','+' Id='+accXref.Id+
                                ','+ 'Application_Type='+accXref.Application__c);
                            system.debug('changedFields=======>'+changedFields); 
                        }
                        // SFS Field change 
                        if((accXrefHistory.field == 'SHIP_TO_STREET_LINE_1__C' || accXrefHistory.field == 'SHIP_TO_STREET_LINE_2__C' || accXrefHistory.field == 'SHIP_TO_ZIP_POSTAL_CODE__C' ||
                            accXrefHistory.field == 'SHIP_TO_CITY__C' || accXrefHistory.field == 'SHIP_TO_STATE__C'|| accXrefHistory.field == 'Ship_To_Country__c' || 
                            accXrefHistory.field == 'Created') && accXref.Application__c == 'SFS')
                        {
                         
                            AccXRefresults.add(accXref);
                            /*For getting which exact data is changed* - start*/
                            changedSFSFields=getChangedAMSOrSFSFields(accXrefHistory,accXref);
                      
                            system.debug('changedSFSFields=========>'+changedSFSFields);
                            if(accXrefHistory.field != 'SHIP_TO_STREET_LINE_1__C' && accXrefHistory.field != 'SHIP_TO_STREET_LINE_2__C' &&
                                accXrefHistory.field != 'SHIP_TO_CITY__C' && accXrefHistory.field != 'SHIP_TO_STATE__C' &&
                                accXrefHistory.field != 'Ship_To_Country__c' && accXrefHistory.field == 'SHIP_TO_ZIP_POSTAL_CODE__C')
                            {
                              SFSPostCodeChanges.add(accXref);
                            }
                      
                            accSFSXrefChangedData.put(accXref.Account__c,changedSFSFields+' '+ 'In Account-X reference Name='+accXref.Name+','+' Id='+accXref.Id+
                                ','+ 'Application_Type='+accXref.Application__c);
                        }else if((accXrefHistory.field == 'STREET_ADDRESS__C'|| accXrefHistory.field == 'CITY__C' ||
                                    accXrefHistory.field == 'STATE__C'|| accXrefHistory.field == 'POSTALCODE__C'|| accXrefHistory.field == 'Country__c'
                                    || accXrefHistory.field == 'Created') && accXref.Application__c == 'SAP')
                        {
                            changedSAPFields = getChangedSAPFields(accXrefHistory,accXref);
                       
                            if (accXrefHistory.field != 'STREET_ADDRESS__C' &&
                                accXrefHistory.field != 'CITY__C' &&
                                accXrefHistory.field != 'STATE__C' &&
                                accXrefHistory.field != 'Country__c' &&
                                accXrefHistory.field == 'POSTALCODE__C')
                            {
                                SAPPostCodeChanges.add(accXref);
                            } 
                            AccXRefresults.add(accXref); 
                            system.debug('changedSAPFields**'+changedSAPFields); 
                            accSAPXrefChangedData.put(accXref.Account__c,changedSAPFields+' '+ 'In Account-X reference Name='+accXref.Name+','+' Id='+accXref.Id+
                                ','+ 'Application_Type='+accXref.Application__c);                
                        }
                    }
                }
            }
        } 
         system.debug('accSAPXrefChangedData======>'+accSAPXrefChangedData);
         system.debug('accSFSXrefChangedData======>'+accSFSXrefChangedData);
         system.debug('accAMSXrefChangedData======>'+accAMSXrefChangedData);
         
        if(AccXRefresults.size()>0){
           for(Account_X_Reference__c accXref:AccXRefresults){
              accountIds.add(accXref.Account__c);
              detectedXrefIdList.add(accXref.Id);
           } 
        }       
        system.debug('detectedXrefIdList========>'+detectedXrefIdList);
         
        //START: SMS-861 change, skip ADM logic if VAR_Account_Flag__c = TRUE  
        if(accountIds.size()>0){
            accountList = [SELECT Id, BillingStreet, RecordTypeId, BillingState, BillingPostalCode, BillingCountry, Billing_County__c, BillingCity, VAR_ACCOUNT_FLAG__C 
                            FROM Account WHERE Id IN: accountIds AND VAR_ACCOUNT_FLAG__c = FALSE];
        }
        //END: SMS-861 change, skip ADM logic if VAR_Account_Flag__c = TRUE 
        allAccXRefresults = [SELECT Account__c,Application__c,Bill_To_Account_Name__c,Bill_To_City__c,Bill_To_Contact_Name__c,Bill_To_Country__c,
        Bill_To_State__c,Bill_To_Street_Line_1__c,Bill_To_Street_Line_2__c,Bill_To_Zip_Postal_Code__c,City__c,Country__c,CreatedDate,PostalCode__c,
        Ship_To_City__c,Ship_To_Country__c,Ship_To_State__c,Ship_To_Street_Line_1__c,Ship_To_Street_Line_2__c,Ship_To_Zip_Postal_Code__c,State__c,Name,
        Street_Address__c FROM Account_X_Reference__c where Account__c IN: accountList AND Id NOT IN: detectedXrefIdList];
         
         system.debug('allAccXRefresults==========>'+allAccXRefresults);
         
        Id accountRecordTypeId = [Select id from RecordType where Name=:taaCusSet.ExcludeCustomerRecordTYpe__c limit 1].Id;
        
        if(accountList.size()>0 && AccXRefresults.size()>0){
           for(Account a:accountList){
             try{
                Set<Account_X_Reference__c> accXrefAMSfList=new Set<Account_X_Reference__c>();  
                Set<Account_X_Reference__c> accXrefSAPfList=new Set<Account_X_Reference__c>();
                Set<Account_X_Reference__c> accXrefSFSList=new Set<Account_X_Reference__c>();
                Set<Account_X_Reference__c> detectedSAPList=new Set<Account_X_Reference__c>();
                Set<Account_X_Reference__c> detectedSFSList=new Set<Account_X_Reference__c>();
               
                Boolean changeInAMS=false;
                Boolean changeInSAP=false;
                Boolean changeInSFS = false;
                Boolean detectedAMS=false;
                Boolean detectedSAP=false;
                Boolean detectedSFS=false;
                Boolean checkForSAPphyisicalAddress=false;
                Boolean checkForSFSphyisicalAddress = false;
                
               for(Account_X_Reference__c accXref:AccXRefresults){
                
                if(a.RecordTypeId!=accountRecordTypeId){ 
                    
                   if(a.Id==accXref.Account__c){
                    
                      Boolean oldAddressAMSContainsPOBOX=false;
                      String newShippingStreet;
                      String changedFieldinfo='';
                      String changedFieldSAPinfo='';
                      // added for SFS
                      String changedFieldSFSinfo= '';
                      
                      if(accXref.Application__c=='AMS'){
                        
                         if(accAMSXrefChangedData.containsKey(accXref.Account__c)){
                             changedFieldinfo=accAMSXrefChangedData.get(accXref.Account__c);
                         }
                         
                        detectedAMS=true;
                        
                        String info=checkForAMSorSFSXrefEmtyField(accXref);
                        system.debug('info========>'+info);
                        if(String.isEmpty(info)){
                            system.debug('Inside AMS** 2');
                            
                            if(String.isNotEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C+' '+accXref.SHIP_TO_STREET_LINE_2__C;
                            }
                            else if(String.isEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                system.debug('Inside AMS** 3');
                                newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C;
                            } 
                            if(String.isNotEmpty(a.BillingStreet)){
                                oldAddressAMSContainsPOBOX=newValueWithoutPOBOX(a.BillingStreet, newShippingStreet);
                                //Account has PO BOX
                               
                                if(xRefOnlyWithPOBox(a.BillingStreet)&& AMSOrSFSXrefOnlyWithPOBox(accXref)){
                                   
                                  
                                   checkForSFSphyisicalAddress=true;
                                   checkForSAPphyisicalAddress = true;
                                 }
                                 
                            }
                            if(!AMSOrSFSXrefOnlyWithPOBox(accXref) || oldAddressAMSContainsPOBOX){
                                system.debug('Inside AMS** 4');
                                if(String.isNotEmpty(a.BillingCountry) && String.isNotEmpty(accXref.Ship_To_Country__c)){
                                    if(USCountryList.contains(a.BillingCountry.toLowerCase()) && (!USCountryList.contains(accXref.Ship_To_Country__c.toLowerCase()))){
                                        errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldinfo,
                                        'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_US_FOREIGN_ADDRESS,job.id));
                                        changeInAMS=false;
                                    }
                                    else if(!USCountryList.contains(a.BillingCountry.toLowerCase()) && (USCountryList.contains(accXref.Ship_To_Country__c.toLowerCase()))){
                                        errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldinfo,
                                        'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_FOREIGN_US_ADDRESS,job.Id));
                                        changeInAMS=false;
                                    }
                                    else {
                                        system.debug('Inside AMS** 5');
                                        accXrefAMSfList.add(accXref);
                                        changeInAMS=true;
                                    }
                                 }
                                 else {
                                    system.debug('Inside AMS** 6');
                                    accXrefAMSfList.add(accXref);
                                    changeInAMS=true;
                                  }
                             }
                             else if(AMSOrSFSXrefOnlyWithPOBox(accXref) || 
                                    !oldAddressAMSContainsPOBOX){
                                     errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_POBOX_ADDRESS,job.Id));
                                     changeInAMS=false;
                                     
                                }
                            }
                              
                            else if(String.isNotEmpty(info)){
                                info=changedFieldinfo+' '+info+'\n'+ 'For Account X reference Id'+' - '+accXref.Id;
                                errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',
                                info, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_MISSING_FIELD,job.Id));
                                changeInAMS=false;
                            }
                         } 
                            
                            system.debug('changeInAMS=====1=>'+changeInAMS);
                            //Checking whether Account already has got AMS record or not - Start
                         if(!detectedAMS && allAccXRefresults.size()>0){
                                for(Account_X_Reference__c allXref:allAccXRefresults){
                                    if(a.Id==allXref.Account__c && allXref.Application__c=='AMS'){
                                       String info=checkForAMSorSFSXrefEmtyField(allXref);
                                       if(String.isNotEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                            newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C+' '+accXref.SHIP_TO_STREET_LINE_2__C;
                                        }
                                        else if(String.isEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                            system.debug('Inside AMS** 3');
                                            newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C;
                                         }
                                        if(String.isEmpty(info) && ( (String.isNotEmpty(a.BillingStreet) && xRefOnlyWithPOBox(a.BillingStreet)) || (String.isNotEmpty(a.BillingStreet)&& (!xRefOnlyWithPOBox(a.BillingStreet) && !AMSOrSFSXrefOnlyWithPOBox(allXref))))){
                                           system.debug('Inside here**1');
                                           changeInAMS=true;
                                        }
                                        if(String.isNotEmpty(info) || ( (String.isNotEmpty(a.BillingStreet) && (xRefOnlyWithPOBox(a.BillingStreet) && AMSOrSFSXrefOnlyWithPOBox(allXref))))){
                                            system.debug('Inside here**2');
                                             changeInAMS=false;
                                        }   
                                     }
                                 }
                            }          
                              //Checking whether Account already has got AMS record or not - End
                              
                           if(accXref.Application__c=='SFS'){
                                    
                                          if(accSFSXrefChangedData.containsKey(accXref.Account__c)){
                                         changedFieldSFSinfo=accSFSXrefChangedData.get(accXref.Account__c);
                                          }
                                          
                                          detectedSFS = true;
                                          detectedSFSList.add(accXref);
                                          String SFSFieldinfo=checkForAMSorSFSXrefEmtyField(accXref);
                                          
                                          system.debug('SFSFieldinfo======>'+SFSFieldinfo);
                                          system.debug('changeInAMS=====>'+changeInAMS);
                                          
                                          // Checking for field is empty or not 
                                          if(String.isEmpty(SFSFieldinfo)){
                                                 system.debug('inside all fields are present');
                                                 
                                                 if(String.isNotEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                                      
                                                    newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C+' '+accXref.SHIP_TO_STREET_LINE_2__C;
                                                
                                                }else if(String.isEmpty(accXref.SHIP_TO_STREET_LINE_2__C)){
                                                
                                                    newShippingStreet=accXref.SHIP_TO_STREET_LINE_1__C;
                                                }
                                                 
                                                 if(String.isNotEmpty(a.BillingStreet)){
                                                       oldAddressAMSContainsPOBOX=newValueWithoutPOBOX(a.BillingStreet, newShippingStreet);
                                                 
                                                            if(xRefOnlyWithPOBox(a.BillingStreet)&& AMSOrSFSXrefOnlyWithPOBox(accXref)){
                                                            checkForSAPphyisicalAddress=true;
                                                            
                                                            }
                                                
                                                }
                                            
                                                if(!AMSOrSFSXrefOnlyWithPOBox(accXref) || oldAddressAMSContainsPOBOX){
                                                      system.debug('Inside AMS** 4');
                                                  if(String.isNotEmpty(a.BillingCountry) && String.isNotEmpty(accXref.Ship_To_Country__c)){
                                                      if(USCountryList.contains(a.BillingCountry.toLowerCase()) && (!USCountryList.contains(accXref.Ship_To_Country__c.toLowerCase()))){
                                                          errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSFSinfo,
                                                          'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_US_FOREIGN_ADDRESS,job.id));
                                                          changeInSFS=false;
                                                      }
                                                      else if(!USCountryList.contains(a.BillingCountry.toLowerCase()) && (USCountryList.contains(accXref.Ship_To_Country__c.toLowerCase()))){
                                                          errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSFSinfo,
                                                          'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_FOREIGN_US_ADDRESS,job.Id));
                                                          changeInSFS=false;
                                                      }
                                                      else {
                                                          system.debug('Inside AMS** 5');
                                                          accXrefSFSList.add(accXref);
                                                          
                                                          changeInSFS=true;
                                                          if(checkForSFSphyisicalAddress){
                                                            changeInAMS=false;
                                                          }
                                                          
                                                      }
                                                   }
                                                   else {
                                                      system.debug('Inside AMS** 6');
                                                      accXrefSFSList.add(accXref);
                                                      changeInSFS=true;
                                                      if(checkForSFSphyisicalAddress){
                                                        changeInAMS=false;
                                                      }
                                                      
                                                   }
                                            
                                                }else if(AMSOrSFSXrefOnlyWithPOBox(accXref) || !oldAddressAMSContainsPOBOX){
                                                      errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSFSinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_POBOX_ADDRESS,job.Id));
                                                changeInSFS=false;
                                                }
                                                  

                                          }else if(String.isNotEmpty(SFSFieldinfo) && !changeInAMS){
                                              SFSFieldinfo=SFSFieldinfo+'\n'+ 'For Account X reference Id'+' - '+accXref.Id;
                                              errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',
                                              SFSFieldinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_MISSING_FIELD,job.Id));  
                                          
                                          }
                                          
                                          /*Zip+4 code changes - start */
                                          system.debug(!changeInAMS+'====='+SFSPostCodeChanges.size()+'SFSPostCodeChanges======>'+SFSPostCodeChanges);
                                           if(SFSPostCodeChanges.size()>0){
                                                for(Account_X_Reference__c sfs4Changes:SFSPostCodeChanges){
                                                    
                                                            if(accXref.Id==sfs4Changes.Id && (!changeInAMS)){
                                                                  if(String.isNotEmpty(accXref.SHIP_TO_ZIP_POSTAL_CODE__C) && String.isNotEmpty(a.BILLINGPOSTALCODE) &&accXref.SHIP_TO_ZIP_POSTAL_CODE__C.length()> 4 && accXref.SHIP_TO_ZIP_POSTAL_CODE__C.substring(0,5)== a.BILLINGPOSTALCODE.substring(0,5)){
                                                            if(accXref.SHIP_TO_ZIP_POSTAL_CODE__C.length() > a.BILLINGPOSTALCODE.length() ){
                                                                errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSFSinfo
                                                                ,'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_4ZIPCODECHANGE,job.Id)); 
                                                                changeInSFS=false;   
                                                                system.debug('inside +4 zip condition 1===>');
                                                            }
                                                            else if(String.isNotEmpty(accXref.SHIP_TO_ZIP_POSTAL_CODE__C) && String.isNotEmpty( a.BILLINGPOSTALCODE)&& accXref.SHIP_TO_ZIP_POSTAL_CODE__C.length()== a.BILLINGPOSTALCODE.length() && a.BILLINGPOSTALCODE.length()>5 ){
                                                              if(accXref.SHIP_TO_ZIP_POSTAL_CODE__C.substring(6,accXref.SHIP_TO_ZIP_POSTAL_CODE__C.length())!= a.BILLINGPOSTALCODE.substring(6,a.BILLINGPOSTALCODE.length())){
                                                                  errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',
                                                                  changedFieldSFSinfo ,'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_4ZIPCODECHANGE,job.Id));
                                                                 changeInSFS=false; 
                                                                  system.debug('inside +4 zip condition 2===>');
                                                          }   
                                                      }   
                                                 }
                                                      }
                                                }
                                                
                                           }
                                          /*Zip+4 code changes - End */
                                          
                              }
                              
                               
                             if(accXref.Application__c=='SAP'){
                                   if(accSAPXrefChangedData.containsKey(accXref.Account__c)){
                                        changedFieldSAPinfo=accSAPXrefChangedData.get(accXref.Account__c);
                                    }
                                    system.debug('changedFieldSAPinfo**'+changedFieldSAPinfo);
                                    detectedSAP=true;
                                    detectedSAPList.add(accXref);
                                    system.debug('Coming inside SAP block****');
                                    String fieldSAPinfo=checkForSAPXrefEmtyField(accXref);  
                                    if(String.isEmpty(fieldSAPinfo)){
                                        newShippingStreet=accXref.STREET_ADDRESS__C;
                                        if(String.isNotEmpty(a.BillingStreet)){
                                           oldAddressAMSContainsPOBOX=newValueWithoutPOBOX(a.BillingStreet,newShippingStreet);
                                         }
                                         
                                        if(!SAPXrefOnlyWithPOBox(accXref) || oldAddressAMSContainsPOBOX){
                                            if(String.isNotEmpty(a.BillingCountry) && String.isNotEmpty(accXref.Country__c)){
                                                if(USCountryList.contains(a.BillingCountry.toLowerCase()) && (!USCountryList.contains(accXref.Country__c.toLowerCase())) && !changeInAMS){
                                                    errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSAPinfo,'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_US_FOREIGN_ADDRESS,job.Id));
                                                    }
                                                    else if(!USCountryList.contains(a.BillingCountry.toLowerCase()) && (USCountryList.contains(accXref.Country__c.toLowerCase()))&& !changeInAMS){
                                                          errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSAPinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_FOREIGN_US_ADDRESS,job.Id));
                                                    }
                                                    else{
                                                      accXrefSAPfList.add(accXref); 
                                                      changeInSAP=true;  
                                                      system.debug('Inside SAP** 1'+checkForSAPphyisicalAddress);
                                                      if(checkForSAPphyisicalAddress){
                                                        changeInAMS=false;
                                                        changeInSFS=false;
                                                      }
                                                   }
                                                }else{
                                                      accXrefSAPfList.add(accXref); 
                                                      changeInSAP=true; 
                                                      system.debug('Inside SAP** 2');
                                                      if(checkForSAPphyisicalAddress){
                                                        changeInAMS=false;
                                                        changeInSFS=false;
                                                      }
                                             }
                                         }
                                         else if(SAPXrefOnlyWithPOBox(accXref) ||!oldAddressAMSContainsPOBOX && !changeInAMS){
                                            errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSAPinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_POBOX_ADDRESS,job.Id));
                                            }
                                         }
                                         // If fields are missing then create monitoring log
                                         else if(String.isNotEmpty(fieldSAPinfo) && !changeInAMS){
                                            fieldSAPinfo=fieldSAPinfo+'\n'+ 'For Account X reference Id'+' - '+accXref.Id;
                                            errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',
                                            fieldSAPinfo, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_MISSING_FIELD,job.Id));    
                                         }
                                         
                                      
                                        /*Zip+4 code changes - start */
                                        if(SAPPostCodeChanges.size()>0){
                                        for(Account_X_Reference__c sap4Changes:SAPPostCodeChanges){
                                            if(accXref.Id==sap4Changes.Id && (!changeInAMS)){
                                            if(String.isNotEmpty(accXref.POSTALCODE__C) && String.isNotEmpty(a.BILLINGPOSTALCODE) &&accXref.POSTALCODE__C.length()> 4 && accXref.POSTALCODE__C.substring(0,5)== a.BILLINGPOSTALCODE.substring(0,5)){
                                                if(accXref.POSTALCODE__C.length() > a.BILLINGPOSTALCODE.length() ){
                                                    errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',changedFieldSAPinfo
                                                    ,'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_4ZIPCODECHANGE,job.Id)); 
                                                    changeInSAP=false;   
                                                }
                                                else if(String.isNotEmpty(accXref.POSTALCODE__C) && String.isNotEmpty( a.BILLINGPOSTALCODE)&& accXref.POSTALCODE__C.length()== a.BILLINGPOSTALCODE.length() && a.BILLINGPOSTALCODE.length()>5 ){
                                                        if(accXref.POSTALCODE__C.substring(6,accXref.POSTALCODE__C.length())!= a.BILLINGPOSTALCODE.substring(6,a.BILLINGPOSTALCODE.length())){
                                                           errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ',
                                                            changedFieldSAPinfo ,'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_4ZIPCODECHANGE,job.Id));
                                                           changeInSAP=false; 
                                                        }   
                                                }   
                                           }
                                        }
                                     }
                                  }
                               /*Zip+4 code changes - End */
                                }
                            }
                        } 
                    }
                    system.debug(accXrefSAPfList+'===>'+changeInAMS+'===>'+changeInsfs+'====>'+changeInSAP);
                    if(changeInAMS){
                        system.debug('From here 1 ****'); 
                        
                        Boolean isAMSSAPmatching=false;
                        Boolean isAMSSFSmatching=false;
                        
                        if(accXrefAMSfList.size()> 0 && accXrefSAPfList.size()>0 && accXrefSFSList.size()>0){
                            system.debug('From here 2 ****');
                             if(comapreAMSorSFSList(accXrefAMSfList) && comapreSAPList(accXrefSAPfList) && comapreAMSorSFSList(accXrefSFSList)){
                                
                                //compare AMS and SAP
                                if(compareAMSWithSAP(accXrefAMSfList,accXrefSAPfList)){
                                       for(Account_X_Reference__c accXref:accXrefAMSfList){
                                           a=updateAMSorSFSAccount(accXref,a);
                                       }  
                                     isAMSSAPmatching=true;
                                }
                                
                                else if(!compareAMSWithSAP(accXrefAMSfList,accXrefSAPfList)){
                                    
                                    for(Account_X_Reference__c accXref:accXrefAMSfList){
                                          a=updateAMSorSFSAccount(accXref,a);
                                    }  
                                    isAMSSAPmatching=false;
                                }
                                
                                //Compare AMS and SFS
                                if(compareAMSWithSFS(accXrefAMSfList,accXrefSFSList)){
                                       for(Account_X_Reference__c accXref:accXrefAMSfList){
                                           a=updateAMSorSFSAccount(accXref,a);
                                       }  
                                     isAMSSFSmatching=true;
                                }
                                
                                else if(!compareAMSWithSFS(accXrefAMSfList,accXrefSFSList)){
                                    
                                    for(Account_X_Reference__c accXref:accXrefAMSfList){
                                          a=updateAMSorSFSAccount(accXref,a);
                                    }  
                                    isAMSSFSmatching=false;
                                }
                                
                             
                                
                             }              
                             
                        }
                       
                      // else if(accXrefAMSfList.size()> 0 && !(accXrefSAPfList.size()> 0)){
                      else if(accXrefAMSfList.size()> 0 && (!(accXrefSAPfList.size()> 0) || !(accXrefSFSList.size()> 0))){
                            system.debug('From here 3 ****'); 
                            if(comapreAMSorSFSList(accXrefAMSfList)){
                                for(Account_X_Reference__c accXref:accXrefAMSfList){
                                   a=updateAMSorSFSAccount(accXref,a);
                                 }  
                            }
                            else if(!comapreAMSorSFSList(accXrefAMSfList)){
                                    String associatedRecors= associatedAccountXrefRecord(accXrefAMSfList);
                                    errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ','Multiple AMS Xref changes detected with differing addresses for AMSX record values'+' '+ associatedRecors, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_AMS_MULTIPLE_ADDRESS,job.Id));
                            }
                        }   
                        
                        if(detectedSAP && !(isAMSSAPmatching) && detectedSAPList.size()>0){
                            system.debug('From here 4 ****');
                            for(Account_X_Reference__c accXref:detectedSAPList){
                                errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ','Changes in SAP X ref has been detected='+accXref.Id+ ', '+ 'Application_c='+accXref.Application__c+','+'STREET_ADDRESS__C='+accXref.STREET_ADDRESS__C+
                             ','+'CITY__C='+accXref.CITY__C+','+'STATE__C='+accXref.STATE__C+','+
                             'POSTALCODE__C='+accXref.POSTALCODE__C+','+'Country__c='+accXref.Country__c, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_SAP_ADDRESS_CHANGE_DETECTED,job.Id));      
                        
                            }   
                        }
                        
                        //Compare AMS and SFS
                        if(detectedSFS && !(isAMSSFSmatching) && detectedSFSList.size()>0){
                            system.debug('From here 4 ****');
                            for(Account_X_Reference__c accXref:detectedSFSList){
                                errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ','Changes in SFS X ref has been detected='+accXref.Id+ ', '+ 'Application_c='+accXref.Application__c+','+'STREET_ADDRESS__C='+accXref.SHIP_TO_STREET_LINE_1__C+' '+accXref.SHIP_TO_STREET_LINE_2__C+
                             ','+'CITY__C='+accXref.SHIP_TO_CITY__C+','+'STATE__C='+accXref.SHIP_TO_STATE__C+','+
                             'POSTALCODE__C='+accXref.SHIP_TO_ZIP_POSTAL_CODE__C+','+'Country__c='+accXref.Ship_To_Country__c, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_SFS_ADDRESS_CHANGE_DETECTED,job.Id));      
                        
                            }   
                        }
                                    
                         accountWithXreferenceMap.put(a.Id,accXrefAMSfList);
                         
                    }else if(!changeInAMS && accXrefSFSList.size()> 0 && changeInSFS){
                        system.debug('inside update SFS Record');
                        
                        if(comapreAMSorSFSList(accXrefSFSList)){
                              for(Account_X_Reference__c accXref :accXrefSFSList){
                                a = updateAMSorSFSAccount(accXref,a);
                              }
                              accountWithXreferenceMap.put(a.Id,accXrefSFSList); 
                        }else if(!comapreAMSorSFSList(accXrefSFSList)){
                                
                            String associatedRecors= associatedAccountXrefRecord(accXrefSFSList);
                            errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ','SFS Xref address changes detected'+'  '+associatedRecors, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_SFS_MULTIPLE_ADDRESS,job.Id));   
                        }
                        
                    }
                    else if(!changeInAMS && accXrefSAPfList.size()> 0 && changeInSAP && !changeInSFS){
                        system.debug('inside SAP==>');
                        if(comapreSAPList(accXrefSAPfList)){
                            for(Account_X_Reference__c accXref:accXrefSAPfList){
                              a=updateSAPAccount(accXref,a);
                            } 
                            accountWithXreferenceMap.put(a.Id,accXrefSAPfList);     
                        }
                        else if(!comapreSAPList(accXrefSAPfList)){
                                
                            String associatedRecors= associatedAccountXrefRecord(accXrefSAPfList);
                            errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account address automation', 'UpdateAccountAddressBatchController ','SAF Xref address changes detected'+'  '+associatedRecors, 'processAccountXReferenceHistory', a.Id,WK_Exception.ADM_EXCEPTION_SAP_MULTIPLE_ADDRESS,job.Id));   
                        }
                    }
                    
                    //For SFS 
                    
                
                    } catch(WK_Exception e){
                      Monitoring_Log__c m = new Monitoring_Log__c();
                      m.Name = 'Account address automation';
                      m.Account__c = a.id;
                      m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                      m.Type__c = WK_Exception.ADM_CODE_ERROR;
                      errorRecordslist.add(m);
                    }
                     catch(Exception e){
                      Monitoring_Log__c m = new Monitoring_Log__c();
                      m.Name = 'Account address automation';
                      m.Account__c = a.id;
                      m.Detail__c = e.getTypeName()+'::line no::'+e.getLineNumber()+'::Error message::'+e.getMessage();
                      m.Type__c = WK_Exception.ADM_CODE_ERROR;
                      errorRecordslist.add(m);
                    }
                     accountUpdateList.add(a);  
                }
            }
       
   
              if(accountUpdateList.size()>0){
                system.debug('Inside Loop 35****'+accountUpdateList);   
                Integer successCounter = 0;
                Integer failureCounter = 0;
                Database.SaveResult[] results = Database.update(accountUpdateList,false);
                    
                for(Database.SaveResult sr : results){
                    if(!sr.isSuccess()){
                      system.debug('Inside failure **'+sr.getErrors());
                       String errorMsg = '';
                       for(Database.Error err : sr.getErrors()){
                             errorMsg += err.getStatusCode() +': '+err.getMessage()+':: while updating account address'+'\n';
                        }
                        failureCounter++;
                        try{
                           errorRecordslist.add(LoggerUtil.createErrorRecord('UpdateAccountAddressBatch','UpdateAccountAddressBatchController',
                           'processAccountXReferenceHistory',errorMsg));
                        }catch(WK_Exception e){
                            errorRecordslist.add(LoggerUtil.createErrorRecord('UpdateAccountAddressBatch','UpdateAccountAddressBatchController',
                             'processAccountXReferenceHistory',errorMsg));
                        }
                      }
                      else{
                        system.debug('Inside Success **');
                          String info='';
                          
                            if(accountWithXreferenceMap.containsKey(sr.getId())){
                                for(Account_X_Reference__c  accountXref:accountWithXreferenceMap.get(sr.getId())){
                                    if(accountXref.Application__c=='AMS'){
                                        if(accAMSXrefChangedData.containsKey(sr.getId())){
                                           // if(accAMSXrefChangedData.get(sr.getId()).Contains('created')){
                                            info=accAMSXrefChangedData.get(sr.getId());
                                        //}
                                    }
                                  }
                                  
                                  else if (accountXref.Application__c=='SAP'){
                                        if(accSAPXrefChangedData.containsKey(sr.getId())){
                                           //if(accSAPXrefChangedData.get(sr.getId()).Contains('created')){
                                            info=accSAPXrefChangedData.get(sr.getId());
                                        //}
                                    }
                                  }
                                    info=info+'\n '+'Address specific fieds from the relevent Account-x-reference are :'+'\n'+'Id='+accountXref.Id+' '+','+'Application_c='+accountXref.Application__c+' '+
                                  +','+'SHIP_TO_STREET_LINE_1__C='+accountXref.SHIP_TO_STREET_LINE_1__C+
                                        ','+'SHIP_TO_STREET_LINE_2__C='+','+accountXref.SHIP_TO_STREET_LINE_2__C+','+'SHIP_TO_CITY__C='+accountXref.SHIP_TO_CITY__C+','+
                                        'SHIP_TO_STATE__C='+accountXref.SHIP_TO_STATE__C+','+
                                         'SHIP_TO_ZIP_POSTAL_CODE__C='+accountXref.SHIP_TO_ZIP_POSTAL_CODE__C+','+'Ship_To_Country__c='+accountXref.Ship_To_Country__c+','+
                                         'SOLD_TO_Street_Address='+accountXref.Street_Address__c+','+'SOLD_TO_City='+accountXref.CITY__C+','+
                                         'SOLD_TO_STATE='+accountXref.STATE__C+','+'SOLD_TO_PostalCode='+accountXref.POSTALCODE__C+','+'SOLD_TO_Country='+accountXref.Country__c;
                                }
                             }
                          
                        
                        
                        
                          if(String.isNotEmpty(info)){
                          errorRecordslist.add(LoggerUtil.createMonitoringLogWithBatchDetails('Account Address automation', 'UpdateAccountAddressBatchController',
                          info , 'updateAccountAddress', sr.getId(),WK_Exception.ADM_ACCOUNT_ADDRESS_UPDATED,job.Id));
                          }
                          successCounter++;
                      }
                  }
                  String errorType;
                   if(!(failureCounter > 0)){
                        errorType=WK_Exception.ADM_ADDRESS_AUTOMATION_JOB_SUCCESS;
                    }
                   else{
                     errorType=WK_Exception.ADM_ADDRESS_AUTOMATION_JOB_WITHERRORS;
                    } 
                     errorRecordslist.add(LoggerUtil.createErrorRecordWithADM('Account address automation','UpdateAccountAddressBatch', 'Apex Job Id -'+' '+job.Id+'\n'+'Job start Date - '+ Job.CreatedDate + '\n'+' Job End date - '+ Job.CompletedDate+'\n'+'No.of Errors -'+Job.NumberOfErrors+'\n'+
                     'No.Of Success records - '+' ' +successCounter+'\n'+'No.Of Error records - '+' '+failureCounter,'processAccountXReferenceHistory', errorType,Job.id));   
                } 
                system.debug('errorRecordslist=======>'+errorRecordslist);
                if(errorRecordslist.size()>0){
                    Database.insert(errorRecordslist,false);
                 } 
            }   
        
  public Boolean newValueWithoutPOBOX(String oldValue, String newAddressLine){
            boolean flag;
                
               if(String.isNotEmpty(oldValue)){ 
                if(xRefOnlyWithPOBox(oldValue)){ //Account has Po Box
                    flag=true;
                }
                if(!xRefOnlyWithPOBox(oldValue) && xRefOnlyWithPOBox(newAddressLine)){
                   flag=false; // Account doest has but the AMS record has
                }
               }
          return flag;
       }        
     
    public static boolean comapreAMSorSFSList(Set<Account_X_Reference__c> accXrefSet){
            boolean comparedValue;
            if(accXrefSet.size()==1){
                comparedValue=true; 
            }
            else if(accXrefSet.size()> 1){
            List<Account_X_Reference__c> accXrefList=new  List<Account_X_Reference__c>();
            accXrefList.addAll(accXrefSet);
            
            boolean streetLine1,streetLine2,shipToCityFlag,shipToStateFlag,shipToPostal,shiptToCountry = false;
            comparedValue=false;
            for(integer i=0;i< accXrefList.size()-1;i++){
                
                if(accXrefList.get(i).SHIP_TO_STREET_LINE_1__C.equalsignorecase(accXrefList.get(i+1).SHIP_TO_STREET_LINE_1__C)){
                    streetLine1=true;
                }else{
                    streetLine1=false;
                }
                
                if(accXrefList.get(i).SHIP_TO_STREET_LINE_2__C != null || accXrefList.get(i+1).SHIP_TO_STREET_LINE_2__C != null){
                      if(accXrefList.get(i).SHIP_TO_STREET_LINE_2__C.equalsignorecase(accXrefList.get(i+1).SHIP_TO_STREET_LINE_2__C)){
                          streetLine2=true;
                      }else{
                          streetLine2=false;
                      }
                }
                
                if(accXrefList.get(i).SHIP_TO_CITY__C.equalsignorecase(accXrefList.get(i+1).SHIP_TO_CITY__C)){
                    shipToCityFlag=true;
                }else{
                    shipToCityFlag=false;
                }
                
                if(accXrefList.get(i).SHIP_TO_STATE__C.equalsignorecase(accXrefList.get(i+1).SHIP_TO_STATE__C)){
                    shipToStateFlag=true;
                    
                }else{
                    shipToStateFlag=false;
               }
                
                if(accXrefList.get(i).SHIP_TO_ZIP_POSTAL_CODE__C.equalsignorecase(accXrefList.get(i+1).SHIP_TO_ZIP_POSTAL_CODE__C)){
                    shipToPostal=true;
                    
                }else{
                    shipToPostal=false;
                       
                }
                
                if(accXrefList.get(i).Ship_To_Country__c.equalsignorecase(accXrefList.get(i+1).Ship_To_Country__c)){
                    shiptToCountry=true;
                }else{
                    shiptToCountry=false;
                      
                }
            }
        
            
            if(streetLine1==false || streetLine2==false || shipToCityFlag==false || shipToStateFlag==false || shipToPostal==false || shiptToCountry==false ){
                comparedValue=false;
            }
            
            else{
                comparedValue=true;
            }
        } 
         return comparedValue;
   }
    
    
    public static boolean comapreSAPList(Set<Account_X_Reference__c > accXrefSet){
            boolean comparedValue;
            if(accXrefSet.size()==1){
                comparedValue=true; 
            }
            else if(accXrefSet.size()> 1){
                List<Account_X_Reference__c> accXrefList=new List<Account_X_Reference__c>();
                accXrefList.addAll(accXrefSet);
                boolean streetAddress,CityFlag,StateFlag,PostalCode,Country = false;
                comparedValue=false;
                for(integer i=0;i<accXrefList.size()-1;i++){
                   
                    if(accXrefList.get(i).STREET_ADDRESS__C.equalsignorecase(accXrefList.get(i+1).STREET_ADDRESS__C)){
                        streetAddress=true;
                    }else{
                       streetAddress=false;
                    }
                    if(accXrefList.get(i).CITY__C.equalsignorecase(accXrefList.get(i+1).CITY__C)){
                        CityFlag=true;
                       
                    }else{
                       CityFlag=false;
                    }
                    
                    if(accXrefList.get(i).STATE__C.equalsignorecase(accXrefList.get(i+1).STATE__C)){
                        StateFlag=true;
                    }else{
                        StateFlag=false;
                    }
                    
                    if(accXrefList.get(i).POSTALCODE__C.equalsignorecase(accXrefList.get(i+1).POSTALCODE__C)){
                        PostalCode=true;
                    }else{
                        PostalCode=false;
                    }
                    
                 if(accXrefList.get(i).Country__c==accXrefList.get(i+1).Country__c){
                        Country=true;
                    }else{
                        Country=false;
                    }
                }
                if(streetAddress==false || CityFlag==false || StateFlag==false || PostalCode==false || Country==false){
                 comparedValue=false;
                }
           
                else{
                    comparedValue=true;
                }
        }
            return comparedValue; 
    }
    
        public  boolean compareAMSWithSAP(Set<Account_X_Reference__c> accXAMSrefList,Set<Account_X_Reference__c> accXSAPrefList){
        
                
                boolean streetAddress,comparedValue,CityFlag,StateFlag,PostalCode,Country = false;
               
                
                for(Account_X_Reference__c amsXrefList:accXAMSrefList){
                    for(Account_X_Reference__c sapXrefList:accXSAPrefList){
                         String Streetline;
                        
                        if(amsXrefList.SHIP_TO_STREET_LINE_1__C!=null && amsXrefList.SHIP_TO_STREET_LINE_2__C!=null){
                         Streetline=amsXrefList.SHIP_TO_STREET_LINE_1__C+' '+amsXrefList.SHIP_TO_STREET_LINE_2__C;
                       }
                
                        else if(amsXrefList.SHIP_TO_STREET_LINE_1__C!=null && amsXrefList.SHIP_TO_STREET_LINE_2__C==null){
                            Streetline=amsXrefList.SHIP_TO_STREET_LINE_1__C;
                        }
                    system.debug(Streetline+'===st=='+sapXrefList.STREET_ADDRESS__C);
                     if(String.isNotEmpty(Streetline) && String.isNotEmpty(sapXrefList.STREET_ADDRESS__C) && (Streetline==sapXrefList.STREET_ADDRESS__C)){
                        streetAddress=true;
                     }
                     system.debug(amsXrefList.SHIP_TO_CITY__C+'===city=='+sapXrefList.CITY__C);
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_CITY__C) && String.isNotEmpty(sapXrefList.CITY__C) && (amsXrefList.SHIP_TO_CITY__C==sapXrefList.CITY__C)){
                        CityFlag=true;
                     }
                    system.debug(amsXrefList.SHIP_TO_STATE__C+'===state=='+sapXrefList.STATE__C);
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_STATE__C) && String.isNotEmpty(sapXrefList.STATE__C) && (amsXrefList.SHIP_TO_STATE__C==sapXrefList.STATE__C)){
                        StateFlag=true;
                     }
                    system.debug(amsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C+'===post=='+sapXrefList.POSTALCODE__C);
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C) && String.isNotEmpty(sapXrefList.POSTALCODE__C) && (amsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C==sapXrefList.POSTALCODE__C)){
                        PostalCode=true;
                     }
                     
                     if(String.isNotEmpty(amsXrefList.Ship_To_Country__c) && String.isNotEmpty(sapXrefList.Country__c) && (amsXrefList.Ship_To_Country__c==sapXrefList.Country__c)){
                        Country=true;
                     }
                }
               }
                if(streetAddress==true && CityFlag==true && StateFlag==true && PostalCode==true && Country==true){
                 comparedValue=true;
                }
                else{
                 comparedValue=false;
                }
            return comparedValue; 
      }
    
    public  boolean compareAMSWithSFS(Set<Account_X_Reference__c> accXAMSrefList,Set<Account_X_Reference__c> accXSFSrefList){
        
                
                boolean streetAddress,comparedValue,CityFlag,StateFlag,PostalCode,Country = false;
               
                
                for(Account_X_Reference__c amsXrefList:accXAMSrefList){
                    for(Account_X_Reference__c sfsXrefList:accXSFSrefList){
                         String Streetline;
                         String Streetlinesfs;
                        if(amsXrefList.SHIP_TO_STREET_LINE_1__C!=null && amsXrefList.SHIP_TO_STREET_LINE_2__C!=null){
                         Streetline=amsXrefList.SHIP_TO_STREET_LINE_1__C+' '+amsXrefList.SHIP_TO_STREET_LINE_2__C;
                        }
                
                        else if(amsXrefList.SHIP_TO_STREET_LINE_1__C!=null && amsXrefList.SHIP_TO_STREET_LINE_2__C==null){
                            Streetline=amsXrefList.SHIP_TO_STREET_LINE_1__C;
                        }
                        
                        if(sfsXrefList.SHIP_TO_STREET_LINE_1__C!=null && sfsXrefList.SHIP_TO_STREET_LINE_2__C!=null){
                              Streetlinesfs=sfsXrefList.SHIP_TO_STREET_LINE_1__C+' '+sfsXrefList.SHIP_TO_STREET_LINE_2__C;
                        }
                
                        else if(sfsXrefList.SHIP_TO_STREET_LINE_1__C!=null && sfsXrefList.SHIP_TO_STREET_LINE_2__C==null){
                            Streetlinesfs=sfsXrefList.SHIP_TO_STREET_LINE_1__C;
                        }
                    
                     if(String.isNotEmpty(Streetline) && String.isNotEmpty(Streetlinesfs) && (Streetline==Streetlinesfs)){
                        streetAddress=true;
                     }
                    
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_CITY__C) && String.isNotEmpty(sfsXrefList.SHIP_TO_CITY__C) && (amsXrefList.SHIP_TO_CITY__C==sfsXrefList.SHIP_TO_CITY__C)){
                        CityFlag=true;
                     }
                    
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_STATE__C) && String.isNotEmpty(sfsXrefList.SHIP_TO_STATE__C) && (amsXrefList.SHIP_TO_STATE__C==sfsXrefList.SHIP_TO_STATE__C)){
                        StateFlag=true;
                     }
                    
                    if(String.isNotEmpty(amsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C) && String.isNotEmpty(sfsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C) && (amsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C==sfsXrefList.SHIP_TO_ZIP_POSTAL_CODE__C)){
                        PostalCode=true;
                     }
                     
                     if(String.isNotEmpty(amsXrefList.Ship_To_Country__c) && String.isNotEmpty(sfsXrefList.Ship_To_Country__c) && (amsXrefList.Ship_To_Country__c==sfsXrefList.Ship_To_Country__c)){
                        Country=true;
                     }
                }
               }
                if(streetAddress==true && CityFlag==true && StateFlag==true && PostalCode==true && Country==true){
                 comparedValue=true;
                }
                else{
                 comparedValue=false;
                }
            return comparedValue; 
      }
    
    
    public String associatedAccountXrefRecord(Set<Account_X_Reference__c> accXrefList){
        String accXRefName='';

        for(Account_X_Reference__c accXref:accXrefList){
            accXRefName=accXRefName+',' +accXref.Id;
        }
         return accXRefName;
    }
     
    public static String checkForAMSorSFSXrefEmtyField(Account_X_Reference__c accXref){
             String info='';
             
             if(String.IsEmpty(accXref.SHIP_TO_STREET_LINE_1__C)){
                    info=info+' Value for SHIP_TO_STREET_LINE_1__C is missing';
              }
                
             if(String.IsEmpty(accXref.SHIP_TO_CITY__C)){
                    info=info+ '\n' +' Value for SHIP_TO_CITY__C is missing';
              }
                
             if(String.IsEmpty(accXref.SHIP_TO_STATE__C)){
                    info=info+ '\n' +' Value for SHIP_TO_STATE__C is missing';
             }
                
             if(String.IsEmpty(accXref.SHIP_TO_ZIP_POSTAL_CODE__C)){
                    info=info+ '\n' +' Value for SHIP_TO_ZIP_POSTAL_CODE__C is missing';
              }
                
            //SMS-861 
            /*          
             if(String.IsEmpty(accXref.Ship_To_Country__c)){
                    info=info+ '\n' +' Value for Ship_To_Country__c is missing';
              }
            */
            //SMS-861 
             return info;
    }
    
    public static String checkForSAPXrefEmtyField(Account_X_Reference__c accXref)
    {
         String info='';
          
         if(String.IsEmpty(accXref.STREET_ADDRESS__C)){
            info=info+'Value for STREET_ADDRESS__C is missing';
          }
         if(String.IsEmpty(accXref.CITY__C)){
            info=info+ '\n' +' Value for CITY__C is missing';
         }
         
         if(String.IsEmpty(accXref.STATE__C)){
           info=info+ '\n' +' Value for STATE__C is missing';
         }
                
        if(String.IsEmpty(accXref.POSTALCODE__C)){
           info=info+ '\n' +' Value for POSTALCODE__C is missing';
        }
       //SMS-861 
       /*        
       if(String.IsEmpty(accXref.Country__c)){
          info=info+ '\n' +' Value for Country__c is missing';
        }
       */ 
       //SMS-861
        return info;
   }  
     
    
     public Account updateAMSorSFSAccount(Account_X_Reference__c accXref, Account account){
        Account a=account;
        
        if(String.isNotEmpty((accXref.SHIP_TO_STREET_LINE_2__C))){
           a.BILLINGSTREET=accXref.SHIP_TO_STREET_LINE_1__C+' ' +accXref.SHIP_TO_STREET_LINE_2__C;
         }
        else{
          a.BILLINGSTREET=accXref.SHIP_TO_STREET_LINE_1__C;
        }
        a.BILLINGCITY=accXref.SHIP_TO_CITY__C;
        a.BILLINGSTATE=accXref.SHIP_TO_STATE__C;
        a.BILLINGPOSTALCODE=accXref.SHIP_TO_ZIP_POSTAL_CODE__C;
        a.BillingCountry=accXref.Ship_To_Country__c;
        a.Id=accXref.Account__c;
        return a;             
     }
     
     public Account updateSAPAccount(Account_X_Reference__c accXref,Account account){
         Account a=account;
         a.BILLINGSTREET=accXref.STREET_ADDRESS__C;
         a.BILLINGCITY=accXref.CITY__C;
         a.BILLINGSTATE=accXref.STATE__C;
         a.BILLINGPOSTALCODE=accXref.POSTALCODE__C;
         a.BillingCountry=accXref.Country__c;
         a.Id=accXref.Account__c;
         return a; 
    }
    
    public set<String> getUScountryList(){
        Set<String> USCountryList=new Set<String>();
        USCountryList.add('us');
        USCountryList.add('usa');
        USCountryList.add('united states');
        
        return USCountryList;
    }
    
    public String getChangedAMSOrSFSFields(Account_X_Reference__History accXrefHistory,Account_X_Reference__c accXref){
        String changedFields='';
        
        if(accXrefHistory.field=='Created'){
            if(String.isNotEmpty(accXref.SHIP_TO_STREET_LINE_1__C )&& String.isNotEmpty(accXref.SHIP_TO_ZIP_POSTAL_CODE__C) && String.isNotEmpty(accXref.SHIP_TO_CITY__C) && 
                 String.isNotEmpty(accXref.SHIP_TO_STATE__C) && String.isNotEmpty(accXref.Ship_To_Country__c)){
                 // For AMS or SFS 
                 changedFields= accXref.Application__c +'record is created with following details'+
                 ' SHIP_TO_STREET_LINE_1__C='+accXref.SHIP_TO_STREET_LINE_1__C+','+
                 ' SHIP_TO_STREET_LINE_2__C='+accXref.SHIP_TO_STREET_LINE_2__C+
                 ' SHIP_TO_ZIP_POSTAL_CODE__C='+accXref.SHIP_TO_ZIP_POSTAL_CODE__C+
                 ' SHIP_TO_CITY__C='+accXref.SHIP_TO_CITY__C+
                 ' SHIP_TO_STATE__C='+accXref.SHIP_TO_STATE__C;                   
             }
       }
        
        if(accXrefHistory.field=='SHIP_TO_STREET_LINE_1__C'){
            changedFields=changedFields+'SHIP_TO_STREET_LINE_1__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
        }
        if(accXrefHistory.field=='SHIP_TO_STREET_LINE_2__C'){
           changedFields=changedFields+'SHIP_TO_STREET_LINE_2__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
        }
        if(accXrefHistory.field=='SHIP_TO_ZIP_POSTAL_CODE__C'){
          changedFields=changedFields+'SHIP_TO_ZIP_POSTAL_CODE__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
        }
        if(accXrefHistory.field=='SHIP_TO_CITY__C'){
           changedFields=changedFields+'SHIP_TO_CITY__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
        }
        if(accXrefHistory.field=='SHIP_TO_STATE__C'){
         changedFields=changedFields+'SHIP_TO_STATE__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
        }
        if(accXrefHistory.field=='Ship_To_Country__c'){
        changedFields=changedFields+'Ship_To_Country__c value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
       }     
       
       return  changedFields;        
    }
    
  public String getChangedSAPFields(Account_X_Reference__History accXrefHistory,Account_X_Reference__c accXref ){   
    String changedSAPFields='';
    if(accXrefHistory.field=='Created'){
       if(String.isNotEmpty(accXref.STREET_ADDRESS__C )&& String.isNotEmpty(accXref.CITY__C) && String.isNotEmpty(accXref.STATE__C) && 
          String.isNotEmpty(accXref.POSTALCODE__C) && String.isNotEmpty(accXref.Country__c)){
          changedSAPFields='SAP record is created with following details'+
          ' STREET_ADDRESS__C='+accXref.STREET_ADDRESS__C+','+
          ' CITY__C='+accXref.CITY__C+
         ' STATE__C='+accXref.STATE__C+
          ' POSTALCODE__C='+accXref.POSTALCODE__C+
           'Country__c='+accXref.Country__c;
        }
    }
    if(accXrefHistory.field=='STREET_ADDRESS__C'){
     changedSAPFields=changedSAPFields+'STREET_ADDRESS__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
    }
    if(accXrefHistory.field=='CITY__C'){
    changedSAPFields=changedSAPFields+'CITY__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
    }
    if(accXrefHistory.field=='STATE__C'){
     changedSAPFields=changedSAPFields+'STATE__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
    }
    if(accXrefHistory.field=='POSTALCODE__C'){
      changedSAPFields=changedSAPFields+'POSTALCODE__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
    }
    if(accXrefHistory.field=='Country__c'){
     changedSAPFields=changedSAPFields+'SHIP_TO_STATE__C value is changed from '+accXrefHistory.OldValue +' To '+accXrefHistory.NewValue+'\n';
    }  
    
    return changedSAPFields;               
  }
}