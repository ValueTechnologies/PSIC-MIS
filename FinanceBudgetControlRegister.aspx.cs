using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class FinanceBudgetControlRegister : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }




        [WebMethod]
        public static string LoadAccountHead()
        {
            return Fn.Data2Json("select AccountID, HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName from tbl_ChartOfAccount where ISEntryLevel = 1 order by HeadName");
        }


        [WebMethod]
        public static string SaveNewBudget(string Head, string DateOfBudget, string Amount)
        {
            return Fn.ExenID("INSERT INTO tbl_BudgerRegister (HeadId, IssueDate, Amount) VALUES ('" + Head + "', '"+ DateOfBudget + "', '"+ Amount + "'); Select Scope_Identity();");
        }

        [WebMethod]
        public static string BudgetList()
        {
            return Fn.Data2Json("SELECT   ROW_NUMBER() over(order by tbl_ChartOfAccount.HeadName) as srno, tbl_ChartOfAccount.HeadName , Sum(Amount) as Amount FROM tbl_BudgerRegister inner join tbl_ChartOfAccount on tbl_ChartOfAccount.AccountID = tbl_BudgerRegister.HeadId group by tbl_ChartOfAccount.HeadName");
        }


    }
}