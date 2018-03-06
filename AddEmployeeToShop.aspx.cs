using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class AddEmployeeToShop : System.Web.UI.Page
    {
        public static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetEmployees(string ShopID)
        {
            return Fn.Data2Json("select TblHResources.User_ID as EmpID,  TblHResources.Full_Name as EmployeeName from PSIC_DB.dbo.TblHResources as TblHResources inner join  PSIC_DB.dbo.tbl_EmployeePostingHistory as tbl_EmployeePostingHistory on tbl_EmployeePostingHistory.EmpID = TblHResources.User_ID where  tbl_EmployeePostingHistory.PostingEndingDate is null and tbl_EmployeePostingHistory.PostingTehsil = (Select ShopTehsilID from tbl_Shops where ShopID = '" + ShopID + "')");
        }



        [WebMethod]
        public static string SaveShopStaff(string ShopID, string EmpID, string IsManager)
        {
            return Fn.Exec("INSERT INTO tbl_EmployeeShop (ShopID, EmpID, IsManager) VALUES ('" + ShopID + "','" + EmpID + "','" + IsManager + "')");
        }


        [WebMethod]
        public static string GetStaff(string ShopID)
        {
            return Fn.Data2Json("select TblHResources.User_ID as EmpID,  TblHResources.Full_Name as EmpName, TblHResources.ContactNos, case when tbl_EmployeeShop.IsManager = 1 then 'Manager' else 'Staff Member' end as Role from tbl_EmployeeShop inner join tbl_Shops on tbl_Shops.ShopID = tbl_EmployeeShop.ShopID inner join TblHResources on TblHResources.User_ID = tbl_EmployeeShop.EmpID where tbl_EmployeeShop.ShopID = '" + ShopID + "' order by tbl_EmployeeShop.IsManager desc");
        }


    }
}