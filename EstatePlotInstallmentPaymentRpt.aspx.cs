using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class EstatePlotInstallmentPaymentRpt : System.Web.UI.Page
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
                DSEstateManagement ds = new DSEstateManagement();
                string reportPath = Server.MapPath("EstatePlotInstallmentsPaymentRpt.rdlc");

                DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter da1 = new DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotInstallmentsPaymentRptTableAdapter da2 = new DSEstateManagementTableAdapters.usp_EstatePlotInstallmentsPaymentRptTableAdapter();

                da1.Fill(ds.usp_EstatePlotInfoRpt, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EstatePlotInstallmentsPaymentRpt, Convert.ToInt32(ID));
                

                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotInfoRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_EstatePlotInstallmentsPaymentRpt"]));
                

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception e)
            {

            }
        }

    }
}