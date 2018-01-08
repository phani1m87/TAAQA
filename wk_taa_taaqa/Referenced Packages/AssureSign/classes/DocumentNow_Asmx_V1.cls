/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocumentNow_Asmx_V1 {
    global DocumentNow_Asmx_V1() {

    }
global class ArrayOfDocument {
    global List<AS.DocumentNow_Asmx_V1.Document> Document;
    global ArrayOfDocument() {

    }
    global ArrayOfDocument(List<AS.DocumentNow_Asmx_V1.Document> document) {

    }
}
global class ArrayOfDocumentEvent {
    global List<AS.DocumentNow_Asmx_V1.DocumentEvent> DocumentEvent;
    global ArrayOfDocumentEvent() {

    }
}
global class ArrayOfDocumentExceptions {
    global List<String> DocumentException;
    global ArrayOfDocumentExceptions() {

    }
}
global class ArrayOfDocumentExpiration {
    global List<AS.DocumentNow_Asmx_V1.DocumentExpiration> DocumentExpiration;
    global ArrayOfDocumentExpiration() {

    }
}
global class ArrayOfDocumentExpirationResult {
    global List<AS.DocumentNow_Asmx_V1.DocumentExpirationResult> DocumentExpirationResult;
    global ArrayOfDocumentExpirationResult() {

    }
}
global class ArrayOfDocumentHistoryView {
    global List<AS.DocumentNow_Asmx_V1.DocumentHistoryView> DocumentHistoryView;
    global ArrayOfDocumentHistoryView() {

    }
}
global class ArrayOfDocumentHistoryViewResult {
    global List<AS.DocumentNow_Asmx_V1.DocumentHistoryViewResult> DocumentHistoryViewResult;
    global ArrayOfDocumentHistoryViewResult() {

    }
}
global class ArrayOfDocumentResult {
    global List<AS.DocumentNow_Asmx_V1.DocumentResult> DocumentResult;
    global ArrayOfDocumentResult() {

    }
}
global class ArrayOfDocumentStatusCheck {
    global List<AS.DocumentNow_Asmx_V1.DocumentStatusCheck> DocumentStatusCheck;
    global ArrayOfDocumentStatusCheck() {

    }
}
global class ArrayOfDocumentStatusCheckResult {
    global List<AS.DocumentNow_Asmx_V1.DocumentStatusCheckResult> DocumentStatusCheckResult;
    global ArrayOfDocumentStatusCheckResult() {

    }
}
global class ArrayOfExpirationExceptions {
    global List<String> ExpirationException;
    global ArrayOfExpirationExceptions() {

    }
}
global class ArrayOfHistoryViewExceptions {
    global List<String> HistoryViewException;
    global ArrayOfHistoryViewExceptions() {

    }
}
global class ArrayOfParameter {
    global List<AS.DocumentNow_Asmx_V1.Parameter> Parameter;
    global ArrayOfParameter() {

    }
    global ArrayOfParameter(List<AS.DocumentNow_Asmx_V1.Parameter> parameter) {

    }
}
global class ArrayOfParameterItemBase {
    global List<AS.DocumentNow_Asmx_V1.TypedParameterItem> TypedParameterItem;
    global List<AS.DocumentNow_Asmx_V1.WrittenParameterItem> WrittenParameterItem;
    global ArrayOfParameterItemBase() {

    }
}
global class ArrayOfParameterListExceptions {
    global List<String> ParameterListException;
    global ArrayOfParameterListExceptions() {

    }
}
global class ArrayOfSessionLookup {
    global List<AS.DocumentNow_Asmx_V1.SessionLookup> SessionLookup;
    global ArrayOfSessionLookup() {

    }
}
global class ArrayOfSessionLookupExceptions {
    global List<String> SessionLookupException;
    global ArrayOfSessionLookupExceptions() {

    }
}
global class ArrayOfSessionLookupResult {
    global List<AS.DocumentNow_Asmx_V1.SessionLookupResult> SessionLookupResult;
    global ArrayOfSessionLookupResult() {

    }
}
global class ArrayOfSignatoryItem {
    global List<AS.DocumentNow_Asmx_V1.SignatoryItem> SignatoryItem;
    global ArrayOfSignatoryItem() {

    }
}
global class ArrayOfSignatoryListExceptions {
    global List<String> SignatoryListException;
    global ArrayOfSignatoryListExceptions() {

    }
}
global class ArrayOfStatusCheckExceptions {
    global List<String> StatusCheckException;
    global ArrayOfStatusCheckExceptions() {

    }
}
global class ArrayOfTemplateItem {
    global List<AS.DocumentNow_Asmx_V1.TemplateItem> TemplateItem;
    global ArrayOfTemplateItem() {

    }
}
global class ArrayOfTemplateListExceptions {
    global List<String> TemplateListException;
    global ArrayOfTemplateListExceptions() {

    }
}
global class AsyncSubmissionResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentExceptions Exceptions;
    global String SessionId;
    global AsyncSubmissionResult() {

    }
}
global class CheckStatusRequest {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentStatusCheck DocumentStatusChecks;
    global CheckStatusRequest() {

    }
}
global class CheckStatusResponse {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentStatusCheckResult DocumentStatusCheckResults;
    global CheckStatusResponse() {

    }
}
global class Document {
    global String ContextIdentifier;
    global AS.DocumentNow_Asmx_V1.Metadata Metadata;
    global AS.DocumentNow_Asmx_V1.Template Template;
    global Document() {

    }
    global Document(AS.DocumentNow_Asmx_V1.Metadata metadata, AS.DocumentNow_Asmx_V1.Template template, String contextIdentifier) {

    }
}
global class DocumentEvent {
    global String Date_x;
    global String Details;
    global DocumentEvent() {

    }
}
global class DocumentExceptions {
    global String Severity;
    global DocumentExceptions() {

    }
}
global class DocumentExpiration {
    global String AuthToken;
    global String ContextIdentifier;
    global String Id;
    global String Remarks;
    global DocumentExpiration() {

    }
}
global class DocumentExpirationResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfExpirationExceptions Exceptions;
    global String Id;
    global DocumentExpirationResult() {

    }
}
global class DocumentHistoryView {
    global String AuthToken;
    global String ContextIdentifier;
    global String Id;
    global DocumentHistoryView() {

    }
}
global class DocumentHistoryViewResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentEvent Events;
    global AS.DocumentNow_Asmx_V1.ArrayOfHistoryViewExceptions Exceptions;
    global String Id;
    global DocumentHistoryViewResult() {

    }
}
global class DocumentNOW {
    global String clientCert_x;
    global String clientCertPasswd_x;
    global String endpoint_x;
    global Map<String,String> inputHttpHeaders_x;
    global Map<String,String> outputHttpHeaders_x;
    global Integer timeout_x;
    global DocumentNOW() {

    }
    global DocumentNOW(Integer timeoutPeriod) {

    }
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentStatusCheckResult CheckStatus(AS.DocumentNow_Asmx_V1.ArrayOfDocumentStatusCheck DocumentStatusChecks) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentExpirationResult Expire(AS.DocumentNow_Asmx_V1.ArrayOfDocumentExpiration DocumentExpirations) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.ParameterListQueryResult ListParameters(AS.DocumentNow_Asmx_V1.ParameterListQuery ParameterListQuery) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.SignatoryListQueryResult ListSignatories(AS.DocumentNow_Asmx_V1.SignatoryListQuery SignatoryListQuery) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.TemplateListQueryResult ListTemplates(AS.DocumentNow_Asmx_V1.TemplateListQuery TemplateListQuery) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.ArrayOfSessionLookupResult LookupSession(AS.DocumentNow_Asmx_V1.ArrayOfSessionLookup SessionLookups) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.AsyncSubmissionResult SubmitAsync(AS.DocumentNow_Asmx_V1.ArrayOfDocument Documents) {
        return null;
    }
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentHistoryViewResult ViewHistory(AS.DocumentNow_Asmx_V1.ArrayOfDocumentHistoryView DocumentHistoryViews) {
        return null;
    }
}
global class DocumentResult {
    global String AuthToken;
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentExceptions Exceptions;
    global String Id;
    global AS.DocumentNow_Asmx_V1.Metadata Metadata;
    global DocumentResult() {

    }
}
global class DocumentStatusCheck {
    global String AuthToken;
    global String ContextIdentifier;
    global String Id;
    global DocumentStatusCheck() {

    }
}
global class DocumentStatusCheckResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfStatusCheckExceptions Exceptions;
    global String Id;
    global Datetime StatusDate;
    global String StatusDetails;
    global String StatusType;
    global DocumentStatusCheckResult() {

    }
}
global class ExpirationExceptions {
    global String Severity;
    global ExpirationExceptions() {

    }
}
global class ExpireRequest {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentExpiration DocumentExpirations;
    global ExpireRequest() {

    }
}
global class ExpireResponse {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentExpirationResult DocumentExpirationResults;
    global ExpireResponse() {

    }
}
global class HistoryViewExceptions {
    global String Severity;
    global HistoryViewExceptions() {

    }
}
global class ListParametersRequest {
    global AS.DocumentNow_Asmx_V1.ParameterListQuery ParameterListQuery;
    global ListParametersRequest() {

    }
}
global class ListParametersResponse {
    global AS.DocumentNow_Asmx_V1.ParameterListQueryResult ParameterListQueryResult;
    global ListParametersResponse() {

    }
}
global class ListSignatoriesRequest {
    global AS.DocumentNow_Asmx_V1.SignatoryListQuery SignatoryListQuery;
    global ListSignatoriesRequest() {

    }
}
global class ListSignatoriesResponse {
    global AS.DocumentNow_Asmx_V1.SignatoryListQueryResult SignatoryListQueryResult;
    global ListSignatoriesResponse() {

    }
}
global class ListTemplatesRequest {
    global AS.DocumentNow_Asmx_V1.TemplateListQuery TemplateListQuery;
    global ListTemplatesRequest() {

    }
}
global class ListTemplatesResponse {
    global AS.DocumentNow_Asmx_V1.TemplateListQueryResult TemplateListQueryResult;
    global ListTemplatesResponse() {

    }
}
global class LookupSessionRequest {
    global AS.DocumentNow_Asmx_V1.ArrayOfSessionLookup SessionLookups;
    global LookupSessionRequest() {

    }
}
global class LookupSessionResponse {
    global AS.DocumentNow_Asmx_V1.ArrayOfSessionLookupResult SessionLookupResults;
    global LookupSessionResponse() {

    }
}
global class Metadata {
    global String DocumentName;
    global String ExpirationDate;
    global String OrderNumber;
    global String Password;
    global String UserName;
    global Metadata() {

    }
    global Metadata(String userName, String documentName, String orderNumber, String password, String expirationDate) {

    }
}
global class Parameter {
    global String Name;
    global String Value;
    global Parameter() {

    }
    global Parameter(String name, String value) {

    }
}
global class ParameterItemBase {
    global String Name;
    global String Prompt;
    global Boolean Required;
    global String Tag;
    global ParameterItemBase() {

    }
}
global class ParameterListExceptions {
    global String Severity;
    global ParameterListExceptions() {

    }
}
global class ParameterListQuery {
    global String ContextIdentifier;
    global String TemplateId;
    global String UserName;
    global ParameterListQuery() {

    }
    global ParameterListQuery(String contextIdentifier, String userName, String templateId) {

    }
}
global class ParameterListQueryResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfParameterListExceptions Exceptions;
    global AS.DocumentNow_Asmx_V1.ArrayOfParameterItemBase Parameters;
    global String TemplateId;
    global ParameterListQueryResult() {

    }
}
global class SessionLookup {
    global String ContextIdentifier;
    global String SessionId;
    global SessionLookup() {

    }
}
global class SessionLookupExceptions {
    global String Severity;
    global SessionLookupExceptions() {

    }
}
global class SessionLookupResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentResult DocumentResults;
    global AS.DocumentNow_Asmx_V1.ArrayOfSessionLookupExceptions Exceptions;
    global String SessionId;
    global SessionLookupResult() {

    }
}
global class SignatoryItem {
    global String EmailAddress;
    global String FirstName;
    global String FullName;
    global String LastName;
    global String SignatoryAuthToken;
    global String SignatoryId;
    global SignatoryItem() {

    }
}
global class SignatoryListExceptions {
    global String Severity;
    global SignatoryListExceptions() {

    }
}
global class SignatoryListQuery {
    global String AuthToken;
    global String ContextIdentifier;
    global String Id;
    global SignatoryListQuery() {

    }
}
global class SignatoryListQueryResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfSignatoryListExceptions Exceptions;
    global String Id;
    global AS.DocumentNow_Asmx_V1.ArrayOfSignatoryItem Signatories;
    global SignatoryListQueryResult() {

    }
}
global class StatusCheckExceptions {
    global String Severity;
    global StatusCheckExceptions() {

    }
}
global class SubmitAsyncResponse {
    global AS.DocumentNow_Asmx_V1.AsyncSubmissionResult AsyncSubmissionResult;
    global SubmitAsyncResponse() {

    }
}
global class SubmitRequest {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocument Documents;
    global SubmitRequest() {

    }
}
global class SubmitResponse {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentResult DocumentResults;
    global SubmitResponse() {

    }
}
global class Template {
    global String Id;
    global AS.DocumentNow_Asmx_V1.ArrayOfParameter Parameters;
    global Template() {

    }
    global Template(AS.DocumentNow_Asmx_V1.ArrayOfParameter parameters, String id) {

    }
}
global class TemplateItem {
    global String Accessibility;
    global Datetime CreationDate;
    global String Description;
    global String Id;
    global Boolean ImmediatePresentment;
    global String Name;
    global String Owner;
    global Boolean PasswordRequired;
    global TemplateItem() {

    }
}
global class TemplateListExceptions {
    global String Severity;
    global TemplateListExceptions() {

    }
}
global class TemplateListQuery {
    global String ContextIdentifier;
    global String UserName;
    global TemplateListQuery() {

    }
    global TemplateListQuery(String contextIdentifier, String userName) {

    }
}
global class TemplateListQueryResult {
    global AS.DocumentNow_Asmx_V1.ArrayOfTemplateListExceptions Exceptions;
    global AS.DocumentNow_Asmx_V1.ArrayOfTemplateItem Templates;
    global TemplateListQueryResult() {

    }
}
global class TypedParameterItem {
    global String DefaultValue;
    global String Name;
    global String Prompt;
    global Boolean Required;
    global String Tag;
    global TypedParameterItem() {

    }
}
global class ViewHistoryRequest {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentHistoryView DocumentHistoryViews;
    global ViewHistoryRequest() {

    }
}
global class ViewHistoryResponse {
    global AS.DocumentNow_Asmx_V1.ArrayOfDocumentHistoryViewResult DocumentHistoryViewResults;
    global ViewHistoryResponse() {

    }
}
global class WrittenParameterItem {
    global String DefaultValue;
    global String Name;
    global String Prompt;
    global Boolean Required;
    global String Tag;
    global WrittenParameterItem() {

    }
}
}
