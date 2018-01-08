/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class IncentiveService {
    global IncentiveService() {

    }
    global static Apttus_Config2__LoyaltyPointAccrualSummary__c adjustLoyaltyPoints(Id enrollmentId, Apttus_Config2__LoyaltyPointAccrualAdjustmentItem__c adjItemSO) {
        return null;
    }
    global static Map<Id,List<Apttus_Config2__Incentive__c>> amendIncentives(Set<Id> incentiveIds, List<Apttus_Config2.Property> props) {
        return null;
    }
    global static Map<Id,List<Apttus_Config2__OrderPocketAdjustmentLineItem__c>> applyIncentivesToOrder(Id orderId, Set<String> couponCodes, Set<String> autoApplyCodes) {
        return null;
    }
    global static Map<Id,List<Apttus_Config2__OrderPocketAdjustmentLineItem__c>> applyIncentivesToOrder(Id orderId, Set<String> couponCodes, Set<String> autoApplyCodes, Apttus_Config2.CustomClass.IncentiveAutoApplyRule autoApplyRule) {
        return null;
    }
    global static Map<Id,Apttus_Config2__Incentive__c> cloneIncentives(Set<Id> incentiveIds, List<Apttus_Config2.Property> props) {
        return null;
    }
    global static Apttus_Config2__LoyaltyPointAccrualSummary__c computeLoyaltyPointsForEnrollment(Id enrollmentId) {
        return null;
    }
    global static Id computeLoyaltyPointsForEnrollmentAsync(Id enrollmentId) {
        return null;
    }
    global static Apttus_Config2__LoyaltyPointAccrualSummary__c computeLoyaltyPointsForOrder(Id orderId, Id enrollmentId) {
        return null;
    }
    global static List<Apttus_Config2__LoyaltyPointAccrualSummary__c> computeLoyaltyPointsForOrder(Id orderId) {
        return null;
    }
    global static Apttus_Config2.CPQStruct.RebateResult computeRebate(Apttus_Config2.CPQStruct.RebateInput input) {
        return null;
    }
    global static List<Apttus_Config2__Incentive__c> getIncentivesForCart(Id cartId) {
        return null;
    }
    global static List<Apttus_Config2__Incentive__c> getIncentivesForOrder(Id orderId) {
        return null;
    }
    global static Id initiateLoyaltyCycleForEnrollment(Id enrollmentId) {
        return null;
    }
    global static Id initiateLoyaltyCycleForEnrollmentAsync(Id enrollmentId) {
        return null;
    }
    global static Id processLoyaltyCycleAsync(List<Id> loyaltyIds, Date runDate) {
        return null;
    }
    global static Map<Id,List<Apttus_Config2__Incentive__c>> renewIncentives(Set<Id> incentiveIds, List<Apttus_Config2.Property> props) {
        return null;
    }
global enum AutoApplyRule {DISABLE, ENABLE, RESTRICT}
}
