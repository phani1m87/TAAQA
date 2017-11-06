/*
 * Author: Salesforce Services
 * Description: Controller extension that assists in getting relation accounts with same Global Ultimate DUNS number.
 *              Used in custom VF related list in Account detail screen.
 */
public without sharing class WK_TAA_RelatedAccountsExtension{
  public Account account {get; set;}
  public Integer noOfRecords{get; set;}
  public Integer size{get;set;}
  public Map<Id,boolean> userRecordAccess {get; set;}
  
  // Constructor
  public WK_TAA_RelatedAccountsExtension(ApexPages.StandardController stdController){    
    this.account = (Account)stdController.getRecord();
  }

  // Initiate Standard set controller
  public ApexPages.StandardSetController relatedAccountSetController {
        get{
            if(relatedAccountSetController == null && this.account != null){                             
                size = 10;
                string queryString = 'Select Id, Name, Type, BillingCity, BillingState, BillingCountry from Account where DAndBCompany.GlobalUltimateDunsNumber=\'' 
                    + this.account.DAndBCompany.GlobalUltimateDunsNumber +'\' and id != \'' + this.account.id + '\' ORDER BY Name';
                relatedAccountSetController = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                relatedAccountSetController.setPageSize(size);
                noOfRecords = relatedAccountSetController.getResultSize();
            }
            return relatedAccountSetController;
        }set;
   } 
   
   // Get Related Accounts
   Public List<Account> getRelatedAccounts(){
       List<SObject> AccountExt;
       List<Account> relatedAccountsList = (List<Account>)relatedAccountSetController.getRecords();
       Set<Id> accountIdSet = (new Map<Id,Account>(relatedAccountsList)).keySet();
       List<Id> accountIdList = new List<Id>();
       accountIdList.addAll(accountIdSet);
       userRecordAccess = new Map<Id, boolean>();
       // Initiate record access to show different icons.
       for (UserRecordAccess recordAccess : 
            [SELECT RecordId, HasReadAccess
                FROM UserRecordAccess 
                WHERE UserId = :UserInfo.getUserId() 
                AND RecordId IN :accountIdList]) {
            userRecordAccess.put(recordAccess.recordId, recordAccess.HasReadAccess);
        }
       return relatedAccountsList;
    }
}