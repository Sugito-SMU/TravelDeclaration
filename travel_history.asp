<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="CommonFunction.asp"  -->
<!-- #INCLUDE FILE="header.asp" -->

  <link href="/ajax/libs/jqueryui/1.8.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></script>      

<%

'Response.write NTLogin
'Response.end


if Session("TravelID") <> "" Then
TravelID=Session("TravelID")
session("TravelID")=""
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL1="SELECT [TravelID],[UserAccountID],FORMAT(DeclareDte,'dd-MMM-yyyy hh:mm tt') as DeclareDte,[BloodType],[PersMobileNum],[PersEmail],[NOKName],[NOKHomeNum],[NOKMobileNum],[DestAddr],[DestCity],[DestContactNum],CASE WHEN PurposeType='Official' THEN 'O' WHEN PurposeType='Personal' THEN 'P' ELSE PurposeType END AS PurposeType,[PurposeTxt],[OrgNm],[OrgContactPers],[OrgContactNum],[SMUContact],FORMAT(DepartDte,'dd-MMM-yyyy') as DepartDte,FORMAT(ReturnDte,'dd-MMM-yyyy') as ReturnDte,[Remarks],[CreatedBy],FORMAT(CreatedDte,'dd-MMM-yyyy hh:mm tt') as CreatedDte,[IsInSG],[IsValid],[OtherTravelDtl],[PurposeCd],[ModifiedBy],FORMAT(ModifiedDte,'dd-MMM-yyyy hh:mm tt') as ModifiedDte FROM [dbo].[v_trace_travel_report] WHERE TravelID=?"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TravelID))
CurrCmd.CommandText = strSQL1
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()

if objRds.EOF then
	Response.write "<br><div align=center>Error occured when cancel the travel declaration.<br><br>Please approach IT helpdesk at 68280123 or email IT helpdesk at <a href=mailto:helpdesk.smu.edu.sg>helpdesk.smu.edu.sg</a>.</div>"
	Response.End
else	
	UserAccountID=UCASE(trim(objRds("UserAccountID")))
	BloodType=trim(objRds("bloodType"))	
	PersMobileNum = trim(objRds("PersMobileNum"))
	PersEmail = trim(objRds("PersEmail"))
	NOKName = trim(objRds("NOKName"))
	NOKHomeNum = trim(objRds("NOKHomeNum"))
	NOKMobileNum = trim(objRds("NOKMobileNum"))
	DestAddr = trim(objRds("DestAddr"))
	DestCity = trim(objRds("DestCity"))	
	DestContactNum =trim(objRds("DestContactNum"))	
	PurposeType = trim(objRds("PurposeType"))
	PurposeTxt = trim(objRds("PurposeTxt"))
	DepartDte = trim(objRds("DepartDte"))
	ReturnDte = trim(objRds("ReturnDte"))
	OrgNm = trim(objRds("OrgNm"))
	OrgContactPers =trim(objRds("OrgContactPers"))
	OrgContactNum=trim(objRds("OrgContactNum"))
	SMUContact=trim(objRds("SMUContact"))
	Remarks=trim(objRds("Remarks"))
	CreatedBy=trim(objRds("CreatedBy"))
	IsInSG=trim(objRds("IsInSG"))
	PurposeCd=trim(objRds("PurposeCd"))
	IsValid=trim(objRds("IsValid"))
	OtherTravelDtl=trim(objRds("OtherTravelDtl"))
	ModifiedBy=trim(objRds("ModifiedBy"))	
end if

SET CurrCmd1 = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd1.ACTIVECONNECTION = OBJCONN

strSQL="Select TravelID,Seq,Country,City,DestAddress,FORMAT(DepDate,'dd-MMM-yyyy') as DepDate,FORMAT(ArrDate,'dd-MMM-yyyy') as ArrDate from [dbo].[V_Trace_Travel_CountryCity] where TravelID=? Order By Seq"
CurrCmd1.PARAMETERS.APPEND CurrCmd1.CreateParameter("TravelID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(TravelID))
CurrCmd1.CommandText = strSQL
CurrCmd1.CommandType = adCmdText
set objRds1 = CurrCmd1.EXECUTE()
         
         
        
	'DeptCd = trim(objRds("OrganisationID"))
	'Title = trim(objRds("Title"))
	'UserType=trim(objRds("UserType"))
	'UserName=trim(objRds("UserName"))
	'NTLogin=trim(objRds("NTLoginAccount"))
	'DepartmentName = trim(objRds("OrganisationDesc"))
	'UserContactNum = trim(objRds("CONTACT_MOBILE"))
	'UserPersEmail = trim(objRds("EMAIL_PERSONAL"))

		       SET CurrCmd2 = SERVER.CREATEOBJECT("ADODB.COMMAND")		
                       SET CurrCmd2.ACTIVECONNECTION = OBJCONN
 			CurrCmd2.COMMANDTEXT = DBOWNER & "csp_update_trace_travel"	
			'from view
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateAndEncodeSQL(UserAccountID))
			'Set in Stored Procedure instead
			
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("BloodType", adVarWChar, adParamInput,3, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(BloodType))))
			'from view
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateAndEncodeSQL(DeptCd))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("Title", adVarchar, adParamInput,250,ValidateAndEncodeSQL(Title))
			'not used
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PersOffNum", adVarWChar, adParamInput,30, "")
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(PersMobileNum))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PersEmail", adVarWChar, adParamInput,100, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(PersEmail))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("NOKName", adVarWChar, adParamInput,80, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NOKName))))
			'not used
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NOKHomeNum))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NOKMobileNum))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DestAddr", adVarWChar, adParamInput,660, "")
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DestCity", adVarWChar, adParamInput,100, "")
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3, "")
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DestContactNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(DestContactNum))))
			
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PurposeType", adVarWChar, adParamInput,1, ValidateAndEncodeSQL(PurposeType))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(PurposeTxt))))
		
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("DepartDte", adVarchar, adParamInput,20, DepartDte)
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("ReturnDte", adVarchar, adParamInput,20, ReturnDte)

			'Others
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("OrgNm", adVarWChar, adParamInput,300, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(OrgNm))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(OrgContactPers))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(OrgContactNum))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("SMUContact", adVarWChar, adParamInput,200, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(SMUContact))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("Remarks", adVarWChar, adParamInput,1000, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(Remarks))))
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("CreatedBy", adVarchar, adParamInput,40, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(CreatedBy))))

            CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("IsInSG", adVarchar, adParamInput,1, ValidateAndEncodeSQL(IsInSG))			
            CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("PurposeCd", adVarchar, adParamInput,10, ValidateAndEncodeSQL(PurposeCd))                       
			
			CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("IsValid", adVarchar, adParamInput,1, "N")
            CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("OtherTravelDtl", adVarchar, adParamInput,1000,ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(OtherTravelDtl))))
            CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("ModifiedBy", adVarchar, adParamInput,40, ReplaceSpecialCharactersDecode(ValidateAndEncodeSQL(ReplaceSpecialCharactersEncode(NTLogin))))
            CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("HasTravelPlan", adVarchar, adParamInput,40, "N")
              			
                      

 			'CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("TravelID", adBigInt, adParamInput,10,TravelID)
			'CurrCmd2.EXECUTE ,,adCmdStoredProc
			'Response.write(TravelID)
	                   if(TravelID<>"") then				
				RecordsAffected=0
 				CurrCmd2.PARAMETERS.APPEND CurrCmd2.CreateParameter("TravelID", adBigInt, adParamInput,10,TravelID)
				CurrCmd2.EXECUTE RecordsAffected,,adCmdStoredProc
				if(RecordsAffected>0) then
				  sTravelID =TravelID
				 
                   		 while not objRds1.EOF	
                                 TravelID = objRds1("TravelID")
                                ' Response.Write "TravelID" & TravelID
                                 Seq = objRds1("Seq")
                                 'Response.Write "Seq" & Seq
                                 Country= objRds1("Country")
                                 ' Response.Write "Country" & Country
                                 City = objRds1("City")
                                 'Response.Write "City" & City
                                 DestAddress = objRds1("DestAddress")
                                ' Response.Write "DestAddress" & DestAddress
                                 DepDate = objRds1("DepDate")
                                 'Response.Write "DepDate" & DepDate
                                 ArrDate = objRds1("ArrDate")
                              ' Response.Write "ArrDate " & ArrDate 
                                 'Response.End
                                 'sErrorCode=Insert_Travel_Trace_CountryCity1(objRds1(TravelID),objRds1(Seq),objRds1(Country),objRds1(City),objRds1(DestAddress),objRds1(DepDate),objRds1(ArrDate))
                               
                                  SET CurrCmd4 = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd4.COMMANDTEXT = "[dbo].[CSP_INSERT_TRACE_TRAVEL_CountryCity]"
  		SET CurrCmd4.ACTIVECONNECTION = OBJCONN
			
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("TravelID", adInteger, adParamInput,10,TravelID)
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("Seq", adInteger, adParamInput,10, Seq)
			
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("Country", adVarWChar, adParamInput,3,ValidateAndEncodeSQL(Country))
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("City", adVarWChar, adParamInput,100,ValidateAndEncodeSQL(City))
			'not used
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("DestAddress", adVarWChar, adParamInput,660, ValidateAndEncodeSQL(DestAddress))
			
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("DepDate", adVarchar, adParamInput,20, ValidateAndEncodeSQL(DepDate))
			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("ArrDate", adVarchar, adParamInput,20, ValidateAndEncodeSQL(ArrDate))


			CurrCmd4.PARAMETERS.APPEND CurrCmd.CreateParameter("DepCountry", adVarWChar, adParamInput,3,ValidateAndEncodeSQL(DepCountry))
			CurrCmd4.PARAMETERS.APPEND CurrCmd.CreateParameter("DepCity", adVarWChar, adParamInput,100,ValidateAndEncodeSQL(DepCity))
			CurrCmd4.PARAMETERS.APPEND CurrCmd.CreateParameter("FlightNo", adVarWChar, adParamInput,30,ValidateAndEncodeSQL(FlightNo))

			CurrCmd4.PARAMETERS.APPEND CurrCmd4.CreateParameter("Rescsp", adBigInt, adParamOutput)
					
			CurrCmd4.EXECUTE ,,adCmdStoredProc
	
			sErrorCode =CLNG(CurrCmd4.Parameters("Rescsp").value) '0 means not ok


                          
                                objRds1.MoveNext    

                                wend
				end if
				
                           end if

session("TravelID")=""

END IF

%>


<%LogDte=Now()%>
<%
Function InsertStringAtInterval(rsSource, rsInsert, rlInterval)
	Dim rgx
	Set rgx = new RegExp
	rgx.Pattern = "([\s\S]{" & rlInterval & "})"
	rgx.Global = true
	InsertStringAtInterval = rgx.Replace(rsSource, "$1" & rsInsert)
End Function

%>

<!-- #INCLUDE FILE="header_travel.asp" -->
<script language="javascript">
	function chkconfirm(form1) {
		return true;
	}


</script>

<form name="form1" method=post action="travel_history.asp" onsubmit="return chkconfirm(this)">

<div id="dialog" title="Confirmation Required" style="font-size: medium;" >
  Are you sure you want to cancel this declaration ?
</div>

<table cellspacing="0" width="530" align="center" border="0">
<tr>
	<td>
		<!-- Personal Info -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td colspan="2" class=SectionHeader><b>Personal Information</b></td>
		</tr>
		</table>
		<table class=SectionDetail   width="100%" cellpadding="8">
		<tr>
			<td width="35%"><b>Name:</b></td>
			<td width="65%"> <%=ValidateAndEncodeXSSEx(Username)%></td>
		</tr>		<tr>
			<td><b>School/Office:</b></td>
			<td><%=ValidateAndEncodeXSSEx(DepartmentName)%></td>
		</tr>
		</table>

		<!-- Spacer -->
		<table border="0" bordercolor=black cellpadding="0" cellspacing="0" width="100%" style="color:black">
		<tr>
			<td>&nbsp;</td>
		</tr>
		</table>

		<!-- Travel History -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td colspan="2" class=SectionHeader><b>Travel History</b> </td>
		</tr>
		</table>

		<!-- Travel History -->
		<table border="0" cellpadding="0" cellspacing="0"  width="100%">	
		<tr>
			<td>
			<%
'Response.write(ValidateAndEncodeSQL(UserAccountID))
				'Remove UPPER
				'Set objRds = objConn.Execute(DecodeQuadrupleQuotes("Select * FROM " & DBOWNER & "V_Trace_Temperature where UPPER(useraccountid)='" & UCASE(UserAccountID) & "' order by logdate desc"))
				'Set objRds = objConn.Execute(DecodeQuadrupleQuotes("Select * FROM " & DBOWNER & "V_Trace_Temperature where useraccountid='" & UserAccountID & "' order by logdate desc"))
				'05 May: Add 14 days criteria to pull records only 14 days old
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
'strSQL="Select TravelID, FORMAT(DepartDte,'dd-MMM-yyyy') as DepartDte, FORMAT(declareDte, 'dd-MMM-yyyy hh:mm tt') as DeclareDate, (Select Top 1 CountryName+'/'+City from  [dbo].[v_trace_travel_countryCity] where TRAVELID=MainTable.TRAVELID order by Seq) as Country,PurposeType,CASE WHEN (IsValid='N') THEN 'N' ELSE 'Y' END as Status from  [dbo].[v_trace_travel_report] MainTable Where useraccountid=? Order By MainTable.DepartDte Desc,MainTable.DeclareDte Desc"
strSQL="Select TTR.TravelID, FORMAT(TTC.ArrDate,'dd-MMM-yyyy') as DepartDte, FORMAT(declareDte, 'dd-MMM-yyyy hh:mm tt') as DeclareDate,(TTC.Country+'/'+TTC.City) as Country,PurposeType,CASE WHEN (IsValid='N') THEN 'N' ELSE 'Y' END as Status FROM [dbo].[v_trace_travel_report] TTR LEFT JOIN [dbo].[Trace_Travel_CountryCity] TTC ON TTC.TravelID = TTR.TRAVELID and TTC.Seq=1 Where TTR.useraccountid=? Order By TTR.DepartDte Desc,TTR.DeclareDte Desc"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarChar,adParamInput,100,ValidateAndEncodeSQL(UserAccountID))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()


				if objRds.EOF then 
			%>
				
			<%
				else
			%>
					<table  width="100%"  border=1 align="center" cellpadding="4" cellspacing="0">
					<tr>
						<td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">S/N</b></font></td>
                                                <td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Declaration DateTime</b></font></td>
						<td width="10%" nowrap class="TemperatureHistoryTitle"><b><font color="#000000">Arrival Date</b></font></td>						
						<td width="10%" nowrap class="TemperatureHistoryTitle" align="Left"><b><font color="#000000">Country/City1</b></font></td>
						<td width="10%" class="TemperatureHistoryTitle" align="center"><b><font color="#000000">Purpose</b></font></td>
						<td width="50%" class="TemperatureHistoryTitle"><b><font color="#000000">Status</b></font></td>	
						<td width="50%" class="TemperatureHistoryTitle"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;</b></font></td>	
						<td width="50%" class="TemperatureHistoryTitle"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></font></td>						
					</tr>		
			<%
					color_count = 0
					r_count = 0
				
					while not objRds.EOF			
						r_count = r_count + 1
            
						if color_count = 0 then
							myclass = "class=TravelHistoryDetail"
							color_count = 1
						else
							myclass = ""
							color_count = 0
						end if		
			%>
					<tr>
   						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap><%=ValidateAndEncodeXSSEx(r_count)%></td>
						
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap><%=ValidateAndEncodeXSSEx(objRds("DeclareDate"))%></td>
                                                <td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap><%=ValidateAndEncodeXSSEx(objRds("DepartDte"))%></td>
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="Left"><%=ValidateAndEncodeXSSEx(objRds("Country"))%></td>
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="center"><%=ValidateAndEncodeXSSEx(objRds("PurposeType"))%></td>

						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="center"><%IF ValidateAndEncodeXSSEx(objRds("Status"))="N" THEN%>Cancelled<%ELSE%>Valid<%END IF%></td>


<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="center"><a class="EditLink" href="common_log_edit_travel.asp"><%IF ValidateAndEncodeXSSEx(objRds("Status"))="N" THEN%><%ELSE%>Edit<%END IF%></a></td>
						<td width="10%" valign="top" <%=ValidateAndEncodeXSSEx(myclass)%> nowrap align="center"><a class="CancelLink" href="travel_history.asp"><%IF ValidateAndEncodeXSSEx(objRds("Status"))="N" THEN%><%ELSE%>Cancel<%END IF%></a><input type="hidden" id="TravelID" name="TravelID" value="<%=ValidateAndEncodeXSSEx(objRds("TravelID"))%>"></td>
						
					</tr>
			<%
					objRds.MoveNext
					wend
			%>
					</table>
			<%
				end if			
			%>
			</td>
		</tr>
		</table>	
			<script type="text/javascript">
	  


 $(function() {


$(document).ready(function() {
    $("#dialog").dialog({
      autoOpen: false,
      modal: true
    });
  });



});


$('.EditLink').click(function(e){
	var TravelID=$(this).closest('tr').find('#TravelID').val();
 	e.preventDefault();
 var targetUrl = $(this).attr("href");
$.ajax({
		type: "POST",
		url: "set_session.asp?SessionName=TravelID&Value="+TravelID+"",
		success: function(msg){
			if(msg=="Success")
{
window.location.href = targetUrl;
}
}
  	});
	
});



$('.CancelLink').click(function(e){
	var TravelID=$(this).closest('tr').find('#TravelID').val();
 	e.preventDefault();
    	var targetUrl = $(this).attr("href");

	$("#dialog").dialog({
      buttons : {
        "Confirm" : function() {

  		$.ajax({
		type: "POST",
		url: "set_session.asp?SessionName=TravelID&Value="+TravelID+"",
		success: function(msg){
			if(msg=="Success")
			{
				window.location.href = targetUrl;
			}
				      }
  	});

        },
        "Cancel" : function() {
          	$(this).dialog("close");
        }
      }
    });
    $("#dialog").dialog("open");
});



</script>		<!-- Back Button -->
		<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
		<tr>
			<td align="right"><font face="Tahoma" size="2" color="#000000"><a href="log_travel_preface.asp">Back</a> </font></td>
		</tr>
		</table>

	</td>
</tr>
</table>

<!-- #INCLUDE FILE="footer.asp" -->
<%OBJCONN.CLOSE%>

