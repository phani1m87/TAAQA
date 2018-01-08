/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQStruct {
    global CPQStruct() {

    }
global abstract class ABOActionRequestDO {
    global List<Id> AssetIds {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global ABOActionRequestDO() {

    }
}
global abstract class ABOActionResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global Map<Id,Apttus_Config2__LineItem__c> LineItemMap {
        get;
        set;
    }
}
global abstract class APIResponseDO {
    global List<String> Errors {
        get;
        set;
    }
}
global class AcceptOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global AcceptOrderRequestDO() {

    }
}
global class AcceptOrderResponseDO {
    webService List<Apttus_Config2__AssetLineItem__c> AssetItems {
        get;
    }
    webService Boolean IsSuccess {
        get;
    }
}
global class AddRampLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class AddRampLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class CancelAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Date CancelDate {
        get;
        set;
    }
    global CancelAssetsRequestDO() {

    }
}
global class CancelAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class ChangeAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global ChangeAssetsRequestDO() {

    }
}
global class ChangeAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class CommitIncentiveBenefitDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveBenefitDataRequestDO() {

    }
}
global class CommitIncentiveBenefitDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitIncentiveDataRequestDO {
    webService Boolean CommitBenefitData {
        get;
        set;
    }
    webService Boolean CommitCouponData {
        get;
        set;
    }
    webService Boolean CommitLimitData {
        get;
        set;
    }
    webService Boolean CommitRollupData {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveDataRequestDO() {

    }
}
global class CommitIncentiveDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitIncentiveLimitDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveLimitDataRequestDO() {

    }
}
global class CommitIncentiveLimitDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitRollupDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CommitRollupDataRequestDO() {

    }
}
global class CommitRollupDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CreateAssetRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CreateAssetRequestDO() {

    }
}
global class CreateAssetResponseDO {
    webService List<Apttus_Config2__AssetLineItem__c> AssetItems {
        get;
    }
}
global class CreateCartRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    global CreateCartRequestDO() {

    }
}
global class CreateCartResponseDO {
    webService Id CartId {
        get;
    }
}
global class CreateOrderRequestDO {
    webService Id AccountId {
        get;
        set;
    }
    webService Datetime OrderDate {
        get;
        set;
    }
    webService Date OrderEndDate {
        get;
        set;
    }
    webService Date OrderStartDate {
        get;
        set;
    }
    webService Id PriceListId {
        get;
        set;
    }
    webService Datetime PricingDate {
        get;
        set;
    }
    webService Id RecordTypeId {
        get;
        set;
    }
    global CreateOrderRequestDO() {

    }
}
global class CreateOrderResponseDO {
    webService Apttus_Config2__Order__c OrderSO {
        get;
    }
}
global class CreateRollupDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    webService List<Id> RollupIds {
        get;
        set;
    }
    global CreateRollupDataRequestDO() {

    }
}
global class CreateRollupDataResponseDO {
    webService List<Apttus_Config2__OrderRollupData__c> OrderRollupData {
        get;
    }
}
global class PlaceOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global PlaceOrderRequestDO() {

    }
}
global class PlaceOrderResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class PricePendingInfo {
    webService List<Integer> CompletedLineNumbers {
        get;
    }
    webService List<Integer> ErrorLineNumbers {
        get;
    }
    webService Boolean IsPricePending {
        get;
    }
    webService Boolean IsTotalPricePending {
        get;
    }
    webService List<Integer> PendingLineNumbers {
        get;
    }
}
global class ProductBundleDO {
    global Apttus_Config2.CPQStruct.ProductLineItemDO BundleProduct {
        get;
    }
    global Boolean HasOptionProducts {
        get;
    }
    global List<Id> OptionProductIds {
        get;
    }
    global List<Apttus_Config2.CPQStruct.ProductLineItemDO> OptionProducts {
        get;
    }
    global ProductBundleDO(Apttus_Config2.CPQStruct.ProductLineItemDO bundle, List<Apttus_Config2.CPQStruct.ProductLineItemDO> optItems) {

    }
}
global class ProductCollDO {
    global Boolean HasProducts {
        get;
    }
    global List<Id> ProductIds {
        get;
    }
    global List<Apttus_Config2.CPQStruct.ProductLineItemDO> Products {
        get;
    }
    global ProductCollDO(List<Apttus_Config2.CPQStruct.ProductLineItemDO> prodItems) {

    }
}
global class ProductLineItemDO {
    global String AddedBy {
        get;
    }
    global String Comments {
        get;
    }
    global Date EndDate {
        get;
    }
    global Id productOptionComponentId {
        get;
    }
    global Product2 ProductSO {
        get;
    }
    global Decimal Quantity {
        get;
    }
    global Decimal SellingTerm {
        get;
    }
    global Date StartDate {
        get;
    }
    global ProductLineItemDO(Product2 productSO, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
    global ProductLineItemDO(Product2 productSO, String addedBy, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
    global ProductLineItemDO(Product2 productSO, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments, Id productOptionComponentId) {

    }
}
global class QueryAssetsRequestDO {
    global List<Id> AccountIds {
        get;
        set;
    }
    global String CustomFilter {
        get;
        set;
    }
    global Boolean Descending {
        get;
        set;
    }
    global List<String> FieldNames {
        get;
        set;
    }
    global Integer Nrecord {
        get;
        set;
    }
    global Integer Offset {
        get;
        set;
    }
    global List<String> SortFields {
        get;
        set;
    }
    global QueryAssetsRequestDO() {

    }
}
global class QueryAssetsResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global Integer AssetCount {
        get;
        set;
    }
    global List<Apttus_Config2__AssetLineItem__c> AssetLineItems {
        get;
        set;
    }
}
global class QueryCartRequestDO {
}
global class QueryCartResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RebateInput {
    global List<Apttus_Config2__ExternalOrderSummaryItem__c> ExternalOrderSummaryItems {
        get;
        set;
    }
    global List<Apttus_Config2__Milestone2__c> MilestoneItems {
        get;
        set;
    }
    global List<Apttus_Config2__OrderLineItem__c> OrderLineItems {
        get;
        set;
    }
    global List<Id> RebateIds {
        get;
        set;
    }
    global RebateInput() {

    }
}
global class RebateResult {
    global List<Apttus_Config2__ExternalOrderAdjustmentItem__c> ExternalOrderAdjItems {
        get;
    }
    global List<Apttus_Config2__IncentiveAdjustmentItem__c> IncentiveAdjItems {
        get;
    }
    global List<Apttus_Config2__MilestoneAdjustmentItem__c> MilestoneAdjItems {
        get;
    }
    global List<Apttus_Config2__OrderPocketAdjustmentLineItem__c> OrderAdjItems {
        get;
    }
}
global class RecommendationRequestDO {
    global Id CartId {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global RecommendationRequestDO() {

    }
}
global class RecommendationResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global List<Id> ProductIds {
        get;
        set;
    }
}
global class RemoveOptionLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class RemoveOptionLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RemoveRampLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class RemoveRampLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RenewAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Boolean FarthestAssetEndDate {
        get;
        set;
    }
    global Date RenewEndDate {
        get;
        set;
    }
    global Decimal RenewTerm {
        get;
        set;
    }
    global RenewAssetsRequestDO() {

    }
}
global class RenewAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class SwapAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Date NewStartDate {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global SwapAssetsRequestDO() {

    }
}
global class SwapAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class SynchronizeCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global SynchronizeCartRequestDO() {

    }
}
global class SynchronizeCartResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class UpdateLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class UpdateLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
}
