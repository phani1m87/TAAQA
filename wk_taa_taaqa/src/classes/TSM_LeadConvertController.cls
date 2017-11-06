/*
 * Controller class for 'TSM_LeadConvert' visualforce page. Has the backend logic for custom lead closure and conversion.
 */
public with sharing class TSM_LeadConvertController {

    public Lead leadToConvert {get; set;}  
    public list<SelectOption> accountTypes {get; set;}
    public list<SelectOption> contactTypes {get; set;}

    public String selectedAccountType {get; set;}
    public String selectedContactType {get; set;}
    public Boolean isEditableAccountType {get; set;}
    public Boolean isEditableContactType {get; set;}

    public Account newAccount {get; set;}
    public Contact newcontact {get; set;}
    public Opportunity newOpportunity {get; set;}

    public Id primaryCampaignId;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public TSM_LeadConvertController(ApexPages.StandardController stdController) {
        //get the ID to query for the Lead fields
        Id leadId = stdController.getId();
        
        // Do NOT modify this SOQL to remove fields that are required for ATA functionality
        leadToConvert = [SELECT Id, Status, OwnerId, Email, Name, FirstName , LastName, Salutation, Company, Owner.Type, Reason__c,PostalCode,
                                Market_Segment__c,Market_Sub_Segment__c, Related_Account__c, Related_Contact__c, Related_Opportunity__c
                                FROM Lead WHERE Id = :leadId
                            ];
        //set the default values
        isEditableAccountType = true;
        isEditableContactType = true;

        accountTypes = new list<SelectOption>();
        accountTypes.add(new SelectOption(Label.TSM_LeadConversion_None,Label.TSM_LeadConversion_None));        
        accountTypes.add(new SelectOption(Label.TSM_LeadConversion_New,Label.TSM_LeadConversion_New));
        accountTypes.add(new SelectOption(Label.TSM_LeadConversion_Existing,Label.TSM_LeadConversion_Existing));
        
        contactTypes = new list<SelectOption>();
        contactTypes.add(new SelectOption(Label.TSM_LeadConversion_None,Label.TSM_LeadConversion_None));
        contactTypes.add(new SelectOption(Label.TSM_LeadConversion_New,Label.TSM_LeadConversion_New));
        contactTypes.add(new SelectOption(Label.TSM_LeadConversion_Existing,Label.TSM_LeadConversion_Existing));

        //instantiate the new objects.
        newAccount = new Account();
        newContact = new Contact();
        newOpportunity = new Opportunity();
        newOpportunity.stageName = Label.TSM_LeadConversion_OppStage;
        newOpportunity.OwnerId = leadToConvert.OwnerId;
        
        if(leadToConvert.Related_Account__c != null){
            selectedAccountType = Label.TSM_LeadConversion_Existing;
            isEditableAccountType = false;

            //also set the contact type existing
            selectedContactType = Label.TSM_LeadConversion_Existing;
        }else{
            //selectedAccountType = Label.TSM_LeadConversion_New;
            selectedAccountType = Label.TSM_LeadConversion_None;
            //set the Account name based on Lead company name
            //newAccount.Name = leadToConvert.Company;
        }

        if(leadToConvert.Related_Contact__c != null){
            selectedContactType = Label.TSM_LeadConversion_Existing;
            isEditableContactType = false;

            //also set the Account type existing
            selectedAccountType = Label.TSM_LeadConversion_Existing;
        }else if(leadToConvert.Related_Contact__c == null && leadToConvert.Related_Account__c == null){
            //selectedContactType = Label.TSM_LeadConversion_New;
            selectedContactType = Label.TSM_LeadConversion_None;
            //set the contact fields based on lead fields
            //newContact.FirstName = leadToConvert.FirstName;
            //newContact.LastName = leadToConvert.LastName;
            //newContact.Salutation = leadToConvert.Salutation;
        }
    }
        

    // This method is called when the user selects the Account or contact type and reset the related the fields.
    public PageReference setLeadStatusDependentFields() {
        if(leadToConvert.Status == Label.TSM_LeadStatus_ExistingOpportunity){
            selectedAccountType = Label.TSM_LeadConversion_Existing;
            selectedContactType = Label.TSM_LeadConversion_Existing;
        }else if(leadToConvert.Status == Label.TSM_LeadStatus_NoCurrentOpportunity){
            if(leadToConvert.Related_Account__c != null) selectedAccountType = Label.TSM_LeadConversion_Existing;
            if(leadToConvert.Related_Contact__c != null) selectedContactType = Label.TSM_LeadConversion_Existing;
        }

        return null;
    }

    public PageReference setExistingAccount() {
        if(leadToConvert.Related_Contact__c != null && leadToConvert.Related_Account__c == null){
            //set the account Id based on the contact's account
            List<Contact> cList = [Select Id, AccountId from Contact 
                                            WHERE Id = :leadToConvert.Related_Contact__c limit 1];
            if(cList != null && !cList.isEmpty() && cList[0].AccountId != null){
                leadToConvert.Related_Account__c = cList[0].AccountId ;
            }
        }else if(leadToConvert.Related_Opportunity__c != null && leadToConvert.Related_Account__c == null){
            //set the account Id based on the Opportunity's account
            List<Opportunity> oList = [Select Id, AccountId from Opportunity 
                                            WHERE Id = :leadToConvert.Related_Opportunity__c limit 1];
            if(oList != null && !oList.isEmpty() && oList[0].AccountId != null){
                leadToConvert.Related_Account__c = oList[0].AccountId ;
            }
        }
        System.debug('@@@ leadToConvert.Related_Account__c - '+ leadToConvert.Related_Contact__c + ' - ' + leadToConvert.Related_Account__c);
        return null;
    }

    // This method is called when the user selects the Account or contact type and reset the related the fields.
    public PageReference resetFields() {
        if(selectedAccountType == Label.TSM_LeadConversion_Existing){
            //reset the new account fields that might be filled
            newAccount = new Account();
        }else if(selectedAccountType == Label.TSM_LeadConversion_New) {
            //reset the existng account field
            leadToConvert.Related_Account__c = null;

            //set the Account name based on Lead company name
            newAccount.Name = leadToConvert.Company;
            newAccount.Came_from_Lead__c = True;
            selectedContactType = Label.TSM_LeadConversion_New;
        } else if(selectedAccountType == Label.TSM_LeadConversion_None) {
            //selectedContactType = Label.TSM_LeadConversion_None;
        }

        if(selectedContactType == Label.TSM_LeadConversion_Existing){
            //reset the new Contact fields that might be filled
            newContact = new Contact();
            selectedAccountType = Label.TSM_LeadConversion_Existing;
        }else if(selectedContactType == Label.TSM_LeadConversion_New || selectedContactType == Label.TSM_LeadConversion_None){
            //reset the existng contact field
            leadToConvert.Related_Contact__c = null;

            //set the contact fields based on lead fields
            newContact.FirstName = leadToConvert.FirstName;
            newContact.LastName = leadToConvert.LastName;
            newContact.Salutation = leadToConvert.Salutation;
        }

        return null;
    }

    // This method is called when the user clicks the Convert button on the VF Page
    public PageReference convertLead() {
        //validate if required fields are entered
        if(leadToConvert.Status == null || leadToConvert.Status == '--None--'){
            PrintError('Please select a valid Status value');
            return null;
        }

        //before conversion get the primary campaign Id to set on opportunity, as the campaignmember will reassign to contact after conversion
        List<CampaignMember> campaignMemberList = [SELECT CampaignID, LeadID, Status FROM CampaignMember 
                                                                    WHERE LeadID =: leadToConvert.Id 
                                                                    Order by CreatedDate DESC
                                                                    Limit 1];
        if(campaignMemberList != null && !campaignMemberList.isEmpty()){
            primaryCampaignId =  campaignMemberList[0].CampaignID;
            //SMS-866
            campaignMemberList[0].Exclude_From_Reporting__c = false;
            //SMS-866
        } 

        Savepoint sp = Database.setSavepoint();
        try{
            // This is the lead convert object that will convert the lead 
            Database.LeadConvert leadConvert = new database.LeadConvert();        
            leadConvert.setLeadId(leadToConvert.Id); 
            leadConvert.setConvertedStatus(leadToConvert.Status);
            leadConvert.setOwnerId(UserInfo.getUserId());

            Id convertToAccountId;
            Id convertToContactId;

            //Sets the ID of the account into which the lead is merged. 
            if(selectedAccountType == Label.TSM_LeadConversion_Existing && leadToConvert.Related_Account__c != null){
                convertToAccountId = leadToConvert.Related_Account__c;
                leadConvert.setAccountId(convertToAccountId);
            }else if(selectedAccountType == Label.TSM_LeadConversion_New && leadToConvert.Status != Label.TSM_LeadStatus_NotViable){
                //insert the new Account and then set the account Id for lead conversion
                try{
                    newAccount.Came_from_lead__c=True;
                    
                    // Do NOT remove these lines as they are required for ATA functionality
                    newAccount.BillingPostalCode = leadToConvert.PostalCode;
                    newAccount.Market_Segment__c = leadToConvert.Market_Segment__c;
                    newAccount.Market_Sub_Segment__c = leadToConvert.Market_Sub_Segment__c;
                    //Do NOT remove the above lines as they are required for ATA functionality
                    
                    insert newAccount;
                    convertToAccountId = newAccount.Id;
                    leadConvert.setAccountId(convertToAccountId);
                }
                catch(System.DMLException e){
                	// Fix for SMS-634
                	Database.rollback(sp);
                    PrintError(e.getMessage());
                }
            }

            //Sets the ID of the Contact into which the lead is merged. 
            if(selectedContactType == Label.TSM_LeadConversion_Existing){
                convertToContactId = leadToConvert.Related_Contact__c;
                leadConvert.setContactId(convertToContactId);
            }else if(selectedContactType == Label.TSM_LeadConversion_New && leadToConvert.Status != Label.TSM_LeadStatus_NotViable){
                //insert the new Contact and then set the Contact Id for lead conversion
                try{
                    if(leadToConvert.Related_Account__c != null) newcontact.AccountId = leadToConvert.Related_Account__c;
                    else newcontact.AccountId = newAccount.Id;
                    insert newcontact;
                    convertToContactId = newContact.Id;
                    leadConvert.setContactId(convertToContactId);
                }
                catch(System.DMLException e){
                	// Fix for SMS-634
                	Database.rollback(sp);
                    PrintError(e.getMessage());
                }   
            }

            //Set if the Opportunity has to created manually
            if(leadToConvert.Status == Label.TSM_LeadStatus_ExistingOpportunity ||  leadToConvert.Status == Label.TSM_LeadStatus_NotViable ||
                // added below criteria for SMS-677
                leadToConvert.Status == Label.TSM_LeadStatus_NoCurrentOpportunity){
                leadConvert.setDoNotCreateOpportunity(true);
            }else if(leadToConvert.Status == Label.TSM_LeadStatus_NewOpportunity){
                // Allow the opportunity creation with lead conversion so that std mapped fields are set, once converted the values selected on the page will be set. 
                leadConvert.setOpportunityName(newOpportunity.Name);
                leadConvert.setDoNotCreateOpportunity(false);
            }

            //convert the lead
            if(convertToAccountId != null && convertToContactId != null ){
                Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
                System.debug('leadConvertResult:'+leadConvertResult);
                // if the lead conversion was successfull do the post updates.
                if (leadConvertResult.success)
                {   
                    //update Opportunity with values selected on the page. - configured in field set 'TSM_LeadConvertFields'
                    Opportunity opp;
                    if(leadToConvert.Status == Label.TSM_LeadStatus_NewOpportunity){
                        opp = new Opportunity(id=leadConvertResult.getOpportunityId());
                        if(opp != null){
                            for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.TSM_LeadConvertFields.getFields()) {
                                if(opp.get(f.getFieldPath()) != newOpportunity.get(f.getFieldPath())){
                                    opp.put(f.getFieldPath(), newOpportunity.get(f.getFieldPath()));
                                }
                            }
                            opp.Primary_Contact_for_Proposal__c = leadConvertResult.getContactId();
                            update opp;
                        }
                    }else if(leadToConvert.Status == Label.TSM_LeadStatus_ExistingOpportunity){
                        opp = new Opportunity(id=leadToConvert.Related_Opportunity__c);

                        //set the primary campaign source to recent campaign
                        if(primaryCampaignId != null)
                            opp.CampaignId = primaryCampaignId;
                        update opp;

                        if(opp != null && opp.Id != null){
                            //The convertedTo Contact is added to the Contact Roles on the selected Opportunity if doesn't exits.
                            List<OpportunityContactRole> ocrList = [Select Id from OpportunityContactRole 
                                                                                Where OpportunityId = :opp.Id and 
                                                                                        ContactId = :leadConvertResult.getContactId() 
                                                                                        Limit 1];
                            if(ocrList == null || ocrList.isEmpty()){                                
                                OpportunityContactRole ocr = new OpportunityContactRole();
                                ocr.OpportunityId = opp.Id;
                                ocr.ContactId = leadConvertResult.getContactId();
                                //ocr.Role = '';
                                insert ocr;
                            }
                        }
                    }
                    //SMS-866
                    if(campaignMemberList != NULL && campaignMemberList.size() > 0)
                    {
                    	update campaignMemberList[0];
                    }
                    //SMS-866
                    System.debug('leadToConvert:'+leadToConvert);
                    // for SMS-678 BEGIN
                    //update leadToConvert;
                    //TSM_LeadConvertController.updateLeadReason(leadToConvert.Id, leadToConvert.Reason__c);
                    // for SMS-678 END
                    // redirect the user to the newly created Account
                    PageReference pageRef = new PageReference('/' + leadConvertResult.getAccountId());            
                    pageRef.setRedirect(true);            
                    return pageRef; 
                }else{
                    //if converting was unsucessful, print the errors to the pageMessages and return null
                    System.Debug(leadConvertResult.errors);
                    PrintErrors(leadConvertResult.errors);            
                    return null;
                }
            }else if(leadToConvert.Status == Label.TSM_LeadStatus_NotViable){
                //Existing account and contact are not select then just update the Status and Reason, but no conversion
                update leadToConvert;
                PageReference pageRef = new PageReference('/' + leadToConvert.Id);            
                pageRef.setRedirect(true);            
                return pageRef; 
            }
        /*
        }catch (DMLException e) {
            Database.rollback(sp);
            PrintError(e.getMessage());
        */
        }catch(Exception e){
        	// Fix for SMS-634
            Database.rollback(sp);
            PrintError(e.getMessage());
        }
        return null;
    }

    //this method will take database errors and print them to teh PageMessages 
    public void PrintErrors(Database.Error[] errors)
    {
        for(Database.Error error : errors)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error.message);
            ApexPages.addMessage(msg);
        }
    }
    
    //This method will put an error into the PageMessages on the page
    public void PrintError(string error) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error); 
        ApexPages.addMessage(msg);
    }
   
   // Fix for SMS-678 BEGIN
   public PageReference updateLeadReason() {
        Lead lead = [SELECT Id, Reason__c FROM Lead WHERE Id = :leadToConvert.Id];
        lead.Reason__c = leadToConvert.Reason__c;
        update lead;
        return null;
    }
}