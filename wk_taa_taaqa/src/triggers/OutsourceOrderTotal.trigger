trigger OutsourceOrderTotal on Apttus_Proposal__Proposal__c (before update) {    
   Decimal oTotal = 0;
      for(apttus_proposal__proposal__c p : trigger.new){
      if(p.OS_Tax_Year__c != null && p.OS_Tax_Year__c !=''){
           if(p.os_offshore_1040_1041_dollars__c == null && p.os_offshore_business_dollars__c == null && p.os_offshore_charter_dollars__c == null && p.os_onshore_1040_dollars__c == null && p.os_onshore_bus_dollars__c == null && p.os_onshore_charter_dollars__c == null){
              p.os_order_total_trigger__c = 0;
           }else{ 
             if(p.os_offshore_1040_1041_dollars__c != null){
                oTotal +=  p.os_offshore_1040_1041_dollars__c;
             }
             if(p.os_offshore_business_dollars__c != null){
                oTotal +=  p.os_offshore_business_dollars__c; 
             }
             if(p.os_offshore_charter_dollars__c != null){
                oTotal +=  p.os_offshore_charter_dollars__c; 
             }
             if(p.os_onshore_1040_dollars__c != null){
                oTotal +=  p.os_onshore_1040_dollars__c; 
             }
             if(p.os_onshore_bus_dollars__c != null){
                oTotal +=  p.os_onshore_bus_dollars__c; 
             }
             if(p.os_onshore_charter_dollars__c != null){
                oTotal +=  p.os_onshore_charter_dollars__c; 
             }
               
               p.os_order_total_trigger__c = oTotal;
               
               
               
                if(oTotal>1000 ){
               p.OS_25_Initial_Deposit__c = oTotal*0.25;
               }
               else
               {
               if(oTotal<>0){
                p.OS_25_Initial_Deposit__c = oTotal;
                }
                }
              
              
               
               if(p.os_deposit_flag__c != true){
              
             
               
               if(oTotal>1000 ){
               
               p.os_deposit_amount__c  = oTotal*0.25;
               p.OS_Deposit_flag__c = True;
               }
               else
               { 
               if(oTotal<>0){             
               p.os_deposit_amount__c  = oTotal;
               p.OS_Deposit_flag__c = True;
               }
               }
               }
               
               
               
           }  
     }
}
}