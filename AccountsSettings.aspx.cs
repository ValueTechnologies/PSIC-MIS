using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class AccountsSettings : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {

            }
        }


        [WebMethod(EnableSession=true)]
        public static void CurruntYearSaveData(string StartingMonth, string StartingYear, string ActiveMonth, string ActiveYear) 
        {
            DateTime AccountYear = new DateTime(Convert.ToInt32(StartingYear), Convert.ToInt32(StartingMonth), 1);
            DateTime CurruntMonth = new DateTime(Convert.ToInt32(ActiveYear), Convert.ToInt32(ActiveMonth), 1);

            Fn.Exec("if not exists(select * from tblMonthCloseing) begin INSERT INTO tblMonthCloseing (AMonth, AccYear) VALUES ('" + CurruntMonth + "', '" + AccountYear + "') end else begin UPDATE tblMonthCloseing SET AMonth = '" + CurruntMonth + "', AccYear = '" + AccountYear + "' end");

            HttpContext.Current.Session["Amonth"] = Convert.ToString(ActiveMonth) + Convert.ToString(ActiveYear);
        }



        [WebMethod]
        public static string GetAccountYearAndMonth() 
        {
            return Fn.Data2Json("Select Format(AMonth, 'MM') as ActiveMonth, Format(AMonth, 'yyy') as ActiveYear,   Format(AccYear, 'MM') as AccountYearMonth, Format(AccYear, 'yyy') as AccountYearYear from  tblMonthCloseing");
        }
    }
}