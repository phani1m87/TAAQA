/*
 * Trigger handler for Quote / Proposal Trigger to create ERP Order and Line Items
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 06/14/2017 SHIVAJI           1.5          AOP1.5 Changes
 * 10/23/2017 SHIVAJI           2.0          AOP2.0 Changes SMS-900
 * ------------------------------------------------------------------------- */

public without sharing Class EOI_QuoteProposalTriggerHandler 
{
	List<ERP_Order__c> ERPOrderList = new List<ERP_Order__c>();
	List<ERP_Order_Line_Item__c> ERPOrderLineItemList = new List<ERP_Order_Line_Item__c>();
	List<Apttus_Proposal__Proposal_Line_Item__c> quoteProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
	List<Id> orderIds = new List<Id>();
	public static  boolean firstRun = true;
	public boolean isOrderupdate = false;
   
	public void onAfterUpdate(List<Apttus_Proposal__Proposal__c > QuoteProposalList) 
   	{
		Schema.DescribeSObjectResult d = Schema.SObjectType.Apttus_Proposal__Proposal__c;
	    Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
	    List<Apttus_Proposal__Proposal__c> proposalUpdateList = new List<Apttus_Proposal__Proposal__c>();
    
    	try{   
        	List<Apttus_Proposal__Proposal__c> proposalList = [SELECT Id, Name, ERP_Order__c,SAP_Rush_Order__c, ERP_Order__r.Order_Submission_Status__c, 
        														Access_Type__c, Advance_Period_Start_Date__c, New_Authentication_Type__c, Bill_To_Contact_Name__c, Bill_To_City__c, 
        														Bill_To_Country__c, SAP_Bill_To_Partner_Number__c, Bill_To_Phone__c, Bill_To_Zip_Postal_Code__c, 
        														Bill_To_State__c,Bill_To_Street_Line_1__c, Bill_To_Street_Line_2__c, Annual_End_Date__c, 
        														Annual_Start_Date__c, Aptps_Cyber_source_Token__c, Credit_Card_Expiration__c, Credit_Card_Type__c, 
        														IC_Contact_Email__c,IC_Contact_First_Name__c, IC_Contact_Last_Name__c, IC_Contact_Phone__c, 
        														New_IDs_Issued__c, Inventory_DTN__c, New_Max_IDs_Allowed__c, Name_on_Card__c, Number_of_Concurrent_Users__c, 
        														One_Line_Invoice_Header__c, SAP_Payment_Terms__c, Apttus_Proposal__Primary_Contact__c, Auto_Renewal_SO_Compliance__c, 
        														X6_Digit_Selling_DTN__c, Apttus_Proposal__Account__c, SAP_Ship_To_Partner_Number__c, Ship_To_Contact_Name__c, Ship_To_Country__c, Ship_To_City__c,
        														Shipping_Method__c, Ship_To_Phone__c,Ship_To_Zip_Postal_Code__c, Ship_To_State__c, WK_Stub_Year__c, Split_Commission__c, 
        														Ship_To_Street_Line_2__c, Ship_To_Street_Line_1__c, WK_Stub_Year_Start_Date__c,ERP_Account__c, ERP_Account__r.Name, RecordTypeId, 
        														ASA__c, MYA_Year_2_End_Date__c, MYA_Term_New__c, MYA__c, Advance_Period_End_Date__c, SAP_IC_Trial_Account_Number__c, 
        														MYA_Year_2_Start_Date__c, MYA_Year_3_Start_Date__c, MYA_Year_4_Start_Date__c, MYA_Year_5_Start_Date__c,Quote_Total__c,
        														Apttus_Proposal__Opportunity__r.Primary_Contact_for_Proposal__c, Apttus_Proposal__Opportunity__c, Apttus_QPConfig__PriceListId__c, 
        														MYA_Year_5_End_Date__c, MYA_Year_4_End_Date__c,MYA_Year_3_End_Date__c, WK_Stub_Year_End_Date__c, Rush_Order__c,
        														Is_Create_New_Bill_To__c, Is_Create_New_Ship_To__c, Is_Update_Selected_Bill_To__c, Is_Update_Selected_Ship_To__c 
        														FROM Apttus_Proposal__Proposal__c 
        														WHERE Id IN: QuoteProposalList ];
       		for(Apttus_Proposal__Proposal__c  quoteProposal:proposalList)
       		{
        		system.debug('Inside QuoteProposalTrigger'+quoteProposal);
        		if(quoteProposal.ERP_Order__c == null || (quoteProposal.ERP_Order__c != null && quoteProposal.ERP_Order__r.Order_Submission_Status__c != 'Finalized / Complete in ERP'))
        		{
         			ERPOrderList.add(new ERP_Order__c(Access_Type__c=quoteProposal.Access_Type__c,Advance_Start_Date__c=quoteProposal.Advance_Period_Start_Date__c,
			         Authentication_Type__c=quoteProposal.New_Authentication_Type__c,Bill_To_City__c=quoteProposal.Bill_To_City__c,Bill_To_Country__c=quoteProposal.Bill_To_Country__c,
			         Bill_To_Partner_Number__c=quoteProposal.SAP_Bill_To_Partner_Number__c,Bill_To_Phone__c=quoteProposal.Bill_To_Phone__c,
			         Bill_To_Postal_Code__c=quoteProposal.Bill_To_Zip_Postal_Code__c,Bill_To_State__c=quoteProposal.Bill_To_State__c,
			         Bill_To_Street_1__c=quoteProposal.Bill_To_Street_Line_1__c,Bill_To_Street_2__c=quoteProposal.Bill_To_Street_Line_2__c,Contract_End_Date__c=quoteProposal.Annual_End_Date__c,
			         Contract_Start_Date__c=quoteProposal.Annual_Start_Date__c,Credit_Card_Cyber_Source_Token__c=quoteProposal.Aptps_Cyber_source_Token__c,
			         Credit_Card_Expiration__c=quoteProposal.Credit_Card_Expiration__c,Credit_Card_Type__c=quoteProposal.Credit_Card_Type__c,Customer_X_Ref__c=quoteProposal.ERP_Account__c,
			         IC_Admin_Email__c=quoteProposal.IC_Contact_Email__c,IC_Admin_First_Name__c=quoteProposal.IC_Contact_First_Name__c,IC_Admin_Last_Name__c=quoteProposal.IC_Contact_Last_Name__c,
			         IC_Admin_Phone__c=quoteProposal.IC_Contact_Phone__c,IDs_to_be_issued__c=quoteProposal.New_IDs_Issued__c,Inventory_DTN__c=quoteProposal.Inventory_DTN__c,
			         Max_IDs_allowed__c=quoteProposal.New_Max_IDs_Allowed__c,Name_on_Card__c=quoteProposal.Name_on_Card__c,Number_of_Concurrent_Users__c=quoteProposal.Number_of_Concurrent_Users__c,
			         One_Line_Invoice_Header__c=quoteProposal.One_Line_Invoice_Header__c,Payment_Term__c=quoteProposal.SAP_Payment_Terms__c,Primary_Contact__c=quoteProposal.Apttus_Proposal__Opportunity__r.Primary_Contact_for_Proposal__c,
			         Renewal_Type__c=quoteProposal.Auto_Renewal_SO_Compliance__c,Selling_DTN__c=quoteProposal.X6_Digit_Selling_DTN__c,SFDC_Account__c=quoteProposal.Apttus_Proposal__Account__c,
			         Shipping_Method__c=quoteProposal.Shipping_Method__c,Ship_To_City__c=quoteProposal.Ship_To_City__c,Ship_To_Country__c=quoteProposal.Ship_To_Country__c,Ship_To_Partner_Number__c=quoteProposal.SAP_Ship_To_Partner_Number__c,
			         Ship_To_Phone__c=quoteProposal.Ship_To_Phone__c,Ship_To_Postal_Code__c=quoteProposal.Ship_To_Zip_Postal_Code__c,Ship_To_State__c=quoteProposal.Ship_To_State__c,
			         Ship_To_Street_1__c=quoteProposal.Ship_To_Street_Line_1__c,Ship_To_Street_2__c=quoteProposal.Ship_To_Street_Line_2__c,Split_Commission__c=quoteProposal.Split_Commission__c,Stub_Flag__c=quoteProposal.WK_Stub_Year__c,
			         Stub_Year_Start_Date__c=quoteProposal.WK_Stub_Year_Start_Date__c,Sold_To_Partner_Number__c=((quoteProposal.ERP_Account__c != null)?quoteProposal.ERP_Account__r.Name:''),Quote_Record_Type__c=rtMapById.get(quoteProposal.RecordTypeId).getName(), Proposal__c=quoteProposal.Id, ASA__c=quoteProposal.ASA__c,
			         IC_Trial_Account_Number__c=quoteProposal.SAP_IC_Trial_Account_Number__c, Advance_End_Date__c=quoteProposal.Advance_Period_End_Date__c, MYA__c=quoteProposal.MYA__c, MYA_Term__c = ((quoteProposal.MYA_Term_New__c != null)?Integer.valueOf(quoteProposal.MYA_Term_New__c):null), MYA_Year_2_End_Date__c=quoteProposal.MYA_Year_2_End_Date__c,
			         MYA_Year_2_Start_Date__c=quoteProposal.MYA_Year_2_Start_Date__c, MYA_Year_3_Start_Date__c=quoteProposal.MYA_Year_3_Start_Date__c,MYA_Year_4_Start_Date__c=quoteProposal.MYA_Year_4_Start_Date__c,MYA_Year_5_Start_Date__c=quoteProposal.MYA_Year_5_Start_Date__c,
			         MYA_Year_3_End_Date__c=quoteProposal.MYA_Year_3_End_Date__c,MYA_Year_4_End_Date__c=quoteProposal.MYA_Year_4_End_Date__c,MYA_Year_5_End_Date__c=quoteProposal.MYA_Year_5_End_Date__c, Price_List__c=quoteProposal.Apttus_QPConfig__PriceListId__c,Quote_Total__c=quoteProposal.Quote_Total__c,
			         Stub_Year_End_Date__c=quoteProposal.WK_Stub_Year_End_Date__c, Rush_Order__c=quoteProposal.SAP_Rush_Order__c, Bill_To_Contact_Name__c = quoteProposal.Bill_To_Contact_Name__c, Ship_To_Contact_Name__c = quoteProposal.Ship_To_Contact_Name__c, 
			         Is_Create_New_Bill_To__c = quoteProposal.Is_Create_New_Bill_To__c, Is_Create_New_Ship_To__c = quoteProposal.Is_Create_New_Ship_To__c, Is_Update_Selected_Bill_To__c = quoteProposal.Is_Update_Selected_Bill_To__c, Is_Update_Selected_Ship_To__c = quoteProposal.Is_Update_Selected_Ship_To__c));  
					orderIds.add(quoteProposal.id);
        		}else{
            		Trigger.New[0].addError('You can\'t update Quote/Proposal because associated Order has been already placed.');
        		}
			}
       
       		if(ERPOrderList.size() > 0)
       		{
        		system.debug('Inside trigger ERPOrderList.size()'+ERPOrderList.size());
				Database.SaveResult[] results = Database.insert(ERPOrderList,false);
           		for(Database.SaveResult sr : results){
            		if(sr.isSuccess()){
                   		isOrderupdate = true;
               		}else{
               			for(Database.Error err : sr.getErrors()) 
               			{
            				System.debug('The following error has occurred.');                    
            				Trigger.New[0].AddError(err.getStatusCode() + ': ' + err.getMessage());
            			}
	           		}
        		}
           		for(ERP_Order__c currentERPOrder : ERPOrderList)
        		{
                	proposalUpdateList.add(new Apttus_Proposal__Proposal__c(Id = currentERPOrder.Proposal__c, ERP_Order__c = currentERPOrder.Id));
            	}
            	update proposalUpdateList;
       		}
       
       		if(ERPOrderList.size() > 0 && isOrderupdate)
       		{
           		quoteProposalLineItems = [SELECT Product_Code__c, Net_Adjustment__c,Net_Price_WK__c,List_Price__c,Formatted_Promo_Code__c,Apttus_QPConfig__Quantity2__c,Apttus_QPConfig__ItemSequence__c,Year_2_Price__c,Year_3_Price__c,Year_4_Price__c,
								           Apttus_QPConfig__LineType__c, Year_5_Price__c,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__ProductOptionId__c,Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c,
								           Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Proposal_Line_Item__c.Apttus_Proposal__Proposal__c 
										  FROM Apttus_Proposal__Proposal_Line_Item__c 
           								  WHERE Apttus_Proposal__Proposal__c IN: orderIds];
           
           		Map<String, String> mapProductCodeNPromoCode = new Map<String, String>(); 
           		for(Apttus_Proposal__Proposal_Line_Item__c quoteProposalLineItem : quoteProposalLineItems)
           		{
           			mapProductCodeNPromoCode.put(quoteProposalLineItem.Product_Code__c, quoteProposalLineItem.Formatted_Promo_Code__c);	
           		}
           		
           		if(quoteProposalLineItems.size() > 0)
           		{
           
              		for(Apttus_Proposal__Proposal_Line_Item__c quoteProposalLineItem : quoteProposalLineItems)
              		{
	                 	String product,parentProduct,productCode;
						if(quoteProposalLineItem.Apttus_QPConfig__ProductOptionId__c != null)
						{
                    		system.debug('Aptus triggerHandler 6**2');
                    		product = quoteProposalLineItem.Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__c; 
                    		parentProduct = quoteProposalLineItem.Apttus_Proposal__Product__c;
                    		productCode = quoteProposalLineItem.Apttus_QPConfig__ProductOptionId__r.Apttus_Config2__ComponentProductId__r.ProductCode;
                    
                 		}else{
                  			product = quoteProposalLineItem.Apttus_Proposal__Product__c;
                  			productCode = quoteProposalLineItem.Apttus_Proposal__Product__r.ProductCode;
                  
                 		}
                 		system.debug('Product__c**'+product);
                 		system.debug('productCode**'+productCode);
                 
                 		for(ERP_Order__c ERPOrder : ERPOrderList)
                 		{
                     		String promoCode = quoteProposalLineItem.Formatted_Promo_Code__c;
                     		if(quoteProposalLineItem.Apttus_QPConfig__LineType__c == 'Product/Service' && mapProductCodeNPromoCode != NULL && mapProductCodeNPromoCode.get(productCode) != NULL){
                     			promoCode = mapProductCodeNPromoCode.get(productCode);
                     		}
                     		
                     		ERPOrderLineItemList.add(new ERP_Order_Line_Item__c(ERP_Order__c=ERPOrder.Id,Net_Adjustment__c=quoteProposalLineItem.Net_Adjustment__c,
                     			Line_Type__c = quoteProposalLineItem.Apttus_QPConfig__LineType__c, Net_Price__c=quoteProposalLineItem.Net_Price_WK__c,Promo_Code__c=promoCode,Quantity__c=quoteProposalLineItem.Apttus_QPConfig__Quantity2__c,
                     			Item_Sequence__c=quoteProposalLineItem.Apttus_QPConfig__ItemSequence__c,Line_Number__c=quoteProposalLineItem.Apttus_QPConfig__LineNumber__c,
                     			Product__c=product,Parent_Product__c=parentProduct,Product_Code__c=productCode, List_Price__c=quoteProposalLineItem.List_Price__c, Year_2_Net_Price__c=quoteProposalLineItem.Year_2_Price__c,
                     			Year_3_Net_Price__c=quoteProposalLineItem.Year_3_Price__c,Year_4_Net_Price__c=quoteProposalLineItem.Year_4_Price__c,Year_5_Net_Price__c=quoteProposalLineItem.Year_5_Price__c));	
                 		}
              		}
           		}
			}
			
       		if(ERPOrderLineItemList.size()>0){
	            Database.SaveResult[] results = Database.insert(ERPOrderLineItemList,false);
	            //#TechnicalDebt
	            for(Database.SaveResult sr : results)
	            {
					if(!sr.isSuccess())
		            {
		            	for(Database.Error err : sr.getErrors()) 
		            	{
	            			System.debug('The following error has occurred.');                    
	            			Trigger.New[0].AddError(err.getStatusCode() + ': ' + err.getMessage());
	                	}
	               
	           		}
	            }
       		}
       
		}catch(Exception e){
			//#TechnicalDebt If we cant create ERP Order we need to log an error
			system.debug('Exception occured'+e.getMessage() + ' - lineMsg: '+ e.getLineNumber());
			Trigger.New[0].addError('Error: '+e.getMessage()+' occurs at Line: '+e.getLineNumber());
      	}
	} 
}