using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class DepartmentRegistration : System.Web.UI.Page
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
        public static string SaveData(string Values) 
        {
            var frmdata = Values;
            string[] d = frmdata.Split('½');


            return Fn.ExenID("INSERT INTO tbl_Departments (DepartmentName, DepartmentPhoneNo, CurrentlyWorking) VALUES        ('" + d[0] + "' , '" + d[1] + "', '" + d[2] + "'); select SCOPE_IDENTITY();");
        }


        [WebMethod]
        public static string AllDepartments() 
        {
            return Fn.Data2Json("select  ROW_NUMBER() over(order by tbl_Departments.DepartmentID) as Srno, tbl_Departments.DepartmentID , tbl_Departments.DepartmentName, tbl_Departments.DepartmentPhoneNo, Case when tbl_Departments.CurrentlyWorking = 1 then 'Yes' else 'No' end as CurrentlyWorking from tbl_Departments   Order by tbl_Departments.DepartmentName");
        }
    }
}