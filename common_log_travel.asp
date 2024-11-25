<!-- Personal Info -->

	
	<tr>
		<td><font color="red">*</font>&nbsp;<b>Blood Type:</b></td>
		<td>
			<SELECT NAME="BloodType">
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
		<td width="65%"><input type=text name="NOKName" value="" size="50" maxlength="80"></td>
	</tr>
	<tr>
		<td width="35%"><font color="red">*</font>&nbsp;<b>Home Contact No.:</b></td>
		<td width="65%"><input type=text name="NOKHomeNum" value="" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td width="35%"><font color="red">*</font>&nbsp;<b>Mobile Contact No.:</b></td>
		<td width="65%"><input type=text name="NOKMobileNum" value="" size="30" maxlength="30"></td>
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

<input type="hidden" id="UserType" name="UserType" value="<%=UserType%>">
<input type="hidden" id="PurposeOfficialText" name="PurposeOfficialText" value="">
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
		<td width="65%"><textarea cols="39" rows="4" name="OfficialPurpose" id="OfficialPurpose" maxlength="1000"></textarea></td>
	</tr>







































































	<tr valign="top">
		<td width="35%"><font color="red" id="OverseasContact">*&nbsp;</font><b>Contact No. While Travelling:</b></td>
		<td width="65%"><input type=text name="DestContactNum" size="30" maxlength="30"></td>
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

var IsInSingapore='<%=session("IsInSingapore")%>';
if(IsInSingapore=="Y")
{
$("#DeptCountryCd1").val('SGP');
$("#DeptCity1").val('Singapore');
}
else
{
$("#DeptCountryCd1").val('');
$("#DeptCity1").val('');
}

if($('#UserType').val()=="STAFF")
{
$('#StudentDDl').hide();
$('#StaffDDl').show();
}
else
{
$('#StudentDDl').show();
$('#StaffDDl').hide();
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
$("#OffDetails1,#OffDetails2,#OverseasContact,#PurposeOfficial").css("display", "table-row");
$("#OverseasContact").css("display", "inline");
}

}

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
			<textarea cols="39" rows="4" name="DestAddr1" maxlength="500" onKeyDown="limitText(document.form1.DestAddr1,document.form1.countdown1,500);" onKeyUp="limitText(document.form1.DestAddr1,document.form1.countdown1,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdown1" size="3" value="500"> characters left</font>
		</td>
	</tr>
	<tr id="OpenCloseDepDate"></tr>
	<tr id="OpenCloseDepDateee">
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 1)</font></td>
		<td width="65%">
			<select name="DepDte1" size="1" class="smalllink" onchange="DateChange('1','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth1" size="1" class="smalllink" onchange="DateChange('1','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr1" size="1" class="smalllink" onchange="DateChange('1','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
		    <input type="radio" name="TI1" value="Y" onClick="OpenCloseMoreTravel('TI1','Y')"> Yes
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
			<select name="RetDte1" size="1" class="smalllink" onchange="DateChange('1','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth1" size="1" class="smalllink" onchange="DateChange('1','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr1" size="1" class="smalllink" onchange="DateChange('1','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<textarea cols="39" rows="4" name="DestAddr2" maxlength="500" onKeyDown="limitText(document.form1.DestAddr2,document.form1.countdownTI2,500);" onKeyUp="limitText(document.form1.DestAddr2,document.form1.countdownTI2,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI2" size="3" value="500"> characters left</font>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 2)</font></td>
		<td width="65%">
			<select name="DepDte2" size="1" class="smalllink" onchange="DateChange('2','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth2" size="1" class="smalllink" onchange="DateChange('2','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr2" size="1" class="smalllink" onchange="DateChange('2','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<select name="RetDte2" size="1" class="smalllink" onchange="DateChange('2','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth2" size="1" class="smalllink" onchange="DateChange('2','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr2" size="1" class="smalllink" onchange="DateChange('2','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<textarea cols="39" rows="4" name="DestAddr3" maxlength="500" onKeyDown="limitText(document.form1.DestAddr3,document.form1.countdownTI3,500);" onKeyUp="limitText(document.form1.DestAddr3,document.form1.countdownTI3,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI3" size="3" value="500"> characters left</font>
		</td>
	</tr>
	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 3)</font></td>
		<td width="65%">
			<select name="DepDte3" size="1" class="smalllink" onchange="DateChange('3','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth3" size="1" class="smalllink" onchange="DateChange('3','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr3" size="1" class="smalllink" onchange="DateChange('3','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
		<td width="35%" colspan="1"><font color="red" id="DepartureStar3" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red"  style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 3 <span id="ifAvailable3"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte3" size="1" class="smalllink" onchange="DateChange('3','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth3" size="1" class="smalllink" onchange="DateChange('3','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr3" size="1" class="smalllink" onchange="DateChange('3','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<textarea cols="39" rows="4" name="DestAddr4" maxlength="500" onKeyDown="limitText(document.form1.DestAddr4,document.form1.countdownTI4,500);" onKeyUp="limitText(document.form1.DestAddr4,document.form1.countdownTI4,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI4" size="3" value="500"> characters left</font>
		</td>
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 4)</font></td>
		<td width="65%">
			<select name="DepDte4" size="1" class="smalllink" onchange="DateChange('4','Ret','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth4" size="1" class="smalllink" onchange="DateChange('4','Ret','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr4" size="1" class="smalllink" onchange="DateChange('4','Ret','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<select name="RetDte4" size="1" class="smalllink" onchange="DateChange('4','Dep','D')">
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth4" size="1" class="smalllink" onchange="DateChange('4','Dep','M')">
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr4" size="1" class="smalllink" onchange="DateChange('4','Dep','Y')">
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<textarea cols="39" rows="4" name="DestAddr5" maxlength="500" onKeyDown="limitText(document.form1.DestAddr5,document.form1.countdownTI5,500);" onKeyUp="limitText(document.form1.DestAddr5,document.form1.countdownTI5,500);"></textarea>
			<font size="1"><input readonly type="text" name="countdownTI5" size="3" value="500"> characters left</font>
		</td>
	</tr>

	<tr>
		<td width="35%" colspan="1"><font color="red">*</font>&nbsp;<b>Arrival Date:</b><br><font style="font-weight:normal;">&nbsp;&nbsp;(at destination country/city 5)</font></td>
		<td width="65%">
			<select name="DepDte5" size="1" class="smalllink" >
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
			<select name="DepMth5" size="1" class="smalllink" >
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
			</select>
			<select name="DepYr5" size="1" class="smalllink" >
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
		<td width="35%" colspan="1"><font color="red" id="DepartureStar5" style="display:none;">*</font>&nbsp;<b>Departure Date:</b><br><font color="red" style="font-weight:normal;">&nbsp;&nbsp;(from destination country/city 5 <span id="ifAvailable5"><br>&nbsp;&nbsp;if available &#41;</span></font></td>
		<td width="65%">
			<select name="RetDte5" size="1" class="smalllink" >
				<option value="">
				<%i=1
				do while i <= 31%>
					<option value="<%=i%>"><%=i%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetMth5" size="1" class="smalllink" >
				<option value="">
				<%i=1
					do while i <= 12%>
					<option value="<%=i%>"><%=mid(monthname(i),1,3)%>
				<%i=i+1
				loop%>
				</select>
				<select name="RetYr5" size="1" class="smalllink" >
				<option value="">
				<%i=Year(LogDte)
					do while i <= Year(LogDte)+9%>
					<option value="<%=i%>"><%=i%>
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
			<textarea cols="39" rows="8" name="PurposeTxt" maxlength="1000" onKeyDown="limitText(document.form1.PurposeTxt,document.form1.countdownPT,1000);" onKeyUp="limitText(document.form1.PurposeTxt,document.form1.countdownPT,1000);"></textarea>
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
		<td width="65%"><input type="Text" name="OrgName" value="" size="50" maxlength="50"></td>
	</tr>
	<tr>
		<td width="35%"><b>Org Contact Person:</b></td>
		<td width="65%"><input type="Text" name="OrgContactPerson" value="" size="50" maxlength="50"></td>
	</tr>
	<tr>
		<td width="35%"><b>Org Contact Number:</b></td>
		<td width="65%"><input type="Text" name="OrgContact" value="" size="30" maxlength="30"></td>
	</tr>
	<tr>
		<td width="35%"><b>SMU Contact Person:</b></td>
		<td width="65%"><input type="Text" name="SMUContactName" value="" size="50" maxlength="50"></td>
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
			<textarea cols="39" rows="10" name="OthersRemarks" maxlength="1000" onKeyDown="limitText(document.form1.OthersRemarks,document.form1.countdown3,1000);" onKeyUp="limitText(document.form1.OthersRemarks,document.form1.countdown3,1000);"></textarea>
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
	</tr>
	</table>

	<!-- Spacer -->
	<table border="0" bordercolor=black cellpadding="0" cellspacing="0"  width="100%" style="color:black">
	<tr>
		<td>&nbsp;</td>
	</tr>
	</table>