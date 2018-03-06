using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class AlreadyRetiredEmployees : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSHR ds = new DSHR();
                string reportPath = Server.MapPath("AlreadyRetiredEmployeesRpt.rdlc");
                DSHRTableAdapters.usp_AlreadyRetiredEmployeesTableAdapter da1 = new DSHRTableAdapters.usp_AlreadyRetiredEmployeesTableAdapter();

                da1.Fill(ds.usp_AlreadyRetiredEmployees, Convert.ToDateTime(txtDateFrom.Text), Convert.ToDateTime(txtDateTo.Text), Convert.ToInt32(ddlDept.SelectedValue), Convert.ToInt32(ddlDesignation.SelectedValue));

                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_AlreadyRetiredEmployees"]));

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




    }
}