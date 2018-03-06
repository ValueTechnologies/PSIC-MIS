using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class LedgerSearch : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchLedger(string strAccountName) 
        {
            return Fn.Data2Json("SELECT AccountID, HeadName FROM tbl_ChartOfAccount where ISEntryLevel = 1 and AccountID in (Select distinct AccEntryID from TblVoucherDTL )  and headname like '%' + '" + strAccountName + "' + '%'");
        }
    }
}