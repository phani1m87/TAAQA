/**
*  jQuery.CchPfxSdk plugin v0.00
*  
*  Initially created on 03/27/2012
*
*  REST API Proxy for Javascript
*
*
**/


/// <reference path="jquery.iframe-transport.js" />
/// <reference path="toastr.js" />
///// <reference path="jquery-1.8.2-vsdoc.js" />
/// <reference path="jquery-1.8.2.min.js" />


(function ($) {
    /// SDK REST service host url
    var _restHostUrl = "";
    // Place Holder of SDK Integrator Key
    var _restIntegratorKey = "010733AC-A58F-4B87-8FB1-8488C17B95EB";
    if (_restIntegratorKey == "")
        alert('SDK calls will fail, Please update the _restIntegratorKey variable with IntegratorKey in script file jquery.cch.pfx.sdk.rest.js');
    var _ssoToken = '';
    /// Send security token into http request header
    function _setHttpHeader(xhr) {
        var ssoToken = _getSessionCookie("CchNGAuthToken");
        xhr.setRequestHeader("Security", ssoToken);
        xhr.setRequestHeader("IntegratorKey", _restIntegratorKey);
    };

    /// Get session cookie 
    function _getSessionCookie(name) {
        var key = name + "=";
        var cookie = "";

        // No required to set Token in Cookie as for salesforce we are goingto maintain in SF object.
        if (name = "CchNGAuthToken")
            return _ssoToken;

        if (document.cookie.length > 0) {
            var begin = document.cookie.indexOf(key)
            if (begin != -1) {
                begin += key.length
                var end = document.cookie.indexOf(";", begin);
                if (end == -1)
                    end = document.cookie.length;
                cookie = unescape(document.cookie.substring(begin, end));
                //_setTimeExpirationCookie();
            }
        }
        if (cookie.length == 0)
            cookie = _ssoToken;

        return cookie;
    };

    /*function _setTimeExpirationCookie() {
    var now = new Date(); var time = now.getTime();
    var expireTime = time + 900*1000;
    now.setTime(expireTime);
    document.cookie = 'AuthTokenExpiryTime=' + now;
    }*/

    function _setSessionCookie(Token) {
        //document.cookie = 'CchNGAuthToken=' + Token;
        _ssoToken = Token;
    }

    function _getbyte(s, i) {
        var x = s.charCodeAt(i);
        if (x > 255) {
            throw "INVALID_CHARACTER_ERR: DOM Exception 5";
        }

        return x;
    }

    function _base64Encode(s) {
        if (arguments.length !== 1) {
            throw "SyntaxError: exactly one argument required";
        }

        s = String(s);

        var i,
            b10,
            x = [],
            imax = s.length - s.length % 3;

        if (s.length === 0) {
            return s;
        }

        var _PADCHAR = "=";
        var _ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        for (i = 0; i < imax; i += 3) {
            b10 = (_getbyte(s, i) << 16) | (_getbyte(s, i + 1) << 8) | _getbyte(s, i + 2);
            x.push(_ALPHA.charAt(b10 >> 18));
            x.push(_ALPHA.charAt((b10 >> 12) & 0x3F));
            x.push(_ALPHA.charAt((b10 >> 6) & 0x3f));
            x.push(_ALPHA.charAt(b10 & 0x3f));
        }

        switch (s.length - imax) {
            case 1:
                b10 = _getbyte(s, i) << 16;
                x.push(_ALPHA.charAt(b10 >> 18) + _ALPHA.charAt((b10 >> 12) & 0x3F) + _PADCHAR + _PADCHAR);
                break;

            case 2:
                b10 = (_getbyte(s, i) << 16) | (_getbyte(s, i + 1) << 8);
                x.push(_ALPHA.charAt(b10 >> 18) + _ALPHA.charAt((b10 >> 12) & 0x3F) + _ALPHA.charAt((b10 >> 6) & 0x3f) + _PADCHAR);
                break;
        }

        return x.join("");
    }


    /// Global plugin functions
    $.extend({

        /// Authenticate function
        authenticate: function (user, sid, password, account, restHostUrl, doneCallback, failCallBack) {
            //overwrite the global rest host URL with the entered value
            //alert("restHostUrl:" + restHostUrl);
            //alert("test");
            _restHostUrl = restHostUrl + '/api';
            //var reqStr = "user=" + user + "&sid=" + sid + "&pass=" + password + "&acc=" + account + "&integratorkey=" + _restIntegratorKey + "&callback=?";
            //var reqStr = "user=" + escape(user) + "&sid=" + sid + "&pass=" + escape(password) + "&acc=" + account + "&integratorkey=" + _restIntegratorKey;
            //var reqStr = "user='" + user + "'&sid='" + sid + "'&pass='" + password + "'&acc='" + account + "'&integratorkey='" + _restIntegratorKey + "'&callback=?";
            // var request = $.ajax({
            // url: _restHostUrl + "/AuthService/v1.0/Authenticate?" + reqStr,
            // beforeSend: _setHttpHeader,
            // contentType: "application/json; charset=utf-8", 
            // type: "GET",
            // dataType: "json"
            // });
            var request = {
                UserName: user,
                UserSid: sid,
                Password: password,
                Realm: account
            };

            var request = $.ajax({
                url: _restHostUrl + "/AuthService/v1.0/Authenticate",
                data: JSON.stringify(request),
                beforeSend: _setHttpHeader,
                contentType: "application/json",
                type: "POST",
                dataType: "json"
            });

            request.done(function (data, textStatus, jqXHR) {
                _setSessionCookie(data.Token);
                if (doneCallback) doneCallback(data, textStatus, jqXHR);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });

        },
        IsSalesForceLicensed: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/LicensingService/v1.0/IsSalesForceLicensed",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        setAuthenticatedURL: function (restHostUrl) {
            _restHostUrl = restHostUrl + '/api';
        },
        setSecurityToken: function (Token) {
            _setSessionCookie(Token);
        },

        /// Get security token
        getSecurityToken: function () {
            return _getSessionCookie("CchNGAuthToken");
        },

        /// Authenticate function
        authenticate2: function (user, sid, password, account, doneCallback, failCallBack) {
            var reqStr = "user=" + escape(user) + "&sid=" + sid + "&pass=" + escape(password) + "&acc=" + account + "&callback=?";
            var xmlHttp;

            if (window.XMLHttpRequest) {
                xmlHttp = new window.XMLHttpRequest;
            }
            else {
                try {

                    xmlHttp = new ActiveXObject("MSXML2.XMLHTTP");

                }
                catch (ex) {
                    xmlHttp = null;
                }
            }

            xmlHttp.open("GET", _restHostUrl + "/AuthService/v1.0/Authenticate?" + reqStr, false);

            xmlHttp.onreadystatechange = function (event) {
                if (xmlHttp.readyState == 4) {
                    if (xmlHttp.status == 200) {
                        //fileContents = convertResponseBodyToText(xmlHttp.responseBody);                 
                        //fileContents = xmlHttp.responseBody;
                        alert(xmlHttp.getResponseHeader("Content-Length"));
                        alert(xmlHttp.getResponseHeader("Content-Type"));
                        alert(xmlHttp.getResponseHeader("Set-Cookie"));
                        //                 var fso, f2;     
                        //                 fso = new ActiveXObject("Scripting.FileSystemObject");     
                        //                 f2=fso.CreateTextFile("D:\\Logs\\DownLoad\\example.js",true);     
                        //                 f2.Write(fileContents);     
                        //                 f2.Close(); 
                        //fileSize = fileContents.length-1;                 
                        // invoke a callback here, if you like...
                        if (doneCallback) {
                            var token = $.parseJSON(xmlHttp.responseText);
                            alert(token.Token);

                            doneCallback(xmlHttp.responseBody);
                        }
                    }
                    else {
                        alert("download failed, status " + xmlHttp.status);
                    }
                }
            };     //req.send();         

            xmlHttp.send();

            ////            alert(xmlHttp.responseBody);

        },

        authenticateEx: function (user, sid, password, account, doneCallback, failCallBack) {
            alert("in authentication ex");
            var reqStr = "user=" + escape(user) + "&sid=" + sid + "&pass=" + escape(password) + "&acc=" + account + "&integratorkey=" + _restIntegratorKey + "&callback=?";
            var request = $.ajax({
                url: _restHostUrl + "/AnonymousDocumentService/v1.0/Authenticate/Authenticate?" + reqStr,
                type: "GET",
                dataType: "json"
            });

            request.done(function (data) {
                _setSessionCookie(data.Token);
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });

        },

        /// Client functions
        client: function (method) {
            if (_clientMethods[method]) {
                return _clientMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            }
            else if (typeof method === 'object' || !method) {
                return _clientMethods.init.apply(this, arguments);
            }
            else {
                $.error('Method ' + method + ' does not exist on jQuery.client');
            }
        },

        /// Document Service functions
        documentService: function (method) {
            if (_documentServiceMethods[method]) {
                return _documentServiceMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            }
            else if (typeof method === 'object' || !method) {
                return _documentServiceMethods.init.apply(this, arguments);
            }
            else {
                $.error('Method ' + method + ' does not exist on jQuery.documentService');
            }
        },

        /// Staff Service functions
        staff: function (method) {
            if (_staffMethods[method]) {
                return _staffMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            }
            else if (typeof method === 'object' || !method) {
                return _staffMethods.init.apply(this, arguments);
            }
            else {
                $.error('Method ' + method + ' does not exist on jQuery.staff');
            }
        },

        /// Anonymous Document Service functions
        anonymousDocumentService: function (method) {
            if (_anonymousDocumentServiceMethods[method]) {
                return _anonymousDocumentServiceMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            }
            else if (typeof method === 'object' || !method) {
                return _anonymousDocumentServiceMethods.init.apply(this, arguments);
            }
            else {
                $.error('Method ' + method + ' does not exist on jQuery.anonymousDocumentService');
            }
        }

    });     // $.extend

    /// Client methods
    var _clientMethods = {
        init: function () {
        },

        /// Get a list of clients based on client ID
        /// Return: jqXHR Object
        GetClients: function (exportRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                //cache: false,
                type: "POST",
                //async: false,
                url: _restHostUrl + "/ClientService/v1.0/Client?action=Search",
                data: JSON.stringify(exportRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get client details
        /// Return: jqXHR Object
        GetClientDetails: function (clientId, clientSubId, doneCallback, failCallBack) {
            //var data = {ClientID: clientId, ClientSubID: clientSubId};
            var requestUrl = "";
            requestUrl = _restHostUrl + "/ClientService/v1.0/Client?id=" + encodeURIComponent(clientId) + "&subid=" + encodeURIComponent(clientSubId);
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get client address
        /// Return: jqXHR Object
        GetClientAddress: function (clientId, clientSubId, doneCallback, failCallBack) {
            //var data = {ClientID: clientId, ClientSubID: clientSubId};
            var requestUrl = "";
            if (clientSubId == "" || clientSubId == null)
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/AddressList";
            else
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/" + clientSubId + "/AddressList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get client emails
        /// Return: jqXHR Object
        GetClientEmails: function (clientId, clientSubId, doneCallback, failCallBack) {
            //var data = {ClientID: clientId, ClientSubID: clientSubId};
            var requestUrl = "";
            if (clientSubId == "" || clientSubId == null)
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/EmailList";
            else
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/" + clientSubId + "/EmailList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get client phones
        /// Return: jqXHR Object
        GetClientPhones: function (clientId, clientSubId, doneCallback, failCallBack) {
            //var data = {ClientID: clientId, ClientSubID: clientSubId};
            var requestUrl = "";
            if (clientSubId == "" || clientSubId == null)
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/PhoneList";
            else
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/" + clientSubId + "/PhoneList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get client instant messengers
        /// Return: jqXHR Object
        GetClientInstantMessengers: function (clientId, clientSubId, doneCallback, failCallBack) {
            //var data = {ClientID: clientId, ClientSubID: clientSubId};
            var requestUrl = "";
            if (clientSubId == "" || clientSubId == null)
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/InstantMessengerList";
            else
                requestUrl = _restHostUrl + "/ClientService/v1.0/Client/" + clientId + "/" + clientSubId + "/InstantMessengerList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of Corporation clients
        CreateMultipleClientCorporation: function (clientCorporationList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Corporate",
                data: JSON.stringify(clientCorporationList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of Corporation clients
        UpdateMultipleClientCorporation: function (clientCorporationList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Corporate",
                data: JSON.stringify(clientCorporationList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of EmployeePlan clients
        CreateMultipleClientEmployeePlan: function (clientEmployeePlanList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/EmployeePlan",
                data: JSON.stringify(clientEmployeePlanList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of EmployeePlan clients
        UpdateMultipleClientEmployeePlan: function (clientEmployeePlanList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/EmployeePlan",
                data: JSON.stringify(clientEmployeePlanList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of Fiduciary clients
        CreateMultipleClientFiduciary: function (clientFiduciaryList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Fiduciary",
                data: JSON.stringify(clientFiduciaryList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of Fiduciary clients
        UpdateMultipleClientFiduciary: function (clientFiduciaryList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Fiduciary",
                data: JSON.stringify(clientFiduciaryList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of individual clients
        CreateMultipleClientIndividual: function (clientIndividualList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Individual",
                data: JSON.stringify(clientIndividualList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of individual clients
        UpdateMultipleClientIndividual: function (clientIndividualList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Individual",
                data: JSON.stringify(clientIndividualList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of NonProfit clients
        CreateMultipleClientNonProfit: function (clientNonProfitList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/ExemptOrganization",
                data: JSON.stringify(clientNonProfitList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of NonProfit clients
        UpdateMultipleClientNonProfit: function (clientNonProfitList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/ExemptOrganization",
                data: JSON.stringify(clientNonProfitList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of Partnership clients
        CreateMultipleClientPartnership: function (clientPartnershipList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Partnership",
                data: JSON.stringify(clientPartnershipList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of Partnership clients
        UpdateMultipleClientPartnership: function (clientPartnershipList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Partnership",
                data: JSON.stringify(clientPartnershipList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create a list of SoleProprietorship clients
        CreateMultipleClientSoleProprietorship: function (clientSoleProprietorshipList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/SoleProprietorship",
                data: JSON.stringify(clientSoleProprietorshipList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        /// Update a list of SoleProprietorship clients
        UpdateMultipleClientSoleProprietorship: function (clientSoleProprietorshipList, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/SoleProprietorship",
                data: JSON.stringify(clientSoleProprietorshipList),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get address types
        /// Return: jqXHR Object
        GetFirmAddressTypes: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/FirmService/v1.0/Firm/AddressType",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get phone types
        /// Return: jqXHR Object
        GetFirmPhoneTypes: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/FirmService/v1.0/Firm/PhoneType",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get email types
        /// Return: jqXHR Object
        GetFirmEmailTypes: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/FirmService/v1.0/Firm/EmailType",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get IM types
        /// Return: jqXHR Object
        GetFirmInstantMessengerTypes: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/FirmService/v1.0/Firm/InstantMessengerType",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get IM Providers
        /// Return: jqXHR Object
        GetFirmInstantMessengerProviders: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/FirmService/v1.0/Firm/InstantMessengerProvider",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create address for client
        /// Return: jqXHR Object
        CreateClientAddress: function (clientId, clientSubId, clientAddress, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientAddress = clientAddress;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Address",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update address for client
        /// Return: jqXHR Object
        UpdateClientAddress: function (clientId, clientSubId, clientAddress, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientAddress = clientAddress;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Address",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create email for client
        /// Return: jqXHR Object
        CreateClientEmail: function (clientId, clientSubId, clientEmail, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientEmail = clientEmail;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Email",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update email for client
        /// Return: jqXHR Object
        UpdateClientEmail: function (clientId, clientSubId, clientEmail, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientEmail = clientEmail;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Email",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create phone for client
        /// Return: jqXHR Object
        CreateClientPhone: function (clientId, clientSubId, clientPhone, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientPhone = clientPhone;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/Phone",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update phone for client
        /// Return: jqXHR Object
        UpdateClientPhone: function (clientId, clientSubId, clientPhone, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientPhone = clientPhone;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/Phone",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create instant messenger for client
        /// Return: jqXHR Object
        CreateClientInstantMessenger: function (clientId, clientSubId, clientIM, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientInstantMessenger = clientIM;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/ClientService/v1.0/Client/InstantMessenger",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update instant messenger for client
        /// Return: jqXHR Object
        UpdateClientInstantMessenger: function (clientId, clientSubId, clientIM, doneCallback, failCallBack) {
            var requestData = {};
            requestData.ClientId = clientId;
            requestData.ClientSubordinateId = clientSubId;
            requestData.ClientInstantMessenger = clientIM;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/ClientService/v1.0/Client/InstantMessenger",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        }

    };      /// Client methods


    /// Document Service methods
    var _documentServiceMethods = {
        init: function () {
        },

        /// Get the Classes
        /// Return: jqXHR Object
        GetClasses: function (getClassesRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/DocumentService/v1.0/Entity/Classes",
                data: JSON.stringify(getClassesRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the Classes by firm

        /// Return: jqXHR Object
        GetClassesByFirm: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Firm/Classes",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the Years By Firm
        /// Return: jqXHR Object
        GetYearsByFirm: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Firm/Years",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the File Types for logged in Client Firm
        /// Return: jqXHR Object
        GetDocumentTypes: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Firm/DocumentTypes",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the login user information
        /// Return: jqXHR Object
        GetLoggedUser: function (doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/User?type=logged",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the Client Template
        /// Return: jqXHR Object
        GetClientTemplate: function (getRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/DocumentService/v1.0/Entity/ClientTemplate",
                data: JSON.stringify(getRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        // Get the Documentversion

        GetDocumentVersion: function (DocumentGuid, doneCallback, failCallBack) {
            var targeturl = _restHostUrl + "/DocumentService/v1.0/Document/" + DocumentGuid + "/Versions";
            var request = $.ajax({
                type: "GET",
                url: targeturl,

                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);

            });
        },

        // Get the DocumentHistory

        GetDocumentHistory: function (DocumentGuid, doneCallback, failCallBack) {
            var targeturl = _restHostUrl + "/DocumentService/v1.0/Document/" + DocumentGuid + "/History";
            var request = $.ajax({
                type: "GET",
                url: targeturl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);

            });
        },


        /// Get the Documents for the given client
        /// Return: jqXHR Object
        AdvancedSearch: function (getRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/DocumentService/v1.0/Document?action=AdvancedSearch",
                data: JSON.stringify(getRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        ///GetDocumentSearchFieldNames
        GetDocumentSearchFieldNames: function (doneCallback, failCallBack) {

            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Document/?action=GetDocumentSearchFieldNames",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        //GetDocumentSearchCombineOperators
        GetDocumentSearchCombineOperators: function (doneCallback, failCallBack) {

            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Document/?action=GetDocumentSearchCombineOperators",
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        //GetDocumentSearchCombineOperators
        GetDocumentSearchOperators: function (fieldNameRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Document/?action=GetDocumentSearchOperators&fieldName=" + fieldNameRequest,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the Documents for the given client
        /// Return: jqXHR Object
        SrchDocuments: function (getRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/DocumentService/v1.0/Document?action=Search&searchText=" + getRequest,
                data: JSON.stringify(getRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get the Documents for the given client        
        GetDocumentClientSearch: function (clientId, clientName, officeID, srchType, doneCallback, failCallBack) {
            var targeturl = _restHostUrl + "/DocumentService/v1.0/Document/Client?action=Search&clientid=" + clientId + "&clientname=" + clientName + "&officeID=" + officeID + "&srchType=" + srchType;
            var request = $.ajax({
                type: "GET",
                url: targeturl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        //GetDocumentMetaData

        GetDocumentMetadata: function (DocumentGuid, doneCallback, failCallBack) {
            var targeturl = _restHostUrl + "/DocumentService/v1.0/Document/" + DocumentGuid + "/Metadata";
            var request = $.ajax({
                type: "GET",
                url: targeturl,

                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);

            });
        },

        //CheckOutDocument

        /*CheckOutDocument: function (DocumentGuid, UserComments, doneCallback, failCallBack) {
            var ssoToken = _getSessionCookie("CchNGAuthToken");
            var base64Token = _base64Encode(ssoToken);

            // Make a Base64 string URL friendly by replacing '+' and '/' with '-' and '_' 
            // and removing any trailing '=' characters
            base64Token = base64Token.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');

            var reqStr = "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + base64Token;

            var url = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/" + DocumentGuid + "?action=CheckOut" + reqStr;
            //var url = _restHostUrl + "/DocumentService/v1.0/Document/" + documentGuid;

            return url;
        },*/
		
		CheckoutDocument: function (documentGuid, doneCallback, failCallBack) {
            var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/" + documentGuid + "?action=CheckOut";

            xhr = new XMLHttpRequest();
            xhr.open('GET', targetUrl, true);
            xhr.responseType = "blob";
            _setHttpHeader(xhr);

            xhr.onload = function (e) {
                if (this.status >= 200 && this.status < 300 || this.status === 304) {
                    var contentDisposition = this.getResponseHeader('content-Disposition');
                    var fileName = contentDisposition.substring(contentDisposition.indexOf('"') + 1, contentDisposition.length - 1);
                    saveAs(this.response, fileName);
					if (doneCallback) doneCallback("Checked out");
                }
                else {
                    var reader = new FileReader();
                    reader.onload = function (event) {
                        var jqXHR = new Object();
                        jqXHR.responseText = reader.result;
                        jqXHR.statusText = xhr.statusText;
                        jqXHR.status = xhr.status;
                        if (failCallBack) failCallBack(jqXHR, this.statusText, this.status);
                    };
                    reader.readAsText(this.response);
                }
            }

            xhr.send(null);
        },

        //CheckInDocument
        // CheckInDocument: function (DocumentGuid, UserComments, KeepCheckout, filePath, doneCallback, failCallBack) {
        // var ssoToken = $.anonymousDocumentService('GetBase64SSOToken');

        // var metadata = [{ name: "UserComments", value: "" }, { name: "KeepCheckout", value: ""}];
        // metadata[0].value = UserComments;
        // metadata[1].value = KeepCheckout;
        // var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/" +
        // DocumentGuid + "?action=CheckIn" + "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + ssoToken;

        // var request = $.ajax(targetUrl, {
        // type: "POST",
        // data: metadata,
        // files: filePath,
        // iframe: true,
        // processData: false,
        // ResponseCall: 'checkindocument',
        // DocumentGuid: DocumentGuid
        // });

        // request.done(function (data, textStatus, jqXHR) {
        // if (doneCallback) doneCallback(data, textStatus, jqXHR);
        // });

        // request.fail(function (jqXHR, textStatus, err) {
        // if (failCallBack) failCallBack(jqXHR, textStatus, err);

        // });
        // },
        CheckInDocument: function (DocumentGuid, UserComments, KeepCheckout, filePath, doneCallback, failCallBack) {
            var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/" +
            DocumentGuid + "?action=CheckIn";

            xhr = new XMLHttpRequest();
            xhr.open('post', targetUrl, true);
            _setHttpHeader(xhr);
            var formData = new FormData();
            formData.append("UserComments", UserComments);
            formData.append("KeepCheckout", KeepCheckout);
            formData.append("File", filePath[0].files[0]);

            xhr.onload = function (e) {
                if (this.status >= 200 && this.status < 300 || this.status === 304) {
                    if (doneCallback) doneCallback(JSON.parse(this.responseText));
                }
                else {
                    if (failCallBack) failCallBack(this, this.statusText, this.status);
                }
            }

            if ('getAsBinary' in filePath[0].files[0])
                xhr.sendAsBinary(filePath[0].files[0].getAsBinary());
            else
                xhr.send(formData);
        },

        //CancelCheckOut
        CancelCheckOut: function (DocumentGuid, doneCallback, failCallBack) {
            var targeturl = _restHostUrl + "/DocumentService/v1.0/Document/" + DocumentGuid + "?action=CancelCheckOut";
            var request = $.ajax({
                type: "GET",
                url: targeturl,

                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);

            });
        },


        //Upload MetaData
        // UploadDocumentMetadata: function (MetadataRequest, filepath, doneCallback, failCallBack) {

        // var ssoToken = $.anonymousDocumentService('GetBase64SSOToken');
        // var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/?action=Upload" + "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + ssoToken;
        // var metadata = [{ name: "Metadata", value: ""}];
        // metadata[0].value = JSON.stringify(MetadataRequest);

        // var request = $.ajax(targetUrl, {
        // type: "POST",
        // data: metadata,
        // files: filepath,
        // iframe: true,
        // processData: false,
        // ResponseCall: 'uploaddocument',
        // DocumentGuid: MetadataRequest.DocumentGuid
        // });

        // request.done(function (data) {
        // if (doneCallback) doneCallback(data);
        // });
        // request.fail(function (jqXHR, textStatus, err) {
        // if (failCallBack) failCallBack(jqXHR, textStatus, err);
        // });
        // },
        UploadDocumentMetadata: function (MetadataRequest, filepath, doneCallback, failCallBack) {
            var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/?action=Upload";

            xhr = new XMLHttpRequest();
            xhr.open('post', targetUrl, true);
            _setHttpHeader(xhr);
            var filename = MetadataRequest.DocumentName;
            var formData = new FormData();
            formData.append(filename, filepath[0].files[0]);
            formData.append("metadata", JSON.stringify(MetadataRequest));

            xhr.onload = function (e) {
                if (this.status >= 200 && this.status < 300 || this.status === 304) {
                    if (doneCallback) doneCallback(JSON.parse(this.responseText));
                }
                else {
                    if (failCallBack) failCallBack(this, this.statusText, this.status);
                }
            }

            if ('getAsBinary' in filepath[0].files[0])
                xhr.sendAsBinary(filepath[0].files[0].getAsBinary());
            else
                xhr.send(formData);
        },
        UploadDocumentMetadataSF: function (MetadataRequest, filepath, doneCallback, failCallBack) {

            var ssoToken = $.anonymousDocumentService('GetBase64SSOToken');
            var targetUrl = _restHostUrl + "/DocumentService/Transfer/v1.0/Document/?action=Upload" + "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + ssoToken;
            var metadata = [{ name: "Metadata", value: ""}];
            metadata[0].value = JSON.stringify(MetadataRequest);
            var formData = new FormData();
            formData.append("Metadata", JSON.stringify(MetadataRequest));
            formData.append("documentFilePath", filepath);
            //alert(filepath.length);

            var request = $.ajax(targetUrl, {
                type: "POST",
                data: formData,
                //files: filepath,
                //iframe: true,
                processData: false,
                contentType: 'multipart/form-data',
                dataType: "json"
            });


            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);

            });
        },

        ///Downloads the document specified in the request
        DownloadDocument: function (downloadRequest, doneCallback, failCallBack) {


            var xmlHttp;

            if (window.XMLHttpRequest) {
                xmlHttp = new window.XMLHttpRequest;
            }
            else {
                try {

                    xmlHttp = new ActiveXObject("MSXML2.XMLHTTP");

                }
                catch (ex) {
                    xmlHttp = null;
                }
            }

            xmlHttp.open("POST", _restHostUrl + "/DocumentService/v1.0/DownloadDocument", false);
            _setHttpHeader(xmlHttp);
            xmlHttp.setRequestHeader('Content-Type', 'application/json');


            xmlHttp.onreadystatechange = function (event) {
                if (xmlHttp.readyState == 4) {
                    if (xmlHttp.status == 200) {
                        //fileContents = convertResponseBodyToText(xmlHttp.responseBody);                 
                        //fileContents = xmlHttp.responseBody;
                        alert(xmlHttp.getResponseHeader("Content-Length"));
                        alert(xmlHttp.getResponseHeader("Content-Type"));
                        //                 var fso, f2;     
                        //                 fso = new ActiveXObject("Scripting.FileSystemObject");     
                        //                 f2=fso.CreateTextFile("D:\\Logs\\DownLoad\\example.js",true);     
                        //                 f2.Write(fileContents);     
                        //                 f2.Close(); 
                        //fileSize = fileContents.length-1;                 
                        // invoke a callback here, if you like...
                        if (doneCallback) doneCallback(fileContents);
                    }
                    else {
                        alert("download failed, status " + xmlHttp.status);
                    }
                }
            };     //req.send(); 
            if (xmlHttp.overrideMimeType)
                xmlHttp.overrideMimeType('text/plain; charset=x-user-defined');


            xmlHttp.send(JSON.stringify(downloadRequest));

            alert(xmlHttp.responseBody);



            //        var request = $.ajax({
            //        type: "POST",
            //        url: _restHostUrl + "/DocumentService/v1.0/DownloadDocument",
            //                data: JSON.stringify(downloadRequest),
            //                contentType: "application/json",
            //                beforeSend: _setHttpHeader,
            //                async: false,
            //            });

            //            request.done(function (data) {
            //                if (doneCallback) doneCallback(data);
            //            });

        }

    };          /// Document Service methods    

    /// Staff methods
    var _staffMethods = {
        init: function () {
        },

        /// Get a list of Staff based on staff ID
        /// Return: jqXHR Object
        GetStaff: function (exportRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                //cache: false,
                type: "POST",
                //async: false,
                url: _restHostUrl + "/StaffService/v1.0/Staff?action=Search",
                data: JSON.stringify(exportRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        CreateStaff: function (ImportRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/StaffService/v1.0/Staff",
                data: JSON.stringify(ImportRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },
        UpdateStaff: function (UpdateRequest, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/StaffService/v1.0/Staff",
                data: JSON.stringify(UpdateRequest),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get staff details
        /// Return: jqXHR Object
        GetStaffDetails: function (staffId, doneCallback, failCallBack) {
            var request = $.ajax({
                type: "GET",
                url: _restHostUrl + "/StaffService/v1.0/Staff/" + encodeURIComponent(staffId),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get Staff address
        /// Return: jqXHR Object
        GetStaffAddress: function (staffId, doneCallback, failCallBack) {
            var requestUrl = _restHostUrl + "/StaffService/v1.0/Staff/" + staffId + "/AddressList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get Staff Emails
        /// Return: jqXHR Object
        GetStaffEmails: function (staffId, doneCallback, failCallBack) {
            var requestUrl = _restHostUrl + "/StaffService/v1.0/Staff/" + staffId + "/EmailList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get Staff Phones
        /// Return: jqXHR Object
        GetStaffPhones: function (staffId, doneCallback, failCallBack) {
            var requestUrl = _restHostUrl + "/StaffService/v1.0/Staff/" + staffId + "/PhoneList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Get Staff Instant Messengers
        /// Return: jqXHR Object
        GetStaffInstantMessengers: function (staffId, doneCallback, failCallBack) {
            var requestUrl = _restHostUrl + "/StaffService/v1.0/Staff/" + staffId + "/InstantMessengerList";
            var request = $.ajax({
                type: "GET",
                url: requestUrl,
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create address for staff
        /// Return: jqXHR Object
        CreateStaffAddress: function (staffId, staffAddress, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffAddress = staffAddress;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Address",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update address for staff
        /// Return: jqXHR Object
        UpdateStaffAddress: function (staffId, staffAddress, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffAddress = staffAddress;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Address",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create email for staff
        /// Return: jqXHR Object
        CreateStaffEmail: function (staffId, staffEmail, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffEmail = staffEmail;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Email",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update email for staff
        /// Return: jqXHR Object
        UpdateStaffEmail: function (staffId, staffEmail, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffEmail = staffEmail;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Email",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create phone for staff
        /// Return: jqXHR Object
        CreateStaffPhone: function (staffId, staffPhone, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffPhone = staffPhone;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Phone",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update phone for staff
        /// Return: jqXHR Object
        UpdateStaffPhone: function (staffId, staffPhone, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffPhone = staffPhone;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/StaffService/v1.0/Staff/Phone",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Create instant messenger for staff
        /// Return: jqXHR Object
        CreateStaffInstantMessenger: function (staffId, staffIM, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffInstantMessenger = staffIM;
            var request = $.ajax({
                type: "POST",
                url: _restHostUrl + "/StaffService/v1.0/Staff/InstantMessenger",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        },

        /// Update instant messenger for staff
        /// Return: jqXHR Object
        UpdateStaffInstantMessenger: function (staffId, staffIM, doneCallback, failCallBack) {
            var requestData = {};
            requestData.StaffId = staffId;
            requestData.StaffInstantMessenger = staffIM;
            var request = $.ajax({
                type: "PUT",
                url: _restHostUrl + "/StaffService/v1.0/Staff/InstantMessenger",
                data: JSON.stringify(requestData),
                contentType: "application/json",
                dataType: "json",
                beforeSend: _setHttpHeader
            });

            request.done(function (data) {
                if (doneCallback) doneCallback(data);
            });

            request.fail(function (jqXHR, textStatus, err) {
                if (failCallBack) failCallBack(jqXHR, textStatus, err);
            });
        }
    };  //Staff methods End


    /// anonymousDocumentService methods
    var _anonymousDocumentServiceMethods = {
        init: function () {
        },

        /// Get document's downloading URL 
        /// Return: URL of the http request to download the document
        GetDocumentUrl: function (documentGuid, userIntID) {
            var ssoToken = _getSessionCookie("CchNGAuthToken");
            var base64Token = _base64Encode(ssoToken);

            // Make a Base64 string URL friendly by replacing '+' and '/' with '-' and '_' 
            // and removing any trailing '=' characters
            base64Token = base64Token.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');

            var reqStr = "guid=" + documentGuid + "&user=" + userIntID + "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + base64Token;

            var url = _restHostUrl + "/AnonymousDocumentService/v1.0/Document?" + reqStr;
            //var url = _restHostUrl + "/DocumentService/v1.0/Document/" + documentGuid;

            return url;
        },

        /// Get document's downloading URL 
        /// Return: URL of the http request to download the document
        GetDocumentUrlForSalesForce: function (documentGuid, userIntID, FileName) {
            var ssoToken = _getSessionCookie("CchNGAuthToken");
            var base64Token = _base64Encode(ssoToken);

            // Make a Base64 string URL friendly by replacing '+' and '/' with '-' and '_' 
            // and removing any trailing '=' characters
            base64Token = base64Token.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');

            var reqStr = "guid=" + documentGuid + "&user=" + userIntID + "&IntegratorKey=" + _restIntegratorKey + "&ssoToken=" + base64Token;

            var url = _restHostUrl + "/AnonymousDocumentService/v1.0/Document/" + FileName + "?" + reqStr;
            //var url = _restHostUrl + "/DocumentService/v1.0/Document/" + documentGuid;

            return url;
        },
        DownloadDocument: function (documentGuid, userIntID, failCallBack) {
            var targetUrl = _restHostUrl + "/AnonymousDocumentService/v1.0/Document?guid=" + documentGuid + "&user=" + userIntID;

            xhr = new XMLHttpRequest();
            xhr.open('GET', targetUrl, true);
            xhr.responseType = "blob";
            _setHttpHeader(xhr);

            xhr.onload = function (e) {
                if (this.status >= 200 && this.status < 300 || this.status === 304) {
                    var contentDisposition = this.getResponseHeader('content-Disposition');
                    var fileName = contentDisposition.substring(contentDisposition.indexOf('"') + 1, contentDisposition.length - 1);
                    saveAs(this.response, fileName);
                }
                else {
                    var reader = new FileReader();
                    reader.onload = function (event) {
                        var jqXHR = new Object();
                        jqXHR.responseText = reader.result;
                        jqXHR.statusText = xhr.statusText;
                        jqXHR.status = xhr.status;
                        if (failCallBack) failCallBack(jqXHR, this.statusText, this.status);
                    };
                    reader.readAsText(this.response);
                }
            }

            xhr.send(null);
        },
        GetBase64SSOToken: function () {
            var ssoToken = _getSessionCookie("CchNGAuthToken");
            var base64Token = _base64Encode(ssoToken);

            // Make a Base64 string URL friendly by replacing '+' and '/' with '-' and '_' 
            // and removing any trailing '=' characters
            base64Token = base64Token.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
            return base64Token;
        }
    };

})(jQuery);
