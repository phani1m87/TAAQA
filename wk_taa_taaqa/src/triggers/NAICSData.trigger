trigger NAICSData on Account (before update) { 
    for (account Acc:trigger.new){
        account oldAcc= Trigger.oldmap.get(Acc.Id);
        if(oldacc.sic <> acc.sic){
       

  Map<String,String> NAICSLookup = new Map<String,String>();
  Set<String> Siccode = new Set<String>();    

 for(Account A:Trigger.new) {     
     
    Siccode.add(A.Sic);
   // a.addError('siccode');
     
 for(naics_code__c NA:

    [SELECT      sic_code_Number__c, Industry__c
     FROM        naics_code__c
     WHERE       sic_code_number__c IN :siccode]) {

    NAICSLookup.put(NA.sic_code_number__c,NA.Industry__c);
  }
 }

  for(Account A:Trigger.new) {
      if(NAICSLookup.containsKey(A.Sic)) {
      A.naics_Industry__c = NAICSLookup.get(A.sic);
      }
  }
            Map<String,String> NAICSLookup1 = new Map<String,String>();
  Set<String> Siccode1 = new Set<String>();    

 for(Account A1:Trigger.new) {     
     
    Siccode1.add(A1.Sic);
   // a.addError('siccode');
     
 for(naics_code__c NA1:

    [SELECT      sic_code_Number__c, sub_Industry__c
     FROM        naics_code__c
     WHERE       sic_code_number__c IN :siccode1]) {

    NAICSLookup1.put(NA1.sic_code_number__c,NA1.sub_Industry__c);
  }
 }

  for(Account A1:Trigger.new) {
      if(NAICSLookup1.containsKey(A1.Sic)) {
      A1.naics_Sub_Industry__c = NAICSLookup1.get(A1.sic);
      }
  }
  
       }
}
}