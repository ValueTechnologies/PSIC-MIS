using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace PSIC
{
    public partial class CreateLogin : System.Web.UI.Page
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
        public static string AllDepartments()
        {
            return Fn.Data2Json("SELECT DepartmentID,   DepartmentName FROM tbl_Departments ");
        }


        [WebMethod]
        public static string AllNonCreatedLoginEmployees(string DeptID) 
        {
            return Fn.Data2Json("Select User_ID, Full_Name, Email from TblHResources where User_ID not in (Select Emp_Id from Login) and DeptID = " + DeptID);
        }



        [WebMethod]
        public static string EmployeesEmailUsingID(string UseriD)
        {
            return Fn.Data2Json("Select Email from TblHResources where User_ID = " + UseriD);
        }

        [WebMethod]
        public static string CreateNewLogin(string password, string userid, string emailAddress) 
        {
            string strPass = Encryptor.Encrypt(password);
            string sss = Fn.ExenID("usp_CreateNewLogin @Password = '" + strPass + "' ,@userid = '" + userid + "', @EmpID = '" + CreateLogin.UserID + "', @username = '" + emailAddress + "'");

            DBManagerPSICMisc dbMan = new DBManagerPSICMisc();
            string emailBody = dbMan.NewAccountEmailBody(emailAddress, password);

            Fn.SendEmail(emailAddress, "New Login Created", emailBody, dbMan.UserEmail(CreateLogin.UserID));

            return string.Empty;
        }

    }
}