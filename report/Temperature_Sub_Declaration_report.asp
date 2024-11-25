
	<%
	count=count+1
	
		frm=(PageNum-1) * PerPage
		showCnt=frm + count
		
		if color_count = 0 then
				myclass = "class=TemperatureHistoryDetail"
				color_count = 1
		else
				myclass = ""
				color_count = 0
		end if	
	%>	
	<tr valign="top">
	<td width="2%"<%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(showCnt)%></td>	
	<td width="15%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateXSSHTML(objRds("username"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("usertype"))%></td>
	<td width="18%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("nric_fin_pp"))%></td>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateXSSHTML(objRds("OrganisationDesc"))%></td>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("PersContactNum"))%></td>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(FormatNumber(objRds("Temperature"),1,,,0))%></td>
	<td width="20%" <%=ValidateAndEncodeXSSEx(myclass)%>><%
	sRemarks=objRds("comment")
	if(excelSheet) then
		'sRemarks=Replace(sRemarks,chr(10)," ")
		'sRemarks=Replace(sRemarks,chr(13)," ")
		Response.Write(ValidateXSSHTML(sRemarks))
	else
		sRemarks = InsertStringAtInterval(Server.htmlencode(sRemarks), "<br />", 33)
		Response.Write(ValidateXSSHTML(sRemarks))
	end if
	
	%></td>
	<%
	logDate=objRds("logDate")
	intLocale = SetLocale(8201)
	NonExcelLogDate=FormatDateTime(objRds("logDate"),0)
	%>
	
	<% if(excelSheet) then %>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:dd\/mm\/yyyy\ hh\:mm\:ss\ AM\/PM"><%=ValidateAndEncodeXSSEx(logDate)%></td>
	<%else%>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(NonExcelLogDate)%></td>
	<%end if%>
	
 </tr>	
