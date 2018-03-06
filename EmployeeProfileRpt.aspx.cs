using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class EmployeeProfileRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ShowReport(Convert.ToString(Request.QueryString["ID"]));
            }
        }



        private void ShowReport(string ID)
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSHR ds = new DSHR();
                string reportPath = Server.MapPath("EmployeeProfileRpt.rdlc");
                DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter da1 = new DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter();
                DSHRTableAdapters.usp_EmployeeDegreesTableAdapter da2 = new DSHRTableAdapters.usp_EmployeeDegreesTableAdapter();
                DSHRTableAdapters.usp_EmployeePostingHistoryRptTableAdapter da3 = new DSHRTableAdapters.usp_EmployeePostingHistoryRptTableAdapter();
                DSHRTableAdapters.usp_AwardListRptTableAdapter da4 = new DSHRTableAdapters.usp_AwardListRptTableAdapter();
                DSHRTableAdapters.usp_PromotionHistoryRptTableAdapter da5 = new DSHRTableAdapters.usp_PromotionHistoryRptTableAdapter();
                DSHRTableAdapters.usp_EmployeeInquiryRptTableAdapter da6 = new DSHRTableAdapters.usp_EmployeeInquiryRptTableAdapter();
                DSHRTableAdapters.usp_EmployeeSuspensionRptTableAdapter da7 = new DSHRTableAdapters.usp_EmployeeSuspensionRptTableAdapter();
                DSHRTableAdapters.usp_EmployeeTrainingRptTableAdapter da8 = new DSHRTableAdapters.usp_EmployeeTrainingRptTableAdapter();
                DSHRTableAdapters.usp_EmployeeExpalantionRptTableAdapter da9 = new DSHRTableAdapters.usp_EmployeeExpalantionRptTableAdapter();




                da1.Fill(ds.usp_EmployeeBasicInfoByID, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EmployeeDegrees, Convert.ToInt32(ID));
                da3.Fill(ds.usp_EmployeePostingHistoryRpt, Convert.ToInt32(ID));
                da4.Fill(ds.usp_AwardListRpt, Convert.ToInt32(ID));
                da5.Fill(ds.usp_PromotionHistoryRpt, Convert.ToInt32(ID));
                da6.Fill(ds.usp_EmployeeInquiryRpt, Convert.ToInt32(ID));
                da7.Fill(ds.usp_EmployeeSuspensionRpt, Convert.ToInt32(ID));
                da8.Fill(ds.usp_EmployeeTrainingRpt, Convert.ToInt32(ID));
                da9.Fill(ds.usp_EmployeeExpalantionRpt, Convert.ToInt32(ID));


                DataTable dt = ds.Tables["usp_EmployeeBasicInfoByID"];
                string logoID = Convert.ToString(dt.Rows[0]["User_ID"]);
                string PhotoExtension = Convert.ToString(dt.Rows[0]["PhotoExtension"]);
                ReportParameter paramLogo = new ReportParameter();
                paramLogo.Name = "EmpPicPath";
                string path;
                path = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase);
                path = path.Substring(6, path.Length - 9);
                paramLogo.Values.Add("file:///" + path + @"Uploads\EmployeePhoto\" + logoID + Convert.ToString(PhotoExtension));


                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;
                ReportViewer1.LocalReport.SetParameters(paramLogo);

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_EmployeeBasicInfoByID"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds.Tables["usp_EmployeeDegrees"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet3", ds.Tables["usp_EmployeePostingHistoryRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet4", ds.Tables["usp_AwardListRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet5", ds.Tables["usp_PromotionHistoryRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet6", ds.Tables["usp_EmployeeInquiryRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet7", ds.Tables["usp_EmployeeSuspensionRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet8", ds.Tables["usp_EmployeeTrainingRpt"]));
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet9", ds.Tables["usp_EmployeeExpalantionRpt"]));
                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }
    }
}