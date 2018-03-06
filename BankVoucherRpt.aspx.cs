using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class BankVoucherRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ShowReport(Convert.ToString(Request.QueryString["ID"]));
            }
        }


        private void ShowReport(string ID)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();

                DSFinance ds = new DSFinance();
                string reportPath = Server.MapPath("BankVoucherRpt.rdlc");
                DSFinanceTableAdapters.usp_JournalVoucherRptTableAdapter da1 = new DSFinanceTableAdapters.usp_JournalVoucherRptTableAdapter();

                da1.Fill(ds.usp_JournalVoucherRpt, Convert.ToInt32(ID));


                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_JournalVoucherRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }



    }
}