using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstatePlotInstallmentsMade : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string CreateInstallments(string fromDate, string toDate, string Amount, string NoOfInstallments)
        {
            DBManagerPSICMisc dbMan = new DBManagerPSICMisc();
            return dbMan.EstatePlotInstallmentsCreate(fromDate, toDate, Amount, NoOfInstallments);
        }

        [WebMethod]
        public static string SaveInstallmentsMain(string fromDate, string toDate, string Amount, string NoOfInstallments, string PlotId)
        {
            return Fn.ExenID("INSERT INTO tbl_EstatePlotInstallments (PlotId, FromDate, ToDate, Amount, TotalIntallments) VALUES ('" + PlotId + "', '" + fromDate + "','" + toDate + "','" + Amount + "', '" + NoOfInstallments + "'); Select SCOPE_IDENTITY();");
        }



        [WebMethod]
        public static string SaveInstallmentsDetail(string InstallmentID, string InsDate, string InsAmount)
        {
            return Fn.Exec("INSERT INTO tbl_EstatePlotInstallmentsDetail (InstallmentID, InstallmentDate, InstallmentAmount) VALUES ('"+ InstallmentID + "', '"+ InsDate + "', '"+ InsAmount + "')");
        }

    }
}