using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class Designations : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        public static string UserID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserID = Session["UserID"].ToString();
            }
            catch (Exception)
            {
                Response.Redirect("~/Login.aspx");
            }
        }


        [WebMethod]
        public static string SaveData(string designation, string detail, string Highermanagement) 
        {
            return Fn.ExenID("INSERT INTO tbl_Designation (Designation, DesignationDetail, HigherManagment) VALUES ('" + designation.Trim() + "', '" + detail.Trim() + "', '" + Highermanagement.Trim() + "'); Select SCOPE_IDENTITY();");
        }



        [WebMethod]
        public static string UpdateData(string designation, string detail, string DesignationID, string Highermanagement)
        {
            return Fn.ExenID("UPDATE tbl_Designation SET   Designation = '" + designation.Trim() + "', DesignationDetail = '" + detail.Trim() + "', HigherManagment = '" + Highermanagement.Trim() + "' WHERE (DesignationID = " + DesignationID + "); Select SCOPE_IDENTITY();");
        }

        [WebMethod]
        public static string AllDesignation() 
        {
            return Fn.Data2Json("SELECT row_number() over(order by Designation) as srno, DesignationID, Designation, DesignationDetail, HigherManagment as HMID, Case when HigherManagment = 1 then 'Yes' else 'No' end HigherManagment FROM tbl_Designation  order by Designation");
        }

        [WebMethod]
        public static string DeleteDesignation(string ID) 
        {
            return Fn.Data2Json("usp_DeleteDesig '" + ID + "'");
        }

    }
}