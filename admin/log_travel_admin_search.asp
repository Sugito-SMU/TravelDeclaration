<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->

<%LogDate=Now()%>

<html>
<head>
	<title>Administrator's Panel</title>
	<link rel="stylesheet" href="../tracing.css" type="text/css">
</head>
<body>
	<table width="750"  border="0" cellspacing="0" cellpadding="5"  align="center" bgcolor="#ffffff">
	<tr><td>


<script language="javascript">
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
	
	var amp="%";
	var s = document.form1.searchstring.value;	
	s = s.replace(/^\s+|\s+$/g, '');	
	if (s == "")
	{
		alert("Please enter a search criteria");
		document.form1.searchstring.value ="";
		document.form1.searchstring.focus();
		return false;
	}	
	else
	{
		if (s.indexOf(amp)!=-1){
				alert("% is a special character. Please re-enter the search value");
				document.form1.searchstring.focus();
				return false;
			}
		
		if (s.length < 3){
				alert("Please enter a valid search value. Minimum 3 characters.");
				document.form1.searchstring.focus();
				return false;
		}
	
	}
		
	return true;
}

</script>

<form name="form1" method=post action="log_travel_admin_search.asp" onsubmit="return chkconfirm(this)">
<table cellspacing="0" width="100%" align="center" border="0">
<tr>
	<td>					
		<!-- Temperature Control -->		
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
		<tr>
			<td class=SectionHeader colspan="2"><b>Administrator's Panel</b></td>
		</tr>	
		</table>
		<table class=SectionDetail width="100%" cellpadding="8" border="0">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<table width="600" border="0" bordercolor="black">
				<tr>
					<td align="left" colspan="3">&nbsp;&nbsp;<input type=text name="searchstring" value="<%=ValidateXSSHTML(Request.Form("searchstring"))%>" size="50" maxlength="100">&nbsp;&nbsp;&nbsp;<input type="submit" name="Updsubmit" value="Search"></td>
				</tr>
				<tr>
				<%
					Dim radioValue1 : radioValue1 = Request.form("SearchType")

					' Modified by Avy - CR# 10097 start
					if radioValue1 = "" then
						radiocheck2 = "checked"
					end if		
					' Modified by Avy - CR# 10097 end

					if radioValue1 = "NR" then
						radiocheck1 = "checked"
					end if	

					if radioValue1 = "Na" then
						radiocheck2 = "checked"
					end if	
	
					if radioValue1 = "L" then
						radiocheck3 = "checked"
					end if
		
				%>
					<!-- Commented by Avy - CR# 10097 start
					<td align="center" width="20%"><input type="radio" name="SearchType" value="NR" id="SearchType" <%=radiocheck1%>> by NRIC/FIN/<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Passport No.</td>
					     Commented by Avy - CR# 10097 end  -->				
					<td align="center" width="20%"><input type="radio" name="SearchType" value="Na" id="SearchType" <%=radiocheck2%>> by Name<br>&nbsp;</td>
					<td align="left" width="80%"><input type="radio" name="SearchType" value="L" id="SearchType" <%=radiocheck3%>> by Login Account ID <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="1">(Domain accounts "SMUSTF\" and "SMUSTU\" are not required)</font></td>
				</tr>							
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		</table>		
		
		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>	
				
<%if Request.Form("Updsubmit")<>"" THEN

	Dim radioValue : radioValue = Request.form("SearchType")
	
	OrderByStr = " order by Username "
	
	'06 May: Start === DOS can only view student records		
	If UCASE(NTlogin) = DOSUsr1 or UCASE(NTlogin) = DOSUsr2 then
		UsrFilterStr = " and NTLOGINACCOUNT like 'SMUSTU\%' "
	else
		UsrFilterStr = ""
	end if	

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
	if radioValue = "NR" then
		strSQL = "Select * FROM " & DBOWNER & "V_Trace_UserAccount where (CHARINDEX(?,NRIC_FIN_PP)>0) and isActive ='Y'" & UsrFilterStr & OrderByStr
	end if	

	if radioValue = "Na" then
		strSQL = "select * from " & DBOWNER & "V_Trace_UserAccount where (CHARINDEX(?,username)>0) and isActive ='Y'" & UsrFilterStr & OrderByStr
	end if	
	
	if radioValue = "L" then
		strSQL = "select * from " & DBOWNER & "V_Trace_UserAccount where (CHARINDEX(?,ntloginaccount)>0) AND ntloginaccount like 'SMUST%' and isActive ='Y' " & UsrFilterStr & OrderByStr
	end if	
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("searchstring", adVarChar,adParamInput,1000,ValidateAndEncodeSQL(trim(Request.Form("searchstring"))))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set TravelSearch = CurrCmd.EXECUTE()

	if TravelSearch.EOF then
%>
		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">	
		<tr>
			<td>Sorry there are no results for your search. Please verify your search criteria and try again.</td>
		</tr>
		</table>		
<%
	else
%>
					<table  width="100%"  border=1 align="center" cellpadding="4" cellspacing="0">
					<tr>
						<td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">S/N</b></font></td>
						<td width="30%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Name</b></font></td>
						<!-- NRIC/FIN/Passport No. column removed by Avy - CR# 10097 -->
						<td width="15%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Login Account ID</b></font></td>
						<td width="45%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</b></font></td>
					</tr>		
			<%
					color_count = 0
					r_count = 0
				
					while not TravelSearch.EOF			
						r_count = r_count + 1
            
						if color_count = 0 then
							myclass = "class=TemperatureHistoryDetail"
							color_count = 1
						else
							myclass = ""
							color_count = 0
						end if		
			%>
					<tr>
   						<td width="10%" valign="top" <%=myclass%> nowrap><%=r_count%></td>
   						<!-- Start Security Hardening Exercise 12 Jan 2012 -->
   						<!-- Removed apostrophe enclosing id in querystring. Otherwise will break application. -->
						<td width="30%" valign="top" <%=myclass%> nowrap>
						<!--<a href="log_travel_admin.asp?id=<%=ValidateXSSHTML(TravelSearch("NTLOGINACCOUNT"))%>"><%=ValidateXSSHTML(TravelSearch("Username"))%></a>-->
						<a href="log_travel_admin_preface.asp?id=<%=ValidateXSSHTML(TravelSearch("NTLOGINACCOUNT"))%>"><%=ValidateXSSHTML(TravelSearch("Username"))%></a>
						</td>
						<!-- NRIC/FIN/Passport No. column removed by Avy - CR# 10097 -->
						<td width="15%" valign="top" <%=myclass%> nowrap><%=ValidateXSSHTML(TravelSearch("NTLOGINACCOUNT"))%></td>
						<td width="45%" valign="top" <%=myclass%> nowrap><%=ValidateXSSHTML(TravelSearch("Organisationdesc"))%></td>
					</tr>
			<%
					TravelSearch.MoveNext
					wend
			%>
					</table>
<%
	end if			
%>
<%
end if			
%>	
		
	</td>
</tr>
</table>
<!-- #INCLUDE FILE="../footer.asp" -->
<%OBJCONN.CLOSE%>