using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace PSIC
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetGeneralInfo()
        {
            return Fn.Data2Json("usp_EmployeeBasicInfoByID " + Convert.ToString(HttpContext.Current.Session["UserID"]));
        }
    }
}