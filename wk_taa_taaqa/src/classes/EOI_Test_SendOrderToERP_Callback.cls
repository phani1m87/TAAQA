@isTest
private class EOI_Test_SendOrderToERP_Callback 
{
    @testsetup static void startup() 
    {
        EOI_Test_QuoteProposalTriggerHandler.myUnitTest();
    }
    
    static testMethod void testCallBackWebservice()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        EOI_SendOrderToERP_Callback_V2.callbackInfo objCallbackInfo = new EOI_SendOrderToERP_Callback_V2.callbackInfo();
        objCallbackInfo.statusCode = 'E';
        objCallbackInfo.statusDescription = 'Test Description';
        objCallbackInfo.sfdc_OrderIDKey = objERPOrder.Name;
        objCallbackInfo.erp_OrderIDKey = 'Test ERP Key';
        objCallbackInfo.providerSystemName = 'Test';
        objCallbackInfo.responseDateTime = System.Now();
        objCallbackInfo.esbHostName = 'Test';
        objCallbackInfo.esbBrokerName = 'Test';
        objCallbackInfo.UUID = 'Test';
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        Test.stopTest();
    }
    
    static testMethod void testCallBackWebservice_SAP_ERROR_E()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        EOI_SendOrderToERP_Callback_V2.callbackInfo objCallbackInfo = new EOI_SendOrderToERP_Callback_V2.callbackInfo();
        objCallbackInfo.statusCode = 'E';
        objCallbackInfo.statusDescription = 'Test Description';
        objCallbackInfo.sfdc_OrderIDKey = objERPOrder.Name;
        objCallbackInfo.erp_OrderIDKey = 'Test ERP Key';
        objCallbackInfo.providerSystemName = 'Test';
        objCallbackInfo.responseDateTime = System.Now();
        objCallbackInfo.esbHostName = 'Test';
        objCallbackInfo.esbBrokerName = 'Test';
        objCallbackInfo.UUID = 'Test';
        
        List<EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type> lstSAPReturnType = new List<EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type>();
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objSAP = new EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type();
        objSAP.Type = 'E';
        objSAP.ID = 'TestId';
        objSAP.SAP_NUMBER = '001';
        objSAP.MESSAGE = 'ERROR';
        lstSAPReturnType.add(objSAP);
        objCallbackInfo.listOfSAPReturnResults = lstSAPReturnType;
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        objCallbackInfo.sfdc_OrderIDKey = '';
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        objCallbackInfo.UUID = '';
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        objCallbackInfo.responseDateTime = NULL;
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        objCallbackInfo.statusCode = '';
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        objCallbackInfo.statusDescription = '';
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        
        Test.stopTest();
    }
    
     static testMethod void testCallBackWebservice_SAP_ERROR_S()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        EOI_SendOrderToERP_Callback_V2.callbackInfo objCallbackInfo = new EOI_SendOrderToERP_Callback_V2.callbackInfo();
        objCallbackInfo.statusCode = 'S';
        objCallbackInfo.statusDescription = 'Test Description';
        objCallbackInfo.sfdc_OrderIDKey = objERPOrder.Name;
        objCallbackInfo.erp_OrderIDKey = 'Test ERP Key';
        objCallbackInfo.providerSystemName = 'Test';
        objCallbackInfo.responseDateTime = System.Now();
        objCallbackInfo.esbHostName = 'Test';
        objCallbackInfo.esbBrokerName = 'Test';
        objCallbackInfo.UUID = 'Test';
        
        List<EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type> lstSAPReturnType = new List<EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type>();
        EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type objSAP = new EOI_SendOrderToERP_Callback_V2.SAP_RETURN_Type();
        objSAP.Type = 'S';
        objSAP.ID = 'TestId';
        objSAP.SAP_NUMBER = '001';
        objSAP.MESSAGE = 'ERROR';
        lstSAPReturnType.add(objSAP);
        objCallbackInfo.listOfSAPReturnResults = lstSAPReturnType;
        
        List<EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type> lstSalesType = new List<EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type>();
        EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type objSales = new EOI_SendOrderToERP_Callback_V2.SALES_DOCUMENTS_Type();
        objSales.SOURCE_ORDER_ID = '123456789012';
        objSales.SAP_DOC_ID = 'DOC01';
        objSales.SAP_DOC_TYPE = 'Test';
        lstSalesType.add(objSales);
        objCallbackInfo.listOfSAPSalesDocuments = lstSalesType;
        
        List<EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type> lstMessage = new List<EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type>();
        EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type objMessage = new EOI_SendOrderToERP_Callback_V2.MESSAGE_ID_Type();
        objMessage.SFDC_ID = '123456789012';
        objMessage.IIB_ID = '123456789012';
        objMessage.SAPPI_ID = '123456789012';
        lstMessage.add(objMessage);
        objCallbackInfo.listOfTransactionIDs = lstMessage;
        EOI_SendOrderToERP_Callback_V2.callbackOrderProcessingStatus(objCallbackInfo);
        Test.stopTest();
    }
}