<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="CommonFunction.asp"  -->
<!-- #INCLUDE FILE="header.asp" -->


<style>
.reportingPeriod
{
	color:blue;
}
#content {
margin-left:auto;
margin-right:auto;

}
</style>
<%
if Request.ServerVariables("REQUEST_METHOD")= "POST" then
  frmtoken = ValidateXSSHTML(REQUEST.FORM("log_travel_preface_token"))
  sesstoken = session("log_travel_preface_token")
  'response.write frmtoken & "==" & sesstoken
  'respnose.end
  if frmtoken <> sesstoken then
    response.write "Page has expired."
    response.end
  end if
end if
%>
<form name="form1" method="post" action="log_travel_preface.asp">
<div id="content">
<table border="0" cellspacing="0" height="400px" width="100%" ><!--start t1-->
	<tr>
		<td style="width:30%">&nbsp;</td>
		<td style="width: 40%; height: 100px; text-align: right; vertical-align: bottom;"><a href="/travel_history.asp"><h4>View Travel History</h4></a>&nbsp;</td>
		<td style="width:30%">&nbsp;</td>
	</tr>
	<tr >
		<td style="width:30%">&nbsp;</td>
		<td style="width:40%;text-align:center;background-color:gainsboro;vertical-align:top;" >
			<p/>&nbsp;
			<h2><u>Travel Declaration</u></h2>
			
			<!-- CR-16462 
			<h3>For the reporting period of <br/><% =CONSTANT_TRAVEL_DECLARE_PERIOD %></h3><p/>
			-->
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">

<tr>
					<td style="width:5%;height:50px;background-color:gainsboro">&nbsp;&nbsp;</td>
					<td style="width:50%;" nowrap >
					<font color="red">*</font>&nbsp;I am currently in Singapore
					</td>
					<td style="width:20%;" nowrap >
						<input type="radio" name="IsInSingapore" id="IsInSingapore" value="Y"  onClick="IsInSingaporeYes()"> Yes
												
					</td>
					<td style="width:20%" nowrap >
						
						<input type="radio" name="IsInSingapore" id="IsInSingapore" value="N"  onClick="IsInSingaporeNo()"> No
						
					</td>
					<td style="width:5%;background-color:gainsboro">&nbsp;</td>
				</tr>	



<tr>
					<td style="width:5%;height:50px;background-color:gainsboro">&nbsp;&nbsp;</td>
					<td style="width:50%;" nowrap >
					<font color="red">*</font>&nbsp;I have travelling plan
					</td>
					<td style="width:20%;" nowrap >
						<input type="radio" name="IsTravelling" value="YES" onClick="IsTravellingF()">Yes
												
					</td>
					<td style="width:20%" nowrap >
						
						<input type="radio" name="IsTravelling" value="NO" onClick="NotTravelling()">No
						
					</td>
					<td style="width:5%;background-color:gainsboro">&nbsp;</td>
				</tr>	








							</table>
			
			<p/>
<% 
      tkn = hour(now())&minute(now())&second(now()) 
      session("log_travel_preface_token") = tkn

%>
    	<input type="hidden" name="log_travel_preface_token" value="<%=ValidateXSSHTML(tkn)%>">
			<input type="Submit" name="Submit" value="Submit" style="width:100px" onClick="return submitOnClick()" />
			&nbsp;
			</div>
		</td>
		<td style="width:30%">&nbsp;</td>
	</tr>
</table><!--end t1-->
</form>
<script language="javascript">
var SubmitBtn = document.getElementById("Submit");
function NotTravelling(){
	document.form1.Submit.value="Submit";
}
function IsTravelling() {
	document.form1.Submit.value="Proceed";
}
function IsInSingaporeNo(){	    
    
    //document.form1.IsTravelling[0].checked = true; 
    document.form1.IsTravelling[1].disabled = true;   
    document.form1.IsTravelling[1].checked = false;  
    //document.form1.IsTravelling.value="YES"; 
    document.form1.Submit.value="Proceed";
	
}
function IsInSingaporeYes(){      

    document.form1.IsTravelling[1].disabled = false; 
    var varIsTrav2;
            var ele = document.getElementsByName('IsTravelling');               
            for(i = 0; i < ele.length; i++) { 
                if(ele[i].checked) 
                varIsTrav2 = ele[i].value; 
            } 
          
         if(varIsTrav2 != null && varIsTrav2 == "NO")
          {
            document.form1.Submit.value="Submit";
          }
   
   
}
function IsTravellingF() {        
	document.form1.Submit.value="Proceed";  
       
}
function submitOnClick(){  
                   
            var varIsTrav2;
            var ele = document.getElementsByName('IsTravelling');               
            for(i = 0; i < ele.length; i++) { 
                if(ele[i].checked) 
                varIsTrav2 = ele[i].value; 
            } 
            
         if(varIsTrav2 == null || varIsTrav2 == "")
          {
            alert ("Please select the options in order to proceed with declaration.");
            return false;
          }
                
           var varIsinSG2;
           var ele = document.getElementsByName('IsInSingapore');               
            for(i = 0; i < ele.length; i++) { 
                if(ele[i].checked) 
                varIsinSG2 = ele[i].value; 
            }          
          if(varIsinSG2 == null || varIsinSG2 == "")
          {
           alert ("Please select the options in order to proceed with declaration.");
           return false;
          }
          return true;
         
}



</script>
<!-- #INCLUDE FILE="footer.asp" -->
<%
if Request.ServerVariables("REQUEST_METHOD")= "POST" then

session("IsInSingapore") = REQUEST.FORM("IsInSingapore")





	reply = Request("IsTravelling")

	if reply = "YES" then
		response.redirect "log_travel.asp"
	else
		SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT = "[dbo].CSP_INSERT_TRACE_TRAVEL"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("UserAccountID", adVarchar, adParamInput,13,ValidateAndEncodeSQL(UserAccountID))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("BloodType", adVarWChar, adParamInput,3, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DeptCd", adVarchar, adParamInput,10,ValidateAndEncodeSQL(DeptCd))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Title", adVarchar, adParamInput,250,ValidateAndEncodeSQL(Title))
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersOffNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersMobileNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PersEmail", adVarWChar, adParamInput,100, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKName", adVarWChar, adParamInput,80, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKHomeNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("NOKMobileNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddr", adVarWChar, adParamInput,660, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCity", adVarWChar, adParamInput,100, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestCountryCd", adVarWChar, adParamInput,3, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestContactNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeType", adVarWChar, adParamInput,1, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeTxt", adVarWChar, adParamInput,1000,Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepartDte", adVarchar, adParamInput,20, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ReturnDte", adVarchar, adParamInput,20, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgNm", adVarWChar, adParamInput,300, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactPers", adVarWChar, adParamInput,80, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OrgContactNum", adVarWChar, adParamInput,30, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("SMUContact", adVarWChar, adParamInput,200, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Remarks", adVarWChar, adParamInput,1000, Null)
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("CreatedBy", adVarchar, adParamInput,40, ValidateAndEncodeSQL(NTLogin))
                CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsInSG", adVarchar, adParamInput,1, Null)
                CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("PurposeCd", adVarchar, adParamInput,10, Null)  
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("IsValid", adVarchar, adParamInput,1, "Y")
                CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("OtherTravelDtl", adVarchar, adParamInput,1000,Null)
                CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ModifiedBy", adVarchar, adParamInput,40,ValidateAndEncodeSQL(NTLogin))  
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("HasTravelPlan", adVarchar, adParamInput,1, "N")
		CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adBigInt, adParamOutput)

		CurrCmd.EXECUTE ,,adCmdStoredProc
		sTravelID = CLNG(CurrCmd.Parameters("TravelID").value)
		if sTravelID > 0 then
			response.redirect "log_travel_result.asp?m=1"
			'response.clear
			'response.write 	"<span class='thankYouResponseNormal'>" & _
			'				"You have no travelling plans for period " & CONSTANT_TRAVEL_DECLARE_PERIOD & ". Thank you for your response." & _
			'				"</span>"
		%>
			<!--<script language='javascript'>alert('Thank you. We have logged your response.');</script>-->
		<%
		end if
	end if
end if	
%>