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
    public partial class GPFIndividualEmployeeRpt : System.Web.UI.Page
    {
        public static string EmpID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ddlYearFrom.DataBind();
                txtYearTo.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
                EmpID = Convert.ToString(Request.QueryString["ID"]);
                ShowReport();
            }
        }



        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSHR ds = new DSHR();
                DSGPF ds2 = new DSGPF();
                string reportPath = Server.MapPath("GPFIndividualEmployeeDetailRpt.rdlc");
                DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter da1 = new DSHRTableAdapters.usp_EmployeeBasicInfoByIDTableAdapter();

                DSGPFTableAdapters.usp_GPFIndividualDetailRptTableAdapter da2 = new DSGPFTableAdapters.usp_GPFIndividualDetailRptTableAdapter();




                da1.Fill(ds.usp_EmployeeBasicInfoByID, Convert.ToInt32(EmpID));
                da2.Fill(ds2.usp_GPFIndividualDetailRpt, Convert.ToInt32(EmpID), Convert.ToInt32(ddlYearFrom.SelectedValue), Convert.ToInt32(txtYearTo.Text));


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
                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet2", ds2.Tables["usp_GPFIndividualDetailRpt"]));
                
                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ShowReport();
        }

        protected void ddlYearFrom_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtYearTo.Text = Convert.ToString(Convert.ToInt32(ddlYearFrom.SelectedValue) + 1);
        }
    }
}