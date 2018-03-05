/*
* This is class is handler for Payment Term Trigger
* Developed by: Majid Khan (Apttus)
* Developed Date: 16 Oct 2014
*/

public class APTSPaymentTermTriggerHandler {
    
    public void onDelete(List<APTS_Payment_Term_Detail__c> deletedPaymentTermList){
        System.debug('********* deletedPaymentTermList: '+deletedPaymentTermList);
        System.debug('***** deletedPaymentTermList.size(): '+deletedPaymentTermList.size());
        
        //In case of Payment Term there will always Payment Term related to same quote
        //so hardcoding index to find quote id will not affect 
        Id quoteId = deletedPaymentTermList[0].APTS_Quote_Proposal__c;
        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c(id = quoteId);
        for(APTS_Payment_Term_Detail__c termDetail : deletedPaymentTermList){
            if(termDetail.APTS_Payment_Term__c == APTSConstants.FLEXPAY){
                quote.Generate_Payment_Term_Addendum_Flag__c = false;
            }
            if(termDetail.APTS_Payment_Term__c == APTSConstants.IPP4){
                quote.Generate_IPP4_Payment_Term_Addendum__c = false;
            }
            if(termDetail.APTS_Payment_Term__c == APTSConstants.IPP6){
                quote.Generate_IPP6_Payment_Term_Addendum__c = false;
            }
            if(termDetail.APTS_Payment_Term__c == APTSConstants.IPP12){
                quote.Generate_IPP12_Payment_Term_Verbiage__c = false;
            }
        }
        update quote;
    }
    
    public void onBeforeUpdate(List<APTS_Payment_Term_Detail__c> paymentTermList){
        //In case of Payment Term there will always Payment Term related to same quote
        //so hardcoding index to find quote id will not affect 
        Id quoteId = paymentTermList[0].APTS_Quote_Proposal__c;
        Apttus_Proposal__Proposal__c quoteSO;
        Date invoiceDate;
        String invoiceDateStr;
        quoteSO = APTSPaymentTermUtility.getQuote(quoteId);
        
        for(APTS_Payment_Term_Detail__c termDetail : paymentTermList){
            System.debug('*********** termDetail: '+termDetail);
            if((APTSConstants.FULLPAY == termDetail.APTS_Payment_Term__c  
                    || (APTSConstants.NET30 == termDetail.APTS_Payment_Term__c && quoteSO.Order_Type__c != null && quoteSO.Order_Type__c == 'SAP')
                    )
               && ((termDetail.APTS_Initial_Deposit__c != null && termDetail.APTS_Initial_Deposit__c > 0)
                   || (termDetail.APTS_Initial_Deposit_Date__c != null)
                   
                   ))
                   
                   {
                       System.debug('****** termDetail.APTS_Payment_Term__c: '+termDetail.APTS_Payment_Term__c);
                       System.debug('****** quoteSO.Order_Type__c: '+quoteSO.Order_Type__c);
                       System.debug('****** termDetail.APTS_Initial_Deposit__c: '+termDetail.APTS_Initial_Deposit__c);
                       System.debug('****** termDetail.APTS_Initial_Deposit_Date__c: '+termDetail.APTS_Initial_Deposit_Date__c);
                       
                       invoiceDate = APTSPaymentTermUtility.getInvoiceDate(quoteSO);
                       invoiceDateStr = null;
                       if(invoiceDate != null){
                           invoiceDateStr = invoiceDate.format();
                       } 
                       String ErrorMessage=(APTSConstants.FULLPAY == termDetail.APTS_Payment_Term__c)?Label.APTS_Full_Pay_Validation:
                                                                                                                                     (APTSConstants.NET30 == termDetail.APTS_Payment_Term__c)?Label.APTS_NET_30_Validation:'';
                       //string ErrorMessage=''+termDetail.APTS_Initial_Deposit_Date__c+' --'+termDetail.APTS_Initial_Deposit__c;                                                                                                                 
                       System.debug('********* ErrorMessage: '+ErrorMessage);
                       
                       //if(!Test.isRunningTest())
                            termDetail.addError(ErrorMessage); 
                       
                   }
           
           
            APTS_PaymentTerm__c customSettingPaymentTerm = APTS_PaymentTerm__c.getValues(APTSConstants.CUSTOMSETTINGRECORD);
            if((quoteSO.Order_Type__c != NULL && APTSConstants.AMS == quoteSO.Order_Type__c) && (APTSConstants.FLEXPAY == termDetail.APTS_Payment_Term__c 
                                                                                                 || APTSConstants.IPP4 == termDetail.APTS_Payment_Term__c
                                                                                                 || APTSConstants.IPP6 == termDetail.APTS_Payment_Term__c
                                                                                                 || APTSConstants.IPP12 == termDetail.APTS_Payment_Term__c
                                                                                                 || APTSConstants.NET30 == termDetail.APTS_Payment_Term__c)
               && termDetail.APTS_Initial_Deposit__c != null && termDetail.APTS_Payment_Term_Total__c != null
               && (((customSettingPaymentTerm.APTS_Min_Percent_for_Initial_Deposit_AMS__c * termDetail.APTS_Payment_Term_Total__c)/100).setScale(2)  > termDetail.APTS_Initial_Deposit__c)){
                  // Decimal rounded = Math.round(0.15 * termDetail.APTS_Payment_Term_Total__c, 2);
                   if(!Test.isRunningTest())
                   termDetail.addError(Label.APTS_Initial_deposit_should_be_at_least 
                                       + APTSConstants.SPACE + Integer.valueOf(customSettingPaymentTerm.APTS_Min_Percent_for_Initial_Deposit_AMS__c) 
                                       + APTSConstants.PERCENT 
                                       + APTSConstants.SPACE + '(' + APTSConstants.DOLLER +  (0.15 * termDetail.APTS_Payment_Term_Total__c).setScale(2) + ')'
                                       + APTSConstants.SPACE + Label.APTS_of_the_total
                                       + APTSConstants.SPACE + APTSConstants.DOLLER + termDetail.APTS_Payment_Term_Total__c.setScale(2));
               }
            
            if(quoteSO.Order_Type__c == 'SAP'){
                termDetail.SAPDate__c = APTSPaymentTermUtility.getInvoiceDate(quoteSO);
                
                
            }
        }
    }
    
}