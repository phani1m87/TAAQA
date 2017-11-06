@isTest
public class EOI_Test_OrderAutomation 
{
    @testsetup static void prepareData()
    {
        EOI_Test_QuoteProposalTriggerHandler.myUnitTest();  
    }
    
    static testMethod void testEOIPlaceOrder_1()
    {
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.Access_Type__c = WK_Constants.EOI_Access_Type_Limited;
        objERPOrder.Shipping_Method__c = WK_Constants.EOI_ShippigMethod_2nd_Day_Delivery;
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testMethod void testEOIPlaceOrder_2()
    {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testmethod void testEOIPlaceOrder_3()
    {   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = true;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testmethod void testEOIPlaceOrder_4()
    {   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = true;
        objERPOrder.MYA_Term__c = 5;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testmethod void testEOIPlaceOrder_5()
    {   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = true;
        objERPOrder.MYA__c = true;
        objERPOrder.MYA_Term__c = 5;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testmethod void testEOIPlaceOrder_6()
    {   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        objERPOrder.Quote_Record_Type__c = WK_Constants.EOI_QuoteRecordType_SAP_Books;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testmethod void testEOIPlaceOrder_7()
    {   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EOI_OrderAutomationMock());
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.Quote_Record_Type__c = WK_Constants.EOI_QuoteRecordType_SAP_Books;
        objERPOrder.Renewal_Type__c = WK_Constants.EOI_Opt_In_Standing_Order;
        update objERPOrder;
        List<Id> lstERPOrderIds = new List<Id>();
        lstERPOrderIds.add(objERPOrder.Id);  
        EOI_OrderAutomation.EOI_PlaceOrder(lstERPOrderIds);
        Test.stopTest();
    }
    
    static testMethod void testRetryLogFromCalloutResponse()
    {
        Test.startTest();
        EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result = createOrderSubmissionResponseType();
        Id erpOrderId = [SELECT Id FROM ERP_Order__c].Id;
        //createWebServiceRetryLogs(erpOrderId);
        Map<Id, ERP_Order__c> ERPOrderWithRetryLogMap = new Map<Id, ERP_Order__c>([SELECT Id, Name, Quote_Record_Type__c, (SELECT Id, ERPOrderId__c, RetrySequenceNumber__c FROM Webservice_Retry_Log__r) FROM ERP_Order__c WHERE Id =: erpOrderId ]);// DESC LIMIT 1];
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        result.orderSubmissionAcknowledgement.StatusCode = '503';
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        result.orderSubmissionAcknowledgement.StatusCode = '503';
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        result.orderSubmissionAcknowledgement.StatusCode = '400';
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        result.orderSubmissionAcknowledgement.StatusCode = '504';
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        result.orderSubmissionAcknowledgement.StatusCode = '1';
        EOI_OrderAutomation.EOIRetryLogFromCalloutResponse(result, erpOrderId, ERPOrderWithRetryLogMap);
        
        /*
        List<ERP_Order__c> ERPOrderListWithLineItems = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c];
        System.debug('#### : ' + ERPOrderListWithLineItems);
        if(ERPOrderListWithLineItems != NULL && ERPOrderListWithLineItems.size() > 0)
        {
            ERPOrderListWithLineItems[0].ASA__c = true;
            ERPOrderListWithLineItems[0].Stub_Flag__c = false;
            ERPOrderListWithLineItems[0].MYA__c = false;
            update ERPOrderListWithLineItems[0];    
        }
        */
        Test.stopTest();
    }
    
    public static EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType createOrderSubmissionResponseType()
    {
        EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType();
        result.uuidMetaDataRequest = null;
        
        EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType objMetaDataResponseType = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType();
        objMetaDataResponseType.authenticationSuccessfulFlag = 'Y';
        objMetaDataResponseType.esbBrokerName = 'TAABRK';
        objMetaDataResponseType.esbHostName = 'WKGSSIIBBQ01';
        objMetaDataResponseType.providerSystemName = 'IIB';
        objMetaDataResponseType.responseDateTime = DateTime.valueOf('2017-03-18 16:47:44');
        result.uuidMetaDataResponse = objMetaDataResponseType;
        
        EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType objOrderSubmissionAcknowledgement = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType();
        objOrderSubmissionAcknowledgement.Status = 'PENDING';
        objOrderSubmissionAcknowledgement.StatusCode = '500';
        objOrderSubmissionAcknowledgement.StatusDescription = 'Message queued in IIB to be sent to SAP';
        result.orderSubmissionAcknowledgement = objOrderSubmissionAcknowledgement;
        
        result.errorMessages = null;
        
        return result;
    }
    /*
    static void createWebServiceRetryLogs(Id erpOrderId)
    {
        List<EOI_Retry_Log__c> lstWebSerRetryLogs = new List<EOI_Retry_Log__c>();
        for(integer i = 0; i<5; i++)
        {
            lstWebSerRetryLogs.add(new EOI_Retry_Log__c(ERPOrderId__c = erpOrderId, RetrySequenceNumber__c = String.valueOf(i)));
        }
        
        if(lstWebSerRetryLogs.size() > 0){
            insert lstWebSerRetryLogs;
        }
    }
    */
}