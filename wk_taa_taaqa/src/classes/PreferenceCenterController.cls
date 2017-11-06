/*
    ###########################################################################
    # File..................: Class - PreferenceCenterController
    # Created by............: The Hunley Group
    # Created Date..........: 1/1/2016
    # Description...........: Class used to support Force.com sites implementation 
                                of Email Preference Center. Sites users do not have access 
                                to the Contact or Lead object directly so we need to pass data
                                to a custom object (Email_Preferences__c) and then use a trigger
                                to pass that data to the corresponding lead or contact.
    # Release Notes.........: Prior to releasing to Production the URL in the Page Reference (callpage)
                                needs to be updated to the Production sites URL.
    ########################################################################### */
public without sharing class PreferenceCenterController {
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public String Title{get;set;}
    public String Company{get;set;}
    public String Email{get;set;}
    public String Phone{get;set;}
    public String MobilePhone{get;set;}
    public Boolean SP_CFM{get;set;}
    public Boolean SP_AAW{get;set;}
    public Boolean NA_CCC{get;set;}
    public Boolean GOO{get;set;}
    public Boolean NA_IFT{get;set;}
    public Boolean NA_TNH{get;set;}
    public Boolean RL_AAR{get;set;}
    public Boolean RL_FEPR{get;set;}
    public Boolean RL_FTR{get;set;}
    public Boolean RL_ITR{get;set;}
    public Boolean RL_SAA{get;set;}
    public Boolean RL_SFE{get;set;}
    public Boolean RL_SFI{get;set;}
    public Boolean RL_SIT{get;set;}
    public Boolean RL_SST{get;set;}
    public Boolean RL_STR{get;set;}
    public Boolean SP_CDT{get;set;}
    public Boolean SP_CFT{get;set;}
    public Boolean SP_CIT{get;set;}
    
    public String oFirstName{get;set;}
    public String oLastName{get;set;}
    public String oTitle{get;set;}
    public String oMobilePhone{get;set;}
    public Boolean oSP_CFM{get;set;}
    public Boolean oSP_AAW{get;set;}
    public Boolean oNA_CCC{get;set;}
    public Boolean oGOO{get;set;}
    public Boolean oNA_IFT{get;set;}
    public Boolean oNA_TNH{get;set;}
    public Boolean oRL_AAR{get;set;}
    public Boolean oRL_FEPR{get;set;}
    public Boolean oRL_FTR{get;set;}
    public Boolean oRL_ITR{get;set;}
    public Boolean oRL_SAA{get;set;}
    public Boolean oRL_SFE{get;set;}
    public Boolean oRL_SFI{get;set;}
    public Boolean oRL_SIT{get;set;}
    public Boolean oRL_SST{get;set;}
    public Boolean oRL_STR{get;set;}
    public Boolean oSP_CDT{get;set;}
    public Boolean oSP_CFT{get;set;}
    public Boolean oSP_CIT{get;set;}
    public String pcid{get;set;}
    public String str_cid;
    String sMessage;
    
    Id cid = System.currentPageReference().getParameters().get('id');
    
    public PreferenceCenterController() {
        str_cid = String.valueOf(cid);
        if (str_cid.left(3) == '003'){
            getThiscontact();
            pcid=cid;
            FirstName=thiscontact.FirstName;
            LastName=thiscontact.LastName;
            Title=thiscontact.Title;
            Company=thiscontact.Account.Name;
            Email=thiscontact.Email;
            Phone=thiscontact.Phone;
            MobilePhone=thiscontact.MobilePhone;
            GOO=thiscontact.HasOptedOutOfEmail;
            SP_CFM=thiscontact.SP_CFM__c;
            SP_AAW=thiscontact.SP_AAW__c;
            NA_CCC=thiscontact.NA_CCC__c;
            NA_IFT=thiscontact.NA_IFT__c;
            NA_TNH=thiscontact.NA_TNH__c;
            RL_AAR=thiscontact.RL_AAR__c;
            RL_FEPR=thiscontact.RL_FEPR__c;
            RL_FTR=thiscontact.RL_FTR__c;
            RL_ITR=thiscontact.RL_ITR__c;
            RL_SAA=thiscontact.RL_SAA__c;
            RL_SFE=thiscontact.RL_SFE__c;
            RL_SFI=thiscontact.RL_SFI__c;
            RL_SIT=thiscontact.RL_SIT__c;
            RL_SST=thiscontact.RL_SST__c;
            RL_STR=thiscontact.RL_STR__c;
            SP_CDT=thiscontact.SP_CDT__c;
            SP_CFT=thiscontact.SP_CFT__c;
            SP_CIT=thiscontact.SP_CIT__c;
            
            oFirstName=thiscontact.FirstName;
            oLastName=thiscontact.LastName;
            oTitle=thiscontact.Title;
            oMobilePhone=thiscontact.MobilePhone;
            oGOO=thiscontact.HasOptedOutOfEmail;
            oSP_CFM=thiscontact.SP_CFM__c;
            oSP_AAW=thiscontact.SP_AAW__c;
            oNA_CCC=thiscontact.NA_CCC__c;
            oNA_IFT=thiscontact.NA_IFT__c;
            oNA_TNH=thiscontact.NA_TNH__c;
            oRL_AAR=thiscontact.RL_AAR__c;
            oRL_FEPR=thiscontact.RL_FEPR__c;
            oRL_FTR=thiscontact.RL_FTR__c;
            oRL_ITR=thiscontact.RL_ITR__c;
            oRL_SAA=thiscontact.RL_SAA__c;
            oRL_SFE=thiscontact.RL_SFE__c;
            oRL_SFI=thiscontact.RL_SFI__c;
            oRL_SIT=thiscontact.RL_SIT__c;
            oRL_SST=thiscontact.RL_SST__c;
            oRL_STR=thiscontact.RL_STR__c;
            oSP_CDT=thiscontact.SP_CDT__c;
            oSP_CFT=thiscontact.SP_CFT__c;
            oSP_CIT=thiscontact.SP_CIT__c;
        } else if (str_cid.left(3) == '00Q'){
            getThislead();
            pcid=cid;
            FirstName=thislead.FirstName;
            LastName=thislead.LastName;
            Company=thislead.Company;
            Title=thislead.Title;
            Email=thislead.Email;
            Phone=thislead.Phone;
            MobilePhone=thislead.MobilePhone;
            GOO=thislead.HasOptedOutOfEmail;
            SP_CFM=thislead.SP_CFM__c;
            SP_AAW=thislead.SP_AAW__c;
            NA_CCC=thislead.NA_CCC__c;
            NA_IFT=thislead.NA_IFT__c;
            NA_TNH=thislead.NA_TNH__c;
            RL_AAR=thislead.RL_AAR__c;
            RL_FEPR=thislead.RL_FEPR__c;
            RL_FTR=thislead.RL_FTR__c;
            RL_ITR=thislead.RL_ITR__c;
            RL_SAA=thislead.RL_SAA__c;
            RL_SFE=thislead.RL_SFE__c;
            RL_SFI=thislead.RL_SFI__c;
            RL_SIT=thislead.RL_SIT__c;
            RL_SST=thislead.RL_SST__c;
            RL_STR=thislead.RL_STR__c;
            SP_CDT=thislead.SP_CDT__c;
            SP_CFT=thislead.SP_CFT__c;
            SP_CIT=thislead.SP_CIT__c;
            
            oFirstName=thislead.FirstName;
            oLastName=thislead.LastName;
            oTitle=thislead.Title;
            oMobilePhone=thislead.MobilePhone;
            oGOO=thislead.HasOptedOutOfEmail;
            oSP_CFM=thislead.SP_CFM__c;
            oSP_AAW=thislead.SP_AAW__c;
            oNA_CCC=thislead.NA_CCC__c;
            oNA_IFT=thislead.NA_IFT__c;
            oNA_TNH=thislead.NA_TNH__c;
            oRL_AAR=thislead.RL_AAR__c;
            oRL_FEPR=thislead.RL_FEPR__c;
            oRL_FTR=thislead.RL_FTR__c;
            oRL_ITR=thislead.RL_ITR__c;
            oRL_SAA=thislead.RL_SAA__c;
            oRL_SFE=thislead.RL_SFE__c;
            oRL_SFI=thislead.RL_SFI__c;
            oRL_SIT=thislead.RL_SIT__c;
            oRL_SST=thislead.RL_SST__c;
            oRL_STR=thislead.RL_STR__c;
            oSP_CDT=thislead.SP_CDT__c;
            oSP_CFT=thislead.SP_CFT__c;
            oSP_CIT=thislead.SP_CIT__c;
        }
    }
    
    public Contact thiscontact = new Contact();
    public Contact getThiscontact(){
        thiscontact = [SELECT Id, FirstName, LastName, Account.Name, Email, Phone, MobilePhone, 
                       Title, SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c, 
                       NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                       RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                       SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail
                       FROM Contact WHERE Id = :cid];
        return thiscontact;
    }
    
    public Lead thislead = new Lead();
    public Lead getThislead(){
        thislead = [SELECT Id, FirstName, LastName, Company, Email, Phone, MobilePhone, Title,
                       SP_CFM__c, SP_AAW__c, NA_CCC__c, NA_IFT__c, 
                       NA_TNH__c, RL_AAR__c, RL_FEPR__c, RL_FTR__c, RL_ITR__c, 
                       RL_SAA__c, RL_SFE__c, RL_SFI__c, RL_SIT__c, RL_SST__c, RL_STR__c, 
                       SP_CDT__c, SP_CFT__c, SP_CIT__c, HasOptedOutOfEmail
                       FROM Lead WHERE Id = :cid];
        return thislead;
    }
    
    public Email_Preferences__c newcontact_EP = new Email_Preferences__c();
    
    public double getRandom() {
        return Math.random();
    }
        
    public pagereference quickSave(){
        if (str_cid.left(3) == '003'){
            newcontact_EP.FirstName__c = FirstName;
            newcontact_EP.LastName__c = LastName;
            newcontact_EP.MobilePhone__c = MobilePhone;
            newcontact_EP.Title__c = Title;
            newcontact_EP.Contact__c = cid;
            newcontact_EP.GOO__c = GOO;
            newcontact_EP.SP_CFM__c = SP_CFM;
            newcontact_EP.SP_AAW__c=SP_AAW;
            newcontact_EP.NA_CCC__c=NA_CCC;
            newcontact_EP.NA_IFT__c=NA_IFT;
            newcontact_EP.NA_TNH__c=NA_TNH;
            newcontact_EP.RL_AAR__c=RL_AAR;
            newcontact_EP.RL_FEPR__c=RL_FEPR;
            newcontact_EP.RL_FTR__c=RL_FTR;
            newcontact_EP.RL_ITR__c=RL_ITR;
            newcontact_EP.RL_SAA__c=RL_SAA;
            newcontact_EP.RL_SFE__c=RL_SFE;
            newcontact_EP.RL_SFI__c=RL_SFI;
            newcontact_EP.RL_SIT__c=RL_SIT;
            newcontact_EP.RL_SST__c=RL_SST;
            newcontact_EP.RL_STR__c=RL_STR;
            newcontact_EP.SP_CDT__c=SP_CDT;
            newcontact_EP.SP_CFT__c=SP_CFT;
            newcontact_EP.SP_CIT__c=SP_CIT;
            
            newcontact_EP.oFirst_Name__c = oFirstName;
            newcontact_EP.oLast_Name__c = oLastName;
            newcontact_EP.oMobile_Phone__c = oMobilePhone;
            newcontact_EP.oTitle__c = oTitle;
            newcontact_EP.oGOO__c = oGOO;
            newcontact_EP.oSP_CFM__c = oSP_CFM;
            newcontact_EP.oSP_AAW__c=oSP_AAW;
            newcontact_EP.oNA_CCC__c=oNA_CCC;
            newcontact_EP.oNA_IFT__c=oNA_IFT;
            newcontact_EP.oNA_TNH__c=oNA_TNH;
            newcontact_EP.oRL_AAR__c=oRL_AAR;
            newcontact_EP.oRL_FEPR__c=oRL_FEPR;
            newcontact_EP.oRL_FTR__c=oRL_FTR;
            newcontact_EP.oRL_ITR__c=oRL_ITR;
            newcontact_EP.oRL_SAA__c=oRL_SAA;
            newcontact_EP.oRL_SFE__c=oRL_SFE;
            newcontact_EP.oRL_SFI__c=oRL_SFI;
            newcontact_EP.oRL_SIT__c=oRL_SIT;
            newcontact_EP.oRL_SST__c=oRL_SST;
            newcontact_EP.oRL_STR__c=oRL_STR;
            newcontact_EP.oSP_CDT__c=oSP_CDT;
            newcontact_EP.oSP_CFT__c=oSP_CFT;
            newcontact_EP.oSP_CIT__c=oSP_CIT;
             try{
                 insert newcontact_EP;
             }Catch(DMLException ex){
                
                sMessage += 'ERROR: ' + 'An exception has occurred. Please contact your System Administrator quoting the following message -- '+ ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
          
                Apexpages.Message errorMessage1 = new Apexpages.Message(ApexPages.Severity.ERROR,sMessage );
                Apexpages.addMessage(errorMessage1);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
                String[] toAddresses = new String[] {'Terri.Pittman@wolterskluwer.com','Elizabeth.Lubeck@wolterskluwer.com'};
                mail.setToAddresses(toAddresses) ;
                mail.setSubject('Preference Area Error!');
        
                String body = '<html lang="ja"><body>'+
                        '<br><br>'+
                        'This email alert is to bring to your notice that exception occured when <a href="https://na25.salesforce.com/' + cid + '">this Contact (' + cid + ')</a> tried to update their Email Preferences '+
                        '<br><br>'+
                        '<b>'+
                        'Here is detail of Exception '+
                        '</b>'+
                        '<br><br>'+ sMessage+
                        '<br><br>The Contact had submitted the following choices:'+
                        '<br><br>Global Opt Out = '+ GOO+
                        '<br><br><b>SOFTWARE</b>'+
                        '<br>Accounting & Audit Workflow = '+ SP_AAW+
                        '<br>Corporate Direct Tax = '+ SP_CDT+
                        '<br>Corporate Indirect Tax = '+ SP_CIT+
                        '<br>CPA Firm Management & Workflow = '+ SP_CFM+
                        '<br>CPA Firm Technology = '+ SP_CFT+
                        '<br><br><b>RESEARCH & LEARNING</b>'+
                        '<br>Accounting & Audit: Research = '+ RL_AAR+
                        '<br>Accounting & Audit: CPE/Seminars = '+ RL_SAA+
                        '<br>Federal Tax: Research = '+ RL_FTR+
                        '<br>Federal Tax: CPE/Seminars = '+ RL_SFI+
                        '<br>Finance & Estate Planning: Research = '+ RL_FEPR+
                        '<br>Finance & Estate Planning: CPE/Seminars = '+ RL_SFE+
                        '<br>International Tax: Research = '+ RL_ITR+
                        '<br>International Tax: CPE/Seminars = '+ RL_SIT+
                        '<br>State Tax: Research = '+ RL_STR+
                        '<br>State Tax: CPE/Seminars = '+ RL_SST+
                        '<br><br>CCH Connections Conference = '+ NA_CCC+
                        '<br>Intelligence for Taxation (Monthly) = '+ NA_IFT+
                        '<br>Tax News Headlines (Daily) = '+ NA_TNH+
                        '<br><br>'+ sMessage+
                        '</body></html>';
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                
                PageReference callPage = new PageReference('http://wolterskluwertaa.force.com/prefcenter/PA_Unavailable');
                return callPage;
             }
        } else if (str_cid.left(3) == '00Q'){
            newcontact_EP.FirstName__c = FirstName;
            newcontact_EP.LastName__c = LastName;
            newcontact_EP.MobilePhone__c = MobilePhone;
            newcontact_EP.Title__c = Title;
            newcontact_EP.Lead__c = cid;
            newcontact_EP.GOO__c = GOO;
            newcontact_EP.SP_CFM__c = SP_CFM;
            newcontact_EP.SP_AAW__c=SP_AAW;
            newcontact_EP.NA_CCC__c=NA_CCC;
            newcontact_EP.NA_IFT__c=NA_IFT;
            newcontact_EP.NA_TNH__c=NA_TNH;
            newcontact_EP.RL_AAR__c=RL_AAR;
            newcontact_EP.RL_FEPR__c=RL_FEPR;
            newcontact_EP.RL_FTR__c=RL_FTR;
            newcontact_EP.RL_ITR__c=RL_ITR;
            newcontact_EP.RL_SAA__c=RL_SAA;
            newcontact_EP.RL_SFE__c=RL_SFE;
            newcontact_EP.RL_SFI__c=RL_SFI;
            newcontact_EP.RL_SIT__c=RL_SIT;
            newcontact_EP.RL_SST__c=RL_SST;
            newcontact_EP.RL_STR__c=RL_STR;
            newcontact_EP.SP_CDT__c=SP_CDT;
            newcontact_EP.SP_CFT__c=SP_CFT;
            newcontact_EP.SP_CIT__c=SP_CIT;
            
            newcontact_EP.oFirst_Name__c = oFirstName;
            newcontact_EP.oLast_Name__c = oLastName;
            newcontact_EP.oMobile_Phone__c = oMobilePhone;
            newcontact_EP.oTitle__c = oTitle;
            newcontact_EP.oGOO__c = oGOO;
            newcontact_EP.oSP_CFM__c = oSP_CFM;
            newcontact_EP.oSP_AAW__c=oSP_AAW;
            newcontact_EP.oNA_CCC__c=oNA_CCC;
            newcontact_EP.oNA_IFT__c=oNA_IFT;
            newcontact_EP.oNA_TNH__c=oNA_TNH;
            newcontact_EP.oRL_AAR__c=oRL_AAR;
            newcontact_EP.oRL_FEPR__c=oRL_FEPR;
            newcontact_EP.oRL_FTR__c=oRL_FTR;
            newcontact_EP.oRL_ITR__c=oRL_ITR;
            newcontact_EP.oRL_SAA__c=oRL_SAA;
            newcontact_EP.oRL_SFE__c=oRL_SFE;
            newcontact_EP.oRL_SFI__c=oRL_SFI;
            newcontact_EP.oRL_SIT__c=oRL_SIT;
            newcontact_EP.oRL_SST__c=oRL_SST;
            newcontact_EP.oRL_STR__c=oRL_STR;
            newcontact_EP.oSP_CDT__c=oSP_CDT;
            newcontact_EP.oSP_CFT__c=oSP_CFT;
            newcontact_EP.oSP_CIT__c=oSP_CIT;
            try{
                 insert newcontact_EP;
            }Catch(DMLException ex){
                
                sMessage += 'ERROR: ' + 'An exception has occurred. Please contact your System Administrator quoting the following message -- '+ ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
          
                Apexpages.Message errorMessage1 = new Apexpages.Message(ApexPages.Severity.ERROR,sMessage );
                Apexpages.addMessage(errorMessage1);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
                String[] toAddresses = new String[] {'Terri.Pittman@wolterskluwer.com','Elizabeth.Lubeck@wolterskluwer.com'};
                mail.setToAddresses(toAddresses) ;
                mail.setSubject('Preference Area Error!');
        
                String body = '<html lang="ja"><body>'+
                        '<br><br>'+
                        'This email alert is to bring to your notice that exception occured when <a href="https://na25.salesforce.com/' + cid + '">this Lead (' + cid + ')</a> tried to update their Email Preferences  '+
                        '<br><br>'+
                        '<b>'+
                        'Here is detail of Exception '+
                        '</b>'+
                        '<br><br>'+ sMessage+
                        '<br><br>The Lead had submitted the following choices:'+
                        '<br><br>Global Opt Out = '+ GOO+
                        '<br><br><b>SOFTWARE</b>'+
                        '<br>Accounting & Audit Workflow = '+ SP_AAW+
                        '<br>Corporate Direct Tax = '+ SP_CDT+
                        '<br>Corporate Indirect Tax = '+ SP_CIT+
                        '<br>CPA Firm Management & Workflow = '+ SP_CFM+
                        '<br>CPA Firm Technology = '+ SP_CFT+
                        '<br><br><b>RESEARCH & LEARNING</b>'+
                        '<br>Accounting & Audit: Research = '+ RL_AAR+
                        '<br>Accounting & Audit: CPE/Seminars = '+ RL_SAA+
                        '<br>Federal Tax: Research = '+ RL_FTR+
                        '<br>Federal Tax: CPE/Seminars = '+ RL_SFI+
                        '<br>Finance & Estate Planning: Research = '+ RL_FEPR+
                        '<br>Finance & Estate Planning: CPE/Seminars = '+ RL_SFE+
                        '<br>International Tax: Research = '+ RL_ITR+
                        '<br>International Tax: CPE/Seminars = '+ RL_SIT+
                        '<br>State Tax: Research = '+ RL_STR+
                        '<br>State Tax: CPE/Seminars = '+ RL_SST+
                        '<br><br>CCH Connections Conference = '+ NA_CCC+
                        '<br>Intelligence for Taxation (Monthly) = '+ NA_IFT+
                        '<br>Tax News Headlines (Daily) = '+ NA_TNH+
                        
                        '</body></html>';
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                PageReference callPage = new PageReference('http://wolterskluwertaa.force.com/prefcenter/PA_Unavailable');
                return callPage;
             }
        }    
        //Use Math.Random function to assure page refreshes with updated information
        PageReference callPage = new PageReference('http://wolterskluwertaa.force.com/prefcenter/PA_Confirm?confirm='+Math.Random()+'&Id='+cid);
        return callPage;
    }
}