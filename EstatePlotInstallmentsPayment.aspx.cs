using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstatePlotInstallmentsPayment : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string AllInstallmentsOfPlot(string PlotID)
        {
            return Fn.Data2Json("select ROW_NUMBER() over(order by tbl_EstatePlotInstallmentsDetail.InstallmentDate) as srno, Format(tbl_EstatePlotInstallmentsDetail.InstallmentDate, 'dd - MMM - yyyy') as InstallmentDate, tbl_EstatePlotInstallmentsDetail.InstallmentAmount, case when (tbl_EstatePlotInstallmentsDetail.Paid is null) then 'Not Paid' else 'Paid' end as PaymentStatus , tbl_EstatePlotInstallmentsDetail.InstallmentDetailID from tbl_EstatePlotInstallments 	inner join tbl_EstatePlotInstallmentsDetail on tbl_EstatePlotInstallments.InstallmentID = tbl_EstatePlotInstallmentsDetail.InstallmentID where tbl_EstatePlotInstallments.PlotId = " + PlotID);
        }

        [WebMethod]
        public static string SaveInstallmentPayment(string PaymentAmount, string PaymentDate, string InstallmentDetailID)
        {
            return Fn.Exec("UPDATE tbl_EstatePlotInstallmentsDetail SET Paid = 1, PaidDate = '" + PaymentDate + "', PaidAmount = '" + PaymentAmount + "' where InstallmentDetailID =" + InstallmentDetailID);
        }



    }
}