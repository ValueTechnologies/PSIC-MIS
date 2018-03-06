using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSStockIn : System.Web.UI.Page
    {
        static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string LoadPONumbers()
        {
            return Fn.Data2Json("Select PONumber from tbl_PurchaseOrder where is_completed is NULL AND ShopID = '" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
        }

        [WebMethod]
        public static string GetPurchaseOrder(string PurchaseOrderNo, string PurchasingDate)
        {
            if (PurchaseOrderNo == "0")
            {
                if (Convert.ToInt32(HttpContext.Current.Session["ShopID"]) == 1)
                {
                    if (PurchasingDate.Trim() == string.Empty)
                    {
                        return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null");
                    }
                    return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and Format(OrderDate, 'dd - MMMM - yyyy') = '" + PurchasingDate + "'");
                }
                if (PurchasingDate.Trim() == string.Empty)
                {
                    return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and ShopID = '" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
                }
                return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and Format(OrderDate, 'dd - MMMM - yyyy') = '" + PurchasingDate + "' AND ShopID = '" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
            }

            if (Convert.ToInt32(HttpContext.Current.Session["ShopID"]) == 1)
            {
                if (PurchasingDate.Trim() == string.Empty)
                {
                    return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and PONumber like '%' + '" + PurchaseOrderNo + "' + '%' ");
                }
                return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and PONumber like '%' + '" + PurchaseOrderNo + "' + '%' and Format(OrderDate, 'dd - MMMM - yyyy') = '" + PurchasingDate + "'");
            }
            if (PurchasingDate.Trim() == string.Empty)
            {
                return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and PONumber like '%' + '" + PurchaseOrderNo + "' + '%' AND ShopID = '" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
            }
            return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_PurchaseOrder.PONumber) as Srno, tbl_PurchaseOrder.PurchaseOrderID, tbl_PurchaseOrder.PONumber, tbl_POSSupplier.Name as SupplierName , tbl_PurchaseOrder.OrderDate, tbl_PurchaseOrder.Remaks from tbl_PurchaseOrder inner join tbl_POSSupplier on tbl_POSSupplier.SupplierID = tbl_PurchaseOrder.SupplierID where tbl_PurchaseOrder.Is_Completed is null and PONumber like '%' + '" + PurchaseOrderNo + "' + '%' and Format(OrderDate, 'dd - MMMM - yyyy') = '" + PurchasingDate + "' AND ShopID = '" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
        }

        [WebMethod]
        public static string GetPurchaseOrderDetail(string PurchaseID)
        {
            return Fn.Data2Json("SELECT tbl_PurchaseOrderDetail.PurchaseOrderDetailID, tbl_PurchaseOrderDetail.ProductId, tbl_Product.ProductName, tbl_PurchaseOrderDetail.Features, tbl_PurchaseOrderDetail.Qty FROM            tbl_PurchaseOrderDetail INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_PurchaseOrderDetail.ProductId where tbl_PurchaseOrderDetail.PurchaseID = " + PurchaseID );
        }

        [WebMethod]
        public static string GetSalesProfitPercent()
        {
            return Fn.Data2Json("SELECT SalesProfitPercent FROM tbl_SalesProfitPercent WHERE ID = 1");
        }


        [WebMethod]
        public static string SavePurchasing(string PurchasingDate, string PurchasingAmount, string PurchaseOrder)
        {
            return Fn.ExenID("INSERT INTO tbl_Purchasings (PurchasingDate, PurchasingTotalAmount, PurchasingBillNo, PurchaseOrderID) Select '" + PurchasingDate + "', '" + PurchasingAmount + "', ISNULL(Max(PurchasingBillNo), 0) + 1, '"+ PurchaseOrder +"'  from tbl_Purchasings; Select SCOPE_IDENTITY();");
        }


        [WebMethod(EnableSession = true)]
        public static string SavePurchasingDetail(string POID, string PurchasingID, string ProductId, string Specification, string Qty, string PPPU, string SPPU)
        {
            return Fn.Exec("usp_StockIn '"+ POID + "',  '"+ PurchasingID + "', '" + ProductId + "', '" + Specification + "', '" + Qty + "', '" + PPPU + "', '" + SPPU + "', '"+ Convert.ToString(HttpContext.Current.Session["ShopID"]) +"' ");
        }

    }
}