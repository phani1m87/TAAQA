if(typeof ASD=="undefined"||!ASD) { var ASD = {}; }

var $Y = YAHOO;
var $YD = YAHOO.util.Dom;
var $YE = YAHOO.util.Event;
var $ = $YD.get;
var $S = DomQuery.select;

/////////////
//Exception//
/////////////
ASD.Exception = function(type, details, source)
{
    this.type = type;
    this.details = details;
    this.source = source;
};

//////////////////
//PageController//
//////////////////
ASD.PageController = function(config)
{
    this.config = config || {};
    this.navigateEvent = new CustomEventEx("navigateEvent");
};
ASD.PageController.prototype.getEl = function() { throw new ASD.Exception('NotImplementedException', null, 'PageController.getEl()'); }
ASD.PageController.prototype.tabActivatedHandler = function() { return; };
ASD.PageController.prototype.preRender = function() { return; };
ASD.PageController.prototype.dispose = function() { this.navigateEvent.unsubscribeAll(); };

/////////////////
//TabController//
/////////////////
ASD.TabController = function(config)
{
    this.config = config || {};
	
	this.settings = {};
	if (config.contentEl) { this.settings.contentEl = (typeof config.contentEl === 'string') ? $S(config.configEl)[0] : config.contentEl; } else { throw new ASD.Exception('MissingContentElException', 'config.contentEl', 'TabController.Constructor()'); }
	if (config.tabEl) { this.settings.tabEl = (typeof config.tabEl === 'string') ? $$(config.tabEl)[0] : config.tabEl; } else { throw new ASD.Exception('MissingTabElException', 'config.tabEl', 'TabController.Constructor()'); }
	
	this.asdContent = $S('.asdContent', '.asdControl')[0];
	this.asdContent.style.display = "block";
	
    this.state = {};
    if (config.pages) { this.state.pages = config.pages; } else { throw new ASD.Exception('MissingPagesException', 'config.pages', 'TabController.Constructor()'); }

    this.tabActivatedEvent = new CustomEventEx("tabActivatedEvent");
        
	for (var pageName in this.state.pages)
    {
        var page = this.state.pages[pageName];
        page.sharedState = this.state;
        if (page.navigateEvent && page.navigateEvent.subscribeHandler) { page.navigateEvent.subscribeHandler(this.navigateToPage, this); }
        if (page.tabActivatedHandler) { this.tabActivatedEvent.subscribeHandler(page.tabActivatedHandler, page); }
    }

    if (this.settings.tabEl) { $YE.addEventHandler(this.settings.tabEl, 'click', this.onTabActivated, this); }
        
    if (config.initialPage) { this.navigateToPage(config.initialPage); } else { throw new ASD.Exception('MissingInitialPageException', 'config.initialPage', 'TabController.Constructor()'); }
};
ASD.TabController.prototype.onTabActivated = function() { this.tabActivatedEvent.fire(); };
ASD.TabController.prototype.navigateToPage = function(page)
{
    if (!page) { return; }
	
    if (this.state.currentPage) { this.state.currentPage.getEl().style.display = "none"; }

    this.state.currentPage = page;
    
    if (page.preRender) { page.preRender(); }
    
    page.getEl().style.display = "block";
};
//////////////////////////////////
//AppDetailsDocSetupTemplatePage//
//////////////////////////////////
ASD.AppDetailsDocSetupTemplatePage = function(config)
{
	ASD.AppDetailsDocSetupTemplatePage.superclass.constructor.call(this, config);
	
	this.next = $S('.setup_template_Next', this.getEl())[0];
	
	$YE.addEventHandler(this.next, "click", this.loadNextPage, this);
	
	this.sfAttachment = $S('.docTypeRadio input', this.getEl());
	
	var s = this.settings = {};
	if (BrowserDetect.isIE6()) { s.loadingEl = $S('.asdControl .templateContent .loadingPanelIE6')[0].cloneNode(true); }
	else { s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true); }
	
	this.tab = $S('.tabTwo', '.asdControl')[0];
	$YE.addEventHandler(this.tab, "click", this.loadTemplates, this);

	this.initPage();
	
	$YE.addEventHandler(document, "click", function(e)
	{
		var targetEl = $YE.getTarget(e);
		var calEl = $S('#cal1Container', 'asdTemplateTabContent')[0];
		var btnEl = $S('.asdContent .calendarbutton')[0];
 
	    if (targetEl != calEl && !$YD.isAncestor(calEl, targetEl) && targetEl != btnEl && !$YD.isAncestor(btnEl, targetEl)) { 
	        this.hideExpirationDateCalendar();
	    } 
	}, this); 
	
};
$Y.extend(ASD.AppDetailsDocSetupTemplatePage, ASD.PageController);
ASD.AppDetailsDocSetupTemplatePage.prototype.initPage = function()
{
	if (this.defaultExpirationSelect)
		this.dispose();
		
	$YE.addEventHandler($S('.asdContent .calendarbutton')[0], "click", this.showExpirationDateCalendar, this);	
	
	this.docSection = $S('.docSection')[0];
	this.defaultExpirationSelect = $S('.slDefExpiration', '.docSection')[0];
	this.defaultExpirationText = $S('.defexpiration', '.docSection')[0];
	this.defaultExpirationText.style.display = 'block';
	
	var currentDate = new Date();
	var expirationDateText2 = $S('.expirationDateText2', '.asdTemplateTabContent')[0];
	var expirationDateText = $S('.expirationDateText', '.asdTemplateTabContent')[0];
	var submitexpirationdate = $S('.submitexpirationdate','.asdTemplateTabContent')[0];
	
	if(expirationDateText) {
		if (expirationDateText.value == "") {
			expirationDateText.value = expirationDateText2.value;
			submitexpirationdate.innerHTML = expirationDateText2.value;
		}
		var expDate = expirationDateText.value.split('-');
			
		this.expirationDateCalendar = new YAHOO.widget.Calendar("expriationDateCalendar", "cal1Container",
		{ 
			mindate: (currentDate.getMonth()+1 +"/"+ currentDate.getDate() +"/"+ currentDate.getFullYear()), 
			pagedate: (expDate[1] + '/' + expDate[0]), 
			selected: (expDate [1] + '/' + expDate[2] + '/' + expDate[0]),
			close: true
		});
		this.expirationDateCalendar.selectEvent.subscribe(this.expirationDateSelectedHandler, this);
		this.expirationDateCalendar.render();
	}
	
	this.cbParseDocument = $S('.cbParseDocument', this.asdTabContent)[0];
	this.cbParseDocumentText = $S('.templateLabelTextCb', this.asdTabContent)[0];
	this.sfAttachment = $S('.docTypeRadio input', this.getEl());
	$YE.addEventHandler(this.sfAttachment, "click", this.setParseDocument, this);	
	
	//this.apiServerURLTemp =  $S('.apiServerURLTemp', this.asdTabContent)[0];
	//this.apiServerURL =  $S('.apiServerURL', this.asdTabContent)[0];
	//this.parseDocumentSetting = $S('.parseDocumentSetting', this.asdTabContent)[0];
	this.setParseDocument();
	
	//alert (this.defaultExpirationSelect.options[this.defaultExpirationSelect.selectedIndex].text);
	if (this.defaultExpirationSelect.options[this.defaultExpirationSelect.selectedIndex].text == 'AssureSign Default')
	{
		this.defaultExpirationText.style.display = 'none';
		expirationDateText.value = "";
	}
	else
		this.defaultExpirationText.style.display = 'block';
		
	$YE.addEventHandler(this.defaultExpirationSelect, "change", this.showHideDiv, this);
};
ASD.AppDetailsDocSetupTemplatePage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupTemplatePage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupTemplatePage.prototype.updateState = function() 
{
	ASD.AppDetailsDocSetupTemplatePage.superclass.updateState.call(this);
};

ASD.AppDetailsDocSetupTemplatePage.prototype.templateSelectedHandler = function()
{
	var templateEl = $S('.setup_templateSelect', this.getEl())[0];
	var nameEl = $S('.templateDocNameText', this.getEl())[0];
	try 
	{
		if (!nameEl.value || (nameEl.value.length === 0))
		{
			nameEl.value = templateEl.options[templateEl.selectedIndex].text;
		}
	}
	catch (e) { }
};
ASD.AppDetailsDocSetupTemplatePage.prototype.loadDefaultAttachment = function() 
{
	this.defaultAttachment = $S('.defaultAttachment', this.getEl())[0];
	if (this.defaultAttachment.value == "asdDoc")
		this.sfAttachment[0].checked = true;
	if (this.defaultAttachment.value == "sfAttach")
		this.sfAttachment[1].checked = true;
	if (this.defaultAttachment.value == "sfDoc")
		this.sfAttachment[2].checked = true;
		
	if(this.sfAttachment[0].checked == true) {
		this.cbParseDocument.checked = false;
		this.cbParseDocumentText.style.color = "#888888";
		this.cbParseDocument.disabled = true;
	}
};

ASD.AppDetailsDocSetupTemplatePage.prototype.loadParseDocument = function() 
{
	this.parseDocumentSetting = $S('.parseDocumentSetting', this.getEl())[0];
	this.parseDocumentContainer = $S('.parseDocumentContainer', this.getEl())[0];
	if(this.parseDocumentSetting.value == "Yes") {
		this.parseDocumentContainer.style.display = "block";
	}
	else {
		this.parseDocumentContainer.style.display = "none";
	}
};

ASD.AppDetailsDocSetupTemplatePage.prototype.loadDefaultExpiration = function() 
{
	var defaultExpirationSetting = $S('.defaultExpirationSetting', this.getEl())[0];
	var defaultExpirationSelect = $S('.slDefExpiration', '.docSection')[0];
	var expirationDateText = $S('.expirationDateText', '.asdTemplateTabContent')[0];
	var submitexpirationdate = $S('.submitexpirationdate','.asdTemplateTabContent')[0];
	this.defaultExpirationText = $S('.defexpiration', '.docSection')[0];
	if(defaultExpirationSetting.value == "assuresignDefExp") {
		defaultExpirationSelect.selectedIndex = 0;
		this.defaultExpirationText.style.display = 'none';
		expirationDateText.value = '';
	}
	else {
		defaultExpirationSelect.selectedIndex = 1;
		this.defaultExpirationText.style.display = 'block';
		expirationDateText.value = submitexpirationdate.innerHTML;
	}
};

ASD.AppDetailsDocSetupTemplatePage.prototype.setParseDocument = function() { 
	this.templateLabelText = $S('.templateLabelText', this.getEl());
	this.parseDocumentSetting = $S('.parseDocumentSetting', this.getEl())[0];
	
	if(this.parseDocumentSetting != null) {
		if(this.parseDocumentSetting.value == "Yes") {
			if(this.sfAttachment[0].checked == true) {
				this.cbParseDocument.disabled = true;
				this.cbParseDocumentText.style.color = "#888888";
				this.templateLabelText.disabled = true;
				this.cbParseDocument.checked = false;
			}
			else {
				this.cbParseDocument.disabled = false;
				this.cbParseDocumentText.style.color = "#333333";
				this.templateLabelText.disabled = false;
			}
		}
	}
};
ASD.AppDetailsDocSetupTemplatePage.prototype.validatePage = function() { 
	var isValid = true;
	this.validateText = $S('.validationText', this.getEl())[0];
	this.validateText.innerHTML = '';
	
	this.templateSelect = $S('.setup_templateSelect', this.asdTabContent)[0];
	this.passwordRequired = this.templateSelect.value.split(";")[3];
	
	this.templateDocNameText = $S('.templateDocNameText', this.getEl())[0];
	this.expirationDateText = $S('.expirationDateText', this.getEl())[0];
	this.templatePasswordText = $S('.templatePasswordText', this.getEl())[0];
	
	if(this.templateDocNameText.value == '') {
		this.validateText.innerHTML = '<span>- Please enter a document name</span><br/>';
		isValid = false;
	}
	//Commented out for Default Expiration- May no longer need this
	//if(this.expirationDateText.value == '') {
		//this.validateText.innerHTML += '<span>- Please enter an expiration date</span><br/>';
		//isValid = false;
	//}
	if(this.passwordRequired != null) {
		if(this.passwordRequired == 'true') {
			if(this.templatePasswordText.value == '') {
				this.validateText.innerHTML += '<span>- Please enter a document password</span><br/>';
				isValid = false;
			}
		}
	}
	else {
		this.validateText.innerHTML += '<span>- Please select a template</span><br/>';
		isValid = false;
	}
	return isValid;
};
ASD.AppDetailsDocSetupTemplatePage.prototype.loadNextPage = function() { 
	//this.apiServerURLTemp =  $S('.apiServerURLTemp', this.getEl());
	//this.apiServerURL =  $S('.apiServerURL', this.getEl())[0];
	//if(this.apiServerURL != null && this.apiServerURLTemp != null) {
	//	this.apiServerURL.value = this.apiServerURLTemp.value;
	//}
	
	//validated = true;
	//this.validatePage();
	if (this.validatePage() == true) {
		this.asdTemplateTabContent = $S('.asdTemplateTabContent', this.getEl())[0];
		this.templateRerenderForm =  $S('.templateRerenderForm')[0];
		this.templateRerenderForm.ondblclick();
		this.sfAttachment = $S('.docTypeRadio input', this.getEl());
		if(this.sfAttachment[1].checked == true) {
			this.sharedState.pages.sfAttachPage.initialize();
			this.navigateEvent.fire(this.sharedState.pages.sfAttachPage);
		}
		else if(this.sfAttachment[2].checked == true) {
			this.sharedState.pages.sfDocPage.initialize();
			this.navigateEvent.fire(this.sharedState.pages.sfDocPage);
		}
		else {
			ASD.detailsTabController.state.pages.paramPage.showLoadingShim();
			this.navigateEvent.fire(this.sharedState.pages.paramPage);
		}
		this.dispose();
	}
};

ASD.AppDetailsDocSetupTemplatePage.prototype.processTemplateData = function()
{
	this.sfAttachment = $S('.docTypeRadio input', this.getEl());
	if(this.sfAttachment[0].checked == true) {
		window.setTimeout(as_setRender1,1);
	}
};
ASD.AppDetailsDocSetupTemplatePage.prototype.loadTemplates = function()
{
	this.asdTabContent = $S('.asdTemplateTabContent', this.getEl())[0];
	this.templateSelect = $S('.setup_templateSelect', this.asdTabContent)[0];
	if(this.templateSelect) {
		if(this.templateSelect.options.length <= 1) {
			this.showLoadingShim();
			window.setTimeout(as_setTemplateRender,1);
		}
	}
};
ASD.AppDetailsDocSetupTemplatePage.prototype.showLoadingShim = function() 
{ 	
	try { 
		$S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); 
		$D.setStyle(this.settings.loadingEl, 'height', '33em'); 
	} 
	catch(e) {} 
}
ASD.AppDetailsDocSetupTemplatePage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }
ASD.AppDetailsDocSetupTemplatePage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupTemplate')[0];
	}
	return this.El;
};
ASD.AppDetailsDocSetupTemplatePage.prototype.getContentType = function() {
	return "tab2";
};
ASD.AppDetailsDocSetupTemplatePage.prototype.expirationDateSelectedHandler = function(type, args, obj)
{
	var dates = args[0];
	var date = dates[0];
	var year = date[0], month = date[1], day = date[2];
	var txtDate1 = $S('.submitexpirationdate','.asdTemplateTabContent')[0];
	var txtDate2 = $S('.expirationDateText', '.asdTemplateTabContent')[0];

	day = day.toString();
	if (day.length <= 1){ day = "0" + day; }
	
	month = month.toString();
	if (month.length <= 1){ month = "0" + month; }
	
	txtDate1.innerHTML = year + "-" + month + "-" + day;
	txtDate2.value = year + "-" + month + "-" + day;
	
	obj.hideExpirationDateCalendar();
};
ASD.AppDetailsDocSetupTemplatePage.prototype.showExpirationDateCalendar = function()
{
	var cal = $S('.asdContent #cal1Container')[0];
	cal.style.display = 'block';
};
ASD.AppDetailsDocSetupTemplatePage.prototype.hideExpirationDateCalendar = function()
{
	var cal = $S('.asdContent #cal1Container')[0];
	cal.style.display = 'none';
};

ASD.AppDetailsDocSetupTemplatePage.prototype.showHideDiv = function()
{
	var expirationDateText = $S('.expirationDateText', '.asdTemplateTabContent')[0];
	var submitexpirationdate = $S('.submitexpirationdate', '.asdTemplateTabContent')[0];
	
    var divstyle = new String();
    divstyle = document.getElementById("default_expiration").style.display;
    if(divstyle.toLowerCase()=="block" || divstyle == "")
    {
        document.getElementById("default_expiration").style.display = "none";
        expirationDateText.value = "";
    }
    else
    {
        document.getElementById("default_expiration").style.display = "block";
        expirationDateText.value = submitexpirationdate.innerHTML;
    }
};
ASD.AppDetailsDocSetupTemplatePage.prototype.dispose = function()
{
	$E.purgeElement(this.defaultExpirationSelect);
};
///////////////////////////////////
//AppDetailsDocSetupParameterPage//
///////////////////////////////////
ASD.AppDetailsDocSetupParameterPage = function(config)
{
	var s = this.settings = {};
	if (BrowserDetect.isIE6()) { s.loadingEl = $S('.asdControl .templateContent .loadingPanelIE6')[0].cloneNode(true); }
	else { s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true); }
	
	this.previous = $S('.setup_params_Previous', this.getEl())[0];
	this.next = $S('.setup_params_Next', this.getEl())[0];
	
	$YE.addEventHandler(this.previous, "click", this.loadPreviousPage, this);
	$YE.addEventHandler(this.next, "click", this.loadNextPage, this);
	
	ASD.AppDetailsDocSetupParameterPage.superclass.constructor.call(this, config);
};

$Y.extend(ASD.AppDetailsDocSetupParameterPage, ASD.PageController);

ASD.AppDetailsDocSetupParameterPage.prototype.AssignParametersOnDblClick = function()
{
	this.AssignParameters();
}

ASD.AppDetailsDocSetupParameterPage.prototype.initParams = function()
{
	if (this.button) { $YE.purgeElement(this.button); }
	this.button = $S('.setup_button', this.getEl())[0];
	$YE.addEventHandler(this.button, "click", this.AssignParameters, this);
	
	this.paramtextboxes =  $S('input.setup_paramtextboxes');
	this.parameterchooserlist = $S('.setup_parameterchooserlist', this.getEl())[0];
	
	this.sfAttachment = $S('.docTypeRadio input', '.setupTemplate');
	
	var i = 0;
	for (i = 0; i < this.paramtextboxes.length; i++){
		$YE.addEventHandler(this.paramtextboxes[i], "focus", this.focusHandler, {controller:this,el:this.paramtextboxes[i] });
	}

	this.fnTXTFocus(this.paramtextboxes[0]);
	
	//required fields
	this.paramValueItems = $S('.paramValueWrapperItems', this.getEl());
	for (i = 0; i < this.paramValueItems.length; i++){
		paramValueItem = $S('.paramValueWrapperItem_row_' + i, '.setup_paramsDatatable')[0];
		var rowRequiredValue= $S('.setup_paramrequiredboxes_row_' + i, '.paramValueWrapperItem_row_' + i)[0].innerHTML;
		
		if (rowRequiredValue == 'false'){
			requiredblock = $S('.requiredBlock_row_' + i, '.paramValueWrapperItem_row_' + i);
			$YD.removeClass(requiredblock,'requiredBlock');
		}
	}
};
ASD.AppDetailsDocSetupParameterPage.prototype.showLoadingShim = function() 
{ 	
	try { 
		$S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); 
		$D.setStyle(this.settings.loadingEl, 'height', '33em'); 
	} 
	catch(e) {} 
}
ASD.AppDetailsDocSetupParameterPage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }
ASD.AppDetailsDocSetupParameterPage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupParameterPage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupParameterPage.prototype.updateState = function() 
{ 
	ASD.AppDetailsDocSetupParameterPage.superclass.updateState.call(this);
};
ASD.AppDetailsDocSetupParameterPage.prototype.loadPreviousPage = function() { 
	if(this.sfAttachment[1].checked == true) {
		this.navigateEvent.fire(this.sharedState.pages.sfAttachPage);
	}
	else if(this.sfAttachment[2].checked == true) {
		this.navigateEvent.fire(this.sharedState.pages.sfDocPage);
	}
	else {
		ASD.detailsTabController.state.pages.templatePage.loadParseDocument();
		this.navigateEvent.fire(this.sharedState.pages.templatePage);
	}
};

ASD.AppDetailsDocSetupParameterPage.prototype.okay = function() { 
	this.el.ondblclick();
};

ASD.AppDetailsDocSetupParameterPage.prototype.loadNextPage = function() { 

	var valid = true;
	
	//check required fields
	for (i = 0; i < this.paramValueItems.length; i++){
		requiredRow= $S('.setup_paramrequiredboxes')[i];
		paramRowTextBox = $S('.setup_paramtextboxes')[i];
		var regexContainer = $S('.setup_paramregex')[i];
		var validationMessageContainer =  $S('.setup_paramvalidationmessage')[i];
		
		var isRequired = requiredRow.innerHTML;
		var isEmpty = (paramRowTextBox.value == '');
		 
		requiredTextField = $S('.requiredFieldInput')[i];
		$YD.addClass(requiredTextField,'requiredFieldInputHide');
		validationMessageContainer.style.display = "none";
		
		//check for parameter validation and evaluate as necessary
		if (regexContainer.innerHTML != "")
		{
			if (isRequired == 'false' && (isEmpty == 'true' || isEmpty == true))
				valid = true;
			else if (this.validateParameter (regexContainer.innerHTML, paramRowTextBox.value) != true) {
				validationMessageContainer.style.display = "block";
				valid = false;
			}
		}
		else if (isRequired == 'true')
		{
			//both conditions are evaluated due to inconsistent and incorrect results when evaluating only one
			if (isEmpty == 'true' || isEmpty == true)
			{
				valid = false;
				$YD.removeClass(requiredTextField,'requiredFieldInputHide');
			}
		}
	}
	
	if (valid)
	{
		this.serverUrlMain = $S('.serverUrlMain', this.getEl())[0];
		var serverUrl = this.serverUrlMain.innerHTML;
		window.setTimeout(function() { as_setRender2(serverUrl); },1);
		
		this.sharedState.pages.summaryPage.initSummaryDetails();
		this.navigateEvent.fire(this.sharedState.pages.summaryPage);
	}
};
ASD.AppDetailsDocSetupParameterPage.prototype.validateParameter = function(regex, parameter) {
	var re = new RegExp(regex);
	if (parameter.match(re)) {
	    return true;
	} else {
	    return false;
	}
};
ASD.AppDetailsDocSetupParameterPage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupParams')[0];
	}
	return this.El;
};
ASD.AppDetailsDocSetupParameterPage.prototype.getContentType = function() {
	return "tab2";
};
ASD.AppDetailsDocSetupParameterPage.prototype.AssignParameters = function(){	
	this.parameterchooserlist = $S('.parameterchooserlist', this.getEl())[0];
	this.customtableshow =  $S('.customtableshow', this.getEl())[0];
	
	if (this.parameterchooserlist != null){
		if (this.parameterchooserlist.tagName == 'select'|| this.parameterchooserlist.tagName =='SELECT'){
			if (this.parameterchooserlist.options.length < 1){
				this.customtableshow.value = '';
			}else{
				this.customtableshow.value = this.parameterchooserlist.options[0].text;
			}
			var id = this.customtableshow.className.split("_")[4].split(" ")[0];
			
			if ((this.paramtextboxes.length -1) > parseInt(id) && this.customtableshow.value != ''){
				this.fnTXTFocus(this.paramtextboxes[parseInt(id) + 1]);
			}
		}
	}
};
ASD.AppDetailsDocSetupParameterPage.prototype.focusHandler = function(){	
	this.controller.fnTXTFocus(this.el);
};
ASD.AppDetailsDocSetupParameterPage.prototype.fnTXTFocus = function(el){	
	if (el){
		var arr = new Array(); 
		arr = this.paramtextboxes;	
			
		//loop and remove any selections
		for(var i=0; i < arr.length; i++)
		{
			var inputTXT = arr[i];
			inputTXT.style.borderColor = "";
			$YD.removeClass(inputTXT,'customtableshow');
		}
	    el.style.borderColor = "#006699";
	    $YD.addClass(el,'customtableshow');
	    el.focus();
	}
};

//////////////////////////////////
//AppDetailsDocSetupSummaryPage///
//////////////////////////////////
ASD.AppDetailsDocSetupSummaryPage = function(config)
{		   
	ASD.AppDetailsDocSetupSummaryPage.superclass.constructor.call(this, config);
	this.previous = $S('.setup_review_Previous', this.getEl())[0];
	this.submit = $S('.setup_review_Submit', this.getEl())[0];

	$YE.addEventHandler(this.previous, "click", this.loadPreviousPage, this);
	$YE.addEventHandler(this.submit, "click", this.loadNextPage, this);
	
	var s = this.settings = {};
	if (BrowserDetect.isIE6()) { s.loadingEl = $S('.asdControl .templateContent .loadingPanelIE6')[0].cloneNode(true); }
	else { s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true); }
	
	this.templateSelect = $S('.setup_templateSelect', '.asdTemplateTabContent')[0];
	this.tab = $S('.asdControl .tabTwo')[0];
};
$Y.extend(ASD.AppDetailsDocSetupSummaryPage, ASD.PageController);
ASD.AppDetailsDocSetupSummaryPage.prototype.initSummaryDetails = function()
{
	this.templateNameSummary = $S('.setup_templateSelect', '.setupTemplate')[0];
	this.templateNameText = this.templateNameSummary.options[this.templateNameSummary.selectedIndex].text;
	this.templateNameLabel = $S('.templateNameSummary', '.reviewDetailsRenderPanel')[0];
	this.templateNameLabel.innerHTML = this.templateNameText;
	
	this.templateDocNameSummary = $S('.templateDocNameText', '.setupTemplate')[0];
	this.templateDocNameText = this.templateDocNameSummary.value;
	this.templateDocNameLabel = $S('.documentNameSummary', '.reviewDetailsRenderPanel')[0];
	this.templateDocNameLabel.innerHTML = this.templateDocNameText;
	
	this.templateOrderNumberSummary = $S('.templateOrderNumberText', '.setupTemplate')[0];
	this.templateOrderNumberText = this.templateOrderNumberSummary.value;
	this.templateOrderNumberLabel = $S('.orderNumberSummary', '.reviewDetailsRenderPanel')[0];
	this.templateOrderNumberLabel.innerHTML = this.templateOrderNumberText;
	
	this.templatePasswordSummary = $S('.templatePasswordText', '.setupTemplate')[0];
	this.templatePasswordText = this.templatePasswordSummary.value;
	this.templatePasswordLabel = $S('.passwordSummary', '.reviewDetailsRenderPanel')[0];
	
	if(this.templatePasswordText == '') {
		this.templatePasswordLabel.innerHTML = 'n/a';
	}
	else {
		this.templatePasswordLabel.innerHTML = this.templatePasswordText;
	}
	
	this.expirationDateSummary = $S('.expirationDateText', '.setupTemplate')[0];
	this.expirationDateText = this.expirationDateSummary.value;
	this.expirationDateLabel = $S('.expirationDateSummary', '.reviewDetailsRenderPanel')[0];
	this.expirationDateLabel.innerHTML = (this.expirationDateText == '' || this.expirationDateText == null) ? "AssureSign Default" : this.expirationDateText;
	
	this.attachmentNameSummary = $S('.attachmentName', '.asdSFAttachTabContent')[0];
	this.attachmentNameText = this.attachmentNameSummary.innerHTML;
	this.attachmentNameLabel = $S('.sfAttachmentSummary', '.reviewDetailsRenderPanel')[0];
	
	this.sfDocNameSummary = $S('.sfDocName', '.asdSFDocTabContent')[0];
	this.sfDocNameText = this.sfDocNameSummary.innerHTML;
	this.sfDocNameLabel = $S('.sfDocumentSummary', '.reviewDetailsRenderPanel')[0];
	
	this.docTypeRadio = $S('.docTypeRadio input', '.setupTemplate');
	if(this.docTypeRadio[1].checked == true) {
		this.attachmentNameLabel.innerHTML = this.attachmentNameText;
		this.sfDocNameLabel.innerHTML = "n/a";
	}
	else if(this.docTypeRadio[2].checked == true) {
		this.sfDocNameLabel.innerHTML = this.sfDocNameText;
		this.attachmentNameLabel.innerHTML = "n/a";
	}
	else {
		this.sfDocNameLabel.innerHTML = "n/a";
		this.attachmentNameLabel.innerHTML = "n/a";
	}
	
	this.parseDocumentSummary = $S('.cbParseDocument', '.setupTemplate')[0];
	this.parseDocumentSummaryText = $S('.parseDocumentSummary', '.reviewDetailsRenderPanel')[0];
	if(this.parseDocumentSummary.checked == true){
		this.parseDocumentSummaryText.innerHTML = 'Yes';
	}else{
		this.parseDocumentSummaryText.innerHTML = 'No';
	}
};
ASD.AppDetailsDocSetupSummaryPage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupSummaryPage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupSummaryPage.prototype.updateState = function() 
{
	ASD.AppDetailsDocSetupSummaryPage.superclass.updateState.call(this);
};
ASD.AppDetailsDocSetupSummaryPage.prototype.loadPreviousPage = function() { 
	this.navigateEvent.fire(this.sharedState.pages.paramPage);
		
	//rebind events to parameterlist	
	window.setTimeout(as_setRender1,1);
		
		var paramtextboxes1;
		paramtextboxes1 =  $S('input.setup_paramtextboxes');
		var i = 0;
		for (i = 0; i < paramtextboxes1.length; i++){
			$YE.addEventHandler(paramtextboxes1[i], "focus", this.sharedState.pages.paramPage.focusHandler, {controller:this.sharedState.pages.paramPage,el:paramtextboxes1[i] });
		}
};
ASD.AppDetailsDocSetupSummaryPage.prototype.loadNextPage = function() { 
	window.setTimeout(as_setRender3,1);
	this.navigateEvent.fire(this.sharedState.pages.confirmPage);
}; 
ASD.AppDetailsDocSetupSummaryPage.prototype.showLoadingShim = function() 
{ 	
	try { 
		$S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); 
		$D.setStyle(this.settings.loadingEl, 'height', '33em'); 
	} 
	catch(e) {} 
}
ASD.AppDetailsDocSetupSummaryPage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }
ASD.AppDetailsDocSetupSummaryPage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupReview')[0];
	}
	return this.El;
};
ASD.AppDetailsDocSetupSummaryPage.prototype.getContentType = function() {
	return "tab2";
};

//////////////////////////////////
//AppDetailsDocSetupConfirmPage///
//////////////////////////////////
ASD.AppDetailsDocSetupConfirmPage = function(config)
{		   
	ASD.AppDetailsDocSetupConfirmPage.superclass.constructor.call(this, config);
	
	this.existingButton = $S('.setup_confirm_existing', this.getEl())[0];
	this.tab = $S('.tabThree', '.asdControl')[0];
	$YE.addEventHandler(this.existingButton, "click", function(e) {
		try {
			var slicedTab = this.tab.id.slice(0,this.tab.id.length-4); 
			if (RichFaces.onTabChange(e, $S('.asdControl .rich-tabpanel')[0].id,slicedTab)) {
				RichFaces.switchTab($S('.asdControl .rich-tabpanel')[0].id, slicedTab, 'name3');
				window.setTimeout(as_setRefreshDocumentList,1);	
				ASD.existingDocsTabController.state.pages.detailsPage.viewList();
			}
		}
		catch(e) {} 
	}, this);
	this.refreshButton = $S('.setup_confirm_refresh', this.getEl())[0];
	$YE.addEventHandler(this.refreshButton, "click", this.refreshPage, this);
};
$Y.extend(ASD.AppDetailsDocSetupConfirmPage, ASD.PageController);
ASD.AppDetailsDocSetupConfirmPage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupConfirmPage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupConfirmPage.prototype.updateState = function() 
{
	ASD.AppDetailsDocSetupConfirmPage.superclass.updateState.call(this);
};
ASD.AppDetailsDocSetupConfirmPage.prototype.refreshPage = function() { 
	window.setTimeout(as_refresh,1);
	
	this.setup_templateSelect = $S('.setup_templateSelect', '.setupTemplate')[0];
	this.setup_templateSelect.selectedIndex = 0;
	
	this.templateDocNameText = $S('.templateDocNameText', '.setupTemplate')[0];
	this.templateDocNameText.value = '';
	this.templateOrderNumberText = $S('.templateOrderNumberText', '.setupTemplate')[0];
	this.templateOrderNumberText.value = '';
	this.templatePasswordText = $S('.templatePasswordText', '.setupTemplate')[0];
	this.templatePasswordText.value = '';
	this.cbParseDocument = $S('.cbParseDocument', '.setupTemplate')[0];
	this.cbParseDocument.checked = false;
	
	this.expirationDateText = $S('.expirationDateText', '.setupTemplate')[0];
	this.expirationDateText2 = $S('.expirationDateText2', '.setupTemplate')[0];
	this.submitexpirationdate = $S('.submitexpirationdate', '.setupTemplate')[0];
	this.expirationDateText.value = this.expirationDateText2.value;
	this.submitexpirationdate.innerHTML = this.expirationDateText2.value;
	
	this.paramtextboxes =  $S('input.setup_paramtextboxes', '.setup_renderParamForm');
	for (i = 0; i < this.paramtextboxes.length; i++){
		this.paramtextboxes[i].value = '';
	}

	this.attachmentRow = $S('.attachmentTable tr');
    for (i = 0; i < this.attachmentRow.length; i++)
    {
    	$YD.removeClass(this.attachmentRow[i],'highlightSelectedElement');
	}
	this.sharedState.pages.sfDocPage.settings.rowSelected = false;
	
	this.sfDocFolderSelect = $S('.sfDocFolderSelect');
	this.sfDocTableRow = $S('.sfDocTable tbody tr');
    for (i = 0; i < this.sfDocTableRow.length; i++)
    {
    	$YD.removeClass(this.sfDocTableRow[i],'highlightSelectedElement');
	}
	this.sharedState.pages.sfDocPage.settings.rowSelected = false;
	this.folderSelect = $S('.sfDocFolderSelect');
	this.folderSelect[0].selectedIndex = 0;
	
	this.navigateEvent.fire(this.sharedState.pages.templatePage);
};
ASD.AppDetailsDocSetupConfirmPage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupConfirm')[0];
	}
	return this.El;
};
ASD.AppDetailsDocSetupConfirmPage.prototype.getContentType = function() {
	return "tab2";
};

///////////////////////////////
//AppDetailsDocSetupSFDocPage//
///////////////////////////////
ASD.AppDetailsDocSetupSFDocPage = function(config)
{		   
	ASD.AppDetailsDocSetupSFDocPage.superclass.constructor.call(this, config);
	
	this.previous = $S('.setup_sfDoc_Previous', this.getEl())[0];
	this.next = $S('.setup_sfDoc_Next', this.getEl())[0];
	$YE.addEventHandler(this.previous, "click", this.loadPreviousPage, this);
	$YE.addEventHandler(this.next, "click", this.loadNextPage, this);

	this.folderSelect = $S('.sfDocFolderSelect', this.getEl())[0];
	$YE.addEventHandler(this.folderSelect, "change", this.showLoadingShim, this);
	
	var s = this.settings = {};
	if (BrowserDetect.isIE6()) { s.loadingEl = $S('.asdControl .templateContent .loadingPanelIE6')[0].cloneNode(true); }
	else { s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true); }
	s.rowSelected = false;
	this.sfDocName = $S('.sfDocName', this.getEl())[0];
	
	this.initialize();
};
$Y.extend(ASD.AppDetailsDocSetupSFDocPage, ASD.PageController);
ASD.AppDetailsDocSetupSFDocPage.prototype.initialize = function()
{
	
	var selectedDocumentId = this.selectedDocumentId;
	var that = this;
	
	var sfDocTableLinks = $S('.sfDocTable td a', this.getEl());
	var sfDocTableRow = $S('.sfDocTable tbody tr', this.getEl());	
	if (sfDocTableLinks)
	{
		for (var i = 0; i < sfDocTableLinks.length; i++)
		{
			var idEl = $S('input.id', sfDocTableLinks[i])[0];
			$YE.addEventHandler(sfDocTableRow[i], 'click', function() { 
					var ctlr = this.controller;
					this.sfDocValidate = $S('.sfDocValidateShow', '.setupSFDoc')[0];
					$YD.removeClass(this.sfDocValidate,'sfDocValidateShow');
					$YD.addClass(this.sfDocValidate,'sfDocValidateHide');
					that.selectedDocumentId = this.id;
					var tempId = that.selectedDocumentId.split('|');
					that.sfDocName.innerHTML = tempId[2];
					this.controller.setSelectedRow();
			}, { controller: this, id: idEl.value });
		}
	}	
};
ASD.AppDetailsDocSetupSFDocPage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupSFDocPage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupSFDocPage.prototype.updateState = function() 
{
	ASD.AppDetailsDocSetupSFDocPage.superclass.updateState.call(this);
};
ASD.AppDetailsDocSetupSFDocPage.prototype.loadPreviousPage = function() { 
	ASD.detailsTabController.state.pages.templatePage.loadParseDocument();
	this.navigateEvent.fire(this.sharedState.pages.templatePage);
};
ASD.AppDetailsDocSetupSFDocPage.prototype.loadNextPage = function() { 
	if (this.settings.rowSelected == true) {
		this.navigateEvent.fire(this.sharedState.pages.paramPage);
		var selectedDocumentId = this.selectedDocumentId;
		
		window.setTimeout(function() { as_assignSfDocId(selectedDocumentId); },1);
	}
	else {
		this.sfDocValidate = $S('.sfDocValidateHide', this.getEl())[0];
		$YD.removeClass(this.sfDocValidate,'sfDocValidateHide'); 
		$YD.addClass(this.sfDocValidate,'sfDocValidateShow'); 
	}
	
};
ASD.AppDetailsDocSetupSFDocPage.prototype.setSelectedRow = function() { 
	this.settings.rowSelected = true;
};
ASD.AppDetailsDocSetupSFDocPage.prototype.showLoadingShim = function() 
{ 	
	try { 
		$S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); 
		$D.setStyle(this.settings.loadingEl, 'height', '33em'); 
	} 
	catch(e) {} 
};
ASD.AppDetailsDocSetupSFDocPage.prototype.hideLoadingShim = function() { 
	try { 
		$S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); 
	} 
	catch(e) {} 
};

ASD.AppDetailsDocSetupSFDocPage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupSFDoc')[0];
	}
	return this.El;
};
ASD.AppDetailsDocSetupSFDocPage.prototype.getContentType = function() {
	return "tab2";
};

//////////////////////////////////
//AppDetailsDocSetupSFAttachPage//
//////////////////////////////////
ASD.AppDetailsDocSetupSFAttachPage = function(config)
{		   
	ASD.AppDetailsDocSetupSFAttachPage.superclass.constructor.call(this, config);
	this.previous = $S('.setup_sfAttach_Previous', this.getEl())[0];
	this.next = $S('.setup_sfAttach_Next', this.getEl())[0];
	
	$YE.addEventHandler(this.previous, "click", this.loadPreviousPage, this);
	$YE.addEventHandler(this.next, "click", this.loadNextPage, this);

	var s = this.settings = {};
	s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true);
	s.rowSelected = false;
	this.attachmentName = $S('.attachmentName', this.getEl())[0];
	
	this.initialize();
};
$Y.extend(ASD.AppDetailsDocSetupSFAttachPage, ASD.PageController);
ASD.AppDetailsDocSetupSFAttachPage.prototype.initialize = function()
{
	
	var selectedAttachmentId = this.selectedAttachmentId;
	var that = this;
	
	//attach table events
	var attachmentLinks = $S('.attachmentTable td a', this.getEl());
	var attachmentRow = $S('.attachmentTable tbody tr', this.getEl());
	
	if (attachmentLinks)
	{
		for (var i = 0; i < attachmentLinks.length; i++)
		{
			var idEl = $S('input', attachmentLinks[i])[0];
			$YE.addEventHandler(attachmentRow[i], 'click', function() { 
					var ctlr = this.controller;
					this.sfAttachValidate = $S('.sfAttachValidateShow', '.setupSFAttach')[0];
					$YD.removeClass(this.sfAttachValidate,'sfAttachValidateShow');
					$YD.addClass(this.sfAttachValidate,'sfAttachValidateHide');
					that.selectedAttachmentId = this.id;
					var tempId = that.selectedAttachmentId.split('|');
					that.attachmentName.innerHTML = tempId[2];
					this.controller.setSelectedRow();
			}, { controller: this, id: idEl.value });
		}
	}
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.setSelectedRow = function() { 
	this.settings.rowSelected = true;
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.loadFromState = function()
{
	ASD.AppDetailsDocSetupSFAttachPage.superclass.loadFromState.call(this);
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.updateState = function() 
{
	ASD.AppDetailsDocSetupSFAttachPage.superclass.updateState.call(this);
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.loadPreviousPage = function() { 
	ASD.detailsTabController.state.pages.templatePage.loadParseDocument();
	this.navigateEvent.fire(this.sharedState.pages.templatePage);
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.loadNextPage = function() { 
	if (this.settings.rowSelected == true) {
		this.navigateEvent.fire(this.sharedState.pages.paramPage);
		var selectedAttachmentId = this.selectedAttachmentId;
		window.setTimeout(function() { as_assignAttachmentId(selectedAttachmentId); },1);
	}
	else {
		this.sfAttachValidate = $S('.sfAttachValidateHide', this.getEl())[0];
		$YD.removeClass(this.sfAttachValidate,'sfAttachValidateHide'); 
		$YD.addClass(this.sfAttachValidate,'sfAttachValidateShow'); 
	}
}; 
ASD.AppDetailsDocSetupSFAttachPage.prototype.getEl = function() {
	if (this.El ==null) {
		this.El = $S('.setupSFAttach')[0];
	}
	return this.El;  
};
ASD.AppDetailsDocSetupSFAttachPage.prototype.getContentType = function() {
	return "tab2";
};

////////////////////////
//ExistingDocsListPage//
////////////////////////
ASD.ExistingDocsListPage = function(config)
{
	ASD.ExistingDocsListPage.superclass.constructor.call(this, config);
	var s = this.settings = {};
	s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true);
};
$Y.extend(ASD.ExistingDocsListPage, ASD.PageController);
ASD.ExistingDocsListPage.prototype.getEl = function()
{
	return $S('.asdControl .listPanel')[0];
};
ASD.ExistingDocsListPage.prototype.tabActivatedHandler = function() 
{
	this.showLoadingShim();
	window.setTimeout(as_setRefreshDocumentList,1);
	this.sharedState.currentPage.navigateEvent.fire(this);
};
ASD.ExistingDocsListPage.prototype.initializeList = function()
{
	this.hideLoadingShim();
	var documentLinks = $S('.documentList td.name a', this.getEl());
	if (documentLinks)
	{
		for (var i = 0; i < documentLinks.length; i++)
		{
			var idEl = $S('input', documentLinks[i])[0];
			$YE.addEventHandler(documentLinks[i], 'click', this.viewDetails, { controller: this, id: idEl.value });
		}
	}
	var orderEls = $S('.documentList td.orderNumber', this.getEl());
	for (var i = 0; i < orderEls.length; i++) { if (!orderEls[i].innerHTML || (orderEls[i].innerHTML.length === 0)) { orderEls[i].innerHTML = "&nbsp;"; } }
};
ASD.ExistingDocsListPage.prototype.viewDetails = function()
{
	var ctlr = this.controller;
	var pg = ctlr.sharedState.pages.detailsPage; 
	pg.showLoadingShim();
	var id = this.id;
	window.setTimeout(function() { as_viewDetailsWithId(id); },1);
	ctlr.navigateEvent.fire(pg);
};
ASD.ExistingDocsListPage.prototype.showLoadingShim = function() { try { $S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); $D.setStyle(this.settings.loadingEl, 'height', '33em'); } catch(e) {} }
ASD.ExistingDocsListPage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }

///////////////////////////
//ExistingDocsDetailsPage//
///////////////////////////
ASD.ExistingDocsDetailsPage = function(config)
{
	ASD.ExistingDocsDetailsPage.superclass.constructor.call(this, config);
	var s = this.settings = {};
	s.returnEl = $S('.toolbarFooter .details_Previous', this.getEl())[0];
	s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true);
	$YE.addEventHandler(s.returnEl, 'click', this.viewList, this);
};
$Y.extend(ASD.ExistingDocsDetailsPage, ASD.PageController);
ASD.ExistingDocsDetailsPage.prototype.getEl = function()
{
	return $S('.asdControl .detailsPanel')[0];
};
ASD.ExistingDocsDetailsPage.prototype.preRender = function()
{
	var detailsFieldEls = $S('.documentDetails ul li span.value', this.getEl());
	if (detailsFieldEls != null) { for (var i = 0; i < detailsFieldEls.length; i++) { detailsFieldEls[i].innerHTML = '&nbsp;'; } }
};
ASD.ExistingDocsDetailsPage.prototype.viewList = function() 
{
	var pg = this.sharedState.pages.listPage;
	pg.showLoadingShim();
	window.setTimeout(as_setRefreshDocumentList,1);	
	this.navigateEvent.fire(pg);
};
ASD.ExistingDocsDetailsPage.prototype.viewSigning = function() 
{
	var pg = this.sharedState.pages.signingPage;
	pg.showLoadingShim();
	window.setTimeout(as_setRefreshSignerList,1);
	this.navigateEvent.fire(pg);
};
ASD.ExistingDocsDetailsPage.prototype.showLoadingShim = function() { try { $S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); $D.setStyle(this.settings.loadingEl, 'height', '33em'); } catch(e) {} }
ASD.ExistingDocsDetailsPage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }
ASD.ExistingDocsDetailsPage.prototype.initialize = function()
{
	this.hideLoadingShim();
	
	var detailsTab = $S('.tabList .detailsTab', this.getEl())[0];
	var historyTab = $S('.tabList .historyTab', this.getEl())[0];
	var errorsTab = $S('.tabList .errorsTab', this.getEl())[0];
	
	$YE.addEventHandler(detailsTab, 'click', function() { this.showLoadingShim(); window.setTimeout(as_viewDetails,1); }, this);
	$YE.addEventHandler(historyTab, 'click', function() { this.showLoadingShim(); window.setTimeout(as_viewHistory,1); }, this);
	$YE.addEventHandler(errorsTab, 'click', function() { this.showLoadingShim(); window.setTimeout(as_viewErrors,1); }, this); 
	
	var deleteAction = $S('.actions .delete', this.getEl())[0];
	$YE.addEventHandler(deleteAction, 'click', function()
	{
		if (confirm('Are you sure you would like to delete this document?'))
		{
			this.viewList();
			window.setTimeout(as_deleteDocument,1);
		}
	}, this);

	var expireAction = $S('.actions .expire', this.getEl())[0];
	$YE.addEventHandler(expireAction, 'click', function() 
	{ 
		if (confirm('Are you sure you would like to expire this document?'))
		{
			this.showLoadingShim();
			window.setTimeout(as_expireDocument,1);
		} 
	}, this);
		
	var cancelAction = $S('.actions .cancel', this.getEl())[0];
	$YE.addEventHandler(cancelAction, 'click', function() 
	{ 
		if (confirm('Are you sure you would like to cancel this document?'))
		{
			this.showLoadingShim();
			window.setTimeout(as_cancelDocument,1);
		} 
	}, this);
	
	var signAction = $S('.actions .sign', this.getEl())[0];
	$YE.addEventHandler(signAction, 'click', this.viewSigning, this);
};

//ExistingDocsSigningPage//
ASD.ExistingDocsSigningPage = function(config)
{
	ASD.ExistingDocsSigningPage.superclass.constructor.call(this, config);
	var s = this.settings = {};
	s.renderEl = $S('.toolbarHeader .docSigningRenderForm', this.getEl())[0];
	s.returnEl = $S('.toolbarFooter .signing_Previous', this.getEl())[0];
	s.loadingEl = $S('.asdControl .templateContent .loadingPanel')[0].cloneNode(true);	
	$YE.addEventHandler(s.returnEl, 'click', this.returnClicked, this);
};
$Y.extend(ASD.ExistingDocsSigningPage, ASD.PageController);
ASD.ExistingDocsSigningPage.prototype.getEl = function()
{
	var s = this.settings;
	if (s.el == null) { s.el = $S('.asdControl .signingPanel')[0]; }
	return s.el;
};
ASD.ExistingDocsSigningPage.prototype.showLoadingShim = function() { try { $S('.asdControl .asdContent')[0].appendChild(this.settings.loadingEl); $D.setStyle(this.settings.loadingEl, 'height', '33em'); } catch(e) {} }
ASD.ExistingDocsSigningPage.prototype.hideLoadingShim = function() { try { $S('.asdControl .asdContent')[0].removeChild(this.settings.loadingEl); } catch(e) {} }
ASD.ExistingDocsSigningPage.prototype.preRender = function() { };
ASD.ExistingDocsSigningPage.prototype.returnClicked = function() 
{ 
	var pg = this.sharedState.pages.detailsPage; 
	pg.showLoadingShim(); 
	window.setTimeout(as_viewDetails,1);
	this.navigateEvent.fire(pg); 
};
ASD.ExistingDocsSigningPage.prototype.initialize = function() { this.hideLoadingShim(); };

function documentPageInit() { 

	var c = {};
	c.contentEl = $S('.asdControl .tab2')[0];
	c.tabEl = $S('.asdControl .tabTwo')[0];
	
	
	c.pages = 
	{
		templatePage: new ASD.AppDetailsDocSetupTemplatePage(),
		paramPage: new ASD.AppDetailsDocSetupParameterPage(),
		summaryPage: new ASD.AppDetailsDocSetupSummaryPage(),
		confirmPage: new ASD.AppDetailsDocSetupConfirmPage(),
		sfDocPage: new ASD.AppDetailsDocSetupSFDocPage(),
		sfAttachPage: new ASD.AppDetailsDocSetupSFAttachPage()
	};
	c.initialPage = c.pages.templatePage;
	
	ASD.detailsTabController = new ASD.TabController(c); 
	
	var c2 = {};
	c2.contentEl = $S('.asdControl .tab3')[0];
	c2.tabEl = $S('.asdControl .tabThree')[0];
	c2.pages = 
	{
		listPage: new ASD.ExistingDocsListPage(),
		detailsPage: new ASD.ExistingDocsDetailsPage(),
		signingPage: new ASD.ExistingDocsSigningPage()
	};
	c2.initialPage = c2.pages.listPage;
	
	ASD.existingDocsTabController = new ASD.TabController(c2);
	
}

$YE.addEventHandler(window, "load", documentPageInit);
