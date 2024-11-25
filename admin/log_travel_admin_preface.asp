<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="../CommonFunction.asp"  -->
<!-- #INCLUDE FILE="ReportHeader.asp" -->
<style>
.reportingPeriod
{
	color:blue;
}
.thankYouResponseNormal
{
	font-family: Arial, Helvetica, sans-serif;
}
#content {
margin-left:auto;
margin-right:auto;

}
</style>
<%
if Request.ServerVariables("REQUEST_METHOD")= "POST" then
  frmtoken = ValidateXSSHTML(REQUEST.FORM("log_travel_admin_preface_token"))
  sesstoken = session("log_travel_admin_preface_token")
  'response.write frmtoken & "==" & sesstoken
  'respnose.end
  if frmtoken <> sesstoken then
    response.write "Page has expired."
    response.end
  end if
end if
%>
<% postbackURL = "log_travel_admin_preface.asp?id=" & ValidateXSSHTML(Request.Querystring("id")) %>
<form method="post" action="<%= postbackURL %>"> <!--log_travel_admin_preface.asp-->
<div id="content">
<table border="0" cellspacing="0" height="400px" width="100%" ><!--start t1-->
	<tr>
		<td style="width:22.5%">&nbsp;</td>
		<td style="height:120px;width:55%">&nbsp;</td>
		<td style="width:22.5%">&nbsp;</td>
	</tr>
	<tr >
		<td >&nbsp;</td>
		<td style="text-align:center;background-color:gainsboro;vertical-align:top;" >
			<p/>&nbsp;
			<h2><u>Travel Declaration</u></h2>
			<!-- CR-16462 
			<h3>For the reporting period of <br/><% =ValidateXSSHTML(CONSTANT_TRAVEL_DECLARE_PERIOD) %></h3><p/>
			-->
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td style="width:5%;height:75px;background-color:gainsboro">&nbsp;</td>
					<td style="width:6%;" >&nbsp;</td>
					<td style="width:40%;" nowrap>
						<input type="radio" name="IsTravelling" value="NO" checked="checked" ><b>No</b>, selected staff has no travelling plan
					</td>
					<td style="width:40%" nowrap>
						<input type="radio" name="IsTravelling" value="YES" ><b>Yes</b>, selected staff has travelling plan
						</td>
					<td style="width:4%;" >&nbsp;</td>
					<td style="width:5%;background-color:gainsboro">&nbsp;</td>
				</tr>
			</table>
			<p/>
<% 
      tkn = hour(now())&minute(now())&second(now()) 
      session("log_travel_admin_preface_token") = tkn
%>
    	<input type="hidden" name="log_travel_admin_preface_token" value="<%=ValidateXSSHTML(tkn)%>">
			<input type="Submit" id="Submit" name="Submit" value="Submit" style="width:100px" />
			&nbsp;
		</div>
		</td>
		<td>&nbsp;</td>
	</tr>
</table><!--end t1-->
</form>
<script language="javascript">
var SubmitBtn = document.getElementById("Submit");
function NotTravelling(){
	SubmitBtn.value="Submit";
}
function IsTravelling() {
	SubmitBtn.value="Proceed";
}
</script>

<%
if Request.ServerVariables("REQUEST_METHOD")= "POST" then

	UserAccountID = Request.Querystring("id")
	loginid = Request.QueryString("id")

'******************************
'*****Request Variables *******
'******************************
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select * FROM " & DBOWNER & "V_trace_useraccount where NtLoginAccount=? AND isActive='Y'"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("loginid", adVarChar,adParamInput,100,ValidateAndEncodeSQL(loginid))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set persRds = CurrCmd.EXECUTE()
	

	Dim persUserAccountID
	if persRds.EOF then
			Response.clear
			Response.write "<br><div align=center>We cannot find this account in the system.<br><br>Please approach helpdesk at 68280123 or email  helpdesk at <a href=mailto:helpdesk.smu.edu.sg>helpdesk.smu.edu.sg</a>.</div>"
			Response.End
		else
			persUserAccountID=UCASE(trim(persRds("UserAccountID")))
			persDeptCd = trim(persRds("OrganisationID"))
			persTitle = trim(persRds("Title"))
			persUsername = UCASE(trim(persRds("Username")))
			persDepartmentName = trim(persRds("OrganisationDesc"))	
	end if	
	Session("log_travel_admin_result_staffname") = UCASE(trim(ValidateXSSHTML(persRds("Username"))))

	reply = Request("IsTravelling")
	if reply = "YES" then
		response.redirect "log_travel_admin.asp?id=" & ValidateXSSHTML(Request.Querystring("id")) '"log_travel.asp"
	else
	
		'loginid = Request.QueryString("id")

		'Set persRds = objConn.Execute("Select * FROM " & DBOWNER & "V_trace_useraccount where NtLoginAccount='" & loginid & "' AND isActive='Y'")

		'Dim persUserAccountID
		'if persRds.EOF then
		'		Response.clear
		'		Response.write "<br><div align=center>We cannot find this account in the system.<br><br>Please approach CIT helpdesk at 68280123 or email CIT helpdesk at <a href=mailto:helpdesk.smu.edu.sg>helpdesk.smu.edu.sg</a>.</div>"
		'		Response.End
		'	else
		'		persUserAccountID=UCASE(trim(persRds("UserAccountID")))
		'		persDeptCd = trim(persRds("OrganisationID"))
		'		persTitle = trim(persRds("Title"))
		'		persUsername = UCASE(trim(persRds("Username")))
		'		persDepartmentName = trim(persRds("OrganisationDesc"))	
		'end if	
		
		SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT = DBOWNER & "CSP_INSERT_TRACE_TRAVEL"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateAndEncodeSQL(persUserAccountID))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarWChar, adParamInput,3, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateAndEncodeSQL(persDeptCd))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Title", adVarchar, adParamInput,250,ValidateAndEncodeSQL(persTitle))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersOffNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersEmail", adVarWChar, adParamInput,100, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKName", adVarWChar, adParamInput,80, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarWChar, adParamInput,660, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarWChar, adParamInput,100, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestContactNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeType", adVarWChar, adParamInput,1, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000,Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepartDte", adVarchar, adParamInput,20, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ReturnDte", adVarchar, adParamInput,20, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgNm", adVarWChar, adParamInput,300, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("SMUContact", adVarWChar, adParamInput,200, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Remarks", adVarWChar, adParamInput,1000, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40, ValidateAndEncodeSQL(NTLogin))

        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsInSG", adVarchar, adParamInput,1, Null)
		
        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeCd", adVarchar, adParamInput,10, PurposeCode)                        
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsValid", adVarchar, adParamInput,1, "Y")
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OtherTravelDtl", adVarchar, adParamInput,1000,Null)
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ModifiedBy", adVarchar, adParamInput,40,ValidateAndEncodeSQL(NTLogin))


    		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamOutput)

		CurrCmd.EXECUTE ,,adCmdStoredProc
		sTravelID = CLNG(CurrCmd.Parameters("TravelID").value)
		if sTravelID > 0 then
			'Session("log_travel_admin_result_staffname") = persUsername
			response.redirect "log_travel_admin_result.asp?t=0"
			
			'response.clear
			'response.write 	"<span class='thankYouResponseNormal'>" & _
			'				persUsername & " has no travelling plans for period " & CONSTANT_TRAVEL_DECLARE_PERIOD & ". <br/>Thank you for your response." & _
			'				"</span><p/>" & _
			'				"<a href='log_travel_admin_search.asp'>Go back to Administrator's Panel</a>"
		%>
			<!--<script language='javascript'>alert('Thank you. We have logged your response.');</script>-->
		<%
		end if
	end if
end if	
%>