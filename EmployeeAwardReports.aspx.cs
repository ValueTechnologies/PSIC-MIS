using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EmployeeAwardReports : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string SaveAward(string date, string reason, string remarks,string empid)
        {
            return Fn.Exec("INSERT INTO tbl_EmployeeAwards (EmpID, AwardDate, Reason, Remarks) VALUES ('" + empid + "', '" + date + "', '" + reason + "', '" + remarks + "')");
        
        }

    }
}