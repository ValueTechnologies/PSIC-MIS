using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class PensionEmployeeWiseYearlyRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                for (int i = 1947; i < DateTime.Now.Year + 1; i++)
                {
                    ddlYearFrom.Items.Add(Convert.ToString(i));
                }

                ddlYearFrom.SelectedValue = Convert.ToString(DateTime.Now.Year);
                txtToYear.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
            }
        }


        void ChangeYear()
        {
            txtToYear.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
        }

        protected void ddlYearFrom_SelectedIndexChanged(object sender, EventArgs e)
        {
            ChangeYear();
        }



        private void ShowReport(string ID)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSPension ds = new DSPension();
                string reportPath = Server.MapPath("PensionEmployeeWiseYearlyReport.rdlc");
                DSPensionTableAdapters.usp_PensionEmployeeWiseYearlyReportTableAdapter da = new DSPensionTableAdapters.usp_PensionEmployeeWiseYearlyReportTableAdapter();
                DSPensionTableAdapters.usp_PensionEmployeeBasicDataReportTableAdapter da1 = new DSPensionTableAdapters.usp_PensionEmployeeBasicDataReportTableAdapter();

                da.Fill(ds.usp_PensionEmployeeWiseYearlyReport, Convert.ToInt32(ID), Convert.ToInt32(ddlYearFrom.SelectedValue), Convert.ToInt32(txtToYear.Text));
                da1.Fill(ds.usp_PensionEmployeeBasicDataReport, Convert.ToInt32(ID));
                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "Years";
                paramLogo.Values.Add("From " + ddlYearFrom.SelectedValue + " To : "+ txtToYear.Text);


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_PensionEmployeeWiseYearlyReport"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_PensionEmployeeBasicDataReport"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            ShowReport(Convert.ToString(Request.QueryString["ID"]));
        }
    }
}