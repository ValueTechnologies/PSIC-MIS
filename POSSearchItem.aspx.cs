using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSSearchItem : System.Web.UI.Page
    {
        private static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string SearchFromTag(string tag)
        {
            return Fn.Data2Json("usp_ProductTracking '" + tag + "'");
        }

        [WebMethod]
        public static string SearchFromProduct(string product)
        {
            return Fn.Data2Json("usp_ProductTrackingByProduct '" + product + "'");
        }
    }
}