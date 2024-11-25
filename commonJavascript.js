<script language="Javascript">
// ===================================================================
// Author: Matt Kruse <matt@mattkruse.com>
// WWW: http://www.mattkruse.com/
//
// NOTICE: You may use this code for any purpose, commercial or
// private, without any further permission from the author. You may
// remove this notice from your final code if you wish, however it is
// appreciated by the author if at least my web site address is kept.
//
// You may *NOT* re-distribute this code in any way except through its
// use. That means, you can include it in your product, or your web
// site, or any other form where the code is actually being used. You
// may not put the plain javascript up on your site for download or
// include it in your javascript libraries for download. 
// If you wish to share this code with others, please just point them
// to the URL instead.
// Please DO NOT link directly to my .js files from your site. Copy
// the files to your server and use them there. Thank you.
// ===================================================================

// HISTORY
// ------------------------------------------------------------------
// May 17, 2003: Fixed bug in parseDate() for dates <1970
// March 11, 2003: Added parseDate() function
// March 11, 2003: Added "NNN" formatting option. Doesn't match up
//                 perfectly with SimpleDateFormat formats, but 
//                 backwards-compatability was required.

// ------------------------------------------------------------------
// These functions use the same 'format' strings as the 
// java.text.SimpleDateFormat class, with minor exceptions.
// The format string consists of the following abbreviations:
// 
// Field        | Full Form          | Short Form
// -------------+--------------------+-----------------------
// Year         | yyyy (4 digits)    | yy (2 digits), y (2 or 4 digits)
// Month        | MMM (name or abbr.)| MM (2 digits), M (1 or 2 digits)
//              | NNN (abbr.)        |
// Day of Month | dd (2 digits)      | d (1 or 2 digits)
// Day of Week  | EE (name)          | E (abbr)
// Hour (1-12)  | hh (2 digits)      | h (1 or 2 digits)
// Hour (0-23)  | HH (2 digits)      | H (1 or 2 digits)
// Hour (0-11)  | KK (2 digits)      | K (1 or 2 digits)
// Hour (1-24)  | kk (2 digits)      | k (1 or 2 digits)
// Minute       | mm (2 digits)      | m (1 or 2 digits)
// Second       | ss (2 digits)      | s (1 or 2 digits)
// AM/PM        | a                  |
//
// NOTE THE DIFFERENCE BETWEEN MM and mm! Month=MM, not mm!
// Examples:
//  "MMM d, y" matches: January 01, 2000
//                      Dec 1, 1900
//                      Nov 20, 00
//  "M/d/yy"   matches: 01/20/00
//                      9/2/00
//  "MMM dd, yyyy hh:mm:ssa" matches: "January 01, 2000 12:30:45AM"
// ------------------------------------------------------------------

var MONTH_NAMES=new Array('January','February','March','April','May','June','July','August','September','October','November','December','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
var DAY_NAMES=new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun','Mon','Tue','Wed','Thu','Fri','Sat');
function LZ(x) {return(x<0||x>9?"":"0")+x}

// ------------------------------------------------------------------
// isDate ( date_string, format_string )
// Returns true if date string matches format of format string and
// is a valid date. Else returns false.
// It is recommended that you trim whitespace around the value before
// passing it to this function, as whitespace is NOT ignored!
// ------------------------------------------------------------------
function isDate(val,format) {
	var date=getDateFromFormat(val,format);
	if (date==0) { return false; }
	return true;
	}

// -------------------------------------------------------------------
// compareDates(date1,date1format,date2,date2format)
//   Compare two date strings to see which is greater.
//   Returns:
//   1 if date1 is greater than date2
//   0 if date2 is greater than date1 of if they are the same
//  -1 if either of the dates is in an invalid format
// -------------------------------------------------------------------
function compareDates(date1,dateformat1,date2,dateformat2) {
	var d1=getDateFromFormat(date1,dateformat1);
	var d2=getDateFromFormat(date2,dateformat2);
	if (d1==0 || d2==0) {
		return -1;
		}
	else if (d1 > d2) {
		return 1;
		}
	return 0;
	}

// ------------------------------------------------------------------
// formatDate (date_object, format)
// Returns a date in the output format specified.
// The format string uses the same abbreviations as in getDateFromFormat()
// ------------------------------------------------------------------
function formatDate(date,format) {
	format=format+"";
	var result="";
	var i_format=0;
	var c="";
	var token="";
	var y=date.getYear()+"";
	var M=date.getMonth()+1;
	var d=date.getDate();
	var E=date.getDay();
	var H=date.getHours();
	var m=date.getMinutes();
	var s=date.getSeconds();
	var yyyy,yy,MMM,MM,dd,hh,h,mm,ss,ampm,HH,H,KK,K,kk,k;
	// Convert real date parts into formatted versions
	var value=new Object();
	if (y.length < 4) {y=""+(y-0+1900);}
	value["y"]=""+y;
	value["yyyy"]=y;
	value["yy"]=y.substring(2,4);
	value["M"]=M;
	value["MM"]=LZ(M);
	value["MMM"]=MONTH_NAMES[M-1];
	value["NNN"]=MONTH_NAMES[M+11];
	value["d"]=d;
	value["dd"]=LZ(d);
	value["E"]=DAY_NAMES[E+7];
	value["EE"]=DAY_NAMES[E];
	value["H"]=H;
	value["HH"]=LZ(H);
	if (H==0){value["h"]=12;}
	else if (H>12){value["h"]=H-12;}
	else {value["h"]=H;}
	value["hh"]=LZ(value["h"]);
	if (H>11){value["K"]=H-12;} else {value["K"]=H;}
	value["k"]=H+1;
	value["KK"]=LZ(value["K"]);
	value["kk"]=LZ(value["k"]);
	if (H > 11) { value["a"]="PM"; }
	else { value["a"]="AM"; }
	value["m"]=m;
	value["mm"]=LZ(m);
	value["s"]=s;
	value["ss"]=LZ(s);
	while (i_format < format.length) {
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) {
			token += format.charAt(i_format++);
			}
		if (value[token] != null) { result=result + value[token]; }
		else { result=result + token; }
		}
	return result;
	}
	
// ------------------------------------------------------------------
// Utility functions for parsing in getDateFromFormat()
// ------------------------------------------------------------------
function _isInteger(val) {
	var digits="1234567890";
	for (var i=0; i < val.length; i++) {
		if (digits.indexOf(val.charAt(i))==-1) { return false; }
		}
	return true;
	}
function _getInt(str,i,minlength,maxlength) {
	for (var x=maxlength; x>=minlength; x--) {
		var token=str.substring(i,i+x);
		if (token.length < minlength) { return null; }
		if (_isInteger(token)) { return token; }
		}
	return null;
	}
	
// ------------------------------------------------------------------
// getDateFromFormat( date_string , format_string )
//
// This function takes a date string and a format string. It matches
// If the date string matches the format string, it returns the 
// getTime() of the date. If it does not match, it returns 0.
// ------------------------------------------------------------------
function getDateFromFormat(val,format) {
	val=val+"";
	format=format+"";
	var i_val=0;
	var i_format=0;
	var c="";
	var token="";
	var token2="";
	var x,y;
	var now=new Date();
	var year=now.getYear();
	var month=now.getMonth()+1;
	var date=1;
	var hh=now.getHours();
	var mm=now.getMinutes();
	var ss=now.getSeconds();
	var ampm="";
	
	while (i_format < format.length) {
		// Get next token from format string
		c=format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length)) {
			token += format.charAt(i_format++);
			}
		// Extract contents of value based on format token
		if (token=="yyyy" || token=="yy" || token=="y") {
			if (token=="yyyy") { x=4;y=4; }
			if (token=="yy")   { x=2;y=2; }
			if (token=="y")    { x=2;y=4; }
			year=_getInt(val,i_val,x,y);
			if (year==null) { return 0; }
			i_val += year.length;
			if (year.length==2) {
				if (year > 70) { year=1900+(year-0); }
				else { year=2000+(year-0); }
				}
			}
		else if (token=="MMM"||token=="NNN"){
			month=0;
			for (var i=0; i<MONTH_NAMES.length; i++) {
				var month_name=MONTH_NAMES[i];
				if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) {
					if (token=="MMM"||(token=="NNN"&&i>11)) {
						month=i+1;
						if (month>12) { month -= 12; }
						i_val += month_name.length;
						break;
						}
					}
				}
			if ((month < 1)||(month>12)){return 0;}
			}
		else if (token=="EE"||token=="E"){
			for (var i=0; i<DAY_NAMES.length; i++) {
				var day_name=DAY_NAMES[i];
				if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) {
					i_val += day_name.length;
					break;
					}
				}
			}
		else if (token=="MM"||token=="M") {
			month=_getInt(val,i_val,token.length,2);
			if(month==null||(month<1)||(month>12)){return 0;}
			i_val+=month.length;}
		else if (token=="dd"||token=="d") {
			date=_getInt(val,i_val,token.length,2);
			if(date==null||(date<1)||(date>31)){return 0;}
			i_val+=date.length;}
		else if (token=="hh"||token=="h") {
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<1)||(hh>12)){return 0;}
			i_val+=hh.length;}
		else if (token=="HH"||token=="H") {
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<0)||(hh>23)){return 0;}
			i_val+=hh.length;}
		else if (token=="KK"||token=="K") {
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<0)||(hh>11)){return 0;}
			i_val+=hh.length;}
		else if (token=="kk"||token=="k") {
			hh=_getInt(val,i_val,token.length,2);
			if(hh==null||(hh<1)||(hh>24)){return 0;}
			i_val+=hh.length;hh--;}
		else if (token=="mm"||token=="m") {
			mm=_getInt(val,i_val,token.length,2);
			if(mm==null||(mm<0)||(mm>59)){return 0;}
			i_val+=mm.length;}
		else if (token=="ss"||token=="s") {
			ss=_getInt(val,i_val,token.length,2);
			if(ss==null||(ss<0)||(ss>59)){return 0;}
			i_val+=ss.length;}
		else if (token=="a") {
			if (val.substring(i_val,i_val+2).toLowerCase()=="am") {ampm="AM";}
			else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") {ampm="PM";}
			else {return 0;}
			i_val+=2;}
		else {
			if (val.substring(i_val,i_val+token.length)!=token) {return 0;}
			else {i_val+=token.length;}
			}
		}
	// If there are any trailing characters left in the value, it doesn't match
	if (i_val != val.length) { return 0; }
	// Is date valid for month?
	if (month==2) {
		// Check for leap year
		if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
			if (date > 29){ return 0; }
			}
		else { if (date > 28) { return 0; } }
		}
	if ((month==4)||(month==6)||(month==9)||(month==11)) {
		if (date > 30) { return 0; }
		}
	// Correct hours value
	if (hh<12 && ampm=="PM") { hh=hh-0+12; }
	else if (hh>11 && ampm=="AM") { hh-=12; }
	var newdate=new Date(year,month-1,date,hh,mm,ss);
	return newdate.getTime();
	}

// ------------------------------------------------------------------
// parseDate( date_string [, prefer_euro_format] )
//
// This function takes a date string and tries to match it to a
// number of possible date formats to get the value. It will try to
// match against the following international formats, in this order:
// y-M-d   MMM d, y   MMM d,y   y-MMM-d   d-MMM-y  MMM d
// M/d/y   M-d-y      M.d.y     MMM-d     M/d      M-d
// d/M/y   d-M-y      d.M.y     d-MMM     d/M      d-M
// A second argument may be passed to instruct the method to search
// for formats like d/M/y (european format) before M/d/y (American).
// Returns a Date object or null if no patterns match.
// ------------------------------------------------------------------
function parseDate(val) {
	var preferEuro=(arguments.length==2)?arguments[1]:false;
	generalFormats=new Array('y-M-d','MMM d, y','MMM d,y','y-MMM-d','d-MMM-y','MMM d');
	monthFirst=new Array('M/d/y','M-d-y','M.d.y','MMM-d','M/d','M-d');
	dateFirst =new Array('d/M/y','d-M-y','d.M.y','d-MMM','d/M','d-M');
	var checkList=new Array('generalFormats',preferEuro?'dateFirst':'monthFirst',preferEuro?'monthFirst':'dateFirst');
	var d=null;
	for (var i=0; i<checkList.length; i++) {
		var l=window[checkList[i]];
		for (var j=0; j<l.length; j++) {
			d=getDateFromFormat(val,l[j]);
			if (d!=0) { return new Date(d); }
			}
		}
	return null;
	}


	function trim(stringToTrim)
	{
		return stringToTrim.replace(/^\s+|\s+$/g,"");
	}



function OpenCloseMoreTravel(sFrom,sValue)
{
	if (sFrom=="TI1" && sValue=="Y")
	{
		$("#DepartureStar1").show();
		$("#ifAvailable1").html('&#41;');
		document.getElementById('OpenCloseTI2').style.display='block';
		//document.getElementById('OpenCloseDepDate').style.display='block';
		//document.getElementById('OpenCloseRetDate').style.display='block';
		document.getElementById('OpenCloseDepDate').removeAttribute("style");
		document.getElementById('OpenCloseRetDate').removeAttribute("style");
	}else
	if (sFrom=="TI1" && sValue=="N")
	{
		$("select[name='RetDte1'],[name='RetMth1'],[name='RetYr1']").val('');
		$("select[name='DepDte2'],[name='DepMth2'],[name='DepYr2']").val('');
		$("select[name='RetDte2'],[name='RetMth2'],[name='RetYr2']").val('');
		$("#DepartureStar1").hide();
		$("#ifAvailable1").html('<br>&nbsp;&nbsp;if available &#41;');
		document.getElementById('OpenCloseTI2').style.display='none';
		document.getElementById('OpenCloseTI3').style.display='none';
		document.getElementById('OpenCloseTI4').style.display='none';
		document.getElementById('OpenCloseTI5').style.display='none';
		document.getElementById('OpenCloseTI6').style.display='none';
		document.getElementById('OpenCloseDepDate').style.display='none';
		document.getElementById('OpenCloseRetDate').style.display='none';
		
		document.form1.TI2[1].checked=true;
		document.form1.TI3[1].checked=true;
		document.form1.TI4[1].checked=true;
		document.form1.TI5[1].checked=true;
		
		document.form1.DestCountryCd2.value="";
		document.form1.DestCountryCd3.value="";
		document.form1.DestCountryCd4.value="";
		document.form1.DestCountryCd5.value="";
	}else
	if (sFrom=="TI2" && sValue=="Y")
	{
		$("#DepartureStar2").show();
		$("#ifAvailable2").html('&#41;');
		document.getElementById('OpenCloseTI3').style.display='block';
	}
	else
	if (sFrom=="TI2" && sValue=="N")
	{
		$("select[name='RetDte2'],[name='RetMth2'],[name='RetYr2']").val('');
		$("select[name='DepDte3'],[name='DepMth3'],[name='DepYr3']").val('');
		$("select[name='RetDte3'],[name='RetMth3'],[name='RetYr3']").val('');
		$("#DepartureStar2").hide();
		$("#ifAvailable2").html('<br>&nbsp;&nbsp;if available &#41;');
		document.getElementById('OpenCloseTI3').style.display='none';
		document.getElementById('OpenCloseTI4').style.display='none';
		document.getElementById('OpenCloseTI5').style.display='none';
		document.getElementById('OpenCloseTI6').style.display='none';
		
		document.form1.TI3[1].checked=true;
		document.form1.TI4[1].checked=true;
		document.form1.TI5[1].checked=true;
		
		document.form1.DestCountryCd3.value="";
		document.form1.DestCountryCd4.value="";
		document.form1.DestCountryCd5.value="";
		
	}if (sFrom=="TI3" && sValue=="Y")
	{
		$("#DepartureStar3").show();
		$("#ifAvailable3").html('&#41;');
		document.getElementById('OpenCloseTI4').style.display='block';
		
	}else
	if (sFrom=="TI3" && sValue=="N")
	{
		$("select[name='RetDte3'],[name='RetMth3'],[name='RetYr3']").val('');
		$("select[name='DepDte4'],[name='DepMth4'],[name='DepYr4']").val('');
		$("select[name='RetDte4'],[name='RetMth4'],[name='RetYr4']").val('');
		$("#DepartureStar3").hide();
		$("#ifAvailable3").html('<br>&nbsp;&nbsp;if available &#41;');
		document.getElementById('OpenCloseTI4').style.display='none';
		document.getElementById('OpenCloseTI5').style.display='none';
		document.getElementById('OpenCloseTI6').style.display='none';
		
		document.form1.TI4[1].checked=true;
		document.form1.TI5[1].checked=true;
		
		document.form1.DestCountryCd4.value="";
		document.form1.DestCountryCd5.value="";
		
	}if (sFrom=="TI4" && sValue=="Y")
	{
		$("#DepartureStar4").show();
		$("#ifAvailable4").html('&#41;');
		document.getElementById('OpenCloseTI5').style.display='block';
		
	}else
	if (sFrom=="TI4" && sValue=="N")
	{
		$("select[name='RetDte4'],[name='RetMth4'],[name='RetYr4']").val('');
		$("select[name='DepDte5'],[name='DepMth5'],[name='DepYr5']").val('');
		$("select[name='RetDte5'],[name='RetMth5'],[name='RetYr5']").val('');
		$("#DepartureStar4").hide();
		$("#ifAvailable4").html('<br>&nbsp;&nbsp;if available &#41;');
		document.getElementById('OpenCloseTI5').style.display='none';
		document.getElementById('OpenCloseTI6').style.display='none';
		
		document.form1.TI5[1].checked=true;
		
		document.form1.DestCountryCd5.value="";
	}
	
	
}

function OpenClose()
{
	
        var TI1Value="";
	var TI2Value="";
        var TI3Value="";
        var TI4Value="";
	var TI5Value="";

	for (counter = 0; counter < document.form1.TI1.length; counter++)
	{
		if (document.form1.TI1[counter].checked)
		{
			TI1Value=document.form1.TI1[counter].value;
		}
	}

        for (counter = 0; counter < document.form1.TI2.length; counter++)
	{
		if (document.form1.TI2[counter].checked)
		{
			TI2Value=document.form1.TI2[counter].value;
		}
	}

         for (counter = 0; counter < document.form1.TI3.length; counter++)
	{
		if (document.form1.TI3[counter].checked)
		{
			TI3Value=document.form1.TI3[counter].value;
		}
	}	
   
         for (counter = 0; counter < document.form1.TI4.length; counter++)
	{
		if (document.form1.TI4[counter].checked)
		{
			TI4Value=document.form1.TI4[counter].value;
		}
	}	 

     if(document.getElementById('DestCountryCd2').value!="")
    {
		document.getElementById('OATI2').style.display='';
		document.getElementById('CityTI2').style.display='';
		document.getElementById('DepDateTI2').style.display='';
		document.getElementById('ReturnDateTI2').style.display='';
		
		
    }else
     if(document.getElementById('DestCountryCd2').value=="")
    {
		document.getElementById('OATI2').style.display='none';
		document.getElementById('CityTI2').style.display='none';
		document.getElementById('DepDateTI2').style.display='none';
		document.getElementById('ReturnDateTI2').style.display='none';
    }
    
    if(document.getElementById('DestCountryCd3').value!="")
    {
		document.getElementById('OATI3').style.display='';
		document.getElementById('CityTI3').style.display='';
		document.getElementById('DepDateTI3').style.display='';
		document.getElementById('ReturnDateTI3').style.display='';
		
		
    }else
     if(document.getElementById('DestCountryCd3').value=="")
    {
		document.getElementById('OATI3').style.display='none';
		document.getElementById('CityTI3').style.display='none';
		document.getElementById('DepDateTI3').style.display='none';
		document.getElementById('ReturnDateTI3').style.display='none';
    }

    
     if(document.getElementById('DestCountryCd4').value!="")
    {
		document.getElementById('OATI4').style.display='';
		document.getElementById('CityTI4').style.display='';
		document.getElementById('DepDateTI4').style.display='';
		document.getElementById('ReturnDateTI4').style.display='';
		
		
    }else
     if(document.getElementById('DestCountryCd4').value=="")
    {
		document.getElementById('OATI4').style.display='none';
		document.getElementById('CityTI4').style.display='none';
		document.getElementById('DepDateTI4').style.display='none';
		document.getElementById('ReturnDateTI4').style.display='none';
    }

	 	
	if(document.getElementById('DestCountryCd5').value!="")
    {
		document.getElementById('OATI5').style.display='';
		document.getElementById('CityTI5').style.display='';
		document.getElementById('DepDateTI5').style.display='';
		document.getElementById('ReturnDateTI5').style.display='';
		
		
    }else
     if(document.getElementById('DestCountryCd5').value=="")
    {
		document.getElementById('OATI5').style.display='none';
		document.getElementById('CityTI5').style.display='none';
		document.getElementById('DepDateTI5').style.display='none';
		document.getElementById('ReturnDateTI5').style.display='none';
    }
  
    
  return true;
}

function imposeMaxLength(Object, MaxLen)
{
  return (Object.value.length <= MaxLen);
}


function apply()
{
  document.form1.Updsubmit.disabled=true;
  if(document.form1.chk.checked==true)
  {
    document.form1.Updsubmit.disabled=false;
  }
  if(document.form1.chk.checked==false)
  {
    document.form1.Updsubmit.enabled=false;
  }
}

function echeck(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)

// This is not needed because Personal Email is not compulsory
//		if (str.indexOf(at)==-1){
//		   alert("Please enter a valid Email Account")
//		   document.form1.PersEmail
//		   return false
//		}

		if (str != "")
		{
			if (str.indexOf(at)==-1){
				alert("Please enter a valid Email Account");
				document.form1.PersEmail
				return false;
			}

			if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
			   alert("Please enter a valid Email Account");
			   return false;
			}

			if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
			    alert("Please enter a valid Email Account");
			    return false;
			}

			 if (str.indexOf(at,(lat+1))!=-1){
			    alert("Please enter a valid Email Account");
			    return false;
			 }

			 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
			    alert("Please enter a valid Email Account");
			    return false;
			 }

			 if (str.indexOf(dot,(lat+2))==-1){
			    alert("Please enter a valid Email Account");
			    return false;
			 }

			 if (str.indexOf(" ")!=-1){
			    alert("Please enter a valid Email Account");
			    return false;
			 }
		}
	return true
}

function limitText(limitField, limitCount, limitNum)
{
  if (limitField.value.length > limitNum)
  {
	limitField.value = limitField.value.substring(0, limitNum);
  }
  else
  {
	limitCount.value = limitNum - limitField.value.length;
  }
}

function IsNumeric(strString)
{
   var strValidChars = "0123456789-+()\/ ";
   var strChar;
   var blnResult = true;

   if (strString.length == 0) return false;

   //  test strString consists of valid characters listed above
   for (i = 0; i < strString.length && blnResult == true; i++)
      {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         }
      }
   return blnResult;
}

//Date Validation
function IsInvalidDate(ssday,ssmonth,ssyear) {
	if (ssday > 31)
		return true;
	else if ((ssmonth ==4)||(ssmonth ==6)||(ssmonth ==9)||(ssmonth ==11)) {
		if (ssday>30)
			return true;
	}
	else if (ssmonth==2) {
		if (ssday==29) {
			if ((ssyear % 4)> 0) {
				return true;
			}
		}
		else if (ssday > 28)	{
			return true;
		}
	}
	return false;
}

function chkconfirm(form1) {

	var tmpPersMobileNum=document.form1.PersMobileNum;
	
	document.form1.PersMobileNum.value		= document.form1.PersMobileNum.value.replace(/^\s+|\s+$/g, '');
	document.form1.PersEmail.value		= document.form1.PersEmail.value.replace(/^\s+|\s+$/g, '');
	document.form1.NOKName.value		= document.form1.NOKName.value.replace(/^\s+|\s+$/g, '');
	document.form1.NOKHomeNum.value		= document.form1.NOKHomeNum.value.replace(/^\s+|\s+$/g, '');
	document.form1.NOKMobileNum.value		= document.form1.NOKMobileNum.value.replace(/^\s+|\s+$/g, '');
	//document.form1.DestCity.value		= document.form1.DestCity.value.replace(/^\s+|\s+$/g, '');
	//document.form1.DestAddr.value		= document.form1.DestAddr.value.replace(/^\s+|\s+$/g, '');
	document.form1.DestContactNum.value		= document.form1.DestContactNum.value.replace(/^\s+|\s+$/g, '');
	document.form1.OrgContact.value		= document.form1.OrgContact.value.replace(/^\s+|\s+$/g, '');
       
	
	if (document.form1.PersMobileNum.value=="")
	{
		alert("Please enter a valid Personal Contact No.");
		tmpPersMobileNum.focus();
		return false;
	}
	
	if (IsNumeric(tmpPersMobileNum.value)==false){
		//tmpPersMobileNum.value="";
		alert("Please enter a valid Personal Contact No.");
		tmpPersMobileNum.focus();
		return false;
	 }

	 var emailID=document.form1.PersEmail
	 if (echeck(emailID.value)==false){
//		emailID.value="";
		emailID.focus();
		return false;
	 }

	 if (document.form1.BloodType.value == "")
	 {
		alert("Please select a Blood Type.");
		document.form1.BloodType.focus();
		return false;
	 }

     if (document.form1.NOKName.value == "")
     {
		alert("Please enter a Name of Contact of Emergency Contact/Next-of-Kin..");
        document.form1.NOKName.focus();
        return false;
     }

	  if (document.form1.NOKHomeNum.value == "")
     {
		alert("Please enter a Home Contact No. of Emergency Contact/Next-of-Kin.");
        document.form1.NOKHomeNum.focus();
        return false;
     }else
     {
		if (IsNumeric(document.form1.NOKHomeNum.value)==false){
		alert("Please enter a valid Home Contact No. of Emergency Contact/Next-of-Kin.");
		document.form1.NOKHomeNum.focus();
		return false;
	 }
     }


     if (document.form1.NOKMobileNum.value.trim == "")
     {
		alert("Please enter a valid Mobile Contact No. of Emergency Contact/Next-of-Kin.");
        document.form1.NOKMobileNum.focus();
        return false;
     }

	var tmpNOKMobileNum=document.form1.NOKMobileNum
	 if (IsNumeric(tmpNOKMobileNum.value)==false){
		alert("Please enter a valid Mobile Contact No. of Emergency Contact/Next-of-Kin.");
		tmpNOKMobileNum.focus();
		return false;
	 }


	if ($('input[name=PurposeType]:checked').val() =="O")
	 {
		if($('#UserType').val()=="STAFF"  && document.form1.StaffDDl.value == "")
		{
		 alert("Please select purpose of official travel.");
		 document.form1.StaffDDl.focus();
		 return false;
		}
		else if($('#UserType').val()!="STAFF"  && document.form1.StudentDDl.value == "")
		{
		 alert("Please select purpose of official travel.");
		 document.form1.StudentDDl.focus();
		 return false;
		}

		if(document.form1.OfficialPurpose.value=="" && (document.form1.StaffDDl.value =="STF999" || document.form1.StudentDDl.value == "STU999"))
		{
		 alert("Please specify the purpose.");
		 document.form1.OfficialPurpose.focus();
		 return false;
		}
	 }
 	








    if (document.getElementById('OverseasContact').style.display== "inline")
    {
     if (document.form1.DestContactNum.value == "")
     {
		alert("Please enter Contact No. While Travelling.");
        document.form1.DestContactNum.focus();
        return false;
     }
     
     var tmpDestContactNum=document.form1.DestContactNum;
	 if (IsNumeric(tmpDestContactNum.value)==false){
//		tmpDestContactNum.value="";
		alert("Please enter a valid Contact No. While Travelling.");
		tmpDestContactNum.focus();
		return false
	 }
    }

	
     if (document.form1.PersMobileNum.value == "")
     {
		alert("Please enter your Contact No.");
        document.form1.PersMobileNum.focus();
        return false;
     }

    
    var TI1Value="";
    var TI2Value="";
    var TI3Value="";
    var TI4Value="";
    var TI5Value="";

	for (counter = 0; counter < document.form1.TI1.length; counter++)
	{
		// If a radio button has been selected it will return true
		// (If not it will return false)
		if (document.form1.TI1[counter].checked)
		{
			TI1Value=document.form1.TI1[counter].value;
		}
	}

        for (counter = 0; counter < document.form1.TI2.length; counter++)
	{
		if (document.form1.TI2[counter].checked)
		{
			TI2Value=document.form1.TI2[counter].value;
		}
	}

        for (counter = 0; counter < document.form1.TI3.length; counter++)
	{
		if (document.form1.TI3[counter].checked)
		{
			TI3Value=document.form1.TI3[counter].value;
			
		}
	}

        for (counter = 0; counter < document.form1.TI4.length; counter++)
	{
		// If a radio button has been selected it will return true
		// (If not it will return false)
		if (document.form1.TI4[counter].checked)
		{
			TI4Value=document.form1.TI4[counter].value;
			
		}
	}

         for (counter = 0; counter < document.form1.TI5.length; counter++)
	{
		if (document.form1.TI5[counter].checked)
		{
			TI5Value=document.form1.TI5[counter].value;
			
		}
	}
	
	    
    //check if first more country is selected then no need check Arrival and Departure Date 1
    if (TI1Value=="N")
    {
if(document.form1.DepDte1.value==""||document.form1.DepMth1.value==""||document.form1.DepYr1.value=="")
{
	alert("Please select a valid Arrival Date.");
	document.form1.DepDte1.focus();
	return false;
}
		

	if (checkFirstCity('N')==false) return false;
		
    }else
    if (TI1Value=="Y")
    {
	
	if (checkFirstCity('Y')==false) return false;
        
	if (checkFirstCity2(2)==false) return false;

    }
	
     //alert("b4 TI2Value");  
     if (TI2Value=="Y")
     {
         if (checkFirstCity3(3)==false) return false; 
     }

     //alert("b4 TI3Value"); 
     if (TI3Value=="Y")
     {
          if (checkFirstCity4(4)==false) return false; 
     }
      
     //alert("b4 TI4Value"); 
     if (TI4Value=="Y")
     {
          if (checkFirstCity5(5)==false) return false; 
     }    


     //alert("b4 TI5Value"); 
     if (TI5Value=="Y")
     {
          if (checkFirstCity6(6)==false) return false;
     }    
       
        //alert("b4 orgContact"); 
	var tmpDestContactNum=document.form1.OrgContact;
	if (tmpDestContactNum.value!="")
	{
		if (IsNumeric(tmpDestContactNum.value)==false)
		{
			alert("Please enter a valid Organisation Contact.");
			tmpDestContactNum.focus();
			return false;
		}
	}
	
         
         //alert("b4 checked"); 
	//Check if declaration is checked before submission
	if (document.form1.chk.checked != 1) {
		alert("Please click on the checkbox if you agree and accept the declaration clause.");
		return false;
	}

	return true;
}

function checkFirstCity2(i)
{
	Deptcountry="document.form1.DeptCountryCd"+i+".value";
	Deptcity = "document.form1.DeptCity"+i+".value.replace(/^\s+|\s+$/g, '')";

	country="document.form1.DestCountryCd"+i+".value";
	city = "document.form1.DestCity"+i+".value.replace(/^\s+|\s+$/g, '')";
	DestAddr = "document.form1.DestAddr"+i+".value.replace(/^\s+|\s+$/g, '')";
			
	DepYr="document.form1.DepYr"+i+".value";
	DepMth="document.form1.DepMth"+i+".value";
	DepDte="document.form1.DepDte"+i+".value";
	RetYr="document.form1.RetYr"+i+".value";
	RetMth="document.form1.RetMth"+i+".value";

	RetDte="document.form1.RetDte"+i+".value";

	if (eval(Deptcountry)=="")
	{
		alert("Please select Departure Country for Country/City " + i);     
		document.form1.DeptCountryCd2.focus();                           
		return false;
	}
		
	if (eval(Deptcity)=="")
	{
		alert("Please enter Departure City for Country/City " + i);
		document.form1.DeptCity2.focus();
		return false;
        }

        if (eval(country)=="")
	{
		alert("Please select Destination Country for Country/City " + i);     
		document.form1.DestCountryCd2.focus();                           
		return false;
	}
		
	if (eval(city)=="")
	{
		alert("Please enter Destination City for Country/City " + i);
		document.form1.DestCity2.focus();
		return false;
        }
			
		
	if (eval(DestAddr)=="")
	{
		alert("Please enter Destination Address for Country/City " + i);
		document.form1.DestAddr2.focus();  
		return false;                              
	}

	if (IsInvalidDate(eval(DepDte),eval(DepMth),eval(DepYr.value))) 
	{
		alert("Please select a valid Arrival Date.");
		document.form1.DepDte2.focus();
		return false;
	}

	if (IsInvalidDate(eval(RetDte),eval(RetMth),eval(RetYr))) 
        {
		alert("Please select a valid Departure Date.");
		document.form1.RetDte2.focus();
		return false;
	}	
	
	var tmpDepDte=new Date(eval(DepYr), eval(DepMth)-1, eval(DepDte));
	var tmpRetDte=new Date(eval(RetYr), eval(RetMth)-1, eval(RetDte));	
	
	
		var pastDate = new Date();
		pastDate.setDate(pastDate.getDate() - 365);


if($( 'input[name='+'TI'+i+']:checked' ).val()=="N")
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte2.focus();
			return false;
		}

}
else
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte2.focus();
			return false;
		}
		if (tmpRetDte < pastDate) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte2.focus();
			return false;
		}
	if(tmpDepDte > tmpRetDte)
	{				
		alert("Your Arrival Date must be earlier than your Departure Date for Country/City " + i);
		return false;                                
	}
}
}

function checkFirstCity3(i)
{
	Deptcountry="document.form1.DeptCountryCd"+i+".value";
	Deptcity = "document.form1.DeptCity"+i+".value.replace(/^\s+|\s+$/g, '')";

	country="document.form1.DestCountryCd"+i+".value";
	city = "document.form1.DestCity"+i+".value.replace(/^\s+|\s+$/g, '')";
	DestAddr = "document.form1.DestAddr"+i+".value.replace(/^\s+|\s+$/g, '')";
			
	DepYr="document.form1.DepYr"+i+".value";
	DepMth="document.form1.DepMth"+i+".value";
	DepDte="document.form1.DepDte"+i+".value";
	RetYr="document.form1.RetYr"+i+".value";
	RetMth="document.form1.RetMth"+i+".value";

	RetDte="document.form1.RetDte"+i+".value";


	if (eval(Deptcountry)=="")
	{
		alert("Please select Departure Country for Country/City " + i);     
		document.form1.DeptCountryCd3.focus();                           
		return false;
	}
		
	if (eval(Deptcity)=="")
	{
		alert("Please enter Departure City for Country/City " + i);
		document.form1.DeptCity3.focus();
		return false;
        }

	if (eval(country)=="")
	{
		alert("Please select Destination Country for Country/City " + i);     
		document.form1.DestCountryCd3.focus();                           
		return false;
	}
		
	if (eval(city)=="")
	{
		alert("Please enter Destination City for Country/City " + i);
		document.form1.DestCity3.focus();
		return false;
        }
			
		
	if (eval(DestAddr)=="")
	{
		alert("Please enter Destination Address for Country/City " + i);
		document.form1.DestAddr3.focus();  
		return false;                              
	}

	if (IsInvalidDate(eval(DepDte),eval(DepMth),eval(DepYr.value))) 
	{
		alert("Please select a valid Arrival Date.");
		document.form1.DepDte3.focus();
		return false;
	}

	if (IsInvalidDate(eval(RetDte),eval(RetMth),eval(RetYr))) 
        {
		alert("Please select a valid Departure Date.");
		document.form1.RetDte3.focus();
		return false;
	}	
		
	
	var tmpDepDte=new Date(eval(DepYr), eval(DepMth)-1, eval(DepDte));
	var tmpRetDte=new Date(eval(RetYr), eval(RetMth)-1, eval(RetDte));	
	
		var pastDate = new Date();
		pastDate.setDate(pastDate.getDate() - 365);


if($( 'input[name='+'TI'+i+']:checked' ).val()=="N")
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte3.focus();
			return false;
		}
}
else
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte3.focus();
			return false;
		}
		if (tmpRetDte < pastDate) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte3.focus();
			return false;
		}
	if(tmpDepDte > tmpRetDte)
	{				
		alert("Your Arrival Date must be earlier than your Departure Date for Country/City " + i);
		return false;                                
	}
}
}

function checkFirstCity4(i)
{
	Deptcountry="document.form1.DeptCountryCd"+i+".value";
	Deptcity = "document.form1.DeptCity"+i+".value.replace(/^\s+|\s+$/g, '')";

	country="document.form1.DestCountryCd"+i+".value";
	city = "document.form1.DestCity"+i+".value.replace(/^\s+|\s+$/g, '')";
	DestAddr = "document.form1.DestAddr"+i+".value.replace(/^\s+|\s+$/g, '')";
			
	DepYr="document.form1.DepYr"+i+".value";
	DepMth="document.form1.DepMth"+i+".value";
	DepDte="document.form1.DepDte"+i+".value";
	RetYr="document.form1.RetYr"+i+".value";
	RetMth="document.form1.RetMth"+i+".value";

	RetDte="document.form1.RetDte"+i+".value";
	
	if (eval(Deptcountry)=="")
	{
		alert("Please select Departure Country for Country/City " + i);     
		document.form1.DeptCountryCd4.focus();                           
		return false;
	}
		
	if (eval(Deptcity)=="")
	{
		alert("Please enter Departure City for Country/City " + i);
		document.form1.DeptCity4.focus();
		return false;
        }
        if (eval(country)=="")
	{
		alert("Please select Destination Country for Country/City " + i);     
		document.form1.DestCountryCd4.focus();                           
		return false;
	}
		
	if (eval(city)=="")
	{
		alert("Please enter Destination City for Country/City " + i);
		document.form1.DestCity4.focus();
		return false;
        }
			
		
	if (eval(DestAddr)=="")
	{
		alert("Please enter Destination Address for Country/City " + i);
		document.form1.DestAddr4.focus();  
		return false;                              
	}


	
	if (IsInvalidDate(eval(DepDte),eval(DepMth),eval(DepYr.value))) 
	{
		alert("Please select a valid Arrival Date.");
		document.form1.DepDte4.focus();
		return false;
	}

	if (IsInvalidDate(eval(RetDte),eval(RetMth),eval(RetYr))) 
        {
		alert("Please select a valid Departure Date.");
		document.form1.RetDte4.focus();
		return false;
	}	
			
	
	var tmpDepDte=new Date(eval(DepYr), eval(DepMth)-1, eval(DepDte));
	var tmpRetDte=new Date(eval(RetYr), eval(RetMth)-1, eval(RetDte));
	
		var pastDate = new Date();
		pastDate.setDate(pastDate.getDate() - 365);


if($( 'input[name='+'TI'+i+']:checked' ).val()=="N")
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte4.focus();
			return false;
		}
}
else
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte4.focus();
			return false;
		}
		if (tmpRetDte < pastDate) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte4.focus();
			return false;
		}
	if(tmpDepDte > tmpRetDte)
	{				
		alert("Your Arrival Date must be earlier than your Departure Date for Country/City " + i);
		return false;                                
	}
}

}

function checkFirstCity5(i)
{
	Deptcountry="document.form1.DeptCountryCd"+i+".value";
	Deptcity = "document.form1.DeptCity"+i+".value.replace(/^\s+|\s+$/g, '')";

	country="document.form1.DestCountryCd"+i+".value";
	city = "document.form1.DestCity"+i+".value.replace(/^\s+|\s+$/g, '')";
	DestAddr = "document.form1.DestAddr"+i+".value.replace(/^\s+|\s+$/g, '')";
			
	DepYr="document.form1.DepYr"+i+".value";
	DepMth="document.form1.DepMth"+i+".value";
	DepDte="document.form1.DepDte"+i+".value";
	RetYr="document.form1.RetYr"+i+".value";
	RetMth="document.form1.RetMth"+i+".value";

	RetDte="document.form1.RetDte"+i+".value";

	if (eval(Deptcountry)=="")
	{
		alert("Please select Departure Country for Country/City " + i);     
		document.form1.DeptCountryCd5.focus();                           
		return false;
	}
		
	if (eval(Deptcity)=="")
	{
		alert("Please enter Departure City for Country/City " + i);
		document.form1.DeptCity5.focus();
		return false;
        }

        if (eval(country)=="")
	{
		alert("Please select Destination Country for Country/City " + i);     
		document.form1.DestCountryCd5.focus();                           
		return false;
	}
		
	if (eval(city)=="")
	{
		alert("Please enter Destination City for Country/City " + i);
		document.form1.DestCity5.focus();
		return false;
        }
			
		
	if (eval(DestAddr)=="")
	{
		alert("Please enter Destination Address for Country/City " + i);
		document.form1.DestAddr5.focus();  
		return false;                              
	}
	

		
         if (IsInvalidDate(eval(DepDte),eval(DepMth),eval(DepYr.value))) 
	{
		alert("Please select a valid Arrival Date.");
		document.form1.DepDte5.focus();
		return false;
	}

	if (IsInvalidDate(eval(RetDte),eval(RetMth),eval(RetYr))) 
        {
		alert("Please select a valid Departure Date.");
		document.form1.RetDte5.focus();
		return false;
	}	
	
	var tmpDepDte=new Date(eval(DepYr), eval(DepMth)-1, eval(DepDte));
	var tmpRetDte=new Date(eval(RetYr), eval(RetMth)-1, eval(RetDte));
	
		var pastDate = new Date();
		pastDate.setDate(pastDate.getDate() - 365);


if($( 'input[name='+'TI'+i+']:checked' ).val()=="N")
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte5.focus();
			return false;
		}

}
else
{
		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte5.focus();
			return false;
		}
		if (tmpRetDte < pastDate) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte5.focus();
			return false;
		}
	if(tmpDepDte > tmpRetDte)
	{				
		alert("Your Arrival Date must be earlier than your Departure Date for Country/City " + i);
		return false;                                
	}
}

}

function checkFirstCity6(i)
{

	document.form1.PurposeTxt.value = document.form1.PurposeTxt.value.replace(/^\s+|\s+$/g, '');
	
	if (document.form1.PurposeTxt.value=="")
	{
		alert("Please enter Other Travelling Details");
		document.form1.PurposeTxt.focus();
		return false;
        }
			
}

function checkFirstCity(sYN)
{
	
	document.form1.DestCity1.value = document.form1.DestCity1.value.replace(/^\s+|\s+$/g, '');
	document.form1.DestAddr1.value= document.form1.DestAddr1.value.replace(/^\s+|\s+$/g, '');


	if (document.form1.DeptCountryCd1.value == "")
	{
		alert("Please select a Departure Country.");
		document.form1.DeptCountryCd1.focus();
		return false;
	}
	 
	if (document.form1.DeptCity1.value == "")
	{
		alert("Please enter a Departure City.");
		document.form1.DeptCity1.focus();
		return false;
	}

	if (document.form1.DestCountryCd1.value == "")
	{
		alert("Please select a Destination Country.");
		document.form1.DestCountryCd1.focus();
		return false;
	}
	 
	if (document.form1.DestCity1.value == "")
	{
		alert("Please enter a Destination City.");
		document.form1.DestCity1.focus();
		return false;
	}
		
	if (document.form1.DestAddr1.value == "")
	{
		alert("Please enter Destination Address.");
		document.form1.DestAddr1.focus();
		return false;
	}
		

	//if (IsInvalidDate(document.form1.DepDte.value,document.form1.DepMth.value,document.form1.DepYr.value)) 
	//{
	//	alert("Please select a valid From Date.");
	//	document.form1.DepDte.focus();
	//	return false;
	//}

	//if (IsInvalidDate(document.form1.RetDte.value,document.form1.RetMth.value,document.form1.RetYr.value)) 
        //{
	//	alert("Please select a valid To Date.");
	//	document.form1.RetDte.focus();
	//	return false;
	//}

	//Date check
	//Departure date must be before Return date
	//var tmpDepDte=new Date(document.form1.DepYr.value, document.form1.DepMth.value-1, document.form1.DepDte.value);
	//var tmpRetDte=new Date(document.form1.RetYr.value, document.form1.RetMth.value-1, document.form1.RetDte.value);

	//if(tmpDepDte > tmpRetDte)
	//{
	//	alert("Your From Date must be earlier than your To Date");
	//	return false;
	//}
   if (sYN=="Y") 
        {
		if (IsInvalidDate(document.form1.DepDte1.value,document.form1.DepMth1.value,document.form1.DepYr1.value)) 
		{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte1.focus();
			return false;
		}

		if (IsInvalidDate(document.form1.RetDte1.value,document.form1.RetMth1.value,document.form1.RetYr1.value)) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte1.focus();
			return false;
		}

		//Date check
		//Departure date must be before Return date
		var tmpDepDte=new Date(document.form1.DepYr1.value, document.form1.DepMth1.value-1, document.form1.DepDte1.value);
		var tmpRetDte=new Date(document.form1.RetYr1.value, document.form1.RetMth1.value-1, document.form1.RetDte1.value);

		var pastDate = new Date();
		pastDate.setDate(pastDate.getDate() - 365);

		if (tmpDepDte < pastDate) 
        	{
			alert("Please select a valid Arrival Date.");
			document.form1.DepDte1.focus();
			return false;
		}

		if (tmpRetDte < pastDate) 
        	{
			alert("Please select a valid Departure Date.");
			document.form1.RetDte1.focus();
			return false;
		}

		if(tmpDepDte > tmpRetDte)
		{
			alert("Your arrival date must be earlier than your departure date");
			return false;
		}

	}//if sYN
}

function DateChange(sID,sFrom,sType)
{
 if (sID=="")
{ 
 if (sFrom=="Dep")
 {

  if (sType=="D")
  {
   	document.form1.DepDte1.value=document.form1.DepDte.value;
        document.form1.RetDte1.value=document.form1.DepDte.value;	     

  }else
  if (sType=="M")
  {
	document.form1.DepMth1.value=document.form1.DepMth.value;
        document.form1.RetMth1.value=document.form1.DepMth.value;
  
  }else
  if (sType=="Y")
  {
	document.form1.DepYr1.value=document.form1.DepYr.value;
        document.form1.RetYr1.value=document.form1.DepYr.value;
  }
 }
}else
if (sID=="1")
{
  if (sFrom=="Dep")
 {

  if (sType=="D")
  {
   	document.form1.DepDte2.value=document.form1.RetDte1.value;
        document.form1.RetDte2.value=document.form1.RetDte1.value;	     

  }else
  if (sType=="M")
  {
	document.form1.DepMth2.value=document.form1.RetMth1.value;
        document.form1.RetMth2.value=document.form1.RetMth1.value;
  
  }else
  if (sType=="Y")
  {
	document.form1.DepYr2.value=document.form1.RetYr1.value;
        document.form1.RetYr2.value=document.form1.RetYr1.value;
  }
 }
}else
if (sID=="2")
{
  if (sFrom=="Dep")
 {

  if (sType=="D")
  {
   	document.form1.DepDte3.value=document.form1.RetDte2.value;	     
	document.form1.RetDte3.value=document.form1.RetDte2.value;

  }else
  if (sType=="M")
  {
	document.form1.DepMth3.value=document.form1.RetMth2.value;
	document.form1.RetMth3.value=document.form1.RetMth2.value;
  
  }else
  if (sType=="Y")
  {
	document.form1.DepYr3.value=document.form1.RetYr2.value;
	document.form1.RetYr3.value=document.form1.RetYr2.value;
  }
 }//dep
}else
if (sID=="3")
{
  if (sFrom=="Dep")
 {

  if (sType=="D")
  {
   	document.form1.DepDte4.value=document.form1.RetDte3.value;	
	document.form1.RetDte4.value=document.form1.RetDte3.value;     

  }else
  if (sType=="M")
  {
	document.form1.DepMth4.value=document.form1.RetMth3.value;
	document.form1.RetMth4.value=document.form1.RetMth3.value;
  
  }else
  if (sType=="Y")
  {
	document.form1.DepYr4.value=document.form1.RetYr3.value;
	document.form1.RetYr4.value=document.form1.RetYr3.value;
  }
 }//dep
}else
if (sID=="4")
{
  if (sFrom=="Dep")
 {

  if (sType=="D")
  {
   	document.form1.DepDte5.value=document.form1.RetDte4.value;	
	document.form1.RetDte5.value=document.form1.RetDte4.value;     

  }else
  if (sType=="M")
  {
	document.form1.DepMth5.value=document.form1.RetMth4.value;
	document.form1.RetMth5.value=document.form1.RetMth4.value;
  
  }else
  if (sType=="Y")
  {
	document.form1.DepYr5.value=document.form1.RetYr4.value;
	document.form1.RetYr5.value=document.form1.RetYr4.value;
  }
 }//dep
}

}//function

</script>