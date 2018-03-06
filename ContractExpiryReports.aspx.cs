using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;



namespace PSIC
{
    public partial class ContractExpiryReports : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchContractEmployees(string empno, string name, string deptid, string desigid)
        {
            return Fn.Data2Json("usp_ContractEmployeeInfo '" + empno + "', '" + name + "', '" + deptid + "', '" + desigid + "'");
        }



        [WebMethod]
        public static string SaveExtendedContractInfo(string StartDate, string EndDate, string empid)
        {
            return Fn.ExenID("update tbl_EmployeeContractInfo set IsCurrentContract = '0' where  EmpID = '"+  empid +"';INSERT INTO tbl_EmployeeContractInfo (EmpID, ContractStartDate, ContractEndDate, IsExtended, IsCurrentContract) VALUES ('" + empid + "', '" + StartDate + "', '" + EndDate + "', '1', '1')");
        }

    }
}