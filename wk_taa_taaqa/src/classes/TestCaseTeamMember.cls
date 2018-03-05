@isTest 
public class TestCaseTeamMember{
 
     Public static  testMethod void TestCaseTeamMember()
          {
              Case C = new case(status = 'Order taken', 
                                OwnerId = '005i0000005wjLZAAY',
                               Subject = 'Test',
                               Description = 'Test',
                               Company_name__C = 'Test',
                               Street__c = '123',
                               City__c = 'Test',
                               State__c = 'CA',
                               Zip_Postal_Code__c ='12345',
                               First_name__C = 'Test',
                               Last_name__C = 'test',
                               segment__c = 'Banks and Financial Institutions',
                               SubSegment__C = 'Large Enterprise',
                               email__c = 'test@test.com',
                               phone_Number__c = '123-456-7890');
                  
                  insert C;
          }             
}