using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class SalesReciptRpt : System.Web.UI.Page
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

                DSPOS ds = new DSPOS();
                string reportPath = Server.MapPath("SalesReciptRpt.rdlc");
                DSPOSTableAdapters.usp_SalesReciptCustomerRptTableAdapter da1 = new DSPOSTableAdapters.usp_SalesReciptCustomerRptTableAdapter();
                DSPOSTableAdapters.usp_SalesReciptDetailRptTableAdapter da2 = new DSPOSTableAdapters.usp_SalesReciptDetailRptTableAdapter();

                da1.Fill(ds.usp_SalesReciptCustomerRpt, Convert.ToInt32(ID));
                da2.Fill(ds.usp_SalesReciptDetailRpt, Convert.ToInt32(ID));
                
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_SalesReciptCustomerRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_SalesReciptDetailRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }



    }
}