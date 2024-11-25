	<%

		count=count+1	
			
		strContact = ""
		if UCASE(objRds("usertype")) = "STAFF" then
			strContact = objRds("contact_office")
		elseif UCASE(objRds("usertype")) = "STUDENT" then
			strContact = objRds("contact_mobile")
		end if
				
	%>	
<tr valign="top" align="left">
		<td width="3%"<%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(count)%></td>	
		<td width="47%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("username"))%></td>
		<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("usertype"))%></td>
		<td width="30%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("organisationdesc"))%></td>
		<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%> style="mso-number-format:\@"><%=ValidateAndEncodeXSSEx(strContact)%></td>
		<td width="10%" <%=ValidateAndEncodeXSSEx(myclass)%>><%=ValidateAndEncodeXSSEx(objRds("email_smu"))%></td>			
 </tr>	
