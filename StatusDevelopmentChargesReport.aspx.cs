using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class StatusDevelopmentChargesReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {



            }
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            ShowReport(Convert.ToString(Request.QueryString["ID"]));
        }



        private void ShowReport(string ID)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSEstateManagement ds = new DSEstateManagement();
                string reportPath = Server.MapPath("StatusDevelopmentChargesRpt.rdlc");
                DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter da1 = new DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotChargesRptTableAdapter da2 = new DSEstateManagementTableAdapters.usp_EstatePlotChargesRptTableAdapter();


                da1.Fill(ds.usp_EstatePlotInfoRpt, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EstatePlotChargesRpt, Convert.ToInt32(ID), Convert.ToDateTime(txtFromDate.Text.Trim()), Convert.ToDateTime(txtToDate.Text.Trim()));
                
                ReportParameter BetweenDates = new ReportParameter();
                BetweenDates.Name = "BetweenDates";
                BetweenDates.Values.Add("From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim());


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(BetweenDates);

                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotInfoRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet2", ds.Tables["usp_EstatePlotChargesRpt"]));


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