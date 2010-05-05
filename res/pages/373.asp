
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
var nCurrSora      =26;
var nCurrAya       =137;
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
		var StrPage = "373";
		var strLength="170480";
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
<tr><td align=left dir=rtl><SPAN class=sc_F1>&#64396;&#64422;</span>
<td>&nbsp;</td>
<td align=right dir=rtl><SPAN class=sc_F1>&#64568;&#64587;</span>
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
					  <html><META http-equiv="Content-Type" CONTENT="text/html; charset=windows-1252">
					<head>
					<STYLE>
					.sc_F0 {FONT-FAMILY:QCF_P373; FONT-SIZE: 22pt; mso-font-charset: 0}
					.sc_F1 {FONT-FAMILY:QCF_BSML; FONT-SIZE: 20pt; mso-font-charset: 0}

					</STYLE>
					<STYLE>
					<!--
					 	@font-face {
						font-family: QCF_P373;
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
							<SPAN class=sc_F0 style='line-height:165%'> <A name=26_137></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,137) target=_top>&#64337;&#64338;&#64339;&#64340;&#64341;&#64342;</A><A name=26_138></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,138) target=_top>&#64343;&#64344;&#64345;&#64346;</A><A name=26_139></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,139) target=_top>&#64347;</A><br><A name=26_139></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,139) target=_top>&#64348;&#64349;&#64350;&#64351;&#64352;&#64353;&#64354;&#64355;&#64356;&#64357;&#64358;&#64359;</A><A name=26_140></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,140) target=_top>&#64360;</A><br><A name=26_140></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,140) target=_top>&#64361;&#64362;&#64363;&#64364;&#64365;</A><A name=26_141></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,141) target=_top>&#64366;&#64367;&#64368;&#64369;</A><A name=26_142></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,142) target=_top>&#64370;&#64371;</A><br><A name=26_142></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,142) target=_top>&#64372;&#64373;&#64374;&#64375;&#64376;&#64377;</A><A name=26_143></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,143) target=_top>&#64378;&#64379;&#64380;&#64381;&#64382;</A><br><A name=26_144></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,144) target=_top>&#64383;&#64384;&#64385;&#64386;</A><A name=26_145></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,145) target=_top>&#64387;&#64388;&#64389;&#64390;&#64391;&#64392;&#64393;&#64394;</A><br><A name=26_145></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,145) target=_top>&#64395;&#64396;&#64397;&#64398;&#64399;</A><A name=26_146></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,146) target=_top>&#64400;&#64401;&#64402;&#64403;&#64404;&#64405;</A><br><A name=26_147></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,147) target=_top>&#64406;&#64407;&#64408;&#64409;</A><A name=26_148></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,148) target=_top>&#64410;&#64411;&#64412;&#64413;&#64414;</A><br><A name=26_149></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,149) target=_top>&#64415;&#64416;&#64417;&#64418;&#64419;&#64420;</A><A name=26_150></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,150) target=_top>&#64421;&#64422;&#64423;</A><br><A name=26_150></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,150) target=_top>&#64424;</A><A name=26_151></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,151) target=_top>&#64425;&#64426;&#64427;&#64428;&#64429;</A><A name=26_152></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,152) target=_top>&#64430;&#64431;&#64432;&#64433;</A><br><A name=26_152></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,152) target=_top>&#64467;&#64468;&#64469;</A><A name=26_153></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,153) target=_top>&#64470;&#64471;&#64472;&#64473;&#64474;&#64475;</A><A name=26_154></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,154) target=_top>&#64476;&#64477;</A><br><A name=26_154></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,154) target=_top>&#64478;&#64479;&#64480;&#64481;&#64482;&#64483;&#64484;&#64485;&#64486;&#64487;</A><A name=26_155></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,155) target=_top>&#64488;</A><br><A name=26_155></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,155) target=_top>&#64489;&#64490;&#64491;&#64492;&#64493;&#64494;&#64495;&#64496;&#64497;</A><A name=26_156></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,156) target=_top>&#64498;&#64499;</A><br><A name=26_156></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,156) target=_top>&#64500;&#64501;&#64502;&#64503;&#64504;&#64505;</A><A name=26_157></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,157) target=_top>&#64506;&#64507;</A><br><A name=26_157></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,157) target=_top>&#64508;&#64509;</A><A name=26_158></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,158) target=_top>&#64510;&#64511;&#64512;&#64513;&#64514;&#64515;&#64516;&#64517;&#64518;&#64519;</A><br><A name=26_158></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,158) target=_top>&#64520;&#64521;&#64522;</A><A name=26_159></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(26,159) target=_top>&#64523;&#64524;&#64525;&#64526;&#64527;&#64528;</A></SPAN>
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
<td colspan=3 align="center" ><b><Font Size="4"> &#x0663;&#x0667;&#x0663; </Font></b></td>
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

