/**
@Author: HCL Technologies Pvt Ltd.
@Description: QueryServiceClass class will contain the strings which will be called this org wise.
*/
public with sharing class QueryServiceClass {
    /*
    @Variable: updateAccountAddressStr is String varible.
    @           It is used in UpdateAccountAddressBatchScheduler to query the data for start 
    @           method of UpdateAccountAddressBatch.
    */
    public static String updateAccountAddressStr = 'Select Street_Address__c, State__c, Ship_To_Zip_Postal_Code__c, Ship_To_Street_Line_2__c,'+
                                                    'Ship_To_Street_Line_1__c, Ship_To_State__c, Ship_To_Phone__c, Ship_To_Partner_Number__c,'+ 
                                                    'Ship_To_Fax__c, Ship_To_Country__c, Ship_To_Contact_Name__c, Ship_To_City__c,'+ 'IsNotValid__c,'+
                                                    'Ship_To_Account_Name__c, PostalCode__c, Phone__c, Email__c, ERP_Account_Name__c,'+ 
                                                    'Country__c, City__c, Building_Number__c, Bill_To_Zip_Postal_Code__c, Bill_To_Street_Line_2__c,'+ 
                                                    'Bill_To_Street_Line_1__c, Bill_To_State__c, Bill_To_Phone__c, Bill_To_Partner_Number__c,'+ 
                                                    'Bill_To_Fax__c, Bill_To_Country__c, Bill_To_Contact_Name__c, Bill_To_City__c, Bill_To_Account_Name__c,'+ 
                                                    'Application__c, ApplicationID__c, Account__c,Account__r.RecordTypeId'+
                                                    ' '+ 
                                                    'From Account_X_Reference__c'+
                                                    ' '+
                                                    'where LastModifiedDate=TODAY';
    /*
    @Variable: massUpdateAccountStr is String varible.
    @           It is used in MassUpdateAccountBatchScheduler to query the data for start 
    @           method of MassUpdateAccountBatch.
    */
    public static String massUpdateAccountStr = 'Select '+
                                                'Name,'+
                                                'BillingPostalCode,'+
                                                'Sic,'+ 
                                                'Service_Source__c,'+ 
                                                'SW_ASR__c,'+
                                                'R_L_FSR__c,'+
                                                'R_L_ASR__c,'+ 
                                                'QP__c,'+ 
                                                'Pro_SW_FSR__c,'+ 
                                                'Named_Account__c,'+ 
                                                'Named_Account_Type__c,'+ 
                                                'NAM_SAM_CNAM__c,'+ 
                                                'Market_Sub_Segment__c,'+ 
                                                'Market_Segment__c,'+ 
                                                'IsMassUpdated__c,'+ 
                                                'Inside_Sales__c,'+ 
                                                'Id,'+ 
                                                'DTN_Makeup__c,'+ 
                                                'Corp_Indirect__c,'+ 
                                                'Corp_Direct__c,'+ 
                                                'ARM_National_Account__c,'+ 
                                                'AISR__c,'+
                                                'RecordTypeId,'+
                                                'Inactive__c,'+
                                                'Exclude_Account_Automation__c,'+
                                                'ISR_Indirect__c'+
                                                ' '+
                                                'From Account'+
                                                ' '+
                                                'Where Exclude_Account_Automation__c=false and '+
                                                '(IsMassUpdated__c=true';
    
    /*
    @   Variable: queryToFindAffectedAccounts is String varible.
    @   It is used in ATA_AccountTeamUpdateBatch to query the data for start 
    */
    public static String queryToFindAffectedAccounts = 'SELECT '+
			                                                'Id,'+
			                                                'Name,'+
			                                                'BillingPostalCode,'+
			                                                'RecordTypeId,'+
			                                                'Exclude_Account_Automation__c'+
			                                                ' '+
			                                                'FROM Account'+
			                                                ' '+
			                                                'WHERE Exclude_Account_Automation__c = false AND IsMassUpdated__c = true';
    
    
    public static String dirtyDTNAccounts(set<String>setDirtyZipcodeDTN){
        return 'Select '+
            'BillingPostalCode,'+
            'Sic,'+ 
            'Service_Source__c,'+ 
            'SW_ASR__c,'+
            'R_L_FSR__c,'+
            'R_L_ASR__c,'+ 
            'QP__c,'+ 
            'Pro_SW_FSR__c,'+ 
            'Named_Account__c,'+ 
            'Named_Account_Type__c,'+ 
            'NAM_SAM_CNAM__c,'+ 
            'Market_Sub_Segment__c,'+ 
            'Market_Segment__c,'+ 
            'IsDirty__c,'+ 
            'Inside_Sales__c,'+ 
            'Id,'+ 
            'DTN_Makeup__c,'+ 
            'Corp_Indirect__c,'+ 
            'Corp_Direct__c,'+ 
            'ARM_National_Account__c,'+ 
            'AISR__c'+
            ' '+
            'From Account'+
            ' '+
            'Where IsDirty__c=true OR'+
            ' '+
            'BillingPostalCode in:'+
            setDirtyZipcodeDTN;
    }
    
     /* Added By Usha*/
     
  
   public static String getAccountXReferenceHistory(String accountXrefDate){ 
     return 'Select '+
                       'parentId,'+
                       'oldvalue,'+
                       'newvalue,'+ 
                       'Isdeleted,'+ 
                       'Id,'+
                       'field,'+
                       'createddate,'+ 
                        'createdbyId'+
                           '  '+ 
                        'From Account_X_Reference__History'+
                         '  '+
                         'where createddate >='+
                         accountXrefDate+' '+'AND Field In ('+'\''+'SHIP_TO_STREET_LINE_1__C'+'\''+','+'\''+'SHIP_TO_STREET_LINE_2__C'+'\''+','+'\''+
                         'SHIP_TO_CITY__C'+'\''+','+'\''+'SHIP_TO_STATE__C'+'\''+','+'\''+'Ship_To_Country__c'+'\''+','+'\''+'STREET_ADDRESS__C'+'\''+','+
                         +'\''+'CITY__C'+'\''+','+'\''+'STATE__C'+'\''+','+'\''+'CITY__C'+'\''+','+'\''+'SHIP_TO_ZIP_POSTAL_CODE__C'+'\''+','+'\''+'POSTALCODE__C'+'\''+','+'\''+'Country__c' +'\''+','+'\''+'Created'+'\''+')';
      }
      
      public static String getAccountXReferenceHistoryCount(String accountXrefDate){ 
     return 'Select '+
                       'Count()'+
                       
                        'From Account_X_Reference__History'+
                         '  '+
                         'where createddate >='+
                         accountXrefDate+' '+'AND Field In ('+'\''+'SHIP_TO_STREET_LINE_1__C'+'\''+','+'\''+'SHIP_TO_STREET_LINE_2__C'+'\''+','+'\''+
                         'SHIP_TO_CITY__C'+'\''+','+'\''+'SHIP_TO_STATE__C'+'\''+','+'\''+'Ship_To_Country__c'+'\''+','+'\''+'STREET_ADDRESS__C'+'\''+','+
                         +'\''+'CITY__C'+'\''+','+'\''+'STATE__C'+'\''+','+'\''+'CITY__C'+'\''+','+'\''+'SHIP_TO_ZIP_POSTAL_CODE__C'+'\''+','+'\''+'POSTALCODE__C'+'\''+','+'\''+'Country__c' +'\''+','+'\''+'Created'+'\''+')'+'limit 40000';
      }

    public static String getReplicationMonitorLogQuery(){
        return 'SELECT Id, ObjectID__c, PartnerNetworkRecord_StartDate__c FROM ReplicationMonitoringLog__c WHERE PartnerNetworkRecord_StartDate__c = NULL';
    }
}