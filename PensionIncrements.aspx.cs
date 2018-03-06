using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class PensionIncrements : System.Web.UI.Page
    {
        static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID)
        {
            return Fn.Data2Json("usp_SearchEmployeePensionersPensionForIncrease'" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }


        [WebMethod]
        public static string SaveData(string EmpId, string preGPension, string IncPrecentage, string IncDate, string IncGross, string IncMonthlyPension, string IncCommutation)
        {
            return Fn.ExenID("usp_PensionIncrementInPension '"+ EmpId + "' , '" + preGPension + "'  , '" + IncPrecentage + "'  , '" + IncDate + "' , '" + IncGross + "' , '" + IncMonthlyPension + "' , '" + IncCommutation + "' ");
        }

    }
}