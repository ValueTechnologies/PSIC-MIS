using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class ChangePassword : System.Web.UI.Page
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
        public static string LoadMyData() 
        {
            return Fn.Data2Json("SELECT UserName FROM Login where Emp_Id =  " + UserID);
        
        }


        [WebMethod]
        public static string ChangeMyPassword(string OldPassword, string NewPassword, string Email) 
        {
            return Fn.Exec("UPDATE Login SET Password = '" + Encryptor.Encrypt(NewPassword) + "' where UserName = '" + Email + "' and Password = '" + Encryptor.Encrypt(OldPassword) + "'; Select Scope_Identity(); ");
        }

    }
}