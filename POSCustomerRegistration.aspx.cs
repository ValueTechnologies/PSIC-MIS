using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSCustomerRegistration : System.Web.UI.Page
    {
        public static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string SaveCustomer(string vals)
        {
            string[] d = vals.Split('§');
            return Fn.Exec("usp_POSCustomerRegistration '"+ d[0]+ "', '" + d[1] + "', '" + d[2] + "', '" + d[3] + "', '" + d[4] + "', '" + d[5] + "', '" + d[6] + "', '" + d[7] + "'");
        }

        
        [WebMethod]
        public static string GetCustomer()
        {
            return Fn.Data2Json("SELECT ROW_NUMBER() over(order by tbl_Customer.Name) as Srno, tbl_Customer.CustomerID, tbl_Customer.Name, tbl_Customer.CellNo, tbl_Customer.Address, case when tbl_Customer.HasMembership = 1 then 'Yes' else 'No' end as HasMembership, ISNULL(tbl_MembershipDetail.MembershipType, '') as MembershipType, ISNULL(tbl_MembershipDetail.Amount, 0) as Amount, ISNULL(Format(tbl_MembershipDetail.StartingDate, 'dd-MMM-yyyy'), '') as StartingDate, ISNULL(Format(tbl_MembershipDetail.EndingDate, 'dd-MMM-yyyy'), '') as EndingDate, tbl_MembershipDetail.Is_Expire FROM tbl_Customer Left Outer JOIN tbl_MembershipDetail ON tbl_MembershipDetail.CustomerId = tbl_Customer.CustomerID where tbl_MembershipDetail.Is_Expire = 0  or tbl_MembershipDetail.Is_Expire is null");
        }
    }
}