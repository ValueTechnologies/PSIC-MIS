using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class POSInventroyAlertReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ShowReport();
            }
        }


        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();

                DSPOS ds = new DSPOS();
                string reportPath = Server.MapPath("POSInventroyAlertReportRpt.rdlc");
                DSPOSTableAdapters.usp_AlertReportInventoryRptTableAdapter da1 = new DSPOSTableAdapters.usp_AlertReportInventoryRptTableAdapter();

                da1.Fill(ds.usp_AlertReportInventoryRpt, Convert.ToInt32(HttpContext.Current.Session["ShopID"]));

                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_AlertReportInventoryRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }
    }
}