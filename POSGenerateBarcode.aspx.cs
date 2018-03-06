using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OnBarcode.Barcode;
using System.Web.Services;
using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using Microsoft.Reporting.WebForms;

namespace PSIC
{
    public partial class POSGenerateBarcode : System.Web.UI.Page
    {
        static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string LoadPONumbers()
        {
            return Fn.Data2Json("Select PONumber from tbl_PurchaseOrder where is_completed = 'True'");
        }


        protected void btnSearchPurchaseOrder_Click(object sender, EventArgs e)
        {
            search();
        }


        void search()
        {
            ReportViewer1.LocalReport.DataSources.Clear();
            DSPOS ds = new DSPOS();
            string reportPath = Server.MapPath("BarcodeList.rdlc");
            DSPOSTableAdapters.usp_BarcodeGenerateRptTableAdapter da = new DSPOSTableAdapters.usp_BarcodeGenerateRptTableAdapter();

            var srch = Convert.ToString(txtSearchPurchaseOrderNo.Text.Trim());
            var a = Request.Form["ddlPO"];

            da.Fill(ds.usp_BarcodeGenerateRpt, Convert.ToString(a));

            ReportViewer1.LocalReport.ReportPath = reportPath;



            // create a linear barcode object
            Linear barcode = new Linear();

            // set barcode type to Code 128
            barcode.Type = BarcodeType.CODE128;

            // draw barcodes for each data row
            foreach (DSPOS.usp_BarcodeGenerateRptRow row in ds.Tables["usp_BarcodeGenerateRpt"].Rows)
            {
                // set barcode encoding data value
                barcode.Data = row["tag"].ToString();

                // set drawing barcode image format
                barcode.Format = System.Drawing.Imaging.ImageFormat.Jpeg;

                row.Barcode = barcode.drawBarcodeAsBytes();
            }


            ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSet1", ds.Tables["usp_BarcodeGenerateRpt"]));
            ReportViewer1.LocalReport.Refresh();

            Session["selected_po"] = a;

        }


    }
}