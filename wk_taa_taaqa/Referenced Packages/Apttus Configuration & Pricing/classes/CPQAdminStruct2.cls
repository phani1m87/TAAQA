/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQAdminStruct2 {
    global CPQAdminStruct2() {

    }
global class AttachmentRequestDO {
    global String AttachmentBody;
    global String AttachmentName;
    global Attachment AttachmentSO;
    global Id Id;
    global Id ParentId;
    global AttachmentRequestDO() {

    }
    global AttachmentRequestDO(Id parentId, String attachmentName, String attachmentBody) {

    }
    global AttachmentRequestDO(Id attachmentId, Id parentId, String attachmentName, String attachmentBody) {

    }
}
global class AttributeDO {
    global String AttributeFieldLabel {
        get;
        set;
    }
    global String FieldType {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PicklistValues {
        get;
        set;
    }
    global Apttus_Config2__ProductAttribute__c ProductAttributeSO {
        get;
        set;
    }
    global AttributeDO() {

    }
    global AttributeDO(Apttus_Config2__ProductAttribute__c productAttributeSO, String name, List<Schema.PicklistEntry> picklistValues) {

    }
    global AttributeDO(Apttus_Config2__ProductAttribute__c productAttributeSO, String name, List<Schema.PicklistEntry> picklistValues, String fieldType) {

    }
}
global class AttributeGroupDO {
    global Apttus_Config2__ProductAttributeGroup__c AttributeGroupSO {
        get;
        set;
    }
    global List<Apttus_Config2__FieldExpression__c> FieldExpressionSOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.AttributeDO> ProductAttributeDOs {
        get;
        set;
    }
    global List<Id> ProductAttributeGroupIds {
        get;
        set;
    }
    global Apttus_Config2__ProductAttributeGroupMember__c ProductAttributeGroupMemberSO {
        get;
        set;
    }
    global List<Id> ProductAttributeIds {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttribute__c> ProductAttributeSOs {
        get;
        set;
    }
    global AttributeGroupDO() {

    }
    global AttributeGroupDO(Apttus_Config2__ProductAttributeGroup__c attributeGroupSO) {

    }
    global AttributeGroupDO(Apttus_Config2__ProductAttributeGroup__c attributeGroupSO, List<Apttus_Config2.CPQAdminStruct2.AttributeDO> productAttributeDOs) {

    }
}
global class AttributeGroupRequestDO {
    global List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> AttributeGroups {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer MaxNumberOfAttributesPerGroup {
        get;
        set;
    }
    global Integer NumberOfAttributeGroupsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global AttributeGroupRequestDO() {

    }
    global AttributeGroupRequestDO(List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> attributeGroups, Integer groupsPerChunk) {

    }
    global AttributeGroupRequestDO(Integer chunkNumber, Integer groupsPerChunk, String searchString) {

    }
}
global class AttributeGroupResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> AttributeGroupDOs {
        get;
        set;
    }
    global Integer NumberOfAttributeGroupsInChunk {
        get;
        set;
    }
    global AttributeGroupResponseDO() {

    }
    global AttributeGroupResponseDO(List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> attributeGroupDOs, Integer groupsPerChunk) {

    }
}
global class AttributeValueMatrixDO {
    global List<Apttus_Config2__AccountLocation__c> AccountLocationSOsInScope {
        get;
        set;
    }
    global List<String> AttributeFieldNames {
        get;
        set;
    }
    global List<String> AttributeFieldNamesToAdd {
        get;
        set;
    }
    global List<String> AttributeFieldNamesToRemove {
        get;
        set;
    }
    global List<Apttus_Config2__AttributeValueMatrixEntry__c> AttributeValueMatrixEntrySOs {
        get;
        set;
    }
    global Id AttributeValueMatrixId {
        get;
        set;
    }
    global Apttus_Config2__AttributeValueMatrix__c AttributeValueMatrixSO {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfEntriesInChunk {
        get;
        set;
    }
    global Integer NumberOfEntriesPerChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.AttributeGroupDO ProductAttributeGroupDO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttributeMatrixView__c> ProductAttributeMatrixViewSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroup__c> ProductGroupSOsInScope {
        get;
        set;
    }
    global List<Product2> ProductSOsInScope {
        get;
        set;
    }
    global String SortDirection {
        get;
        set;
    }
    global String SortField {
        get;
        set;
    }
    global AttributeValueMatrixDO() {

    }
    global AttributeValueMatrixDO(Apttus_Config2__AttributeValueMatrix__c attrValueMatrixSO) {

    }
}
global class AutoCompleteItem {
    global String fieldName {
        get;
        set;
    }
    global String fieldType {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global List<Schema.PicklistEntry> picklistValues {
        get;
        set;
    }
    global String sObjectName {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global AutoCompleteItem() {

    }
    global AutoCompleteItem(String label, String value) {

    }
}
global class CategoryNodeDO {
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> ChildCategoryDOs {
        get;
        set;
    }
    global Apttus_Config2__ClassificationHierarchy__c ClsHierarchySO {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global CategoryNodeDO() {

    }
    global CategoryNodeDO(Apttus_Config2__ClassificationHierarchy__c hierarchySO) {

    }
    global CategoryNodeDO(Apttus_Config2__ClassificationHierarchy__c hierarchySO, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> childCategorySOs) {

    }
    global void addChild(Apttus_Config2.CPQAdminStruct2.CategoryNodeDO childWrapper) {

    }
}
global class ConstraintRuleActionDO {
    global List<Apttus_Config2__ConstraintRuleActionExpression__c> ConstraintRuleActionExpressionSOs {
        get;
        set;
    }
    global Apttus_Config2__ConstraintRuleAction__c ConstraintRuleActionSO {
        get;
        set;
    }
    global ConstraintRuleActionDO() {

    }
    global ConstraintRuleActionDO(Apttus_Config2__ConstraintRuleAction__c ruleActionSO) {

    }
    global ConstraintRuleActionDO(Apttus_Config2__ConstraintRuleAction__c ruleActionSO, List<Apttus_Config2__ConstraintRuleActionExpression__c> ruleActionExpressionSOs) {

    }
}
global class ConstraintRuleDO {
    global List<Apttus_Config2.CPQAdminStruct2.ConstraintRuleActionDO> ConstraintRuleActionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRuleCondition__c> ConstraintRuleConditionSOs {
        get;
        set;
    }
    global Apttus_Config2__ConstraintRule__c ConstraintRuleSO {
        get;
        set;
    }
    global ConstraintRuleDO() {

    }
    global ConstraintRuleDO(Apttus_Config2__ConstraintRule__c constraintRuleSO) {

    }
    global ConstraintRuleDO(Apttus_Config2__ConstraintRule__c constraintRuleSO, List<Apttus_Config2__ConstraintRuleCondition__c> ruleConditionSOs, List<Apttus_Config2.CPQAdminStruct2.ConstraintRuleActionDO> ruleActionSOs) {

    }
}
global class FeatureSetDO {
    global Apttus_Config2__FeatureSet__c FeatureSetSO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductFeatureValue__c> ProductFeatureValueSOs {
        get;
        set;
    }
    global FeatureSetDO() {

    }
}
global class FieldDO {
    global String FieldLabel {
        get;
        set;
    }
    global String FieldName {
        get;
        set;
    }
    global Boolean IsEditable {
        get;
        set;
    }
    global Boolean IsRequired {
        get;
        set;
    }
    global Boolean IsRichText {
        get;
        set;
    }
    global Integer Length {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PicklistValues {
        get;
        set;
    }
    global Integer Precision {
        get;
        set;
    }
    global String ReferenceTo {
        get;
        set;
    }
    global String RelationshipFieldName {
        get;
        set;
    }
    global Integer Scale {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global FieldDO() {

    }
    global FieldDO(Schema.FieldSetMember fieldSetMember) {

    }
    global FieldDO(String fieldName, String fieldLabel, String type, String value, Boolean isRequired, Boolean isEditable, Boolean isRichText, List<Schema.PicklistEntry> picklistValues) {

    }
    global FieldDO(String fieldName, String fieldLabel, String type, String value, Boolean isRequired, Boolean isEditable, Boolean isRichText, List<Schema.PicklistEntry> picklistValues, String relationshipName) {

    }
}
global class FootnoteDO {
    global Apttus_Config2__Footnote__c FootnoteSO {
        get;
        set;
    }
    global Id ProductFootnoteId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Integer SequenceNumber {
        get;
        set;
    }
    global FootnoteDO() {

    }
}
global class GenericRuleDO implements System.Comparable {
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String RuleType {
        get;
        set;
    }
    global GenericRuleDO() {

    }
    global GenericRuleDO(Id ruleId, String name, String ruleType) {

    }
    global Integer compareTo(Object genericRuleObj) {
        return null;
    }
}
global class GetAttributeRequestDO {
    global Id AttributeGroupId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global GetAttributeRequestDO() {

    }
    global GetAttributeRequestDO(Id pagId, Integer attributesPerChunk, Integer chunkNumber) {

    }
}
global class GetAttributeResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.AttributeDO> AttributeDOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetAttributeResponseDO() {

    }
    global GetAttributeResponseDO(List<Apttus_Config2.CPQAdminStruct2.AttributeDO> attributeDOs, Integer attributesPerChunk) {

    }
}
global class GetAttributeValueMatrixRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetAttributeValueMatrixRequestDO() {

    }
    global GetAttributeValueMatrixRequestDO(Integer chunkNumber, Integer numOfRecordsPerChunk, Id productId, String searchString) {

    }
}
global class GetAttributeValueMatrixResponseDO {
    global List<Apttus_Config2__AttributeValueMatrix__c> AttributeValueMatrixSOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetAttributeValueMatrixResponseDO() {

    }
    global GetAttributeValueMatrixResponseDO(List<Apttus_Config2__AttributeValueMatrix__c> avmSOs, Integer numOfRecords) {

    }
}
global class GetCategoryRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean HasZeroProductCount {
        get;
        set;
    }
    global Boolean IsCategoryHierarchyRetrieval {
        get;
        set;
    }
    global Integer NumberOfCategoriesPerChunk {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global String SortDirection {
        get;
        set;
    }
    global String SortField {
        get;
        set;
    }
    global GetCategoryRequestDO() {

    }
    global GetCategoryRequestDO(Integer chunkNumber, Integer numberOfCategoriesPerChunk, String searchString) {

    }
    global GetCategoryRequestDO(Integer chunkNumber, Integer numberOfCategoriesPerChunk, String searchString, Id priceListId) {

    }
}
global class GetCategoryResponseDO {
    global List<Apttus_Config2__ClassificationHierarchy__c> CategoryHierarchySOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> CategoryNodeDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ClassificationName__c> CategorySOs {
        get;
        set;
    }
    global Integer NumberOfCategoriesInChunk {
        get;
        set;
    }
    global GetCategoryResponseDO() {

    }
    global GetCategoryResponseDO(List<Apttus_Config2__ClassificationName__c> categorySOs, Integer numberOfCategoriesInChunk) {

    }
    global GetCategoryResponseDO(Integer numberOfCategoriesInChunk, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> categoryNodeDOs) {

    }
}
global class GetConstraintRuleRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfConstraintRulesPerChunk {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetConstraintRuleRequestDO() {

    }
    global GetConstraintRuleRequestDO(Integer chunkNumber, Integer numberOfConstraintRulesPerChunk, List<Id> productIds, String searchString) {

    }
}
global class GetConstraintRuleResponseDO {
    global List<Apttus_Config2__ConstraintRuleCondition__c> ConstraintRules {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRule__c> ConstraintRuleSOs {
        get;
        set;
    }
    global Integer NumberOfConstraintRulesInChunk {
        get;
        set;
    }
    global GetConstraintRuleResponseDO() {

    }
    global GetConstraintRuleResponseDO(List<Apttus_Config2__ConstraintRule__c> constraintRules, Integer numberOfRulesInChunk) {

    }
    global GetConstraintRuleResponseDO(Integer numberOfConstraintRulesInChunk, List<Apttus_Config2__ConstraintRuleCondition__c> constraintRules) {

    }
}
global class GetGenericRulesRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetGenericRulesRequestDO() {

    }
    global GetGenericRulesRequestDO(Integer chunkNumber, Integer numOfRecordsPerChunk, Id productId, String searchString) {

    }
}
global class GetGenericRulesResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.GenericRuleDO> GenericRuleDOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetGenericRulesResponseDO() {

    }
    global GetGenericRulesResponseDO(List<Apttus_Config2.CPQAdminStruct2.GenericRuleDO> ruleDOs, Integer numOfRecsInChunk) {

    }
}
global class GetGenericSObjectRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global String SObjectName {
        get;
        set;
    }
    global String SortDirection {
        get;
        set;
    }
    global String SortField {
        get;
        set;
    }
    global GetGenericSObjectRequestDO() {

    }
}
global class GetGenericSObjectResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global String SObjectRecordsJsonString {
        get;
        set;
    }
    global GetGenericSObjectResponseDO(String sObjRecsStr, Integer numOfRecords) {

    }
}
global class GetOptionGroupRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean HasZeroProductCount {
        get;
        set;
    }
    global Integer NumberOfOptionGroupsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetOptionGroupRequestDO() {

    }
    global GetOptionGroupRequestDO(Integer chunkNumber, Integer numberOfOptionGroupsPerChunk, String searchString) {

    }
}
global class GetOptionGroupResponseDO {
    global Integer NumberOfOptionGroupsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> OptionGroupDOs {
        get;
        set;
    }
    global GetOptionGroupResponseDO() {

    }
    global GetOptionGroupResponseDO(Integer numberOfOptionGroupsInChunk, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> optionGroupDOs) {

    }
}
global class GetPriceDimensionRequestDO {
    global String SearchString {
        get;
        set;
    }
    global GetPriceDimensionRequestDO() {

    }
    global GetPriceDimensionRequestDO(String searchString) {

    }
}
global class GetPriceDimensionResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceDimensionDO> PriceDimensionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceDimension__c> PriceDimensionSOs {
        get;
        set;
    }
    global GetPriceDimensionResponseDO() {

    }
    global GetPriceDimensionResponseDO(List<Apttus_Config2__PriceDimension__c> priceDimensionSOs, Integer numOfRecords) {

    }
}
global class GetPriceListItemRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetPriceListItemRequestDO() {

    }
    global GetPriceListItemRequestDO(Id priceListId, Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
}
global class GetPriceListItemResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceListItemDO> PriceListItemDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceListItem__c> PriceListItemSOs {
        get;
        set;
    }
    global GetPriceListItemResponseDO() {

    }
    global GetPriceListItemResponseDO(Integer numberOfRecordsInChunk, List<Apttus_Config2__PriceListItem__c> priceListItemSOs) {

    }
}
global class GetPriceListRequestDO {
    global Id CategoryId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetPriceListRequestDO() {

    }
    global GetPriceListRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
    global GetPriceListRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString, Id categoryId) {

    }
}
global class GetPriceListResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceListDO> PriceListDOs {
        get;
        set;
    }
    global GetPriceListResponseDO() {

    }
    global GetPriceListResponseDO(List<Apttus_Config2.CPQAdminStruct2.PriceListDO> priceListDOs, Integer numberOfRecordsInChunk) {

    }
}
global class GetPriceMatrixRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfEntriesPerChunk {
        get;
        set;
    }
    global Id PriceMatrixId {
        get;
        set;
    }
    global GetPriceMatrixRequestDO() {

    }
}
global class GetPriceMatrixResponseDO {
    global Integer NumberOfEntriesInChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.PriceMatrixDO PriceMatrixDO {
        get;
        set;
    }
    global GetPriceMatrixResponseDO() {

    }
    global GetPriceMatrixResponseDO(Apttus_Config2.CPQAdminStruct2.PriceMatrixDO priceMatrixDO, Integer numberOfEntriesInChunk) {

    }
}
global class GetProductAttributeRuleRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfAttributeRulesPerChunk {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetProductAttributeRuleRequestDO() {

    }
    global GetProductAttributeRuleRequestDO(Integer chunkNumber, Integer numberOfAttributeRulesPerChunk, List<Id> productIds, String searchString) {

    }
}
global class GetProductAttributeRuleResponseDO {
    global List<Apttus_Config2__ProductAttributeRule__c> AttributeRuleSOs {
        get;
        set;
    }
    global Integer NumberOfAttributeRulesInChunk {
        get;
        set;
    }
    global GetProductAttributeRuleResponseDO() {

    }
    global GetProductAttributeRuleResponseDO(Integer numberOfAttributeRulesInChunk, List<Apttus_Config2__ProductAttributeRule__c> attributeRuleSOs) {

    }
}
global class GetProductGroupRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductGroupId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetProductGroupRequestDO() {

    }
    global GetProductGroupRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
}
global class GetProductGroupResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductGroupDO> ProductGroupDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroupMember__c> ProductGroupMemberSOs {
        get;
        set;
    }
    global GetProductGroupResponseDO() {

    }
    global GetProductGroupResponseDO(List<Apttus_Config2.CPQAdminStruct2.ProductGroupDO> productGroupDOs, Integer numberOfRecordsInChunk) {

    }
}
global class GetProductRequestDO {
    global Id CategoryId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global String ConfigType {
        get;
        set;
    }
    global List<String> ConfigTypes {
        get;
        set;
    }
    global Integer NumberOfProductsPerChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.SearchRowDO> SearchRowDOs {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global String SortDirection {
        get;
        set;
    }
    global String SortField {
        get;
        set;
    }
    global String ViewName {
        get;
        set;
    }
    global GetProductRequestDO() {

    }
    global GetProductRequestDO(Integer chunkNumber, Integer numberOfProductsPerChunk, String viewName, String searchString, String configType, String sortField, String sortDirection) {

    }
    global GetProductRequestDO(Integer chunkNumber, Integer numberOfProductsPerChunk, String viewName, String searchString, String configType, String sortField, String sortDirection, List<String> configTypes) {

    }
}
global class GetProductResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> DisplayColumns {
        get;
        set;
    }
    global Integer NumberOfProductsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2__ProductClassification__c> ProductClassificationSOs {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global GetProductResponseDO() {

    }
    global GetProductResponseDO(Integer numberOfProductsInChunk, List<Product2> products, List<Apttus_Config2.CPQAdminStruct2.FieldDO> displayColumns) {

    }
}
global class HierarchyDO2 {
    global Id ChildOptionGroupId {
        get;
        set;
    }
    global Id ChildProductId {
        get;
        set;
    }
    global Id ParentOptionGroupId {
        get;
        set;
    }
    global Id ParentProductId {
        get;
        set;
    }
    global HierarchyDO2() {

    }
    global HierarchyDO2(Id parentProductId, Id childProductId, Id parentOptionGroupId, Id childOptionGroupId) {

    }
}
global class HierarchyRequestDO2 {
    global List<Apttus_Config2.CPQAdminStruct2.HierarchyDO2> HierarchyDOs {
        get;
        set;
    }
    global Id OptionGroupId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global HierarchyRequestDO2() {

    }
}
global class PriceDimensionDO {
    global Apttus_Config2.CPQAdminStruct2.FieldDO FieldDO {
        get;
        set;
    }
    global Apttus_Config2__PriceDimension__c PriceDimensionSO {
        get;
        set;
    }
    global PriceDimensionDO() {

    }
}
global class PriceListDO {
    global Id PriceListId {
        get;
        set;
    }
    global Integer PriceListItemCount {
        get;
        set;
    }
    global List<Apttus_Config2__PriceListItem__c> PriceListItemSOs {
        get;
        set;
    }
    global Apttus_Config2__PriceList__c PriceListSO {
        get;
        set;
    }
    global PriceListDO() {

    }
    global PriceListDO(Apttus_Config2__PriceList__c priceListSO) {

    }
    global PriceListDO(Apttus_Config2__PriceList__c priceList, List<Apttus_Config2__PriceListItem__c> priceListItems) {

    }
}
global class PriceListItemDO {
    global Apttus_Config2__PriceListItem__c PriceListItemSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceMatrixDO> PriceMatrixDOs {
        get;
        set;
    }
    global List<Apttus_Config2__RelatedPriceListItem__c> RelatedPriceListItemSOs {
        get;
        set;
    }
    global PriceListItemDO() {

    }
    global PriceListItemDO(Apttus_Config2__PriceListItem__c pliSO) {

    }
}
global class PriceMatrixDO {
    global List<Apttus_Config2.CPQAdminStruct2.PriceDimensionDO> PriceDimensionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceMatrixEntry__c> PriceMatrixEntrySOs {
        get;
        set;
    }
    global Apttus_Config2__PriceMatrix__c PriceMatrixSO {
        get;
        set;
    }
    global PriceMatrixDO() {

    }
    global PriceMatrixDO(Apttus_Config2__PriceMatrix__c priceMatrixSO) {

    }
}
global class PricingDO {
    global List<Id> PriceListIds {
        get;
        set;
    }
    global List<Id> PriceListItemIds {
        get;
        set;
    }
    global List<Id> PriceMatrixEntryIds {
        get;
        set;
    }
    global List<Id> PriceMatrixIds {
        get;
        set;
    }
    global List<Id> ProductOptionPriceIds {
        get;
        set;
    }
    global List<Id> RelatedPriceListItemIds {
        get;
        set;
    }
    global PricingDO() {

    }
}
global class PricingMetadataDO {
    global List<Schema.PicklistEntry> ChargeTypes {
        get;
        set;
    }
    global List<Schema.PicklistEntry> Frequency {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceMethods {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceTypes {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceUoms {
        get;
        set;
    }
    global PricingMetadataDO() {

    }
    global PricingMetadataDO(List<Schema.PicklistEntry> chargeTypes, List<Schema.PicklistEntry> priceUoms, List<Schema.PicklistEntry> priceTypes, List<Schema.PicklistEntry> priceMethods, List<Schema.PicklistEntry> frequency) {

    }
}
global class ProductAttributeRuleDO {
    global List<Apttus_Config2__ProductAttributeRuleAction__c> ProductAttributeRuleActionSOs {
        get;
        set;
    }
    global Apttus_Config2__ProductAttributeRule__c ProductAttributeRuleSO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroup__c> ProductGroupSOsInScope {
        get;
        set;
    }
    global List<Product2> ProductSOsInScope {
        get;
        set;
    }
    global ProductAttributeRuleDO() {

    }
    global ProductAttributeRuleDO(Apttus_Config2__ProductAttributeRule__c attributeRuleSO) {

    }
    global ProductAttributeRuleDO(Apttus_Config2__ProductAttributeRule__c attributeRuleSO, List<Apttus_Config2__ProductAttributeRuleAction__c> attributeRuleActionSOs) {

    }
}
global class ProductCloneDO {
    global Boolean AttributesFlag {
        get;
        set;
    }
    global Boolean CategoriesFlag {
        get;
        set;
    }
    global Boolean CollateralFlag {
        get;
        set;
    }
    global Boolean DetailsFlag {
        get;
        set;
    }
    global String FieldSetName {
        get;
        set;
    }
    global Boolean OptionsFlag {
        get;
        set;
    }
    global Boolean PricingFlag {
        get;
        set;
    }
    global Boolean ProductGroupsFlag {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String ProductName {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> RequiredUniqueFields {
        get;
        set;
    }
    global String SObjectName {
        get;
        set;
    }
    global ProductCloneDO() {

    }
    global ProductCloneDO(Id productId, String productName, Boolean detailsFlag, Boolean categoriesFlag, Boolean attributesFlag, Boolean optionsFlag, Boolean pricingFlag, Boolean collateralFlag) {

    }
}
global class ProductDO2 {
    global Id CategoryId {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global Integer Sequence {
        get;
        set;
    }
    global ProductDO2() {

    }
    global ProductDO2(Product2 productSO, Id categoryId) {

    }
}
global class ProductGroupDO {
    global List<Apttus_Config2__AttributeValueMatrix__c> AttributeValueMatrixSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRule__c> ConstraintRuleSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttributeRule__c> ProductAttributeRuleSOs {
        get;
        set;
    }
    global Id ProductGroupId {
        get;
        set;
    }
    global List<Id> ProductGroupMemberIds {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroupMember__c> ProductGroupMemberSOs {
        get;
        set;
    }
    global Apttus_Config2__ProductGroup__c ProductGroupSO {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global ProductGroupDO() {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO) {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO, List<Id> productIds) {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO, List<Product2> productSOs) {

    }
}
global class ProductInformationDO {
    global String FileName {
        get;
        set;
    }
    global Apttus_Config2__ProductInformation__c ProductInformationSO {
        get;
        set;
    }
    global ProductInformationDO() {

    }
    global ProductInformationDO(Apttus_Config2__ProductInformation__c productInformationSO, String fileName) {

    }
}
global class ProductOptionComponentDO {
    global Apttus_Config2__FieldExpression__c DefaultQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MaxQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MinQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionComponent__c ProductOptionComponentSO {
        get;
        set;
    }
    global ProductOptionComponentDO() {

    }
    global ProductOptionComponentDO(Apttus_Config2__ProductOptionComponent__c pocSO) {

    }
}
global class ProductOptionGroupDO {
    global List<Apttus_Config2.CPQAdminStruct2.ProductOptionGroupDO> ChildOptionGroupDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductOptionGroup__c> ChildProductOptionGroupSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductOptionComponent__c> ComponentSOs {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MaxTotalQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MinTotalQuantityExpressionSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductOptionComponentDO> ProductOptionComponentDOs {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionGroup__c ProductOptionGroupSO {
        get;
        set;
    }
    global ProductOptionGroupDO() {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c pogSO) {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c productOptionGroupSO, List<Apttus_Config2__ProductOptionComponent__c> components) {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c productOptionGroupSO, List<Apttus_Config2__ProductOptionComponent__c> components, List<Apttus_Config2.CPQAdminStruct2.ProductOptionGroupDO> childOptionGroupDOs) {

    }
}
global class ProductOptionPriceDO {
    global String OptionGroupName {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global Apttus_Config2__PriceListItem__c PriceListItemSO {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionPrice__c ProductOptionPriceSO {
        get;
        set;
    }
    global ProductOptionPriceDO() {

    }
    global ProductOptionPriceDO(Apttus_Config2__ProductOptionPrice__c productOptionPriceSO) {

    }
    global ProductOptionPriceDO(Apttus_Config2__ProductOptionPrice__c optionPriceSO, Apttus_Config2__PriceListItem__c pliSO, String optionGroupName) {

    }
}
global class ProductRecordDetailsDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> DisplayFields {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> ProductFields {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global ProductRecordDetailsDO() {

    }
    global ProductRecordDetailsDO(List<Apttus_Config2.CPQAdminStruct2.FieldDO> productFields, List<Apttus_Config2.CPQAdminStruct2.FieldDO> displayFields) {

    }
}
global class ProductRequestDO2 {
    global List<Apttus_Config2__ProductClassification__c> ProductClassificationSOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductDO2> ProductDOs {
        get;
        set;
    }
    global ProductRequestDO2() {

    }
}
global class SavedSearchDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.GetProductRequestDO ProductsRequestDO {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.GetProductResponseDO ProductsResponseDO {
        get;
        set;
    }
    global Id SavedSearchId {
        get;
        set;
    }
    global List<Id> SavedSearchIds {
        get;
        set;
    }
    global List<Apttus_Config2__SavedSearch__c> SavedSearchSOs {
        get;
        set;
    }
    global String SearchContext {
        get;
        set;
    }
    global SavedSearchDO() {

    }
    global SavedSearchDO(List<Apttus_Config2__SavedSearch__c> savedSearchSOs) {

    }
    global SavedSearchDO(List<Apttus_Config2__SavedSearch__c> savedSearchSOs, Integer numOfRecsInChunk) {

    }
}
global class SearchRowDO {
    global String field {
        get;
        set;
    }
    global String function {
        get;
        set;
    }
    global String operator {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global SearchRowDO(String field, String function, String value, String operator) {

    }
}
global class sObjectTreeView {
    global String apiDisplayName;
    global String apiName;
    global List<Apttus_Config2.CPQAdminStruct2.sObjectTreeView> fields;
    global String fieldType;
    global Boolean isRef;
    global String label;
    global String refSObjectName;
    global String sObjectName;
    global sObjectTreeView() {

    }
}
}
