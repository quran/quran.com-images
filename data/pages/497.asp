
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
var nCurrSora      =44;
var nCurrAya       =19;
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
		var StrPage = "497";
		var strLength="169756";
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
<tr><td align=left dir=rtl><SPAN class=sc_F1>&#64396;&#64473;</span>
<td>&nbsp;</td>
<td align=right dir=rtl><SPAN class=sc_F1>&#64568;&#64593;</span>
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
					.sc_F0 {FONT-FAMILY:QCF_P497; FONT-SIZE: 22pt; mso-font-charset: 0}
					.sc_F1 {FONT-FAMILY:QCF_BSML; FONT-SIZE: 20pt; mso-font-charset: 0}

					</STYLE>
					<STYLE>
					<!--
					 	@font-face {
						font-family: QCF_P497;
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
							<SPAN class=sc_F0 style='line-height:165%'> <A name=44_19></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,19) target=_top>&#64337;&#64338;&#64339;&#64340;&#64341;&#64342;&#64343;&#64344;&#64345;&#64346;&#64347;</A><A name=44_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,20) target=_top>&#64348;&#64349;</A><br><A name=44_20></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,20) target=_top>&#64350;&#64351;&#64352;&#64353;&#64354;</A><A name=44_21></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,21) target=_top>&#64355;&#64356;&#64357;&#64358;&#64359;&#64360;</A><A name=44_22></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,22) target=_top>&#64361;</A><br><A name=44_22></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,22) target=_top>&#64362;&#64363;&#64364;&#64365;&#64366;&#64367;</A><A name=44_23></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,23) target=_top>&#64368;&#64369;&#64370;&#64371;</A><br><A name=44_23></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,23) target=_top>&#64372;&#64373;</A><A name=44_24></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,24) target=_top>&#64374;&#64375;&#64376;&#64377;&#64378;&#64379;&#64380;&#64381;</A><A name=44_25></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,25) target=_top>&#64382;</A><br><A name=44_25></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,25) target=_top>&#64383;&#64384;&#64385;&#64386;&#64387;</A><A name=44_26></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,26) target=_top>&#64388;&#64389;&#64390;&#64391;</A><A name=44_27></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,27) target=_top>&#64392;</A><br><A name=44_27></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,27) target=_top>&#64393;&#64394;&#64395;&#64396;</A><A name=44_28></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,28) target=_top>&#64397;&#64398;&#64399;&#64400;&#64401;&#64402;</A><br><A name=44_29></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,29) target=_top>&#64403;&#64404;&#64405;&#64406;&#64407;&#64408;&#64409;&#64410;&#64411;</A><A name=44_30></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,30) target=_top>&#64412;</A><br><A name=44_30></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,30) target=_top>&#64413;&#64414;&#64415;&#64416;&#64417;&#64418;&#64419;</A><A name=44_31></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,31) target=_top>&#64420;&#64421;&#64422;&#64423;</A><br><A name=44_31></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,31) target=_top>&#64424;&#64425;&#64426;&#64427;&#64428;</A><A name=44_32></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,32) target=_top>&#64429;&#64430;&#64431;&#64432;&#64433;</A><br><A name=44_32></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,32) target=_top>&#64467;&#64468;</A><A name=44_33></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,33) target=_top>&#64469;&#64470;&#64471;&#64472;&#64473;&#64474;&#64475;</A><br><A name=44_33></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,33) target=_top>&#64476;</A><A name=44_34></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,34) target=_top>&#64477;&#64478;&#64479;&#64480;</A><A name=44_35></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,35) target=_top>&#64481;&#64482;&#64483;&#64484;&#64485;&#64486;</A><br><A name=44_35></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,35) target=_top>&#64487;&#64488;&#64489;</A><A name=44_36></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,36) target=_top>&#64490;&#64491;&#64492;&#64493;&#64494;&#64495;</A><A name=44_37></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,37) target=_top>&#64496;</A><br><A name=44_37></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,37) target=_top>&#64497;&#64498;&#64499;&#64500;&#64501;&#64502;&#64503;&#64504;&#64505;&#64506;&#64507;&#64508;&#64509;</A><br><A name=44_37></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,37) target=_top>&#64510;</A><A name=44_38></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,38) target=_top>&#64511;&#64512;&#64513;&#64514;&#64515;&#64516;&#64517;&#64518;</A><br><A name=44_39></A><A class=black style='cursor: pointer; cursor: myhand;' onclick=ClickAyaArea(44,39) target=_top>&#64519;&#64520;&#64521;&#64522;&#64523;&#64524;&#64525;&#64526;&#64527;</A></SPAN>
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
<td colspan=3 align="center" ><b><Font Size="4"> &#x0664;&#x0669;&#x0667; </Font></b></td>
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

