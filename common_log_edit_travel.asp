<!-- #INCLUDE FILE="../includes/checkparams.asp" -->
<!-- #INCLUDE FILE="secure.asp" -->
<!-- #INCLUDE FILE="AdoVbs.Inc"  -->
<!-- #INCLUDE FILE="CommonFunction.asp"  -->
<!-- #INCLUDE FILE="header.asp" -->
<!-- #INCLUDE FILE="commonJavascript.js"  -->
    <link href="ajax/libs/jqueryui/1.8.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></script>     

<%  

LogDte=Now()

If Session("TravelID") <> "" Then
SessionTravelID=Session("TravelID")
Session("TravelID")=""
SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN

strSQL="SELECT [TravelID],[UserAccountID],FORMAT(DeclareDte,'dd-MMM-yyyy hh:mm tt') as DeclareDte,[BloodType],[PersMobileNum],[PersEmail],[NOKName],[NOKHomeNum],[NOKMobileNum],[DestAddr],'' As [DestCountryCd], [DestCity],[DestContactNum],CASE WHEN PurposeType='Official' THEN 'O' WHEN PurposeType='Personal' THEN 'P' ELSE PurposeType END as PurposeType,[PurposeTxt],[OrgNm],[OrgContactPers],[OrgContactNum],[SMUContact], Convert(varchar,DepartDte,103) as DepartDte,Convert(varchar,ReturnDte,103) as ReturnDte,[Remarks],[CreatedBy],FORMAT(CreatedDte,'dd-MMM-yyyy hh:mm tt') as CreatedDte,[IsInSG],[IsValid],[OtherTravelDtl],[PurposeCd],[ModifiedBy],FORMAT(ModifiedDte,'dd-MMM-yyyy hh:mm tt') as ModifiedDte FROM [dbo].[v_trace_travel_report] Where TravelID=?"
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adVarChar,adParamInput,100,SessionTravelID)
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objRds = CurrCmd.EXECUTE()


SET CurrCmd1 = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd1.ACTIVECONNECTION = OBJCONN

strSQL="Select TravelID,Seq,Country,City,DestAddress,Convert(varchar,DepDate,103) as DepDate, Convert(varchar,ArrDate,103) as ArrDate,DepCountry,DepCity,FlightNo from [dbo].[V_Trace_Travel_CountryCity] where TravelID=? Order By Seq"
CurrCmd1.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adVarChar,adParamInput,100,SessionTravelID)
CurrCmd1.CommandText = strSQL
CurrCmd1.CommandType = adCmdText
set objRds1 = CurrCmd1.EXECUTE()



if objRds1.eof or objRds1.bof then
    jMax=-1
'Response.write "if"

else
    arDataArray = objRds1.GetRows
    jMax = ubound(arDataArray, 2)
end if



'For i = 0 to jMax
	'Response.Write "TravelID : " & arDataArray(0,i) & " Seq : " & arDataArray(1, i)  & " Country : " & arDataArray(2, i)  & " City : " & arDataArray(3, i) & "<BR>"
'Next

'Response.end




End if


%>

<body onload="document.form1.chk.checked=false;">
<form name="form1" method=post action="log_travel.asp" onsubmit="return chkconfirm(this)">
<table cellspacing="0" width="530" align="center" border="0">
<%if objRds.EOF or SessionTravelID="" then
	Response.write "No records found <br><a href='travel_history.asp'>Back</a></div>"
	Response.End
else %>
<input type="hidden" id="TravelID" name="TravelID" value="<%=SessionTravelID%>">	
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
		<td><input type=text name="PersMobileNum" value="<%=objRds("PersMobileNum")%>" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;Personal Email Account:</td>
		<td><input type=text name="PersEmail" value="<%=objRds("PersEmail")%>" size="50" maxlength="100"></td>
	</tr>

	
	<!-- Personal Info -->

	
	
	<tr>
		<td><font color="red">*</font>&nbsp;<b>Blood Type:</b></td>
		<td>
			<SELECT NAME="BloodType" id="BloodType">
				<OPTION VALUE="">
				<OPTION VALUE="A+">A+
				<OPTION VALUE="A-">A-
				<OPTION VALUE="B+">B+
				<OPTION VALUE="B-">B-
				<OPTION VALUE="AB+" >AB+
				<OPTION VALUE="AB-" >AB-
				<OPTION VALUE="O+" >O+
				<OPTION VALUE="O-" >O-
				<OPTION VALUE="X" >I am not sure
			</SELECT>
		</td>
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>

	<!-- Emergency Contact -->
	<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2" class=SectionHeader><b>Emergency Contact/Next-of-Kin</b></td>
	</tr>
	</table>

	<table class=SectionDetail width="100%" cellpadding="2">
	<tr>
		<td width="35%"><font color="red">*</font>&nbsp;<b>Name of Contact:</b></td>
		<td width="65%"><input type=text name="NOKName" value="<%=objRds("NOKName")%>" size="50" maxlength="80"></td>
	</tr>
	<tr>
		<td width="35%"><font color="red">*</font>&nbsp;<b>Home Contact No.:</b></td>
		<td width="65%"><input type=text name="NOKHomeNum" value="<%=objRds("NOKHomeNum")%>" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td width="35%"><font color="red">*</font>&nbsp;<b>Mobile Contact No.:</b></td>
		<td width="65%"><input type=text name="NOKMobileNum" value="<%=objRds("NOKMobileNum")%>" size="30" maxlength="30"></td>
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>

	<!-- Travel Info -->
	<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2" class=SectionHeader><b>Travel Information</b></td>
	</tr>
	</table>
	<table class=SectionDetail width="100%" cellpadding="2" border="0">
	<tr>
	<td colspan="2">
		<span style="font-weight:normal;color:red">
		If some information is unavailable now, please edit your travel information when you have the details (via View Travel History).
		</span>
	</td></tr>
	<tr>
		<td width="10%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Purpose Type</b></td>
		<td width="90%" >
			<table width="100%">
			<tr>   

				<td ><input type="radio" name="PurposeType" id="PurposeType" value="P">Personal<br></td>
			</tr>
			<tr>
				<td><input type="radio" name="PurposeType" id="PurposeType" value="O" checked>Official
				</td>
			</tr>
			</table>
		</td>
	</tr>
<!-- Vinod -->

<input type="hidden" id="PurposeOfficialText" name="PurposeOfficialText" value="">
<input type="hidden" id="UserType" name="UserType" value="<%=UserType%>">
<tr valign="top" id="PurposeOfficial">
		<td width="35%"><font color="red">*</font>&nbsp;<b>Purpose of Official Travel:</b></td>
		<td width="65%">

		<SELECT NAME="StaffDDl" ID="StaffDDl" style="width: 87%;">
			<!-- #INCLUDE FILE="StaffsOfficialList.inc"  -->
		</SELECT>
		<SELECT NAME="StudentDDl" ID="StudentDDl" style="width: 87%;">
			<!-- #INCLUDE FILE="StudentsOfficialList.inc"  -->
		</SELECT>
		</td>
	</tr>

<tr valign="top" id="trPurpose">
		<td width="35%"><font color="red">*</font>&nbsp;<b>Please specify for Others:</b></td>
		<td width="65%"><textarea cols="39" rows="4" name="OfficialPurpose" id="OfficialPurpose" maxlength="1000"><%=objRds("PurposeTxt")%></textarea></td>
	</tr>
	<tr valign="top">
		<td width="35%"><font color="red" id="OverseasContact">*&nbsp;</font><b>Contact No. While Travelling:</b></td>
		<td width="65%"><input type=text name="DestContactNum" size="30" value="<%=objRds("DestContactNum")%>" maxlength="30"></td>
	</tr>

	</table>
  
   
	
    <!---------Travel Information 1---------->
    <table class=SectionDetail  width="100%" cellpadding="2" border="0">
	<tr>
		<td width="35%" colspan="2"><br><b><U>Country/City 1</U></b></td>
	</tr>
<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure Country:</b></td>
		<td width="65%">
		<SELECT NAME="DeptCountryCd1" ID="DeptCountryCd1" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure City:</b></td>

		<td width="65%"><input type="Text" name="DeptCity1" id="DeptCity1" size="30" maxlength="30"></td>
	
	</tr>
	<tr>
		<td width="35%" colspan="1">&nbsp;Flight Number:<font style="font-weight:normal;">&nbsp;&nbsp;(if available)</font></td>

		<td width="65%"><input type="Text" name="DeptFlightNo1" id="DeptFlightNo1" size="30" maxlength="30"></td>
	
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Country:</b></td>
		<td width="65%">
		<SELECT NAME="DestCountryCd1" ID="DestCountryCd1" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination City:</b></td>
			<script type="text/javascript">
	  


 $(function() {

if('<%=objRds("BloodType")%>'!='I am not sure')
{
$("#BloodType").val('<%=objRds("BloodType")%>');
}
else
{
$("#BloodType").val('X');
}

$("#PurposeOfficialText").val('<%=objRds("PurposeTxt")%>');
$("#PurposeType").val(['<%=objRds("PurposeType")%>']);


//$("#DepDte").val(SplitMonthDateYear("Date",'<%=objRds("DepartDte")%>'));
//$("#DepMth").val(SplitMonthDateYear('Month','<%=objRds("DepartDte")%>'));
//$("#DepYr").val(SplitMonthDateYear('Year','<%=objRds("DepartDte")%>'));

//$("#RetDte").val(SplitMonthDateYear("Date",'<%=objRds("ReturnDte")%>'));
//$("#RetMth").val(SplitMonthDateYear('Month','<%=objRds("ReturnDte")%>'));
//$("#RetYr").val(SplitMonthDateYear('Year','<%=objRds("ReturnDte")%>'));




var Details="<%=jMax%>";

<%
if(jMax>=0) Then
 For i = 0 To jMax%>

 $("#TI<%=i%>").val(['Y']);



 OpenCloseMoreTravel('TI<%=i%>','Y')

 $("#DestCountryCd<%=i+1%>").val('<%=arDataArray(2,i)%>');
 $("#DestCity<%=i+1%>").val('<%=arDataArray(3,i)%>');
 $("#DestAddr<%=i+1%>").val('<%=arDataArray(4,i)%>');
 


if ('<%=arDataArray(5,i)%>'!="")
{
 $("#RetDte<%=i+1%>").val(SplitMonthDateYear("Date",'<%=arDataArray(5,i)%>'));
 $("#RetMth<%=i+1%>").val(SplitMonthDateYear('Month','<%=arDataArray(5,i)%>'));
 $("#RetYr<%=i+1%>").val(SplitMonthDateYear('Year','<%=arDataArray(5,i)%>'));
}
else
{
 $("#RetDte<%=i+1%>").val('');
 $("#RetMth<%=i+1%>").val('');
 $("#RetYr<%=i+1%>").val('');
}



if ('<%=arDataArray(6,i)%>'!="")
{
 $("#DepDte<%=i+1%>").val(SplitMonthDateYear("Date",'<%=arDataArray(6,i)%>'));
 $("#DepMth<%=i+1%>").val(SplitMonthDateYear('Month','<%=arDataArray(6,i)%>'));
 $("#DepYr<%=i+1%>").val(SplitMonthDateYear('Year','<%=arDataArray(6,i)%>'));
}
else
{
 $("#DepDte<%=i+1%>").val('');
 $("#DepMth<%=i+1%>").val('');
 $("#DepYr<%=i+1%>").val('');
}

 $("#DeptCountryCd<%=i+1%>").val('<%=arDataArray(7,i)%>');
 $("#DeptCity<%=i+1%>").val('<%=arDataArray(8,i)%>');
 $("#DeptFlightNo<%=i+1%>").val('<%=arDataArray(9,i)%>');


<%if(i=4)then%>
 $("#OpenCloseTI6").css('display', 'inline');
 $("#TI5").val(['Y']);
<%end if%>
<%Next
end if%>




if($('#UserType').val()=="STAFF")
{
$('#StudentDDl').hide();
$('#StaffDDl').show();
$("#StaffDDl").val('<%=objRds("PurposeCd")%>');
}
else
{
$('#StudentDDl').show();
$('#StaffDDl').hide();
$("#StudentDDl").val('<%=objRds("PurposeCd")%>');
}

PurposeType();

OtherPurpose("");


$('#StaffDDl,#StudentDDl').change(function(){
 $("#PurposeOfficialText").val($(this).children("option:selected").text());
var Value=$(this).val();
if(Value=="STF999"||Value=="STU999")
     {
	$("#OfficialPurpose").val('');
     }
OtherPurpose(Value);
});

function SplitMonthDateYear(type,value)
{
var returnValue="";
var arr = value.split('/');
if(type=="Date")
{
returnValue=arr[0];
returnValue= returnValue.replace(/\b0/g, '');

}
else if(type=="Month")
{
returnValue=arr[1];
returnValue= returnValue.replace(/\b0/g, '');
}
else if(type=="Year")
{
//returnValue=arr[2];
returnValue=arr[2].split(' ')[0];

}
return returnValue;
}


function OtherPurpose(Value) {
   var Value1="";
   if(Value=="")
     {
	Value=$('#StaffDDl').val();
  	Value1=$('#StudentDDl').val();
     }
   else
     {
        Value1=Value;
     }

   if(Value=="STF999"||Value1=="STU999")
     {
        $("#trPurpose").css("display", "table-row");
	$("#PurposeOfficialText").val('');
     }
   else
     {
       $("#trPurpose").css("display", "none");
     }
}

$('input[name=PurposeType]').change(function(){
PurposeType();
});

function PurposeType() {
  var value = $('input[name=PurposeType]:checked' ).val();
if(value=="P")
{
    $("#OffDetails1,#OffDetails2,#OverseasContact,#PurposeOfficial,#trPurpose").css("display", "none");
    $('#StaffDDl').val('');
    $('#StudentDDl').val('');
    $("#OfficialPurpose").val('');
    $("#PurposeOfficialText").val('');
}
else
{
$("#OffDetails1,#OffDetails2,#PurposeOfficial").css("display", "table-row");
$("#OverseasContact").css("display", "inline");
}

}


limitText(document.form1.DestAddr1,document.form1.countdown1,500);
limitText(document.form1.DestAddr2,document.form1.countdownTI2,500);
limitText(document.form1.DestAddr3,document.form1.countdownTI3,500);
limitText(document.form1.DestAddr4,document.form1.countdownTI4,500);
limitText(document.form1.DestAddr5,document.form1.countdownTI5,500);
limitText(document.form1.PurposeTxt,document.form1.countdownPT,1000);
limitText(document.form1.OthersRemarks,document.form1.countdown3,1000);





$("#DeptCity1").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DeptCountryCd1').options[document.getElementById('DeptCountryCd1').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });
$("#DeptCity2").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DeptCountryCd2').options[document.getElementById('DeptCountryCd2').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

$("#DeptCity3").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DeptCountryCd3').options[document.getElementById('DeptCountryCd3').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

$("#DeptCity4").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DeptCountryCd4').options[document.getElementById('DeptCountryCd4').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });


$("#DeptCity5").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DeptCountryCd5').options[document.getElementById('DeptCountryCd5').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });






	        $("#DestCity1").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DestCountryCd1').options[document.getElementById('DestCountryCd1').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

	        $("#DestCity2").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DestCountryCd2').options[document.getElementById('DestCountryCd2').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

	        $("#DestCity3").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DestCountryCd3').options[document.getElementById('DestCountryCd3').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

	        $("#DestCity4").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DestCountryCd4').options[document.getElementById('DestCountryCd4').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });

	        $("#DestCity5").autocomplete({
	            source: function(request, response) {
	                $.ajax({
	                    url: "getCity.asp",
	                    data: "city=" + request.term + "&country=" + document.getElementById('DestCountryCd5').options[document.getElementById('DestCountryCd5').selectedIndex].value + "",
	                    dataType: "json",
	                    type: "GET",
	                    contentType: "application/json; charset=utf-8",
	                    dataFilter: function(data) { return data; },
	                    success: function(data) {
	                        response($.map(data.d, function(item) {
	                            return {
	                                value: item.Name
	                            }
	                        }))
	                    },
	                    error: function(XMLHttpRequest, textStatus, errorThrown) {
	                        alert(textStatus);
	                    }
	                });
	            },
	            minLength: 3
	        });			
	    });
			</script>
			<style>
			.ui-autocomplete
			{
				text-align: left;
				font-size: smaller;
			}
			</style>
		<td width="65%"><input type="Text" name="DestCity1" id="DestCity1" size="30" maxlength="30"></td>
	</tr>
	<tr >
		<td width="35%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Address:</b></td>
		<td width="65%">
			<textarea cols="39" rows="4" name="DestAddr1" id="DestAddr1" maxlength="500" onKeyDown="limitText(document.form1.DestAddr1,document.form1.countdown1,500);" onKeyUp="limitText(document.form1.DestAddr1,document.form1.countdown1,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdown1" size="3" value="500"> characters left</font>
		</td>
	</tr>
<tr id="OpenCloseDepDate"></tr>
	<tr id="OpenCloseDepDateee">
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 1)</font></td>
		<td width="65%">
			<select name="DepDte1" id="DepDte1" size="1" class="smalllink" onchange="DateChange('1','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth1" id="DepMth1" size="1" class="smalllink" onchange="DateChange('1','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr1" id="DepYr1" size="1" class="smalllink" onchange="DateChange('1','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
<tr id="OpenCloseRetDate" ></tr>
	
	<tr>
		<td width="35%" valign="top" colspan="1">
		&nbsp;&nbsp;&nbsp;Travelling to another <br>&nbsp;&nbsp;&nbsp;country/city:
		</td>
		<td width="65%">
		    <input type="radio" name="TI1" id="TI1" value="Y" onClick="OpenCloseMoreTravel('TI1','Y')"> Yes
			<input type="radio" name="TI1" value="N" checked  onClick="OpenCloseMoreTravel('TI1','N')"> No
			<!--input type="radio" name="TI1" value="Y" onClick="document.getElementById('OpenCloseTI2').style.display='block';document.getElementById('OpenCloseDepDate').style.display='block';document.getElementById('OpenCloseRetDate').style.display='block';"> Yes
			<input type="radio" name="TI1" value="N" checked  onClick="document.getElementById('OpenCloseTI2').style.display='none';document.getElementById('OpenCloseTI3').style.display='none';document.getElementById('OpenCloseTI4').style.display='none';document.getElementById('OpenCloseTI5').style.display='none';document.getElementById('OpenCloseTI6').style.display='none';document.getElementById('OpenCloseDepDate').style.display='none';document.getElementById('OpenCloseRetDate').style.display='none';"> No
			--->
		</td>
	</tr>

	</table>

	<!---------Travel Information 2---------->
	<table class=SectionDetail id="OpenCloseTI2" style="display:none;" width="100%" cellpadding="2" border="0">
<tr id="OpenCloseRetDateee">
		<td width="35%" colspan="1"><font color="red" id="DepartureStar1" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 1 <span id="ifAvailable1"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte1" id="RetDte1" size="1" class="smalllink" onchange="DateChange('1','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth1" id="RetMth1" size="1" class="smalllink" onchange="DateChange('1','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr1" id="RetYr1" size="1" class="smalllink" onchange="DateChange('1','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>

	<tr>
		<td width="35%" valign="top" colspan="1">
		</td>
		<td width="65%">
		&nbsp;
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="2"><b><U>Country/City 2</U></b></td>
	</tr>

<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure Country:</b></td>
		<td width="65%">
		<SELECT NAME="DeptCountryCd2" ID="DeptCountryCd2" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure City:</b></td>

		<td width="65%"><input type="Text" name="DeptCity2" id="DeptCity2" size="30" maxlength="30"></td>
	
	</tr>
	<tr>
		<td width="35%" colspan="1">&nbsp;Flight Number:<font style="font-weight:normal;">&nbsp;&nbsp;(if available)</font></td>

		<td width="65%"><input type="Text" name="DeptFlightNo2" id="DeptFlightNo2" size="30" maxlength="30"></td>
	
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Country:</b></td>
		<td width="65%">
		<SELECT NAME="DestCountryCd2" ID="DestCountryCd2">
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination City:</b></td>
		<td width="65%"><input type="Text" name="DestCity2" id="DestCity2" size="30" maxlength="30"></td>
	</tr>
	<tr >
		<td width="35%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Address:</b></td>
		<td width="65%">
			<textarea cols="39" rows="4" name="DestAddr2" id="DestAddr2" maxlength="500" onKeyDown="limitText(document.form1.DestAddr2,document.form1.countdownTI2,500);" onKeyUp="limitText(document.form1.DestAddr2,document.form1.countdownTI2,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI2" size="3" value="500"> characters left</font>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 2)</span></font></td>
		<td width="65%">
			<select name="DepDte2" id="DepDte2" size="1" class="smalllink" onchange="DateChange('2','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth2" id="DepMth2" size="1" class="smalllink" onchange="DateChange('2','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr2" id="DepYr2" size="1" class="smalllink" onchange="DateChange('2','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
	<tr>
		<td width="35%" valign="top" colspan="1">
			&nbsp;&nbsp;&nbsp;Travelling to another <br>&nbsp;&nbsp;&nbsp;country/city:
		</td>
		<td width="65%">

		    <input type="radio" name="TI2" value="Y" id="TI2"  onClick="OpenCloseMoreTravel('TI2','Y')"> Yes
			<input type="radio" name="TI2" value="N" id="TI2" checked  onClick="OpenCloseMoreTravel('TI2','N')"> No
			<!---input type="radio" name="TI2" value="Y" id="TI2"  onClick="document.getElementById('OpenCloseTI3').style.display='block';"> Yes
			<input type="radio" name="TI2" value="N" id="TI2" checked  onClick="document.getElementById('OpenCloseTI3').style.display='none';document.getElementById('OpenCloseTI4').style.display='none';document.getElementById('OpenCloseTI5').style.display='none';document.getElementById('OpenCloseTI6').style.display='none';"> No
			--->
		</td>
	</tr>
	</table>

	<!---------Travel Information 3---------->
	<table class=SectionDetail id="OpenCloseTI3" style="display:none;" width="100%" cellpadding="2" border="0">
<tr>
		<td width="35%" colspan="1"><font color="red" id="DepartureStar2" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 2 <span id="ifAvailable2"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte2" id="RetDte2" size="1" class="smalllink" onchange="DateChange('2','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth2" id="RetMth2" size="1" class="smalllink" onchange="DateChange('2','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr2" id="RetYr2" size="1" class="smalllink" onchange="DateChange('2','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
	


	<tr>
		<td width="35%" valign="top" colspan="1">
		</td>
		<td width="65%">
		&nbsp;
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="2"><u><b>Country/City 3</b></U></td>
	</tr>

<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure Country:</b></td>
		<td width="65%">
		<SELECT NAME="DeptCountryCd3" ID="DeptCountryCd3" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure City:</b></td>

		<td width="65%"><input type="Text" name="DeptCity3" id="DeptCity3" size="30" maxlength="30"></td>
	
	</tr>
	<tr>
		<td width="35%" colspan="1">&nbsp;Flight Number:<font style="font-weight:normal;">&nbsp;&nbsp;(if available)</font></td>

		<td width="65%"><input type="Text" name="DeptFlightNo3" id="DeptFlightNo3" size="30" maxlength="30"></td>
	
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Country:</b></td>
		<td width="65%">
		<SELECT NAME="DestCountryCd3" ID="DestCountryCd3">
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination City:</b></td>
		<td width="65%"><input type="Text" name="DestCity3" id="DestCity3" size="30" maxlength="30"></td>
	</tr>
	<tr >
		<td width="35%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Address:</b></td>
		<td width="65%">
			<textarea cols="39" rows="4" name="DestAddr3" id="DestAddr3" maxlength="500" onKeyDown="limitText(document.form1.DestAddr3,document.form1.countdownTI3,500);" onKeyUp="limitText(document.form1.DestAddr3,document.form1.countdownTI3,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI3" size="3" value="500"> characters left</font>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 3)</font></td>
		<td width="65%">
			<select name="DepDte3" id="DepDte3" size="1" class="smalllink" onchange="DateChange('3','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth3" id="DepMth3" size="1" class="smalllink" onchange="DateChange('3','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr3" id="DepYr3" size="1" class="smalllink" onchange="DateChange('3','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
	<tr>
		<td width="35%" valign="top" colspan="1">
		&nbsp;&nbsp;&nbsp;Travelling to another <br>&nbsp;&nbsp;&nbsp;country/city:
		</td>
		<td width="65%">

			<input type="radio" name="TI3" value="Y" id="TI3"  onClick="OpenCloseMoreTravel('TI3','Y')"> Yes
			<input type="radio" name="TI3" value="N" id="TI3" checked  onClick="OpenCloseMoreTravel('TI3','N')"> No
		</td>
	</tr>
	
	</table>

    <!---------Travel Information 4---------->
	<table class=SectionDetail id="OpenCloseTI4" style="display:none;"  width="100%" cellpadding="2" border="0">
<tr>
		<td width="35%" colspan="1"><font color="red"  id="DepartureStar3" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 3 <span id="ifAvailable3"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte3" id="RetDte3" size="1" class="smalllink" onchange="DateChange('3','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth3" id="RetMth3" size="1" class="smalllink" onchange="DateChange('3','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr3" id="RetYr3" size="1" class="smalllink" onchange="DateChange('3','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>


	<tr>
		<td width="35%" valign="top" colspan="1">
		</td>
		<td width="65%">
		&nbsp;
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="2"><u><b>Country/City 4</b></u></td>
	</tr>

<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure Country:</b></td>
		<td width="65%">
		<SELECT NAME="DeptCountryCd4" ID="DeptCountryCd4" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure City:</b></td>

		<td width="65%"><input type="Text" name="DeptCity4" id="DeptCity4" size="30" maxlength="30"></td>
	
	</tr>
	<tr>
		<td width="35%" colspan="1">&nbsp;Flight Number:<font style="font-weight:normal;">&nbsp;&nbsp;(if available)</font></td>

		<td width="65%"><input type="Text" name="DeptFlightNo4" id="DeptFlightNo4" size="30" maxlength="30"></td>
	
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Country:</b></td>
		<td width="65%">
		<SELECT NAME="DestCountryCd4" ID="DestCountryCd4">
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination City:</b></td>
		<td width="65%"><input type="Text" name="DestCity4" id="DestCity4" size="30" maxlength="30"></td>
	</tr>
	<tr >
		<td width="35%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Address:</b></td>
		<td width="65%">
			<textarea cols="39" rows="4" name="DestAddr4" id="DestAddr4" maxlength="500" onKeyDown="limitText(document.form1.DestAddr4,document.form1.countdownTI4,500);" onKeyUp="limitText(document.form1.DestAddr4,document.form1.countdownTI4,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI4" size="3" value="500"> characters left</font>
		</td>
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 4)</font></td>
		<td width="65%">
			<select name="DepDte4" id="DepDte4" size="1" class="smalllink" onchange="DateChange('4','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth4" id="DepMth4" size="1" class="smalllink" onchange="DateChange('4','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr4" id="DepYr4" size="1" class="smalllink" onchange="DateChange('4','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
	<tr>
		<td width="35%" valign="top" colspan="1">
		&nbsp;&nbsp;&nbsp;Travelling to another <br>&nbsp;&nbsp;&nbsp;country/city:
		</td>
		<td width="65%">
			<input type="radio" name="TI4" value="Y" id="TI4"  onClick="OpenCloseMoreTravel('TI4','Y')"> Yes
			<input type="radio" name="TI4" value="N" id="TI4" checked  onClick="OpenCloseMoreTravel('TI4','N')"> No
		</td>
	</tr>

	</table>


    <!---------Travel Information 5---------->
	<table class=SectionDetail id="OpenCloseTI5" style="display:none;" width="100%" cellpadding="2" border="0">
	<tr>
		<td width="35%" colspan="1"><font color="red" id="DepartureStar4" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 4 <span id="ifAvailable4"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte4" id="RetDte4" size="1" class="smalllink" onchange="DateChange('4','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth4" id="RetMth4" size="1" class="smalllink" onchange="DateChange('4','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr4" id="RetYr4" size="1" class="smalllink" onchange="DateChange('4','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>

	<tr>
		<td width="35%" valign="top" colspan="1">
		</td>
		<td width="65%">
		&nbsp;
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="2"><u><b>Country/City 5</b></u></td>
	</tr>


<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure Country:</b></td>
		<td width="65%">
		<SELECT NAME="DeptCountryCd5" ID="DeptCountryCd5" >
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Departure City:</b></td>

		<td width="65%"><input type="Text" name="DeptCity5" id="DeptCity5" size="30" maxlength="30"></td>
	
	</tr>
	<tr>
		<td width="35%" colspan="1">&nbsp;Flight Number:<font style="font-weight:normal;">&nbsp;&nbsp;(if available)</font></td>

		<td width="65%"><input type="Text" name="DeptFlightNo5" id="DeptFlightNo5" size="30" maxlength="30"></td>
	
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Country:</b></td>
		<td width="65%">
		<SELECT NAME="DestCountryCd5" ID="DestCountryCd5">
			<!-- #INCLUDE FILE="Countrylist.inc"  -->
		</SELECT>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Destination City:</b></td>
		<td width="65%"><input type="Text" name="DestCity5" id="DestCity5"  size="30" maxlength="30"></td>
	</tr>
	<tr >
		<td width="35%" valign="top" colspan="1"><font color="red">*</font>&nbsp;<b>Destination Address:</b></td>
		<td width="65%">
			<textarea cols="39" rows="4" name="DestAddr5" id="DestAddr5" maxlength="500" onKeyDown="limitText(document.form1.DestAddr5,document.form1.countdownTI5,500);" onKeyUp="limitText(document.form1.DestAddr5,document.form1.countdownTI5,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI5" size="3" value="500"> characters left</font>
		</td>
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 5)</font></td>
		<td width="65%">
			<select name="DepDte5" id="DepDte5" size="1" class="smalllink" >
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth5" id="DepMth5" size="1" class="smalllink" >
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr5" id="DepYr5" size="1" class="smalllink" >
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>
	<tr>
		<td width="35%" valign="top" colspan="1">
		&nbsp;&nbsp;&nbsp;Travelling to another <br>&nbsp;&nbsp;&nbsp;country/city:
		</td>
		<td width="65%">
			<input type="radio" name="TI5" value="Y" id="TI5"  onClick="document.getElementById('OpenCloseTI6').style.display='block';document.getElementById('DepartureStar5').style.display='';document.getElementById('ifAvailable5').innerHTML='&#41;';"> Yes
			<input type="radio" name="TI5" value="N" id="TI5" checked  onClick="document.getElementById('OpenCloseTI6').style.display='none';document.getElementById('DepartureStar5').style.display='none';document.getElementById('ifAvailable5').innerHTML='<br>&nbsp;&nbsp;if available &#41;';"> No
		</td>
	</tr>
	<tr>
		<td width="35%" valign="top" colspan="1">
		</td>
		<td width="65%">&nbsp;
		</td>
	</tr>

	</table>

	<!---------Travel Information 6---------->
	<table class=SectionDetail id="OpenCloseTI6" style="display:none;" width="100%" cellpadding="2" border="0">
	<tr>
		<td width="35%" colspan="1"><font color="red" id="DepartureStar5">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 5<span id="ifAvailable5">&#41;</span></font></td>
		<td width="65%">
			<select name="RetDte5" id="RetDte5" size="1" class="smalllink" >
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth5" id="RetMth5" size="1" class="smalllink" >
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>" ><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr5" id="RetYr5" size="1" class="smalllink" >
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>" ><%=i%>
				<%i=i+1
					loop%>
			</select>
		</td>
	</tr>

	<tr>
		<td width="35%" valign="top" colspan="1">
			<b>Other Travelling Details:</b><br><br><span style="font-weight:normal">(If you are travelling to more than 5 country/city, please list down the rest of countries, cities and periods of stay.)</span>
		</td>
		<td width="65%">
			<textarea cols="39" rows="8" name="PurposeTxt" maxlength="1000" onKeyDown="limitText(document.form1.PurposeTxt,document.form1.countdownPT,1000);" onKeyUp="limitText(document.form1.PurposeTxt,document.form1.countdownPT,1000);"><%=objRds("OtherTravelDtl")%></textarea>
			<font size="1"><input readonly type="text" name="countdownPT" size="3" value="1000"> characters left</font>
		</td>
	</tr>
	</table>


    <!--------SMU Official Section---------->

 	<br>
    <table border="0"  id="OffDetails1" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td class=SectionHeader width="515"><b>For SMU Official Trip Only</b></td>
	</tr>
	</table>
	<table class=SectionDetail ID="OffDetails2" width="100%" cellpadding="2">
	<tr>
		<td width="35%"><b>Overseas Organisation Name:</b></td>
		<td width="65%"><input type="Text" name="OrgName" value="<%=objRds("OrgNm")%>" size="50" maxlength="50"></td>
	</tr>
	<tr>
		<td width="35%"><b>Org Contact Person:</b></td>
		<td width="65%"><input type="Text" name="OrgContactPerson" value="<%=objRds("OrgContactPers")%>" size="50" maxlength="50"></td>
	</tr>
	<tr>
		<td width="35%"><b>Org Contact Number:</b></td>
		<td width="65%"><input type="Text" name="OrgContact" value="<%=objRds("OrgContactNum")%>" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td width="35%"><b>SMU Contact Person:</b></td>
		<td width="65%"><input type="Text" name="SMUContactName" value="<%=objRds("SMUContact")%>" size="50" maxlength="50"></td>
	</tr>
	</table>
	<!--------END SMU Official Section---------->

	<br>
    <!--------OTHERS Section---------->
    <table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2" class=SectionHeader><b>Others</b></td>
	</tr>
	</table>
	<table class=SectionDetail width="100%" cellpadding="2">
	<tr valign="top">
		<td width="35%"><b>Remarks:</b></br></br>
		</td>
		<td width="65%">
			<textarea cols="39" rows="10" name="OthersRemarks" maxlength="1000" onKeyDown="limitText(document.form1.OthersRemarks,document.form1.countdown3,1000);" onKeyUp="limitText(document.form1.OthersRemarks,document.form1.countdown3,1000);"><%=objRds("Remarks")%></textarea>
			<font size="1"><input readonly type="text" name="countdown3" size="3" value="1000"> characters left</font>
		</td>
	</tr>
	</table>
	<!--------END OTHERS Section---------->

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>

	<!--Agreement -->
	<table border="0" bordercolor=black cellpadding="6" cellspacing="0"  width="100%">
	<tr>
		<td colspan="2" class=SectionHeader><b>Declaration</b></td>
	</tr>
	</table>
	<table class=SectionDetail width="100%" cellpadding="2">
	<tr>
		<td><font color="red">*</font><input type="checkbox" name="chk" >&nbsp;I declare that the information furnished on this form is true and complete to the best of my knowledge.</td>
	</tr>
<%
'	<tr>
'		<td>
'			<ol>
'				<li>It is my own liability, and not SMU's liability, to provide medical coverage for me and/or my family members if I and/or my family contract H1N1 (Human Swine Influenza) from the trip.</li><br><br>
'				<li>To impose a 7-day self-quarantine away from the campus using my annual/no-pay leave.</li><br><br>
'				<li>After the 7-day quarantine period, to produce a medical certificate (at my own expense) to certify that I am H1N1-free.</li>
'			</ol>
'		</td>
'	</tr>
%>
	<tr>
		<td align=center><input type="reset" value="Reset" id=reset1 name=reset1>&nbsp;<input type="submit" name="Updsubmit" value="Submit"></td>
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td><font color="red">*&nbsp;<i>Compulsory Fields</i></font> </td>

		<td align="right"><font color="#000000" face="Tahoma" size="2"><a href="travel_history.asp">Back</a> </font></td>
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>
</td>
</tr>
<%
	end if
	%>
</table>

</body>
<!-- #INCLUDE FILE="footer.asp" -->
<%OBJCONN.CLOSE%>
