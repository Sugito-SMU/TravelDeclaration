<%
response.buffer=true
IF UCASE(request.ServerVariables("HTTP_HOST"))="OSCAR.SMU.EDU.SG" THEN
	DBOwner="dbo." '"[smustf\kbtheng]."'"sharonwan."
	DBOwner2="dbo." '"sharonwan."
	DBOwner3="dbo." '"[smustf\kbtheng]."
	DBOwner4="dbo." '"[smustf\kbtheng]."'"sharonwan."
ELSE
	DBOwner="dbo."
	DBOwner2="dbo."
	DBOwner3="dbo."
	DBOwner4="dbo."
END IF
CONST VersionNum="2.0"
CONST staff_Domain="SMUSTF"
CONST student_Domain="SMUSTU"
DIM access
access="Y"
%>

<!-- #INCLUDE FILE="../../../../../../../elmo/login_header.asp" -->
<%

  IF (access = "N") THEN
      RESPONSE.WRITE SECACC_ACCESSMSG
      RESPONSE.END
  END IF
  
%>
<!-- #INCLUDE FILE="../../../../../../../elmo/prjtrace.asp"  -->
<%
'04 May: Remove UPPER and UCASE
'Set objRds = objConn.Execute("Select * FROM " & DBOWNER4 & "V_trace_useraccount where UPPER(NtLoginAccount)='" & UCASE(username) & "' AND isActive='Y'")

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL ="Select * FROM " & DBOWNER4 & "V_trace_useraccount where NtLoginAccount=? AND isActive='Y'"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("username", adVarChar,adParamInput,100,ValidateAndEncodeSQL(username))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()	

if objRds.EOF then
	Response.write "<br><div align=center>We cannot find your account in the system.<br><br>Please approach CIT helpdesk at 68280123 or email CIT helpdesk at <a href=mailto:helpdesk.smu.edu.sg>helpdesk.smu.edu.sg</a>.</div>"
	Response.End
else
	'04 May: UCASE UserAccountID 
	'UserAccountID=trim(objRds("UserAccountID"))
	UserAccountID=UCASE(trim(objRds("UserAccountID")))
	NRIC_FIN_PP=trim(objRds("NRIC_FIN_PP"))
	DeptCd = trim(objRds("OrganisationID"))
	Title = trim(objRds("Title"))
	UserType=trim(objRds("UserType"))
	UserName=trim(objRds("UserName"))
	NTLogin=trim(objRds("NTLoginAccount"))
	DepartmentName = trim(objRds("OrganisationDesc"))
	UserContactNum = trim(objRds("CONTACT_MOBILE"))
	UserPersEmail = trim(objRds("EMAIL_PERSONAL"))
	'Response.write objRds("CAMPUS_ID")
	'Response.write objRds("SIS_NAME")
	'Response.write objRds("EMPLID")
end if

%>