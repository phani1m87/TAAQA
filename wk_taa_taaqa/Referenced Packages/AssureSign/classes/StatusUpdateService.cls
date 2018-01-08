/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class StatusUpdateService {
    global StatusUpdateService() {

    }
    webService static AS.StatusUpdateService.StatusUpdateResult updateStatus(AS.StatusUpdateService.StatusUpdate statusUpdate) {
        return null;
    }
global class StatusUpdate {
    @WebService
    webService String authToken;
    @WebService
    webService Blob documentData;
    @WebService
    webService String documentId;
    @WebService
    webService String documentStatus;
    global StatusUpdate() {

    }
}
global class StatusUpdateResult {
    @WebService
    webService List<String> errors;
    @WebService
    webService Boolean success;
    global StatusUpdateResult() {

    }
}
}
