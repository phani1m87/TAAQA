var LoggedInUserID = "";
var CheckSFLicense = true;

function RestSdkLogin(successCallback, failCallback){
	getSFUserID();
	var loginInfo = getCCHAxcessLoginInfo();
	//loginInfo.SecurityToken = "";
	if(loginInfo == null) {
		if (failCallback) failCallback(null, 'SF404', "CCH Axcess credentials Not configured. Please go to 'CCH Axcess' tab and configure CCH Axcess credentials"); 
	}
	if (loginInfo.SecurityToken == null || loginInfo.SecurityToken.length == 0) {
		//alert("RestSdlLogin => Call Authenticate API");
		CallRestSdkLoginAPI(loginInfo.user, loginInfo.sid, loginInfo.pass, loginInfo.acc, loginInfo.server, successCallback, failCallback);
	}
	// Bypass calling authentication API. set API URL and Security token to RestPlugin.
	else{
		//alert("RestSdlLogin => Skip Authenticate API");
		$.setAuthenticatedURL(loginInfo.server);
		$.setSecurityToken(loginInfo.SecurityToken);
		if (successCallback) successCallback("Already logged in"); 
	}
}

function CallRestSdkLoginAPI(user, sid, pass, acc, server, successCallback, failCallback) {
	function getPasswordSuccess(Password){
		$.authenticate(user, sid, Password, acc, server, success, fail);
		function success(data, textStatus, jqXHR)
		{
			var errorObject = JSON.parse(jqXHR.responseText);
			if (errorObject.ErrorMessage == null) {
				if(CheckSFLicense == true) {
					// Check SF Connector License
					function licenseSuccess(licData, licTextStatus, licJqXHR) {
						if (licData.ErrorMessage == null && licData == true) {
							if(setSecurityTokenToSFDB($.getSecurityToken())){
								if (successCallback) successCallback(data); 
							}
						}
						else {
							if (failCallback) failCallback(CreateSFJqXHR("SF401", "Salesforce connector license not assigned."), "Salesforce connector license not assigned.", "SF401");
						}
					};
					function licenseFail(licJqXHR, licTextStatus, licErr) {
						if (failCallback) failCallback(licJqXHR, licTextStatus, licErr); 
					}
					restapi_IsSalesForceLicensed(licenseSuccess, licenseFail);
					//
				}
				else{
					if(setSecurityTokenToSFDB($.getSecurityToken())){
						if (successCallback) successCallback(data); 
					}
				}
			}
			else {
				if (failCallback) failCallback(jqXHR, errorObject.StatusMessage, errorObject.StatusCode); 
			}
		};
		function fail(jqXHR, textStatus, err)
		{
			//var error="Login failed. Status: " + textStatus + "error: " + err;
			if (failCallback) failCallback(jqXHR, textStatus, err); 
		};
	}
	var requestPassword = showPasswordPopup(acc, user, getPasswordSuccess);
	// }
}

function showPasswordPopup(acc, user, successCallback) {
	$.msgBox({ type: "prompt",
		title: "Enter your CCH Axcess Credentials",
		inputs: [{ header: "Account number:", type: "text", name: "PassPopup_Accountnumber", value: acc, disabled: true },
				 { header: "User ID:", type: "text", name: "PassPopup_UserID", value: user, disabled: true },
				 { header: "Password:", type: "password", name: "PassPopup_password", isDefaultFocused: true, isRequiredMsg: "Please enter CCH Axcess login password." }],
		buttons: [{ value: "Ok", name: "PassPopup_Submit", isdefault: true }],
		displaylogo: true,
		success: function (result, values) {
			var PasswordFieldID = 0;
			for(var i = 0; i < values.length; i++) {
				if(values[i].name == "PassPopup_password")
					PasswordFieldID = i;
			}
			if(values[PasswordFieldID].value == null || values[PasswordFieldID].value.length == 0){
				alert("Please enter CCH Axcess login password.");
				showPasswordPopup(acc, user, successCallback);
			}
			else{
				if (successCallback) successCallback(values[PasswordFieldID].value); 
			}
		}
	});
}

function getSFUserID(){
	var user = sforce.connection.getUserInfo();
	var username =user.userName;
	var result = sforce.connection.query("SELECT ID from User WHERE User.username='" + username + "'");
	var records = result.getArray("records");
	if (records.length != 1) throw "unable to find user";
	LoggedInUserID = records[0].Id;
}

function getCCHAxcessLoginInfo(){
	var login = sforce.connection.query("Select p.CCHAxcess__UserId__c, p.CCHAxcess__Password__c, p.CreatedById, p.CCHAxcess__Account__c,  p.CCHAxcess__Server__c, CCHAxcess__SecurityToken__c From CCHAxcess__PfxCredentials__c p WHERE p.CreatedById='"+LoggedInUserID+"'");
	var loginrecords = login.getArray("records");
	if (loginrecords .length != 1) return null;

	var loginInfo = new Object();
	
	loginInfo.user = loginrecords[0].CCHAxcess__UserId__c;
	loginInfo.sid = "SID";
	loginInfo.pass = loginrecords[0].CCHAxcess__Password__c;
	loginInfo.acc = loginrecords[0].CCHAxcess__Account__c;
	loginInfo.server = loginrecords[0].CCHAxcess__Server__c;
	loginInfo.SecurityToken = loginrecords[0].CCHAxcess__SecurityToken__c
	return loginInfo;
}

function setSecurityTokenToSFDB(SecurityToken){
	var CreateNewRecords = []; 
	var update_PfxCredential = new sforce.SObject("CCHAxcess__PfxCredentials__c");
	var getresult = sforce.connection.query("SELECT Id, CCHAxcess__SecurityToken__c FROM CCHAxcess__PfxCredentials__c WHERE CreatedById='"+LoggedInUserID+"'");
	if(getresult.size != 0){
		var records = getresult.getArray("records");
		update_PfxCredential.Id = records[0].Id;
		update_PfxCredential.CCHAxcess__SecurityToken__c = SecurityToken;
		CreateNewRecords.push(update_PfxCredential); 
		
		var result = sforce.connection.update(CreateNewRecords);
		if (result[0].success=='false'){
			alert(result[0].errors.message);
			return false;
		}
	}
	else
		return false;
	return true;
}

/* ---------- Rest API calling functions ---------- */
// Authenticate API
function restapi_authenticate(LoginSuccess, LoginFail) {
	var loginInfo = getCCHAxcessLoginInfo();
	CallRestSdkLoginAPI(loginInfo.user, loginInfo.sid, loginInfo.pass, loginInfo.acc, loginInfo.server, LoginSuccess, LoginFail);
}
// Check SF Connector License
function restapi_IsSalesForceLicensed(successCallback, failCallback) {
	var request = $.IsSalesForceLicensed(success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		if (failCallback) failCallback(jqXHR, textStatus, err); 
	}
}

// Get document clients
function restapi_GetDocumentClientSearch(clientId, clientName, officeID, srchType, successCallback, failCallback) {
	var request = $.documentService('GetDocumentClientSearch', clientId, clientName, officeID, srchType, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetDocumentClientSearch(clientId, clientName, officeID, srchType, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Document AdvancedSearch
function restapi_AdvancedSearch(searchParamsList, successCallback, failCallback) {
	var request = $.documentService('AdvancedSearch', searchParamsList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_AdvancedSearch(searchParamsList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// get DocumentMetadata
function restapi_GetDocumentMetadata(documentGuid, successCallback, failCallback) {
	var request = $.documentService('GetDocumentMetadata', documentGuid, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetDocumentMetadata(documentGuid, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Download Document
function restapi_DownloadDocument(docGuid, failCallback) {
	var request = $.anonymousDocumentService('DownloadDocument', docGuid, "", fail);
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_DownloadDocument(docGuid, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Checkout Document
function restapi_CheckOutDocument(docGuid, successCallback, failCallback) {
	var request = $.documentService('CheckoutDocument', docGuid, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CheckOutDocument(docGuid, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Cancel Checkout
function restapi_CancelCheckOut(docGuid, successCallback, failCallback) {
	var request = $.documentService('CancelCheckOut', docGuid, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CancelCheckOut(docGuid, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Checkin document
function restapi_CheckInDocument(docGuid, UserComments, KeepCheckout, filePath, successCallback, failCallback) {
	var request = $.documentService('CheckInDocument', docGuid, UserComments, KeepCheckout, filePath, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CheckInDocument(docGuid, UserComments, KeepCheckout, filePath, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// get document Classes
function restapi_GetClassesByFirm(successCallback, failCallback) {
	var request = $.documentService('GetClassesByFirm', success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetClassesByFirm(successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// get document Years
function restapi_GetYearsByFirm(successCallback, failCallback) {
	var request = $.documentService('GetYearsByFirm', success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetYearsByFirm(successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// get document Types
function restapi_GetDocumentTypes(successCallback, failCallback) {
	var request = $.documentService('GetDocumentTypes', success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetDocumentTypes(successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Upload document Metadata
function restapi_UploadDocumentMetadata(MetaDataDataContract, filePath, successCallback, failCallback) {
	var request = $.documentService('UploadDocumentMetadata', MetaDataDataContract, filePath, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UploadDocumentMetadata(MetaDataDataContract, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// GetClients
function restapi_GetClients(exportRequest, successCallback, failCallback) {
	var request = $.client('GetClients', exportRequest, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetClients(exportRequest, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Get Client Details
function restapi_GetClientDetails(ClientId, ClientSubId, successCallback, failCallback) {
	var request = $.client('GetClientDetails', ClientId, ClientSubId, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_GetClientDetails(ClientId, ClientSubId, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create Corporation client
function restapi_CreateMultipleClientCorporation(ClientCorporationList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientCorporation', ClientCorporationList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientCorporation(ClientCorporationList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update Corporation client
function restapi_UpdateMultipleClientCorporation(ClientCorporationList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientCorporation', ClientCorporationList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientCorporation(ClientCorporationList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create EmployeePlan client
function restapi_CreateMultipleClientEmployeePlan(ClientEmployeePlanList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientEmployeePlan', ClientEmployeePlanList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientEmployeePlan(ClientEmployeePlanList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update EmployeePlan client
function restapi_UpdateMultipleClientEmployeePlan(ClientEmployeePlanList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientEmployeePlan', ClientEmployeePlanList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientEmployeePlan(ClientEmployeePlanList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create Fiduciary client
function restapi_CreateMultipleClientFiduciary(ClientFiduciaryList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientFiduciary', ClientFiduciaryList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientFiduciary(ClientFiduciaryList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update Fiduciary client
function restapi_UpdateMultipleClientFiduciary(ClientFiduciaryList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientFiduciary', ClientFiduciaryList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientFiduciary(ClientFiduciaryList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create Individual client
function restapi_CreateMultipleClientIndividual(ClientIndividualList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientIndividual', ClientIndividualList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientIndividual(ClientIndividualList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update Individual client
function restapi_UpdateMultipleClientIndividual(ClientIndividualList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientIndividual', ClientIndividualList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientIndividual(ClientIndividualList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create NonProfit client
function restapi_CreateMultipleClientNonProfit(ClientNonProfitList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientNonProfit', ClientNonProfitList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientNonProfit(ClientNonProfitList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update NonProfit client
function restapi_UpdateMultipleClientNonProfit(ClientNonProfitList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientNonProfit', ClientNonProfitList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientNonProfit(ClientNonProfitList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create Partnership client
function restapi_CreateMultipleClientPartnership(ClientPartnershipList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientPartnership', ClientPartnershipList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientPartnership(ClientPartnershipList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update Partnership client
function restapi_UpdateMultipleClientPartnership(ClientPartnershipList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientPartnership', ClientPartnershipList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientPartnership(ClientPartnershipList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Create SoleProprietorship client
function restapi_CreateMultipleClientSoleProprietorship(ClientSoleProprietorshipList, successCallback, failCallback) {
	var request = $.client('CreateMultipleClientSoleProprietorship', ClientSoleProprietorshipList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_CreateMultipleClientSoleProprietorship(ClientSoleProprietorshipList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update SoleProprietorship client
function restapi_UpdateMultipleClientSoleProprietorship(ClientSoleProprietorshipList, successCallback, failCallback) {
	var request = $.client('UpdateMultipleClientSoleProprietorship', ClientSoleProprietorshipList, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateMultipleClientSoleProprietorship(ClientSoleProprietorshipList, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}

// Update client Address
function restapi_UpdateClientAddress(clientid, ClientSubordinateId, addr, successCallback, failCallback) {
	var request = $.client('UpdateClientAddress', clientid, ClientSubordinateId, addr, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateClientAddress(clientid, ClientSubordinateId, addr, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update client Phone
function restapi_UpdateClientPhone(clientid, ClientSubordinateId, phone, successCallback, failCallback) {
	var request = $.client('UpdateClientPhone', clientid, ClientSubordinateId, phone, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateClientPhone(clientid, ClientSubordinateId, phone, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
// Update client Email
function restapi_UpdateClientEmail(clientid, ClientSubordinateId, email, successCallback, failCallback) {
	var request = $.client('UpdateClientEmail', clientid, ClientSubordinateId, email, success, fail);
	function success(data) {
		if (successCallback) successCallback(data); 
	}
	function fail(jqXHR, textStatus, err) {
		var errorObject = JSON.parse(jqXHR.responseText);
		if(errorObject.ErrorMessage.indexOf("Session already expired") != -1) {
			function LoginSuccess(data) {
				restapi_UpdateClientEmail(clientid, ClientSubordinateId, email, successCallback, failCallback);
			};
			function LoginFail(jqXHR, textStatus, err) {
				if (failCallback) failCallback(jqXHR, textStatus, err); 
			};
			restapi_authenticate(LoginSuccess, LoginFail);
		}
		else
			if (failCallback) failCallback(jqXHR, textStatus, err);
	}
}
/* ------------------------------------------------ */


/* ----------------Common Functions --------------- */
function fetchMessageFromSdkResult(data) {
	var msg = '';
	if(data.Message != null && data.Message.length > 0)
		msg = data.Message + "\n";
	if(data.ErrorReport != null && data.ErrorReport.Details != null && data.ErrorReport.Details[0] != null)
		msg = msg + "ErrorMessage: " + data.ErrorReport.Details[0].Messages[0].ErrorDescription;
	return msg;
}

function getDateFromJson(jsonDate) {
	var date = new Date(jsonDate.match(/\d+/)[0] * 1);
	return date.format("mmmm d, yyyy");
}

function getDateFromSFFormat(SFDate) {
	var year = parseInt(SFDate.substring(0, 4));
	var month = parseInt(SFDate.substring(5, 7)) - 1;
	var day = parseInt(SFDate.substring(8, 10));
	var date = new Date(year, month, day);
	return date.format("mmmm d, yyyy");
}

function endsWith(str, suffix) {
	return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function getImageIconName(ImageName, Status) {
	var image = 'document_icon.png';
	if (endsWith(ImageName,'.txt') || endsWith(ImageName,'.text'))
		image = 'txt_icon.png';
	else if (endsWith(ImageName,'.doc'))
		image = 'doc_icon.png';
	else if (endsWith(ImageName,'.docx'))
		image = 'docx_icon.png';
	else if (endsWith(ImageName,'.ppt'))
		image = 'ppt_icon.png';
	else if (endsWith(ImageName,'.pptx'))
		image = 'pptx_icon.png';
	else if (endsWith(ImageName,'.xls') || endsWith(ImageName,'.xlsx'))
		image = 'xls_icon.png';
	else if (endsWith(ImageName,'.pdf'))
		image = 'pdf_icon.png';
	else if (endsWith(ImageName,'.rar') || endsWith(ImageName,'.zip'))
		image = 'rar_icon.png';
	else if (endsWith(ImageName,'.jpeg') || endsWith(ImageName,'.jpg'))
		image = 'jpeg_icon.png';
	
	if (Status == 'O')
		image = image.replace('_icon', '_icon_checkout');
		
	return image;
}
function CreateSFJqXHR(ErrorId, ErrorMessage) {
	var jqXHR = new Object();
	jqXHR.responseText = '{"ErrorId":"' + ErrorId + '","ErrorMessage":"' + ErrorMessage + '","CorrelationId":"00000000-0000-0000-0000-000000000000","StatusCode":"' + ErrorId + '","StatusMessage":"' + ErrorMessage + '"}';
	jqXHR.statusText = ErrorMessage;
	jqXHR.Status = ErrorId;
	return jqXHR;
}

/* ------------------------------------------------ */

/* ---------------- Alert Boxes ------------------- */

function CustomAlertInfo(msg, successCallback){
	$.msgBox({ 
		type: "info",
		title: "CCH Axcess",
		content: msg,
		buttons: [{ value: "Ok", name: "AlertInfo_Ok", isDefaultFocused: true }],
		success: function (result, values) { if (successCallback) successCallback(); }
	});
}
function CustomAlertError(msg, successCallback){
	$.msgBox({ 
		type: "error",
		title: "CCH Axcess",
		content: msg,
		buttons: [{ value: "Ok", name: "AlertError_Ok", isDefaultFocused: true }],
		success: function (result, values) { if (successCallback) successCallback(); }
	});
}

function displayRestFailedErrorMessage(jqXHR, textStatus, err) {
    displayRestFailedErrorMessageWithCallback(jqXHR, textStatus, err, function(){});
};
function displayRestFailedErrorMessageWithCallback(jqXHR, textStatus, err, successCallback) {
    var respText = jqXHR.responseText;
    if (respText != null) {
        var firstChar = respText.substring(0, 1)
        if (firstChar == "{") {
            var errorObject = jQuery.parseJSON(jqXHR.responseText);
            CustomAlertError(errorObject.ErrorMessage + "<br>HTTP Status : " + errorObject.StatusCode + " : " + errorObject.StatusMessage, successCallback);
        }
        else {
            var searchTextStop = "See server logs for more details";
            var searchTextStart = "The server encountered an error";
            var actualErrStr = extractExceptionMessage(respText, searchTextStart, searchTextStop);
            if (actualErrStr == "") {
                actualErrStr = respText;
            }
            CustomAlertError(actualErrStr + "<br>HTTP Status : " + jqXHR.status + " : " + jqXHR.statusText + " " + textStatus + " " + err, successCallback);
        }
    }
    else {
        CustomAlertError("Unknown Error - HTTP Status : " + jqXHR.status + " : " + jqXHR.statusText + " " + textStatus + " " + err, successCallback);
    }
};
function extractExceptionMessage(respText, searchTextStart, searchTextStop) {
    var actualErrStr = "";
    if (respText != null) {
        var indexStart = respText.indexOf(searchTextStart);
        if (indexStart != -1) {
            var indexStop = respText.indexOf(searchTextStop, indexStart + 1);
            if (indexStop != -1) {
                actualErrStr = respText.substring(indexStart, indexStop)
            }
        }
    }
    return actualErrStr;
};
/* ------------------------------------------------ */

