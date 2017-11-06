public class APTSPaymentTermHandler {   
    
    List<Apttus_Config2__LineItem__C> allLineItems;
    String orderType;
    String sapPaymentTerm;
    private Id quoteId;
    private Map<String, Decimal> paymentTermTotalPaymentMap;
    
    public APTSPaymentTermHandler(List<Apttus_Config2__LineItem__C> LineItemList, String orderType, Id quoteId
                                  , String sapPaymentTerm){
        System.debug('******Method Invoked');
        allLineItems = LineItemList;        
        this.orderType = orderType;
        this.quoteId = quoteId;
        this.sapPaymentTerm = sapPaymentTerm;
    }
    
    
    public PaymentTermResult validate(){
        System.debug('*************orderType:' + orderType);
        System.debug('*************quoteId:' + quoteId);
        //Map<String, List<Apttus_Config2__LineItem__c>> productOptionMap = new Map<String, List<Apttus_Config2__LineItem__c>>();  
        Map<String, List<Apttus_Config2__LineItem__c>> productStandaloneMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        Map<Id, Apttus_Config2__ProductAttributeValue__c> productAttributeMap;
        String uniqueProductIdentifier;
        Set<Id> productAttributeIdSet = new Set<Id>();
        Apttus_Config2__ProductAttributeValue__c attributeSO;
        Map<String, OptionGroupWrapper> bundleStandAloneProductPaymentTermMap = new Map<String, OptionGroupWrapper>();
        List<Apttus_Config2__LineItem__c> bundleStandAloneProduct = new List<Apttus_Config2__LineItem__c>();
        OptionGroupWrapper optionGroupWrp;
        PaymentTermResult validation = new PaymentTermResult(true, null);
        Boolean isTax100PaymentTerm;
        Boolean isTax1000PaymentTerm;
        Boolean isNonTaxPaymentTerm;
        Boolean isValidationFailLowerLimit;
        Boolean isValidationFailUpperLimit;
        Integer paymentTermLowerLimit;
        Integer paymentTermUpperLimit;
        String paymentTerm;
        Boolean continueFlow = true;
        
        
        //Check valid state for validation
        for(Apttus_Config2__LineItem__C line : allLineItems){
            if(line.Apttus_Config2__PricingStatus__c != APTSConstants.COMPLETE){
                 System.debug('*************Apttus_Config2__PricingStatus__c:' + line.Apttus_Config2__PricingStatus__c);
               //|| line.Apttus_Config2__SyncStatus__c != APTSConstants.PENDING){
                   continueFlow = false;
                
             }
        }
        System.debug('*************continueFlow:' + continueFlow);
        if(!continueFlow){
            validation = new PaymentTermResult(true, APTSConstants.CONTINUEFLOW);
            return validation;
        }
        
        //Get Attribute values from attribute value object
        //
        
        string str = '';
        for(Apttus_Config2__LineItem__C line : allLineItems){
            //str += line.Apttus_Config2__PricingStatus__c+';' + line.Apttus_Config2__SyncStatus__c + ';';
            uniqueProductIdentifier = line.Apttus_Config2__ProductId__c + APTSConstants.CommaDelimeter + line.Apttus_Config2__LineNumber__c;
            
            if(APTSConstants.PRODUCTSERVICE == line.Apttus_Config2__LineType__c){
                if(!productStandaloneMap.containsKey(uniqueProductIdentifier)){
                    productStandaloneMap.put(uniqueProductIdentifier, new List<Apttus_Config2__LineItem__c>());
                    if(line.Apttus_Config2__AttributeValueId__c != null){
                        productAttributeIdSet.add(line.Apttus_Config2__AttributeValueId__c);
                    }
                }
                productStandaloneMap.get(uniqueProductIdentifier).add(line);
            }
        }
        
        //System.debug('********** productAttributeIdSet.size(): '+productAttributeIdSet.size());
        //Fetch Attribute Values
        if(productAttributeIdSet.size() > 0){
            productAttributeMap = new Map<Id, Apttus_Config2__ProductAttributeValue__c>([SELECT Tax_100_s_Payment_Terms__c
                                                                                         , Tax_1000_s_Payment_Terms__c
                                                                                         , APTS_Non_Tax_Payment_Terms__c  //Added Raj
                                                                                         FROM Apttus_Config2__ProductAttributeValue__c
                                                                                         where id IN : productAttributeIdSet]);
        }
        
        
        //Loop each bundle standalone
        System.debug('***************productStandaloneMap: ' + productStandaloneMap);
        System.debug('***************productAttributeMap: ' + productAttributeMap);
        //System.debug('*********mapsizes ' + productAttributeMap.size()+'productStandaloneMap'+productStandaloneMap.size());
        for(List<Apttus_Config2__LineItem__c> bundleStandAloneLineList : productStandaloneMap.values()){
            
            //system.debug('********** bundleStandAloneLineList.size(): '+bundleStandAloneLineList.size());
            system.debug('********** bundleStandAloneLineList: '+bundleStandAloneLineList);
            isTax100PaymentTerm = false;
            isTax1000PaymentTerm = false;
            isNonTaxPaymentTerm = false;
            paymentTerm = null;
            if(orderType == 'SAP'){
                paymentTerm = sapPaymentTerm;
            }
            for(Apttus_Config2__LineItem__c bundleStandAloneLineSO : bundleStandAloneLineList){
                
                if(bundleStandAloneLineSO.Apttus_Config2__AttributeValueId__c != null){
                    attributeSO = productAttributeMap.get(bundleStandAloneLineSO.Apttus_Config2__AttributeValueId__c);
                     System.debug('***************attributeSO: ' + attributeSO);
                    if(attributeSO.Tax_100_s_Payment_Terms__c != null){
                        isTax100PaymentTerm = true;
                        paymentTerm = attributeSO.Tax_100_s_Payment_Terms__c;
                         System.debug('***************100 attributeSO: ' + attributeSO);
                    }else if(attributeSO.Tax_1000_s_Payment_Terms__c != null){
                        isTax1000PaymentTerm = true;
                        paymentTerm = attributeSO.Tax_1000_s_Payment_Terms__c;
                    }else if(attributeSO.APTS_Non_Tax_Payment_Terms__c != null){
                        isNonTaxPaymentTerm = true;
                        paymentTerm = attributeSO.APTS_Non_Tax_Payment_Terms__c;
                    }
                    
                }
                if(orderType == 'SAP'){
                    paymentTerm = sapPaymentTerm;
                     isTax100PaymentTerm = false;
                        isTax1000PaymentTerm = false;
                        isNonTaxPaymentTerm = false;
                }
                if(paymentTerm != null){
                    uniqueProductIdentifier = bundleStandAloneLineSO.Apttus_Config2__ProductId__c 
                        + APTSConstants.CommaDelimeter 
                        + bundleStandAloneLineSO.Apttus_Config2__LineNumber__c;
                    optionGroupWrp = new OptionGroupWrapper(isTax100PaymentTerm, isTax1000PaymentTerm
                                                            , isNonTaxPaymentTerm
                                                            , paymentTerm);
                    System.debug('***************optionGroupWrp: ' + optionGroupWrp);
                    bundleStandAloneProductPaymentTermMap.put(uniqueProductIdentifier, optionGroupWrp);
                    bundleStandAloneProduct.add(bundleStandAloneLineSO);
                    //break;
                }
            }
        }
        System.debug('***************bundleStandAloneProductPaymentTermMap: ' + bundleStandAloneProductPaymentTermMap);
        //Loop on bundle/Standalone which have Payment Term
        paymentTermTotalPaymentMap = new Map<String, Decimal>();
        Decimal totalNetPrice;
        Decimal netPrice;
        //system.debug('********* bundleStandAloneProduct: '+bundleStandAloneProduct.size());
        for(Apttus_Config2__LineItem__c bundleStandAloneLineSO : bundleStandAloneProduct){
        
            uniqueProductIdentifier = bundleStandAloneLineSO.Apttus_Config2__ProductId__c 
                + APTSConstants.CommaDelimeter 
                + bundleStandAloneLineSO.Apttus_Config2__LineNumber__c;
            optionGroupWrp = bundleStandAloneProductPaymentTermMap.get(uniqueProductIdentifier);
            if(optionGroupWrp != null && optionGroupWrp.PaymentTerm != null){
                netPrice = bundleStandAloneLineSO.Apttus_Config2__NetPrice__c;
                totalNetPrice = paymentTermTotalPaymentMap.get(optionGroupWrp.PaymentTerm);
                if(totalNetPrice == null){
                    totalNetPrice = 0;
                }
                totalNetPrice += netPrice != null ? netPrice : 0;
                paymentTermTotalPaymentMap.put(optionGroupWrp.PaymentTerm, totalNetPrice);
            }
        }
        System.debug('********** totalNetPrice: '+totalNetPrice);
        System.debug('***************bundleStandAloneProduct: ' + bundleStandAloneProduct);
        System.debug('***************paymentTermTotalPaymentMap: ' + paymentTermTotalPaymentMap);
        
         if(orderType == 'AMS'){
            //Validation Payment Term
            //
            APTS_PaymentTerm__c customSettingPaymentTerm = APTS_PaymentTerm__c.getValues(APTSConstants.CUSTOMSETTINGRECORD);
            system.debug('***customsetting'+customSettingPaymentTerm);
            system.debug('***totalNetPrice'+totalNetPrice);
            for(String payTerm : paymentTermTotalPaymentMap.keySet()){
                system.debug('payTerm::'+payTerm);
                isValidationFailLowerLimit = false;
                isValidationFailUpperLimit = false;
                //if(orderType == APTSConstants.AMS){
                //system.debug('***pymttermstotalmap'+paymentTermTotalPaymentMap.keyset());
                    totalNetPrice = paymentTermTotalPaymentMap.get(payTerm);
                    if(APTSConstants.FLEXPAY.equals(payTerm)){
                    	//system.debug()
                        if(totalNetPrice < customSettingPaymentTerm.FlexPayLowerLimit__c){
                            isValidationFailLowerLimit = true;
                            paymentTermLowerLimit = Integer.valueOf(customSettingPaymentTerm.FlexPayLowerLimit__c);                        
                        }
                    }
                    if(APTSConstants.IPP4.equals(payTerm)){
                        if(customSettingPaymentTerm.IPP4LowerLimit__c != null && totalNetPrice < customSettingPaymentTerm.IPP4LowerLimit__c){
                            isValidationFailLowerLimit = true;
                            paymentTermLowerLimit = Integer.valueOf(customSettingPaymentTerm.IPP4LowerLimit__c);                        
                        }
                        if(customSettingPaymentTerm.IPP4UpperLimit__c != null && totalNetPrice > customSettingPaymentTerm.IPP4UpperLimit__c){
                            isValidationFailUpperLimit = true;
                            paymentTermUpperLimit = Integer.valueOf(customSettingPaymentTerm.IPP4UpperLimit__c);                        
                        }
                    }
                    if(APTSConstants.IPP6.equals(payTerm)){
                        if(customSettingPaymentTerm.IPP6LowerLimit__c != null && totalNetPrice < customSettingPaymentTerm.IPP6LowerLimit__c){
                            isValidationFailLowerLimit = true;
                            paymentTermLowerLimit = Integer.valueOf(customSettingPaymentTerm.IPP6LowerLimit__c);                        
                        }
                    }
                    if(isValidationFailLowerLimit){
                        validation  = new PaymentTermResult(false, Label.APTS_Quote_Not_Eligible_for + APTSConstants.SPACE 
                                                            + payTerm + APTSConstants.SPACE
                                                            +  Label.APTS_Payment_Term_Lower_Limit + + APTSConstants.SPACE 
                                                            +  paymentTermLowerLimit +APTSConstants.DOT);
                        
                        paymentTermTotalPaymentMap = new Map<String, Decimal>();
                    }else if(isValidationFailUpperLimit){
                        validation  = new PaymentTermResult(false, Label.APTS_Quote_Not_Eligible_for + APTSConstants.SPACE 
                                                            + payTerm + APTSConstants.SPACE 
                                                            +  Label.APTS_Payment_Term_Upper_Limit + APTSConstants.SPACE 
                                                            +  paymentTermUpperLimit +APTSConstants.DOT); 
                        paymentTermTotalPaymentMap = new Map<String, Decimal>();
                    }
               // }
            }
         }
        System.debug('***************paymentTermTotalPaymentMap: ' + paymentTermTotalPaymentMap);
        return validation;
    }
    
    public PaymentTermResult insertPaymentTerm(){
        PaymentTermResult result = new PaymentTermResult(true, null);
        APTS_Payment_Term_Detail__c paymentTermSO;
        Decimal totalNetPrice;
        List<APTS_Payment_Term_Detail__c> existingPaymentTermDetailList = [SELECT ID FROM APTS_Payment_Term_Detail__c
                                                                            WHERE APTS_Quote_Proposal__c = : quoteId];
        delete existingPaymentTermDetailList;
        List<APTS_Payment_Term_Detail__c> paymentTermSOList = new List<APTS_Payment_Term_Detail__c>();
        for(String payTerm : paymentTermTotalPaymentMap.keySet()){           
            totalNetPrice = paymentTermTotalPaymentMap.get(payTerm);
            paymentTermSO = new APTS_Payment_Term_Detail__c(APTS_Payment_Term__c = payTerm, APTS_Quote_Proposal__c = quoteId
                                                            , APTS_Payment_Term_Total__c = totalNetPrice);
            paymentTermSOList.add(paymentTermSO);
        }
        if(paymentTermSOList.size() > 0){
            insert paymentTermSOList;
            result.isSuccess = true;            
        }
        return result;
    }
    
    
    
    public class PaymentTermResult{
        public Boolean  isSuccess{get;private set;}
        public String message{get;private set;}
        public PaymentTermResult(Boolean isSucess, String message){
            this.isSuccess = isSucess;
            this.message = message;
        }
    }
    
    
    
    public class OptionGroupWrapper{
        
        public Boolean IsTax100PaymentTerm{get; private set;}
        public Boolean IsTax1000PaymentTerm {get; private set;}
        public Boolean IsNonTaxPaymentTerm{get;private set;}
        public String PaymentTerm{get; private set;}
        public OptionGroupWrapper(Boolean isTax100Payment, Boolean isTax1000Payment
                                  , Boolean isNonTaxPaymentTerm, string paymentTerm){
                                      this.IsTax100PaymentTerm = isTax100Payment;
                                      this.IsTax1000PaymentTerm = isTax1000Payment;
                                      this.IsNonTaxPaymentTerm = isNonTaxPaymentTerm;
                                      this.PaymentTerm = paymentTerm;
                                  }
    }
    
}