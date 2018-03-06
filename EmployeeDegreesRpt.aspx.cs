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
    public partial class EmployeeDegreesRpt : System.Web.UI.Page
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
                string reportPath = Server.MapPath("EmployeeDegreesRpt.rdlc");
                DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter da1 = new DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter();
                DSHRTableAdapters.usp_EmployeeDegreesTableAdapter da2 = new DSHRTableAdapters.usp_EmployeeDegreesTableAdapter();

                da1.Fill(ds.usp_EmployeeBasicInfoByID, Convert.ToInt32(ID));
                da2.Fill(ds.usp_EmployeeDegrees, Convert.ToInt32(ID));

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

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }
    }
}