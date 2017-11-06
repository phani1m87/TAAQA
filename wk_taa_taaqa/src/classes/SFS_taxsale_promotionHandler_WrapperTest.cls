@IsTest
public class SFS_taxsale_promotionHandler_WrapperTest {
    
    static testMethod void testParse() {
        String json = '{\"Customer\":{\"subsegment\":\"2-4 Total Employees\",\"ShippingZip\":\"60647\",\"ShippingState\":\"IL\",\"Shippingcountry\":\"US\",\"ShippingCity\":\"CHICAGO\",\"ShippingAdress\":\"1234 MAIN STREET\",\"Segment\":\"Accounting Firms\",\"Phone\":\"(310) 800-9255\",\"Name\":\"CCH INC. TECHNICAL SUPPORT-BOESCHEN\",\"BillingZip\":\"60647\",\"BillingState\":\"IL\",\"Billingcountry\":\"US\",\"BillingCity\":\"CHICAGO\",\"BillingAdress\":\"1234 MAIN STREET\",\"AcctOwner\":null,\"AccoutNumber\":\"0000174303\",\"AccountRecordId\":\"001i000000QP3nIAAT\"},\"Contacts\":{\"Phone\":\"(310) 800-9256\",\"Mobile\":null,\"LastName\":\"Morris\",\"FirstName\":\"Cyndi\",\"Fax\":null,\"Email\":\"cyndi.morris@wolterskluwer.com\",\"ContactRecordId\":\"003i000000Ubf80AAB\",\"ContactNumber\":\"0000604338\"}}';
        SFS_taxsale_promotionHandler_Wrapper obj = SFS_taxsale_promotionHandler_Wrapper.parse(json);
        System.assert(obj != null);
    }
}