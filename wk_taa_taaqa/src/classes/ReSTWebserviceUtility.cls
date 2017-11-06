/*
 * Utility Class for ReST Webservice Callouts
 *  
*/
/*--------------------------------------------------------------------------
 * Date       Author            Version      Description
 * -------------------------------------------------------------------------
 * 10/13/2017 SHIVAJI           1.0          Initial Draft
 * Being used in Sales to Service Integration JIRA # SMS-864
 * ------------------------------------------------------------------------- */
public class ReSTWebserviceUtility 
{
    // *** Authentication Callout
    public static OauthUtil.OAuth2 authenticate(String requestorCredentialName)
    {
    	OauthUtil.OAuth2 objAuthenticationInfo = new OauthUtil.OAuth2(); 
    	HttpResponse res = OauthUtil.Authenticate(requestorCredentialName);
		if(res != NULL && res.getStatusCode() == 200)
		{
			objAuthenticationInfo = (OauthUtil.OAuth2)JSON.deserialize(res.getbody(), OauthUtil.OAuth2.class);
		}else{
			//isError = true;
			if(res == NULL){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: source system seems to be down or wrongly endpointed.'));
			}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Technical error: ' + res.getStatus()));	
			}
			return null;
		}
		return objAuthenticationInfo;
    }
    
    
    // *** Method to prepare HttpRequest object 
    public static HttpRequest getHttpRequest(String method, Map<String, String> headerMap, Integer timeOut, String endPoint, String body)
    {
    	HttpRequest req = new HttpRequest();
    	if(!String.isBlank(method)){
    		req.setMethod(method);
    	}else{
    		return NULL;
    	}
    	
    	if(headerMap != NULL && headerMap.size() > 0)
    	{
    		for(String key : headerMap.keySet())
    		{
    			req.setHeader(key, headerMap.get(key));		
    		}
    	}else{
    		return NULL;
    	}
    	
    	if(timeOut != NULL){
			req.setTimeout(timeOut);
    	}else{
    		req.setTimeout(120000);
    	}
    	
    	if(!String.isBlank(endPoint)){
			req.setEndpoint(endPoint);//URL will be your Salesforce REST API end point where you will do POST,PUT,DELETE orGET
    	}else{
    		return NULL;
    	}
		
		if(!String.isBlank(body)){
			req.setBody(body);
		}
		return req;
    }
    
    public static String getUpdateCaseSOAPRequest(String accessToken, String escalationLevel, String caseNumber)
    {
    	return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cre="http://soap.sforce.com/schemas/class/CreateUpdateCaseV2">'+
   						'<soapenv:Header>'+
						'      <cre:AllowFieldTruncationHeader>'+
						'         <cre:allowFieldTruncation>true</cre:allowFieldTruncation>'+
						'      </cre:AllowFieldTruncationHeader>'+
						'      <cre:DebuggingHeader>'+
						'         <!--Zero or more repetitions:-->'+
						'         <cre:categories>'+
						'            <cre:category>ALL</cre:category>'+
						'            <cre:level>DEBUG</cre:level>'+
						'         </cre:categories>'+
						'         <cre:debugLevel>Db</cre:debugLevel>'+
						'      </cre:DebuggingHeader>'+
						'      <cre:CallOptions>'+
						'         <cre:client>SFDC</cre:client>'+
						'      </cre:CallOptions>'+
						'      <cre:SessionHeader>'+
						'         <cre:sessionId>' + accessToken + '</cre:sessionId>'+
						'      </cre:SessionHeader>'+
						'   </soapenv:Header>'+
						'   <soapenv:Body>'+
						'      <cre:updateCase>'+
						'         <cre:objExternalCaseInfo>'+
						'            '+
						'            <cre:caseEscalationLevel>' + escalationLevel + '</cre:caseEscalationLevel>'+
						//'            <cre:caseEscalationLevel>E1</cre:caseEscalationLevel>'+
						'            '+
						'            <cre:caseNumber>' + caseNumber + '</cre:caseNumber>'+
						//'            <cre:caseNumber>11003138</cre:caseNumber>'+
						'            '+
						'         </cre:objExternalCaseInfo>'+
						'      </cre:updateCase>'+
						'   </soapenv:Body>'+
						'</soapenv:Envelope>';	
    }
}