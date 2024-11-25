	<%
	count=count+1
	
		frm=(PageNum-1) * PerPage
		showCnt=frm + count
		
		if color_count = 0 then
				myclass = "class=TemperatureHistoryDetail"
				color_count = 1
		else
				myclass = ""
				color_count = 0
		end if	
	
		
	
	%>	
	<tr valign="top">
	<td width="1%" <%=myclass%>><%=ValidateXSSHTML(showCnt)%></td>	
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("username"))%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(objRds("usertype"))%></td>
	<td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("nric_fin_pp"))%></td>
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("Dept_T"))%></td>
	<td width="3%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("PersMobileNum"))%></td>
	
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("PersEmail"))%></td>
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("HomeAddress"))%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(objRds("HomeCountry"))%></td>
	<td width="2%" <%=myclass%>><%=ValidateXSSHTML(objRds("BloodType"))%></td>
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("NOKName"))%></td>
	<td width="5%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("NOKHomeNum"))%></td>
	<td width="5%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("NOKMobileNum"))%></td>
	<td width="5%" <%=myclass%>><%=ValidateXSSHTML(objRds("PurposeType"))%></td>
	<!--td width="3%" <%=myclass%>><%=ValidateXSSHTML(objRds("Country"))%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(objRds("DestCity"))%></td>
	<td width="5%" <%=myclass%>><%
	sDestAddr=objRds("DestAddr")
	if(excelSheet) then
		'myFormattedRemarks=Replace(sDestAddr,chr(10)," ")
		'myFormattedRemarks=Replace(myFormattedRemarks,chr(13)," ")
		Response.Write ValidateXSSHTML((sDestAddr))
	else
		if sDestAddr = "" then
		    'myFormattedRemarks = sDestAddr
			myFormattedRemarks = InsertStringAtInterval(ValidateXSSHTML(sDestAddr), "<br>", 33)
		else
			myFormattedRemarks = ""
		end if
		Response.Write ValidateXSSHTML(myFormattedRemarks)
	end if
	
	%></td-->
	<td width="5%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("DestContactNum"))%></td>
	<%
		intLocale = SetLocale(10249)
		'fc-DepartDte=objRds("DepartDte")'FormatDateTime(objRds("DepartDte"),2)
		'fc-ReturnDte=objRds("ReturnDte")'FormatDateTime(objRds("ReturnDte"),2)
		'fc-NonExcelDepartDte=FormatDateTime(objRds("DepartDte"),2)
		'fc-NonExcelReturnDte=FormatDateTime(objRds("ReturnDte"),2)
		
		if IsNull(objRds("DepartDte")) then 
			DepartDte="" 
			NonExcelDepartDte =""
		else 
			DepartDte=FormatDateTime(objRds("DepartDte"),2) 
			NonExcelDepartDte=FormatDateTime(objRds("DepartDte"),2)
		end if
		if IsNull(objRds("ReturnDte")) then 
			ReturnDte="" 
			NonExcelReturnDte=""
		else 
			ReturnDte=FormatDateTime(objRds("ReturnDte"),2) 
			NonExcelReturnDte=FormatDateTime(objRds("ReturnDte"),2)
		end if
		
		DeclareDte=objRds("DeclareDte")
		intLocale = SetLocale(8201)
		NonExcelDeclareDte=FormatDateTime(objRds("DeclareDte"),0)
				
	%>
	

	
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(objRds("PeriodOfTravel"))%></td>
	
	<%
	
	isPrevEmpty=true
	if objRds("Country")<>"" or objRds("DestCity")<>"" or objRds("DestAddr")<>"" then
		isPrevEmpty=false
	end if
	
	 sTravelID=objRds("TravelID")
	for i=1 to CONSTANT_Max_Multiple_CountryCity
	   sSeq=i
	%>
	<!-- #INCLUDE FILE="../sql_trace_travel_countrycity.asp" -->
	<%
		bHasTravelPlan = true
		if clng(objCntTravelPlan("cnt")) = 0 then
			bHasTravelPlan = false
		end if
		
		sCountry=""
		sCity=""
		sDestAddress=""
	    sArrDate=""
	    sDepDate=""
	    ' Modified by Avy CR# 9931 -- start
	    sNonExcelDepDate=""
	    sNonExcelArrDate=""
	    ' Modified by Avy CR# 9931 -- end
	    
		if objTraceTravelCountryCity.eof then
			sDeptCountry = ""
			sDeptCity=""
			sFlightNo=""
			sCountry = ""
			sCity=""
			sDestAddress=""
			sDepDate=""
			sNonExcelDepDate=""
			sNonExcelArrDate=""
			sArrDate=""
			
		else
			if isPrevEmpty=false and i=1 then
				
			sDeptCountry = objRds("DepCountry")
			sDeptCity=objRds("DepCountry")
			sFlightNo=objRds("FlightNo")

				sCountry=objRds("Country")
				sCity=objRds("DestCity")
				sDestAddress=objRds("DestAddr")
				if(excelSheet) then
				else
					sDestAddr = InsertStringAtInterval(ValidateXSSHTML(sDestAddr), "<br>", 33)
				end if
			end if
			
			while not objTraceTravelCountryCity.eof
				sCountry=objTraceTravelCountryCity("CountryName")
				if sCountry<>"" then	
			sDeptCountry = objTraceTravelCountryCity("DepCountry")
			sDeptCity=objTraceTravelCountryCity("DepCity")
			sFlightNo=objTraceTravelCountryCity("FlightNo")
					sCity=objTraceTravelCountryCity("City")
					sDestAddress=objTraceTravelCountryCity("DestAddress")
					sDepDate=objTraceTravelCountryCity("DepDate")
					if sDepDate<>"" then sNonExcelDepDate=FormatDateTime(sDepDate,0)
					
					sArrDate=objTraceTravelCountryCity("ArrDate")
					if sArrDate<>"" then sNonExcelArrDate=FormatDateTime(sArrDate,0)
				end if
				objTraceTravelCountryCity.movenext
			wend
		end if
		
	%>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sDeptCountry)%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sDeptCity)%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sFlightNo)%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sCountry)%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sCity)%></td>
	<td width="3%" <%=myclass%>><%=ValidateXSSHTML(sDestAddress)%></td>
	
	<% if(excelSheet) then %>
	<td width="3%" <%=myclass%> style=mso-number-format:"dd\/mm\/yyyy"><%=ValidateXSSHTML(sDepDate)%></td>
	<td width="3%" <%=myclass%> style=mso-number-format:"dd\/mm\/yyyy"><%=ValidateXSSHTML(sArrDate)%></td>
	<% else %>
	<td width="3%" <%=myclass%> ><%=ValidateXSSHTML(sNonExcelDepDate)%></td>
	<td width="3%" <%=myclass%> ><%=ValidateXSSHTML(sNonExcelArrDate)%></td>
	<% end if %>
	
	<% Next %>

	
	<td width="5%" <%=myclass%>><%
	sPurposeTxt=objRds("PurposeTxt")
	if(excelSheet) then
		'sPurposeTxt=Replace(sPurposeTxt,chr(10)," ")
		'sPurposeTxt=Replace(sPurposeTxt,chr(13)," ")
		Response.Write(ValidateXSSHTML(sPurposeTxt))
	else
		if IsNull(objRds("PurposeTxt")) then
			sPurposeTxt = ""
		else
			sPurposeTxt = InsertStringAtInterval(ValidateXSSHTML(sPurposeTxt), "<br>", 33)
		end if
		'sPurposeTxt = InsertStringAtInterval(Server.HTMLEncode(sPurposeTxt), "<br>", 33)
		Response.Write(ValidateXSSHTML(sPurposeTxt))
	end if
	%></td>
	<td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("OrgNm"))%></td>
	<td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("OrgContactPers"))%></td>
	<td width="4%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("OrgContactNum"))%></td>
	<td width="5%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(objRds("SMUContact"))%></td>
	<!---td width="10%"></td>
	<td width="5%" ></td>
	<td width="10%" ></td---->
	<td width="10%" <%=myclass%>><%
	if bHasTravelPlan = true then
		sRemarks=objRds("Remarks")
	else
		sRemarks="No travelling plan"
	end if
	'sRemarks=objRds("Remarks")
	if(excelSheet) then
		'sRemarks=Replace(sRemarks,chr(10)," ")
		'sRemarks=Replace(sRemarks,chr(13)," ")
		Response.Write(ValidateXSSHTML(sRemarks))
	else
		'sRemarks = InsertStringAtInterval(Server.HTMLEncode(sRemarks), "<br>", 33)
		Response.Write(ValidateXSSHTML(sRemarks))
	end if
	
	%></td>
	
	<% if(excelSheet) then %>
	<td width="10%" <%=myclass%> style="mso-number-format:dd\/mm\/yyyy\ hh\:mm\:ss\ AM\/PM"><%=ValidateXSSHTML(DeclareDte)%></td>
	<%else%>
	<td width="10%" <%=myclass%> style="mso-number-format:\@"><%=ValidateXSSHTML(NonExcelDeclareDte)%></td>
	<%end if%>
	
	<td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("CreatedBy"))%></td>
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("purposeTxt"))%></td>
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("IsInSG"))%></td>
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("IsValid"))%></td>
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("OtherTravelDtl"))%></td>
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("ModifiedBy"))%></td>         
        <td width="4%" <%=myclass%>><%=ValidateXSSHTML(objRds("HasTravelPlan"))%></td>                 


	
 </tr>	      
