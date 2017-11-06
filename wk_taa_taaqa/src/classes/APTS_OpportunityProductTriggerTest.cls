@isTest
public with sharing class APTS_OpportunityProductTriggerTest {
	static testMethod void systemUtilTest()
	{
	 string str='test';
	 SystemUtil.nullOrEmpty(str);
	 SystemUtil.nullOrEmpty(new list<Object>());
	 SystemUtil.getDocuSignConfigXML();
	 
	
	}
	
	static testMethod void opportunityLineItemTriggerTest()
	{
		Account acc = new Account(Name = 'Apttus Test Account', Type = 'Employer');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Apttus Test Opty', 
                                          AccountId = acc.Id, StageName='Stage 2 - Qualify Target', 
                                          //Competitors__c = '**None**', 
                                          CloseDate = Date.today().addYears(1),
                                          pricebook2Id=Test.getStandardPricebookId());
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();        
        insert opp;
        
        Id Opppricebook2Id=Test.getStandardPricebookId();
        contact ct= new contact(firstname='test',LastName='test',email='test@domain.com', phone='1234567890');
        insert ct;
        //String returnMsg = OrderApprovalClass.Create_OrderApproval(opp.Id,opp.RecordTypeId+'',opp.StageName);

       // STEP I - Create a product
        Product2 productSO = createProduct('BundleProduct1',
                                           'TestApttus',
                                           'TEST Apttus',
                                           'TestApttus',
                                           'Bundle',
                                           'Each',
                                           true,
                                           Date.today(), 
                                           Date.today().addMonths(12),
                                           'Software');
         PricebookEntry entry1=new PricebookEntry(Pricebook2Id=Opppricebook2Id,
                                        product2Id=productSO.id,
                                        unitprice=1000,
                                        IsActive=true
                                        );
         insert entry1;                                    
       
         Product2 productSO3 = createProduct('OptionProduct1',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12),
                                            'Training & Consulting');
        Product2 productSO4 = createProduct('OptionProduct2',
                                            'TestApttus4',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Option',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12),
                                            'Training & Consulting');
        Product2 productSO5 = createProduct('StandAlone1',
                                            'TestAPttus5',
                                            'TestApttus2',
                                            'TestApttus2',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12),
                                            'Training & Consulting');
        PricebookEntry entry2=new PricebookEntry(Pricebook2Id=Opppricebook2Id,
                                        product2Id=productSO5.id,
                                        unitprice=1000,
                                        IsActive=true
                                        );
         insert entry2;                                     
        Product2 productSO6 = createProduct('standAlone2',
                                            'TestApttus6',
                                            'TestApttus3',
                                            'TestApttus3',
                                            'Standalone',
                                            'Each',
                                            true,
                                            Date.today(), 
                                            Date.today().addMonths(12),
                                            'Training & Consulting');
       PricebookEntry entry3=new PricebookEntry(Pricebook2Id=Opppricebook2Id,
                                        product2Id=productSO6.id,
                                        unitprice=1000,
                                        IsActive=true
                                        );
         insert entry3;                                       
       
//opportunity record=[select id,name,stagename from opportunity where id='006e0000007WLOm'];
//PricebookEntry entry =new PricebookEntry(Pricebook2Id=standardBook.id,product2Id='01te0000001eclI',unitprice=1000);
//insert entry;IsActive
/*list<PricebookEntry> pbe=new list<PricebookEntry>();
PricebookEntry entry=new PricebookEntry(Pricebook2Id=standardBook.id,
                                        product2Id=productSO.id,
                                        unitprice=1000,
                                        IsActive=true
                                        );
pbe.add(entry); 
insert pbe;                                      
list<OpportunityLineItem> opProductList=new list<OpportunityLineItem>();
OpportunityLineItem opli =new OpportunityLineItem(PricebookEntryId=pbe[0].Id, 
                                                  OpportunityId=opp.Id, 
                                                  UnitPrice=pbe[0].UnitPrice, 
                                                  Quantity=1,LineType__c='Product/Service');
opProductList.add(opli);
insert opProductList;   */  

OpportunityLineItem opli1=createOpportunityLineItem(opp.id,'Product/Service',entry1.id,null); 
OpportunityLineItem opli2=createOpportunityLineItem(opp.id,'Option',entry1.id,productSO3.id);
OpportunityLineItem opli3=createOpportunityLineItem(opp.id,'Option',entry1.id,productSO4.id);
OpportunityLineItem opli4=createOpportunityLineItem(opp.id,'Product/Service',entry2.id,null);
OpportunityLineItem opli5=createOpportunityLineItem(opp.id,'Product/Service',entry3.id,null);    
list<OpportunityLineItem> opliList1=new list<OpportunityLineItem>();
opliList1.add(opli1);
opliList1.add(opli2);
opliList1.add(opli3);
opliList1.add(opli4);
opliList1.add(opli5);
insert oplilist1;
                        
   list<OpportunityLineItem> opliList =[select id,OpportunityId,LineType__c,Product_Config_Type__c,APTPS_Product_Line__c 
      from OpportunityLineItem where OpportunityId=:opp.id ];
      
      system.debug('oplilist--->'+opliList);
                                          
	 
	}
	static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Id proposalId,Id ConfigId, Id productId, Id OptionId,Id pricelistId,string linetype)
    {
     Apttus_Proposal__Proposal_Line_Item__c propline= new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=proposalId,
                                                                                                 Apttus_QPConfig__ConfigurationId__c=ConfigId,
                                                                                                 Apttus_QPConfig__OptionId__c=OptionId, Apttus_Proposal__Product__c=productId,
                                                                                                 Apttus_QPConfig__ItemSequence__c=1,Apttus_QPConfig__LineNumber__c=2,
                                                                                                 Apttus_QPConfig__LineType__c=linetype,
                                                                                                 Apttus_QPConfig__PriceListId__c=pricelistId, 
                                                                                                 Apttus_QPConfig__ChargeType__c='Subscription Fee',
                                                                                                 Apttus_QPConfig__PriceType__c='Recurring', 
                                                                                                 Apttus_QPConfig__SellingTerm__c=1, 
                                                                                                 Apttus_QPConfig__BasePrice__c=100,
                                                                                                 Apttus_QPConfig__AdjustmentType__c='% Discount',   
                                                                                                 Apttus_QPConfig__AdjustmentAmount__c=10,
                                                                                                 Apttus_QPConfig__NetPrice__c    =100,
                                                                                                 Apttus_QPConfig__AdjustedPrice__c  =100,
                                                                                                 Apttus_QPConfig__BaseExtendedCost__c=100,
                                                                                                 Apttus_QPConfig__ExtendedPrice__c=100,                                                                    
                                                                                                 Apttus_QPConfig__NetAdjustmentPercent__c=10
                                                                                                    );
      insert propline;
      system.assertnotEquals(propline.id,null);
      return propline;
    }
	private static Product2 createProduct(String productName, 
                                   String productCode, 
                                   String productFamily, 
                                   String productDesc,
                                   String configType,
                                   String unitOfMeasure,
                                   Boolean customizable,
                                   Date effectiveDate,
                                   Date expirationDate,
                                   //string productType,
                                   string productline) {
        
        // create a new product
        Product2 product = new Product2(Name=productName);
        
        // setup product data
        
        // product code
        product.ProductCode = productCode;
        // product family
        product.Family = productFamily;
        // description
        product.Description = productDesc;
        // configuration type
        product.Apttus_Config2__ConfigurationType__c = configType;
        // unit of measure
        product.Apttus_Config2__Uom__c = unitOfMeasure;
        // customizable
        product.Apttus_Config2__Customizable__c = customizable;
        // effective date
        product.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        product.Apttus_Config2__ExpirationDate__c = expirationDate;
        if(configType=='Option')
        product.AMS_Product_Category__c='Tax Consulting';
        product.Product_Line__c=productline;
        
        //product.Product_Line__c=productline;
    
        // insert product
        insert product;
        
        System.assert(product.Id != null, 'Failed to create the product for owner ' + UserInfo.getUserId());
            
        return product;
        
    } 
    
    /**
     * Creates a price list for the given user
     * @param priceListName the price list name
     * @param priceListDesc the price list description
     * @param effectiveDate the price list effective date
     * @param expirationDate the price list expiration date
     * @return the price list
     */
    private static Apttus_Config2__PriceList__c createPriceList(String priceListName, 
                                                         String priceListDesc,
                                                         Date effectiveDate,
                                                         Date expirationDate) {
        
        // create a new pricelist
        Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c(Name = priceListName, OwnerId = UserInfo.getUserId());
        
        // setup price list data
        
        // description
        priceListSO.Apttus_Config2__Description__c = priceListDesc;
        // effective date
        priceListSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        priceListSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        // active
        priceListSO.Apttus_Config2__Active__c = true;
        
        // insert price list
        insert priceListSO;
        
        System.assert(priceListSO.Id != null, 'Failed to create the price list for owner ' + UserInfo.getUserId());
            
        return priceListSO;
        
    } 
    
    /**
     * Creates a price list item for the given user
     * @param priceListId the price list Id
     * @param productId the product Id
     * @param chargeType the charge type
     * @param priceType the price type
     * @param priceMethod the price method
     * @param listPrice the list price
     * @param minPrice the minimum price
     * @param maxPrice the maximum price
     * @param minMaxPriceAppliesTo the minmax price applies to
     * @param effectiveDate the entry effective date
     * @param expirationDate the entry expiration date
     * @return the price list item
     */
    private static Apttus_Config2__PriceListItem__c createPriceListItem(ID priceListId,
                                                                 ID productId, 
                                                                 String chargeType,
                                                                 String priceType,
                                                                 String priceMethod,
                                                                 Decimal listPrice,
                                                                 Decimal minPrice,
                                                                 Decimal maxPrice,
                                                                 String minMaxPriceAppliesTo,
                                                                 Date effectiveDate,
                                                                 Date expirationDate,
                                                                 boolean active) {
        
        // create a new pricelist item
        Apttus_Config2__PriceListItem__c itemSO = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceListId);
        
        // setup price list entry data
        
        // product id
        itemSO.Apttus_Config2__ProductId__c = productId;
        // charge type
        itemSO.Apttus_Config2__ChargeType__c = chargeType;
        // price type
        itemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        itemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // list price
        itemSO.Apttus_Config2__ListPrice__c = listPrice;
        // min price
        itemSO.Apttus_Config2__MinPrice__c = minPrice;
        // max price
        itemSO.Apttus_Config2__MaxPrice__c = maxPrice;
        // max price
        itemSO.Apttus_Config2__MinMaxPriceAppliesTo__c = minMaxPriceAppliesTo;
        // effective date
        itemSO.Apttus_Config2__EffectiveDate__c = effectiveDate;
        // expiration date
        itemSO.Apttus_Config2__ExpirationDate__c = expirationDate;
        
        // insert price list item
        insert itemSO;
        
        System.assert(itemSO.Id != null, 'Failed to create the price list item for owner ' + UserInfo.getUserId());
            
        return itemSO;
        
    } 
    
    /**
     * Creates a quote/proposal for the given user
     * @param qpName the quote/proposal name
     * @param opptyId the related opportunity id
     * @param approvalDate the quote/proposal approval date
     * @param expirationDate the quote/proposal expiration date
     * @param priceListId the price list id
     * @param pricingDate the pricing date
     * @param maintDuration the maintenance duration
     * @return the quote/proposal
     */
    private static Apttus_Proposal__Proposal__c createQuoteOrProposal(String qpName,
                                                               ID opptyId,
                                                               Date approvalDate, 
                                                               Date expirationDate, 
                                                               ID priceListId,
                                                               Date pricingDate,
                                                               String maintDuration,
                                                               boolean stubyearquote) {
        
        // create a new quote/proposal
        Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c(OwnerId = UserInfo.getUserId());
        // setup proposal data
        
        // proposal name
        proposalSO.Apttus_Proposal__Proposal_Name__c = qpName;
        // opportunity
        proposalSO.Apttus_Proposal__Opportunity__c = opptyId;
        // approval date
        proposalSO.Apttus_Proposal__Proposal_Approval_Date__c = approvalDate;
        // expiration date
        proposalSO.Apttus_Proposal__Proposal_Expiration_Date__c = expirationDate;
        // expected start date
        proposalSO.Apttus_Proposal__ExpectedStartDate__c = Date.today();
        // expected end date
        proposalSO.Apttus_Proposal__ExpectedEndDate__c = Date.today().addMonths(12);
        // price list id
        proposalSO.Apttus_QPConfig__PriceListId__c = priceListId;
        // pricing date
        proposalSO.Apttus_QPConfig__PricingDate__c = pricingDate;
        
        proposalSO.MYA__c =true;
        
        proposalSO.APTS_Enforce_Repricing__c=false;
        
        proposalSO.MYA_Term__c='3';
        proposalSO.Stubs_Year_Quote__c=stubyearquote;
        if(stubyearquote){
         proposalSO.Stub_Start_Date__c=date.today().addYears(-1); 
         proposalSO.Stub_End_Date__c=date.today().addYears(1);
        }
            
        // insert quote/proposal
        insert proposalSO;
        
        System.assert(proposalSO.Id != null, 'Failed to create the quote/proposal for owner ' + UserInfo.getUserId());
            
        return proposalSO;
        
    } 
    
    /**
     * Creates a product configuration for the given user
     * @param configName the configuration name
     * @param versionNbr the version number
     * @param bObjectId the business object id
     * @param bObjectType the business object type
     * @param groupType the summary group type
     * @param priceListId the price list Id
     * @param ancestorId the ancestor id
     * @param status the configuration status
     * @param finalizedDate the finalized date
     * @param effectiveDate the effective date
     * @param isTransient the transient configuration indicator
     * @param configDesc the configuration description
     * @return the product configuration group
     */
    private static Apttus_Config2__ProductConfiguration__c createProductConfiguration(String configName,
                                                                               Integer versionNbr,
                                                                               ID bObjectId,
                                                                               String bObjectType,
                                                                               String groupType,
                                                                               ID priceListId, 
                                                                               ID ancestorId, 
                                                                               String status, 
                                                                               Datetime finalizedDate, 
                                                                               Datetime effectiveDate, 
                                                                               Boolean isTransient,
                                                                               String configDesc) {
        
        // create a new classification name
        Apttus_Config2__ProductConfiguration__c configSO = new Apttus_Config2__ProductConfiguration__c(Name = configName, OwnerId = UserInfo.getUserId());
        
        // setup product configuration data
        
        // version number
        configSO.Apttus_Config2__VersionNumber__c = versionNbr;
        // summary group type
        configSO.Apttus_Config2__SummaryGroupType__c = groupType;
        // business object 
        configSO.Apttus_Config2__BusinessObjectId__c = bObjectId;
        // business object type
        configSO.Apttus_Config2__BusinessObjectType__c = bObjectType;
        // proposal id
        configSO.Apttus_QPConfig__Proposald__c = bObjectId;
        // price list id
        configSO.Apttus_Config2__PriceListId__c = priceListId;
        // ancestor id
        configSO.Apttus_Config2__AncestorId__c = ancestorId;
        // status 
        configSO.Apttus_Config2__Status__c = status;
        // is transient
        configSO.Apttus_Config2__IsTransient__c = isTransient;
        // finalized date
        configSO.Apttus_Config2__FinalizedDate__c = finalizedDate;
        // effective date
        configSO.Apttus_Config2__EffectiveDate__c = effectiveDate; 
        // description
        configSO.Apttus_Config2__Description__c = configDesc;
        
        // insert product configuration
        insert configSO;
        
        System.assert(configSO.Id != null, 'Failed to create the product configuration for owner ' + UserInfo.getUserId());
            
        return configSO;
        
    } 
    
    /**
     * Creates an ad hoc group for the given user
     * @param groupName the group name
     * @param configId the product configuration Id
     * @param groupDesc the group description
     * @return the ad hoc group
     */
    private static Apttus_Config2__AdHocGroup__c createAdHocGroup(String groupName,
                                                           ID configId,
                                                           String groupDesc) {
        
        // create a new ad hoc group
        Apttus_Config2__AdHocGroup__c groupSO = new Apttus_Config2__AdHocGroup__c(Name = groupName, Apttus_Config2__ConfigurationId__c = configId);
    
        // setup ad hoc group data
        
        // description
        groupSO.Apttus_Config2__Description__c = groupDesc;
        
        // insert ad hoc group 
        insert groupSO;
        
        System.assert(groupSO.Id != null, 'Failed to create the ad hoc group for owner ' + UserInfo.getUserId());
            
        return groupSO;
        
    } 
    
    /**
     * Creates a line item for the given user
     * @param configId the product configuration Id
     * @param groupId the summary group id
     * @param lineNumber the line number
     * @param isPrimaryLine the primary line indicator
     * @param itemSeq the item sequence
     * @param lineType the line type
     * @param productId the product Id
     * @param customizable the product customizable indicator
     * @param productOptionId the product option Id
     * @param optionId the option Id
     * @param classId the leaf classification id
     * @param classHierarchy the classification hierarchy
     * @param quantity the line quantity
     * @param isQtyModifiable the quantity modifiable indicator
     * @param uom the unit of measure
     * @param term the term
     * @param priceListId the price list Id
     * @param plItemId the price list item id
     * @param priceType the price type
     * @param priceMethod the price method
     * @param chargeType the charge type
     * @param frequency the frequency
     * @param allowManualAdj the manual adjustment indicator
     * @param allocateGroupAdj the allocate group adjustment indicator
     * @param listPrice the list price
     * @param basePrice the base price
     * @param basePriceMethod the base price method
     * @param baseExtPrice the base extended price
     * @param optionPrice the option price
     * @param extPrice the extended price
     * @param lineDesc the line item description
     * @return the line item
     */
    private static Apttus_Config2__LineItem__c createLineItem(ID configId,
                                                       ID groupId,
                                                       Integer lineNumber,
                                                       Boolean isPrimaryLine,
                                                       Integer itemSeq,
                                                       String lineType,
                                                       ID productId,
                                                       Boolean customizable,
                                                       ID productOptionId,
                                                       ID optionId,
                                                       ID classId,
                                                       String classHierarchy,
                                                       Decimal quantity,
                                                       Boolean isQtyModifiable,
                                                       String uom,
                                                       Integer term,
                                                       ID priceListId,
                                                       ID plItemId,
                                                       String priceType,
                                                       String priceMethod,
                                                       String chargeType,
                                                       String frequency,
                                                       Boolean allowManualAdj,
                                                       Boolean allocateGroupAdj,
                                                       Decimal listPrice,
                                                       Decimal basePrice,
                                                       String basePriceMethod,
                                                       Decimal baseExtPrice,
                                                       Decimal optionPrice,
                                                       Decimal extPrice,
                                                       String lineDesc,
                                                       integer primarylineNumber
                                                       ) {
        
        // create a new line item
        Apttus_Config2__LineItem__c lineItemSO = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configId);
        
        // setup line item data
        
        // line number
        lineItemSO.Apttus_Config2__LineNumber__c = lineNumber;
        // primary line
        lineItemSO.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        // item sequence
        lineItemSO.Apttus_Config2__PrimaryLineNumber__c=primarylineNumber;
        lineItemSO.Apttus_Config2__ItemSequence__c = itemSeq;
        // summary group id
        lineItemSO.Apttus_Config2__SummaryGroupId__c = groupId;
        // line type
        lineItemSO.Apttus_Config2__LineType__c = lineType;
        // product id
        lineItemSO.Apttus_Config2__ProductId__c = productId;
        // customizable
        lineItemSO.Apttus_Config2__Customizable__c = customizable;
        // product option id
        lineItemSO.Apttus_Config2__ProductOptionId__c = productOptionId;
        // option id
        lineItemSO.Apttus_Config2__OptionId__c = optionId;
        // classification id
        lineItemSO.Apttus_Config2__ClassificationId__c = classId;
        // classification hierarchy
        lineItemSO.Apttus_Config2__ClassificationHierarchy__c = classHierarchy;
        // quantity
        lineItemSO.Apttus_Config2__Quantity__c = quantity;
        // quantity modifiable
        lineItemSO.Apttus_Config2__IsQuantityModifiable__c = isQtyModifiable;
        // uom
        lineItemSO.Apttus_Config2__Uom__c = uom;
        // term
        lineItemSO.Apttus_Config2__Term__c = term;
        // price list id
        lineItemSO.Apttus_Config2__PriceListId__c = priceListId;
        // price list item id
        lineItemSO.Apttus_Config2__PriceListItemId__c = plItemId;
        // price type
        lineItemSO.Apttus_Config2__PriceType__c = priceType;
        // price method
        lineItemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        // charge type
        lineItemSO.Apttus_Config2__ChargeType__c = chargeType;
        // frequency
        lineItemSO.Apttus_Config2__Frequency__c = frequency;
        // allow manual adjustment
        lineItemSO.Apttus_Config2__AllowManualAdjustment__c = allowManualAdj;
        // allocate group adjustment
        lineItemSO.Apttus_Config2__AllocateGroupAdjustment__c = allocateGroupAdj;
        // list price
        lineItemSO.Apttus_Config2__ListPrice__c = listPrice;
        // base price
        lineItemSO.Apttus_Config2__BasePrice__c = basePrice;
        // base price mthod
        lineItemSO.Apttus_Config2__BasePriceMethod__c = basePriceMethod;
        // base extended price
        lineItemSO.Apttus_Config2__BaseExtendedPrice__c = baseExtPrice;
        // option price
        lineItemSO.Apttus_Config2__OptionPrice__c = optionPrice;
        // extended price
        lineItemSO.Apttus_Config2__ExtendedPrice__c = extPrice;
        // description
        lineItemSO.Apttus_Config2__Description__c = lineDesc;
        
        
         //lineItemSO.Apttus_Config2__PriceType__c = 'Recurring';
        // price method
        //lineItemSO.Apttus_Config2__PriceMethod__c = 'Flat Price';
        // charge type
        //lineItemSO.Apttus_Config2__ChargeType__c = 'Flat Price';
        // frequency
        //lineItemSO.Apttus_Config2__Frequency__c = 'Monthly';
        //lineItemSO.Apttus_Config2__BasePriceMethod__c = 'Flat Price';
         
        //   lineItemSO.Currency_Decimals__c = 2;    
        lineItemSO.Apttus_Config2__Term__c = 1;
        lineItemSO.Apttus_Config2__PricingStatus__c = 'New';
        lineItemSO.Apttus_Config2__SyncStatus__c = 'Pending';  
        
        lineItemSO.APTS_Year__c=null;                                                                                                                                                                                                  
        //lineItemSO.IsLineAlreadyCreated__c = true;
        
        // insert line item
        insert lineItemSO;
        
       // System.assert(lineItemSO.Id != null, 'Failed to create the line item for owner ' + UserInfo.getUserId());
            
        return lineItemSO;
        
    } 
    static OpportunityLineItem createOpportunityLineItem( 
                                          Id OpportunityId,  
                                          string lineType,
                                          Id pricebookEntryId,
                                          //Id Pricebook2Id,
                                          //Id productId,
                                          Id optionId )
    {
   
   
    
                                    
    	
     OpportunityLineItem opli =new OpportunityLineItem(PricebookEntryId=pricebookEntryId, 
                                                  OpportunityId=OpportunityId, 
                                                  UnitPrice=null,
                                                  TotalPrice=100, 
                                                  Quantity=1,
                                                  LineType__c=lineType,
                                                  SellingTerm__c=0.75,
                                                  APTS_Year__c=3,
                                                  NetPrice__c=100,
                                                  OptionId__c=optionId
                                                  );
     //insert opli;   
     //system.assertNotEquals(opli.id,null);
     return opli;                                          
    }

}