public with sharing class searchSolutionController {
    public String searchString {get; set;}
    public Integer offsetCounter{get; set;}
    public Integer pageSize{get;set;}
    public Integer listSize{get;set;}
    private ApexPages.StandardController controller {get; set;}

    public List<Solution>solutionList = new List<Solution>();
    public List<Solution>getsolutionList(){
     System.debug('Getter is called'+solutionList.size());
     return solutionList ;
    }
    public void setsolutionList(List<Solution> solutionList){
     this.solutionList= solutionList;
    }
    public Boolean isFilterOn{get; set;}
    public String product {get; set;}
    public String category {get; set;}
    public String businessSegment {get; set;}
    public String professionalClientServicesTopics {get; set;}
    public Boolean isSearchStringblank{get; set;}
    
    
    public searchSolutionController(ApexPages.StandardController controller) {
    this.controller= controller;
     isSearchStringblank= true;
     offsetCounter=0;
     isFilterOn= false;
     pageSize=2;
    }
    public void findSolution(){
      isSearchStringblank= true;
     if(String.isNotBlank(searchString)&& searchString.length()>2){
        System.debug('Value of offset Counter>>>>>>>>>>'+offsetCounter);
        System.debug('Value for Search String to be searched==='+searchString);
        isSearchStringblank= false;
     String applyFilter =''; 
     //System.debug('????????????????Sol Business Segment????????????????'+ sol.Business_Segment__c);
     if((String.isBlank(product)|| product.equals('--None--')) && (String.isBlank(category)|| category.equals('--None--')) && (String.isBlank(businessSegment)|| businessSegment.equals('--None--'))&& (String.isBlank(professionalClientServicesTopics)||professionalClientServicesTopics.equals('--None--'))){
       isFilterOn= false;
     }else{
      isFilterOn= true;
     }
     if(isFilterOn){
        System.debug('??????????Filter is on???????????');
       if(String.isnotBlank(product)&& product!='--None--')
         applyFilter+= ( applyFilter=='' ? 'Where' : 'AND' )+ ' '+'Products__c=' + '\''+product+'\''; 
       if(String.isNotBlank(category)&& category!='--None--')
         applyFilter+= ( applyFilter=='' ? 'Where' : 'AND') + ' ' + 'Category__c = '+ '\''+category+'\'';
       if(String.isNotBlank(businessSegment) &&  businessSegment!='--None--')  
        applyFilter+= (applyFilter=='' ? 'Where': 'AND') + ' '+  'Business_Segment__c='+'\''+businessSegment+'\'' ;
       if(String.isNotBlank(professionalClientServicesTopics ) && professionalClientServicesTopics!='--None--')  
         applyFilter+= (applyFilter==''? 'Where' : 'AND') +' ' + 'Professional_Client_Services__c='+ '\''+professionalClientServicesTopics+'\'';
         
     }
     String searchquery= 'Find {'+ searchString+ '} IN ALL FIELDS RETURNING Solution(Id,SolutionNote,SolutionName,Business_Segment__c,Category__c,Products__c,Professional_Client_Services__c' + ' ' + applyFilter +' Limit '+pageSize+' Offset '+ offsetCounter+')';
     System.debug('<<<<<<<<<Query for Search is>>>>>>>>>> '+ searchquery);
     String searchquery2= 'Find {'+ searchString+ '} IN ALL FIELDS RETURNING Solution(Id,SolutionNote,SolutionName,Business_Segment__c,Category__c,Products__c,Professional_Client_Services__c' + ' ' + applyFilter + ')';
     List<List<sObject>> ListOfListOfSObjects = search.query(searchquery);
     if(ListOfListOfSObjects[0]!= null){
         solutionList= ListOfListOfSObjects[0];
         if(solutionList.size()==0){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Record Found based on your search criterion');
             ApexPages.addMessage(myMsg);
         }
     }
     List<List<sObject>> listOfListOfSobjectwithoutLimit= search.query(searchquery2);
      if(listOfListOfSobjectwithoutLimit[0]!= null){
       listsize= listOfListOfSobjectwithoutLimit[0].size();
      }
    } else if(String.isBlank(searchString) || searchString.length()==1){
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter a search string at least 2 characters long');
      ApexPages.addMessage(myMsg);
    }
   // return null;
    }
    public List<SelectOption> getBusinessSegments(){
      List<SelectOption> options = new List<SelectOption>();        
      options= getOptionsListforfieldType('Business_Segment__c');
      return options;
    }
    public List<SelectOption> getCategories(){
      List<SelectOption> options = new List<SelectOption>();        
      options= getOptionsListforfieldType('Category__c');
      return options;
    }
    public List<SelectOption> getProducts(){
      List<SelectOption> options = new List<SelectOption>();        
      options= getOptionsListforfieldType('Products__c');
      return options;
    }
    public List<SelectOption> getProfessionalClientsServices(){
      List<SelectOption> options = new List<SelectOption>();        
      options= getOptionsListforfieldType('Professional_Client_Services__c');
      return options;
    }
    
   public List<SelectOption> getOptionsListforfieldType(String fieldname){
     List<SelectOption> options = new List<SelectOption>();
     options.add(new SelectOption('--None--','--None--'));       
     Schema.DescribeFieldResult fieldResult =Schema.sObjectType.Solution.fields.getMap().get(fieldname).getDescribe();  
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
     for( Schema.PicklistEntry f : ple){
      options.add(new SelectOption(f.getLabel(), f.getValue()));
     }       
   return options;
   }
   public void next(){
    if (offsetCounter+pagesize< listSize){
     offsetCounter= offsetCounter+ pagesize;
     findSolution();
    }
   } 
    public void previous(){
    if(offsetCounter-pagesize>=0){
      offsetCounter= offsetCounter-pagesize;
      findSolution();
    }
    }
   
 }