using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class IncomeStatement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ShowReport();
        }



        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSFinance ds = new DSFinance();
                string reportPath = Server.MapPath("IncomeStatementRpt.rdlc");
                DSFinanceTableAdapters.usp_IncomeStatementTableAdapter da = new DSFinanceTableAdapters.usp_IncomeStatementTableAdapter();

                da.Fill(ds.usp_IncomeStatement, Convert.ToDateTime(txtDateFrom.Text.Trim()), Convert.ToDateTime(txtDateTo.Text.Trim()));


                ReportParameter Dates = new ReportParameter();
                Dates.Name = "Dates";


                Dates.Values.Add("From : " + txtDateFrom.Text + " To : " + txtDateTo.Text);


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(Dates);

                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables["usp_IncomeStatement"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
            finally
            {
            }
        }
    }
}