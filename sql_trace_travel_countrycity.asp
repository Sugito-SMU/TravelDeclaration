<%

SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "select * from " & DBOWNER & "v_trace_travel_countryCity where (?<>'' AND TravelID= ?) and (?<>'' AND Seq= ?)" 
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sTravelID", adInteger,adParamInput,,ValidateAndEncodeSQL(sTravelID))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sTravelID2", adInteger,adParamInput,,ValidateAndEncodeSQL(sTravelID))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sSeq", adInteger,adParamInput,,ValidateAndEncodeSQL(sSeq))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sSeq2", adInteger,adParamInput,,ValidateAndEncodeSQL(sSeq))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objTraceTravelCountryCity = CurrCmd.EXECUTE()


SET CurrCmd = SERVER.CREATEOBJECT("ADODB.COMMAND")
SET CurrCmd.ACTIVECONNECTION = OBJCONN
strSQL = "select count(*) as cnt from " & DBOWNER & "v_trace_travel_countryCity where ?<>'' AND TravelID= ?" 
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sTravelID", adInteger,adParamInput,,ValidateAndEncodeSQL(sTravelID))
CurrCmd.PARAMETERS.APPEND CurrCmd.CreateParameter("sTravelID2", adInteger,adParamInput,,ValidateAndEncodeSQL(sTravelID))
CurrCmd.CommandText = strSQL
CurrCmd.CommandType = adCmdText
set objCntTravelPlan = CurrCmd.EXECUTE()


%>