
.asdControl { background-color:#F3F3EC; }

.asdControl .asdContent { padding: 0; margin: 0; background-color:#F3F3EC; }
.asdControl .asdContent .tabBack { position: absolute; font-size: 11px; height: 400px; background-color: #F3F3EC; width: 100%; margin: 0; padding: 0; left: 0; top: 0; z-index: -1; }

.asdControl .loadingPanel, .asdControl .loadingPanelIE6 { position: absolute; width: 100%; height: 100%; z-index: 98; left: 0; top: 0; }
.asdControl .loadingPanel .frame { position: absolute; width: 100%; height: 100%; z-index: 99; left: 0; top: 0; border: none; background-color: #ffffff; opacity: 0; filter: alpha(opacity:0); }
.asdControl .loadingPanelIE6 .frame { position: absolute; width: 100%; height: 100%; z-index: 99; left: 0; top: 0; border: none; background-color: #ffffff; opacity: 1; filter: alpha(opacity:1); }
.asdControl .loadingPanel .shim, .asdControl .loadingPanelIE6 .shim { position: absolute; width: 100%; height: 100%; background-color: #ffffff; opacity: 0.6; filter: alpha(opacity:60); z-index: 100; left: 0; top: 0; }
.asdControl .loadingPanel .content, .asdControl .loadingPanelIE6 .content { position: absolute; top: 43%; width: 100%; text-align: center; line-height: 2%; z-index: 101; }
.asdControl .loadingPanel .content span, .asdControl .loadingPanelIE6 .content span { font-size: 125%; font-weight: bold; }

.asdControl .toolbarTitle { background-image:none; background-color:#f3f3ec; border:none; border-bottom:1px solid #f3f3ec; border-top:4px solid #006699; }
.asdControl .toolbarTitle .dr-toolbar-int { padding-left:3px; }
.asdControl .toolbarImage { position: relative; height:24px; margin-top:-5px; margin-left:5px; position:relative; float:left; }
.asdControl .titleText { color: #333333; font-family: 'Verdana', 'Geneva', sans-serif; }

.asdControl .activeTab {background-color: #F1F1F1; color:#000000; background-image:none; cursor: pointer; }
.asdControl .inactiveTab { background-color: #006699; color:#FFFFFF; background-image:none; cursor: pointer; }


.asdControl .listPanel { height: 29.2em; position: relative; }
.asdControl .listPanel .docListPanel { height: 27.5em; overflow-x: hidden; overflow-y: auto; position: relative; }
.asdControl .listPanel .documentList { width: 100%; }
.asdControl .listPanel .documentList thead tr th { border-bottom: 2px solid #006699; }
.asdControl .listPanel .documentList th, .documentList td { border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .listPanel .instructions { font-size:12px; padding:0.5em 0 0; }

.asdControl .detailsPanel { height: 29.2em; }
.asdControl .detailsPanel ul { margin: 0; padding: 0; }
.asdControl .detailsPanel .toolbarButton { width: 15em; }
.asdControl .detailsPanel .docDetailsPanel { height: 25.75em; overflow-x: hidden; overflow-y: auto; position: relative; }

.asdControl .detailsPanel .content { margin: .5em 12.75em 0 0; position: relative; }
.asdControl .detailsPanel .content .details { background-color: #e8e8e8; border: solid 1px #c0c0c0; height: 24.5em; margin-left: 10em; overflow: auto; position:relative; }
.asdControl .detailsPanel .content .details .detailsContent { }

.asdControl .detailsPanel .content .documentDetails { margin: 1em; margin-top: 0; }
.asdControl .detailsPanel .content .documentDetails ul { list-style: none; padding: 0; }
.asdControl .detailsPanel .content .documentDetails ul li { list-style: none; padding: .5em 0; margin: 0; position: relative; border-bottom: solid 1px #c0c0c0; }
.asdControl .detailsPanel .content .documentDetails ul li.highlight { background-color: #ffffff; }
.asdControl .detailsPanel .content .documentDetails ul li .caption { position: absolute; top: .5em; left: 4px; font-weight: bold; }
.asdControl .detailsPanel .content .documentDetails ul li .value { display: block; margin-left: 10em;  }

.asdControl .detailsPanel .content .documentHistory { margin: 1em; margin-top: 0; }
.asdControl .detailsPanel .content .documentHistory .documentHistoryList { width: 100%; }
.asdControl .detailsPanel .content .documentHistory th, .asdControl .detailsPanel .content .documentHistory td { border-bottom: 1px solid #CCCCCC; color:#333333; padding: 4px 2px 4px 5px; }
.asdControl .detailsPanel .content .documentHistory .documentHistoryList th { border-bottom: 2px solid #006699; }

.asdControl .detailsPanel .content .documentErrors { margin: 1em; margin-top: 0; }
.asdControl .detailsPanel .content .documentErrors .documentErrorList { width: 100%; }
.asdControl .detailsPanel .content .documentErrors th, .asdControl .detailsPanel .content .documentErrors td { border-bottom: 1px solid #CCCCCC; color:#333333; padding: 4px 2px 4px 5px; }
.asdControl .detailsPanel .content .documentErrors .documentErrorList th { border-bottom: 2px solid #006699; } 

.asdControl .detailsPanel .content .tabList { position: absolute; left: 0; top: 0; width: 9.5em; z-index: 1; }
.asdControl .detailsPanel .content .tabList .tab { border: 1px solid #c0c0c0; margin-bottom: .15em; padding: 0; display: block; line-height: 0; background-color:#006699; width: 9.875em; }
.asdControl .detailsPanel .content .tabList .tab .tabBorder { height: 100%; width: 100%; border: solid 1px #ffffff; border-right: none; padding: 0; padding-left: .5em; width: 9.4375em; background-image: none; }
.asdControl .detailsPanel .content .tabList .tab .tabBorder.hover { border-color: #FAFAFA; }
.asdControl .detailsPanel .content .tabList .tab .tabLink { display: block; width: 100%; height: 100%; line-height: 2.5em; color: #ffffff; }
.asdControl .detailsPanel .content .tabList .tab .tabLink:hover { text-decoration: none; }
.asdControl .detailsPanel .content .tabList .tab.selected { background-color: #e8e8e8; width: 10em; border-right: none; }
.asdControl .detailsPanel .content .tabList .tab.selected .tabBorder.hover { border-color: #ffffff; }
.asdControl .detailsPanel .content .tabList .tab.selected .tabLink { color: #000000; }
.asdControl .detailsPanel .content .tabList .tab.selected .tabLink:hover { text-decoration: none; }

.asdControl .detailsPanel .actions { position: absolute; top: .5em; right: 0; width: 12em; background-color: #E8E8E8; border: solid 1px #C0C0C0; padding-bottom: 0.75em; border-top: none; }
.asdControl .detailsPanel .actions ul { margin: 0; padding: 0; list-style: none; margin-left: .3em; }
.asdControl .detailsPanel .actions ul li { margin: 0.8em 0 1em; padding: 0; list-style: none; }
.asdControl .detailsPanel .actions .toolbarButton { width: 13em; }
.asdControl .detailsPanel .actions .toolbarButton.important { background-color: #006699; }
.asdControl .detailsPanel .actions a.toolbarButton { text-decoration: none; padding: 2px 5px;  } 

.asdControl .signingPanel { height: 29.2em; }
.asdControl .signingPanel .docSigningPanel { height: 26em; overflow-x: hidden; overflow-y: auto; }
.asdControl .signingPanel .signerList { width: 100%;  }
.asdControl .signingPanel .signerList thead tr th { border-bottom: 2px solid #006699; }
.asdControl .signingPanel .signerList th, .signerList td { border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .signingPanel .toolbarButton { width: 16em; }
.asdControl .signingPanel .instructions { font-size:12px; padding:0.5em 0 0; }

.asdControl .toolbarSubTitle { background-image:none; background-color:#f3f3ec; border:none; border-bottom:1px solid #FFFFFF; border-top: solid 4px #006699; }
.asdControl .toolbarSubTitle .dr-toolbar-int { padding-left:3px; }


.asdControl .invalidsettings { height: 27.5em; font-family: 'Verdana', 'Geneva', sans-serif; overflow: hidden; overflow-y: auto; }
.asdContent .invalidsettings .InvalidSettingsText {color:#CC0000;font-family:'Arial','Helvetica',sans-serif; font-weight: bold;font-size:11px;padding:0.5em 0 0;}
 

.asdControl .start { height: 27.5em; font-family: 'Verdana', 'Geneva', sans-serif; overflow: hidden; overflow-y: auto; }

.asdControl .start .logo { margin-top: .25em; }

.asdControl .start .intro { margin-top: .25em; }
.asdControl .start .intro ul { margin: 0 0 0 2em; padding: 0; }
.asdControl .start .intro li { margin: .5em 0 0 0; padding: 0; font-size: 110%; list-style: square; }

.asdControl .update { margin: 1em 3em 0 3em; overflow: hidden; overflow-y: auto; }
.asdControl .update .header { font-size: 110%; font-weight: bold; border-bottom: solid 2px #006699; }
.asdControl .update .intro { margin-top: .5em; }
.asdControl .update ul { margin: .75em 0 0 .5em; }
.asdControl .update ul li { margin: .5em 0 0 0; padding: 0; list-style: square; }
.asdControl .update .note { margin-top: .75em; }
.asdControl .update .note em { color: #CC0000; font-style: normal; font-weight: bold; }


.asdControl .toolbarHeader { background-image:none; background-color:#9096A1; border: 1px solid #9096A1; }
.asdControl .toolbarFooter { background-image:none; background-color:#E8E8E8; height: 28px; }

.asdControl .asdTemplateTabContent { height: 24.9em; min-width: 610px; background-color:#F1F1F1; overflow: auto; }
.asdControl .asdTemplateTabInvalidConfiguration { height: 25.6em; background-color:#F1F1F1; overflow:hidden; overflow-y:auto; }


.asdControl .asdTemplateTabContent .setupTemplateRenderPanel { width: 18.4em; }
.asdControl .asdTemplateTabContent .setup_templateSelect { width: 19em; }
.asdControl .asdTemplateTabContent .templateText { font-size: 12px; }
.asdControl .asdTemplateTabContent .validationText { font-size: 12px; color: #CC0000; }
.asdControl .asdTemplateTabContent .templateIntro { font-size: 12px; padding: 0.5em 0 0; }
.asdControl .asdTemplateTabContent .templateLabelText { font-weight: bold; font-size: 12px; }
.asdControl .asdTemplateTabContent .templateLabelTextCb { font-weight: bold; font-size: 12px; }
.asdControl .asdTemplateTabContent .docTypeRadio { font-size: 12px; }
.asdControl .asdTemplateTabContent .helpOrb { height: 16px; width: 16px; padding-left: .5em; }
.asdControl .asdTemplateTabContent .cal1Container { z-index:1; }
.asdControl .asdTemplateTabContent .calendarbutton { cursor: pointer; padding-left: .5em; }
.asdControl .asdTemplateTabContent .templateOrderNumberText { width: 11em; margin-right: 1em; }
.asdControl .asdTemplateTabContent .slParseDocument { width: 11em; }
.asdControl .asdTemplateTabContent .default_expiration { padding-left: .5em; }
.asdControl .asdTemplateTabContent .completedDocumentPassword { padding-left: .5em; }

.asdControl .asdParamTabContent{ height: 25.6em; background-color:#F1F1F1; }
.asdControl .asdParamTabContent .paramText { font-size: 12px; }
.asdControl .asdParamTabContent .paramIntro { font-size: 12px; padding: 0.5em 0 0; }
.asdControl .asdParamTabContent .setup_paramsDatatable thead tr th { border-bottom: 2px solid #006699; }
.asdControl .asdParamTabContent .setup_paramsDatatable th, .setup_paramsDatatable td {border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .asdParamTabContent .setup_paramsDatatable .required_field {border-left:2px solid #FF0000;} 
.asdControl .asdParamTabContent .setup_paramsDatatable .requiredFieldText{ font-size: 12px; color: #CC0000; }
.asdControl .asdParamTabContent .setup_paramsDatatable .setup_paramvalidationmessage { font-size: 12px; color: #CC0000; }
.asdControl .asdParamTabContent .setup_paramsDatatable .paramvalidationmessagehide {display:none !important;}
.asdControl .asdParamTabContent .setup_paramsDatatable .requiredFieldInputHide {display:none !important;}
.asdControl .asdParamTabContent .setup_paramsDatatable .requiredFieldInputShow {}
.asdControl .asdParamTabContent .invalidParametersText { color: #CC0000; }

.paramValueWrapperItems {height:100%;position:relative;}
.requiredBlock {background-color:#CC0000;bottom:1px;left:-4px;position:absolute;top:1px;width:3px;}

.asdControl .asdParamTabContent .setup_paramspageLabelText{ font-weight:bold; font-size:12px; }
.asdControl .asdParamTabContent .paramsTablePanel {width:30em; height: 15em; overflow:hidden; overflow-y:auto; position:relative; }

.asdControl .asdParamTabContent .customTD { width: 100%;}
.asdControl .asdParamTabContent .paramSelectorNavigationBar { font-size:12px;font-weight:bold; }
.asdControl .asdParamTabContent .paramSelectorNavigationBar .parameterNavLink:hover {text-decoration:underline; color:#81BDC8; cursor: pointer; cursor: hand  	}
.asdControl .asdParamTabContent .paramSelectorNavigationBar .parameterNavLink {text-decoration:underline; color:#006699;} 

.asdControl .asdParamTabContent .paramSelectorNavigationBar .parameterNavLabel:hover {} 
.asdControl .asdParamTabContent .paramSelectorNavigationBar .parameterNavLabel {} 

.asdControl .asdReviewTabContent { height: 25.6em; background-color:#F1F1F1; overflow:hidden; overflow-y:auto; }
.asdControl .asdReviewTabContent .reviewIntro { font-size: 12px; padding: 0.5em 0 0; }
.asdControl .asdReviewTabContent .reviewParamsPanel { height: 12.7em; overflow:hidden; overflow-y:auto; padding-left: 10em; padding-right: 10em; }
.asdControl .asdReviewTabContent .reviewDocumentTable { width:100%; }
.asdControl .asdReviewTabContent .reviewDocumentTable th, .asdReviewTabContent .reviewDocumentTable td { width: 20em; border-bottom:1px solid #CCCCCC; color:#333333; }
.asdControl .asdReviewTabContent .reviewDocumentTable .nameCol { text-align: right; padding: 2px 10px 2px 2px; width: 17%; }
.asdControl .asdReviewTabContent .reviewDocumentTable .valueCol { padding: 2px 2px 2px 10px; width: 32%; border-right: 20px solid #F1F1F1; }
.asdControl .asdReviewTabContent .reviewDocumentTable .name2Col { text-align: right; padding: 2px 10px 2px 2px; width: 18%; }
.asdControl .asdReviewTabContent .reviewDocumentTable .value2Col { padding: 2px 2px 2px 10px; width: 32%; }
.asdControl .asdReviewTabContent .reviewTable { width:100%; }
.asdControl .asdReviewTabContent .reviewTable thead tr th { border-bottom: 2px solid #006699; }
.asdControl .asdReviewTabContent .reviewTable th, .asdReviewTabContent .reviewTable td { width: 50%; border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .asdReviewTabContent .reviewTableTextBold { font-weight: bold; }
.asdControl .asdReviewTabContent .reviewDetailsRenderPanel { margin-bottom: 1em; }

.asdControl .asdSFDocTabContent { height: 25.6em; background-color:#F1F1F1; }
.asdControl .asdSFDocTabContent .sfDocIntro { font-size: 12px; padding: 0.5em 0 0; }
.asdControl .asdSFDocTabContent .sfDocTable { width:100%; }
.asdControl .asdSFDocTabContent .sfDocTable thead tr th { border-bottom: 2px solid #006699; }
.asdControl .asdSFDocTabContent .sfDocTable th, .asdSFDocTabContent .sfDocTable td { width: 10em; border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .asdSFDocTabContent .sfDocTable .highlightSelectedElement { background-color:#006699; color:#FFFFFF;padding: 0.5em; border:1px solid #333333; }
.asdControl .asdSFDocTabContent .sfDocTable .highlightrow { background-color:#006699; }
.asdControl .asdSFDocTabContent .sfDocTable .highlightrow td { color:#FFFFFF; cursor: pointer; }
.asdControl .asdSFDocTabContent .sfDocTable .highlightSelectedElement td { color:#FFFFFF; cursor: pointer; }
.asdControl .asdSFDocTabContent .sfDocDetailsRenderPanel { overflow:hidden; overflow-y:auto; height: 17em; }
.asdControl .sfDocValidateHide { color: #FF0000; display: none; }
.asdControl .sfDocValidateShow { color: #FF0000; display: inline; padding-left: 1em; }

.asdControl .asdSFAttachTabContent { height: 25.6em; background-color:#F1F1F1; }
.asdControl .asdSFAttachTabContent .sfAttachIntro { font-size: 12px; padding: 0.5em 0 0; }
.asdControl .asdSFAttachTabContent .attachmentTable { width:100%; }
.asdControl .asdSFAttachTabContent .attachmentTable thead tr th { border-bottom: 2px solid #006699; }
.asdControl .asdSFAttachTabContent .attachmentTable th, .asdSFAttachTabContent .attachmentTable td { width: 10em; border-bottom:1px solid #CCCCCC; color:#333333; padding:4px 2px 4px 5px; }
.asdControl .asdSFAttachTabContent .attachmentTable .highlightSelectedElement { background-color:#006699; color:#FFFFFF;padding: 0.5em; border:1px solid #333333; }
.asdControl .asdSFAttachTabContent .attachmentTable .highlightrow { background-color:#006699;  }
.asdControl .asdSFAttachTabContent .attachmentTable .highlightrow td { color:#FFFFFF; cursor: pointer; }
.asdControl .asdSFAttachTabContent .attachmentTable .highlightSelectedElement td {color:#FFFFFF; cursor: pointer; }
.asdControl .asdSFAttachTabContent .attachmentDetails { overflow:hidden; overflow-y:auto; height: 22em; }
.asdControl .sfAttachValidateHide { color: #FF0000; display: none; }
.asdControl .sfAttachValidateShow { color: #FF0000; display: inline; padding-left: 1em; }

.asdControl .asdConfirmTabContent { height: 25.4em; background-color:#F1F1F1; }
.asdControl .asdConfirmTabContent .confirmIntro { font-size: 12px; padding: 0.5em 0 0; }

.asdControl .toolbarButton 
{ 
    -moz-border-radius:3px 3px 3px 3px;
	background:url("/img/alohaSkin/btn_sprite.png") repeat-x scroll right top #E8E8E9;
	border-color:#B5B5B5 #B5B5B5 #7F7F7F;
	border-style:solid;
	border-width:1px;
	color:#333333;
	font-size:0.9em;
	font-weight:bold;
	margin:1px;
	padding:3px 5px;
	font-size: 100%;
	
}

.asdControl .toolbarButtonLong 
{ 
    -moz-border-radius:3px 3px 3px 3px;
	background:url("/img/alohaSkin/btn_sprite.png") repeat-x scroll right top #E8E8E9;
	border-color:#B5B5B5 #B5B5B5 #7F7F7F;
	border-style:solid;
	border-width:1px;
	color:#333333;
	font-size:0.9em;
	font-weight:bold;
	margin:1px;
	padding:3px 5px;
	font-size: 100%;
}

.asdControl .toolbarButtonDisabled
{ 
    -moz-border-radius:3px 3px 3px 3px;
	background:url("/img/alohaSkin/btn_sprite.png") repeat-x scroll right top #E8E8E9;
	border-color:#B5B5B5 #B5B5B5 #7F7F7F;
	border-style:solid;
	border-width:1px;
	color:#333333;
	font-size:0.9em;
	font-weight:bold;
	margin:1px;
	padding:3px 5px;
	font-size: 100%;
}
