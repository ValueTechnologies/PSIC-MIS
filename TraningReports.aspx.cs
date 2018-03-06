using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class TraningReports : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SaveData(string TraningName, string InstituteName, string StartingDate, string EndingDate, string EmpID) 
        {
            return Fn.ExenID("INSERT INTO tbl_EmployeeTraninigs (TraningName, InstituteName, StartingDate, EndingDate, EmpID) VALUES ('" + TraningName + "', '" + InstituteName + "', '" + StartingDate + "', '" + EndingDate + "', '" + EmpID + "'); select SCOPE_IDENTITY();");
        }

    }
}