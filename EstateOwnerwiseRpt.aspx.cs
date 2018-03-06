using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;


namespace PSIC
{
    public partial class EstateOwnerwiseRpt : System.Web.UI.Page
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
                string reportPath = Server.MapPath("EstateOwnerwiseDetailRpt.rdlc");

                DSEstateManagementTableAdapters.usp_EstatePlotCandidateByIDTableAdapter da1 = new DSEstateManagementTableAdapters.usp_EstatePlotCandidateByIDTableAdapter();
                DSEstateManagementTableAdapters.usp_EstatePlotOwnerwisePlotInfoRptTableAdapter da2 = new DSEstateManagementTableAdapters.usp_EstatePlotOwnerwisePlotInfoRptTableAdapter();

                da1.Fill(ds.usp_EstatePlotCandidateByID, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EstatePlotOwnerwisePlotInfoRpt, Convert.ToInt32(ID));


                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "PicPath";

                paramLogo.Values.Add(ServerPath);
                
                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotCandidateByID"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_EstatePlotOwnerwisePlotInfoRpt"]));

                ReportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(IndustriesDetailReportHandler);
                
                
                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception e)
            {

            }
        }

        private void IndustriesDetailReportHandler(object sender, SubreportProcessingEventArgs e)
        {
            int PlotOwnerShipID = Convert.ToInt32(e.Parameters["PlotOwnerShipID"].Values[0]);
            
            DSEstateManagement ds = new DSEstateManagement();

            DSEstateManagementTableAdapters.usp_EstatePlotOwnerwiseIndustiesInfoRptTableAdapter da = new DSEstateManagementTableAdapters.usp_EstatePlotOwnerwiseIndustiesInfoRptTableAdapter();
            da.Fill(ds.usp_EstatePlotOwnerwiseIndustiesInfoRpt, PlotOwnerShipID);
            
            ReportDataSource dsRpt = new ReportDataSource("DataSet1", ds.Tables["usp_EstatePlotOwnerwiseIndustiesInfoRpt"]);
            e.DataSources.Add(dsRpt);
        }



        


        
    }
}