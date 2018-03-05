@isTest 
private class TestNAICSCodes {

    static testMethod void insertAccount() {
   Account A = new Account(
            Name = 'myAcct', 
            BillingStreet='25 Upland Drive',
            BillingPostalCode='94127',
            BillingCountry='United States',
            BillingCity='San Francisco');
        insert A;
        
        a.sic = '111';
        
        update a;
}
 }