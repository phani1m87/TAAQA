/*
 * Controller class for 'TSM_CustomContactLookup' visualforce page. Has the backend logic for lookup search and filters.
 */
public with sharing class TSM_CustomContactLookupController {

  public List<Contact> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string relatedAccountId{get;set;} // relatedAccound Id

  public TSM_CustomContactLookupController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    relatedAccountId = System.currentPageReference().getParameters().get('relatedAccountId');
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
  private List<Contact> performSearch(string searchString) {

    List<Contact> contactList = new List<Contact>();
    
    String searchResultFields =  '';
    for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.TSM_LeadConversion_SearchResult_FieldSet.getFields()) {
        searchResultFields += f.getFieldPath() + ', ';
    }
    if(!searchResultFields.containsIgnoreCase('name')) searchResultFields += 'Name, ';
    
    String soql = 'Select '+searchResultFields+' Id From Contact '; 

    Boolean runQuery = false;
    if(searchString != '' && searchString != null){
        soql = soql +  ' WHERE ( Name LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';
        soql = soql +  ' OR Email LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';
        soql = soql +  ' OR Phone LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\' )';

        if(relatedAccountId != null && relatedAccountId != ''){
          soql = soql +  ' AND AccountId = \'' +String.escapeSingleQuotes(relatedAccountId) +'\'';
        }
        runQuery = true;
    }else if(relatedAccountId != null && relatedAccountId != ''){
        soql = soql +  ' WHERE AccountId = \'' +String.escapeSingleQuotes(relatedAccountId) +'\'';
        runQuery = true;
    }

    if(runQuery == true){
        soql = soql + ' Order by CreatedDate DESC LIMIT 25';
        System.debug(soql);
        contactList =  database.query(soql);
    }
        
    return  contactList; 
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