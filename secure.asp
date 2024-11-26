<%
response.buffer=true
%>
<!-- #INCLUDE FILE="sso.inc"  -->

<%
if (Session("ADFS_USERNAME") = "") then
    if (GetSSOToken() <> "") then
        Response.Redirect("sso.asp")
    else
        Response.Redirect("sso/login.aspx?route=SSO")
    end if
else
    username = Session("ADFS_USERNAME")
end if

Response.Write username



%>