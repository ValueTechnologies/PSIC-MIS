using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class POSDayBook : System.Web.UI.Page
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
                string reportPath = Server.MapPath("SalesReportDateWiseRpt.rdlc");
                DSPOSTableAdapters.usp_SalesReportDateWiseRptTableAdapter da = new DSPOSTableAdapters.usp_SalesReportDateWiseRptTableAdapter();
                var date = DateTime.Now;

                da.Fill(ds.usp_SalesReportDateWiseRpt, date, date, Convert.ToInt32(HttpContext.Current.Session["ShopID"]));

                
                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "DateOfReport";
               
                paramLogo.Values.Add("Date : " + date.ToShortDateString());

                
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_SalesReportDateWiseRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception ex)
            {
                var a = ex.Message;
            }
        }

    }
}