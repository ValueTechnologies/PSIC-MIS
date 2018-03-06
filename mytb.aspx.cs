using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class mytb : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ShowReport(Convert.ToString(Request.QueryString["StartDate"]), Convert.ToString(Request.QueryString["EndDate"]));
            }

        }






        private void ShowReport(string StartDate, string EndDate)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSFinance ds = new DSFinance();
                string reportPath = Server.MapPath("TrialBalance.rdlc");
                DSFinanceTableAdapters.usp_TrialBalanceTableAdapter da = new DSFinanceTableAdapters.usp_TrialBalanceTableAdapter();

                da.Fill(ds.usp_TrialBalance);


                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "ReportDuration";


                paramLogo.Values.Add("From : " + StartDate.Replace("'", "") + " To : " + EndDate.Replace("'", ""));


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables["usp_TrialBalance"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
            finally
            {
                Destroy();
            }
        }




        private void Destroy()
        {
            MyClass fn = new MyClass();
            fn.Exec("usp_TrialBalance_Finish");
        }
    }
}