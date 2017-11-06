global class APTSValidationCallback implements Apttus_Config2.CustomClass.IValidationCallback2 {
    
    /**
* Callback to validate the line items in the cart
* @param cart the cart object to validate
* @return the validation result
*/
    global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
        Apttus_Config2__ProductConfiguration__c productConfiguration = cart.getConfigSO();
        List <Apttus_Config2.LineItem> allLines = cart.getLineItems();
        List<Apttus_Config2__LineItem__C> allLineItems = getLineItems(allLines);
        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
        boolean validateChk = false;
        result.isSuccess=  true;
        
        APTSPaymentTermHandler paymentTermHandler = new APTSPaymentTermHandler(allLineItems, productConfiguration.APTS_Order_Type__c
                                                                               , productConfiguration.Apttus_QPConfig__Proposald__c
                                                                               , productConfiguration.APTS_SAP_Payment_Term__c);        
        APTSPaymentTermHandler.PaymentTermResult pymtTermResult = paymentTermHandler.validate();
        
        if(!pymtTermResult.isSuccess){
            result.isSuccess=  false;
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, pymtTermResult.message)); 
        }
        else{
            if(APTSConstants.CONTINUEFLOW != pymtTermResult.message){
                paymentTermHandler.insertPaymentTerm();
                
            }
            /*
              after debugging comment message line and return true;
            */
            //result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'pymt terms debug'));
            result.isSuccess=  true;
        }
        
        
        //display error message if adjustment amount is manually given in the cart page
        string ErrorMessage='';
        for(Apttus_Config2__LineItem__C lineItem:allLineItems)
        {
         if(!string.isEmpty(lineItem.APTS_Promo_Code__c) && lineItem.Apttus_Config2__AdjustmentAmount__c!=null )
         {
          ErrorMessage='You cannot apply a manual discount on a Promo product';
          result.isSuccess=false;
          result.Messages.add(new apexpages.Message(Apexpages.Severity.Error,ErrorMessage));
         }
         
        }
        
        return result;
    }
    
    
    /**
* Callback to validate the given list ramp line items
* @param cart the cart object associated with the ramp line items
* @param rampLineItems the list of ramp line items
* @return the validation result
*/
    global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.LineItem> rampLineItems) {
        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
        
        //Build your logic and set error message
        //result.isSuccess =  true; set if no error
        //result.isSuccess =  true; set if there is error
        //result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'Errro message')); 
        
        //result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter start Date post BED')); 
        return result;
        
        
    }
    
    
    /* Gets the list of product line items associated with the Battery line
* @param cart the cart object
* @return the list of line item objects
*/
    private static List<Apttus_Config2__LineItem__C> getLineItems(List<Apttus_Config2.LineItem> allLines) {
        
        List<Apttus_Config2__LineItem__C> lineItems = new List<Apttus_Config2__LineItem__C>();
        // iterate thru the cart and get the line items matching the battery code1 
        for (Apttus_Config2.LineItem lineItemMO : allLines) {
            lineItems.add(lineItemMO.getLineItemSO());
        }
        
        return lineItems;   
        
    }
    /**
* Callback to validate the given list of asset items
* @param cart the cart object associated with the asset items
* @param assetItems the list of asset items
* @return the validation result
*/
    global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2__TempRenew__c> assetItems) {
        return new Apttus_Config2.CustomClass.ValidationResult(true);
        
    }
    
}