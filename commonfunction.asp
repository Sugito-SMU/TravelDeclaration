<%

CONSTANT_TRAVEL_DECLARE_PERIOD = "3 Nov 2015 to 4 Jan 2016"
CONSTANT_HIGHEST_TEMP=37.5 'Changed from 37.6 to 38.1 on 15 Mar 2012 ,Changed from 38.0 to 37.5 on 27 May 2020
CONSTANT_Max_Multiple_CountryCity=5
CONSTANT_Affected_Country="'Mexico','United States of America','Canada','Chile','Japan','Australia','United Kingdom','Argentina','Panama','Philippines','Thailand','Dominican Republic','Hong Kong','Indonesia','Spain','New Zealand'"




Function GetFormattedDate(iDate)	
  strDate = CDate(iDate)  
  strDay = DatePart("d", strDate)
  strMonth = DatePart("m", strDate)
  strYear = DatePart("yyyy", strDate)
  If strDay < 10 Then
    strDay = "0" & strDay
  End If
  If strMonth < 10 Then
    strMonth = "0" & strMonth
  End If  
  GetFormattedDate = strYear & "-" & strMonth & "-" & strDay
End Function

Function ReplaceSpecialCharactersEncode(InputString)
dim ReplacedString
    ReplacedString = InputString
    if (not IsNull(ReplacedString)) then
        ReplacedString = replace(ReplacedString,"+","^$")
		ReplacedString = replace(ReplacedString,"-","%*")
	else
	ReplacedString = ""
    end if
    ReplaceSpecialCharactersEncode = ReplacedString
End Function

Function ReplaceSpecialCharactersDecode(InputString)
dim ReplacedString
    ReplacedString = InputString
    if (not IsNull(ReplacedString)) then
        ReplacedString = replace(ReplacedString,"^$","+")
		ReplacedString = replace(ReplacedString,"%*","-")
	else
	ReplacedString = ""
    end if
    ReplaceSpecialCharactersDecode = ReplacedString
End Function


function ValidateXSSHTML(inputHtml)
dim outputHTML
    set sanitizer = Server.CreateObject("AntiXSSSanitizer.HTMLSanitizer")
    if (not IsNull(inputHtml)) then
        outputHTML = sanitizer.GetSafeHtmlFragmentV3(inputHtml)
        outputHTML = replace(outputHTML, "<html>", "")
        outputHTML = replace(outputHTML, "</html>", "")
        outputHTML = replace(outputHTML, "<body>", "")
        outputHTML = replace(outputHTML, "</body>", "")
    else
        outputHTML = ""
    end if
    ValidateXSSHTML = outputHTML
end function


Function InsertStringAtInterval(rsSource, rsInsert, rlInterval)
	Dim rgx
	Set rgx = new RegExp
	rgx.Pattern = "([\s\S]{" & rlInterval & "})"
	rgx.Global = true
	InsertStringAtInterval = rgx.Replace(rsSource, "$1" & rsInsert)
End Function

function Insert_Travel_Trace_CountryCity(sTravelID,sSeq,sCountry,sCity,sDestAddress,sDepDate,sArrDate,DepCountry,DepCity,FlightNo)

		SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
  		CurrCmd.COMMANDTEXT = "[dbo].[CSP_INSERT_TRACE_TRAVEL_CountryCity]"
  		SET CurrCmd.ACTIVECONNECTION = OBJCONN
			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("TravelID", adInteger, adParamInput,10,sTravelID)
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Seq", adInteger, adParamInput,10, sSeq)
			
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Country", adVarWChar, adParamInput,3,ValidateAndEncodeSQL(sCountry))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("City", adVarWChar, adParamInput,100,ValidateAndEncodeSQL(sCity))
			'not used
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DestAddress", adVarWChar, adParamInput,660, ValidateAndEncodeSQL(sDestAddress))

					
					
			

			if (ReturnDte="" or IsNull(ReturnDte)) then
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepDate", adVarchar, adParamInput,20, Null)

			else
				CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepDate", adVarchar, adParamInput,20, ValidateAndEncodeSQL(ReturnDte))

			end if
			'Response.end


			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("ArrDate", adVarchar, adParamInput,20, ValidateAndEncodeSQL(DepartDte))


			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepCountry", adVarWChar, adParamInput,3,ValidateAndEncodeSQL(DepCountry))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("DepCity", adVarWChar, adParamInput,100,ValidateAndEncodeSQL(DepCity))
			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("FlightNo", adVarWChar, adParamInput,30,ValidateAndEncodeSQL(FlightNo))

			CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("Rescsp", adBigInt, adParamOutput)
					
			CurrCmd.EXECUTE ,,adCmdStoredProc
	
			sErrorCode =CLNG(CurrCmd.Parameters("Rescsp").value) '0 means not ok
			
		   Insert_Travel_Trace_CountryCity=sErrorCode
	'sql="Insert into "+  DBOWNER +"Travel_Trace_CountryCity "
	'sql= sql & "(" & sTravelID & "," & sSeq & "," & sCountry & "," & sCity & "," & sDestAddress & "," & sDepDate & "," & sArrDate & ")"

end function


Function getCountrySQLMultipleCountry()
  sql=" countryName in (" & CONSTANT_Affected_Country & ") "
	'sql= sql & " or ( "
	'sql= sql & " DestCity like '%United States of America%' or "
	'sql= sql & " DestCity like '%Mexico%' or "
	'sql= sql & " DestCity like '%Canada%' or "
	'sql= sql & " DestCity like '% US %' or " 
	'sql= sql & " DestCity like '% US.%' or "  
	'sql= sql & " DestCity like '% US,%' or "
	'sql= sql & " DestCity like '% USA %' or "
	'sql= sql & " DestCity like '% USA.%' or "
	'sql= sql & " DestCity like '%United States%' or  "
	'sql= sql & " DestCity like '%America%' or  "
	'sql= sql & " DestCity like '% USA,%' "
	'sql= sql & " DestCity like '% Chile%' "
	
	'new affected areas with effective 3 June 09
	sql= sql & " or (countryName = 'Japan' and (City like '%Osaka%' or DestAddress like '%Osaka%')) "
	sql= sql & " or (countryName = 'Japan' and (City like '%Kobe%' or DestAddress like '%Kobe%')) "
	sql= sql & " or (countryName = 'Australia' and (City like '%Melbourne%' or DestAddress like '%Melbourne%')) "
	sql= sql & " or (countryName = 'Australia' and (DestAddress like '%Victoria%')) "
	'sql= sql & " ) "
	
	getCountrySQLMultipleCountry=sql
	'sql= sql & " ) "
end function

Function getCountrySQL()

	'sql=" and (country in ('Mexico','United States of America','Canada') "
	sql=" country in (" & CONSTANT_Affected_Country & ") "
	sql= sql & " or ( "
	sql= sql & " Purposetxt like '%United States of America%' or "
	sql= sql & " Purposetxt like '%Mexico%' or "
	sql= sql & " Purposetxt like '%Canada%' or "
	sql= sql & " Purposetxt like '% US %' or " 
	sql= sql & " Purposetxt like '% US.%' or "  
	sql= sql & " Purposetxt like '% US,%' or "
	sql= sql & " Purposetxt like '% USA %' or "
	sql= sql & " Purposetxt like '% USA.%' or "
	sql= sql & " Purposetxt like '%United States%' or  "
	sql= sql & " Purposetxt like '%America%' or  "
	sql= sql & " Purposetxt like '% USA,%' or "
	sql= sql & " Purposetxt like '%Japan%' or "
	sql= sql & " Purposetxt like '%Kobe%' or "
	sql= sql & " Purposetxt like '%Osaka%' or "
	sql= sql & " Purposetxt like '%Australia%' or "
	sql= sql & " Purposetxt like '%Melbourne%' or "
	sql= sql & " Purposetxt like '%Victoria%' or "
	sql= sql & " Purposetxt like '%United Kingdom%' or "
	sql= sql & " Purposetxt like '%Argentina%' or "
	sql= sql & " Purposetxt like '%Panama%' or "
	sql= sql & " Purposetxt like '%Philippines%' or "
	sql= sql & " Purposetxt like '%Thailand%' or "
	sql= sql & " Purposetxt like '%Dominican Republic%' or "
	sql= sql & " Purposetxt like '%Hong Kong%' or "
	sql= sql & " Purposetxt like '%Indonesia%' or "
	sql= sql & " Purposetxt like '%Spain%' or "
	sql= sql & " Purposetxt like '%New Zealand%' or "
	sql= sql & " Purposetxt like '%NZ%' or "
	sql= sql & " Purposetxt like '%Chile' "
	
	'new affected areas with effective 3 June 09
	sql= sql & " or (country = 'Japan' and (DestCity like '%Osaka%' or DestAddr like '%Osaka%' or Purposetxt like '%Osaka%')) "
	sql= sql & " or (country = 'Japan' and (DestCity like '%Kobe%' or DestAddr like '%Kobe%' or Purposetxt like '%Kobe%')) "
	sql= sql & " or (country = 'Australia' and (DestCity like '%Melbourne%' or DestAddr like '%Melbourne%' or Purposetxt like '%Melbourne%')) "
	sql= sql & " or (country = 'Australia' and (DestAddr like '%Victoria%' or Purposetxt like '%Victoria%')) "
	sql= sql & " ) "
	
	
	
	
	
	'sql= sql & " ) "
  
     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'sql=" and (country = 'Mexico' "
	'sql= sql & " or (country = 'United States of America') "
	'sql= sql & " or (country = 'Canada') "
	'sql= sql & " ) "


    '''''''''''''''''''''''''''''''''''''''''''''
	'sql=" and (country = 'Mexico' "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%NY %' or DestAddr like '% NY %' or Purposetxt like '% NY%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%NY %' or DestAddr like '% NY %' or Purposetxt like '% NY%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%NY %' or DestAddr like '% NY %' or Purposetxt like '% NY%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%New York%' or DestAddr like '%New York%' or Purposetxt like '%New York%')) "

	'sql= sql & " or (country = 'United States of America' and (DestCity like '%CA %' or DestAddr like '% CA %' or Purposetxt like '% CA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%CA %' or DestAddr like '% CA %' or Purposetxt like '% CA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%CA %' or DestAddr like '% CA %' or Purposetxt like '% CA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%California%' or DestAddr like '%California%' or Purposetxt like '%California%')) "

	'sql= sql & " or (country = 'United States of America' and (DestCity like '%LA %' or DestAddr like '% LA %' or Purposetxt like '% LA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%LA %' or DestAddr like '% LA %' or Purposetxt like '% LA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%LA %' or DestAddr like '% LA %' or Purposetxt like '% LA%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%Los Angeles%' or DestAddr like '%Los Angeles%' or Purposetxt like '%Los Angeles%')) "

	'sql= sql & " or (country = 'United States of America' and (DestCity like '%SF %' or DestAddr like '% SF %' or Purposetxt like '% SF%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%SF %' or DestAddr like '% SF %' or Purposetxt like '% SF%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%SF %' or DestAddr like '% SF %' or Purposetxt like '% SF%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%San Francisco%' or DestAddr like '%San Francisco%' or Purposetxt like '%San Francisco%')) "

	'sql= sql & " or (country = 'United States of America' and (DestCity like '%TX %' or DestAddr like '% TX %' or Purposetxt like '% TX%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%TX %' or DestAddr like '% TX %' or Purposetxt like '% TX%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%TX %' or DestAddr like '% TX %' or Purposetxt like '% TX%')) "
	'sql= sql & " or (country = 'United States of America' and (DestCity like '%Texas%' or DestAddr like '%Texas%' or Purposetxt like '%Texas%')) "

	'sql= sql & " or (country = 'Canada' and (DestCity like '%NS %' or DestAddr like '% NS %' or Purposetxt like '% NS%')) "
	'sql= sql & " or (country = 'Canada' and (DestCity like '%NS %' or DestAddr like '% NS %' or Purposetxt like '% NS%')) "
	'sql= sql & " or (country = 'Canada' and (DestCity like '%NS %' or DestAddr like '% NS %' or Purposetxt like '% NS%')) "
	'sql= sql & " or (country = 'Canada' and (DestCity like '%nova scotia%' or DestAddr like '%nova scotia%' or Purposetxt like '%nova scotia%')) "
	'sql= sql & " ) "
	
	 getCountrySQL=sql
	
end function

Function getMonthShortName(monthNum)
if monthNum = "" then
	getMonthShortName= ""
elseif monthNum="01" or monthNum="1" then
	getMonthShortName= "JAN"
elseif monthNum="02" or monthNum="2" then	
	getMonthShortName= "FEB"
elseif monthNum="03" or monthNum="3" then	
	getMonthShortName= "MAR"
elseif monthNum="04" or monthNum="4" then		
	getMonthShortName= "APR"
elseif monthNum="05" or monthNum="5" then		
	getMonthShortName= "MAY"
elseif monthNum="06" or monthNum="6" then		
	getMonthShortName= "JUN"	
elseif monthNum="07" or monthNum="7" then		
	getMonthShortName= "JUL"	
elseif monthNum="08" or monthNum="8" then		
	getMonthShortName= "AUG"	
elseif monthNum="09" or monthNum="9" then		
	getMonthShortName= "SEP"	
elseif monthNum="10" then
	getMonthShortName= "OCT"
elseif monthNum="11" then
	getMonthShortName= "NOV"
elseif monthNum="12" then
	getMonthShortName= "DEC"
else
	getMonthShortName=monthNum
end if		

end function


%>