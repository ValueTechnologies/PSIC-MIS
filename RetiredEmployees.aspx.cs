using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class RetiredEmployees : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static void RetireEmployees(string Ids) 
        {
            Fn.Exec("INSERT INTO tbl_RetiredEmployees (EmpID, RetirmentDate) Select items, Dateadd(year, 60, TblHResources.DOB) as RetireDate from SplitString('" + Ids + "', ',') as SelectedIDs inner join TblHResources on TblHResources.User_ID = SelectedIDs.items; ");
            Fn.Exec("update TblHResources set U_Status = 0 where User_ID in (select items from SplitString( '" + Ids + "', ','));");
        }

        
    }
}