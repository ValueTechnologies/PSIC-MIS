using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class MostSellingProductRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            if (txtFromDate.Text.Trim() == string.Empty || txtToDate.Text.Trim() == string.Empty)
            {
                return;
            }
            ShowReport();
        }


        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSPOS ds = new DSPOS();
                string reportPath = Server.MapPath("MostSellingProductRpt.rdlc");
                DSPOSTableAdapters.usp_BestSellingProductTableAdapter da = new DSPOSTableAdapters.usp_BestSellingProductTableAdapter();

                da.Fill(ds.usp_BestSellingProduct, Convert.ToDateTime(txtFromDate.Text), Convert.ToDateTime(txtToDate.Text), Convert.ToString(ddlReportType.Text), Convert.ToInt32(HttpContext.Current.Session["ShopID"]));


                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "Dates";

                paramLogo.Values.Add("From : " + txtFromDate.Text + " To : " + txtToDate.Text);

                ReportParameter paramRptType = new ReportParameter();
                paramRptType.Name = "ReportType";

                paramRptType.Values.Add(Convert.ToString(ddlReportType.SelectedItem.Text));


                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);
                ReportViewer1.LocalReport.SetParameters(paramRptType);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_BestSellingProduct"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }




    }
}