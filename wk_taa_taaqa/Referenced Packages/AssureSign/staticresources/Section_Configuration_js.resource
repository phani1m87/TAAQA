if(typeof ASD=="undefined"||!ASD) { var ASD = {}; }

var $Y = YAHOO;
var $YD = YAHOO.util.Dom;
var $YE = YAHOO.util.Event;
var $ = $YD.get;
var $S = DomQuery.select;

ASD.PageController = function(config)
{
    this.config = config || {};
};
ASD.ConfigurationPage = function(config)
{
	ASD.ConfigurationPage.superclass.constructor.call(this, config);
	this.initPage();
};
$Y.extend(ASD.ConfigurationPage, ASD.PageController);
ASD.ConfigurationPage.prototype.initPage = function()
{
	this.defaultExpirationSelect = $S('.slDefaultExpiration', '.configSection')[0];
	this.defaultExpirationText = $S('.defexpiration', '.configSection')[0];

	if (this.defaultExpirationSelect.options[this.defaultExpirationSelect.selectedIndex].text == 'AssureSign Default Expiration')
		this.defaultExpirationText.style.display = 'none';
	else
		this.defaultExpirationText.style.display = 'block';
		
	$YE.addEventHandler(this.defaultExpirationSelect, "change", this.showHideDiv, this);
};
ASD.ConfigurationPage.prototype.showHideDiv = function()
{
	this.slDefaultExpiration = $S('.slDefaultExpiration', '.configSection')[0];
	this.defaultExpirationText = $S('.defexpiration', '.configSection')[0];
    
    if(this.slDefaultExpiration.selectedIndex == 0)
        this.defaultExpirationText.style.display = "none";
    else
        this.defaultExpirationText.style.display = "block";
};
    
configurationPageInit = function() { 
	
	var c = {};
	c.contentEl = $S('.configSection')[0];
	
	c.pages = 
	{
		configPage: new ASD.ConfigurationPage()
	};
	c.initialPage = c.pages.configPage;
	
	ASD.configPageController = new ASD.ConfigurationPage(c); 
};

$YE.addEventHandler(window, "load", configurationPageInit);

