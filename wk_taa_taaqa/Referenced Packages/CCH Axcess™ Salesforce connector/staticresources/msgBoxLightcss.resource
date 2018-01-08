div.msgBox
{
    padding: 4px 10px 4px 10px;
    position: fixed;
    z-index: 1000;
    font-family:Arial;
    width: 430px;
    min-height:160px;
    color: #000000;
    -moz-border-radius: 6px;
    -webkit-border-radius: 6px;
    border-radius: 6px;
    -moz-box-shadow: 0px 0px 11px #000000;
    -webkit-box-shadow: 0px 0px 11px #000000;
    box-shadow: 0px 0px 11px #000000;
}
div.msgBoxBackGround
{
    top:0;
    left:0;
    position:absolute;
    padding:0;
    margin:0;
    width:100%;
    height:100%;
    background-color:#000000;
    opacity:0.9;
    z-index:999;
}
div.msgBoxTitle
{
    padding:5px 0 5px 0;
    /*font-variant:small-caps;*/
    font-size:16px;
    /*font-weight:lighter;*/
    color:#000000;
    width:100%;
    border-bottom : 1px solid #002c5f;
}
div.msgBoxImage
{
    margin:20px 5px 0 5px;
    display:inline-block;
    float:left;
    height:75px;
    width:75px;
}
div.msgBoxImage img
{
    height:75px;
    width:75px;
}
div.msgBoxContent
{
    font-size:8px;
    margin:0 3px 1px 3px;
    display:inline-block;
    float:left;
    height:90px;
    width:319px;
}
div.msgBoxContent p
{
    padding:0;
    margin:0;
    display: table;
    height: 100%;
    width: 100%;
}

div.msgBoxContent span 
{
	font-size:12px;
    display: table-cell;
    vertical-align: middle;
    color: #000000;
}

div.msgBoxButtons
{
    display:inline-block;
    width:100%;
    text-align:right;
}
div.msgBoxButtons input[type='button']
{
    cursor:pointer;
    margin:2px;
    height:35px;
    width:90px;
    border:1px solid #AFAFAF;
    background-color:#004076;
    color:#FFFFFF;
    -moz-border-radius: 6px;
    -webkit-border-radius: 6px;
    border-radius: 6px;
}
div.msgBoxButtons input[type='button']:hover
{
    background-color:#00549c;
    color:White;
}
div.msgBoxButtons input[type='button']:active
{
    background-color:#AAAAAA;
    color:White;
}

div.msgBoxInputs
{
    margin:0 auto;
    padding-top:2px;
    padding-bottom:2px;
    margin-top:5px;
	margin-left:5px;
    width:195px;
	float: left;
}
div.msgBoxLogo
{
    margin:0 auto;
    padding-top:10px;
    padding-bottom:2px;
    margin-top:5px;
	margin-left:30px;
	float: left;
}
div.msgInput input[type='text'],div.msgInput input[type='password']
{
    padding:4px;
    border:1px solid #DFDFDF;
    color:#2f2f2f;
    width:180px;
}
div.msgInput text
{
    color:#2f2f2f;
    font-size:12px;
}
.msgInputValidation 
{
	color: #D21D20 !important;
	font-size:10px !important;
}