trigger PfxTaxUpdateOppProposal on Account (after update) {
    for (Account A:trigger.new){
           Account oldAccount = Trigger.oldMap.get(A.Id);
             

        if(oldAccount.Pfx_Tax_Update_Counter__C !=  A.Pfx_Tax_Update_Counter__c){
        
        TaxUpdateYear__C TUY = TaxUpdateYear__c.getInstance('UpdateYear');
    String Year = TUY.year__c;
    
          Opportunity O = new Opportunity(
          accountId = A.Id,
          name = a.name +' - '+Year+' Tax Update Order',
          amount = 150.00,
          StageName = '5. Time to Buy',
          ForecastCategoryName = 'High Probability',
          Forecast_Type__c = 'High (>90%)',
          Primary_contact_for_proposal__c = a.tax_update_contact__c,
          primary_contact_email__c = a.tax_update_contact_email__c,
          primary_contact_phone__C = a.tax_Update_Contact_phone__c,
          product_category__c = 'Small Firm Software',
          product_sub_category__c = 'Tax',
          type = 'New to Existing',
          RecordTypeId = '01231000001NWytAAG',
          closedate = system.Today(),
          OwnerId = UserInfo.getUserId()); 
          insert O;
            
            apttus_proposal__proposal__c P = new apttus_proposal__proposal__c(
            apttus_proposal__account__c = A.Id,
            apttus_proposal__proposal_name__c = O.name,
            apttus_proposal__approval_stage__c = 'Approved',
            apttus_proposal__opportunity__c = O.Id,
            Quote_Total__c = 150.00,
            RecordTypeId = '012i0000001EOtSAAW',
            apttus_QPConfig__PriceListId__c = 'a1fi0000000y6L4AAI',
            OwnerId = UserInfo.getUserId(),
                        annual_start_date__c = system.Today()
          ,erp_account__c = A.Tax_Update_Account_number__c );            
            insert P;
            
            apttus_Config2__ProductConfiguration__c C = new apttus_Config2__ProductConfiguration__c (
            name = p.name,
            ownerId = UserInfo.getUserId(),
            Apttus_Config2__BusinessObjectId__c = P.Id,
            Apttus_Config2__BusinessObjectType__c = 'Proposal',
            Apttus_Config2__EffectivePriceListId__c = 'a1fi0000000y6L4AAI',
            Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4AAI',
            Apttus_QPConfig__Proposald__c = P.Id,
            Apttus_Config2__Status__C = 'Finalized',
            Apttus_Config2__VersionNumber__c = 1,
            Proposal_ID__c = P.Id);
            Insert C;
            
            Apttus_Config2__LineItem__c CLI = new Apttus_Config2__LineItem__c(
                Apttus_Config2__ConfigurationId__c = C.Id,
                Apttus_Config2__ChargeType__c = 'One Time Fee',
                Apttus_Config2__BasePrice__c = 150.00,
                Apttus_Config2__BaseExtendedPrice__c = 150.00,
                Apttus_Config2__ExtendedPrice__c = 150.00,
                Apttus_Config2__IsPrimaryLine__c = true,
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1,
                Apttus_Config2__ListPrice__c = 150.00,
                Apttus_Config2__LineStatus__c = 'New',
                Apttus_Config2__NetPrice__c = 150.00,
                Apttus_Config2__PriceListId__c = 'a1fi0000000y6L4AAI',
                Apttus_Config2__PriceListItemId__c = 'a1e3100000490cJ',
                Apttus_Config2__PriceType__c = 'One Time',
                Apttus_Config2__ProductId__c = '01t31000007coZX',
                Apttus_Config2__Quantity__c = 1,
                Apttus_Config2__SellingFrequency__c = 'Yearly',
                Apttus_Config2__SyncStatus__c = 'Synchronized',
                Apttus_Config2__PricingStatus__c = 'Complete',
                Apttus_Config2__PrimaryLineNumber__c = 1);
                Insert CLI; 
             
              apttus_proposal__proposal_line_item__c PLI = new apttus_proposal__proposal_line_item__c(
              apttus_proposal__proposal__c = p.Id,
                apttus_proposal__product__c = '01t31000007coZX',
                apttus_qpconfig__quantity2__c = 1,
                apttus_qpconfig__linenumber__c = 1,
                apttus_qpconfig__itemsequence__c = 1,
                apttus_qpconfig__listprice__c = 150.00000,
                apttus_qpconfig__netprice__c = 150.00,
                apttus_qpconfig__linestatus__c = 'New',
                apttus_qpconfig__lineType__c = 'Product/Service',
                apttus_proposal__description__c = 'CCH PFX TAX UPDATE SEMINAR - MTS',
                apttus_qpconfig__PriceListItemId__c = 'a1e3100000490cJ');
                insert PLI;
                
                Template_Line_item__C TLI = new Template_Line_Item__C(
                OwnerId = UserInfo.getUserId(),
                name = 'QLI-Record',
                ams_product_Category__c = 'Tax Professional & Client Services',
                Product__c = '01t31000007coZX',
                Quote_Proposal__C = p.Id,
                display_ams_product_category__c = 'Tax Professional & Client Services',
                proposal_line_item__C = PLI.Id);
                
                insert TLI;
                
                P.quote_total__c = 150.00;
                Update P;
                
               opportunitylineitem OLI = new opportunitylineitem(
                opportunityId = O.Id,
                product2Id = '01t31000007coZX',
                Quantity = 1,
                TotalPrice = 150.00,
                Item_Number__C = '1',
                BasePrice__c = 150.00,
                PriceBookEntryId = '01u310000135QyhAAE',
               SFS_Opportunity_record_ID__C = 'A1' );
            
                
                insert OLI;
                                
                
                
                
   }
}
}