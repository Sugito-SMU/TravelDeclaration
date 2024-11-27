<%
response.buffer=true
%>
<!-- #INCLUDE FILE="sso.inc"  -->

<%
	Dim absolutePath
	absolutePath = Request.ServerVariables("URL")
	if (Session("ADFS_USERNAME") = "") then
	    if (GetSSOToken() <> "") then
	    	Call ValidateAndRouteSSO("sso/login.aspx?route="&absolutePath)
	    else
	        Response.Redirect("sso/login.aspx?route="&absolutePath)
	    end if
	end if
username = Session("ADFS_USERNAME")
	Response.Write username



%>