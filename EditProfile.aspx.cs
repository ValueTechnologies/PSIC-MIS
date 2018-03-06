using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EditProfile : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        public static string UseriD = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UseriD =  Session["UserID"].ToString();
            }
            catch (Exception)
            {
                Response.Redirect("Login.aspx");
            }
        }

        [WebMethod]
        public static string LoadData() 
        {
            return Fn.Data2Json("SELECT User_ID, Full_Name, ContactNos, Email, CNIC, FatherName, Format(DOB, 'dd - MMMM - yyyy') as DOB, Is_Male, Qualification FROM  TblHResources where User_ID = " + UseriD);
        }



    }
}