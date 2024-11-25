
<html>
<head>
<%
CONSTANT_TITLE="Temperature Logging Report  (on who did not log temperature)"
CONSTANT_PERPAGE=20
%>
	<title><%=ValidateAndEncodeXSSEx(CONSTANT_TITLE)%></title>
		<style type="text/css">
body
{
    padding-right: 0px;
    padding-left: 0px;
    font-size: 10pt;
    padding-bottom: 0px;
    margin: 0px;
    color: #000000;
    text-indent: 10px;
    padding-top: 0px;
    font-family: arial, helvetica, sans-serif;
    background-color: #ffffff;
    text-decoration: none
}

table
{
	border-collapse: collapse;
	font-size: 10pt;
	color: #000000;
	background-color: white;
	font-family: tahoma, arial, helvetica, sans-serif
}
td {background-color:#ffffff; }
th {background-color:#dddddd; }

<!-- Style for H1N1 Declaration form -->
.FormHeaderTitle
{
    font-weight: bold;
    color: 2E7DA3;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 18pt;
}

.SectionHeader
{
    font-weight: bold;
    color: white;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 13pt;
    background-color: 666698;
}
table.SectionDetail td
{
    font-weight: bold;
    color: black;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 10pt;
    background-color: E8F2F4;
}

.TemperatureHistoryTitle
{
    font-weight: normal;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 10pt;
    background-color: cccccc
}

.TemperatureHistoryDetail
{
    font-weight: normal;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 10pt;
    background-color: E8F2F4
}

table.TemperatureHistory td
{
    font-weight: normal;
    color: black;
    text-decoration: none
    font-family: arial, helvetica, sans-serif;
    font-size: 9pt;
}
.tablehead
{
    font-weight: bold;
    color: white;
    background-color: black;
    text-decoration: none
}
.banner
{
	padding: 5px;
	height:20px;
	background-color:#3029c6;
	font-size:14pt; 
	color:white; 
	border: 1px solid #454646;
	text-align: left;
	font-weight:bold;
    	font-family: tahoma, verdana,arial, helvetica, sans-serif;
}
.button_add
{
   font-weight: normal;
   font-size: 8pt;
   color: #000000;
	background-color: #ffffcc;
	padding:2px;
	margin:1px;
 	cursor:hand;
	border:solid 1px black;
}

.button_update
{
   font-weight: normal;
   font-size: 8pt;
   color: #000000;
	background-color: #bbbbcc;
	padding:2px;
	margin:1px;
 	cursor:hand;
	border:solid 1px black;
}



.functionbar
{
    padding: 3px;
    font-weight: bold; font-size: 10pt; font-family: tahoma,verdana,arial;
    background-color: #333399; color: #eeeeee;
    text-align: center
}
.alert
{
    font-weight: bold;
    color: darkred
}
.completed
{
    color: gray
}
.notcompleted
{
    color: darkblue
}
.inputright
{
    font-size:10pt;
	text-align: right
}
.button_dark
{
   font-weight: normal;
   font-size: 12px;
   color: #eddddf;
	background-color: #330000;
	padding:2px;
	margin:1px;
 	cursor:hand;
	border:solid 1px black;
}

.response_pos {color:darkgreen}
.response_neg {color:darkred}
.eeptitle {font-size:13pt; color:white; font-weight:bold; padding-right:10px; font-family: verdana}
.footernote {font-size:7pt;color:white;}
input {font-size:10pt; }
select {font-size:10pt; background-color:#f2f2f2}

</style>
</head>
<body>
<br/>&nbsp;
<a href="../report/mainreport.asp">Back to main page</a>



