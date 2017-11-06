public class APTSPaymentTermUtility {
    
    public static Apttus_Proposal__Proposal__c getQuote(Id quoteId){
        Apttus_Proposal__Proposal__c quoteSO = [SELECT ID, ASA__c
                                                , Advance_Period_End_Date__c
                                                , Order_Creation_Date__c
                                                , Order_Type__c
                                                , SAP_Payment_Terms__c
                                               FROM Apttus_Proposal__Proposal__c
                                               WHERE ID = : quoteId];
        return quoteSO;
    }
    
    public static Date getInvoiceDate(Apttus_Proposal__Proposal__c quoteSO){
        Date invoiceDate;        
        invoiceDate = quoteSO.ASA__c ? quoteSO.Advance_Period_End_Date__c
            : quoteSO.Advance_Period_End_Date__c!= null ? quoteSO.Advance_Period_End_Date__c
            : quoteSO.Order_Creation_Date__c;
        return invoiceDate;
    }
    
}