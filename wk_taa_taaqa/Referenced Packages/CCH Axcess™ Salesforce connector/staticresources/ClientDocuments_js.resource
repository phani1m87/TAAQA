/* --------- Sales Force Ajax Call ---------------- */
/* ------------------------------------------------ */


/* ---------------- Rest SDK Call ----------------- */
function OnClickRowGetDocumentMetaData(documentGuid)
{
	//alert("OnClickRowGetDocumentMetaData::: " + documentGuid + " ::: " + DocMetadataUpdated);
	if (DocMetadataUpdated == false) {
		restapi_GetDocumentMetadata(
			documentGuid, 
			function (data) {
				//var metadata = $.jsonToHtml(data);
				//alert(data.DocumentName);
				displayDocumentMetadata(data);
			}, 
			function (jqXHR, textStatus, err) {
				displayRestFailedErrorMessage(jqXHR, textStatus, err);
			}
		);
	}
	DocMetadataUpdated = false;
}

function getDocumentMetaData(documentGuid)
{
	//alert("getDocumentMetatData::: " + documentGuid);
	restapi_GetDocumentMetadata(
		documentGuid, 
		function (data) {
			updateGridRow(documentGuid, data);
		}, 
		function (jqXHR, textStatus, err) {
			displayRestFailedErrorMessage(jqXHR, textStatus, err);
		}
	);
}

function OpenDocumentInWindow(documentGuid, FileName)
{
	var docGuid = documentGuid;
	var userIntId = '';
	var url = $.anonymousDocumentService('GetDocumentUrl', docGuid, userIntId, FileName);
	window.open(url, "_self");
}

function DownLoadDocument(documentGuid)
{
	var docGuid = documentGuid;
	// var userIntId = '';

	// var url = $.anonymousDocumentService('GetDocumentUrl', docGuid, userIntId);
	// var iframe = document.createElement("iframe");
	// iframe.src = url
	// iframe.style.display = "none";
	// document.body.appendChild(iframe);
	var request = restapi_DownloadDocument(docGuid, fail);
    function fail(jqXHR, textStatus, err) {
		displayRestFailedErrorMessage(jqXHR, textStatus, err);
    }
}

function CheckOutDocument(documentGuid, FileName)
{
	/*var UserComments = '';
	if(UserComments != null){
		var url = $.documentService('CheckOutDocument', documentGuid, UserComments, null, null);
		var iframe = document.createElement("iframe");
		iframe.src = url
		iframe.style.display = "none";
		document.body.appendChild(iframe);
		//var int=self.setTimeout(function(){ CreateDocumentActivityLog(documentGuid, FileName, "CheckOut"); getSFRecentDocumentList(); getDocumentMetaData(documentGuid); }, 1000);
		CreateDocumentActivityLog(documentGuid, FileName, "CheckOut"); getSFRecentDocumentList(); getDocumentMetaData(documentGuid);
	}
	*/
    function success(data){
		CreateDocumentActivityLog(documentGuid, FileName, "CheckOut"); 
		getSFRecentDocumentList(); 
		getDocumentMetaData(documentGuid);
	}
	function fail(jqXHR, textStatus, err) {
		displayRestFailedErrorMessage(jqXHR, textStatus, err);
    }
	var request = restapi_CheckOutDocument(documentGuid, success, fail);
}

function CancelCheckOutDocument(docGuid, FileName)
{
	restapi_CancelCheckOut(docGuid, success, fail);
	
	function success(data) {
		CreateDocumentActivityLog(docGuid, FileName, "Cancel Checkout");	
		CustomAlertInfo("Document has been canceled Checkedout successfully.", function(){});
		getSFRecentDocumentList();
		getDocumentMetaData(docGuid);
	}

	function fail(jqXHR, textStatus, err) {
		displayRestFailedErrorMessage(jqXHR, textStatus, err);
	}
}

function CheckInDocument(documentGuid, FileName)
{
   $( "#dialogCheckIn" ).dialog({
		autoOpen: true,
		height: 200,
		width: 350,
		modal: true,
		buttons: {
			"CheckIn Document": function() {
				fnCheckInDocument(documentGuid, FileName);
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
}

function fnCheckInDocument(docGuid, FileName) {
	var formToSubmit = $("#frmCheckInCheckout");
	var UserComments = $("#UserComments", formToSubmit).val();
	var KeepCheckout = document.getElementById("KeepCheckout").checked;//$("#KeepCheckout").checked;
	//var filePath = document.getElementById("CheckindocumentFilePath");
	var filePath = $("#CheckindocumentFilePath");
	if (filePath[0].files.length == 0) {
		alert("Please select document to upload.");
		return false;
	}
	if (filePath[0].files[0].size == 0) {
		alert("Zero sized document has been selected, Please select another document.");
		return false;
	}
	restapi_CheckInDocument(docGuid, UserComments, KeepCheckout, filePath, success, fail);

	function success(data, textStatus, jqXHR) {
		$("#dialogCheckIn").dialog( "close" );
		var token = data.DocumentMetadataList[0];
		if (token.UploadStatus == true){
			if(KeepCheckout == false) {
				CreateDocumentActivityLog(docGuid, FileName, "CheckIn");
				CustomAlertInfo("Document has been checked-in successfully", function(){});
				getSFRecentDocumentList();
				getDocumentMetaData(docGuid);
				//updateGridRow(docGuid, token);
			}
			else {
				CustomAlertInfo("Document has been Uploaded successfully.", function(){});
			}
		}
		else
			CustomAlertError(token.ErrorMessage, function(){});
	}

	function fail(jqXHR, textStatus, err) {
		$("#dialogCheckIn").dialog( "close" );
		displayRestFailedErrorMessage(jqXHR, textStatus, err);
	}
};

/* ------------------------------------------------ */


/* ----------------- Not In Use  ------------------ */
function ShowActionLinks( cellvalue, options, rowObject ){
	var btnDownLoad = "", btnCheckOut = "", btnCheckIn = "", btnCancelCheckOut = "";
	btnDownLoad = "<a href=\"javascript:DownLoadDocument('" + rowObject.DocumentGuid + "')\"><image title='Click Download document' src=\"{!URLFOR($Resource.images, 'images/DownloadDocument.png')}\" /></a>";
	if (rowObject.Status == 'O')
	{
		btnCheckIn = "&nbsp;<a href=\"javascript:CheckInDocument('" + rowObject.DocumentGuid + "', '" + rowObject.FileName + "')\"><image title='Click to check-in document' src=\"{!URLFOR($Resource.images, 'images/CheckinDocument.png')}\" /></a>";
		btnCancelCheckOut = "&nbsp;<a href=\"javascript:CancelCheckOutDocument('" + rowObject.DocumentGuid + "', '" + rowObject.FileName + "')\"><image title='Click to cancel check-out document' src=\"{!URLFOR($Resource.images, 'images/CancelcheckoutDocument.png')}\" /></a>";
	}
	else if(rowObject.Status == 'I')
		btnCheckOut = "&nbsp;<a href=\"javascript:CheckOutDocument('" + rowObject.DocumentGuid + "', '" + rowObject.FileName + "')\"><image title='Click to check-out document' src=\"{!URLFOR($Resource.images, 'images/CheckoutDocument.png')}\" /></a>";
	
	return btnDownLoad + btnCheckOut + btnCheckIn + btnCancelCheckOut;
}
/* ------------------------------------------------ */
