/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CustomClass {
    global static String APPROVALCTX_CART;
    global static String APPROVALCTX_HEADER;
    global static String APPROVALCTX_LINEITEM;
    global static String APPROVALMODE_PREVIEW;
    global static String APPROVALMODE_SUBMIT;
    global static String ASSET_SEARCH_FOR_DISPLAY;
    global static String ASSET_SEARCH_FOR_RULE;
    global CustomClass() {

    }
global class ActionCallbackRequest {
    global List<Id> BundleLineItemIds {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global ActionCallbackRequest() {

    }
}
global class ActionCallbackResponse {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global ActionCallbackResponse() {

    }
}
global class ActionParams {
    global Id AccountId {
        get;
        set;
    }
    global Set<Id> AccountIds {
        get;
        set;
    }
    global String ActionName {
        get;
        set;
    }
    global Boolean ActivateOrder {
        get;
        set;
    }
    global String ApprovalCtxType {
        get;
        set;
    }
    global String ApprovalMode {
        get;
        set;
    }
    global String ApprovalReason {
        get;
        set;
    }
    global String ApprovalType {
        get;
        set;
    }
    global List<Apttus_Config2__AssetLineItem__c> AssetLineItems {
        get;
        set;
    }
    global Id ConfigurationId {
        get;
        set;
    }
    global String CurrentState {
        get;
        set;
    }
    global Map<String,String> CustomParams {
        get;
        set;
    }
    global String FinalizeClass {
        get;
        set;
    }
    global String Flow {
        get;
        set;
    }
    global Boolean IsAngular {
        get;
        set;
    }
    global Boolean IsDraft {
        get;
        set;
    }
    global String LaunchState {
        get;
        set;
    }
    global Set<Id> LineItemIds {
        get;
        set;
    }
    global Decimal LineNumber {
        get;
        set;
    }
    global Set<Id> LocationIds {
        get;
        set;
    }
    global String Method {
        get;
        set;
    }
    global String Mode {
        get;
        set;
    }
    global List<Apttus_Config2__OrderLineItem__c> OrderLineItems {
        get;
        set;
    }
    global Apttus_Config2__Order__c OriginalOrderSO {
        get;
        set;
    }
    global String OutputFormat {
        get;
        set;
    }
    global String ProtectionLevel {
        get;
        set;
    }
    global Id RequestId {
        get;
        set;
    }
    global Id ReturnId {
        get;
        set;
    }
    global String ReturnPage {
        get;
        set;
    }
    global String SessionId {
        get;
        set;
    }
    global String SessionUrl {
        get;
        set;
    }
    global String TemplateName {
        get;
        set;
    }
    global ActionParams() {

    }
}
global enum ActionType {ACTION_ACTIVATE, ACTION_CANCEL, ACTION_COMPLETE, ACTION_CREATE_FROM_AGREEMENT, ACTION_CREATE_FROM_QUOTE, ACTION_SPLIT}
global class Address {
    global String City {
        get;
        set;
    }
    global String Country {
        get;
        set;
    }
    global String CountryCode {
        get;
        set;
    }
    global String County {
        get;
        set;
    }
    global String PostalCode {
        get;
        set;
    }
    global String State {
        get;
        set;
    }
    global String StateCode {
        get;
        set;
    }
    global String Street {
        get;
        set;
    }
    global Address() {

    }
}
global enum AssetLineActionType {ACTION_TYPE_CANCEL, ACTION_TYPE_CHANGE, ACTION_TYPE_INFO}
global class AssetRenewalInput {
    global Id AccountId {
        get;
    }
    global String BusinessObjectType {
        get;
    }
    global Apttus_Config2.CustomClass.IAssetRenewalCustomCallback CustomCallback {
        get;
    }
    global String ExecMode {
        get;
    }
    global String GroupByValue {
        get;
    }
    global Id PriceBookId {
        get;
    }
    global Id PriceListId {
        get;
    }
    global Date RenewalEndDate {
        get;
    }
    global Date RenewalStartDate {
        get;
    }
    global Decimal RenewalTerm {
        get;
    }
    global Id SourceBusinessObjectId {
        get;
    }
}
global class AssetRenewalOutput {
    global Id BusinessObjectId {
        get;
        set;
    }
    global Id ConfigurationId {
        get;
        set;
    }
    global Id RequestId {
        get;
        set;
    }
    global AssetRenewalOutput() {

    }
}
global class BillingMetricsInput {
    global Apttus_Config2.CustomClass.AssetLineActionType ActionType {
        get;
        set;
    }
    global Apttus_Config2__AssetLineItem__c AssetLineItemSO {
        get;
        set;
    }
    global Date EffectiveDate {
        get;
        set;
    }
    global String NewBillingFrequency {
        get;
        set;
    }
    global Date NewEndDate {
        get;
        set;
    }
    global Decimal NewNetPrice {
        get;
        set;
    }
    global Decimal NewSellingTerm {
        get;
        set;
    }
    global BillingMetricsInput() {

    }
}
global class BillingMetricsOutput {
    global Apttus_Config2__AssetLineItem__c AssetLineItemSO {
        get;
        set;
    }
    global Decimal CreditedAmount {
        get;
        set;
    }
    global Decimal CreditedInvoicedAmount {
        get;
        set;
    }
    global Decimal CreditedPendingBillingAmount {
        get;
        set;
    }
    global String ErrorMessage {
        get;
        set;
    }
    global Date InvoicedThroughDate {
        get;
        set;
    }
    global Decimal PaidAmount {
        get;
        set;
    }
    global Decimal TotalCancelledAmount {
        get;
        set;
    }
    global Decimal TotalInvoicedAmount {
        get;
        set;
    }
    global Decimal TotalPendingBillingAmount {
        get;
        set;
    }
    global BillingMetricsOutput() {

    }
}
global class FormulaPageInfo {
    global String NamespacePrefix {
        get;
    }
    global String PageName {
        get;
    }
    global FormulaPageInfo(String pageName, String nsPrefix) {

    }
}
global enum FormulaType {PRICE, QUANTITY}
global interface IActionCallback {
}
global interface IActionCallback2 extends Apttus_Config2.CustomClass.IActionCallback {
}
global interface IActionCallback3 {
}
global interface IActionInvokerCallback {
}
global interface IActionParamsCallback {
}
global interface IAdjustmentLineItemCallback {
    void finish();
}
global interface IAdvancedApprovalCallback {
}
global interface IAssetLineItemCallback {
    void finish();
    List<String> getAssetSearchScope();
}
global interface IAssetLineItemCallback2 {
    void finish();
    List<String> getAssetSearchScope();
}
global interface IAssetRenewalCallback {
}
global interface IAssetRenewalCustomCallback {
    String getAssetFilterExpr();
}
global interface IBatchJobCallback {
}
global interface IBillingMetricsCallback {
}
global interface ICartApprovalCallback {
}
global interface ICartApprovalCallback2 {
}
global interface IConfigureProductsCallback {
}
global interface IDealOptimizerCallback {
}
global interface IDealOptimizerCallback2 {
}
global interface IDisplayActionCallback {
}
global interface IFormulaCallback {
}
global interface ILoyaltyPointCallback {
}
global interface IMetadataCallback {
}
global interface IMilestoneUpdateCallback {
}
global interface IOrderLifecycleCallback {
}
global interface IOrderLifecycleCallback2 extends Apttus_Config2.CustomClass.IOrderLifecycleCallback {
}
global interface IPrestoCallback {
}
global interface IPricingCallback {
    void finish();
}
global interface IPricingCallback2 {
    void finish();
}
global interface IPricingCallback3 extends Apttus_Config2.CustomClass.IPricingCallback2 {
}
global interface IProductAttributeCallback {
    void finish();
}
global interface IProductFilterCallback {
}
global interface IRecommendationCallback {
}
global interface IRelatedPricingCallback {
}
global interface IShippingCallback {
}
global interface ITaxCallback {
}
global interface ITaxCallback2 extends Apttus_Config2.CustomClass.ITaxCallback {
}
global interface IValidationCallback {
}
global interface IValidationCallback2 {
}
global interface IValidationCallback3 {
}
global enum IncentiveAutoApplyRule {DISABLE, ENABLE, RESTRICT}
global class JobInput {
    global Apttus_Config2__BatchJob__c JobSO {
        get;
    }
}
global class MilestoneInfo {
    global List<Id> CompletedMilestoneIds {
        get;
    }
    global List<String> DependentFieldNames {
        get;
    }
    global String DependentSObjectName {
        get;
    }
}
global class PrestoInput {
    global String AppId {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global PrestoInput() {

    }
}
global class PrestoResult {
    global Boolean IsSuccess {
        get;
        set;
    }
    global PrestoResult(Boolean isSuccess) {

    }
}
global enum PricingMode {ADJUSTMENT, BASEPRICE, ROLLDOWN}
global class RecommendationInfo {
    global Id ProductId {
        get;
    }
    global List<Id> RelatedProductIds {
        get;
    }
    global String Relevance {
        get;
    }
    global RecommendationInfo(Id productId, String relevance) {

    }
}
global class RelatedPriceResult {
    global Decimal BasePrice {
        get;
        set;
    }
    global RelatedPriceResult() {

    }
}
global class ShippingInput {
    global Object Handback {
        get;
        set;
    }
    global SObject Item {
        get;
        set;
    }
    global Apttus_Config2.CustomClass.Address ShippingAddress {
        get;
        set;
    }
    global ShippingInput() {

    }
}
global class ShippingResult {
    global Object Handback {
        get;
        set;
    }
    global Decimal ShippingCharge {
        get;
        set;
    }
    global ShippingResult() {

    }
}
global class TaxInput {
    global Object Handback {
        get;
        set;
    }
    global SObject Item {
        get;
        set;
    }
    global Decimal TaxableAmount {
        get;
        set;
    }
    global Apttus_Config2.CustomClass.Address TaxAddress {
        get;
        set;
    }
    global String TaxCode {
        get;
        set;
    }
    global TaxInput() {

    }
}
global class TaxResult {
    global Object Handback {
        get;
        set;
    }
    global Decimal TaxAmount {
        get;
        set;
    }
    global List<Apttus_Config2__TaxBreakup__c> TaxBreakups {
        get;
        set;
    }
    global TaxResult() {

    }
}
global class UsageInput {
    global List<Apttus_Config2.Property> ItemState {
        get;
        set;
    }
    global Decimal ListPrice {
        get;
        set;
    }
    global Id MatrixId {
        get;
        set;
    }
    global Decimal PrevQuantity {
        get;
        set;
    }
    global String PriceMethod {
        get;
        set;
    }
    global Decimal Quantity {
        get;
        set;
    }
    global Date TxnDate {
        get;
        set;
    }
    global List<Apttus_Config2.UsagePriceTierDO> UsageTiers {
        get;
        set;
    }
    global UsageInput() {

    }
}
global class UsagePriceResult {
    global Decimal UsagePrice {
        get;
    }
}
global class ValidationResult {
    global Boolean HasMessages {
        get;
    }
    global Boolean IsSuccess {
        get;
        set;
    }
    global List<ApexPages.Message> Messages {
        get;
    }
    global ValidationResult(Boolean isSuccess) {

    }
}
}
