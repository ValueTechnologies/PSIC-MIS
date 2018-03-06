using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class TrialBalance : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }



        //private void ShowReport()
        //{
        //    try
        //    {

        //        ReportViewer1.LocalReport.DataSources.Clear();
        //        DSFinance ds = new DSFinance();
        //        string reportPath = Server.MapPath("TestTrialBalance.rdlc");
        //        //string reportPath = Server.MapPath("TrialBalance.rdlc");
        //        DSFinanceTableAdapters.usp_TrialBalanceTableAdapter da = new DSFinanceTableAdapters.usp_TrialBalanceTableAdapter();

        //        da.Fill(ds.usp_TrialBalance);


        //        ReportParameter paramLogo = new ReportParameter();
        //        paramLogo.Name = "ReportDuration";

                
        //        paramLogo.Values.Add("From : " + txtDateFrom.Text.Trim() + " To : " + txtDateTo.Text.Trim());


        //        ReportViewer1.LocalReport.EnableExternalImages = true;
        //        ReportViewer1.LocalReport.ReportPath = reportPath;
        //        ReportViewer1.LocalReport.SetParameters(paramLogo);

        //        ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables["usp_TrialBalance"]));

        //        ReportViewer1.LocalReport.Refresh();
        //    }
        //    catch (Exception)
        //    {

        //    }
        //}

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                MakeReportData();
                Response.Redirect("mytb.aspx?StartDate='" + txtDateFrom.Text.Trim() + "'&EndDate='" + txtDateTo.Text.Trim()+"'");
            }
            catch (Exception)
            {

                throw;
            }
            
        }

        private void MakeReportData()
        {
            Fn.Exec("usp_TrialBalance_Setup '" + txtDateFrom.Text.Trim() + "', '" + txtDateTo.Text.Trim() + "'");
        }

        
    }
}