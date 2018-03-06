using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class ChartOfAccount : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string DisplayChartOfAccount() 
        {
            DBManagerPSICMisc dbMan = new DBManagerPSICMisc();
            return dbMan.GetChartOfAccount();
        }

        [WebMethod]
        public static string SaveNewHead(string ParentID, string Code, string Name, string Level, string HeadType) 
        {
            return Fn.Exec("INSERT INTO tbl_ChartOfAccount (HeadName, AccountCode, Leavel, ParentID, ISEntryLevel) VALUES        ('" + Name + "', '" + Code + "','" + (Convert.ToInt32(Level) + 1) + "','" + ParentID + "', '" + HeadType + "')");
        }



        [WebMethod]
        public static string GetNewCode(string parentID) 
        {
            return Fn.Data2Json("select ISNULL(max(AccountCode), 0) + 1 as NewCode from tbl_ChartOfAccount where ParentID = " + parentID);
        }

        [WebMethod]
        public static string GetHeadType(string AccountID) 
        {
            return Fn.Data2Json("select HeadName, AccountCode, Case when ISEntryLevel = 1 then '1' else '0' end as ISEntryLevel from tbl_ChartOfAccount where AccountID = " + AccountID);
        }


        [WebMethod]
        public static string UpdateHead(string AccountID, string HeadName, string HeadType) 
        {
            return Fn.Exec("UPDATE tbl_ChartOfAccount SET HeadName = '" + HeadName + "', ISEntryLevel = '" + HeadType + "' where AccountID = " + AccountID);
        }
    }
}