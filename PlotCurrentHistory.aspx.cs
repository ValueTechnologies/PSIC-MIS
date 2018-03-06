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
    public partial class PlotCurrentHistory : System.Web.UI.Page
    {
        private static string ServerPath = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string path;
                path = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase);
                path = path.Substring(6, path.Length - 9);
                ServerPath = "file:///" + path;
                ShowReport(Convert.ToString(Request.QueryString["ID"]));
            }
        }


        private void ShowReport(string ID)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSEstateManagement ds = new DSEstateManagement();
                string reportPath = Server.MapPath("EstatePlotCurruntStatusRpt.rdlc");

                DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter da1 = new DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotOwnerInfoRptTableAdapter da2 = new DSEstateManagementTableAdapters.usp_EstatePlotOwnerInfoRptTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotIndustryInfoRptTableAdapter da3 = new DSEstateManagementTableAdapters.usp_EstatePlotIndustryInfoRptTableAdapter();

                da1.Fill(ds.usp_EstatePlotInfoRpt, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EstatePlotOwnerInfoRpt, Convert.ToInt32(ID));
                da3.Fill(ds.usp_EstatePlotIndustryInfoRpt, Convert.ToInt32(ID));

                
                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "PicPath";
                
                paramLogo.Values.Add(ServerPath);


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotInfoRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_EstatePlotOwnerInfoRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet3", ds.Tables["usp_EstatePlotIndustryInfoRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }




    }
}