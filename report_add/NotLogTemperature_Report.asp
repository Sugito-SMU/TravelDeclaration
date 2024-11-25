<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="NotLogTemperature_ReportHeader.asp" -->
<!-- #INCLUDE FILE="../CommonFunction.asp" -->
<!-- #INCLUDE FILE="../commonJavascript.js" -->

<script language="Javascript">
	function chk()
	{
		if (document.form1.RegFrom.value=="")
		{
			alert("Please enter a Logging From Date");
			document.form1.RegFrom.focus();
			return false
		}else
		{
			dt=document.form1.RegFrom.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter a valid Logging From Date");
				document.form1.RegFrom.focus();
				return false;
			}
		}
		
		if (document.form1.RegTo.value=="")
		{
			alert("Please enter a Logging To Date");
			document.form1.RegTo.focus();
			return false
		}else
		{
			dt=document.form1.RegTo.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter a valid Logging To Date");
				document.form1.RegTo.focus();
				return false;
			}
		}
		
		resultCompare=compareDates(document.form1.RegFrom.value,"dd/MM/yyyy",document.form1.RegTo.value,"dd/MM/yyyy")
		//1 if date1 is greater than date2
		//   0 if date2 is greater than date1 of if they are the same
		//  -1 if either of the dates is in an invalid format
		if (resultCompare==1)
		{
			alert("Logging Date From must be ealier than Logging Date To");
			return false;
		}
		
		return true;
	}
</script>


<br>
<%

'determine whether to output to excel sheet
	IF REQUEST.QUERYSTRING("DOWNLOAD")<>"" THEN		
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-Disposition", "attachment;filename=NotLogTemperature_Report.xls" 
		Response.Charset = ""
		excelSheet=true
	END IF
	intLocale = SetLocale(8201)

%>

<form name="form1" method=post action="NotLogTemperature_Report.asp">
<%
	if Request.Form("Submit")="" and Request.QueryString("RegFrom")="" and Request.QueryString("RegTo")="" and Request.QueryString("Typed")="" then		
		RegFrom=FormatDateTime(date(),vbgeneraldate)'"01/05/2009"
		RegTo=FormatDateTime(date(),vbgeneraldate)
		Typed="STAFF"		
	else		
		RegFrom=Request("RegFrom")
		RegTo=Request("RegTo")
		Typed=Request("Typed")		
	end if	
	
%>

<%

RegToArr=split(RegTo,"/")
RegFrmArr=split(RegFrom,"/")
RegT=RegToArr(1) & "/" & RegToArr(0) & "/" & RegToArr(2)
RegF=RegFrmArr(1) & "/" & RegFrmArr(0) & "/" & RegFrmArr(2)

if(not excelSheet) then
%>

<tr align="center">
<table align="center">
<tr align="center">
	<td colspan="5" class="SectionHeader"><%=CONSTANT_TITLE%></font></td>
</tr>
<tr align="center">
	<td colspan="5" class="SectionHeader"><font size="2px">as at <%=FormatDateTime(Now(), 0)%></font></td>
</tr>
</table>
<br>

<table border="0">
	<tr>
		<td>Temperature Logging Date&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>- From:</td>
		<td>
			<input type="text" name="RegFrom" value=<%=ValidateAndEncodeXSSEx(RegFrom)%> maxlength="10" <%=strActive%>> (DD/MM/YYYY)	
		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>- To:</td>
		<td>
			<input type="text" name="RegTo" value=<%=ValidateAndEncodeXSSEx(RegTo)%> maxlength="10" <%=strActive%>> (DD/MM/YYYY)
		</td>
	</tr>
	<tr>					
		<td>Type:</td>
		<td>&nbsp;</td>
		<td>
			<select name="Typed">
			
				<option Value="STAFF" <%if UCase(Typed)="STAFF" then %> selected <%end if%>>STAFF</option>
				<option Value="STUDENT" <%if UCase(Typed)="STUDENT" then %> selected <%end if%>>STUDENT</option>
							
			</select>	
		</td>
	</tr>
	<tr>
		<td colspan="2"></td>
		<td><input type="Submit" name="Submit" value="Search" onclick="return chk();"></td>
	</tr>
</table><br>
<%end if%>
</form>
	


<%
if Request("Submit")<>"" then
	

		
		
		
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
CurrCmd.CommandTimeout=4000
SET CurrCmd.ACTIVECONNECTION = OBJCONN

strSQL = "select username, usertype, organisationdesc, contact_office, contact_mobile, email_smu from " & DBOWNER & "V_Trace_Useraccount where useraccountid not in "&_
		" (select distinct useraccountid from " & DBOWNER & "v_trace_temperature where DateDiff(second,logDate, Convert(Datetime,?,101)) >=0 and DateDiff(second,logDate, Convert(Datetime,?,101)) <=0) "&_
		" and isactive = 'Y' and  usertype = ? "&_
		" order by username asc " 

CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarchar,adParamInput,50,ValidateAndEncodeSQL(RegT & " 23:59:59"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarchar,adParamInput,50,ValidateAndEncodeSQL(RegF & " 00:00:00"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed", adVarchar,adParamInput,50,ValidateAndEncodeSQL(Typed))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()
		

		
		' Get recordcount		
		if not objRds.eof then          
			rsArray = objRds.GetRows()          
			RowCnt = UBound(rsArray, 2) + 1     			
		end if
		
		if(excelSheet) then 					
			Response.Write("<b>" & CONSTANT_TITLE & " as at " & FormatDateTime(Now(), 0) & "</b><br>")		
			Response.Write("From : " & ValidateAndEncodeXSSEx(RegFrom) & "<br>")			
			Response.Write("To&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: " & ValidateAndEncodeXSSEx(RegTo) & "<br><br>")
			intLocale = SetLocale(8201)
		end if	

%>
	<table border="0" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="100%">
	<tr>
	<td colspan="10">
		<table>
		<tr>
			<td>
				<br><br>
				<b>No. of Records: <%=RowCnt%> </b>
				<%
				if (not excelSheet and RowCnt > 0) then 
				%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href= "NotLogTemperature_report.asp?download=1&RegFrom=<%=ValidateAndEncodeXSSEx(RegFrom)%>&RegTo=<%=ValidateAndEncodeXSSEx(RegTo)%>&Typed=<%=ValidateAndEncodeXSSEx(Typed)%>&Submit=1" target="_blank">Download Report</a><br><br>
				<%
				end if
				%>
			</td>
		</tr>
	</table>
	<br>

<% 
end if

if(excelSheet) then	
%>


<table border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="100%">

<tr valign="top" align="left">
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">No.</font></b></td>
	<td width="47%" class="TemperatureHistoryTitle"><b><font color="#000000">Name</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Student/<br>Staff</font></b></td>	
	<td width="30%" class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Contact No.</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Email Address</font></b></td>	
</tr>
<%

count=0

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
CurrCmd.CommandTimeout=4000
SET CurrCmd.ACTIVECONNECTION = OBJCONN

strSQL = "select username, usertype, organisationdesc, contact_office, contact_mobile, email_smu from " & DBOWNER & "V_Trace_Useraccount where useraccountid not in "&_
		" (select distinct useraccountid from " & DBOWNER & "v_trace_temperature where DateDiff(second,logDate, Convert(Datetime,?,101)) >=0 and DateDiff(second,logDate, Convert(Datetime,?,101)) <=0) "&_
		" and isactive = 'Y' and  usertype = ? "&_
		" order by username asc " 

CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarchar,adParamInput,50,ValidateAndEncodeSQL(RegT & " 23:59:59"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarchar,adParamInput,50,ValidateAndEncodeSQL(RegF & " 00:00:00"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed", adVarchar,adParamInput,50,ValidateAndEncodeSQL(Typed))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()
		
		
	WHILE (not objRds.eof) 
%>
	<!-- #INCLUDE FILE="NotLogTemperature_Sub_Declaration_Report.asp" -->
<%	
	objRds.movenext
  wend
end if

objRds.Close
Set objRds=Nothing
objConn.Close
Set objConn=Nothing

%>
</table>

<%

Function InsertStringAtInterval(rsSource, rsInsert, rlInterval)
	Dim rgx
	Set rgx = new RegExp
	rgx.Pattern = "([\s\S]{" & rlInterval & "})"
	rgx.Global = true
	InsertStringAtInterval = rgx.Replace(rsSource, "$1" & rsInsert)
End Function

%>