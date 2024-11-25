<%
' Receive the request querystrings
Dim sessionName 
session("TravelID") = ""
sessionName = TRIM(Request.QueryString("SessionName"))

Dim value
value = TRIM(Request.QueryString("Value"))

session(sessionName)=value

 

' Out the JSON string
Response.Write("Success")

%>