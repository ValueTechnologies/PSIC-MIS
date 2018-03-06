using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSReceipt : System.Web.UI.Page
    {
        static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string GetCategories()
        {
            return Fn.Data2Json(" Select 0 as CategoryID, ' ---All---' as Category union SELECT CategoryID, Category FROM tbl_ProductCategory order by Category");
        }


        [WebMethod]
        public static string GetSubCategories(string CatID)
        {
            return Fn.Data2Json("Select 0 as SubCategoryID, ' ---All---' as SubCategory union SELECT SubCategoryID, SubCategory FROM tbl_ProductSubCategory WHERE CategoryID = " + CatID + " order by SubCategory");
        }

        [WebMethod]
        public static string GetPrice(string Tag)
        {
            return Fn.Data2Json("Select Distinct SUM(tbl_PurchasingDetail.SalesPricePerUnit)/COUNT(tbl_PurchasingDetail.SalesPricePerUnit) AS SalesPricePerUnit, SUM(tbl_Stock.Qty) as Qty From tbl_PurchasingDetail inner join tbl_stock on tbl_PurchasingDetail.PurchasingDetailID = tbl_stock.PurchasingDetailID Where tbl_PurchasingDetail.Tag = '" + Tag + "' AND tbl_Stock.Is_Soled is null");
        }

        [WebMethod]
        public static string SearchProduct(string CatID, string SubCatID, string ProductName, string Tag)
        {
            return Fn.Data2Json("usp_SearchProductByCatSubCatProductName '" + ProductName + "', '" + CatID + "', '" + SubCatID + "', '" + Tag + "','" + Convert.ToInt32(HttpContext.Current.Session["ShopID"]) + "'");
        }

        [WebMethod]
        public static string SearchProductDetail(string ProductId)
        {
            return Fn.Data2Json("SELECT tbl_Stock.StockID, tbl_Stock.Qty, tbl_Stock.Tag, tbl_PurchasingDetail.SalesPricePerUnit, tbl_Product.ProductName, tbl_Product.Features , tbl_Purchasings.PurchasingDate, tbl_PurchasingDetail.PurchasingDetailID FROM tbl_Stock INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_Stock.ProductId inner join tbl_PurchasingDetail on tbl_PurchasingDetail.PurchasingDetailID = tbl_Stock.PurchasingDetailId inner join tbl_Purchasings on tbl_Purchasings.PurchasingID = tbl_PurchasingDetail.PurchaseId where tbl_Stock.ProductId = " + ProductId + " and tbl_Stock.Qty > 0 and tbl_Stock.Qty > 0 and tbl_Stock.ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "' order by tbl_Purchasings.PurchasingDate");
        }

        [WebMethod]
        public static string SearchProductDetail1(string ProductId, string tag)
        {
            return Fn.Data2Json("SELECT tbl_Stock.StockID, tbl_Stock.Qty, tbl_Stock.Tag, tbl_PurchasingDetail.SalesPricePerUnit, tbl_Product.ProductName, tbl_Product.Features , tbl_Purchasings.PurchasingDate, tbl_PurchasingDetail.PurchasingDetailID FROM tbl_Stock INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_Stock.ProductId inner join tbl_PurchasingDetail on tbl_PurchasingDetail.PurchasingDetailID = tbl_Stock.PurchasingDetailId inner join tbl_Purchasings on tbl_Purchasings.PurchasingID = tbl_PurchasingDetail.PurchaseId where (tbl_Stock.ProductId = " + ProductId + " and tbl_stock.Tag = '" + tag + "') and tbl_Stock.Qty > 0 and Is_Soled is null and tbl_Stock.ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "' order by tbl_Purchasings.PurchasingDate");
        }

        [WebMethod]
        public static string SearchProductPriceAndQty(string ProductId)
        {
            return Fn.Data2Json("SELECT  Sum(tbl_Stock.Qty) as Qty, tbl_PurchasingDetail.SalesPricePerUnit FROM tbl_Stock INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_Stock.ProductId inner join tbl_PurchasingDetail on tbl_PurchasingDetail.PurchasingDetailID = tbl_Stock.PurchasingDetailId inner join tbl_Purchasings on tbl_Purchasings.PurchasingID = tbl_PurchasingDetail.PurchaseId where tbl_Stock.ProductId = '"+ ProductId + "' and tbl_Stock.Qty > 0 and tbl_Stock.ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'  and (tbl_Stock.Is_Soled is null) group by tbl_PurchasingDetail.SalesPricePerUnit order by tbl_PurchasingDetail.SalesPricePerUnit");
        }

        [WebMethod]
        public static string SearchProductPriceAndQty1(string ProductId, string Tag)
        {
            return Fn.Data2Json("SELECT  Sum(tbl_Stock.Qty) as Qty, tbl_PurchasingDetail.SalesPricePerUnit FROM tbl_Stock INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_Stock.ProductId inner join tbl_PurchasingDetail on tbl_PurchasingDetail.PurchasingDetailID = tbl_Stock.PurchasingDetailId inner join tbl_Purchasings on tbl_Purchasings.PurchasingID = tbl_PurchasingDetail.PurchaseId where (tbl_Stock.ProductId = '" + ProductId + "' and tbl_stock.Tag = '" + Tag + "') and tbl_Stock.Qty > 0 and tbl_Stock.ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'  and (tbl_Stock.Is_Soled is null) group by tbl_PurchasingDetail.SalesPricePerUnit order by tbl_PurchasingDetail.SalesPricePerUnit");
        }


        [WebMethod]
        public static string SearchLoadTags(string ProductId, string PricePerUnit)
        {
            return Fn.Data2Json("SELECT  tbl_Stock.StockID, tbl_Stock.Tag FROM tbl_Stock INNER JOIN tbl_Product ON tbl_Product.ProductID = tbl_Stock.ProductId inner join tbl_PurchasingDetail on tbl_PurchasingDetail.PurchasingDetailID = tbl_Stock.PurchasingDetailId inner join tbl_Purchasings on tbl_Purchasings.PurchasingID = tbl_PurchasingDetail.PurchaseId where tbl_Stock.ProductId = '"+ ProductId + "' and tbl_Stock.ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "' and tbl_Stock.Qty > 0 and SalesPricePerUnit = '" + PricePerUnit + "' and  tbl_Stock.Is_Soled is null order by tbl_PurchasingDetail.Tag");
        }



        [WebMethod]
        public static string SearchCustomer(string Name, string CellNo)
        {
            return Fn.Data2Json("SELECT   ROW_NUMBER()over(order by Name) Srno,     tbl_Customer.CustomerID, tbl_Customer.Name, tbl_Customer.CellNo, tbl_Customer.Address, CASE WHEN HasMembership = 1 THEN 'Yes' ELSE 'No' END AS Membership, ISNULL(tbl_MembershipDetail.StartingDate, '') as StartingDate , ISNULL(tbl_MembershipDetail.EndingDate, '') as EndingDate, tbl_MembershipDetail.Is_Expire FROM tbl_Customer left outer JOIN tbl_MembershipDetail ON tbl_MembershipDetail.CustomerId = tbl_Customer.CustomerID where name like '%' + '" + Name + "' + '%' and CellNo like '%' + '" + CellNo + "' + '%' and (tbl_MembershipDetail.Is_Expire is null  or tbl_MembershipDetail.Is_Expire <> 1)");
        }


        [WebMethod]
        public static string SaveRecipt(string CustomerID, string SubTotal, string DiscountAmount, string TaxAmount, string GrandTotalAmount, string TotalPayment, string DuePayment, string PaymentType, string PurchasingDate, string Remaks)
        {
            return Fn.ExenID("INSERT INTO tbl_Sales (CustomerID, SubTotal, DiscountAmount, TaxAmount, GrandTotalAmount, TotalPayment, DuePayment, PaymentType, PurchasingDate, Remaks, ShopID, SalesInvoiceNo) Select '" + CustomerID + "','" + SubTotal + "','" + DiscountAmount + "','" + TaxAmount + "','" + GrandTotalAmount + "','" + TotalPayment + "','" + DuePayment + "','" + PaymentType + "', '" + PurchasingDate + "'  ,'" + Remaks + "', '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "', ISNULL(Max(SalesInvoiceNo), 0) + 1  From tbl_Sales ; Select Scope_Identity();");
        }


        [WebMethod]
        public static void SaveReciptDetail(string StockID, string ReciptID, string ProductID, string Qty, string UnitPrice)
        {
            Fn.Exec("usp_SaveReciptDetail '" + StockID + "', '" + ReciptID + "', '" + ProductID + "' , '" + Qty + "' , '" + UnitPrice + "'");
        }

        [WebMethod]
        public static void SaveReceiptDetail(string ReciptID, string ProductID, string Qty, string UnitPrice, string Tag)
        {
            Fn.Exec("usp_SaveReceiptDetail " + ReciptID + ", " + ProductID + ", " + Qty + ", " + UnitPrice + ", " + Tag);
        }

    }
}