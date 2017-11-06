/*
    **************************************************************************
    Name    :   OauthUtil
    
    Used for  :   This Apex class is used for Authenticating TAA and SFS Salesforce Orgs .
    
    Version    |    Name            |    Date           
    1.0             Rajesh Gonola          14-April-2017  
    
   
     
    ***************************************************************************
*/
global class OauthUtil{
    
    
    //wrapper for oauth rest api 
     public class OAuth2{  public String id{get;set;} public String issued_at{get;set;} public String instance_url{get;set;} public String signature{get;set;} public String access_token{get;set;}    
     
     }
  
     public static OAuth2 parse(String json){   return (OAuth2) System.JSON.deserialize(json, OAuth2.class); }
     
     
     
     
       public static HttpResponse Authenticate(String clientName) {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse ();
        
        try{
        Oauth_settings__c oauth;
        if(clientName == 'TAAServiceOrg'){
            oauth= Oauth_settings__c.getInstance('TAAServiceOrg');
        }else{
            oauth= Oauth_settings__c.getInstance('Credentials');
        } 
        
        String clientId = oauth.ClientId__c;
        String clientSecret = oauth.ClientSecret__c;
        String username= oauth.Username__c;
        String password= oauth.Password__c;
        String curl= oauth.URL__c;
        String Result;
        
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        
       
        req.setMethod('POST');
        req.setBody(reqbody);//Send JSON body
        req.setEndpoint(curl+'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance
        
         res = h.send(req);
        
        system.debug('Auth request response'+res.getStatusCode());
        system.debug('***body'+res.getbody() );
        
       
        return res;
        
        }catch(Exception ex){
   
           String Result='Something Went wrong'+ex.getMessage()+ex.getLineNumber();
           system.debug('Resp String'+Result);
           return null;
           }
       
       }
    
    
    
    
    
    }