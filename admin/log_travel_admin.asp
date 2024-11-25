<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="../commonJavascript.js"  -->
    <link href="../ajax/libs/jqueryui/1.8.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="../ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="../ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></script>      
<%LogDte=Now()%>
<%
	loginid = ValidateXSSHTML(Request.QueryString("id"))

	'Start Security Hardenning Exercise 12 Jan 2012
	'Enclose id in apostrophe here instead of caller doing it in querystring	    

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select * FROM " & DBOWNER & "V_trace_useraccount where NtLoginAccount=? AND isActive='Y'"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("loginid", adVarChar,adParamInput,100,ValidateAndEncodeSQL(loginid))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set persRds = CurrCmd.EXECUTE()
	if persRds.EOF then
			Response.write "<br><div align=center>We cannot find this account in the system.<br><br>Please approachhelpdesk at 68280123 or emailhelpdesk at <a href=mailto:helpdesk.smu.edu.sg>helpdesk.smu.edu.sg</a>.</div>"
			Response.End
		else
			persUserAccountID=UCASE(trim(persRds("UserAccountID")))
			persDeptCd = trim(persRds("OrganisationID"))
			persTitle = trim(persRds("Title"))
			persUsername = UCASE(trim(persRds("Username")))
			' Removed NRIC variable by Avy - CR# 10097			
			persDepartmentName = trim(persRds("OrganisationDesc"))						
	end if	
	
%>

<html>
<head>
	<title>Form</title>
	<link rel="stylesheet" href="../tracing.css" type="text/css">
</head>
<script type="text/javascript">
    function specifyRow(){
        var x=document.getElementById('TblSectionDetail').rows
        x[1].height="100"
    }
</script>
<body onload="document.form1.TI1[1].checked=true;document.form1.TI2[1].checked=true;document.form1.TI3[1].checked=true;document.form1.TI4[1].checked=true;document.form1.TI5[1].checked=true;document.form1.chk.checked=false;">
<form name="form1" method=post action="log_travel_admin_dup.asp" onsubmit="return chkconfirm(this)">
<table cellspacing="0" width="530" align="center" border="0">
<tr>
<td>
	<!-- Administrator Note -->
	<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2"><b>Administrator, please note that this form is being submitted on behalf of:</b></td>
	</tr>
	</table>
	
	<table cellspacing="0" width="530" align="center" border="0">
<tr>
<td>

    <table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2" class="SectionHeader"><b>Personal Information</b></td>
	</tr>
	</table>
	<table class="SectionDetail" width="100%" cellpadding="2">
	<tr>
		<td width="35%">&nbsp;&nbsp;&nbsp;Name:</td>
		<td width="65%"> <%=ValidateXSSHTML(persUsername)%></td>
	</tr>
	<%
	' Removed NRIC field by Avy - CR# 10097 
	%>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;School/Office:</td>
		<td><%=ValidateXSSHTML(persDepartmentName)%></td>
	</tr>
	<tr>
		<td><b><font color="red">*</font>&nbsp;Contact No.:</b></td>
		<td><input type=text name="PersMobileNum" value="<%=ValidateXSSHTML(UserContactNum)%>" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;Personal Email Account:</td>
		<td><input type=text name="PersEmail" value="<%=ValidateXSSHTML(UserPersEmail)%>" size="50" maxlength="100"></td>
	</tr>
	
    <!-- #INCLUDE FILE="../common_log_travel.asp" -->
    	
	<input type="hidden" name="UserAccountID" value="<%=ValidateXSSHTML(persUserAccountID)%>">
	<input type="hidden" name="DeptCd" value="<%=ValidateXSSHTML(persDeptCd)%>">
	<input type="hidden" name="Title" value="<%=ValidateXSSHTML(persTitle)%>">
	<input type="hidden" name="Username" value="<%=ValidateXSSHTML(persUsername)%>">
	<!-- NRIC_FIN_PP hidden field removed by Avy - CR# 10097 -->	
	<input type="hidden" name="DepartmentName" value="<%=ValidateXSSHTML(persDepartmentName)%>">
	<% 
      tkn = hour(now())&minute(now())&second(now()) 
      session("log_travel_admin_dup_token") = tkn
  %>
	<input type="hidden" name="log_travel_admin_dup_token" value="<%=ValidateXSSHTML(tkn)%>">

</td>
</tr>
</table></form>
</body>
<!-- #INCLUDE FILE="../footer.asp" -->
<%OBJCONN.CLOSE%>




