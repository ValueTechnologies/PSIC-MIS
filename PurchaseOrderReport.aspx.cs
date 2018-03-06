using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class PurchaseOrderReport : System.Web.UI.Page
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
                string reportPath = Server.MapPath("PurchaseOrderRpt.rdlc");
                DSPOSTableAdapters.usp_PurchaseOrderMainTableAdapter da1 = new DSPOSTableAdapters.usp_PurchaseOrderMainTableAdapter();
                DSPOSTableAdapters.usp_PurchaseOrderSubTableAdapter da2 = new DSPOSTableAdapters.usp_PurchaseOrderSubTableAdapter();

                da1.Fill(ds.usp_PurchaseOrderMain, Convert.ToInt32(ID));
                da2.Fill(ds.usp_PurchaseOrderSub, Convert.ToInt32(ID));

                
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_PurchaseOrderMain"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_PurchaseOrderSub"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }
    }
}