/*
    **************************************************************************
    Name    :   smallfirm_taxsale_promotion 
    Used for  :   This trigger is used to push information from TAA to SFS, so that there is an opportunity,quote and order created for the $0 books in SFS, only If they have purchased a Tax solution.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
    
    ***************************************************************************
*/

   
    trigger Smallfirm_taxsale_promotion on Apttus_Proposal__Proposal__c (after update) {
    
    if(!smallfirm_taxsale_promotionHandler.hasAlreadyRunMethod()){
        smallfirm_taxsale_promotionHandler handler = new smallfirm_taxsale_promotionHandler (); 
        
            handler.afterupdate(Trigger.New, Trigger.oldMap);
       
        smallfirm_taxsale_promotionHandler.setAlreadyRunMethod(); 
    }
    
    
    }