using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class BalanceSheet : System.Web.UI.Page
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
                string reportPath = Server.MapPath("BalanceSheetRpt.rdlc");
                DSFinanceTableAdapters.usp_BalanceSheetRpt_DebitTableAdapter da = new DSFinanceTableAdapters.usp_BalanceSheetRpt_DebitTableAdapter();
                DSFinanceTableAdapters.usp_BalanceSheetRpt_CreditTableAdapter da1 = new DSFinanceTableAdapters.usp_BalanceSheetRpt_CreditTableAdapter();

                da.Fill(ds.usp_BalanceSheetRpt_Debit, Convert.ToDateTime(txtDateFrom.Text.Trim()), Convert.ToDateTime(txtDateTo.Text.Trim()));
                da1.Fill(ds.usp_BalanceSheetRpt_Credit, Convert.ToDateTime(txtDateFrom.Text.Trim()), Convert.ToDateTime(txtDateTo.Text.Trim()));


                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "ReportDuration";


                paramLogo.Values.Add("From : " + txtDateFrom.Text.Trim() + " To : " + txtDateTo.Text.Trim());


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables["usp_BalanceSheetRpt_Debit"]));
                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet2", ds.Tables["usp_BalanceSheetRpt_Credit"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
            finally
            {
                //DestorayData();
            }
        }





    }
}