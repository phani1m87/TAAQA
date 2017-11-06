/*
 * Controller for Order_OrderProduct_Entry AOP Test Harnes Page
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 06/14/2017 SHIVAJI           1.5          AOP1.5 Changes
 * 10/23/2017 SHIVAJI           2.0          AOP2.0 Changes SMS-900
 * ------------------------------------------------------------------------- */

public with sharing class EOI_Order_OrderProduct_Controller_V7 
{
    public ERP_Order__c newERPOrder{get;set;}
    public ApexPages.StandardController stdController;
    public ERP_Order_Line_Item__c newERPOrderProduct {get;set;}
    public String uuid{get; set;}
    public String sourceSystemName {get; set;}
    public String providingSystemName {get; set;}
    public String transactionMonitoringFlag {get; set;}
    public String loggingFlag {get; set;}
    public String serviceVersion {get; set;}
    public List<ERP_Order_Line_Item__c> listERPOrderLineItems {get; set;}
    private List<ERP_Order_Line_Item__c> listERPOrderLineItemsToInsert {get; set;}
    public string orderURL{get;set;}
    public EOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseType result {get; set;}
    public EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataRequestType uuidMetaDataRequestFromResult{get;set;}
    public EOI_IIB_ERPOrderCallout_V7.OrderSubmissionAcknowledgementType acknoledgementTypeResult {get;set;}
    public EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataResponseType uuidMetaDataResponseFromResult{get;set;}
    public EOI_IIB_ERPOrderCallout_V7.ErrorMessagesType errorMessagesFromResult{get;set;}
    public EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType  newAccountOrderElement{get;set;}
    //public EOI_IIB_ERPOrderCallout_V7.IIBACKType IIBACKFromResult{get;set;}
    public Integer rowIndex {get;set;}
    //public AsyncWolterskluwerSfdc02_V3.DT_SFDC_ACC_ORDFuture SFDC_ACC_Ord_Future;
    public  AsyncEOI_IIB_ERPOrderCallout_V7.OrderSubmissionResponseTypeFuture  SFDCAccountOrderObj;
    public integer countProduct;
    public String controllerVersion{get;set;}
    public EOI_Order_OrderProduct_Controller_V7()
    {}
    
    public EOI_Order_OrderProduct_Controller_V7(ApexPages.StandardController stdController)
    {
        countProduct = 1;
        this.stdController = stdController;
        this.newERPOrder = (ERP_Order__c)stdController.getRecord();
        
        
        listERPOrderLineItems = new List<ERP_Order_Line_Item__c>();
        listERPOrderLineItemsToInsert = new List<ERP_Order_Line_Item__c>();
        newERPOrderProduct = new ERP_Order_Line_Item__c(Item_Sequence__c = countProduct);
        listERPOrderLineItems.add(newERPOrderProduct);
        controllerVersion = 'EOI_Order_OrderProduct_Controller_V6';
    }
    
    public Pagereference EOI_InsertRecord()
    {
        try
        {
            stdController.save();
            newERPOrder.Id = stdController.getId();
            system.debug('ERP Order :: '+newERPOrder);
            system.debug('ERP Order Line Item List :: '+listERPOrderLineItems);
            for(ERP_Order_Line_Item__c newERPOrderLineItem : listERPOrderLineItems)
            {
                if(!isOrderProductEmpty(newERPOrderLineItem))//Check whether record is empty
                {   
                    newERPOrderLineItem.ERP_Order__c = newERPOrder.Id;
                    listERPOrderLineItemsToInsert.add(newERPOrderLineItem);
                }
            }
            insert listERPOrderLineItemsToInsert;
            orderURL = System.URL.getSalesforceBaseUrl().toExternalForm()+'\\'+newERPOrder.Id;
        }
        catch(Exception ex)
        {
            system.debug('EXCEPTION'+ex);
        }
        return null;
    }
    
    public Continuation EOI_RedirectToOrderProduct()
    {       
        //serviceController = new OrderAutomationServiceController();
        ERP_Order__c currentERPOrder = [SELECT Id, Name FROM ERP_Order__c WHERE Id =: newERPOrder.Id];
        System.debug('ERP_Order__c'+currentERPOrder.Name);
        if(newERPOrder.UseOrderTriggerCallout__c)
        {
            ERP_Order__c currentERPOrderToUpdate = new ERP_Order__c(Id=newERPOrder.Id, Order_Submission_Status__c = 'Ready For Submission');
            update currentERPOrderToUpdate;
            return null;
        }
        else
        {
            List<ERP_Order__c> ERPOrderListWithLineItems = [SELECT MYA_Year_5_Start_Date__c, MYA_Year_5_End_Date__c, MYA_Year_4_Start_Date__c, MYA_Year_4_End_Date__c, MYA_Year_3_Start_Date__c, MYA_Year_3_End_Date__c, MYA_Year_2_End_Date__c, MYA_Year_2_Start_Date__c, MYA_Term__c, MYA_Term_End_Date__c, Authentication_Type__c, Stub_Flag__c, Number_of_Concurrent_Users__c,One_Line_Invoice_Header__c, Access_Type__c,Renewal_Type__c,Quote_Record_Type__c,MYA__c, ASA__c,Rush_Order__c,IC_Admin_First_Name__c, IC_Admin_Last_Name__c,IC_Admin_Phone__c, IC_Admin_Email__c, IDs_to_be_issued__c, Max_IDs_allowed__c,Bill_To_Street_2__c,Bill_To_Street_1__c, Bill_To_City__c, Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Phone__c, Ship_To_City__c, Ship_To_Country__c, Ship_To_Partner_Number__c, Ship_To_Phone__c, Ship_To_Postal_Code__c, Ship_To_State__c, Ship_To_Street_1__c, Ship_To_Street_2__c, Stub_Year_Start_Date__c, Stub_Year_End_Date__c, Advance_Start_Date__c, Advance_End_Date__c,Contract_Start_Date__c, Contract_End_Date__c, Name, Payment_Term__c, Shipping_Method__c, Selling_DTN__c, Inventory_DTN__c, Split_Commission__c, Credit_Card_Type__c, Credit_Card_Cyber_Source_Token__c, Credit_Card_Expiration__c, Name_on_Card__c, Bill_To_Partner_Number__c, Customer_X_Ref__c,Customer_X_Ref__r.ApplicationID__c, SFDC_Account__r.Name, SFDC_Account__c, SFDC_Account__r.Market_Segment__c, SFDC_Account__r.Market_Sub_Segment__c, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName, (SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Items__r) FROM ERP_ORDER__c WHERE Id = :newERPOrder.Id];
            List<ERP_Order_Line_Item__c> ERPOrderProductList = [SELECT ID, Item_Sequence__c, Line_Number__c, Net_Adjustment__c, Net_Price__c, List_Price__c,Parent_Product__c, Product__c, Product_Code__c, Promo_Code__c, Quantity__c, Parent_Product__r.ProductCode FROM ERP_Order_Line_Item__c WHERE ID IN :listERPOrderLineItemsToInsert];
            ERP_Order__c newERPOrderQueried =  ERPOrderListWithLineItems[0];
            system.debug('newERPOrder.ERPOrderProductList'+ERPOrderProductList);
            system.debug('listERPOrderLineItemsToInsert'+listERPOrderLineItemsToInsert);
            newAccountOrderElement =  getMapping(newERPOrderQueried, newERPOrder.ERP_Order_Line_Items__r);
            //AsyncEOI_Sap_Rfc_Functions_V2.ZSFDC_ONLINE_ACCOUNT_ORDER_Response_elementFuture result;
            
            Integer timeOutSecond = 120;  
            Continuation cont = new Continuation(timeOutSecond);
            cont.continuationMethod = 'EOI_GetOrderStatus';
       
            try
            {
                AsyncEOI_IIB_ERPOrderCallout_V7.AsyncTAASalesOrderSubmissionSOAP stub = new AsyncEOI_IIB_ERPOrderCallout_V7.AsyncTAASalesOrderSubmissionSOAP();
                SFDCAccountOrderObj = stub.beginTAAOrderSubmission(cont,newAccountOrderElement.ORDER_HEADER,newAccountOrderElement.CONTRACT_PERIODS_PRICE,newAccountOrderElement.CREDIT_CARD,newAccountOrderElement.CUSTOMER_ADDRESS,newAccountOrderElement.CUSTOMER_HEADER,newAccountOrderElement.ORDER_ITEM,newAccountOrderElement.ORDER_TEXT,newAccountOrderElement.SPLIT_SALES,newAccountOrderElement.uuidMetaDataRequest);
            }                                                       
            catch(Exception ex)
            {
                system.debug(ex.getMessage());
            }
            
            //processResponse();*/
            system.debug('Return element'+SFDCAccountOrderObj);
            return cont;
        }    
    }   
    
    public pageReference EOI_GetOrderStatus() 
    {    
        if(SFDCAccountOrderObj != null)
        {
            result = SFDCAccountOrderObj.getValue();
            uuidMetaDataRequestFromResult = result.uuidMetaDataRequest;
            uuidMetaDataResponseFromResult = result.uuidMetaDataResponse;
            acknoledgementTypeResult = result.orderSubmissionAcknowledgement;
            //IIBACKFromResult = result.IIBACK;
            errorMessagesFromResult = result.errorMessages;
            system.debug('inside EOI_GetOrderStatus() 2'+result);

            insert EOI_ApplicationLoggingUtility.ApplicationLogFromCalloutResponse( 'OrderAutomationController', 'EOI_GetOrderStatus',newAccountOrderElement.toString(),result, newERPOrder.Name, newERPOrder.Id,'');
            //insert EOI_LoggerUtility.createAppilcationLog('weservice callout', 'OrderAutomationServiceController', 'EOI_GetOrderStatus',newAccountOrderElement.toString(),result.toString(),'', result.orderSubmissionAcknowledgement.Status, result.orderSubmissionAcknowledgement.StatusDescription, newERPOrder.Id);
            if(result.orderSubmissionAcknowledgement.Status == 'Pending')
            {
                ERP_Order__c currentERPOrderToUpdate;
                currentERPOrderToUpdate = new ERP_Order__c(Id=newERPOrder.Id, Order_Submission_Status__c = 'Pending ERP Submission');
                update currentERPOrderToUpdate;
            }
            else if(result.orderSubmissionAcknowledgement.Status == 'Failed')
            {
                ERP_Order__c currentERPOrderToUpdate = new ERP_Order__c(Id=newERPOrder.Id, Order_Submission_Status__c = 'Order Submission Failed');
                update currentERPOrderToUpdate;
            }
        }
        return null;//new PageReference('/' + newERPOrder.Id); 
    }
    
    public PageReference EOI_AddERPOrderProduct() 
    {
        system.debug('countProduct :: '+countProduct);
        ERP_Order_Line_Item__c newERPOrderProduct = new ERP_Order_Line_Item__c(Item_Sequence__c = ++countProduct);
        listERPOrderLineItems.add(newERPOrderProduct); // vf render this list with new added wrapper
        return null;
    }
    
    public pageReference EOI_DelERPOrderProduct()
    {
        //Integer toDelPos=-1;
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        //system.debug('indexVal :: '+indexVal);
        {
            listERPOrderLineItems.remove(rowIndex);
        }
        return null;
    }

    private boolean isOrderProductEmpty(ERP_Order_Line_Item__c newERPOrderLineItem)
    {
        if( newERPOrderLineItem.Net_Adjustment__c == null && newERPOrderLineItem.List_Price__c == null && newERPOrderLineItem.Product__c == null && newERPOrderLineItem.Product_Code__c == null && newERPOrderLineItem.Promo_Code__c == null && newERPOrderLineItem.Quantity__c == null)
            return true;
        return false;
    }
    private static EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType getMapping(ERP_Order__c orderDetailsObj, List<ERP_Order_Line_Item__c> orderLineItemList)
        {
            //ERP_Order__c orderDetailsObj = newERPOrder;
            //system.debug('ERP Order Id in save method'+newERPOrder);
            //EOI_IIB_ERPOrderCallout_V7.HTTPS_Port orderAutomationStub = new EOI_IIB_ERPOrderCallout_V7.HTTPS_Port();
            
            //#TechnicalDebt If this class throws an error, what happens?
            EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType sfdc_acc_element = new EOI_IIB_ERPOrderCallout_V7.OrderSubmissionRequestType ();
            
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERArrayType  customer_Header_Element= new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERArrayType ();
            
            List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType> customer_Header_List = new List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType>();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType customer_Header = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_HEADERType();
            //Need to reevaluate
            customer_Header.PARTNER_NUMBER = orderDetailsObj.Customer_X_Ref__r.ApplicationID__c;
            //customer_Header.ITEM_NUMBER = '1';
            customer_Header.PARTNER_TYPE = 'AG';
            customer_Header.COMPANYNAME = orderDetailsObj.SFDC_Account__r.Name;
            customer_Header.FIRSTNAME = orderDetailsObj.Primary_Contact__r.FirstName;
            customer_Header.LASTNAME = orderDetailsObj.Primary_Contact__r.LastName;
            customer_Header.IDTYPE = 'SFDC-TAA';
            customer_Header.IDNUMBER = orderDetailsObj.SFDC_Account__c;
            customer_Header.SALES_ORG = 'US1000000000';
            customer_Header.DISTR_CHANNEL = '10';
            customer_Header.DIVISION = '10';
            //customer_Header.CUST_GROUP = 
            customer_Header.CUST_GROUP1 = orderDetailsObj.SFDC_Account__r.Market_Segment__c;
            customer_Header.CUST_GROUP2 = orderDetailsObj.SFDC_Account__r.Market_Sub_Segment__c;
            //customer_Header.CUST_GROUP5
            customer_Header.ACCESS_TYPE = (orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_All)?'01'
                                            :(orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_All_Link)?'02'
                                            :(orderDetailsObj.Access_Type__c == WK_Constants.EOI_Access_Type_Limited)?'03'
                                            :'';
            //customer_Header.USER_TYPE
            customer_Header.IDISSUED = string.valueOf(orderDetailsObj.IDs_to_be_issued__c);
            customer_Header.MAXUSER = string.valueOf(orderDetailsObj.Max_IDs_allowed__c);
            //customer_Header.concurrentUser = orderDetailsObj.Number_of_Concurrent_Users__c
            customer_Header.DA_FIRSTNAME = orderDetailsObj.IC_Admin_First_Name__c;
            customer_Header.DA_LASTNAME = orderDetailsObj.IC_Admin_Last_Name__c;
            customer_Header.DA_PHONE = orderDetailsObj.IC_Admin_Phone__c;
            customer_Header.DA_EMAIL = orderDetailsObj.IC_Admin_Email__c;
            
            customer_Header_List.add(customer_Header);
            customer_Header_Element.CUSTOMER_HEADERs = customer_Header_List;
            sfdc_acc_element.CUSTOMER_HEADER = customer_Header_Element;
            
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSArrayType customer_Address_Element = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSArrayType();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType[] customer_Address_List = new List<EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType>();
            EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType customer_Address = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType();
            //Need to reevaluate
            customer_Address.PARTNER_NUMBER = orderDetailsObj.Bill_To_Partner_Number__c; 
            customer_Address.PARTNER_TYPE = 'RE';
            //Need to reevaluate
            customer_Address.ITEM_NUMBER = '000000';
            customer_Address.STREET = orderDetailsObj.Bill_To_Street_1__c;
            customer_Address.BUILDING = orderDetailsObj.Bill_To_Street_2__c; 
            //customer_Address.FLOOR;
            //customer_Address.ROOMNUMBER;
            customer_Address.CITY = orderDetailsObj.Bill_To_City__c;
            //customer_Address.DISTRICT;
            customer_Address.CITY_PCODE = orderDetailsObj.Bill_To_Postal_Code__c;
            customer_Address.STATE = orderDetailsObj.Bill_To_State__c;
            customer_Address.COUNTRY = orderDetailsObj.Bill_To_Country__c;
            //customer_Address.PO_BOX;
            //customer_Address.PO_BOX_POSTAL_CODE;
            //customer_Address.PO_BOX_CITY;
            //customer_Address.PO_BOX_REGION;
            customer_Address.TEL_NUMBER = orderDetailsObj.Bill_To_Phone__c;
            //customer_Address.EXTENSION;
            //customer_Address.EMAIL
            customer_Address_List.add(customer_Address);
            
            customer_Address = new EOI_IIB_ERPOrderCallout_V7.CUSTOMER_ADDRESSType();
            //Need to reevaluate
            customer_Address.PARTNER_NUMBER = orderDetailsObj.Ship_To_Partner_Number__c; 
            customer_Address.PARTNER_TYPE = 'WE';
            //Need to reevaluate
            customer_Address.ITEM_NUMBER = '000000';
            customer_Address.STREET = orderDetailsObj.Ship_To_Street_1__c;
            customer_Address.BUILDING = orderDetailsObj.Ship_To_Street_2__c; 
            //customer_Address.FLOOR;
            //customer_Address.ROOMNUMBER;
            customer_Address.CITY = orderDetailsObj.Ship_To_City__c;
            //customer_Address.DISTRICT;
            customer_Address.CITY_PCODE = orderDetailsObj.Ship_To_Postal_Code__c;
            customer_Address.STATE = orderDetailsObj.Ship_To_State__c;
            customer_Address.COUNTRY = orderDetailsObj.Ship_To_Country__c;
            //customer_Address.PO_BOX;
            //customer_Address.PO_BOX_POSTAL_CODE;
            //customer_Address.PO_BOX_CITY;
            //customer_Address.PO_BOX_REGION;
            customer_Address.TEL_NUMBER = orderDetailsObj.Ship_To_Phone__c;
            //customer_Address.EXTENSION;
            //customer_Address.EMAIL
            customer_Address_List.add(customer_Address);
            
            customer_Address_Element.CUSTOMER_ADDRESSs = customer_Address_List;
            sfdc_acc_element.CUSTOMER_ADDRESS = customer_Address_Element;
            
            //EOI_IIB_ERPOrderCallout_V7.ZSSD_ORDER_HEADER[] order_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ORDER_HEADER_element>();
            EOI_IIB_ERPOrderCallout_V7.ORDER_HEADERType order_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_HEADERType();
            order_Element.DOC_TYPE =  (orderDetailsObj.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription && orderDetailsObj.ASA__c)?'ZASC':((orderDetailsObj.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books && orderDetailsObj.Renewal_Type__c==WK_Constants.EOI_Opt_In_Standing_Order)?'ZS00':'ZC01');
            order_Element.FLAG = (orderDetailsObj.Stub_Flag__c == true)?'01':((orderDetailsObj.MYA__c)?'02':'');
            order_Element.SALES_ORG = 'US10';
            order_Element.DISTR_CHANNEL = '10';
            order_Element.DIVISION = '10';
            order_Element.CONTACT_CHANNEL='0004';
            order_Element.SALES_CHANNEL = '102020';
            order_Element.STARTDATE = (orderDetailsObj.Stub_Flag__c)?orderDetailsObj.Stub_Year_Start_Date__c:((orderDetailsObj.ASA__c)?orderDetailsObj.Advance_Start_Date__c:orderDetailsObj.Contract_Start_Date__c);//string.valueOf(orderDetailsObj.Contract_Start_Date__c);
            order_Element.ENDDATE = (orderDetailsObj.MYA__c)?orderDetailsObj.MYA_Term_End_Date__c:orderDetailsObj.Contract_End_Date__c;//orderDetailsObj.Contract_End_Date__c;//string.valueOf(orderDetailsObj.Contract_End_Date__c);
            //order_Element.ORDER_REASON = ;
            order_Element.YOUR_REFERENCE = orderDetailsObj.Name;
            order_Element.PAYMENT_TERM = orderDetailsObj.Payment_Term__c;
            order_Element.SHIP_COND = (orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_First_Class)?'01'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Ground_parcel)?'06'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_International_Air)?'07'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Next_Day_AM_Delivery)?'09'
                                        :(orderDetailsObj.Shipping_Method__c == WK_Constants.EOI_ShippigMethod_Next_Day_PM_Delivery)?'10'
                                        :'';
            order_Element.AUTH_TYPE = (orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard)?'01'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_IP)?'03'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Refer)?'05'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard_IP)?'06'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Refer_IP)?'08'
                                        :(orderDetailsObj.Authentication_Type__c == WK_Constants.EOI_Authentication_type_Standard_Refer)?'07'
                                        :'';
            //order_Element.USER_TYPE;
            order_Element.IDISSUED = string.valueOf(orderDetailsObj.IDs_to_be_issued__c);
            order_Element.MAXUSER = string.valueOf(orderDetailsObj.Max_IDs_allowed__c);
            order_Element.CONCURRENCY = string.valueOf(orderDetailsObj.Number_of_Concurrent_Users__c);
            //order_ELement_List.add(order_Element);
            sfdc_acc_element.ORDER_HEADER = order_Element;
            
            
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTArrayType order_Element_Text = new EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTArrayType();
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType[] order_Text_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType>();
            EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType order_Text_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_TEXTType();
            order_Text_Element.TEXT_ID = 'Z002';
            //order_Text_Element.TEXT_OBJECT = '';
            order_Text_Element.HEADER_TEXT = orderDetailsObj.One_Line_Invoice_Header__c;
            order_Text_ELement_List.add(order_Text_Element);
            order_Element_Text.ORDER_TEXTs = order_Text_ELement_List;
            sfdc_acc_element.ORDER_TEXT = order_Element_Text;
            
            EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMArrayType order_Item_Ele =new EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMArrayType();
            EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType[] order_Item_ELement_List =new List<EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType>();
            
            EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType contract_Period_Price = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType();
            EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType[] contract_Period_PriceTypeList = new List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType>();
            //EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType contract_Period_Price; 
            system.debug('Iterate Line Items ');
            for(ERP_Order_Line_Item__c newOrderLineItem : orderLineItemList)
            {
                system.debug('Order Item '+newOrderLineItem.Product_Code__c);
                EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType order_Item_Element = new EOI_IIB_ERPOrderCallout_V7.ORDER_ITEMType();
                order_Item_Element.ITEM_NUMBER = (newOrderLineItem.Line_Number__c != null )?String.valueOf(newOrderLineItem.Line_Number__c * 10):'0';
                order_Item_Element.BUNDLE = newOrderLineItem.Parent_Product__r.ProductCode;
                order_Item_Element.MATERIAL= newOrderLineItem.Product_Code__c;
                order_Item_Element.QUANTITY = Integer.valueOf(newOrderLineItem.Quantity__c);
                order_Item_Element.STANDING_ORDER = (orderDetailsObj.Renewal_Type__c=='Opt-In (Standing Order)'?'Y':'N');
                order_Item_Element.DELIV_PRIORITY = (orderDetailsObj.Rush_Order__c)?'01':'02';
                order_Item_Element.RENEWALTYPE = (orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_In_OBR)?'02'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order)?'00'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Opt_Out_CBR)?'01'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Exempt_Manual_Renewal)?'03'
                                                    :(orderDetailsObj.Renewal_Type__c == WK_Constants.EOI_Not_Applicable_TC)?'04'
                                                    :'';
                order_Item_Element.PROMOCODE = newOrderLineItem.Promo_Code__c;
                //order_Item_Element.BILLINGPLAN_TYPE = ;
                order_Item_Element.FV_DATE = (orderDetailsObj.ASA__c)?orderDetailsObj.Contract_Start_Date__c:null;//String.valueof(orderDetailsObj.Contract_Start_Date__c);
                order_Item_ELement_List.add(order_Item_Element);
                
                
                //Contract Value
                List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType> testList  = getContractPeriodPrice(orderDetailsObj, newOrderLineItem);
                system.debug('TestList '+testList);
                contract_Period_PriceTypeList.addAll(testList);
                
            }
            system.debug('Final COntract value List :: '+contract_Period_PriceTypeList);
            order_Item_Ele.ORDER_ITEMs = order_Item_ELement_List;
            sfdc_acc_element.ORDER_ITEM = order_Item_Ele;
            
            contract_Period_Price.CONTRACT_PERIODS_PRICEs = contract_Period_PriceTypeList;
            sfdc_acc_element.CONTRACT_PERIODS_PRICE = contract_Period_Price;
            
            if(!String.isBlank(orderDetailsObj.Split_Commission__c) && orderDetailsObj.Split_Commission__c != '100% selling rep/0% inventory rep')
            {
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESArrayType split_Sales_ELe = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESArrayType();
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType[] split_Sales_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType>();
                EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType split_Sales_Element = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType();
                split_Sales_Element.ITEM_NUMBER = '000000';
                system.debug('Selling_DTN'+orderDetailsObj.Selling_DTN__c);
                split_Sales_Element.SALES_DTN = orderDetailsObj.Selling_DTN__c;
                split_Sales_Element.SALES_PERC = (orderDetailsObj.Split_Commission__c=='100% selling rep/0% inventory rep')?100
                                                :(orderDetailsObj.Split_Commission__c=='80% selling rep/20% inventory rep')?80
                                                :(orderDetailsObj.Split_Commission__c=='50% selling rep/50% inventory rep')?50
                                                :(orderDetailsObj.Split_Commission__c=='20% selling rep/80% inventory rep')?20
                                                :0;
                //orderDetailsObj.Inventory_DTN__c
                split_Sales_ELement_List.add(split_Sales_Element);
                split_Sales_Element = new EOI_IIB_ERPOrderCallout_V7.SPLIT_SALESType();
                split_Sales_Element.ITEM_NUMBER = '000000';
                split_Sales_Element.SALES_DTN = orderDetailsObj.Inventory_DTN__c;
                split_Sales_Element.SALES_PERC = (orderDetailsObj.Split_Commission__c=='100% selling rep/0% inventory rep')?0
                                                :(orderDetailsObj.Split_Commission__c=='80% selling rep/20% inventory rep')?20
                                                :(orderDetailsObj.Split_Commission__c=='50% selling rep/50% inventory rep')?50
                                                :(orderDetailsObj.Split_Commission__c=='20% selling rep/80% inventory rep')?80
                                                :0;
                                                
                split_Sales_ELement_List.add(split_Sales_Element);
                split_Sales_ELe.SPLIT_SALESs = split_Sales_ELement_List;
                sfdc_acc_element.SPLIT_SALES = split_Sales_ELe;
            }
            
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDArrayType credit_Card_Ele = new EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDArrayType(); 
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType[] credit_Card_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType>();
            EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType credit_Card_element = new EOI_IIB_ERPOrderCallout_V7.CREDIT_CARDType();
            credit_Card_element.CC_TYPE = (orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_American_Express)?'AMEX'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Discover)?'DISC'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Master_Card)?'MC'
                                            :(orderDetailsObj.Credit_Card_Type__c == WK_Constants.EOI_CCType_Visa)?'VISA'
                                            :'';
            credit_Card_element.CC_NUMBER = orderDetailsObj.Credit_Card_Cyber_Source_Token__c;
            credit_Card_element.CC_VALID_T = orderDetailsObj.Credit_Card_Expiration__c;//string.valueOf(orderDetailsObj.Credit_Card_Expiration__c);
            credit_Card_element.CC_NAME = orderDetailsObj.Name_on_Card__c;
            credit_Card_ELement_List.add(credit_Card_element);
            credit_Card_Ele.CREDIT_CARDs = credit_Card_ELement_List;
            sfdc_acc_element.CREDIT_CARD = credit_Card_Ele;
            
            
            /*
            EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element[] item_Price_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element>();
            EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element item_Price_element = new EOI_IIB_ERPOrderCallout_V7.ITEM_PRICE_element();
            item_Price_element.COND_TYPE = 'ZD03';
            //item_Price_element.COND_PERCEN = '10';//need to discuss
            //item_Price_element.COND_VALUE
            item_Price_ELement_List.add(item_Price_element);
            sfdc_acc_element.ITEM_PRICE = item_Price_ELement_List;
            
            /*EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element[] partner_Details_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element>();
            EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element partner_Detail_element = new EOI_IIB_ERPOrderCallout_V7.PARTNER_DETAILS_element();
            //partner_Detail_element.ITEM_NUMBER;
            partner_Detail_element.PARTNER_TYPE = 'RE';
            partner_Detail_element.PARTNERNUMBER =  orderDetailsObj.Bill_To_Partner_Number__c;
            partner_Details_ELement_List.add(partner_Detail_element);
            sfdc_acc_element.PARTNER_DETAILS = partner_Details_ELement_List;
            * /
            EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element[] message_Id_ELement_List = new List<EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element>();
            EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element message_Id_Element = new EOI_IIB_ERPOrderCallout_V7.MESSAGE_ID_element();
            //message_Id_Element.SFDC_ID ;
            //message_Id_Element.IIB_ID;
            //message_Id_Element.SAPPI_ID
            message_Id_ELement_List.add(message_Id_Element);
            sfdc_acc_element.MESSAGE_ID = message_Id_ELement_List;
            
            EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element []stub_Details_List = new List<EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element>();
            EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element stub_Details = new EOI_IIB_ERPOrderCallout_V7.STUB_DETAILS_element();
            stub_Details.DOC_TYPE = '';
            stub_Details.VALID_FROM = '';
            stub_Details.VALID_TO = '';
            stub_Details.ITEM_NO = '';
            stub_Details.COND_TYPE = '';
            stub_Details.COND_PERCEN = '';
            stub_Details.COND_VALUE = '';
            stub_Details.PROMOCODE = '';
            stub_Details_List.add(stub_Details);
            sfdc_acc_element.STUB_DETAILS = stub_Details_List;
           
            
            */
            
            EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataRequestType newUUIDMetaDataRequestType = new EOI_IIB_ERPOrderCallout_V7.UUIDMetaDataRequestType();
            newUUIDMetaDataRequestType.uuid = WK_Utility.UUID_Generator();
            newUUIDMetaDataRequestType.targetSystemName = 'IIB';
            newUUIDMetaDataRequestType.sourceSystemName = WK_Utility.ServiceIntegrations().SourceSystemName__c;
            newUUIDMetaDataRequestType.requestDateTime = Date.Today();
            //Need to verify with Jack
            newUUIDMetaDataRequestType.providingSystemName = WK_Utility.ServiceIntegrations().SourceSystemName__c;
            newUUIDMetaDataRequestType.uniqueCallingUserId = UserInfo.getName()+'_'+UserInfo.getUserId();
            newUUIDMetaDataRequestType.transactionMonitoringFlag = WK_Utility.ServiceIntegrations().TransactionMonitoringFlag__c;
            newUUIDMetaDataRequestType.loggingFlag = WK_Utility.ServiceIntegrations().LoggingFlag__c;
            newUUIDMetaDataRequestType.serviceVersion = WK_Utility.ServiceIntegrations().ServiceVersion__c;
            //newUUIDMetaDataRequestType.svcUsername;
            //newUUIDMetaDataRequestType.svcPassword;
            //newUUIDMetaDataRequestType.callingSystemBatchId;
            sfdc_acc_element.uuidMetaDataRequest = newUUIDMetaDataRequestType;
            
            return sfdc_acc_element;
        }
        
        private static List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType> getContractPeriodPrice(ERP_Order__c newERPOrder, ERP_Order_Line_Item__c newERPOrderLineItem)
        {
                EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType[] contract_Period_PriceTypeList = new List<EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType>();
                EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType contract_Period_PriceType;// = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEArrayType();
                
                system.debug('!newERPOrder.ASA__c'+!newERPOrder.ASA__c);
                system.debug('!newERPOrder.Stub_Flag__c'+!newERPOrder.Stub_Flag__c);
                system.debug('!newERPOrder.MYA__c'+!newERPOrder.MYA__c);
                system.debug('newERPOrder.Quote_Record_Type__c'+newERPOrder.Quote_Record_Type__c);
                system.debug('WK_Constants.EOI_QuoteRecordType_SAP_Subscription'+WK_Constants.EOI_QuoteRecordType_SAP_Subscription);
                if(!newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c)
                {
                    if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                    {
                        system.debug('Inside ASA=MYA__c=Stub_Flag__c=FLASE=>SAP_Subscription');
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPYM';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.ValueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                    }
                    else if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books && !(newERPOrder.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order))
                    {
                        system.debug('Inside ASA=MYA__c=Stub_Flag__c=FLASE=>SAP_Books');
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZP03';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.ValueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        /*
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZC01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZP05';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        */
                    }
                }
                
                if(!newERPOrder.ASA__c && newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                
                if(newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && !newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    system.debug('*******  Entered ASA Contract Period Price ******!newERPOrder.ASA__c'+!newERPOrder.ASA__c);
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZASC';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Advance_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                
                if(!newERPOrder.ASA__c && !newERPOrder.Stub_Flag__c && newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //************
                    if(newERPOrder.MYA_Term__c >= 2)
                    {   
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    //************
                    if(newERPOrder.MYA_Term__c >= 3)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 4)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 5)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    //*****************
                }
                if(!newERPOrder.ASA__c && newERPOrder.Stub_Flag__c && newERPOrder.MYA__c && newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Subscription)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZC01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Stub_Year_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Stub_Year_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //*************
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPYM';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZR01';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZPY3';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                    //************
                    if(newERPOrder.MYA_Term__c >= 2)
                    {   
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_2_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_2_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_2_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    //************
                    if(newERPOrder.MYA_Term__c >= 3)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_3_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_3_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_3_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 4)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_4_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_4_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_4_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    
                    //************
                    if(newERPOrder.MYA_Term__c >= 5)
                    {
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZD09';
                        contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                        contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                        contract_Period_PriceType.DOC_TYPE = 'ZR01';
                        contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                        contract_Period_PriceType.VALID_FROM = newERPOrder.MYA_Year_5_Start_Date__c;
                        contract_Period_PriceType.VALID_TO = newERPOrder.MYA_Year_5_End_Date__c;
                        contract_Period_PriceType.COND_TYPE = 'ZPY3';
                        contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Year_5_Net_Price__c;
                        contract_Period_PriceTypeList.add(contract_Period_PriceType);
                        
                    }
                    //*****************
                }
                
                if(newERPOrder.Quote_Record_Type__c == WK_Constants.EOI_QuoteRecordType_SAP_Books && newERPOrder.Renewal_Type__c == WK_Constants.EOI_Opt_In_Standing_Order)
                {
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZP03';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.List_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = String.valueOf(newERPOrderLineItem.Line_Number__c*10);
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZD09';
                    contract_Period_PriceType.COND_PERCEN=Integer.valueOf(newERPOrderLineItem.Net_Adjustment__c);
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    /*
                    contract_Period_PriceType = new EOI_IIB_ERPOrderCallout_V7.CONTRACT_PERIODS_PRICEType();
                    contract_Period_PriceType.DOC_TYPE = 'ZS00';
                    contract_Period_PriceType.ITEM_NUMBER = (newERPOrderLineItem.Line_Number__c != null)?String.valueOf(newERPOrderLineItem.Line_Number__c*10):'0';
                    contract_Period_PriceType.VALID_FROM = newERPOrder.Contract_Start_Date__c;
                    contract_Period_PriceType.VALID_TO = newERPOrder.Contract_End_Date__c;
                    contract_Period_PriceType.COND_TYPE = 'ZP05';
                    contract_Period_PriceType.COND_VALUE=newERPOrderLineItem.Net_Price__c;
                    contract_Period_PriceTypeList.add(contract_Period_PriceType);
                    */
                }
                return contract_Period_PriceTypeList;
                //contract_Period_Price.CONTRACT_PERIODS_PRICEs = contract_Period_PriceTypeList;
                //sfdc_acc_element.CONTRACT_PERIODS_PRICE = contract_Period_Price;
        }           
}