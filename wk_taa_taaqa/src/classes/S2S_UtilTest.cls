/*
    **************************************************************************
    Name    :   S2S_UtilTest
    
    Used for  :   Test class for S2S_Util.
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          05-Sep-2017  
    
   
    
    ***************************************************************************
*/
@isTest 
private class S2S_UtilTest {


 static testMethod void calutil() {
    
    Test.StartTest();
    
     Boolean isTriggerOff = S2S_Util.fetchTriggerOffFlag('Opportunity');
     S2S_Util.prepareLogEntry('Opp Sync','some text',null,null,'TAA','500',255,system.now(),25);
     Boolean isTriggerOff2 = S2S_Util.isAdminemail('Opportunity');
    Test.StopTest();
 
 }






}