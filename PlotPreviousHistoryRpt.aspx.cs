using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class PlotPreviousHistoryRpt : System.Web.UI.Page
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
                string reportPath = Server.MapPath("PlotPreviousHistoryRpt.rdlc");

                DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter da1 = new DSEstateManagementTableAdapters.usp_EstatePlotInfoRptTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotPreviousHistoryIndustryInfoRptTableAdapter da2 = new DSEstateManagementTableAdapters.usp_EstatePlotPreviousHistoryIndustryInfoRptTableAdapter();

                da1.Fill(ds.usp_EstatePlotInfoRpt, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EstatePlotPreviousHistoryIndustryInfoRpt, Convert.ToInt32(ID));


                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "PicPath";

                paramLogo.Values.Add(ServerPath);
                


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotInfoRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_EstatePlotPreviousHistoryIndustryInfoRpt"]));

                ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(OwnerDetailReportHandler);





                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception e)
            {
                
            }
        }

        private void OwnerDetailReportHandler(object sender, SubreportProcessingEventArgs e)
        {
            int PlotOwnerShipID = Convert.ToInt32(e.Parameters["PlotOwnerShipID"].Values[0]);


            DSEstateManagement ds = new DSEstateManagement();

            DSEstateManagementTableAdapters.usp_EstatePlotPreviousHistoryOwnersInfoRptTableAdapter da = new DSEstateManagementTableAdapters.usp_EstatePlotPreviousHistoryOwnersInfoRptTableAdapter();
            da.Fill(ds.usp_EstatePlotPreviousHistoryOwnersInfoRpt, PlotOwnerShipID);



            ReportDataSource dsRpt = new ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotPreviousHistoryOwnersInfoRpt"]);
            e.DataSources.Add(dsRpt);




        }
    }
}