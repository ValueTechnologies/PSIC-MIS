using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSPurchaseOrder : System.Web.UI.Page
    {
        static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetProducts(string SubCatID, string ProductName)
        {
            try
            {
                return Fn.Data2Json("select ROW_NUMBER() over(order by ProductName) as Srno, ProductID,  ProductName, Features  from tbl_Product where ProductName like '%' + '"+ ProductName + "' + '%' and SubCategoryID = '" + SubCatID + "' and ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'");
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }


        [WebMethod]
        public static string SavePurchaseOrder(string OrderDate, string SupplierID, string Note)
        {
            try
            {

                return Fn.ExenID("Declare @pono as varchar(50);select @pono = Max(cast((ISNULL(REPLACE(PONumber, 'PO-', ''), '0')) as int)) + 1  from tbl_PurchaseOrder; INSERT INTO tbl_PurchaseOrder (PONumber, OrderDate, SupplierID, Remaks, ShopID) VALUES ('PO-' + @pono, '" + OrderDate + "','" + SupplierID + "', '" + Note + "', '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'); Select Scope_Identity();");
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }


        [WebMethod]
        public static string SavePurchaseOrderDetail(string PurchseId, string ProductID, string Features, string Qty)
        {
            try
            {
                return Fn.Exec("INSERT INTO tbl_PurchaseOrderDetail (PurchaseID, ProductId, Qty, Features) VALUES ('"+ PurchseId + "','"+ ProductID + "','"+ Qty + "','"+ Features + "')");
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }


    }
}