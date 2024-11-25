<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->

<!-- #INCLUDE FILE="../header.asp" -->
<!-- #INCLUDE FILE="../CommonFunction.asp"  -->
<%
Response.Expires = 0
Response.Expiresabsolute = Now() - 1442
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.CacheControl = "no-cache"
%>
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
	<td align="center">
	
	<% if request.querystring("m") = "1" then %>
		You have no travelling plan <!-- CR-16462 :--> for the period between <%= CONSTANT_TRAVEL_DECLARE_PERIOD %>. <br/>
		Thank you for submitting the travel declaration form.
	<%else%>
		Thank you for submitting the travel declaration form. 
	<%end if%>
	
	</td>
</tr>	
<tr>
	<td>&nbsp;</td>
</tr>
</table>

<!-- Back Button -->
<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">	
<tr>
	<td align="center">
		<font face="Tahoma" size="2" color="#000000">
		<!--<a href="log_travel.asp">Back</a> -->
		<!--<a href="log_travel_preface.asp">Back</a>-->
		</font>
	</td>
</tr>	
</table>

<br><br>
<!-- #INCLUDE FILE="../footer.asp" -->

