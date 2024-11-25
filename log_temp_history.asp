<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->

<%LogDte=Now()%>
<%
Function InsertStringAtInterval(rsSource, rsInsert, rlInterval)
	Dim rgx
	Set rgx = new RegExp
	rgx.Pattern = "([\s\S]{" & rlInterval & "})"
	rgx.Global = true
	InsertStringAtInterval = rgx.Replace(rsSource, "$1" & rsInsert)
End Function

%>

<!-- #INCLUDE FILE="header_temperature.asp" -->
<script language="javascript">
	function chkconfirm(form1) {
		return true;
	}
</script>

<form name="form1" method=post action="log_temp_report.asp" onsubmit="return chkconfirm(this)">
<table cellspacing="0" width="580" align="center" border="0">
<tr>
	<td>
		<!-- Personal Info -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td colspan="2" class=SectionHeader><b>Personal Information</b></td>
		</tr>
		</table>
		<table class=SectionDetail   width="100%" cellpadding="8">
		<tr>
			<td width="35%"><b>Name:</b></td>
			<td width="65%"> <%=ValidateAndEncodeXSSEx(Username)%></td>
		</tr>
		<% if NRIC_FIN_PP <> "" then %>
		<tr>
			<td width="35%"><b>NRIC/FIN/Passport No.:</b></td>
			<td width="65%"> <%=ValidateAndEncodeXSSEx(NRIC_FIN_PP)%></td>
		</tr>
		<% end if %>
		<tr>
			<td><b>School/Office:</b></td>
			<td><%=ValidateAndEncodeXSSEx(DepartmentName)%></td>
		</tr>
		</table>

		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0" width="100%" style="color:black">
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>

		<!-- Temperature History -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td colspan="2" class=SectionHeader><b>Temperature History</b> <font size='2'>(for the last 2 weeks)</font></td>
		</tr>
		</table>

		<!-- Temperature History -->
		<table border="0" cellpadding="0" cellspacing="0"  width="100%">	
		<tr>
			<td>
			<%
				'Remove UPPER
				'Set objRds = objConn.Execute(DecodeQuadrupleQuotes("Select * FROM " & DBOWNER & "V_Trace_Temperature where UPPER(useraccountid)='" & UCASE(UserAccountID) & "' order by logdate desc"))
				'Set objRds = objConn.Execute(DecodeQuadrupleQuotes("Select * FROM " & DBOWNER & "V_Trace_Temperature where useraccountid='" & UserAccountID & "' order by logdate desc"))
				'05 May: Add 14 days criteria to pull records only 14 days old
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select * FROM " & DBOWNER & "V_Trace_Temperature where useraccountid=? and DateDiff(day, Logdate, getdate()) < 14 order by logdate desc"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(UserAccountID))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()


				if objRds.EOF then 
			%>
				
			<%
				else
			%>
					<table  width="100%"  border=1 align="center" cellpadding="4" cellspacing="0">
					<tr>
						<td width="5%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">S/N</font></b></td>
						<td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Date</font></b></td>
						<td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Time</font></b></td>
						<td width="10%" class="TemperatureHistoryTitle" align="center"><b><font color="#000000">Temperature Taken (&#176;C)</font></b></td>
						<td width="10%" class="TemperatureHistoryTitle"><b><font color="#000000">Has Respiratory Symptoms?</font></b></td>
						<td width="40%" class="TemperatureHistoryTitle" style="min-width:230px"> <b><font color="#000000">Received a QO, SHN, or been issued MC for respiratory symptoms; or been a close contact of a confirmed case of Covid-19?</font></b></td>
						<td width="20%" class="TemperatureHistoryTitle"><b><font color="#000000">Remarks</font></b></td>						
					</tr>		
			<%
					color_count = 0
					r_count = 0
				
					while not objRds.EOF			
						r_count = r_count + 1
            
						if color_count = 0 then
							myclass = ""
							color_count = 1
						else
							myclass = ""
							color_count = 0
						end if		
			%>
					<tr>
   						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap><%=ValidateAndEncodeXSSEx(r_count)%></td>
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap><%=ValidateAndEncodeXSSEx(Day(objRds("LogDate")))%>-<%=ValidateAndEncodeXSSEx(Monthname(month(objRds("LogDate"))))%>-<%=ValidateAndEncodeXSSEx(year(objRds("LogDate")))%></td>
						<td width="10%" valign="top" <%=myclass%> nowrap><%Response.write(ValidateAndEncodeXSSEx(FormatDateTime(objRds("LogDate"),3)))%></td>
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="center"><%=ValidateAndEncodeXSSEx(FormatNumber(objRds("Temperature"), 1))%></td>
						
						<%
							IsRespiratory=""
							IsQuarantine=""

							if objRds("IsRespiratory")=True then
								IsRespiratory="Yes"
							elseif objRds("IsRespiratory")=False then
								IsRespiratory="No"
							end if

							if objRds("IsQuarantine")=True then
								IsQuarantine="Yes"
							elseif objRds("IsQuarantine")=False then
								IsQuarantine="No"
							end if
						%>

						<td width="50%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(IsRespiratory)%></td>
						<td width="50%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(IsQuarantine)%></td>
						<%
							myRemarks = objRds("Comment")
							myFormattedRemarks = InsertStringAtInterval(Server.HTMLEncode(myRemarks), "<br />", 33)
						%>
						<td width="50%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(myFormattedRemarks)%></td>
					</tr>
			<%
					objRds.MoveNext
					wend
			%>
					</table>
			<%
				end if			
			%>
			</td>
		</tr>
		</table>	

		<!-- Back Button -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td align="right"><font face="Tahoma" size="2" color="#000000"><a href="log_temp.asp">Back</a> </font></td>
		</tr>
		</table>

	</td>
</tr>
</table>
<!-- #INCLUDE FILE="footer.asp" -->
<%OBJCONN.CLOSE%>

