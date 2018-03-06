using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class PromotionHistory : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static void SaveData(string EmpID, string PromotionDate, string DeptID, string DesignID, string BPS) 
        {
            Fn.Exec("INSERT INTO tbl_EmployeePromotionHistory (EmpID, promotionDate, DeptID, DesigID, BPS) VALUES ( '" + EmpID + "', '" + PromotionDate + "', '" + DeptID + "', '" + DesignID + "', '" + BPS + "')");
            Fn.Exec("update TblHResources set DeptID = '" + DeptID + "', DesignationID = '" + DesignID + "', BPS = '" + BPS + "' where User_ID = " + EmpID);
        }

    }
}