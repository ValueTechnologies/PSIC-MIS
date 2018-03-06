using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSProductRegistration : System.Web.UI.Page
    {
        private static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SaveProduct(string PID, string SubCateID, string ProductName, string Features, string MinimumInventory)
        {
            try
            {
                if (PID == "0")
                {
                    Fn.Exec("INSERT INTO tbl_Product (ProductName, SubCategoryID, Features, MinimumInventory, ShopID) VALUES ('" + ProductName + "', '" + SubCateID + "','" + Features + "' ,'" + MinimumInventory + "', '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "');");
                    return "Save Successfully!";
                }
                else
                {
                    Fn.Exec("UPDATE tbl_Product SET ProductName = '" + ProductName + "', SubCategoryID = '" + SubCateID + "', Features = '" + Features + "', MinimumInventory = '" + MinimumInventory + "', ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "' where  ProductID = " + PID);
                    return "Updated Successfully!";
                }
                
            }
            catch (Exception ex)
            {
                return ex.Message;
            }        
            
        }

        [WebMethod]
        public static string GetProducts(string SubCatID)
        {
            try
            {
                return Fn.Data2Json("select ROW_NUMBER() over(order by ProductName) as Srno, ProductID,  ProductName, Features, MinimumInventory  from tbl_Product where SubCategoryID = '" + SubCatID + "' AND ShopID = '" + Convert.ToString(HttpContext.Current.Session["ShopID"]) + "'");
            }
            catch (Exception)
            {
                return string.Empty;
            }
            
        }



    }
}