using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class GPFAllEmployeesDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ddlYearFrom.DataBind();
                txtYearTo.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
            }
        }

        protected void ddlYearFrom_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtYearTo.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
        }



        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSGPF ds = new DSGPF();
                string reportPath = Server.MapPath("GPFAllEmployoeesYearlyRpt.rdlc");

                DSGPFTableAdapters.usp_GPFPerYearRptTableAdapter da1 = new DSGPFTableAdapters.usp_GPFPerYearRptTableAdapter();



                da1.Fill(ds.usp_GPFPerYearRpt, Convert.ToInt32(ddlDept.SelectedValue), Convert.ToInt32(ddlDesignation.SelectedValue), Convert.ToString(ddlYearFrom.SelectedValue), Convert.ToString(txtYearTo.Text) );

               
                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_GPFPerYearRpt"]));

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