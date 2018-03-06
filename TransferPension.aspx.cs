using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class TransferPension : System.Web.UI.Page
    {
        static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID)
        {
            return Fn.Data2Json("usp_SearchEmployeePensionersPensionForTransfer'" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }


        [WebMethod]
        public static string SaveData(string EmpId, string PensionMonth, string PensionYear, string Bank, string MonthlyPension, string MedicalAllowance, string Arrears, string Deductions, string NetPaid, string Remarks)
        {
            return Fn.ExenID("usp_PensionMonthlyTransfer '"+ EmpId + "' ,'" + PensionMonth + "','" + PensionYear + "','" + Bank + "','" + MonthlyPension + "','" + MedicalAllowance + "','" + Arrears + "','" + Deductions + "','" + NetPaid + "','" + Remarks + "'      ");
        }


    }
}