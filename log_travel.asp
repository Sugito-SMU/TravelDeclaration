<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="CommonFunction.asp"  -->
<!-- #INCLUDE FILE="commonJavascript.js"  -->
    <link href="ajax/libs/jqueryui/1.8.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></script>      
	
<%LogDte=Now()%>
<%if Request.Form("Updsubmit")<>"" THEN
	'response.write(REQUEST.FORM("DepDte")&" "&Monthname(REQUEST.FORM("DepMth"))&" "&REQUEST.FORM("DepYr"))
	'response.write(REQUEST.FORM("RetDte")&" "&Monthname(REQUEST.FORM("RetMth"))&" "&REQUEST.FORM("RetYr"))
	'response.end
	
	TI1=REQUEST.FORM("TI1")
	TI5=REQUEST.FORM("TI5")
	
	'if TI1="N" then
		'DepartDte=GetFormattedDate(REQUEST.FORM("DepDte")&" "&Monthname(REQUEST.FORM("DepMth"))&" "&REQUEST.FORM("DepYr"))
		'ReturnDte=GetFormattedDate(REQUEST.FORM("RetDte")&" "&Monthname(REQUEST.FORM("RetMth"))&" "&REQUEST.FORM("RetYr"))
		
	'elseif TI1="Y" then
		'DepDte1 DepMth1 DepYr1
		'RetDte1 RetMth1 RetYr1
		'DepartDte=CDate(REQUEST.FORM("DepDte1")&" "&Monthname(REQUEST.FORM("DepMth1"))&" "&REQUEST.FORM("DepYr1"))
		'ReturnDte=CDate(REQUEST.FORM("RetDte1")&" "&Monthname(REQUEST.FORM("RetMth1"))&" "&REQUEST.FORM("RetYr1"))
	'end if
	
TravelID=request.form("TravelID")
PurposeCode=""
	if InStr(1, UserType, "STAFF", vbTextCompare) then
		PurposeCode=ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("StaffDDl"))))
	else
		PurposeCode=ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("StudentDDl"))))
	end if 
'Response.write request.form("TravelID")
'Response.end

	sPurposeTxt=""
	if TI5="Y" then
		sPurposeTxt=request.form("PurposeTxt")
	end if		
	



	
	'Response.end
	'LogDate=CDate(REQUEST.FORM("logday")&" "&Monthname(REQUEST.FORM("logmth"))&" "&REQUEST.FORM("logyr")&" "&REQUEST.FORM("logyh")&":"&REQUEST.FORM("logmin"))
	SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		'CurrCmd.COMMANDTEXT = DBOWNER & "CSP_INSERT_TRACE_TRAVEL"
		if(TravelID<>"") then
 			CurrCmd.COMMANDTEXT = DBOWNER & "csp_update_trace_travel"
		else
			CurrCmd.COMMANDTEXT = DBOWNER & "csp_insert_trace_travel"
		end if
		
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN
			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateAndEncodeSQL(UserAccountID))
			'Set in Stored Procedure instead
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeclareDte", adVarchar, adParamInput,20, Now())
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarWChar, adParamInput,3, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("BloodType")))))
			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateAndEncodeSQL(DeptCd))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Title", adVarchar, adParamInput,250,ValidateAndEncodeSQL(Title))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersOffNum", adVarWChar, adParamInput,30, "")
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PersMobileNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersEmail", adVarWChar, adParamInput,100, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PersEmail")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKName", adVarWChar, adParamInput,80, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKName")))))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKHomeNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKMobileNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarWChar, adParamInput,660, "")

			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarWChar, adParamInput,100, "")
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3, "")
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestContactNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("DestContactNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeType", adVarWChar, adParamInput,1, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PurposeType")))))
			
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarchar, adParamInput,1000, request.form("PurposeTxt"))


			if(PurposeCode="STF999" or PurposeCode="STU999") then
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OfficialPurpose")))))
			else
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PurposeOfficialText")))))
			end if

			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepartDte", adVarchar, adParamInput,20, Null)
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ReturnDte", adVarchar, adParamInput,20, Null)

			'Others
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgNm", adVarWChar, adParamInput,300, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OrgName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OrgContactPerson")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OrgContact")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("SMUContact", adVarWChar, adParamInput,200, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("SMUContactName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Remarks", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OthersRemarks")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NTLogin))))

                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsInSG", adVarchar, adParamInput,1, session("IsInSingapore"))
			
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeCd", adVarchar, adParamInput,10, PurposeCode)                        
			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsValid", adVarchar, adParamInput,1, "Y")
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OtherTravelDtl", adVarchar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(sPurposeTxt))))
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ModifiedBy", adVarchar, adParamInput,40, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NTLogin))))
 
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("HasTravelPlan", adVarchar, adParamInput,1, "Y")


			sTravelID =0

			if(TravelID<>"") then
				'Response.write "123"
				RecordsAffected=0
 				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamInput,10,TravelID)
				CurrCmd.EXECUTE RecordsAffected,,adCmdStoredProc
				if(RecordsAffected>0) then
				  sTravelID =TravelID
				end if
			else
				'kingbee added on 25 May 2009
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamOutput)
				CurrCmd.EXECUTE ,,adCmdStoredProc
				sTravelID =CLNG(CurrCmd.Parameters("TravelID").value)
			end if

			



			
			
			'Response.Write("<br>sTravelID=" & sTravelID)
			if sTravelID>0 then
			    isErrFound=false
				
				for i=1 to CONSTANT_Max_Multiple_CountryCity
						isInsert=false
									    
						sCountry=Request.Form("DestCountryCd"& i)
						sCity=Request.Form("DestCity"& i)
						sDestAddress=Request.Form("DestAddr"& i)    

						sDepCountry=Request.Form("DeptCountryCd"& i) 
						sDepCity=Request.Form("DeptCity"& i) 
						sFlightNo=Request.Form("DeptFlightNo"& i) 
					
						sDepDte=Request.Form("DepDte"& i)
						sDepMth=Request.Form("DepMth"& i)
						sDepYr=Request.Form("DepYr"& i)
					
						sRetDte=Request.Form("RetDte"& i)
						sRetMth=Request.Form("RetMth"& i)
						sRetYr=Request.Form("RetYr"& i)

						DepartDte=Null
						if sDepMth<>"" then
							DepartDte=sDepDte & " " & Monthname(sDepMth) & " " & sDepYr
						end if
						ReturnDte=Null
						if sRetMth<>"" then
							ReturnDte=sRetDte & " " & Monthname(sRetMth) & " " & sRetYr
						end if
						
				    if i=1 then
						isInsert=true
						
						if TI1="N" then 
							'DepartDte=CDate(REQUEST.FORM("DepDte")&" "&Monthname(REQUEST.FORM("DepMth"))&" "&REQUEST.FORM("DepYr"))
							'ReturnDte=CDate(REQUEST.FORM("RetDte")&" "&Monthname(REQUEST.FORM("RetMth"))&" "&REQUEST.FORM("RetYr"))	
							
						DepartDte=Null
						if sDepMth<>"" then	
							DepartDte=GetFormattedDate(REQUEST.FORM("DepDte1")&" "&Monthname(REQUEST.FORM("DepMth1"))&" "&REQUEST.FORM("DepYr1"))
						end if

						ReturnDte=Null
						   if sRetMth<>"" then
							ReturnDte=GetFormattedDate(REQUEST.FORM("RetDte1")&" "&Monthname(REQUEST.FORM("RetMth1"))&" "&REQUEST.FORM("RetYr1"))
						   end if
						end if
						
                    elseif i>1 then
						 sTI=Request.Form("TI"& i-1)
					
						 if sTI="Y" then
						     isInsert=true     
						 end if						
					end if
					
					if Request.Form("TI"& i)="N" then
     						ReturnDte=Null
					end if	
					
					'Response.Write("<br>i=" & i)
					'Response.Write("<br>sTI=" & sTI)
					'Response.Write("<br>sCountry=" & sCountry)
					'Response.Write("<br>sCity=" & sCity)
					'Response.Write("<br>sDestAddress=" & sDestAddress)
					'Response.Write("<br>DepartDte=" & DepartDte)
					'Response.Write("<br>ReturnDte=" & ReturnDte)
					'Response.end
					'if (sCountry<>"") then
					if isInsert=true then
						sErrorCode=2
						sErrorCode=Insert_Travel_Trace_CountryCity(sTravelID,i,sCountry,sCity,sDestAddress,DepartDte,ReturnDte,sDepCountry,sDepCity,sFlightNo)
					
						'Response.Write("<br>sErrorCode=" & sErrorCode)
						if sErrorCode=0 then
							isErrFound=true	
						end if
					end if
						
				Next
				
				if isErrFound then
					Response.Write("Error Found.")
				else
					Response.Redirect "log_travel_result.asp"
				end if
				
			end if
END IF


%>
<!-- #INCLUDE FILE="header.asp" -->
<body onload="document.form1.TI1[1].checked=true;document.form1.TI2[1].checked=true;document.form1.TI3[1].checked=true;document.form1.TI4[1].checked=true;document.form1.TI5[1].checked=true;document.form1.chk.checked=false;">
<form name="form1" method=post action="log_travel.asp" onsubmit="return chkconfirm(this)">
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
		<td width="65%"> <%=ValidateXSSHTML(Username)%></td>
	</tr>
	<%
	if NRIC_FIN_PP<>"" then
	%>
	<tr>
		<td width="35%">&nbsp;&nbsp;&nbsp;NRIC/FIN/Passport No.:</td>
		<td width="65%"> <%=ValidateXSSHTML(NRIC_FIN_PP)%></td>
	</tr>
	<%
	end if
	%>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;School/Office:</td>
		<td><%=ValidateXSSHTML(DepartmentName)%></td>
	</tr>
	<tr>
		<td><b><font color="red">*</font>&nbsp;Contact No.:</b></td>
		<td><input type=text name="PersMobileNum" value="<%=ValidateXSSHTML(UserContactNum)%>" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;Personal Email Account:</td>
		<td><input type=text name="PersEmail" value="<%=ValidateXSSHTML(UserPersEmail)%>" size="50" maxlength="100"></td>
	</tr>
	
	<!-- #INCLUDE FILE="common_log_travel.asp" -->
</td>
</tr>
</table>
</body>
<!-- #INCLUDE FILE="footer.asp" -->
<%OBJCONN.CLOSE%>




