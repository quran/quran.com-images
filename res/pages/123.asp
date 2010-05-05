
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
var nCurrSora      =5;
var nCurrAya       =90;
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
		var StrPage = "123";
		var strLength="168628";
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
				
<table border="0" cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFff">

<tr>
<td colspan=3>
<table border="0" cellpadding="0" align=center cellspacing="0" WIDTH=100%>
<tr><td align=left dir=rtl><SPAN class=sc_F1>&#64396;&#64401;</span>
<td>&nbsp;</td>
<td align=right dir=rtl><SPAN class=sc_F1>&#64568;&#64575;</span>
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
			<TR align=justify>
				<TD align=middle>
					<html>
					<META http-equiv="Content-Type" CONTENT="text/html; charset=windows-1252">
					<head>
					<STYLE>
					.sc_F0 {FONT-FAMILY:QCF_P123; FONT-SIZE: 22pt; mso-font-charset: 0}
					.sc_F1 {FONT-FAMILY:QCF_BSML; FONT-SIZE: 20pt; mso-font-charset: 0}

					</STYLE>
					<STYLE>
					<!--
					 	@font-face {
						font-family: QCF_P123;
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
							<SPAN class=sc_F0 style='line-height:165%'> <A name=5_90></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,90) target=_top>&#64337;&#64338;&#64339;&#64340;&#64341;&#64342;&#64343;&#64344;&#64345;</A><br><A name=5_90></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,90) target=_top>&#64346;&#64347;&#64348;&#64349;&#64350;&#64351;&#64352;</A><A name=5_91></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,91) target=_top>&#64353;&#64354;</A><br><A name=5_91></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,91) target=_top>&#64355;&#64356;&#64357;&#64358;&#64359;&#64360;&#64361;&#64362;&#64363;</A><br><A name=5_91></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,91) target=_top>&#64364;&#64365;&#64366;&#64367;&#64368;&#64369;&#64370;&#64371;&#64372;&#64373;&#64374;</A><A name=5_92></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,92) target=_top>&#64375;</A><br><A name=5_92></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,92) target=_top>&#64376;&#64377;&#64378;&#64379;&#64380;&#64381;&#64382;&#64383;&#64384;&#64385;</A><br><A name=5_92></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,92) target=_top>&#64386;&#64387;&#64388;&#64389;</A><A name=5_93></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,93) target=_top>&#64390;&#64391;&#64392;&#64393;&#64394;</A><br><A name=5_93></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,93) target=_top>&#64395;&#64396;&#64397;&#64398;&#64399;&#64400;&#64401;&#64402;&#64403;</A><br><A name=5_93></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,93) target=_top>&#64404;&#64405;&#64406;&#64407;&#64408;&#64409;&#64410;&#64411;&#64412;&#64413;&#64414;</A><br><A name=5_93></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,93) target=_top>&#64415;</A><A name=5_94></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,94) target=_top>&#64416;&#64417;&#64418;&#64419;&#64420;&#64421;&#64422;&#64423;&#64424;</A><br><A name=5_94></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,94) target=_top>&#64425;&#64426;&#64427;&#64428;&#64429;&#64430;&#64431;&#64432;&#64433;&#64467;&#64468;</A><br><A name=5_94></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,94) target=_top>&#64469;&#64470;&#64471;&#64472;&#64473;</A><A name=5_95></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,95) target=_top>&#64474;&#64475;&#64476;&#64477;&#64478;&#64479;</A><br><A name=5_95></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,95) target=_top>&#64480;&#64481;&#64482;&#64483;&#64484;&#64485;&#64486;&#64487;&#64488;&#64489;&#64490;&#64491;&#64492;</A><br><A name=5_95></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,95) target=_top>&#64493;&#64494;&#64495;&#64496;&#64497;&#64498;&#64499;&#64500;&#64501;&#64502;&#64503;</A><br><A name=5_95></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,95) target=_top>&#64504;&#64505;&#64506;&#64507;&#64508;&#64509;&#64510;&#64511;&#64512;&#64513;&#64514;&#64515;</A><br><A name=5_95></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(5,95) target=_top>&#64516;&#64517;&#64518;&#64519;&#64520;&#64521;&#64522;&#64523;&#64524;&#64525;&#64526;&#64527;&#64528;</A></SPAN>
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
<td colspan=3 align="center" ><b><Font Size="4"> &#x0661;&#x0662;&#x0663; </Font></b></td>
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

