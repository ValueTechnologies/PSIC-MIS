using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class SalesReportDateWiseRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            ShowReport();
        }


        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSPOS ds = new DSPOS();
                string reportPath = Server.MapPath("SalesReportDateWiseRpt.rdlc");
                DSPOSTableAdapters.usp_SalesReportDateWiseRptTableAdapter da = new DSPOSTableAdapters.usp_SalesReportDateWiseRptTableAdapter();
                
                DateTime fromDate, toDate;

                if (String.IsNullOrEmpty(txtFromDate.Text))
                    fromDate = Convert.ToDateTime("1/1/1753");
                else fromDate = Convert.ToDateTime(txtFromDate.Text);

                if (String.IsNullOrEmpty(txtToDate.Text))
                    toDate = DateTime.Now;
                else toDate = Convert.ToDateTime(txtToDate.Text);

                da.Fill(ds.usp_SalesReportDateWiseRpt, fromDate, toDate, Convert.ToInt32(HttpContext.Current.Session["ShopID"]));

                
                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "DateOfReport";

                if (!String.IsNullOrEmpty(txtFromDate.Text) && !String.IsNullOrEmpty(txtToDate.Text))
                    paramLogo.Values.Add("From : " + txtFromDate.Text + " To : " +  txtToDate.Text);
                else if (!String.IsNullOrEmpty(txtFromDate.Text))
                    paramLogo.Values.Add("From : " + txtFromDate.Text);
                else if (!String.IsNullOrEmpty(txtToDate.Text))
                    paramLogo.Values.Add("To : " + txtToDate.Text);
                else
                    paramLogo.Values.Add(" All Data ");

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