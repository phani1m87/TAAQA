//var $Y = YAHOO;
//var $YD = YAHOO.util.Dom;
var $YE = YAHOO.util.Event;
//var $ = $YD.get;
var $S = DomQuery.select;

function ValidateInput(val)
{
	//get all variables to validate
	var tbContextID = $S('.tbContextID')[0];
	var tbExpiration =  $S('.tbExpiration')[0];
	var tbURL =  $S('.tbURL')[0];

   	allowsave = true;
    var Errormessage = "";
    var showmessage = false;

   
    if (tbContextID.value == "")
    { showmessage = true;  Errormessage += "The Context Identifier is required. \r\n"; }

	var valExperiation;
 	if (tbExpiration.value.length == 1 && tbExpiration.value != "0"){
 		valExperiation = '0' + tbExpiration.value;
 	}else{
 		valExperiation = tbExpiration.value ;
 	}
    
    if ( valExperiation == "00" )
    { showmessage = true;  Errormessage += "A valid Expiration Number is required. \r\n"; }
    
    if (valExperiation.match("^[0-9][0-9]") == null )
    { showmessage = true;  Errormessage += "A valid Expiration Number is required. \r\n"; }
        
    if (tbURL.value == "")
    { showmessage = true;  Errormessage += "The AssureSign URL is required. \r\n"; }

    if (showmessage)
     { alert(Errormessage);  allowsave = false;  }
	
	 
	//if all variables are in correct format
	if (allowsave){
		 if (confirm('Are you sure you want to save this default information?'))
         {
         	//showDemoLoadingShim()
			var saveConfigurationValues = $S('.saveConfigurationValues')[0];
			saveConfigurationValues.onclick(); 
         }

	}else{

	}
} 

var tagsLoadingShim = null;
showTagsLoadingShim = function() 
{
	try { 		 	
		//if (!tagsLoadingShim)
		//{
			tagsLoadingShim = $S('.templateContent .loadingPanel')[0].cloneNode(true);
		//}
		$S('.tagListdiv')[0].appendChild(tagsLoadingShim);
		if (BrowserDetect.isIE6()) { $D.setStyle(tagsLoadingShim, 'height', '300em'); } 
	} 
	catch(e) {alert(e);} 
}
hideTagsLoadingShim = function() 
{ 
	try { $S('.tagListdiv')[0].removeChild(tagsLoadingShim); } catch(e) {} 
}

var demoLoadingShim = null;
showDemoLoadingShim = function() 
{ 	
	try { 
		if (!demoLoadingShim)
		{
			demoLoadingShim = (BrowserDetect.isIE6()) ? $S('.templateContent .loadingPanelIE6')[0].cloneNode(true) : $S('.templateContent .loadingPanel')[0].cloneNode(true);
		}
		$S('.configSectionWrapper')[0].appendChild(demoLoadingShim);
		if (BrowserDetect.isIE6()) { $D.setStyle(demoLoadingShim, 'height', '31em'); }			
	} 
	catch(e) {} 
}
hideDemoLoadingShim = function() 
{ 
	try { $S('.configSectionWrapper')[0].removeChild(demoLoadingShim);	} catch(e) {} 
}

var holder="";

function toggleDiv(id)
{
	if (holder != "")
	{
		document.getElementById(holder).style.display = 'none';
	}
	
	document.getElementById(id).style.display = 'block';
	holder = id;
}