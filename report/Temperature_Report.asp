<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="Temperature_ReportHeader.asp" -->
<!-- #INCLUDE FILE="../CommonFunction.asp" -->
<!-- #INCLUDE FILE="../commonJavascript.js" -->
<script language="Javascript">
	function chk()
	{
		if (document.form1.RegFrom.value=="")
		{
			alert("Please enter a Creation From Date");
			document.form1.RegFrom.focus();
			return false
		}else
		{
			dt=document.form1.RegFrom.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter valid Creation From Date");
				document.form1.RegFrom.focus();
				return false;
			}
		}
		/*
		if(document.form1.RegFromTime.value=="")
		{
			alert("Please enter a Creation From Time");
			document.form1.RegFromTime.focus();
			return false
		}
		}else
		{
			var hhmm=document.form1.RegFromTime.value.split(":");
			if( hhmm.length < 2 )
			{
				alert("Please enter time in HH:mm format (24 hour clock)");
				document.form1.RegFromTime.focus();
				return false;
			}
			else if( hhmm[0].length != 2 || hhmm[1].length != 2  )
			{
				alert("Please enter time in HH:mm format (24 hour clock)");
				document.form1.RegFromTime.focus();
				return false;
			}
		}
		*/
		if (document.form1.RegTo.value=="")
		{
			alert("Please enter a Creation To Date");
			document.form1.RegTo.focus();
			return false
		}else
		{
			dt=document.form1.RegTo.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter valid Creation To Date");
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
			alert("Creation Date From must be ealier than Creation Date To");
			return false;
		}
		
		return true;
	}
	
	//returns true if testString is numeric else returns false
	function isNumeric(teststring)
	{
		var numPattern=new RegExp("[^0-9]");
		return (!numPattern.test(teststring));
	}
</script>


<br>
<%
'DB_OWNER="[smustf\kbtheng]."
'DB_OWNER="sharonwan."

'determine whether to output to excel sheet
	IF REQUEST.QUERYSTRING("DOWNLOAD")<>"" THEN
		'Response.ContentType="application/x-msexcel"
		Response.ContentType = "application/vnd.ms-excel"
		Response.Charset = ""
		Response.AddHeader "Content-Disposition", "attachment;filename=temperature_report.xls" 
		excelSheet=true
	END IF
	intLocale = SetLocale(8201)

%>

<form name="form1" method=post action="Temperature_Report.asp">
<%
	if Request.Form("Submit")="" and Request.QueryString("RegFrom")="" and Request.QueryString("RegTo")="" and Request.QueryString("Typed")="" and Request.QueryString("PT")="" then
		'Response.Write("<br>up")
		RegFrom=FormatDateTime(date(),vbgeneraldate)'"01/05/2009"
		RegTo=FormatDateTime(date(),vbgeneraldate)
		Typed="STAFF"
		PT="OFFICIAL"
		TimeF="12"
		TimeTo="12"
		'Temp="ALL"
		TempThreshold = CONSTANT_HIGHEST_TEMP
		RegFromTime = "00" '"00:00"
		RegToTime = "23" '"23:59"
		RType =  "ALL"
	else
		'Response.Write("<br>down")
		RegFrom=Request("RegFrom")
		RegTo=Request("RegTo")
		Typed=Request("Typed")
		PT=Request("PT")
		TimeF=Request("TimeFrm")
		TimeT=Request("TimeTo")
		'Temp=Request("Temp")
		
		TempThreshold=Request("TempThreshold")
		RegFromTime=Request("RegFromTime")
		RegToTime=Request("RegToTime")
		
		RType = Request("RType")
		
	end if
	
	'Response.Write("<br>RegFromTime=" & RegFromTime)
	'Response.Write("<br>RegToTime=" & RegToTime & "<br/>")
%>

<%

'response.write request.querystring("RegFrom") & "," & request.querystring("RegTo")

If request.querystring("RegFrom") <> "" then
	RegFrmArr=split(Request.Querystring("RegFrom"),"/")
	RegFromTime = request.querystring("RegFromTime")
	TempThreshold = Request.QueryString("Temp")
	RType= Request.QueryString("RType")
else
	RegFrmArr=split(RegFrom,"/")
end if

RegF=RegFrmArr(0) & "-" & getMonthShortName(RegFrmArr(1)) & "-" & RegFrmArr(2) & " " & RegFromTime & ":00:00"  'RegFrmArr(1) & "/" & RegFrmArr(0) & "/" & RegFrmArr(2)
'response.write RegF & "<br/>"	

If request.querystring("RegTo") <> "" then
	RegToArr=split(Request.Querystring("RegTo"),"/")
	RegToTime = request.querystring("RegToTime")
	TempThreshold = Request.QueryString("Temp")
else
	RegToArr=split(RegTo,"/")
end if
RegT=RegToArr(0) & "-" & getMonthShortName(RegToArr(1)) & "-" & RegToArr(2) & " " & RegToTime & ":00:00"  'RegToArr(1) & "/" & RegToArr(0) & "/" & RegToArr(2)
'response.write RegT & "<br/>"


'RegToArr=split(RegTo,"/")
'RegFrmArr=split(RegFrom,"/")
'RegT=RegToArr(0) & "-" & getMonthShortName(RegToArr(1)) & "-" & RegToArr(2) & " " & RegToTime & ":00"  'RegToArr(1) & "/" & RegToArr(0) & "/" & RegToArr(2)
'RegF=RegFrmArr(0) & "-" & getMonthShortName(RegFrmArr(1)) & "-" & RegFrmArr(2) & " " & RegFromTime & ":00"  'RegFrmArr(1) & "/" & RegFrmArr(0) & "/" & RegFrmArr(2)

'response.end
 
if(not excelSheet) then 'excel
%>

<table align="center">
<tr align="center">
	<td colspan="5" class="SectionHeader"><%=CONSTANT_TITLE%></font></td>
</tr>
<tr align="center">
	<td colspan="5" class="SectionHeader"><font size="2px">as at <%=FormatDateTime(Now(), 0)%></font></td>
</tr>
</table>
<br>
<table border="0" width="800px" cellpadding="2" cellspacing="2">
	<tr>
		<td style="vertical-align:top;width:200px">Temperature logging date &nbsp;</td>
		<td colspan="2" style="vertical-align:top;">
			From:&nbsp;<input type="text" name="RegFrom" value=<%=ValidateAndEncodeXSSEx(RegFrom)%> maxlength="10" style="width:100px">
			<select name="RegFromTime">
				<%
				for i=0 to 23
					if Len(i)=1 then
							sNum="0" & i
					else
							sNum=i
					end if
						
					if Trim(sNum)=Trim(RegFromTime) then
				%>
					<option <%=sNum%> selected><%=sNum%></option>
				<%
					else		
				%>
						<option <%=sNum%>><%=sNum%></option>
				<%		
					end if
				next
				%>
			</select>
			
			<!--<input type="text" name="RegFromTime" maxlength="5" style="width:50px" value="<%= ValidateAndEncodeXSSEx(RegFromTime) %>">-->
			&nbsp;(DD/MM/YYYY, HH:mm)

			<br/>To:&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="text" name="RegTo" value=<%=ValidateAndEncodeXSSEx(RegTo)%> maxlength="10" style="width:100px"> 
			<select name="RegToTime">
				<%
				for i=0 to 23
					if Len(i)=1 then
							sNum="0" & i
					else
							sNum=i
					end if
						
					if Trim(sNum)=Trim(RegToTime) then
				%>
					<option <%=sNum%> selected><%=sNum%></option>
				<%
					else		
				%>
						<option <%=sNum%>><%=sNum%></option>
				<%		
					end if
				next
				%>
			</select>
			<!--<input type="text" name="RegToTime" maxlength="5" style="width:50px" value="<%= ValidateAndEncodeXSSEx(RegToTime) %>">-->
			&nbsp;(DD/MM/YYYY, HH:mm)
		
		</td>
	</tr>
	
	<tr>
		<td style="vertical-align:top;">Temperature above or equal to:
			<!--
			<select name="Temp">
				<% if UCase(Temp)= CONSTANT_HIGHEST_TEMP then %>
					<option Value="ALL">ALL</option>
					<option Value=">=<%=CONSTANT_HIGHEST_TEMP%>" selected>>=<%=CONSTANT_HIGHEST_TEMP%></option>
				<% elseif UCase(Temp)="ALL" then %>
					<option Value="ALL" selected>ALL</option>
					<option Value="<%=CONSTANT_HIGHEST_TEMP%>">>=<%=CONSTANT_HIGHEST_TEMP%></option>
				 <%end if%>	
			</select>	
			-->
		</td>
		<td colspan="2">
		
		<input type="text" name="TempThreshold" value="<%=ValidateAndEncodeXSSEx(TempThreshold)%>" maxlength="5" style="width:60px">&deg;C (Degree Celsius) &nbsp;
			<!--     <sub>(Leave blank to retrieve all)</sub>-->
		</td>
	</tr>
	<tr>
		<td style="vertical-align:top;">Respondent Type:</td>
		<td colspan="2">
			<%
				
				RType_All = ""
				RType_Staff = ""
				RType_Student = ""
				IF RType="ALL" Then 
					RType_All = "SELECTED" 
				ELSEIF RType="STAFF" Then 
					RType_Staff = "SELECTED"
				ELSE
					RType_Student = "SELECTED"
				END IF
				
			%>
			<select name="RType">
				<option value="ALL" <%=RType_All%> >All</option>
				<option value="STAFF" <%=RType_Staff %> >Staff only</option>
				<option value="STUDENT" <%=RType_Student %> >Student only</option>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td></td>
		<td colspan="2"><input type="Reset"/>&nbsp;<input type="Submit" name="Submit" value="Search" onclick="return chk();"></td>
	</tr>
</table><br>
<%end if%>
<hr/>
</form>
	
<%	
'''''''''''''''''''''''''''''''''''''''''

	'mofified by felicia-11oct2013-start
	'sqlStrRegStat ="select count(useraccountid) from " & DBOWNER & "V_Trace_Temperature_Report "
	'sqlStrRegStat= sqlStrRegStat & " where DateDiff(second,logDate, Convert(Datetime,'" & RegT & " 23:59:00',101)) >=0 "
	'sqlStrRegStat= sqlStrRegStat & " and   DateDiff(second,logDate, Convert(Datetime,'" & RegF & " 00:00:00',101)) <=0 "
	'if ucase(temp)<>"ALL" and ucase(temp)<>"" then
	'	sqlStrRegStat= sqlStrRegStat & " and  temperature >= " & temp  & " "
	'end if
	

	
	RowCnt = 0 
	

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL ="select  count(useraccountid) from " & DBOWNER & "V_Trace_Temperature_Report (nolock) where logDate <= ?  and  logDate >= ? "&_
		" and (?='' or temperature>=?) and (?='ALL' or usertype=?)"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegT))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegF))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TempThreshold", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TempThreshold))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TempThreshold2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TempThreshold))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RType", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RType))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RType2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RType))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
CurrCmd.CommandTimeout = 600
set rs = CurrCmd.EXECUTE()	


	if not rs.eof then 
		RowCnt = clng(rs(0))
				
	end if 
	
	if RowCnt=0 then
		Response.Write("No Record Found.")
		Response.End
	else
		'Response.Write("Record Found=" & RowCnt)
	end if
%>
<table border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="100%">
<tr>
<td colspan="10">
	<table>
	<tr>
		<td>
			<b>No. of Records: <%=RowCnt%></b>
		</td>
	</tr>
</table>
<br>
<%
    PerPage = Trim(Request.QueryString("PerPage")) 
    PageNum = Trim(Request.QueryString("PageNum")) 
 
    If PerPage = "" or (len(PerPage)>0 and not isnumeric(PerPage)) Then _ 
        PerPage = CONSTANT_PERPAGE
 
    If PageNum = "" or (len(PageNum)>0 and not isnumeric(PageNum)) Then _ 
        PageNum = 1 
 
    PerPage = clng(PerPage) 
    PageNum = clng(PageNum) 
 
    PageCnt = RowCnt \ PerPage 
 
    if RowCnt mod PerPage <> 0 then PageCnt = PageCnt + 1 
    if PageNum < 1 Then PageNum = 1 
    if PageNum > PageCnt Then PageNum = PageCnt 
 
    url = Request.ServerVariables("SCRIPT_NAME") 
    urlParts = split(url, "/") 
    pageName = urlParts(ubound(urlParts)) 
%> 
	<script> 
	function go(p) 
	{ 
		if (p!='current') 
			window.location.href = "<%=ValidateAndEncodeXSSEx(pageName)%>?" 
			+"PerPage=<%=ValidateAndEncodeXSSEx(PerPage)%>&" 
			+"PageNum="+p
			+"&RegFrom=<%=ValidateAndEncodeXSSEx(RegFrom)%>"
			+"&RegFromTime=<%=ValidateAndEncodeXSSEx(RegFromTime)%>"
			+"&RegTo=<%=ValidateAndEncodeXSSEx(RegTo)%>"
			+"&RegToTime=<%=ValidateAndEncodeXSSEx(RegToTime)%>"
			+"&Temp=<%=ValidateAndEncodeXSSEx(TempThreshold)%>"
			+"&RType=<%=ValidateAndEncodeXSSEx(RType)%>";
			//+"&Temp=<%=Temp%>";

	} 
	</script> 
<% 
	'Response.Write "<table><tr><td>"
    'response.write RowCnt & " rows found.<br> Showing " & _ 
    '    " page " & PageNum & " of " & PageCnt & "." 
 
'	if(not excelSheet) then 
'		response.write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select onchange='go(this.value);'>" 
'		for i = 1 to PageCnt  
'			link = i: s = "" 
'			if i = PageNum then link = "current": s=" SELECTED" 
'				response.write "<option value=" & link & s & ">" 
'				response.write "Page " & i 
'		next 
'		Response.Write "</select>" 
'	else
'		intLocale = SetLocale(8201)
'		Response.Write(CONSTANT_TITLE & " as at " & FormatDateTime(Now(), 0))
'	end if	
	'Response.Write "</td></tr></table>"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>

<% 
if(not excelSheet) then 'excelSheet button 
%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href= "temperature_report.asp?download=1&RegFrom=<%=ValidateAndEncodeXSSEx(RegFrom)%>&RegFromTime=<%=ValidateAndEncodeXSSEx(RegFromTime)%>&RegTo=<%=ValidateAndEncodeXSSEx(RegTo)%>&RegToTime=<%=ValidateAndEncodeXSSEx(RegToTime)%>&Temp=<%=ValidateAndEncodeXSSEx(TempThreshold)%>&RType=<%=ValidateAndEncodeXSSEx(RType)%>" target="_blank">Download Report</a><br><br>
<%	
end if
%>

<!--table border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" width="100%" style="color:black"-->
<table border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="100%">
<!--tr valign="top">
	<td colspan="30" class=SectionHeader align="center"><%=CONSTANT_TITLE%></td>
</tr-->

<%

'sqlStr = "select * from " & DBOWNER & "V_Trace_Temperature_Report "
'sqlStr= sqlStr & " where DateDiff(second,logDate, Convert(Datetime,'" & RegT & " 23:59:59',101)) >=0 "
'sqlStr= sqlStr & " and   DateDiff(second,logDate, Convert(Datetime,'" & RegF & " 00:00:00',101)) <=0 "
'if ucase(temp)<>"ALL" then
'		sqlStr= sqlStr & " and   temperature >= " & temp  & " "
'end if
'sqlStr= sqlStr & " order by logDate desc, username asc " 


if(excelSheet) then 

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
CurrCmd.CommandTimeout=4000
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL ="select  * from " & DBOWNER & "V_Trace_Temperature_Report (nolock) where logDate <= ?  and  logDate >= ? "&_
		" and (?='' or temperature>=?) and (?='ALL' or usertype=?) order by logDate desc, username asc "
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegT))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegF))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TempThreshold", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TempThreshold))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TempThreshold2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TempThreshold))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RType", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RType))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RType2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RType))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
CurrCmd.CommandTimeout = 600
set objRds = CurrCmd.EXECUTE()	
%>

<tr valign="top" align="left">
	<td width="2%" class="TemperatureHistoryTitle"><b><font color="#000000">No.</font></b></td>
	<td width="15%" class="TemperatureHistoryTitle"><b><font color="#000000">Name</font></b></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Student/<br>Staff</font></b></td>
	<td width="18%" class="TemperatureHistoryTitle"><b><font color="#000000">NRIC/FIN/Passport No.</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Contact No.</font></b></td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Temperature Taken</font></b></td>
	<td width="20%" class="TemperatureHistoryTitle">
		<b><font color="#000000">Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp</font></b>
		<br>
	</td>
	<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Temperature Logging Date & Time</font></td>
</tr>
<%
count=0
	WHILE (not objRds.eof) 
%>
	<!-- #INCLUDE FILE="Temperature_Sub_Declaration_Report.asp" -->
<%	
	objRds.movenext
  wend
  	end if 'if excellsheet
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