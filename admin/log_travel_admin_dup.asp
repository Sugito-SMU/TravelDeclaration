<!-- #INCLUDE FILE="../../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="../secure.asp" -->
<!-- #INCLUDE FILE="../AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="ReportHeader.asp" -->
<!-- #INCLUDE FILE="../CommonFunction.asp" -->
<!-- #INCLUDE FILE="../commonJavascript.js" -->


<%		

  frmtoken = ValidateXSSHTML(Request.Form("log_travel_admin_dup_token"))
  sesstoken = session("log_travel_admin_dup_token")
  if frmtoken <> sesstoken then
    response.write "Page has expired."
    response.end
  end if


	persUserAccountID=ValidateXSSHTML(Request.Form("UserAccountID"))
	persDeptCd = ValidateXSSHTML(Request.Form("DeptCd"))
	persTitle = ValidateXSSHTML(Request.Form("Title"))
	persUsername = ValidateXSSHTML(Request.Form("Username"))		
	'persNRIC_FIN_PP removed by Avy - CR# 10097
	persDepartmentName = ValidateXSSHTML(Request.Form("DepartmentName"))
	f_DepDte = ValidateXSSHTML(REQUEST.FORM("DepDte"))
	f_DepMth = ValidateXSSHTML(REQUEST.FORM("DepMth"))
	f_DepYr	 = ValidateXSSHTML(REQUEST.FORM("DepYr"))
	f_RetDte = ValidateXSSHTML(REQUEST.FORM("RetDte"))
	f_RetMth = ValidateXSSHTML(REQUEST.FORM("RetMth"))
	f_RetYr	 = ValidateXSSHTML(REQUEST.FORM("RetYr"))
		

	'DepartDte=CDate(f_DepDte&" "&Monthname(f_DepMth)&" "&f_DepYr)
	'ReturnDte=CDate(f_RetDte&" "&Monthname(f_RetMth)&" "&f_RetYr)
	'begin kingbee added on 27 May 2009
	
	sCountry=""
	sCountrySel=""
	iCnt=0
	for i=1 to CONSTANT_Max_Multiple_CountryCity
		sCountry=ValidateXSSHTML(Request.Form("DestCountryCd"& i))
		if sCountry<>"" then		
			iCnt=iCnt+1
			'Response.Write("<br>sCountry=" & sCountry)
			if iCnt=1 then
				sCountrySel= sCountrySel & "'" & sCountry & "'"
			else
				sCountrySel= sCountrySel & ",'" & sCountry & "'"
			end if
		end if
	Next
	 'Response.Write("<br>sCountrySel=" & sCountrySel)
	 
	TI1=ValidateXSSHTML(REQUEST.FORM("TI1"))
	TI5=ValidateXSSHTML(REQUEST.FORM("TI5"))
	
	'MainDepartDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("DepDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("DepMth")))&" "&ValidateXSSHTML(REQUEST.FORM("DepYr")))
	'MainReturnDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("RetDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("RetMth")))&" "&ValidateXSSHTML(REQUEST.FORM("RetYr")))
      
    PurposeCode=""
	if InStr(1, UserType, "STAFF", vbTextCompare) then
		PurposeCode=ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("StaffDDl"))))
	else
		PurposeCode=ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("StudentDDl"))))
	end if 
  
	sPurposeTxt=""
	if TI5="Y" then
		sPurposeTxt= ReplaceSpecialCharactersDecode(ValidateXSSHTML(ReplaceSpecialCharactersEncode(request.form("PurposeTxt"))))
	end if
	'end kingbee added on 27 May 2009

  'response.write "Hello 1b" & Request.Form("Updsubmit")
  'response.end
	' If user still want to proceed to submit the travel declaration form
	if (Request.Form("btnProceed")<>"" ) or (Request.Form("Updsubmit")<>"" ) THEN


		SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT ="CSP_INSERT_TRACE_TRAVEL"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN

			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateXSSHTML(persUserAccountID))
			'Response.Write("personnel useraccountid1:" & ValidateXSSHTML(persUserAccountID))
			'Set in Stored Procedure instead
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeclareDte", adVarchar, adParamInput,20,ValidateXSSHTML( Now()))
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarchar, adParamInput,4,ValidateXSSHTML( request.form("BloodType")))
      dim bldtype 
      bldtype = ucase(request.form("BloodType"))
      if (bldtype = "") or (bldtype = "A+") or (bldtype = "A-") or (bldtype = "B+") or (bldtype = "B-") or (bldtype = "AB+") or (bldtype = "AB-") or (bldtype = "O+") or (bldtype = "O-")  or (bldtype = "X") Then 
  			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarWChar, adParamInput,3,bldtype)
      else
        response.write "Invalid blood type"
        response.end
      end if

			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateXSSHTML(persDeptCd))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Title", adVarchar, adParamInput,250,ValidateXSSHTML(persTitle))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersOffNum", adVarWChar, adParamInput,30,ValidateXSSHTML( ""))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PersMobileNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersEmail", adVarWChar, adParamInput,100,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PersEmail")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKName", adVarWChar, adParamInput,80,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("NOKName")))))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKHomeNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("NOKMobileNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarWChar, adParamInput,660,ValidateXSSHTML( ""))

			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarWChar, adParamInput,100,ValidateXSSHTML( ""))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3,ValidateXSSHTML( ""))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestContactNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("DestContactNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeType", adVarWChar, adParamInput,1,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PurposeType")))))
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarchar, adParamInput,1000,ValidateXSSHTML( request.form("PurposeTxt")))
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( sPurposeTxt))))
			if(PurposeCode="STF999" or PurposeCode="STU999") then
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OfficialPurpose")))))
			else
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("PurposeOfficialText")))))
			end if


			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepartDte", adVarchar, adParamInput,20,Null)
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ReturnDte", adVarchar, adParamInput,20,GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("DepDte1"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("DepMth1")))&" "&ValidateXSSHTML(REQUEST.FORM("DepYr1"))))

			'Others
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgNm", adVarWChar, adParamInput,300,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OrgName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OrgContactPerson")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OrgContact")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("SMUContact", adVarWChar, adParamInput,200,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("SMUContactName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Remarks", adVarWChar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OthersRemarks")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40,ValidateXSSHTML( NTLogin))
			'Set in Stored Procedure instead
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedDte", adVarchar, adParamInput,20,ValidateXSSHTML( Now()))
			
                         CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsInSG", adVarchar, adParamInput,1, Null)
			
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeCd", adVarchar, adParamInput,10, PurposeCode)                        
			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsValid", adVarchar, adParamInput,1, "Y")
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OtherTravelDtl", adVarchar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(sPurposeTxt))))
                        CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ModifiedBy", adVarchar, adParamInput,40,ValidateXSSHTML( NTLogin))


			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("HasTravelPlan", adVarchar, adParamInput,1, "Y")


			
            'kingbee added on 25 May 2009
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamOutput)
			'end kinf bee added

      
			CurrCmd.EXECUTE ,,adCmdStoredProc
          
            sTravelID =CLNG(CurrCmd.Parameters("TravelID").value)
			'Response.Write("<br>sTravelID=" & sTravelID)
			if sTravelID>0 then
			    isErrFound=false
				for i=1 to CONSTANT_Max_Multiple_CountryCity
					
					isInsert=false
					
					sCountry=ValidateXSSHTML(Request.Form("DestCountryCd"& i))
					sCity=ValidateXSSHTML(Request.Form("DestCity"& i))
					sDestAddress=ValidateXSSHTML(Request.Form("DestAddr"& i))      

						sDepCountry=Request.Form("DeptCountryCd"& i) 
						sDepCity=Request.Form("DeptCity"& i) 
						sFlightNo=Request.Form("DeptFlightNo"& i) 
					
					sDepDte=ValidateXSSHTML(Request.Form("DepDte"& i))
					sDepMth=ValidateXSSHTML(Request.Form("DepMth"& i))
					sDepYr=ValidateXSSHTML(Request.Form("DepYr"& i))
					
					sRetDte=ValidateXSSHTML(Request.Form("RetDte"& i))
					sRetMth=ValidateXSSHTML(Request.Form("RetMth"& i))
					sRetYr=ValidateXSSHTML(Request.Form("RetYr"& i))
					
					DepartDte=Null
						if sDepMth<>"" then
							DepartDte=sDepDte & " " & Monthname(sDepMth) & " " & sDepYr
						end if
						ReturnDte=Null
						if sRetMth<>"" then
							ReturnDte=sRetDte & " " & Monthname(sRetMth) & " " & sRetYr
						end if

					'Response.Write("<br>sCountry=" & sCountry)
					'Response.Write("<br>sCity=" & sCity)
					'Response.Write("<br>sDestAddress=" & sDestAddress)
					'Response.Write("<br>DepartDte=" & DepartDte)
					'Response.Write("<br>ReturnDte=" & ReturnDte)
					if i=1 then
				      isInsert=true
				      if TI1="N" then 					    
							'DepartDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("DepDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("DepMth")))&" "&ValidateXSSHTML(REQUEST.FORM("DepYr")))
							'ReturnDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("RetDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("RetMth")))&" "&ValidateXSSHTML(REQUEST.FORM("RetYr")))
					  
	
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
						 sTI=ValidateXSSHTML(Request.Form("TI"& i-1))
						 if sTI="Y" then
						     isInsert=true
						 end if						
					end if
					
					if Request.Form("TI"& i)="N" then
     						ReturnDte=Null
					end if	
					
					if isInsert=true then
						sErrorCode=Insert_Travel_Trace_CountryCity(sTravelID,i,sCountry,sCity,sDestAddress,DepartDte,ReturnDte,sDepCountry,sDepCity,sFlightNo)
					
						Response.Write("<br>sErrorCode=" & sErrorCode)
						if sErrorCode=0 then
							isErrFound=true	
						end if
					end if
						
					'Response.Redirect "log_travel_result.asp"
				Next
				
				if isErrFound then
					Response.Write("Error Found.")
					Response.End 
				else
				    'Response.Write("OK.")
					Response.Redirect "log_travel_admin_result.asp"	
				end if 'end if isErrFound
			end if 'if sTravelID>0 then
			
		'Response.Redirect "log_travel_admin_result.asp"	
		
	END IF 'if Request.Form("btnProceed")<>"" THEN
		
	' Check if there is duplicate travel declaration records
	sql = "Select * from " & DBOWNER & "V_trace_travel_report where "
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "Select * FROM " & DBOWNER & "V_trace_travel_report where "&_
		" useraccountid = ?  and DepartDte = ? and ReturnDte = ? "&_
		" and ((CHARINDEX(?,''''+COUNTRY_C+'''')>0)	 or TravelID in (select TravelID from " & DBOWNER & "v_trace_travel_countryCity where (CHARINDEX(?,''''+COUNTRY+'''')>0))"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("persUserAccountID", adVarChar,adParamInput,100,ValidateXSSHTML(persUserAccountID))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("MainDepartDte", adVarChar,adParamInput,100,ValidateXSSHTML(MainDepartDte))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("MainReturnDte", adVarChar,adParamInput,100,ValidateXSSHTML(MainReturnDte))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sCountrySel", adVarChar,adParamInput,8000,ValidateXSSHTML(sCountrySel))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sCountrySel", adVarChar,adParamInput,8000,ValidateXSSHTML(sCountrySel))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()
	
	If not objRds.EOF then	
%>


<br>
There are other travel declaration records with the same Travel Country, From Date and To Date for <%=ValidateXSSHTML(persUsername)%>.

<table border="1" bordercolor=black align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="350%">
<tr valign="top" align="left">
	<td width="1%" class="TemperatureHistoryTitle"><b><font color="#000000">No.</font></b></td>
	<td width="7%" class="TemperatureHistoryTitle"><b><font color="#000000">Name</font></b></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">Student/<br>Staff</font></b></td>
	<!-- Commented by Avy - CR# 10097 start
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">NRIC/FIN/Passport No.</font></b></td>
		 Commented by Avy - CR# 10097 end -->
	<td width="7%" class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</font></b></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">Contact No.</font></b></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Personal Email Account</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Home Address</font></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">Home Country</font></td>
	<td width="2%" class="TemperatureHistoryTitle"><b><font color="#000000">Blood Type</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Name of NOK</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">NOK Home <br>Contact No.</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">NOK Mobile <br>Contact No.</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Reason for Travel</font></td>
	
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Contact No. While Travelling</font></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">From Date</font></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">To Date</font></td>
	<td width="3%" class="TemperatureHistoryTitle"><b><font color="#000000">Period of Travel</font></td>
	<!--td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Other Travelling Details</font></td-->
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">Organization Name</font></td>
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">Organization <br>Contact Person</font></td>
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">Organization <br>Contact No.</font></td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">SMU Contact Person
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp</font></td>
	<td width="15%" class="TemperatureHistoryTitle">
		<b><font color="#000000">Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp</font></b>
		<br>
	</td>
	<td width="5%" class="TemperatureHistoryTitle"><b><font color="#000000">Declaration/Creation Date & Time</font></td>
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">Created By&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp
	</font></td>
	
	<% for i=1 to CONSTANT_Max_Multiple_CountryCity %>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Country&nbsp;<%=ValidateAndEncodeXSSEx(i)%></font></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">City&nbsp;<%=ValidateAndEncodeXSSEx(i)%></font></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Overseas&nbsp;Address&nbsp;<%=ValidateAndEncodeXSSEx(i)%></font></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Arrival&nbsp;Date&nbsp;<%=ValidateAndEncodeXSSEx(i)%></font></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;Date&nbsp;<%=ValidateAndEncodeXSSEx(i)%></font></td>
	<% next %>
	
	<td width="4%" class="TemperatureHistoryTitle"><b><font color="#000000">Other Travelling Details</font></td>
	</tr>
	
	<%
		
	showCnt = 1
	WHILE (not objRds.EOF) 		
	%>
	<tr valign="top">
	<td width="1%"<%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(showCnt)%></td>	
	<td width="7%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("username"))%></td>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("usertype"))%></td>	
	<!-- NRIC/FIN/Passport No. column removed by Avy - CR# 10097 -->
	<td width="7%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("Dept_T"))%></td>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("PersMobileNum"))%></td>
	
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("PersEmail"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("HomeAddress"))%></td>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("HomeCountry"))%></td>
	<td width="2%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("BloodType"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("NOKName"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("NOKHomeNum"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("NOKMobileNum"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("PurposeType"))%></td>
	<!--td width="3%" ><%'objRds("Country")%></td-->
	<!--td width="3%" ><%'objRds("DestCity")%></td-->
	<!--td width="5%"><%
	'sDestAddr=objRds("DestAddr")
	'if(excelSheet) then
		'myFormattedRemarks=Replace(sDestAddr,chr(10)," ")
		'myFormattedRemarks=Replace(myFormattedRemarks,chr(13)," ")
	'	Response.Write(sDestAddr)
	'else
	'	myFormattedRemarks = InsertStringAtInterval(Server.HTMLEncode(sDestAddr), "<br>", 33)
	'	Response.Write(myFormattedRemarks)
	'end if
	%></td-->
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("DestContactNum"))%></td>
	<%
		intLocale = SetLocale(10249)
		DepartDte=FormatDateTime(objRds("DepartDte"),2)
		ReturnDte=FormatDateTime(objRds("ReturnDte"),2)
		
		intLocale = SetLocale(8201)
		DeclareDte=FormatDateTime(objRds("DeclareDte"),0)		
	%>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(DepartDte)%></td>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(ReturnDte)%></td>
	<td width="3%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("PeriodOfTravel"))%></td>
	<!--td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%
	sPurposeTxt=objRds("PurposeTxt")
	sPurposeTxt = InsertStringAtInterval(Server.HTMLEncode(sPurposeTxt), "<br>", 33)
	Response.Write(ValidateXSSHTML(sPurposeTxt))
	%></td-->
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("OrgNm"))%></td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("OrgContactPers"))%></td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("OrgContactNum"))%></td>
	<td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(objRds("SMUContact"))%></td>	
	<td width="15%" <%=ValidateAndEncodeXSSEx(myclass)%>><%
	sRemarks=objRds("Remarks")
	sRemarks = InsertStringAtInterval(Server.HTMLEncode(sRemarks), "<br>", 33)
	Response.Write(ValidateXSSHTML(sRemarks))
	%></td>
	<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(DeclareDte)%></td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("CreatedBy"))%></td>

	<!-----begin kingbee added------------->
	<%
	sTravelID=0
	'Response.Write("<br>TravelID=" & objRds("TravelID"))
	sTravelID=objRds("TravelID")
	for i=1 to CONSTANT_Max_Multiple_CountryCity
	   sSeq=i
	%>
	<!-- #INCLUDE FILE="../sql_trace_travel_countrycity.asp" -->
	<%
		sCountry=""
		sCity=""
		sDestAddress=""
	    sArrDate=""
	    sDepDate=""
		while not objTraceTravelCountryCity.eof
			sCountry=objTraceTravelCountryCity("CountryName")
			'Response.Write("<br>TravelID=" & objTraceTravelCountryCity("TravelID"))
			if sCountry<>"" then
				sCity=objTraceTravelCountryCity("City")
				sDestAddress=objTraceTravelCountryCity("DestAddress")
				sDepDate=FormatDateTime(objTraceTravelCountryCity("DepDate"),0)
				sArrDate=FormatDateTime(objTraceTravelCountryCity("ArrDate"),0)
			end if
			
			objTraceTravelCountryCity.movenext
		wend
	%>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(sCountry)%> &nbsp;</td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(sCity)%> &nbsp;</td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(sDestAddress)%> &nbsp;</td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(sDepDate)%> &nbsp;</td>
	<td width="4%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(sArrDate)%> &nbsp;</td>
	
	<% Next %>
	<!-----end kingbee added------------->

    <td width="5%" <%=ValidateAndEncodeXSSEx(myclass)%>><%
    sPurposeTxt=objRds("PurposeTxt")
	sPurposeTxt = InsertStringAtInterval(Server.HTMLEncode(sPurposeTxt), "<br>", 33)
	Response.Write(ValidateXSSHTML(sPurposeTxt))
    %> &nbsp;
    </td> 
	
	<%		objRds.movenext
			showCnt = showCnt + 1
	wend	
	
	set objRds = nothing
	%>

</tr>
</table>

<form name="form1" method=post action="log_travel_admin_dup.asp">
<table width="50%" border ="0">
	<tr valign="top">
		<td colspan="3">Do you want to proceed to submit the travel declaration form?<br></td>		
	</tr>	

	<tr>
		<td width="15%"><input type="Submit" name="btnProceed" style="width:50%;"  value="Yes" ></td>
		<td width="15%"><input type="button" name="No" style="width:50%;" value="No" onclick="javascript:history.go(-1);"></td>
		<td width="70%"></td>
	</tr>	
	
	<!-- hidden fields -->
	<input type="hidden" name="UserAccountID" value="<%=ValidateAndEncodeXSSEx(persUserAccountID)%>">
	<input type="hidden" name="DeptCd" value="<%=ValidateAndEncodeXSSEx(persDeptCd)%>">
	<input type="hidden" name="Title" value="<%=ValidateAndEncodeXSSEx(persTitle)%>">
	<input type="hidden" name="Username" value="<%=ValidateAndEncodeXSSEx(persUsername)%>">
	<!-- NRIC_FIN_PP hidden field removed by Avy - CR# 10097 -->
	<input type="hidden" name="DepartmentName" value="<%=ValidateAndEncodeXSSEx(persDepartmentName)%>">	
	<input type="hidden" name="BloodType" value="<%=ValidateXSSHTML(request.form("BloodType"))%>">
	<input type="hidden" name="PersMobileNum" value="<%=ValidateXSSHTML(request.form("PersMobileNum"))%>">
	<input type="hidden" name="PersEmail" value="<%=ValidateXSSHTML(request.form("PersEmail"))%>">
	<input type="hidden" name="NOKName" value="<%=ValidateXSSHTML(request.form("NOKName"))%>">
	<input type="hidden" name="NOKHomeNum" value="<%=ValidateXSSHTML(request.form("NOKHomeNum"))%>">
	<input type="hidden" name="NOKMobileNum" value="<%=ValidateXSSHTML(request.form("NOKMobileNum"))%>">	
	<!--input type="hidden" name="DestAddr" value="<%=ValidateXSSHTML(request.form("DestAddr"))%>"-->
	<!--input type="hidden" name="DestCity" value="<%=ValidateXSSHTML(request.form("DestCity"))%>"-->
	<!--input type="hidden" name="DestCountryCd" value="<%=ValidateXSSHTML(request.form("DestCountryCd"))%>"-->
	<input type="hidden" name="DestContactNum" value="<%=ValidateXSSHTML(request.form("DestContactNum"))%>">
	<input type="hidden" name="PurposeType" value="<%=ValidateXSSHTML(request.form("PurposeType"))%>">
	<input type="hidden" name="PurposeTxt" value="<%=ValidateXSSHTML(request.form("PurposeTxt"))%>">	
	<input type="hidden" name="OrgName" value="<%=ValidateXSSHTML(request.form("OrgName"))%>">
	<input type="hidden" name="OrgContactPerson" value="<%=ValidateXSSHTML(request.form("OrgContactPerson"))%>">
	<input type="hidden" name="OrgContact" value="<%=ValidateXSSHTML(request.form("OrgContact"))%>">
	<input type="hidden" name="SMUContactName" value="<%=ValidateXSSHTML(request.form("SMUContactName"))%>">
	<input type="hidden" name="OthersRemarks" value="<%=ValidateXSSHTML(request.form("OthersRemarks"))%>">	
	<input type="hidden" name="DepDte" value="<%=ValidateAndEncodeXSSEx(f_DepDte)%>">
	<input type="hidden" name="DepMth" value="<%=ValidateAndEncodeXSSEx(f_DepMth)%>">
	<input type="hidden" name="DepYr" value="<%=ValidateAndEncodeXSSEx(f_DepYr)%>">
	<input type="hidden" name="RetDte" value="<%=ValidateAndEncodeXSSEx(f_RetDte)%>">
	<input type="hidden" name="RetMth" value="<%=ValidateAndEncodeXSSEx(f_RetMth)%>">
	<input type="hidden" name="RetYr" value="<%=ValidateAndEncodeXSSEx(f_RetYr)%>">
	
	<!----begin kingbee added	-------------->
	<%
	for i=1 to CONSTANT_Max_Multiple_CountryCity
	%>
					
	<input type="hidden" name="DestCountryCd<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DestCountryCd" & i))%>">
	<input type="hidden" name="DestCity<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DestCity" & i))%>">
	<input type="hidden" name="DestAddr<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DestAddr" & i))%>">
	<input type="hidden" name="DepDte<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DepDte" & i))%>">
	<input type="hidden" name="DepMth<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DepMth" & i))%>">
	<input type="hidden" name="DepYr<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("DepYr" & i))%>">
	<input type="hidden" name="RetDte<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("RetDte" & i))%>">
	<input type="hidden" name="RetMth<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("RetMth" & i))%>">
	<input type="hidden" name="RetYr<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("RetYr" & i))%>">
	
	<input type="hidden" name="TI<%=ValidateAndEncodeXSSEx(i)%>" value="<%=ValidateXSSHTML(request.form("TI" & i))%>">
		
	<%
	Next
	%>
	<!----end kingbee added	-------------->
	
	<!-- hidden fields -->
	
</table>
</form>

<%

else 'If objRds.EOF then (no duplication, direct insert)
		SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT = "CSP_INSERT_TRACE_TRAVEL"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN
			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateXSSHTML(persUserAccountID))
			'Response.Write("personnel useraccountid1:" & persUserAccountID)
			'Set in Stored Procedure instead
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeclareDte", adVarchar, adParamInput,20,ValidateXSSHTML( Now()))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarWChar, adParamInput,3,ValidateXSSHTML( request.form("BloodType")))
			'from view
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateXSSHTML(persDeptCd))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Title", adVarchar, adParamInput,250,ValidateXSSHTML(persTitle))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersOffNum", adVarWChar, adParamInput,30,ValidateXSSHTML( ""))

			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PersMobileNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersEmail", adVarWChar, adParamInput,100,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PersEmail")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKName", adVarWChar, adParamInput,80,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("NOKName")))))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKHomeNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("NOKMobileNum")))))
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarchar, adParamInput,660,ValidateXSSHTML( request.form("DestAddr")))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarWChar, adParamInput,660,ValidateXSSHTML( ""))

			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarchar, adParamInput,100,ValidateXSSHTML( request.form("DestCity")))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarWChar, adParamInput,100,ValidateXSSHTML( ""))
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarchar, adParamInput,3,ValidateXSSHTML( request.form("DestCountryCd")))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3,ValidateXSSHTML( ""))
			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestContactNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("DestContactNum")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeType", adVarWChar, adParamInput,1,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PurposeType")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("PurposeTxt")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepartDte", adVarchar, adParamInput,20, MainDepartDte)
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ReturnDte", adVarchar, adParamInput,20, MainReturnDte)

			'Others
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgNm", adVarWChar, adParamInput,300,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OrgName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OrgContactPerson")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(request.form("OrgContact")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("SMUContact", adVarWChar, adParamInput,200,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("SMUContactName")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Remarks", adVarWChar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode( request.form("OthersRemarks")))))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40,ValidateXSSHTML( NTLogin))
			'Set in Stored Procedure instead
			'CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedDte", adVarchar, adParamInput,20,ValidateXSSHTML( Now()))
			
			'kingbee added on 25 May 2009
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamOutput)
			'end kinf bee added
		
			CurrCmd.EXECUTE ,,adCmdStoredProc
			
			sTravelID =CLNG(CurrCmd.Parameters("TravelID").value)
			'Response.Write("<br>sTravelID=" & sTravelID)
			if sTravelID>0 then
			    isErrFound=false
				for i=1 to CONSTANT_Max_Multiple_CountryCity
				    isInsert=false
				    
					sCountry=ValidateXSSHTML(Request.Form("DestCountryCd"& i))
					sCity=ValidateXSSHTML(Request.Form("DestCity"& i))
					sDestAddress=ValidateXSSHTML(Request.Form("DestAddr"& i))    
					
					sDepDte=ValidateXSSHTML(Request.Form("DepDte"& i))
					sDepMth=ValidateXSSHTML(Request.Form("DepMth"& i))
					sDepYr=ValidateXSSHTML(Request.Form("DepYr"& i))
					
					sRetDte=ValidateXSSHTML(Request.Form("RetDte"& i))
					sRetMth=ValidateXSSHTML(Request.Form("RetMth"& i))
					sRetYr=ValidateXSSHTML(Request.Form("RetYr"& i))
					
					DepartDte=sDepDte & " " & Monthname(sDepMth) & " " & sDepYr
					ReturnDte=sRetDte & " " & Monthname(sRetMth) & " " & sRetYr
					
					if i=1 then
				      isInsert=true
				      if TI1="N" then 
							DepartDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("DepDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("DepMth")))&" "&ValidateXSSHTML(REQUEST.FORM("DepYr")))
							ReturnDte=GetFormattedDate(ValidateXSSHTML(REQUEST.FORM("RetDte"))&" "&Monthname(ValidateXSSHTML(REQUEST.FORM("RetMth")))&" "&ValidateXSSHTML(REQUEST.FORM("RetYr")))
				

					 end if
                    elseif i>1 then
						 sTI=ValidateXSSHTML(Request.Form("TI"& i-1))
						 if sTI="Y" then
						     isInsert=true
						 end if						
					end if
					
					if isInsert=true then
					    sErrorCode=2
					    
						sErrorCode=Insert_Travel_Trace_CountryCity(sTravelID,i,sCountry,sCity,sDestAddress,DepartDte,ReturnDte)
					
						Response.Write("<br>sErrorCode=" & sErrorCode)
						if sErrorCode=0 then
							isErrFound=true	
						end if
					end if
						
				Next
				
				if isErrFound then
					Response.Write("Error Found.")
					Response.End 
				else
				    'Response.Write("OK.")
					Response.Redirect "log_travel_admin_result.asp"	
				end if 'end if isErrFound
			end if 'if sTravelID>0 then
			
		'Response.Redirect "log_travel_admin_result.asp"		
end if
%>