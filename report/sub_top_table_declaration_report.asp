
<table style="table-layout:fixed" border="1" bordercolor="black" align="center" cellpadding="2" cellspacing="1" bgcolor="#000000" width="8000">
<tr valign="top" align="left">
	<td width="1" class="TemperatureHistoryTitle"><b><font color="#000000">No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Name</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Student/Staff</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">NRIC/FIN/Passport&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">School/Office</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Personal&nbsp;Email&nbsp;Accoun</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Home&nbsp;Address</font></b></td>
	<td width="5" class="TemperatureHistoryTitle"><b><font color="#000000">Home&nbsp;Country</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Blood&nbsp;Type</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Name&nbsp;of&nbsp;NOK</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">NOK&nbsp;Home&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">NOK&nbsp;Mobile&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Reason&nbsp;for&nbsp;Travel</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Travel&nbsp;Country</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Travel&nbsp;City</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Overseas&nbsp;Address</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Contact&nbsp No.&nbsp;While&nbsp;Travelling</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Period&nbsp;of&nbsp;Travel</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Other&nbsp;Travelling&nbsp;Details</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Organization&nbsp;Name</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Organization&nbsp;Contact&nbsp;Person</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Organization&nbsp;Contact&nbsp;No.</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">SMU&nbsp;Contact&nbsp;Person</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Remarks</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Declaration/Creation&nbsp;Date&nbsp;&&nbsp;Time</font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Created&nbsp;By</font></b></td>
         <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Reason&nbsp;for&nbsp;Offial&nbsp;Travel</font></b></td>
<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">IsInSG</font></b></td>
<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">IsValid</font></b></td>
<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">OtherTravelDtl</font></b></td>
<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">ModifiedBy</font></b></td>    
        <td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">HasTravelPlan</font></b></td>

	<% for i=1 to CONSTANT_Max_Multiple_CountryCity %>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;Country&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;City&nbsp;<%=i%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Flight&nbsp;Number&nbsp;<%=i%></font></b></td>

	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;Country&nbsp;<%=ValidateXSSHTML(i)%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;City&nbsp;<%=ValidateXSSHTML(i)%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Destination&nbsp;Address&nbsp;<%=ValidateXSSHTML(i)%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Arrival&nbsp;Date&nbsp;<%=ValidateXSSHTML(i)%></font></b></td>
	<td width="10" class="TemperatureHistoryTitle"><b><font color="#000000">Departure&nbsp;Date&nbsp;<%=ValidateXSSHTML(i)%></font></b></td>
	<% next %>
</tr>
