/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocumentNow_Wcf_V1 {
    global DocumentNow_Wcf_V1() {

    }
global class ArrayOfDocumentExceptions {
    global List<String> DocumentException;
    global ArrayOfDocumentExceptions() {

    }
}
global class ArrayOfFileRetrievalDocument {
    global List<AS.DocumentNow_Wcf_V1.FileRetrievalDocument> FileRetrievalDocument;
    global ArrayOfFileRetrievalDocument() {

    }
}
global class ArrayOfParameter {
    global List<AS.DocumentNow_Wcf_V1.Parameter> Parameter;
    global ArrayOfParameter() {

    }
}
global class AsyncSubmissionResult {
    global AS.DocumentNow_Wcf_V1.ArrayOfDocumentExceptions Exceptions;
    global String SessionId;
    global AsyncSubmissionResult() {

    }
}
global class AsyncSubmitWithFileRetrievalResponse_element {
    global AS.DocumentNow_Wcf_V1.AsyncSubmissionResult AsyncSubmitWithFileRetrievalResult;
    global AsyncSubmitWithFileRetrievalResponse_element() {

    }
}
global class AsyncSubmitWithFileRetrieval_element {
    global AS.DocumentNow_Wcf_V1.ArrayOfFileRetrievalDocument Documents;
    global AsyncSubmitWithFileRetrieval_element() {

    }
}
global class DocumentExceptionItem {
    global String Severity;
    global DocumentExceptionItem() {

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
    global AS.DocumentNow_Wcf_V1.AsyncSubmissionResult AsyncSubmitWithFileRetrieval(AS.DocumentNow_Wcf_V1.ArrayOfFileRetrievalDocument Documents) {
        return null;
    }
}
global class FileRetrievalCredential {
    global String Domain;
    global String Password;
    global String Username;
    global FileRetrievalCredential() {

    }
}
global class FileRetrievalDocument {
    global String ContextIdentifier;
    global AS.DocumentNow_Wcf_V1.Metadata Metadata;
    global AS.DocumentNow_Wcf_V1.Template Template;
    global AS.DocumentNow_Wcf_V1.UnderlyingFileMetadata UnderlyingFileMetadata;
    global FileRetrievalDocument() {

    }
}
global class Metadata {
    global String DocumentName;
    global Date ExpirationDate;
    global String OrderNumber;
    global String Password;
    global String UserName;
    global Metadata() {

    }
}
global class Parameter {
    global String Name;
    global String Value;
    global Parameter() {

    }
}
global class Template {
    global String Id;
    global AS.DocumentNow_Wcf_V1.ArrayOfParameter Parameters;
    global Template() {

    }
}
global class UnderlyingFileMetadata {
    global AS.DocumentNow_Wcf_V1.FileRetrievalCredential Credential;
    global String FileType;
    global Boolean RequiresAuthentication;
    global String RetrievalMethod;
    global String Url;
    global UnderlyingFileMetadata() {

    }
}
}
