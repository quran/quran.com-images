
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
var nCurrSora      =78;
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
		var StrPage = "582";
		var strLength="148788";
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
<td valign="top"  >
<table border="0" cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFFF" style='margin-right:3.0pt'>
<tr height=115><td >&nbsp;</td></tr>
<TR><TD><IMG src="/Quran/Images/Joz'a-up.jpg" WIDTH=53 HEIGHT=69></TD></TR>
<TR><TD><IMG src="/Quran/Images/Joz'a-30.jpg" WIDTH=53 HEIGHT=31></TD></TR>
<TR><TD><IMG src="/Quran/Images/Joz'a-dwn.jpg" WIDTH=53 HEIGHT=69></TD></TR>
</TABLE>
</td>
<td >
<!-- MFD -->
<table border="0" cellpadding="0" align=center cellspacing="0" bgcolor="#FFFFff">


<tr>
<td colspan=3>
<table border="0" cellpadding="0" align=center cellspacing="0" WIDTH=100%>
<tr><td align=left dir=rtl><SPAN class=sc_F1>&#64396;&#64507;</span>
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
					  <html><META http-equiv="Content-Type" CONTENT="text/html; charset=windows-1252">
					<head>
					<STYLE>
					.sc_F0 {FONT-FAMILY:QCF_P582; FONT-SIZE: 22pt; mso-font-charset: 0}
					.sc_F1 {FONT-FAMILY:QCF_BSML; FONT-SIZE: 20pt; mso-font-charset: 0}

					</STYLE>
					<STYLE>
					<!--
					 	@font-face {
						font-family: QCF_P582;
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
							<SPAN class=sc_F0 style='line-height:165%'> 
<CENTER>
<TABLE dir=ltr cellSpacing=0 cellPadding=0 width="412" border=0>
					                    <TBODY>
				                    <TR>
					<td width=100% align="center" dir=rtl height=49 background="/Quran/Images/frame.gif" >
</span><SPAN align="center" class=sc_F1>&#64396;&#64507;</span>
</TD></TR></TBODY></TABLE></CENTER>

					<SPAN class=sc_F1>
					<A name=78_0></A><A class=black onclick=ClickAyaArea(78,0) target=_top><center>&#64337;&#64338;&#64339;</center></A>
					</SPAN>
					<SPAN class=sc_F0><A name=78_1></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,1) target=_top>&#64337;&#64338;&#64339;</A><A name=78_2></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,2) target=_top>&#64340;&#64341;&#64342;&#64343;</A><A name=78_3></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,3) target=_top>&#64344;&#64345;&#64346;&#64347;&#64348;</A><br><A name=78_4></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,4) target=_top>&#64349;&#64350;&#64351;</A><A name=78_5></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,5) target=_top>&#64352;&#64353;&#64354;&#64355;</A><A name=78_6></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,6) target=_top>&#64356;&#64357;&#64358;&#64359;&#64360;</A><br><A name=78_7></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,7) target=_top>&#64361;&#64362;&#64363;</A><A name=78_8></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,8) target=_top>&#64364;&#64365;&#64366;</A><A name=78_9></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,9) target=_top>&#64367;&#64368;&#64369;</A><br><A name=78_9></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,9) target=_top>&#64370;</A><A name=78_10></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,10) target=_top>&#64371;&#64372;&#64373;&#64374;</A><A name=78_11></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,11) target=_top>&#64375;&#64376;&#64377;&#64378;</A><A name=78_12></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,12) target=_top>&#64379;</A><br><A name=78_12></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,12) target=_top>&#64380;&#64381;&#64382;&#64383;</A><A name=78_13></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,13) target=_top>&#64384;&#64385;&#64386;&#64387;</A><A name=78_14></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,14) target=_top>&#64388;</A><br><A name=78_14></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,14) target=_top>&#64389;&#64390;&#64391;&#64392;&#64393;</A><A name=78_15></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,15) target=_top>&#64394;&#64395;&#64396;&#64397;&#64398;</A><A name=78_16></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,16) target=_top>&#64399;</A><br><A name=78_16></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,16) target=_top>&#64400;&#64401;</A><A name=78_17></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,17) target=_top>&#64402;&#64403;&#64404;&#64405;&#64406;&#64407;</A><A name=78_18></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,18) target=_top>&#64408;&#64409;&#64410;&#64411;</A><br><A name=78_18></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,18) target=_top>&#64412;&#64413;&#64414;</A><A name=78_19></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,19) target=_top>&#64415;&#64416;&#64417;&#64418;&#64419;</A><A name=78_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,20) target=_top>&#64420;</A><br><A name=78_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,20) target=_top>&#64421;&#64422;&#64423;&#64424;</A><A name=78_21></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,21) target=_top>&#64425;&#64426;&#64427;&#64428;&#64429;</A><A name=78_22></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,22) target=_top>&#64430;</A><br><A name=78_22></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,22) target=_top>&#64431;&#64432;</A><A name=78_23></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,23) target=_top>&#64433;&#64467;&#64468;&#64469;</A><A name=78_24></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,24) target=_top>&#64470;&#64471;&#64472;&#64473;&#64474;&#64475;</A><br><A name=78_24></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,24) target=_top>&#64476;</A><A name=78_25></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,25) target=_top>&#64477;&#64478;&#64479;&#64480;</A><A name=78_26></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,26) target=_top>&#64481;&#64482;&#64483;</A><A name=78_27></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,27) target=_top>&#64484;&#64485;</A><br><A name=78_27></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,27) target=_top>&#64486;&#64487;&#64488;&#64489;</A><A name=78_28></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,28) target=_top>&#64490;&#64491;&#64492;&#64493;</A><A name=78_29></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,29) target=_top>&#64494;&#64495;</A><br><A name=78_29></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,29) target=_top>&#64496;&#64497;&#64498;</A><A name=78_30></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(78,30) target=_top>&#64499;&#64500;&#64501;&#64502;&#64503;&#64504;</A></SPAN>
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
<td colspan=3 align="center" ><b><Font Size="4"> &#x0665;&#x0668;&#x0662; </Font></b></td>
</tr>

</table>
<!-- MFD -->
</td>
<!--
<td valign="top" WIDTH=5%>&nbsp;</td>
-->

<!-- Print-->
<td valign="top" ><IMG width=40 src="/Quran/Images/space.jpg"></td>

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

