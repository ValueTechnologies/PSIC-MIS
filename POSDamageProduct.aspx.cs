using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSDamageProduct : System.Web.UI.Page
    {
        static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SaveDamageProduct(string Date, string Note)
        {
            return Fn.ExenID("INSERT INTO tbl_DamageProduct (DamageDate, Note, ShopID) VALUES ('" + Date + "','" + Note + "', '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'); Select Scope_Identity();");
        }



        [WebMethod]
        public static void SaveDamageDetail(string StockID, string DamageID, string ProductID, string Qty, string UnitPrice)
        {
            Fn.Exec("usp_SaveDamageDetail '" + StockID + "', '" + DamageID + "', '" + ProductID + "' , '" + Qty + "' , '" + UnitPrice + "'");
        }


    }
}