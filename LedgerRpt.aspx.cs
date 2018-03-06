using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class LedgerRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ShowReport(Convert.ToString(Request.QueryString["ID"]), Convert.ToString(Request.QueryString["StartDate"]), Convert.ToString(Request.QueryString["EndDate"]));
            }
        }



        private void ShowReport(string ID, string StartingDate, string EndingDate)
        {
            StartingDate = StartingDate.Replace("\"", "");
            EndingDate = EndingDate.Replace("\"", "");
            try
            {


                ReportViewer1.LocalReport.DataSources.Clear();
                DSFinance ds = new DSFinance();
                string reportPath = Server.MapPath("LedgerRpt.rdlc");
                DSFinanceTableAdapters.usp_LedgerRptTableAdapter da = new DSFinanceTableAdapters.usp_LedgerRptTableAdapter();

                da.Fill(ds.usp_LedgerRpt, Convert.ToDateTime(StartingDate), Convert.ToDateTime(EndingDate), Convert.ToInt32(ID));

                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_LedgerRpt"]));
                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }
    }
}