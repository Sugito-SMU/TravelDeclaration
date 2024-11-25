<%@ Page Language="C#" %>

<%@ Register TagPrefix="Custom" Namespace="Microsoft.Security.Application" Assembly="HtmlSanitizationLibrary" %>
<script runat="server">

    private DateTime _dateFrom = DateTime.MinValue;
    private DateTime _dateTo = DateTime.MinValue;

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void lbtnSubmit2_OnClick(object sender, EventArgs e)
    {
        if (ValidateDates())
        {
            string query = @"
select [UserAccountID], [declareDte]
into #tempLog
from V_Trace_travel_Report (nolock)
where declareDte >= @DateFrom and declareDte <= @DateTo;

create index IX1 on #tempLog([UserAccountID], [declareDte]);

select [UserAccountID], [UserName], [OrganisationDesc], [NtLoginAccount], [UserType], [Email_Smu], [Contact_Mobile]
into #tempUserAcct
from [V_Trace_UserAccount] (nolock)
where isactive = 'Y';

create index IX1 on #tempUserAcct([USERACCOUNTID]);

select a.[UserName] as [Name], a.[UserType] as [Student/Staff]
, a.[OrganisationDesc] as [School/Office], a.[Contact_Mobile] as [Contact No.], lower(a.[Email_Smu]) as [SMU Email]
, lower(replace(replace(a.[NtLoginAccount], 'smustu\', ''), 'smustf\', '')) as [SMU Network ID]
from #tempUserAcct a
left join #tempLog b
	on b.[UserAccountID] = a.[UserAccountID]
where b.[UserAccountID] is null
order by a.[UserType] asc, a.[UserName] asc;

drop table #tempLog;
drop table #tempUserAcct;
";
            System.Data.SqlClient.SqlParameter[] parameters = new System.Data.SqlClient.SqlParameter[]
                                                            {
                                                                new System.Data.SqlClient.SqlParameter("DateFrom", _dateFrom),
                                                                new System.Data.SqlClient.SqlParameter("DateTo", _dateTo.AddDays(1))
                                                            };
            System.Data.DataSet ds = GetDataSet(query, parameters);
            GenerateDownloadFile(ds, "Travel_Not_Logged_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xls");
        }
    }

    private bool ValidateDates()
    {

        if ((!DateTime.TryParseExact(txtFromDate.Text, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out _dateFrom)) ||
            (!DateTime.TryParseExact(txtToDate.Text, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out _dateTo)) ||
            (_dateFrom > _dateTo))
        {
            lblErrorMsg.Text = "Please enter valid dates";
            lblErrorMsg.Visible = true;
            return false;
        }
        else
        {
            lblErrorMsg.Text = "";
            lblErrorMsg.Visible = false;
            return true;
        }
    }

    private string GetConnectionString()
    {
        System.Text.RegularExpressions.Regex re = new Regex("(?<ConnString>Data Source.*)\"", RegexOptions.IgnoreCase);
        string connStr = null;
        using (System.IO.StreamReader sr = new System.IO.StreamReader("D:\\elmo\\prjtrace.asp"))
        {
            while (!sr.EndOfStream)
            {
                string s = sr.ReadLine();
                if (re.IsMatch(s))
                {
                    System.Text.RegularExpressions.GroupCollection groups = re.Match(s).Groups;
                    if (groups.Count > 0)
                    {
                        connStr = groups["ConnString"].Value;
                    }
                }
            }
            if ((connStr != null) && (!connStr.ToLower().Contains("trustservercertificate")))
            {
                connStr += ";TrustServerCertificate=True;";
            }
        }
        return connStr;
    }

    private System.Data.DataSet GetDataSet(string query, System.Data.SqlClient.SqlParameter[] parameters)
    {
        System.Data.DataSet ds = new System.Data.DataSet();
        using (System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(GetConnectionString()))
        {
            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(query, conn);
            foreach (System.Data.SqlClient.SqlParameter param in parameters)
            {
                cmd.Parameters.Add(param);
            }
            System.Data.SqlClient.SqlDataAdapter da = new System.Data.SqlClient.SqlDataAdapter(cmd);
            da.Fill(ds);
            da.Dispose();
            cmd.Dispose();
        }
        return ds;
    }

    private void GenerateDownloadFile(System.Data.DataSet ds, string fileName)
    {
        NPOI.HSSF.UserModel.HSSFWorkbook workbook = new NPOI.HSSF.UserModel.HSSFWorkbook();
        NPOI.HSSF.UserModel.HSSFSheet sheet = workbook.CreateSheet();
        NPOI.HSSF.UserModel.HSSFRow headerRow = sheet.CreateRow(0);


        NPOI.HSSF.UserModel.HSSFCellStyle cellDateFormat = workbook.CreateCellStyle();
        cellDateFormat.DataFormat = workbook.CreateDataFormat().GetFormat("dd-MMM-yyyy hh:mm:ss");

        NPOI.HSSF.UserModel.HSSFFont boldFont = workbook.CreateFont();
        boldFont.FontHeightInPoints = 10;
        boldFont.FontName = "Arial";
        boldFont.Boldweight = NPOI.HSSF.UserModel.HSSFFont.BOLDWEIGHT_BOLD;
        NPOI.HSSF.UserModel.HSSFCellStyle cellBoldFormat = workbook.CreateCellStyle();
        cellBoldFormat.SetFont(boldFont);

        NPOI.HSSF.UserModel.HSSFFont normalFont = workbook.CreateFont();
        normalFont.FontHeightInPoints = 10;
        normalFont.FontName = "Arial";
        normalFont.Boldweight = NPOI.HSSF.UserModel.HSSFFont.BOLDWEIGHT_NORMAL;
        NPOI.HSSF.UserModel.HSSFCellStyle cellNormalFormat = workbook.CreateCellStyle();
        cellNormalFormat.SetFont(normalFont);

        for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
        {
            sheet.AutoSizeColumn(i);
            NPOI.HSSF.UserModel.HSSFCell cell = headerRow.CreateCell(i);
            cell.SetCellValue(ds.Tables[0].Columns[i].ColumnName);
            cell.CellStyle = cellBoldFormat;
        }

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            int rowIndex = i + 1;
            NPOI.HSSF.UserModel.HSSFRow row = sheet.CreateRow(rowIndex);
            for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
            {
                NPOI.HSSF.UserModel.HSSFCell cell = row.CreateCell(j);
                object value = ds.Tables[0].Rows[i][j];
                if ((value != DBNull.Value) && (value != null))
                {
                    if (value.GetType().ToString().ToLower().Contains("datetime"))
                    {
                        cell.SetCellValue((DateTime)value);
                        cell.CellStyle = cellDateFormat;
                    }
                    else if (value.GetType().ToString().ToLower().Contains("decimal"))
                    {
                        cell.SetCellValue(Convert.ToDouble(value));
                    }
                    else
                    {
                        cell.SetCellValue(Convert.ToString(value));
                    }
                }
            }
        }
        for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
        {
            sheet.AutoSizeColumn(i);
        }

        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        workbook.Write(Response.OutputStream);
        Response.End();
    }
</script>
<html>
<head>
    <link rel="stylesheet" href="../styles/bootstrap.min.css">
    <script src="../scripts/jquery-3.4.1.min.js"></script>
    <script src="../scripts/bootstrap.min.js"></script>
    <title>Travel declaration Report</title>
</head>
<body>
    <div class="container-fluid body-content">
        <div style="background-color: #102b72; padding-left:20px; padding-top:10px; padding-bottom:10px; color:White;">
            <h3>
                Travel declaration Report
            </h3>
        </div>
        <div class="main-content">
            <div class="container-fluid">
                <br />
                <br />
                <form id="form1" runat="server">
                <div class="row" style="margin-left: 30px;">
                    <div class="col-sm-2">
                        From Date
                        <asp:TextBox ID="txtFromDate" runat="server" placeholder="dd/mm/yyyy" class="form-control"
                            Width="120px" MaxLength="10"></asp:TextBox>
                    </div>
                    <div class="col-sm-2">
                        To Date
                        <asp:TextBox ID="txtToDate" runat="server" placeholder="dd/mm/yyyy" class="form-control"
                            Width="120px" MaxLength="10"></asp:TextBox>
                    </div>
                </div>
                <div class="row" style="margin-left: 30px;">
                    <div class="col-sm-12">
                        <asp:Label ID="lblErrorMsg" runat="server" Visible="false" ForeColor="Red" Text=""></asp:Label>
                    </div>
                </div>
                <br />
                <br />
                <h5>
                    <ol style="list-style-type: decimal;">                     
                        <li>Travel declaration Report (on who did not log travel)&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbtnSubmit2" runat="server" Text="Download" OnClick="lbtnSubmit2_OnClick" />
                        </li>
                    </ol>
                </h5>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
