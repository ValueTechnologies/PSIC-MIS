using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class AddEmployeeToGPF : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID)
        {
            return Fn.Data2Json("usp_SearchEmployeeBasicDataGPF '" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }



        [WebMethod]
        public static string SaveEmployeeToGPF(string OfficeName, string AccountNo, string EmpID) 
        {
            return Fn.ExenID("INSERT INTO tbl_GPFEmployees (EmpID, AcNo, NameOfOffice, CreateDate) VALUES ('" + EmpID + "', '" + AccountNo.Trim() + "', '" + OfficeName.Trim() + "', GETDATE()); Select SCOPE_IDENTITY();");
        }


    }
}