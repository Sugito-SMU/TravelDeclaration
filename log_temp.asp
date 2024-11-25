<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="CommonFunction.asp"  -->
<script type="text/javascript" src="ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<%LogDate=Now()%>
<%
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select TOP 1 * FROM " & DBOWNER & "V_trace_temperature where UserAccountID=? ORDER BY LogDate DESC"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(UserAccountID))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set RecentTemp = CurrCmd.EXECUTE()



if not RecentTemp.EOF then
	RecentContactNum=trim(RecentTemp("PersContactNum"))
end if
%>
<%if Request.Form("Updsubmit")<>"" THEN
	'response.write(REQUEST.FORM("logday")&" "&Monthname(REQUEST.FORM("logmth"))&" "&REQUEST.FORM("logyr")&" "&REQUEST.FORM("loghr")&":"&REQUEST.FORM("logmin"))
	'response.end
	'LogDate=CDate(REQUEST.FORM("logday")&" "&Monthname(REQUEST.FORM("logmth"))&" "&REQUEST.FORM("logyr")&" "&REQUEST.FORM("logyh")&":"&REQUEST.FORM("logmin"))
	SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT = DBOWNER & "CSP_INSERT_TRACE_TEMPERATURE"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN	    			
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar,adParamInput,13,UserAccountID)
		'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("LogDate", adVarchar, adParamInput, 50, LogDate))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Temperature", adVarchar,adParamInput,8,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("temperature")))))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Comment", adVarWChar,adParamInput,500,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("comment")))))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersContactNum", adVarchar,adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PersContactNum")))))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NTLogin))))

		if REQUEST.FORM("TI1")="Y" then
		   CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsRespiratory", adVarchar, adParamInput,1,1)
		else
		   CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsRespiratory", adVarchar, adParamInput,1,0)
		end if

		if REQUEST.FORM("TI2")="Y" then
		   CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsQuarantine", adVarchar, adParamInput,1,1)
		else
		   CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsQuarantine", adVarchar, adParamInput,1,0)
		end if

		'Set in Stored Procedure
		'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedDte", adVarchar, adParamInput,20, Now())		
		CurrCmd.EXECUTE ,,adCmdStoredProc
	Response.Redirect "log_temp_result.asp"
END IF%>

<!-- #INCLUDE FILE="header_temperature.asp" -->
<script language="javascript">
 
$(function() {

$("input[name*='TI']").change(function(){
    if($('input[name=TI1]:checked' ).val()=="Y"||$('input[name=TI2]:checked' ).val()=="Y")
	$(".trDetails").show();
    else
	$(".trDetails").hide();
});
});

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
   var strValidChars = "0123456789.";
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

function IsValidPhone(strString)
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


//Functions which are form specific
function chkconfirm(form1) {


	if (document.form1.temperature.value == "")
	{
		alert("Invalid Temperature - Please choose a value from 35 to 42.");
		document.form1.temperature.focus();
		return false;
	} 

	if (isNaN(form1.temperature.value)) {
		alert("Invalid Temperature - Please choose a value from 35 to 42.");
		form1.temperature.focus();
		return false;
	}
	
	//Temperature Range 35 to 42
	if (parseFloat(form1.temperature.value) < 35 || parseFloat(form1.temperature.value) > 42) {
		alert("Invalid Temperature - Please choose a value from 35 to 42.");
		form1.temperature.focus();
		return false;
	}


	if ($('input[name=TI1]:checked').length == 0){
		alert("Please select whether you have any respiratory symptoms");	
		return false;
	 }


	if ($('input[name=TI2]:checked').length == 0){
		alert("Please select whether you have received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19");		
		return false;
	 }

	 if (IsValidPhone(form1.PersContactNum.value)==false){
		//PersContactNum.value="";
		alert("Please enter a valid Contact No.");		
		form1.PersContactNum.focus();
		return false;
	 }

	if(($('input[name=TI1]:checked' ).val()=="Y"||$('input[name=TI2]:checked' ).val()=="Y")&form1.comment.value==""){
		alert("Please enter Remarks");	
		form1.comment.focus();
		return false;
	}



	
	return true;
}

function CheckNumeric(e)
{
	if(window.event) // IE
	{
		keynum = e.keyCode;
	}
	else if(e.which) // Netscape/Firefox/Opera
	{
		keynum = e.which;
	}
	
   // Was key that was pressed a numeric character (0-9)?
   if ( keynum == 46 || (keynum > 47 && keynum < 58) )
      return; // if so, do nothing
   else
      window.event.returnValue = null; // otherwise, discard character
}

</script>

<form name="form1" method=post action="log_temp.asp" onsubmit="return chkconfirm(this)">
<table cellspacing="0" width="530" align="center" border="0">
<tr>
	<td>	
		<!-- Personal Info -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
		<tr>
			<td colspan="2" class=SectionHeader><b>Personal Information</b></td>
		</tr>	
		</table>
		<table class=SectionDetail width="100%" cellpadding="8">
		<tr>
			<td width="35%"><b>Name:</b></td>
			<td width="65%"> <%=ValidateXSSHTML(Username)%></td>
		</tr>
		<% if NRIC_FIN_PP <> "" then %>
		<tr>
			<td width="35%"><b>NRIC/FIN/Passport No.:</b></td>
			<td width="65%"> <%=ValidateAndEncodeXSSEx(NRIC_FIN_PP)%></td>
		</tr>
		<% end if %>
		<tr>
			<td><b>School/Office:</b></td>
			<td><%=ValidateXSSHTML(DepartmentName)%></td>
		</tr>	
		</table>

		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>
				
		<!-- Temperature Control -->		
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
		<tr>
			<td class=SectionHeader><b>Temperature Recording</b></td>
			<td class=SectionHeader align="right" valign="bottom"><a href="log_temp_history.asp"><font face="Tahoma" size="1" color="white">View Temperature History</font></a></td>
		</tr>	
		</table>
		<table class=SectionDetail width="100%" cellpadding="8" border="0">
		<tr>
			<td width="35%">Date:</td>
			<td width="65%"><%=Day(LogDate)%>-<%=Monthname(month(LogDate))%>-<%=year(LogDate)%>&nbsp;&nbsp;<%=FormatDateTime((LogDate),3)%></td>
		</tr>			
		<tr>
			<td width="35%"><font color="red">*&nbsp;</font><b>Temperature:</b></td>
			<td width="65%"><input type=text name="temperature" value="" size="5" maxlength="4" onkeypress="return CheckNumeric(event)">&nbsp;&#176;C (Degree Celcius)</td>
		</tr>




			
		<tr>
			<td width="100%" colspan="2"><font color="red">*&nbsp;</font><b>Do you have any respiratory symptoms (e.g. cough, shortness of breath etc.)?</b></td>
		</tr>
		<tr>
    			<td width="100%" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp; Yes
			<input type="radio" name="TI1" value="Y">
			&nbsp;&nbsp;&nbsp;&nbsp; No <input type="radio" name="TI1" value="N" ></td>
		</tr>
			
		<tr>
			<td width="100%" colspan="2"><font color="red">*&nbsp;</font><b>Have you received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19?</b></td>
			
		</tr>
		<tr>
    			<td width="100%" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp; Yes
			<input type="radio" name="TI2" value="Y" >
			&nbsp;&nbsp;&nbsp;&nbsp; No <input type="radio" name="TI2" value="N" ></td>
		</tr>
	
		<tr class="trDetails" style="display:none;">
			<td width="100%" colspan="2"><b>If yes, please provide further details under “Remarks” (e.g. Had cough since DD/MM/YY, had been in close contact who is a confirmed case of Covid-19. )</b></td>
			
		</tr>






	<tr>
		<td><b><font color="red">*</font>&nbsp;Contact No.:</b></td>
	<td><input type=text name="PersContactNum" value="<%=ValidateAndEncodeXSSEx(RecentContactNum)%>" size="30" maxlength="30"></td>
	</tr>	

		<tr>
			<td width="35%" valign="top"><b><font color="red" class="trDetails" style="display:none;">*&nbsp;</font>Remarks:</b></td>
			<td width="65%">
				<textarea cols="39" rows="8" name="comment" maxlength="500" onKeyDown="limitText(document.form1.comment,document.form1.countdown1,500);" onKeyUp="limitText(document.form1.comment,document.form1.countdown1,500);"></textarea>
				<font size="1"><input readonly type="text" name="countdown1" size="3" value="500"> characters left</font>
			</td>

		</tr>
		<tr>
			<td align=center colspan="2"><input type="reset" value="Reset" id=reset1 name=reset1>&nbsp;<input type="submit" name="Updsubmit" value="Submit"></td>
		</tr>
		</table>		
		
		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>	
	
		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td><font color="red">*&nbsp;<i>Compulsory Fields</i></font></td>
		</tr>
		</table>	
	
		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>
		
	</td>
</tr>
</table>
<!-- #INCLUDE FILE="footer.asp" -->
<%OBJCONN.CLOSE%>