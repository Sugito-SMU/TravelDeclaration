<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="../CommonFunction.asp"  -->

<html>
<head>
	<title>Form</title>
	<link rel="stylesheet" href="../tracing.css" type="text/css">
</head>
<body>
<script language="javascript">
function init()
{
	//window.location = "#toprow";
}
</script>
<%
staffname = ""
if Session("log_travel_admin_result_staffname") <> "" then
	staffname = Session("log_travel_admin_result_staffname")
elseif Request("staffname") <> "" then
	staffname = Request("staffname")
end if
%>
<body onLoad="init();">
<div id="toprow"></div>
<br><br>
<input type="hidden" name="staffname" value="<%=ValidateXSSHTML(staffname)%>">
<table cellspacing="0" width="560" align="center">
<tr>
	<td align="center">
	<% if request.querystring("t") = "0" then %>
			<%=ValidateXSSHTML(staffname)%> has no travelling plan
                        <!-- CR-16462  
			for the period between <%= CONSTANT_TRAVEL_DECLARE_PERIOD %>-->. 
			<br/>
			Thank you for submitting the travel declaration form.
	<%else%>
		Thank you for submitting the travel declaration form on behalf of <%=ValidateXSSHTML(staffname)%>. 
	<%end if%>
		<!--You have successfully submitted the travel declaration form. -->
	</td>
</tr>	
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<!-- Back Button -->
<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
<tr>
	<td align="center"><font face="Tahoma" size="2" color="#000000"><a href="log_travel_admin_search.asp">Back to Administrator's Panel</a> </font></td>
</tr>	
</table>		
<br><br>
</body>
</html>

