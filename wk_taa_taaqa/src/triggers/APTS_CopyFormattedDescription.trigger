trigger APTS_CopyFormattedDescription on Product2 (before insert,before update) {
    for (Product2 prod : Trigger.new) {
       
        String siDesc = '';
        String arcoDesc = '';
        String paccodeDesc = '';
        if (prod.Special_Instructions__c != null && prod.Special_Instructions__c != '') {
            siDesc = prod.Special_Instructions__c;
        }
        if (prod.ACRO__c != null && prod.ACRO__c != '') {
            arcoDesc = prod.ACRO__c;
        }
        if (prod.PAC_Code__c != null && prod.PAC_Code__c != '') {
            paccodeDesc  = prod.PAC_Code__c;
        }
        String str = siDesc+'\u003Cbr\u003E\u003Cbr\u003E ACRO: '+arcoDesc+'\u003Cbr\u003E\u003Cbr\u003EPAC Code: '+paccodeDesc;
        
        prod.My_Listed_Products_Desc__c = str;
    }
}