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
    public partial class ContractEndingReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSHR ds = new DSHR();
                string reportPath = Server.MapPath("ContractExpiryRpt.rdlc");
                DSHRTableAdapters.usp_ContractExpiryReportTableAdapter da1 = new DSHRTableAdapters.usp_ContractExpiryReportTableAdapter();
                
                da1.Fill(ds.usp_ContractExpiryReport, Convert.ToDateTime(txtDateFrom.Text), Convert.ToDateTime(txtDateTo.Text), Convert.ToInt32(ddlDept.SelectedValue), Convert.ToInt32(ddlDesignation.SelectedValue));
               
                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_ContractExpiryReport"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ShowReport();
        }
    }
}