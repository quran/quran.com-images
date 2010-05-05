
<SCRIPT LANGUAGE=javascript>
<!--
function DoFormClose(){
	if(navigator.appName == "Microsoft Internet Explorer")
	{
		FontDownATL.NavigaterClose()
	}
	if((navigator.vendor=="Firefox")||(navigator.appName == "Netscape"))
	{
		window.close()
		FontDownNS.NavigaterClose()
	}
}

function CheckDownload(strErr)
{
	if (strErr!=''){
	}
}

//IE Functions-----------------------------------

function Quran_AyaFont(StrPage,nLength)
{
	try {
			FontDownATL.strFontsPath = "http://www.qurancomplex.com/TTF/"
			FontDownATL.DownLoadExx("QCF_P"+StrPage+".TTF" , "2005 8 11" , nLength)
			if (parseInt(StrPage)==576)
			{
				strErr = FontDownATL.DownLoadExx("QCF_P576_2.TTF" , "2005 8 11" , nLength)
			}
			SouraPart()
			}
	catch(e){}
}

function QuranFont_Tafeez(StrPage,StrPageMinus,StrPagePluse,nLength)
{
	nLength = 0;
	try {
			FontDownATL.strFontsPath = "http://www.qurancomplex.com/TTF/";
			FontDownATL.DownLoadExx("QCF_P"+StrPageMinus+".TTF" , "2005 8 11" , nLength);
			FontDownATL.DownLoadExx("QCF_P"+StrPage+".TTF" , "2005 8 11" , nLength);
			FontDownATL.DownLoadExx("QCF_P"+StrPagePluse+".TTF" , "2005 8 11" , nLength)
			if (parseInt(StrPage)==576 || parseInt(StrPageMinus)==576 || parseInt(StrPagePluse)==576)
			{
				FontDownATL.DownLoadExx("QCF_P576_2.TTF" , "2005 8 11" , nLength)
			}
			SouraPart()
		}
	catch(e){}
}

function QuranFont_Display(StrPage,nLength)
{
	nLength = 0;
	try {
		FontDownATL.strFontsPath = "http://www.qurancomplex.com/TTF/";
		FontDownATL.DownLoadExx("QCF_P"+StrPage+".TTF" , "2004 8 11" , nLength);
		if (parseInt(StrPage)==576){
			FontDownATL.DownLoadExx("QCF_P576_2.TTF" , "2005 8 11" , nLength);
		}
		SouraPart();
	} catch(e){
	}
}

function SouraPart()
{
	nLength = 0;
	FontDownATL.strFontsPath = "http://www.qurancomplex.com/TTF/"	
	FontDownATL.DownLoadExx("QCF_BSML.TTF" , "2005 7 11", nLength)
}

//MOZILLA Functions-----------------------------------
function Quran_AyaFontFireFox(StrPage,nLength)
{
	nLength = 0;
	try {
			FontDownNS.strFontsPath = "http://www.qurancomplex.com/TTF/";
			strErr = FontDownNS.DownLoadExx("QCF_P"+StrPage+".TTF" , "2005 8 11",nLength);
			CheckDownload(strErr)
			SouraPart_Firefox()
		}
	catch(e){}
}

function QuranFont_DisplayFireFox(StrPage,nLength)
{
	nLength = 0;
	try {
			var FontDownNS;
			FontDownNS = document.getElementById("FontDownNSS");
			FontDownNS.strFontsPath = "http://www.qurancomplex.com/TTF/";
			FontDownNS.DownLoadExx("QCF_P"+StrPage+".TTF" , "2005 8 11",nLength);
			SouraPart_Firefox()
		}
	catch(e)
	{
	}
}

function SouraPart_Firefox()
{
	nLength = 0;
	FontDownNS.strFontsPath = "http://www.qurancomplex.com/TTF/";
	FontDownNS.DownLoadExx("QCF_BSML.TTF" , "2005 9 8", nLength);
}


//-->
</Script>


<HTML dir=rtl>
<head>

<META content="MS 5.00.2314.1000" name=GENERATOR >
<title>display</title>
<Script language="Javascript">
<!--
var nCurrSora      =80;
var nCurrAya       =1;
var strCurrTafseer ="";

function Recitation(nSora, nAyaInSora)
{
	nCurrSora = nSora;
	nCurrAya  = nAyaInSora;
	location.href = "/Quran/Recite/ReciteOneAya.asp?s=" + nCurrSora + "&f=" + nCurrAya + "&t=286&Reciter=0";
}
function ClickAyaArea(nSora, nAyaInSora)
{
	nCurrSora = nSora;
	nCurrAya = nAyaInSora;
	if (nCurrSora>1 && nCurrAya==0){
		return false;
	}

AyatServices("/quran/ayat_services.asp?l=arb&nsora="+nCurrSora+"&naya="+nCurrAya+"&mod=display")

	document.cookie = "DisplaySora=" + nSora;
	document.cookie = "DisplayAya=" + nAyaInSora;
}
//-->
</script>




<!--tips script-->

<script language="javascript" src="search.js"></script>
<!--script language="javascript" src="dynlayer.js"></script-->
<SCRIPT LANGUAGE="JavaScript">
<!--
//ns4 = (document.layers)? true:false
//ie4 = (document.all)? true:false
//function init()
//{
//	TipObj = new DynLayer('TipDiv');
//}
//-->
</SCRIPT>
<script language="javascript" src="/Shared/ChURL.JS"></script>
</head>
<BODY TOPMARGIN=0  LEFTMARGIN=0 rightmargin=0 bgcolor="#ffffff" >

	<Object id="FontDownATL"  
	height=0 
	width=0 
	classid="clsid:38D6D77C-5EC1-4A4A-AFEB-85FE780CD61A" VIEWASTEXT>
	</Object>
	<embed id="FontDownNSS" align="absbottom" type="application/fonttools-plugin" width=0 height=0>
	<SCRIPT LANGUAGE=javascript>
	<!--
		var FontDownNS;
		FontDownNS = document.getElementById("FontDownNSS");
	//-->
	</SCRIPT>

	<SCRIPT LANGUAGE="JavaScript">
	<!--
		var StrPage = "585";
		var strLength="176744";
		if(navigator.appName == "Microsoft Internet Explorer")
		{
			QuranFont_Display(StrPage,strLength)
		}
		if((navigator.vendor=="Firefox")||(navigator.appName == "Netscape"))
		{
			QuranFont_DisplayFireFox(StrPage,strLength);
		}

	//-->
	</Script>
	
<DIV align=center>

<div align=center>
<table  border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
	<tr>
		<td align=middle valign=top>
		<TABLE align=justify border=0 bgcolor="#fafafa"	 cellspacing="0" cellpadding="0" width="100%">
			<TR align=justify>
				<TD align=middle dir=ltr>
				
<table border="0" align=center cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFff">
<tr>
<!--
<td valign="top" WIDTH=5%>&nbsp;</td>
-->

<!-- Print-->
<td valign="top" ><IMG width=40 src="/Quran/Images/space.jpg"></td>

<td>
<!-- MFD -->

<table border="0" cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFff">


<tr>
<td colspan=3>
<table border="0" cellpadding="0" align=center cellspacing="0" WIDTH=100%>
<tr><td align=left dir=rtl><SPAN class=sc_F1>&#64396;&#64509;</span>
<td>&nbsp;</td>
<td align=right dir=rtl><SPAN class=sc_F1>&#64568;&#64598;</span></td>
</td>
</tr>
</table>
</tr>
	<tr>
<td colspan=3 width=499 height=22>
<img width=499 height=22 src="/Quran/Images/up.jpg" ><br></td>
</tr>
	<tr>
		<td width=23 height=725 background="/Quran/Images/left.jpg" ><br></td>
		<td align=center valign=top><!--FFFFE1 -->

</center>
		<TABLE align=justify border="0" bgcolor="#FEFEE4"	 cellspacing="0" cellpadding="0" width=453 height=100%>
			<TR align=justify dir=rtl>
				<TD align=middle>
					<html>
					<META http-equiv="Content-Type" CONTENT="text/html; charset=windows-1252">
					<head>
					<STYLE>
					.sc_F0 {FONT-FAMILY:QCF_P585; FONT-SIZE: 22pt; mso-font-charset: 0}
					.sc_F1 {FONT-FAMILY:QCF_BSML; FONT-SIZE: 20pt; mso-font-charset: 0}

					</STYLE>
					<STYLE>
					<!--
					 	@font-face {
						font-family: QCF_P585;
						font-style:  normal;
						font-weight: normal;

						}
					 	@font-face {
						font-family: QCF_BSML;
						font-style:  normal;
						font-weight: normal;
						}
					-->
					</STYLE>
					</head>
					<body>
					<TABLE  align=justify border=0 cellspace="0" cellpading="0" width=100%>
					  <TBODY>
<TR align=justify dir=rtl>
					    <TD align=middle>
							<SPAN class=sc_F0 style='line-height:165%'> <SPAN class=sc_F1>
					<A name=33_0></A><A class=black onclick=ClickAyaArea(33,0) target=_top><center>&#64337;&#64338;&#64339;</center></A>
					</SPAN>
<A name=80_1></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,1) target=_top>&#64337;&#64338;&#64339;</A><A name=80_2></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,2) target=_top>&#64340;&#64341;&#64342;&#64343;</A><A name=80_3></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,3) target=_top>&#64344;&#64345;&#64346;&#64347;&#64348;</A><A name=80_4></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,4) target=_top>&#64349;</A><br><A name=80_4></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,4) target=_top>&#64350;&#64351;&#64352;&#64353;</A><A name=80_5></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,5) target=_top>&#64354;&#64355;&#64356;&#64357;</A><A name=80_6></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,6) target=_top>&#64358;&#64359;&#64360;&#64361;</A><br><A name=80_7></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,7) target=_top>&#64362;&#64363;&#64364;&#64365;&#64366;</A><A name=80_8></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,8) target=_top>&#64367;&#64368;&#64369;&#64370;&#64371;</A><A name=80_9></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,9) target=_top>&#64372;&#64373;&#64374;</A><A name=80_10></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,10) target=_top>&#64375;</A><br><A name=80_10></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,10) target=_top>&#64376;&#64377;&#64378;</A><A name=80_11></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,11) target=_top>&#64379;&#64380;&#64381;&#64382;</A><A name=80_12></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,12) target=_top>&#64383;&#64384;&#64385;&#64386;</A><A name=80_13></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,13) target=_top>&#64387;&#64388;&#64389;</A><br><A name=80_13></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,13) target=_top>&#64390;</A><A name=80_14></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,14) target=_top>&#64391;&#64392;&#64393;</A><A name=80_15></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,15) target=_top>&#64394;&#64395;&#64396;</A><A name=80_16></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,16) target=_top>&#64397;&#64398;&#64399;</A><A name=80_17></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,17) target=_top>&#64400;&#64401;</A><br><A name=80_17></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,17) target=_top>&#64402;&#64403;&#64404;</A><A name=80_18></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,18) target=_top>&#64405;&#64406;&#64407;&#64408;&#64409;</A><A name=80_19></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,19) target=_top>&#64410;&#64411;&#64412;&#64413;&#64414;</A><A name=80_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,20) target=_top>&#64415;</A><br><A name=80_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,20) target=_top>&#64416;&#64417;&#64418;</A><A name=80_21></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,21) target=_top>&#64419;&#64420;&#64421;&#64422;</A><A name=80_22></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,22) target=_top>&#64423;&#64424;&#64425;&#64426;&#64427;</A><A name=80_23></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,23) target=_top>&#64428;&#64429;</A><br><A name=80_23></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,23) target=_top>&#64430;&#64431;&#64432;&#64433;</A><A name=80_24></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,24) target=_top>&#64467;&#64468;&#64469;&#64470;&#64471;</A><A name=80_25></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,25) target=_top>&#64472;&#64473;&#64474;&#64475;</A><br><A name=80_25></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,25) target=_top>&#64476;</A><A name=80_26></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,26) target=_top>&#64477;&#64478;&#64479;&#64480;&#64481;</A><A name=80_27></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,27) target=_top>&#64482;&#64483;&#64484;&#64485;</A><A name=80_28></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,28) target=_top>&#64486;&#64487;&#64488;</A><br><A name=80_29></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,29) target=_top>&#64489;&#64490;&#64491;</A><A name=80_30></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,30) target=_top>&#64492;&#64493;&#64494;</A><A name=80_31></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,31) target=_top>&#64495;&#64496;&#64497;</A><A name=80_32></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,32) target=_top>&#64498;&#64499;</A><br><A name=80_32></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,32) target=_top>&#64500;&#64501;</A><A name=80_33></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,33) target=_top>&#64502;&#64503;&#64504;&#64505;</A><A name=80_34></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,34) target=_top>&#64506;&#64507;&#64508;&#64509;&#64510;&#64511;</A><br><A name=80_35></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,35) target=_top>&#64512;&#64513;&#64514;</A><A name=80_36></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,36) target=_top>&#64515;&#64516;&#64517;</A><A name=80_37></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,37) target=_top>&#64518;&#64519;&#64520;&#64521;&#64522;</A><br><A name=80_37></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,37) target=_top>&#64523;&#64524;</A><A name=80_38></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,38) target=_top>&#64525;&#64526;&#64527;&#64528;</A><A name=80_39></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,39) target=_top>&#64529;&#64530;&#64531;</A><A name=80_40></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,40) target=_top>&#64532;</A><br><A name=80_40></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,40) target=_top>&#64533;&#64534;&#64535;&#64536;</A><A name=80_41></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,41) target=_top>&#64537;&#64538;&#64539;</A><A name=80_42></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(80,42) target=_top>&#64540;&#64541;&#64542;&#64543;&#64544;</A></SPAN>
					</span>
</TD></TR></TBODY></TABLE></BODY>
				</td>
			</tr>
		</table>
		</td>
		<td width=23 height=725 background="/Quran/Images/right.jpg" ><br></td>
	</tr><tr>
<td width=499 height=22 colspan=3 >
<img width=499  height=22 src="/Quran/Images/down.jpg" ><br></td>
</tr>

<tr>
<td colspan=3 align="center" ><b><Font Size="4"> &#x0665;&#x0668;&#x0665; </Font></b></td>
</tr>

</table>
<!-- MFD -->
</td>

<td valign="top"  >
<table border="0" cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFFF" style='margin-left:3.0pt'>
<tr height=60><td >&nbsp;</td></tr>
<TR><TD><IMG src="/Quran/Images/hezb-1.jpg" WIDTH=53 HEIGHT=103></TD></TR>
<TR><TD><IMG src="/Quran/Images/hezb59.jpg" WIDTH=53 HEIGHT=16></TD></TR>
<TR><TD><IMG src="/Quran/Images/hezb-dwn2.jpg" WIDTH=53 HEIGHT=6></TD></TR>
</TABLE>
</td>
</tr>
</table>

				</TD>
			</TR>
		</TABLE>
		</td>
	</tr>
</table>

</div>

</DIV>
</BODY>
</HTML>

