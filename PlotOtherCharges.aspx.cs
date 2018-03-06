using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class PlotOtherCharges : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string PlotCharges()
        {
            return Fn.Data2Json("SELECT PlotChargesTypeID, PlotChagesTitle FROM tbl_EstatePlotChargesType order by PlotChagesTitle");
        }


        [WebMethod]
        public static string SaveNewPlotChargesType(string Title)
        {
            return Fn.ExenID("INSERT INTO tbl_EstatePlotChargesType (PlotChagesTitle) VALUES ('"+ Title + "'); Select SCOPE_IDENTITY();");
        }


        [WebMethod]
        public static string SavePlotCharges(string Title, string Amount, string PaymentDate, string PlotID)
        {
            return Fn.ExenID("INSERT INTO tbl_EstatePlotPaymentCharges (PlotID, ChargesTypeID, Amount, PaymentDate) VALUES ('"+ PlotID + "','"+ Title + "','"+ Amount + "','"+ PaymentDate + "'); ");
        }


    }
}