@isTest
private class EOI_Test_Order_OrderProduct_Controller 
{
    @testsetup static void startup() 
    {
        EOI_Test_QuoteProposalTriggerHandler.myUnitTest();
    }
    
    static testmethod void testPage()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_InsertRecord();
        objController.EOI_RedirectToOrderProduct();
        objController.EOI_GetOrderStatus();
        objController.EOI_AddERPOrderProduct();
        ApexPages.currentPage().getParameters().put('rowIndex', '0');
        objController.EOI_DelERPOrderProduct();
        objController.uuid = 'test';
        objController.sourceSystemName = 'test';
        objController.providingSystemName = 'test';
        objController.transactionMonitoringFlag = 'test';
        objController.loggingFlag = 'test';
        objController.serviceVersion = 'test';
        Test.stopTest();
    }
    
    static testmethod void testRedirectToOrderProduct1()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    static testmethod void testRedirectToOrderProduct2()
    {
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = true;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    
    static testmethod void testRedirectToOrderProduct3()
    {   
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = true;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    
    static testmethod void testRedirectToOrderProduct4()
    {   
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = true;
        objERPOrder.MYA_Term__c = 5;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    static testmethod void testRedirectToOrderProduct5()
    {   
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = true;
        objERPOrder.MYA__c = true;
        objERPOrder.MYA_Term__c = 5;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    /*
    static testmethod void testRedirectToOrderProduct6()
    {   
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = true;
        objERPOrder.MYA__c = true;
        objERPOrder.MYA_Term__c = 5;
        objERPOrder.UseOrderTriggerCallout__c = true;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
    }
    */
    static testmethod void testRedirectToOrderProduct7()
    {   
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.ASA__c = false;
        objERPOrder.Stub_Flag__c = false;
        objERPOrder.MYA__c = false;
        objERPOrder.Quote_Record_Type__c = WK_Constants.EOI_QuoteRecordType_SAP_Books;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
    
    static testmethod void testRedirectToOrderProduct8()
    {   
        Test.startTest();
        ERP_Order__c objERPOrder = [SELECT Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c, Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName,MYA_Year_2_Start_Date__c,MYA_Year_2_End_Date__c,MYA_Year_3_Start_Date__c,MYA_Year_3_End_Date__c,MYA_Year_4_Start_Date__c,MYA_Year_4_End_Date__c,MYA_Year_5_Start_Date__c,MYA_Year_5_End_Date__c,MYA_Term_End_Date__c, MYA_Term__c, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c, Year_2_Net_Price__c, Year_3_Net_Price__c, Year_4_Net_Price__c, Year_5_Net_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c LIMIT 1];
        objERPOrder.Quote_Record_Type__c = WK_Constants.EOI_QuoteRecordType_SAP_Books;
        objERPOrder.Renewal_Type__c = WK_Constants.EOI_Opt_In_Standing_Order;
        objERPOrder.Shipping_Method__c = WK_Constants.EOI_ShippigMethod_Next_Day_PM_Delivery;
        objERPOrder.Access_Type__c = WK_Constants.EOI_Access_Type_Limited;
        update objERPOrder;
        ApexPages.StandardController stdController = new ApexPages.StandardController(objERPOrder);
        EOI_Order_OrderProduct_Controller_V7 objController = new EOI_Order_OrderProduct_Controller_V7(stdController);
        objController.EOI_RedirectToOrderProduct();
        Test.stopTest();
    }
}