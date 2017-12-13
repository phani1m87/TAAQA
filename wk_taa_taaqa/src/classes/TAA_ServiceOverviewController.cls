/*
 * Controller for TAAServiceOrg Page - fetches necessary information from TAA Service Org
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 06/14/2017 SHIVAJI           1.0          Initial Draft
 * 08/22/2017 SHIVAJI			1.0			 Create Case Requirement(SMS-864)
 * ------------------------------------------------------------------------- */
public with sharing class TAA_ServiceOverviewController 
{
	public String setXRef {get; set;}
	public Account currentAccount {get; set;}
	
	public String showCases {get; set;}
	//public String showChart {get; set;}
	public String showCaseDetail {get; set;}
	public Boolean isError {get; set;}
	
	public String selectedDateRange {get; set;}
	public String numberOfDays {get; set;}
	public String selectedCaseId {get; set;}
	public String accountNumber {get; set;}
	public String productFamilyName {get; set;}
	public String selectedERPAccount {get; set;}
	
	public List<SelectOption> lstAccountNumbers {get; set;}
	public List<SelectOption> lstProductFamilies {get; set;}
	public TAA_ServiceOverviewController.CaseResponse productFamilyResponse {get; set;}
	public TAA_ServiceOverviewController.CaseResponse caseListResponse {get; set;}
	public TAA_ServiceOverviewController.CaseWithCommentsResponse caseDetailWithComments {get; set;}
	public List<Data> lstCategoryChartData {get; set;}
	public List<Data> lstProductFamilyChartData {get; set;}
	
	public OauthUtil.OAuth2 objAuthenticationInfo;
	
	public String openEscalationCount {get; set;}
	public String openCaseCount {get; set;}
	public String last90DaysCaseCount {get; set;}
	
	public integer maximumSteps {get; set;}
	
	//Create Case Section
	public String showCreateCase {get; set;}
	
	public String accountType {get; set;}
	public String customerType {get; set;}
	public String contactChoice {get; set;}
	public String contactFirstName {get; set;}
	public String contactLastName {get; set;}
	public String contactEmail {get; set;}
	public String contactPhone {get; set;}
	public String bestTimeToContact {get; set;}
	public String severity {get; set;}
	public String escalation {get; set;}
	public String orderNumber {get; set;}
	public String invoiceNumber {get; set;}
	public String productId {get; set;}
	public String featureId {get; set;}
	public String contactReason {get; set;}
	public String issueReason {get; set;}
	public Boolean isVisibleToCustomer {get; set;}
	public Boolean isProductEnhancementRequest {get; set;}
	public String strSubject {get; set;}
	public String strDescription {get; set;}
	public String internalComment {get; set;}
	
	List<Support_Site_Product_Details__c> lstSupportSiteProductSeed;
	Map<String, Support_Site_Product_Details__c> mapSupportSiteProductSeed;
	List<Support_Site_Feature_Details__c> lstSupportSiteFeatureSeed;
	public List<SelectOption> lstSupportSiteProducts {get; set;}
	public List<SelectOption> lstSupportSiteFeatures {get; set;}
	public List<SelectOption> lstSupportSiteContactReason {get; set;}
	public List<SelectOption> lstSupportSiteIssueReason {get; set;}
	public List<SelectOption> lstSupportSiteAccountType {get; set;}
	public List<SelectOption> lstSupportSiteCustomerType {get; set;}
	public List<SelectOption> lstSupportContactChoice {get; set;}
	public List<SelectOption> lstSeverity {get; set;}
	public List<SelectOption> lstEscalation {get; set;}
	Map<String, String> mapAccountNumberNSourceSystem;
	
	//IIB Callout
	private AsyncIIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_elementFuture createCaseServiceResponse;
	
	private IIB_TAAServiceSiteCreateCase_V4.UUIDMetaDataRequestType uuidMetaDataRequest;
	private IIB_TAAServiceSiteCreateCase_V4.CaseInfoType caseInfo;
	private IIB_TAAServiceSiteCreateCase_V4.parametersForRoutingType parametersForRouting;
	
	public IIB_TAAServiceSiteCreateCase_V4.CreateCaseResponse_element response {get; set;}
	
	private IIB_TAAServiceSiteCreateCase_V4.CreateCaseRequestWrapper objRequest;
	
	transient List<sobject> logList;
	private Long startTime;
	private Long totalTime;
	
	private User currentUser;
	//Create Case Section
	
	//Update Case
	public Boolean isCaseCommentPublic {get; set;}
	public String caseCommentBody {get; set;}
	private String caseEscalationLevel; 
	//Update Case
	
	public TAA_ServiceOverviewController(ApexPages.StandardController stdController)
	{
		this.currentAccount = (Account) stdController.getRecord();
		currentAccount = [SELECT Id, Name, CreatedDate, LastModifiedDate FROM Account WHERE Id =: currentAccount.Id];
		currentUser = [SELECT Name, FirstName, LastName, Phone, Email, UserRole.Name, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		isError = false;
		showCases = 'no';
		//showChart = 'no';
		showCaseDetail = 'no';
		//These date fields are used just to make sure data picker works in all browsers, we are not updating this back to Account
		currentAccount.Audit_Competitor_End_Date__c = System.Today().addDays(-90);
		currentAccount.Axcess_Tax_Competitor_End_Date__c = System.Today();
		selectedDateRange = '90';
		numberOfDays = '90';
		selectedERPAccount = 'All';
		accountNumber = '';
		openEscalationCount = 'Not Available';
		openCaseCount = 'Not Available';
		last90DaysCaseCount = 'Not Available';
		
		lstEscalation = new List<SelectOption>();
		lstEscalation.add(new SelectOption('', 'NONE'));
		lstEscalation.add(new SelectOption('E4', 'Support Supervisor'));
		if(!String.isBlank(currentUser.UserRole.Name))
		{
			if(currentUser.Profile.Name.contains('System Administrator') || currentUser.Profile.Name.contains('Sales Manager') || currentUser.UserRole.Name.contains('Supervisor') || currentUser.UserRole.Name.contains('Manager') || currentUser.UserRole.Name.contains('Director') || currentUser.UserRole.Name.contains('VP') || currentUser.UserRole.Name.contains('Vice President')){
				lstEscalation.add(new SelectOption('E3', 'Support Manager'));
			}
			if(currentUser.Profile.Name.contains('System Administrator') || currentUser.UserRole.Name.contains('Director') || currentUser.UserRole.Name.contains('VP') || currentUser.UserRole.Name.contains('Vice President')){
				lstEscalation.add(new SelectOption('E2', 'Support Director'));
			}
			if(currentUser.Profile.Name.contains('System Administrator') || currentUser.UserRole.Name.contains('VP') || currentUser.UserRole.Name.contains('Vice President')){
				lstEscalation.add(new SelectOption('E1', 'Support VP'));	
			}
		}
	}
	
	public void invokeGetCases()
	{
		List<Account_X_Reference__c> lstXRef = [SELECT Name, Application__c FROM Account_X_Reference__c WHERE Account__c =: currentAccount.Id];
		if(lstXRef.size() > 0){
			mapAccountNumberNSourceSystem = new Map<String, String>();
			lstAccountNumbers = new List<SelectOption>();
			lstAccountNumbers.add(new SelectOption('', 'ALL'));
			setXRef = '(';
			for(Account_X_Reference__c objXRef : lstXRef)
			{
				lstAccountNumbers.add(new SelectOption(objXRef.Name, objXRef.Name));
				setXRef = setXRef + '\'' + objXRef.Name + '\',';
				mapAccountNumberNSourceSystem.put(objXRef.Name, objXRef.Application__c);
			}
			setXRef = setXRef.subString(0, setXRef.length() - 1);
			setXRef = setXRef + ')';
			//System.debug('##: ' + setXRef);
			if(lstProductFamilies == NULL || lstProductFamilies.size() == 0){
				getProductFamilyList();
			}
			
			if(lstProductFamilies != NULL && lstProductFamilies.size() > 0){
				fetchListOfCases();
			}
		}else{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no Account X-Ref associated with this account.'));
		}
	}
	
	public void getProductFamilyList()
	{
		try{
			if(objAuthenticationInfo == NULL){
				objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg');			
			}
			
			if(objAuthenticationInfo.access_token != null)
	        {
	        	Http h = new Http();
				String endPoint = objAuthenticationInfo.instance_url + '/services/data/v40.0/query?q=SELECT+Id,Name+FROM+Product_Family__c';
				
				Map<String, String> headerMap = new Map<String, String>();
				headerMap.put('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
				
				HttpRequest req = ReSTWebserviceUtility.getHttpRequest('GET', headerMap, 120000, endPoint, NULL);
				
				if(req != NULL)
				{					
					HttpResponse res = h.send(req);
					system.debug('RESPONSE_BODY ' + res.getBody());
					if(res.getStatusCode() == 200)
					{
						productFamilyResponse = (TAA_ServiceOverviewController.CaseResponse)JSON.deserialize(res.getbody(), TAA_ServiceOverviewController.CaseResponse.class);
						lstProductFamilies = new List<SelectOption>();
						lstProductFamilies.add(new SelectOption('', 'ALL'));
						for(AccountRecords obj : productFamilyResponse.records)
						{
							if(!String.isBlank(obj.Name)){
								lstProductFamilies.add(new SelectOption(obj.Id, obj.Name));
							}
						}				
					}else{
						isError = true;
	        			if(res.getStatus().contains('Not Found')){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
	        			}else{
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
	        			}
					}
				}       
	        }else{
	        	isError = true;
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
	        }
		}catch(Exception e){
			isError = true;
        	if(e.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please get System Administrator to check if ' + objAuthenticationInfo.instance_url + ' is configured in Setup->Security->Remote site setting'));
			}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + e.getMessage()));
			}
		}
	}
	
	public void fetchListOfCases()
	{
		try{
			if(objAuthenticationInfo == NULL){
				objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg'); 
			}
			
			System.debug('###: ' + Date.valueOf(currentAccount.Audit_Competitor_End_Date__c));
			System.debug('###: ' + Date.valueOf(currentAccount.Axcess_Tax_Competitor_End_Date__c));
			Integer dateDifference = Date.valueOf(currentAccount.Audit_Competitor_End_Date__c).daysBetween(Date.valueOf(currentAccount.Axcess_Tax_Competitor_End_Date__c));
			System.debug('###: ' + Date.valueOf(currentAccount.Axcess_Tax_Competitor_End_Date__c)); 
			if(dateDifference != 30 && dateDifference != 60 && dateDifference != 90)
			{
				selectedDateRange = '';
			}
			numberOfDays = String.valueOf(dateDifference);
	        if(objAuthenticationInfo.access_token != null)
	        {
				String endPoint = objAuthenticationInfo.instance_url + '/services/data/v40.0/query?q=SELECT+Id,+(SELECT+Id,ContactEmail,Escalation__c,Support_Category__c,Support_Product_Family_Name__c,Support_Product_Name__c,IsClosed,CaseNumber,CreatedDate,LastModifiedDate,Contact.Name,Product.Name,Account.AccountNumber,Description,Status+FROM+Cases+CASEWHERECLAUSE)+FROM+Account+ACCOUNTWHERECLAUSE';
				String caseWhereClause = '';
				String accountWhereClause = '';
				if(!String.isBlank(selectedDateRange)){
					caseWhereClause = 'WHERE+CreatedDate+=+LAST_N_DAYS:' + selectedDateRange;
					currentAccount.Audit_Competitor_End_Date__c = System.Today().addDays(-integer.valueOf(selectedDateRange));
					currentAccount.Axcess_Tax_Competitor_End_Date__c = System.Today();
					numberOfDays = selectedDateRange;
				}else if(currentAccount.Audit_Competitor_End_Date__c != NULL && currentAccount.Axcess_Tax_Competitor_End_Date__c != NULL){
					String frmDate = String.valueOf(Date.valueOf(currentAccount.Audit_Competitor_End_Date__c)) + 'T00:00:00.000%2B0000';
					String toDateStr = String.valueOf(Date.valueOf(currentAccount.Axcess_Tax_Competitor_End_Date__c)) + 'T00:00:00.000%2B0000';
					caseWhereClause	= 'WHERE+CreatedDate+>=+' + frmDate + '+AND+CreatedDate+<=+' + toDateStr;
				}
				
				if(!String.isBlank(productFamilyName)){
					if(!String.isBlank(caseWhereClause)){
						caseWhereClause = caseWhereClause + '+AND+';
					}else{
						caseWhereClause = caseWhereClause + 'WHERE+';
					}
					caseWhereClause = caseWhereClause + 'Support_Product_Family__c+=+\'' + productFamilyName + '\'';
				}
				
				if(!String.isBlank(accountNumber)){
					selectedERPAccount = accountNumber;
					accountWhereClause = 'WHERE+Source_System_Account_Id__c+IN+(\'' + accountNumber + '\')';
				}else{
					accountWhereClause = 'WHERE+Source_System_Account_Id__c+IN+' + setXRef;
					selectedERPAccount = 'All';
				}
				 
				if(!String.isBlank(caseWhereClause)){
					caseWhereClause = caseWhereClause.replace(' ', '+');
					endPoint = endPoint.replace('CASEWHERECLAUSE', caseWhereClause);
				}
				if(!String.isBlank(accountWhereClause)){
					accountWhereClause = accountWhereClause.replace(' ', '+');
					endPoint = endPoint.replace('ACCOUNTWHERECLAUSE', accountWhereClause);
				}
				
				Http h = new Http();
	        	
	        	Map<String, String> headerMap = new Map<String, String>();
				headerMap.put('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
								
				HttpRequest req = ReSTWebserviceUtility.getHttpRequest('GET', headerMap, 120000, endPoint, NULL);
				
				if(req != NULL){
					HttpResponse res = h.send(req);
					
					system.debug('RESPONSE_BODY ' + res.getBody());
					if(res.getStatusCode() == 200)
					{
						caseListResponse = (TAA_ServiceOverviewController.CaseResponse)JSON.deserialize(res.getbody(), TAA_ServiceOverviewController.CaseResponse.class);
						buildChartData();					
						showCases = 'yes';
					}else{
						isError = true;
						if(res.getStatus().contains('Not Found')){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
	        			}else{
		        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
						}	
					}
				}       
	        }else{
	        	isError = true;
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
	        }
		}catch(Exception e){
			isError = true;
        	if(e.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please get System Administrator to check if ' + objAuthenticationInfo.instance_url + ' is configured in Setup->Security->Remote site setting'));
			}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + e.getMessage()));
			}
		}
	}
	
	public void buildChartData()
	{
		if(caseListResponse != NULL && caseListResponse.records != NULL && caseListResponse.records.size() > 0)
		{
			integer countOpenEscalation = 0;
			integer countOpenCases = 0;
			integer countLast90DaysCases = 0;
			lstCategoryChartData = new List<Data>();
			lstProductFamilyChartData = new List<Data>();
			Map<String, Integer> mapSupportCategoryCaseCount = new Map<String, Integer>();
			Map<String, Integer> mapProductFamilyCaseCount = new Map<String, Integer>(); 
			for(AccountRecords objAccount : caseListResponse.records)
			{
				if(objAccount.Cases != NULL)
				{
					for(Case objCase : objAccount.Cases.records)
					{
						if(!objCase.IsClosed){
							countOpenCases++;
							if(objCase.Escalation__c != NULL && !String.valueOf(objCase.Escalation__c).equalsIgnoreCase('None') && !String.isBlank(objCase.Escalation__c)){
								countOpenEscalation++;
							}
						}
						
						if(objCase.CreatedDate >= System.Today().addDays(-90)){
							countLast90DaysCases++;
						}
						
						if(!String.isBlank(objCase.Support_Category__c)){
							if(!mapSupportCategoryCaseCount.containsKey(objCase.Support_Category__c))
							{
								mapSupportCategoryCaseCount.put(objCase.Support_Category__c, 1);	
							}else{
								mapSupportCategoryCaseCount.put(objCase.Support_Category__c, mapSupportCategoryCaseCount.get(objCase.Support_Category__c) + 1);
							}
						}
						if(!String.isBlank(objCase.Support_Product_Family_Name__c)){
							if(!mapProductFamilyCaseCount.containsKey(objCase.Support_Product_Family_Name__c))
							{
								mapProductFamilyCaseCount.put(objCase.Support_Product_Family_Name__c, 1);	
							}else{
								mapProductFamilyCaseCount.put(objCase.Support_Product_Family_Name__c, mapProductFamilyCaseCount.get(objCase.Support_Product_Family_Name__c) + 1);
							}
						}
					}
				}
			}
			System.debug('### : ' + mapSupportCategoryCaseCount);
			System.debug('##$: ' + mapProductFamilyCaseCount);
			openEscalationCount = String.valueOf(countOpenEscalation);
			openCaseCount = String.valueOf(countOpenCases);
			last90DaysCaseCount = String.valueOf(countLast90DaysCases);
						
			if(mapSupportCategoryCaseCount != NULL && mapSupportCategoryCaseCount.size() > 0)
			{
				List<integer> lstCaseCount = new List<integer>();
				for(String key : mapSupportCategoryCaseCount.keySet())
				{
					lstCaseCount.add(mapSupportCategoryCaseCount.get(key));
					//lstCategoryChartData.add(new Data(key, mapSupportCategoryCaseCount.get(key)));
				}
				lstCaseCount.sort();
				System.debug('###: ' + lstCaseCount);
				//lstCategoryChartData.sort();
				
				for(String key : mapSupportCategoryCaseCount.keySet())
				{
					if(lstCaseCount.size() >= 2){
						if(mapSupportCategoryCaseCount.get(key) == lstCaseCount.get(lstCaseCount.size() - 1) || mapSupportCategoryCaseCount.get(key) == lstCaseCount.get(lstCaseCount.size() - 2)){
							lstCategoryChartData.add(new Data(key, mapSupportCategoryCaseCount.get(key)));
							if(maximumSteps == 0 || maximumSteps < mapSupportCategoryCaseCount.get(key)){
								maximumSteps = mapSupportCategoryCaseCount.get(key);
							}	
						}
					}else{
						lstCategoryChartData.add(new Data(key, mapSupportCategoryCaseCount.get(key)));
						maximumSteps = mapSupportCategoryCaseCount.get(key);
					}
				}
				
				if(maximumSteps == 1){
					maximumSteps = 0;
				}else if(maximumSteps > 10){
					maximumSteps = 5;
				}
				//showChart = 'yes';
			}
			
			if(mapProductFamilyCaseCount != NULL && mapProductFamilyCaseCount.size() > 0)
			{
				List<integer> lstCaseCount = new List<integer>();
				for(String key : mapProductFamilyCaseCount.keySet())
				{
					lstCaseCount.add(mapProductFamilyCaseCount.get(key));
					//lstCategoryChartData.add(new Data(key, mapSupportCategoryCaseCount.get(key)));
				}
				lstCaseCount.sort();
				System.debug('###: ' + lstCaseCount);
				//lstCategoryChartData.sort();
				
				for(String key : mapProductFamilyCaseCount.keySet())
				{
					if(lstCaseCount.size() >= 2){
						if(mapProductFamilyCaseCount.get(key) == lstCaseCount.get(lstCaseCount.size() - 1) || mapProductFamilyCaseCount.get(key) == lstCaseCount.get(lstCaseCount.size() - 2)){
							lstProductFamilyChartData.add(new Data(key, mapProductFamilyCaseCount.get(key)));
						}
					}else{
						lstProductFamilyChartData.add(new Data(key, mapProductFamilyCaseCount.get(key)));
					}	
				}
				//showChart = 'yes';
			}
			System.debug('### : ' + lstCategoryChartData);
		}
	}
	
	public void getCaseDetails()
	{
		try{
			if(objAuthenticationInfo == NULL){
				objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg');	
			}
			if(String.isBlank(selectedCaseId) && selectedCaseId != Apexpages.currentPage().getParameters().get('selectedCaseId')){
				selectedCaseId = Apexpages.currentPage().getParameters().get('selectedCaseId');
			}
	        if(objAuthenticationInfo.access_token != null)
	        {
	        	
				String endPoint = objAuthenticationInfo.instance_url + '/services/data/v40.0/query?q=SELECT+Id,ContactEmail,Escalation__c,Support_Category__c,Support_Product_Family_Name__c,Support_Product_Name__c,IsClosed,CaseNumber,CreatedDate,LastModifiedDate,Contact.Name,Owner.Name,Account.Name,Account.AccountNumber,Description,Resolution__c,Status,Priority,+(SELECT+Id,ParentId,IsPublished,CreatedBy.Name,CreatedDate,CommentBody+FROM+CaseComments+ORDER+BY+CreatedDate+DESC),(SELECT+Id,Name,Description,IsPrivate,CreatedBy.Name,LastModifiedBy.Name,ContentType,CreatedDate,LastModifiedDate+FROM+Attachments+ORDER+BY+CreatedDate+DESC)+FROM+Case+CASEWHERECLAUSE';
				String caseWhereClause = '';
				system.debug('selectedCaseId ' + selectedCaseId);
				if(!String.isBlank(selectedCaseId)){
					caseWhereClause = 'WHERE+Id+=+\'' + selectedCaseId + '\'';
				}else{
					//ERROR Message
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: could not locate the case id of selected case, please contact system administrator.'));
					return; 
				}
				 
				if(!String.isBlank(caseWhereClause)){
					caseWhereClause = caseWhereClause.replace(' ', '+');
					endPoint = endPoint.replace('CASEWHERECLAUSE', caseWhereClause);
				}
				system.debug('endPoint ' + endPoint);
				
				Http h = new Http();
				Map<String, String> headerMap = new Map<String, String>();
				headerMap.put('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
								
				HttpRequest req = ReSTWebserviceUtility.getHttpRequest('GET', headerMap, 120000, endPoint, NULL);
				
				if(req != NULL){
					HttpResponse res = h.send(req);
					system.debug('RESPONSE_BODY ' + res.getBody());
					if(res.getStatusCode() == 200)
					{
						caseDetailWithComments = (TAA_ServiceOverviewController.CaseWithCommentsResponse)JSON.deserialize(res.getbody(), TAA_ServiceOverviewController.CaseWithCommentsResponse.class);
						showCaseDetail = 'yes';
						showCases = 'no';
						caseEscalationLevel = caseDetailWithComments.records[0].Escalation__c;
					}else{
						isError = true;
		        		if(res.getStatus().contains('Not Found')){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
	        			}else{
		        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
						}	
					}
				}
				system.debug('caseDetailWithComments ' + caseDetailWithComments);       
	        }else{
	        	isError = true;
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
	        }
		}catch(Exception e){
			isError = true;
			if(e.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please have System Administrator to check Setup->Security->Remote site settings.'));
			}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + e.getMessage()));
			}
		}
	}
	
	//SMS: 864: Create New Case
	public void enableNewCaseForm()
	{
		showCases = 'no';
		showCaseDetail = 'no';
		showCreateCase = 'yes';
		for(SelectOption objSelect : lstAccountNumbers)
		{
			if(objSelect.getLabel().equalsIgnoreCase('ALL')){
				objSelect.setLabel('--NONE--');
				objSelect.setValue('');
			}
		}
		
		isVisibleToCustomer = true;
		isProductEnhancementRequest = false;
		
		lstAccountNumbers.sort();
		
		lstSupportSiteContactReason = new List<SelectOption>();
		lstSupportSiteContactReason.add(new SelectOption('', '--NONE--'));
		lstSupportSiteContactReason.add(new SelectOption('p', 'Product or Technical Support'));
		lstSupportSiteContactReason.add(new SelectOption('b', 'Billing & Accounts'));
		lstSupportSiteContactReason.add(new SelectOption('o', 'Orders & Returns'));
		lstSupportSiteContactReason.add(new SelectOption('i', 'Interested in a Product or Service'));
		
		lstSupportSiteAccountType = new List<SelectOption>();
		lstSupportSiteAccountType.add(new SelectOption('', '--NONE--'));
		lstSupportSiteAccountType.add(new SelectOption('s', 'Small Firm Services'));
		lstSupportSiteAccountType.add(new SelectOption('o', 'Other'));
		accountType = 'o';
		
		lstSupportSiteIssueReason = new List<SelectOption>();
		
		lstSupportSiteCustomerType = new List<SelectOption>();
		lstSupportSiteCustomerType.add(new SelectOption('', '--NONE--'));
		lstSupportSiteCustomerType.add(new SelectOption('n', 'National'));
		lstSupportSiteCustomerType.add(new SelectOption('p', 'Power Users'));
		lstSupportSiteCustomerType.add(new SelectOption('s', 'Stretegic'));
		
		lstSupportContactChoice = new List<SelectOption>();
		lstSupportContactChoice.add(new SelectOption('Customer', 'Customer'));
		lstSupportContactChoice.add(new SelectOption('Me', 'Me'));
		
		lstSeverity = new List<SelectOption>();
		lstSeverity.add(new SelectOption('Minimal Business Impact', 'Minimal Business Impact'));
		lstSeverity.add(new SelectOption('Nominal Business Impact', 'Nominal Business Impact'));		
		lstSeverity.add(new SelectOption('Significant Business Impact', 'Significant Business Impact'));
		lstSeverity.add(new SelectOption('Critical Business Impact', 'Critical Business Impact'));
		severity = 'Minimal Business Impact';

		escalation = '';
	}
	
	public void refreshFormWithProducts()
	{
		if(!String.isBlank(accountNumber) && mapAccountNumberNSourceSystem.containsKey(accountNumber) && mapAccountNumberNSourceSystem.get(accountNumber) == 'SFS'){
			accountType = 's';					
		}else{
			accountType = 'o';
		}
		
		if(lstSupportSiteProductSeed == NULL){
			lstSupportSiteProductSeed = Support_Site_Product_Details__c.getAll().values();
		}
		
		if(mapSupportSiteProductSeed == NULL){
			mapSupportSiteProductSeed = new Map<String, Support_Site_Product_Details__c>();
		}
		
		if(lstSupportSiteProducts == NULL)
		{
			lstSupportSiteProducts = new List<SelectOption>();
			lstSupportSiteProducts.add(new SelectOption('', '--NONE--'));
			for(Support_Site_Product_Details__c objProductSeed : lstSupportSiteProductSeed)
			{
				if(objProductSeed.AccountType__c == accountType){
					lstSupportSiteProducts.add(new SelectOption(objProductSeed.Product_Id__c, objProductSeed.Product_Name__c));
					mapSupportSiteProductSeed.put(objProductSeed.Product_Id__c, objProductSeed);
				}
			}
			//lstSupportSiteProducts.sort();
		}
		lstSupportSiteProducts = WK_Utility.sortSelectOptionList(lstSupportSiteProducts);
		
		if(lstSupportSiteFeatureSeed == NULL){
			lstSupportSiteFeatureSeed = Support_Site_Feature_Details__c.getAll().values();
		}

		lstSupportSiteFeatures = new List<SelectOption>();	
		lstSupportSiteFeatures.add(new SelectOption('', '--NONE--'));
	}
	
	// *** Refresh Contact Details
	public void refreshContactDetails()
	{
		if(!String.isBlank(contactChoice))
		{
			if(contactChoice == 'Me')
			{
				contactFirstName = currentUser.FirstName;
				contactLastName = currentUser.LastName;
				contactPhone = currentUser.Phone;
				contactEmail = currentUser.Email;
			}else{
				contactFirstName = '';
				contactLastName = '';
				contactPhone = '';
				contactEmail = '';
			}
		}
	}
	
	// *** Refresh Issue Reason & Feature List
	public void refreshFeatureList()
	{
		System.debug('##: ' + productId);
		if(!String.isBlank(productId))
		{
			lstSupportSiteIssueReason.clear();
			if(productId == '1' || productId == '22' || productId == '1845' || productId == '1872'){
				lstSupportSiteIssueReason.add(new SelectOption('h', 'Tax forms, input questions, diagnostics, etc'));
				lstSupportSiteIssueReason.add(new SelectOption('t', 'Installation, system errors, etc'));
			}else{
				lstSupportSiteIssueReason.add(new SelectOption('h', 'Help using the product'));
				lstSupportSiteIssueReason.add(new SelectOption('t', 'Technical Support'));
			}
		}
		
		if(!String.isBlank(issueReason) && !String.isBlank(productId))
		{
			lstSupportSiteFeatures.clear();
			if((productId == '1' || productId == '22' || productId == '1845' || productId == '1872') && issueReason == 't'){
				lstSupportSiteFeatures.add(new SelectOption('', '--NONE-- '));
				for(Support_Site_Feature_Details__c objFeatureSeed : lstSupportSiteFeatureSeed)
				{
					if(objFeatureSeed.ProductId__c.equalsIgnoreCase(productId)){
						lstSupportSiteFeatures.add(new SelectOption(objFeatureSeed.Name, objFeatureSeed.Feature_Name__c));	
					}
				}
				lstSupportSiteFeatures = WK_Utility.sortSelectOptionList(lstSupportSiteFeatures);
			}
		}
		
		System.debug('##: ' + lstSupportSiteFeatures);
	}
	
	// *** Prepare CreateCase Request
	public Boolean prepareRequest()
    {
    	Boolean isError = false;
    	try{
    		if(String.isBlank(contactReason)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact reason is required.'));
			}
    		
    		if(String.isBlank(accountNumber)){
    			isError = true;
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account number is required.'));
    		}else if(mapAccountNumberNSourceSystem == NULL || !(mapAccountNumberNSourceSystem.containsKey(accountNumber))){
    			isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Selected account number does not have ERP system name associated, please contact system administrator.'));
			}else{
				if(mapAccountNumberNSourceSystem.containsKey(accountNumber) && mapAccountNumberNSourceSystem.get(accountNumber) == 'SFS'){
					accountType = 's';					
				}else{
					accountType = 'o';
				}
			}
    		
    		if(String.isBlank(accountType)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account type is blank, please contact system administrator.'));
			}
    		
    		if((contactReason == 'p' || contactReason == 'i') && String.isBlank(productId)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Product is required.'));
			}
			/*
			if(contactReason == 'p' && !String.isBlank(productId) && String.isBlank(issueReason)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Issue reason is required.'));
			}
			*/
			if(String.isBlank(strSubject)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Brief issue summary is required.'));
			}
			
			if(String.isBlank(strDescription)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Detailed description is required.'));
			}
			
			if(String.isBlank(contactFirstName)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'First name is required.'));
			}
				
			if(String.isBlank(contactLastName)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Last name is required.'));
			}
			
			if(String.isBlank(contactEmail)){
				isError = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Email address is required.'));
			}

    		if(!isError)
    		{	
		    	String externalComment = 'Comment from Sales Cloud Created By ' + currentUser.Name;
		    	
		    	objRequest = new IIB_TAAServiceSiteCreateCase_V4.CreateCaseRequestWrapper(); 
		    	
		    	//Prepare UUID
		    	uuidMetaDataRequest = new IIB_TAAServiceSiteCreateCase_V4.UUIDMetaDataRequestType();
		    	uuidMetaDataRequest.uuid = WK_Utility.UUID_Generator();
		        uuidMetaDataRequest.sourceSystemName = WK_Utility.CreateCaseServiceIntegrations().SourceSystemName__c;
		        uuidMetaDataRequest.requestDateTime = Date.Today();
		        uuidMetaDataRequest.providingSystemName = WK_Utility.CreateCaseServiceIntegrations().SourceSystemName__c;
		        uuidMetaDataRequest.uniqueCallingUserId = UserInfo.getName() + '_' + UserInfo.getUserId();
		        uuidMetaDataRequest.transactionMonitoringFlag = WK_Utility.CreateCaseServiceIntegrations().TransactionMonitoringFlag__c ? 'Y' : 'N';
		        uuidMetaDataRequest.loggingFlag = WK_Utility.CreateCaseServiceIntegrations().LoggingFlag__c ? 'Y' : 'N';
		        uuidMetaDataRequest.serviceVersion = WK_Utility.CreateCaseServiceIntegrations().ServiceVersion__c;
				
				//Prepare CaseInfo
				caseInfo = new IIB_TAAServiceSiteCreateCase_V4.CaseInfoType();
				
				IIB_TAAServiceSiteCreateCase_V4.CaseOverviewType newCaseOverview = new IIB_TAAServiceSiteCreateCase_V4.CaseOverviewType();
				newCaseOverview.accountNumber = accountNumber;
				newCaseOverview.caseOrigin = !String.isBlank(WK_Utility.CreateCaseServiceIntegrations().CaseOrigin__c) ? WK_Utility.CreateCaseServiceIntegrations().CaseOrigin__c : 'Sales Cloud'; 
				newCaseOverview.accountSourceSystem = mapAccountNumberNSourceSystem.get(accountNumber);
				newCaseOverview.ticketVisibleToCustomer = isVisibleToCustomer;
				
				if(contactReason == 'p' || contactReason == 'i')
				{
					if(mapSupportSiteProductSeed.get(productId) != NULL)
					{
						newCaseOverview.product = mapSupportSiteProductSeed.get(productId).Product_Cloud_Name__c;
						newCaseOverview.productFamily = mapSupportSiteProductSeed.get(productId).Product_Family_Name__c;
						
						//newCaseOverview.product = 'xyz';
						//newCaseOverview.productFamily = 'xyz';
					}
				}
				
				caseInfo.caseOverview = newCaseOverview;
				
				IIB_TAAServiceSiteCreateCase_V4.CaseTrackingDetailsType newCaseTrackingDetails = new IIB_TAAServiceSiteCreateCase_V4.CaseTrackingDetailsType();
				newCaseTrackingDetails.createdBy = UserInfo.getName();
				newCaseTrackingDetails.customerType = customerType; 
				caseInfo.caseTrackingDetails = newCaseTrackingDetails;
				
				IIB_TAAServiceSiteCreateCase_V4.IssueInfoType newIssueInfo = new IIB_TAAServiceSiteCreateCase_V4.IssueInfoType();
				newIssueInfo.subject = strSubject;
				newIssueInfo.description = strDescription;
				newIssueInfo.productEnhancementRequest = isProductEnhancementRequest;
				caseInfo.issueInfo = newIssueInfo;
				
				// *** Pass customer details in Customer Contact Section
				
				IIB_TAAServiceSiteCreateCase_V4.CustomerContactInfoType newCustomerContactInfo = new IIB_TAAServiceSiteCreateCase_V4.CustomerContactInfoType();
						
				newCustomerContactInfo.customerContactFirstName = contactFirstName;
				newCustomerContactInfo.customerContactLastName = contactLastName;
				if(!String.isBlank(bestTimeToContact)){
					newCustomerContactInfo.bestTimeToContact = bestTimeToContact;
					externalComment = externalComment + '\nBest time to contact: ' + bestTimeToContact;   
				}
				 
				IIB_TAAServiceSiteCreateCase_V4.contactType newCustomerContactInfoList = new IIB_TAAServiceSiteCreateCase_V4.contactType();
				
				IIB_TAAServiceSiteCreateCase_V4.contactDataType newContactEmail = new IIB_TAAServiceSiteCreateCase_V4.contactDataType();
				newContactEmail.contactDetails = contactEmail;
				newContactEmail.contactType = 'EMAIL';
				externalComment = externalComment + '\nEmail: ' + contactEmail;					
				newCustomerContactInfoList.contact = new IIB_TAAServiceSiteCreateCase_V4.contactDataType[]{newContactEmail};
				
				if(!String.isBlank(contactPhone))
				{
					IIB_TAAServiceSiteCreateCase_V4.contactDataType newContactPhone = new IIB_TAAServiceSiteCreateCase_V4.contactDataType();
					newContactPhone.contactDetails = contactPhone;
					newContactPhone.contactType = 'PHONE';
					externalComment = externalComment + '\nPhone: ' + contactPhone;
					newCustomerContactInfoList.contact.add(newContactPhone);
				}
												
				newCustomerContactInfo.customerContactInfoList = newCustomerContactInfoList; 
				caseInfo.customerContactInfo = newCustomerContactInfo;
				
				// *** Pass current user details in Employee Contact Section
				
				IIB_TAAServiceSiteCreateCase_V4.EmployeeContactInfoType newEmployeeContactInfo = new IIB_TAAServiceSiteCreateCase_V4.EmployeeContactInfoType();
				newEmployeeContactInfo.employeeFirstName = currentUser.FirstName;
				newEmployeeContactInfo.employeeLastName = currentUser.LastName;
				
				IIB_TAAServiceSiteCreateCase_V4.contactType newEmployeeContactInfoList = new IIB_TAAServiceSiteCreateCase_V4.contactType();
				
				IIB_TAAServiceSiteCreateCase_V4.contactDataType newEmployeeEmail = new IIB_TAAServiceSiteCreateCase_V4.contactDataType();
				newEmployeeEmail.contactDetails = currentUser.Email;
				newEmployeeEmail.contactType = 'EMAIL';
				
				newEmployeeContactInfoList.contact = new IIB_TAAServiceSiteCreateCase_V4.contactDataType[]{newEmployeeEmail};
				
				if(!String.isBlank(currentUser.Phone))
				{
					IIB_TAAServiceSiteCreateCase_V4.contactDataType newEmployeePhone = new IIB_TAAServiceSiteCreateCase_V4.contactDataType();
					newEmployeePhone.contactDetails = currentUser.Phone;
					newEmployeePhone.contactType = 'PHONE';
					
					newEmployeeContactInfoList.contact.add(newEmployeePhone);
				}
				
				newEmployeeContactInfo.employeeContactInfoList = newEmployeeContactInfoList; 
				caseInfo.employeeContactInfo = newEmployeeContactInfo;
				
				caseInfo.caseStatus = new IIB_TAAServiceSiteCreateCase_V4.CaseStatusType();
				caseInfo.caseStatus.priority = severity;
				caseInfo.caseStatus.EscalationLevel = escalation;
				
				caseInfo.caseComments = new IIB_TAAServiceSiteCreateCase_V4.CaseCommentsType();
				if(!String.isBlank(internalComment)){
					internalComment = 'Comment from Sales Cloud Created By ' + currentUser.Name + '\n' + internalComment;
			 		caseInfo.caseComments.internalComments = internalComment;
				}
			 	
			 	// *** Order Number & Invoice Number
			 	caseInfo.caseRelatedInfo = new IIB_TAAServiceSiteCreateCase_V4.CaseRelatedInfoType();
			 	if((contactReason == 'o' || contactReason == 'b') && !String.isBlank(orderNumber)){
		 			caseInfo.caseRelatedInfo.orderNumber = orderNumber; 
		 			externalComment = externalComment + '\nOrder Number: ' + orderNumber;
			 	}			 		
			 	if(contactReason == 'b' && !String.isBlank(invoiceNumber)){
		 			caseInfo.caseRelatedInfo.invoiceNumber = invoiceNumber;
		 			externalComment = externalComment + '\nInvoice Number: ' + invoiceNumber; 
			 	}
			 	if(!String.isBlank(externalComment)){
					caseInfo.caseComments.externalComments = externalComment;
			 	}
				// *** Prepare parametersForRouting
				parametersForRouting = new IIB_TAAServiceSiteCreateCase_V4.parametersForRoutingType();
				parametersForRouting.contactReason = contactReason;
				
				// *** TECHNICAL DEBT ON SUPPORT SITE ROUTING SERVICE
				if(contactReason == 'p' || contactReason == 'i'){
					parametersForRouting.productId = productId;	
				}else{ // Pass dummy product id in case of non-product requests since product id is required for routing service 
					parametersForRouting.productId = '1';
				}
				
				if(contactReason == 'p'){
					parametersForRouting.issueReason = issueReason;
				}else{ // Pass dummy issue reason in case of non-product requests since issue reason is required for routing service
					parametersForRouting.issueReason = 'h';
				}
				
				parametersForRouting.accountType = accountType;
				parametersForRouting.featureId = featureId;
				parametersForRouting.customerType = customerType;
		
				objRequest.uuidMetaDataRequest = uuidMetaDataRequest;
				objRequest.caseInfo = caseInfo;
				objRequest.parametersForRouting = parametersForRouting;
    		}
			return isError;
    	}catch(Exception ex){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_INTERNAL_SERVER_ERROR_MESSAGE));
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
    		return true;
    	}
    }
    
    // *** Start CreateCase Request
    public Continuation startRequest() 
    {    
       Boolean isError = prepareRequest();
       try{
	       if(!isError){
		       Integer TIMEOUT_INT_SECS = 60;  
		       Continuation objCont = new Continuation(TIMEOUT_INT_SECS);
		       objCont.continuationMethod = 'processResponse';
		
		       AsyncIIB_TAAServiceSiteCreateCase_V4.AsyncCreateCaseSOAP createCaseService = new AsyncIIB_TAAServiceSiteCreateCase_V4.AsyncCreateCaseSOAP();
		       startTime = System.now().getTime();
		       createCaseServiceResponse = createCaseService.beginCreateCase(objCont, uuidMetaDataRequest, caseInfo, parametersForRouting);
		       System.debug('###: ' + createCaseServiceResponse);     
		       return objCont;
	       }else{
	       		return null;
	       }
       	}catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_INTERNAL_SERVER_ERROR_MESSAGE));
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
			return null;				
       	}
    }
    
    // *** Process CreateCase Response
    public Object processResponse()
    {
		try{
	    	if(!Test.isRunningTest()){
	    		response = createCaseServiceResponse.getValue();
	    	}
	    	totalTime = System.now().getTime() - startTime;
	        System.debug('Round Trip Time Required (to IIB) : ' + totalTime);
	        System.debug('Response : ' + response);
	        
	        if(response != NULL)
	        {
	        	if(response != NULL && response.createCase != NULL && !String.isBlank(response.createCase.sfdcCaseUrl))
	        	{
	        		//SUCCESS
	        		showCreateCase = 'no';
	        		//showCases = 'yes';
        			String caseId = response.createCase.sfdcCaseUrl.split('/')[3];
        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, WK_Constants.SVC_CREATECASE_SUCCESS_MESSAGE + ' Case # :<a href="#" onClick="return invokeApexGetCaseDetail(\'' + caseId + '\');" style="color:blue;font-size:1em;">' + response.createCase.caseNumber + '</a>'));	
	        		//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, '<a href="#" onClick="location.reload(); return false;" style="color:blue;font-size:1em;">Click here</a> to go back to the home page.'));
	        	}else if(response.errorMessages != NULL){
	        		//FAILURE
	        		if(response.errorMessages.ErrorMessage.customErrorMessageCode != NULL)
	        		{
	        			//SFDC SERVICE ORG ERROR
	        			if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_BLANK_MESSAGE));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_NOT_PRESENT){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_ACCOUNT_NUMBER_NOT_PRESENT_MESSAGE));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_EMAIL_BLANK){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_EMAIL_BLANK_MESSAGE));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_FIRSTNAME_BLANK){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_FIRSTNAME_BLANK_MESSAGE));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_LASTNAME_BLANK){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_LASTNAME_BLANK_MESSAGE));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_PRODUCT_NOT_PRESENT){
	        				String productName = '';
	        				if(!String.isBlank(caseInfo.caseOverview.product)){
	        					productName = caseInfo.caseOverview.product;
	        				}
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_PRODUCT_NOT_PRESENT_MESSAGE.replace('PRODNAME', productName)));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_CREATECASE_FAILED_PRODUCTFAMILY_NOT_PRESENT){
	        				String productFamilyName = '';
	        				if(!String.isBlank(caseInfo.caseOverview.productFamily)){
	        					productFamilyName = caseInfo.caseOverview.productFamily;
	        				}
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_CREATECASE_FAILED_PRODUCTFAMILY_NOT_PRESENT_MESSAGE.replace('PRODFAMNAME', productFamilyName)));	
	        			}else if(response.errorMessages.ErrorMessage.customErrorMessageCode == WK_Constants.SVC_INTERNAL_SERVER_ERRORCODE){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_INTERNAL_SERVER_ERROR_MESSAGE));
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));	
	        			}else{
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));
	        			}
	        			
	        		}else if(response.errorMessages.ErrorMessage.errorMessageCode != NULL){
	        			//IIB ERROR
	        			if(response.errorMessages.ErrorMessage.errorMessageCode == WK_Constants.SVC_IIB_DATA_MISSING){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_IIB_DATA_MISSING_MESSAGE));
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));	
	        			}else if(response.errorMessages.ErrorMessage.errorMessageCode == WK_Constants.SVC_IIB_DATA_INVALID){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_IIB_DATA_INVALID_MESSAGE));
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));	
	        			}else if(response.errorMessages.ErrorMessage.errorMessageCode == WK_Constants.SVC_INTERNAL_SERVER_ERRORCODE){
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_INTERNAL_SERVER_ERROR_MESSAGE));
	        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));	
	        			}
	        		}
	        		//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, response.errorMessages.ErrorMessage.customErrorMessageDescription));
	        	}
	        }else{
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_EXCEPTION_SFDC_IIB_SERVER_IS_DOWN_FOR_MAINTENANCE_MESSAGECODE));
	        }
	        //Override Application Logging Method to Log the response
	        logList = new List<sObject>();
	       	logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'processResponse', objRequest, response, currentAccount.Id));
	        
	        if(logList.size() > 0){
	        	insert logList;
	        }
	        logList = null;
        }catch(Exception ex){
        	insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'processResponse', objRequest.toString(), ex.getMessage(), currentAccount.Id, null);
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, WK_Constants.SVC_INTERNAL_SERVER_ERROR_MESSAGE));
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
        return null; 
    }
    
    //*** UPDATE CASE
    public void updateCase()
    {
    	HttpRequest req;
    	try{
	    	System.debug('Case Number: ' + caseDetailWithComments.records[0].CaseNumber);
	    	String caseNumber = caseDetailWithComments.records[0].CaseNumber;
	    	if(String.isBlank(caseNumber)){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'System is facing difficulty in determining the Case Number, please contact System Administrator.'));
	    	}else if(caseEscalationLevel == caseDetailWithComments.records[0].Escalation__c){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Case is already escalated to ' + caseEscalationLevel + ' level !!'));
	    	}else{	
				if(objAuthenticationInfo == NULL){
					objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg');			
				}
				
				if(objAuthenticationInfo.access_token != null)
		        {
					String endPoint = objAuthenticationInfo.instance_url + '/services/Soap/class/CreateUpdateCaseV2';
					String body = ReSTWebserviceUtility.getUpdateCaseSOAPRequest(objAuthenticationInfo.access_token, caseDetailWithComments.records[0].Escalation__c, caseNumber);				
					
					system.debug('body ' + body);
					
					Http h = new Http();
					Map<String, String> headerMap = new Map<String, String>();
					headerMap.put('Content-Type','text/xml; charset=UTF-8');
					headerMap.put('Accept', 'text/xml');
					headerMap.put('SOAPAction', '');
					
					if(!String.isBlank(body) && !String.isBlank(endPoint)){
						req = ReSTWebserviceUtility.getHttpRequest('POST', headerMap, 120000, endPoint, body);
					}
					req.setHeader('SOAPAction','1');
					System.debug('##: ' + req.getHeader('SOAPAction'));
					if(req != NULL){
						HttpResponse res = h.send(req);
						system.debug('RESPONSE_BODY ' + res.getBody());
						if(res.getStatusCode() == 200) // *** SUCCESS
						{
							if(!res.getBody().contains('errorMessageCode')){
								ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Case has been successfully escalated to ' + caseDetailWithComments.records[0].Escalation__c + ' level.'));
								getCaseDetails();	
							}else{
								ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'FAILED: ' + res.getBody().substringBetween('<errorMessageDescription>', '</errorMessageDescription>')));
							}
							
						}else{ // *** FAILURE
							isError = true;
			        		if(res.getStatus().contains('Not Found')){
		        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
		        			}else{
			        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
							}	
						}
						//Override Application Logging Method to Log the response
				        logList = new List<sObject>();
				       	logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'escalateCase', req, res, currentAccount.Id));
				        
				        if(logList.size() > 0){
				        	insert logList;
				        }
				        logList = null;
					}
					
		        }else{ // *** FAILURE DUE TO MISSING TOKEN
		        	isError = true;
		        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
		        }
	    	}
    	}catch(Exception ex){
    		insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'escalateCase',  String.valueOf(req), ex.getMessage(), currentAccount.Id, null);
			if(ex.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please get System Administrator to check if ' + objAuthenticationInfo.instance_url + ' is configured in Setup->Security->Remote site setting'));
			}else{
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
			}	
    	}
    }
    
    // *** ADD CASE COMMENT
    public void addNewCaseComment()
    {
    	HttpRequest req;
    	try{
	    	System.debug('caseComment: ' + caseCommentBody);
	    	if(String.isBlank(caseCommentBody)){
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Case comment is required.'));
	    	}else{
	    		
				if(objAuthenticationInfo == NULL){
					objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg');			
				}
				
				if(objAuthenticationInfo.access_token != null)
		        {
					String endPoint = objAuthenticationInfo.instance_url + '/services/data/v41.0/sobjects/CaseComment/';
					String body = '';
					if(!String.isBlank(selectedCaseId)){
						caseCommentBody = 'Comment from Sales Cloud by ' + currentUser.Name +'.\n'+ caseCommentBody;
						body = '{"CommentBody":'+ JSON.serialize(caseCommentBody) +', "IsPublished":"'+ isCaseCommentPublic +'", "ParentId":"'+ selectedCaseId +'"}';
						caseCommentBody = '';
						isCaseCommentPublic = false;
					}else{
						isError = true;
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: necessary information is missing, please contact System Administrator.'));
					}
					system.debug('body ' + body);
					
					Http h = new Http();
					
					Map<String, String> headerMap = new Map<String, String>();
					headerMap.put('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
					headerMap.put('Content-Type','application/json');
					
					if(!String.isBlank(body) && !String.isBlank(endPoint)){
						req = ReSTWebserviceUtility.getHttpRequest('POST', headerMap, 120000, endPoint, body);
					}
					
					if(req != NULL){
						HttpResponse res = h.send(req);
						system.debug('RESPONSE_BODY ' + res.getBody());
						if(res.getStatusCode() == 201) // *** SUCCESS
						{
							ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Case comment successfully added.'));
							getCaseDetails();
						}else{ // *** FAILURE
							isError = true;
			        		if(res.getStatus().contains('Not Found')){
		        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
		        			}else{
			        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
							}	
						}
						//Override Application Logging Method to Log the response
				        logList = new List<sObject>();
				       	logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'addNewCaseComment', req, res, currentAccount.Id));
				        
				        if(logList.size() > 0){
				        	insert logList;
				        }
				        logList = null;
					}
					
		        }else{ // *** FAILURE DUE TO MISSING TOKEN
		        	isError = true;
		        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
		        }
	    	}
    	}catch(Exception ex){
    		insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'addNewCaseComment',  String.valueOf(req), ex.getMessage(), currentAccount.Id, null);
			if(ex.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please get System Administrator to check if ' + objAuthenticationInfo.instance_url + ' is configured in Setup->Security->Remote site setting'));
			}else{
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
			}	
    	}
    }
	
	// *** ADD CASE ATTACHMENT
    public void addNewCaseAttachment()
    {
	    HttpRequest req;
	    try{	
	    	String attachmentId = ApexPages.currentPage().getParameters().get('newAttachmentId');
	    	System.debug('caseAttachment : ' + attachmentId);
	    	System.debug('caseId : ' + selectedCaseId);
	    	List<Attachment> lstAttachment = [SELECT Id, Name, Body, IsPrivate, Description FROM Attachment WHERE Id =: attachmentId LIMIT 1];
	    	Attachment caseAttachment = NULL;
	    	if(lstAttachment != NULL && lstAttachment.size() > 0){
	    		caseAttachment = lstAttachment[0];
	    	}
	    	if(!String.isBlank(selectedCaseId) && caseAttachment != NULL && !String.isBlank(caseAttachment.Name))
	    	{
	    		if(objAuthenticationInfo == NULL){
					objAuthenticationInfo = ReSTWebserviceUtility.authenticate('TAAServiceOrg');			
				}
				
				if(objAuthenticationInfo.access_token != null)
		        {
					String endPoint = objAuthenticationInfo.instance_url + '/services/data/v41.0/sobjects/Attachment/';
					//String body = JSON.serialize(caseAttachment, true); //'{"Name":'+ JSON.serialize(caseAttachment.Name) +', "ParentId":"'+ selectedCaseId +'", "Description":'+ JSON.serialize(caseAttachment.Description) +', "Body":'+ JSON.serialize(caseAttachment.Body) +'}';
					caseAttachment.Name = caseAttachment.Name.split('###')[1];
					caseAttachment.Description = 'Attachment Created By ' + UserInfo.getName() + ' from Sales Cloud.\n ' + caseAttachment.Description; //!= NULL ? ' Description: ' + caseAttachment.Description : ''; 
					String body = '{"Name":'+ JSON.serialize(caseAttachment.Name) +', "ParentId":"'+ selectedCaseId +'", "Description":'+ JSON.serialize(caseAttachment.Description) +', "Body":'+ JSON.serialize(caseAttachment.Body) +', "IsPrivate":'+ JSON.serialize(caseAttachment.IsPrivate) +'}';
					system.debug('body ' + body);
					
					Http h = new Http();
					Map<String, String> headerMap = new Map<String, String>();
					headerMap.put('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
					headerMap.put('Content-Type','application/json');
									
					
					if(!String.isBlank(body) && !String.isBlank(endPoint)){
						req = ReSTWebserviceUtility.getHttpRequest('POST', headerMap, 120000, endPoint, body);
					}
					
					if(req != NULL){
						HttpResponse res = h.send(req);
						system.debug('RESPONSE_BODY ' + res.getBody());
						if(res.getStatusCode() == 201) // *** SUCCESS
						{
							// *** Delete temporarily created attachment on account record
							List<Attachment> lst = [SELECT Id FROM Attachment WHERE ParentId =: currentAccount.Id AND Name LIKE 'DELETE###%'];
							delete lst;
							
							// *** Add success page message
							ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Case Attachment Created.'));
						}else{ // *** FAILURE
							isError = true;
			        		if(res.getStatus().contains('Not Found')){
		        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: couldn\'t locate the service URL, please contact System Administrator'));
		        			}else{
			        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));
							}	
						}
						//Override Application Logging Method to Log the response
				        logList = new List<sObject>();
				       	logList.add(EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'addNewCaseAttachment', req, res, currentAccount.Id));
				        
				        if(logList.size() > 0){
				        	insert logList;
				        }
				        logList = null;
					}
		        }else{ // *** FAILURE DUE TO MISSING TOKEN
		        	isError = true;
		        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Authentication token NULL.'));
		        }
	    	}else{ // *** FAILURE DUE TO MISSING INFO
	    		isError = true;
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: necessary information is missing, please contact System Administrator.'));
	    	}
    	}catch(Exception ex){
    		insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse('TAA_ServiceOverviewController', 'addNewCaseAttachment',  String.valueOf(req), ex.getMessage(), currentAccount.Id, null);
			if(ex.getMessage().contains('Unauthorized endpoint')){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: Unauthorized endpoint, please get System Administrator to check if ' + objAuthenticationInfo.instance_url + ' is configured in Setup->Security->Remote site setting'));
			}else{
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
			}	
    	}
    }
    
	public class Data
	{
		public String status {get; set;}
		public integer count {get; set;}
		public Data(String status, integer count)
		{
			this.status = status;
			this.count = count;
		}
	}
	
	public class CaseResponse 
	{  
		//public String id{get;set;} public String issued_at{get;set;} public String instance_url{get;set;} public String signature{get;set;} public String access_token{get;set;}    
     	public integer totalSize {get; set;}
     	public Boolean done {get; set;}
     	public List<AccountRecords> records {get; set;} 
	}
	
	public class AccountRecords
	{
		public Attributes attributes {get; set;}
		public String id {get; set;}
		public Cases cases {get; set;}
		public String status {get; set;}
		public integer expr0 {get; set;} 
		public String Name {get; set;}
	}
	
	public class Attributes
	{
		public String type {get; set;}
		public String url {get; set;}
	}
	
	public class Cases
	{
		public integer totalSize {get; set;}
     	public Boolean done {get; set;}
     	public List<Case> records {get; set;}
	}
	
	public class CaseWithCommentsResponse 
	{  
		//public String id{get;set;} public String issued_at{get;set;} public String instance_url{get;set;} public String signature{get;set;} public String access_token{get;set;}    
     	public integer totalSize {get; set;}
     	public Boolean done {get; set;}
     	public List<Case> records {get; set;} 
	}
}