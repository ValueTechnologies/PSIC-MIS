using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class PasswordReset : System.Web.UI.Page
    {
        public static MyClass Fn = new  MyClass();
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
        public static void ForgotPassword(string userid, string emailAddress, string password)
        {
            string NewPassword = password;
            DBManagerPSICMisc dbMan = new DBManagerPSICMisc();

            Fn.Exec("UPDATE Login SET Password = '" + Encryptor.Encrypt(NewPassword) + "' where UserName = '" + emailAddress + "' AND Emp_Id = '" + userid + "'");
            //Fn.SendEmail(emailAddress, "New Password", dbMan.ForgotPasswordEmailBody(emailAddress, NewPassword), dbMan.UserEmail(UserID));
        }



        [WebMethod]
        public static string AllEmployees(string DeptID) 
        {
            return Fn.Data2Json("SELECT User_ID, Full_Name FROM TblHResources where DeptID = " + DeptID);
        }



        [WebMethod]
        public static string AllDepartments()
        {
            return Fn.Data2Json("SELECT DepartmentID,   DepartmentName FROM tbl_Departments");
        }


        [WebMethod]
        public static string EmployeesEmailUsingID(string UseriD)
        {
            return Fn.Data2Json("Select UserName from Login where Emp_ID = " + UseriD);
        }

    }
}