using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class StockRegisterRpt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlSubCategory.DataBind();
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            ShowReport();
        }


        private void ShowReport()
        {
            try
            {

                ReportViewer1.LocalReport.DataSources.Clear();
                DSPOS ds = new DSPOS();
                string reportPath = Server.MapPath("StockRegisterRpt.rdlc");
                DSPOSTableAdapters.usp_StockRegisterCatwiseRptTableAdapter da = new DSPOSTableAdapters.usp_StockRegisterCatwiseRptTableAdapter();

                DateTime fromDate, toDate;

                if (String.IsNullOrEmpty(txtFromDate.Text))
                    fromDate = Convert.ToDateTime("1/1/1753");
                else fromDate = Convert.ToDateTime(txtFromDate.Text);

                if (String.IsNullOrEmpty(txtToDate.Text))
                    toDate = DateTime.Now;
                else toDate = Convert.ToDateTime(txtToDate.Text);

                da.Fill(ds.usp_StockRegisterCatwiseRpt, Convert.ToInt32(ddlCategory.SelectedValue), Convert.ToInt32(ddlSubCategory.SelectedValue), txtSearchName.Text.Trim(), Convert.ToInt32(HttpContext.Current.Session["ShopID"]), Convert.ToInt32(ddlSold.SelectedValue), fromDate, toDate);
                
                ReportViewer1.LocalReport.ReportPath = reportPath;

                ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_StockRegisterCatwiseRpt"]));

                ReportViewer1.LocalReport.Refresh();
            }
            catch (Exception)
            {

            }
        }




    }
}