using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class ProductCategory : System.Web.UI.Page
    {
        public static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SaveCategory(string Category)
        {
            return Fn.Exec("INSERT INTO tbl_ProductCategory (Category) VALUES ('" + Category + "')");
        }

        [WebMethod]
        public static string UpdateCategory(string Category, string CategoryID)
        {
            return Fn.Exec("UPDATE tbl_ProductCategory SET Category = '" + Category + "' WHERE CategoryID = " + CategoryID);
        }

        [WebMethod]
        public static string GetCategories()
        {
            return Fn.Data2Json("SELECT  ROW_NUMBER() over(order by Category) as Srno,   CategoryID, Category FROM tbl_ProductCategory ");
        }



        [WebMethod]
        public static string SaveSubCategory(string CategoryID, string SubCategory)
        {
            return Fn.Exec("INSERT INTO tbl_ProductSubCategory (CategoryID, SubCategory) VALUES ('"+ CategoryID + "', '"+ SubCategory + "')");
        }

        [WebMethod]
        public static string UpdateSubCategory(string CategoryID, string SubCategory, string SubCategoryID)
        {
            return Fn.Exec("UPDATE tbl_ProductSubCategory SET CategoryID = '" + CategoryID + "', SubCategory = '" + SubCategory + "' where SubCategoryID = " + SubCategoryID);
        }

        [WebMethod]
        public static string GetSubCategories(string CatID)
        {
            return Fn.Data2Json("SELECT ROW_NUMBER() over(order by SubCategory) as Srno, SubCategoryID,  SubCategory FROM tbl_ProductSubCategory where CategoryID = " + CatID);
        }






    }
}