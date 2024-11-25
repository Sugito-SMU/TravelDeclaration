<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="ReportHeader.asp" -->
<!-- #INCLUDE FILE="../CommonFunction.asp" -->
<!-- #INCLUDE FILE="../commonJavascript.js" -->
<script language="Javascript">
	function chk()
	{
		if (document.form1.RegFrom.value=="")
		{
			alert("Please enter a Declaration/Form From Date");
			document.form1.RegFrom.focus();
			return false
		}else
		{
			dt=document.form1.RegFrom.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter valid Declaration/Form From Date");
				document.form1.RegFrom.focus();
				return false;
			}
		}
		
		if (document.form1.RegTo.value=="")
		{
			alert("Please enter a Declaration/Form To Date");
			document.form1.RegTo.focus();
			return false
		}else
		{
			dt=document.form1.RegTo.value
			if (isDate(dt,"dd/MM/yyyy")==false)
			{
				alert("Please enter valid Declaration/Form To Date");
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
			alert("Declaration/Form From Date must be earlier than Declaration/Form To Date");
			return false;
		}
		
		return true;
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
		Response.AddHeader "Content-Disposition", "attachment;filename=declaration_report.xls" 
		Response.Charset = ""
		excelSheet=true
	END IF

intLocale = SetLocale(8201)

%>
<form name="form1" method=post action="declaration_report.asp">
<%
	if Request.Form("Submit")="" and Request.QueryString("RegFrom")="" and Request.QueryString("RegTo")="" and Request.QueryString("TimeFrm")="" and Request.QueryString("TimeTo")="" then
		'Response.Write("<br>up")
		' Modified by Avy CR# 9931 -- start
		RegFrom=FormatDateTime(date(),vbgeneraldate)'"11/01/2011"'FormatDateTime(CDate(1/5/2009),vbgeneraldate)
		' Modified by Avy CR# 9931 -- end
		RegTo=FormatDateTime(date(),vbgeneraldate)
		TimeF="00"
		TimeT="23"
		Typed="STAFF"
		PT="ALL"'"OFFICIAL"
	else
		'Response.Write("<br>down")
		RegFrom=Request("RegFrom")
		RegTo=Request("RegTo")
		TimeF=Request("TimeFrm")
		TimeT=Request("TimeTo")
		Typed=Request("Typed")
		PT=Request("PT")
	end if
%>


<%

	RegToArr=split(RegTo,"/")
	RegFrmArr=split(RegFrom,"/")
	RegT=RegToArr(1) & "/" & RegToArr(0) & "/" & RegToArr(2)
	RegF=RegFrmArr(1) & "/" & RegFrmArr(0) & "/" & RegFrmArr(2)
	
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
<table>
	<tr valign="top">
		<td>Declaration/Creation Date&nbsp;&nbsp;&nbsp;</td>
		<td>- From:</td>
		<td>
			<input type="text" name="RegFrom" value=<%=ValidateXSSHTML(RegFrom)%> maxlength="10">(DD/MM/YYYY)
		</td>
		<td>&nbsp;&nbsp;&nbsp;Time: <SELECT NAME="TimeFrm">	
			<%
				for i=0 to 23
					if Len(i)=1 then
							sNum="0" & i
					else
							sNum=i
					end if
						
					if Trim(sNum)=Trim(TimeF) then
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
			</SELECT>&nbsp;hrs		
		</td>
	</tr>
	<tr>
		<td align="right"></td>
		<td>- To:</td>
		<td>
			<input type="text" name="RegTo" value=<%=ValidateXSSHTML(RegTo)%> maxlength="10">(DD/MM/YYYY)
		</td>
		<td>&nbsp;&nbsp;&nbsp;Time: <SELECT NAME="TimeTo">
			<%
				for i=0 to 23 
						if Len(i)=1 then
							sNum="0" & i
						else
							sNum=i
						end if
						
					if Trim(sNum)=Trim(TimeT) then
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
			</SELECT>&nbsp;hrs	
		</td>
	</tr>
	<tr>
		<td colspan="2">Type:</td>
		<td>
			<select name="Typed">
				<% if UCase(Typed)="STAFF" then %>
					<option Value="ALL">ALL</option>
					<option Value="STAFF" selected>STAFF</option>
					<option Value="STUDENT">STUDENT</option>
				 <% elseif UCase(Typed)="STUDENT" then %>
					<option Value="ALL">ALL</option>
					<option Value="STAFF">STAFF</option>
					<option Value="STUDENT" selected>STUDENT</option>
				<% elseif UCase(Typed)="ALL" then %>
					<option Value="ALL">ALL</option>
					<option Value="STAFF">STAFF</option>
					<option Value="STUDENT">STUDENT</option>
				 <%end if%>	
			</select>	
		</td>
	</tr>
	<tr>
		<td colspan="2">Reason for Travel:</td>
		<td>
			<select name="PT">
				<% if UCase(PT)="PERSONAL" then %>
					<option Value="ALL">ALL</option>
					<option Value="PERSONAL" selected>PERSONAL</option>
					<option Value="OFFICIAL">OFFICIAL</option>
				 <% elseif UCase(PT)="OFFICIAL" then %>
					<option Value="ALL">ALL</option>
					<option Value="PERSONAL">PERSONAL</option>
					<option Value="OFFICIAL" selected>OFFICIAL</option>
				<% elseif UCase(PT)="ALL" then %>
					<option Value="ALL" selected>ALL</option>
					<option Value="PERSONAL">PERSONAL</option>
					<option Value="OFFICIAL">OFFICIAL</option>		
				 <%end if%>	
			</select>	
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td><input type="Submit" name="Submit" value="Search" onclick="return chk()"></td>
		<td></td>
	</tr>
</table><br>
<%end if%>
</form>

<%

	
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
CurrCmd.CommandTimeout=8000
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL ="select count(*) from " & DBOWNER & "v_trace_travel_report (nolock) where declareDte <= ?  and  declareDte >= ? "&_
		" and (?='ALL' or usertype=?) and (?='ALL' or PurposeType=?) "
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegT  & " " & TimeT & ":59:59"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegF  & " " & TimeF & ":00:00"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed", adVarChar,adParamInput,100,ValidateAndEncodeSQL(Typed))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(Typed))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(PT))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PT2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(PT))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
CurrCmd.CommandTimeout=600
set rs = CurrCmd.EXECUTE()	
	RowCnt = 0 
	
	
	if not rs.eof then 
		RowCnt = clng(rs(0)) 
	end if 

	if RowCnt=0 then
		Response.Write("No Record Found.")
		Response.End 
	else
		'Response.Write("Record Found=" & RowCnt)
	end if
	'response.write "<br/>sqlStrRegStat:" & sqlStrRegStat & "<br/>"
%>
<table style="table-layout:fixed" border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="8500">
<tr>
<td colspan="54">
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
			window.location.href = "<%=ValidateXSSHTML(pageName)%>?" 
			+"PerPage=<%=ValidateXSSHTML(PerPage)%>&" 
			+"PageNum="+p
			+"&Typed=<%=ValidateXSSHTML(Typed)%>"
			+"&PT=<%=ValidateXSSHTML(PT)%>"
			+"&RegFrom=<%=ValidateXSSHTML(RegFrom)%>" 
			+"&RegTo=<%=ValidateXSSHTML(RegTo)%>"
			+"&TimeFrm=<%=ValidateXSSHTML(TimeF)%>"    
			+"&TimeTo=<%=ValidateXSSHTML(TimeT)%>";
	}
	</script>
<%

 '  if(not excelSheet) then
'		response.write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select onchange='go(this.value);'>"

'		for i = 1 to PageCnt
'			link = i: s = ""
'			if i = PageNum then link = "current": s=" SELECTED"
'				response.write "<option value=" & link & s & ">"
'				response.write "Page " & i
'		next
'		Response.Write "</select>"
'	 else
'		intLocale = SetLocale(8201)
'		Response.Write(CONSTANT_TITLE & " as at " & FormatDateTime(Now(), 0))
'	 end if
	'Response.Write "</td></tr></table>"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>

<%
if(not excelSheet) then 'excelSheet button
%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href= "declaration_report.asp?download=1&RegFrom=<%=ValidateXSSHTML(RegFrom)%>&RegTo=<%=ValidateXSSHTML(RegTo)%>&TimeFrm=<%=ValidateXSSHTML(TimeF)%>&TimeTo=<%=ValidateXSSHTML(TimeT)%>&Typed=<%=ValidateXSSHTML(Typed)%>&PT=<%=ValidateXSSHTML(PT)%>" target="_blank">Download Report</a><br><br> 	
<%
end if
%>
</td>
</tr>
</table>
<table style="table-layout:fixed" border="1" bordercolor="black" align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="8500">


<%

if(excelSheet) then
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
CurrCmd.CommandTimeout=8000
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL ="select * from " & DBOWNER & "v_trace_travel_report (nolock) where declareDte <= ?  and  declareDte >= ? "&_
		" and (?='ALL' or usertype=?) and (?='ALL' or PurposeType=?) order by declaredte desc, username asc "
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegT  & " " & TimeT & ":59:59"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("RegF", adVarChar,adParamInput,100,ValidateAndEncodeSQL(RegF  & " " & TimeF & ":00:00"))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed", adVarChar,adParamInput,100,ValidateAndEncodeSQL(Typed))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Typed2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(Typed))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PT", adVarChar,adParamInput,100,ValidateAndEncodeSQL(PT))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PT2", adVarChar,adParamInput,100,ValidateAndEncodeSQL(PT))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()	
%>

<tr valign="top" align="left">
	<td width="2" class="TemperatureHistoryTitle"><b><font color="#000000">No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Name</font></b></td>
	<td width="7" class="TemperatureHistoryTitle"><b><font color="#000000">Student/Staff</font></b></td>
	<td width="12" class="TemperatureHistoryTitle"><b><font color="#000000">NRIC/FIN/Passport&nbsp;No.</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</font></b></td>
	<td width="7" class="TemperatureHistoryTitle"><b><font color="#000000">Contact&nbsp;No.</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Personal&nbsp;Email&nbsp;Account</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Home&nbsp;Address</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Home&nbsp;Country</font></b></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Blood&nbsp;Type</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Name&nbsp;of&nbsp;NOK</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">NOK&nbsp;Home&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">NOK&nbsp;Mobile&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Reason&nbsp;for&nbsp;Travel</font></b></td>
	<!--td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Travel&nbsp;Country</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Travel&nbsp;City</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Overseas&nbsp;Address</font></b></td--->
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Contact&nbsp;No.&nbsp;While&nbsp;Travelling</font></b></td>
	<td width="7" class="TemperatureHistoryTitle"><b><font color="#000000">Period&nbsp;of&nbsp;Travel</font></b></td>
	<% for i=1 to CONSTANT_Max_Multiple_CountryCity %>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;Country&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;City&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Flight&nbsp;Number&nbsp;<%=i%></font></b></td>

	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;Country&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;City&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;Address&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Arrival&nbsp;Date&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;Date&nbsp;<%=i%></font></b></td>
	<% next %>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Other&nbsp;Travelling&nbsp;Details</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Overseas&nbsp;Organisation&nbsp;Name</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Organisation&nbsp;Contact&nbsp;Person</font></b></td>
	<td width="12" class="TemperatureHistoryTitle"><b><font color="#000000">Organisation&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">SMU&nbsp;Contact&nbsp;Person</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Remarks</font></b></td>
	<td width="15" class="TemperatureHistoryTitle"><b><font color="#000000">Declaration/Creation&nbsp;Date&nbsp;&&nbsp;Time</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Created&nbsp;By</font></b></td>	
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Reason&nbsp;for&nbsp;Official&nbsp;Travel</font></b></td>
       	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">IsInSG</font></b></td>
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">IsValid</font></b></td>
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">OtherTravelDtl</font></b></td>
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">ModifiedBy</font></b></td>   
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">HasTravelPlan</font></b></td>   
</tr>

<%
count=0
	WHILE (not objRds.eof)
%>
	<!-- #INCLUDE FILE="sub_declaration_report.asp" -->
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