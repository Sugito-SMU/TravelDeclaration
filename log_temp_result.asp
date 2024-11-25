<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="commonfunction.asp" -->
<!-- #INCLUDE FILE="header.asp" -->
<%
Response.Expires = 0
Response.Expiresabsolute = Now() - 1442
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.CacheControl = "no-cache"
%>
<style>
.tempExceedMax
{
	color:blue;
	font-weight:bold;
}

</style>
<script language="javascript">
function init()
{
	window.location = "#toprow";
}
</script>
<body onLoad="init();">
<div id="toprow"></div>
<br><br>
<table cellspacing="0" width="560" align="center">
<tr>
	<%
	'04 May: Remove UPPER and UCASE
	'Set objRds = objConn.Execute("Select top 1* FROM " & DBOWNER & "V_Trace_Temperature where UPPER(useraccountid)='" & UCASE(UserAccountID) & "' order by logdate desc")

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select top 1 * FROM " & DBOWNER & "V_Trace_Temperature where useraccountid=? order by logdate desc"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(UserAccountID))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()

	if objRds.EOF then
		'nothing
	else
'Response.write objRds("IsRespiratory")
	%>	
		<td align="center">Thank you for submitting your temperature and the relevant declarations.
		<%    Message=""
		if cdbl(objRds("Temperature")) >= CONSTANT_HIGHEST_TEMP and objRds("IsRespiratory")=False and objRds("IsQuarantine")=False then
		      Message="The system has recorded your temperature on <b>" & Day(objRds("LogDate")) & "-" & Monthname(month(objRds("LogDate"))) & "-" &year(objRds("LogDate")) & "&nbsp;</b>at<b>&nbsp;" & FormatDateTime(objRds("LogDate"),3) & "&nbsp;</b>as <b>" & ValidateAndEncodeXSSEx(objRds("Temperature")) &"&#176; C</b>.</br></br> " & "<b> You may be having a fever. Put on a face-mask and immediately consult a doctor. You should also practice safe distancing. Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email:  <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.</b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) < CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=True and objRds("IsQuarantine")=False  then
		      Message="We note that you are currently displaying respiratory symptoms.</br></br><b>Put on a face-mask and immediately consult a doctor. You should also practice safe distancing.  Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.</b>"
			%><p/>	
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) >= CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=True and objRds("IsQuarantine")=False  then
		      Message="The system has recorded your temperature on <b>" & Day(objRds("LogDate")) & "-" & Monthname(month(objRds("LogDate"))) & "-" &year(objRds("LogDate")) & "&nbsp;</b>at<b>&nbsp;" & FormatDateTime(objRds("LogDate"),3) & "&nbsp;</b>as <b>" & ValidateAndEncodeXSSEx(objRds("Temperature")) &"&#176; C</b>" & ". We also note that you are currently displaying respiratory symptoms.<br><br> <b>Put on a face-mask and immediately consult a doctor. You should also practice safe  distancing.  Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.<b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) < CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=False and objRds("IsQuarantine")=True  then
		      Message="We note that you have received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19.<br><br><b>You should also practice safe  distancing and not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor. For students, immediately inform the Office of Safety and Security via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.<b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) >= CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=False and objRds("IsQuarantine")=True  then
		      Message="The system has recorded your temperature on <b>" & Day(objRds("LogDate")) & "-" & Monthname(month(objRds("LogDate"))) & "-" &year(objRds("LogDate")) & "&nbsp;</b>at<b>&nbsp;" & FormatDateTime(objRds("LogDate"),3) & "&nbsp;</b>as <b>" & ValidateAndEncodeXSSEx(objRds("Temperature")) &"&#176; C</b>" & ". We also note that you have received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19.<br><br><b>Put on a face-mask and immediately consult a doctor. You should also practice safe  distancing.  Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.<b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) < CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=True and objRds("IsQuarantine")=True  then
		      Message="We note that you have received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19. We also note that you are currently displaying respiratory symptoms.<br><br><b>Put on a face-mask and immediately consult a doctor. You should also practice safe  distancing.  Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.<b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) >= CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=True and objRds("IsQuarantine")=True  then
		      Message="The system has recorded your temperature on <b>" & Day(objRds("LogDate")) & "-" & Monthname(month(objRds("LogDate"))) & "-" &year(objRds("LogDate")) & "&nbsp;</b>at<b>&nbsp;" & FormatDateTime(objRds("LogDate"),3) & "&nbsp;</b>as <b>" & ValidateAndEncodeXSSEx(objRds("Temperature")) &"&#176; C</b>" & ". We also note that you have received a quarantine/isolation order, stay-home notice, or been issued medical certificates for respiratory symptoms; or been a close contact who is a confirmed case of Covid-19, and that you are currently displaying respiratory symptoms.<br><br><b>Put on a face-mask and immediately consult a doctor. You should also practice safe  distancing.  Do not come to campus if you have not done so.  For faculty or staff, immediately inform your supervisor on the outcome of your doctor's visit. For students, immediately inform the Office of Safety and Security on the outcome of your doctor's visit via email: <a href='mailto:OSS@smu.edu.sg'>OSS@smu.edu.sg</a> or 68085441 / 68280586.<b>"
			%><p/>
			<%=Message%>
		<%elseif cdbl(objRds("Temperature")) < CONSTANT_HIGHEST_TEMP  and objRds("IsRespiratory")=False and objRds("IsQuarantine")=False  then
		      Message="The system has recorded your temperature on <b>" & Day(objRds("LogDate")) & "-" & Monthname(month(objRds("LogDate"))) & "-" &year(objRds("LogDate")) & "&nbsp;</b>at<b>&nbsp;" & FormatDateTime(objRds("LogDate"),3) & "&nbsp;</b>as <b>" & ValidateAndEncodeXSSEx(objRds("Temperature")) &"&#176; C</b>" & "."
			%><p/>
			<%=Message%>
		<%
		end if
%>
		</td>
	<%
	end if 
	%>
	
</tr>
<tr>
	<td>&nbsp;</td>
</tr>

</table>
		<!-- Back Button -->
		<!--
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
		<tr>
			<td align="center"><font face="Tahoma" size="2" color="#000000"><a href="log_temp.asp">Back</a> </font></td>
		</tr>	
		</table>		
		-->
<br><br>
<!-- #INCLUDE FILE="footer.asp" -->

