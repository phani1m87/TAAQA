/*
 * Controller class for 'TSM_CustomAccountLookup' visualforce page. Has the backend logic for lookup search.
 */
public with sharing class TSM_CustomAccountLookupController {

  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword

  public TSM_CustomAccountLookupController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {

    List<Account> accountList = new List<Account>();
    
    String searchResultFields =  '';
    for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.TSM_LeadConversion_SearchResult_FieldSet.getFields()) {
        searchResultFields += f.getFieldPath() + ', ';
    }
    if(!searchResultFields.containsIgnoreCase('name')) searchResultFields += 'Name, ';
    
    String soql = 'Select '+searchResultFields+' Id From Account '; 

    if(searchString != '' && searchString != null){
        soql = soql +  ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';
        soql = soql +  ' OR SFDC_Account__c LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';

        soql = soql + ' limit 25';
        System.debug(soql);
        accountList =  database.query(soql);
    }
        
    return  accountList; 
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}