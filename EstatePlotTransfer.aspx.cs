using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstatePlotTransfer : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string SaveTransfer(string Candidates, string PlotId, string TransferDate, string TransferStatus, string Remarks)
        {
            return Fn.Exec("usp_PlotTransfer '"+ Candidates + "', '"+ PlotId + "', '"+ TransferDate + "', '"+ TransferStatus + "', '"+ Remarks + "'");
        }


        [WebMethod]
        public static string SearchPlots(string SchemeID, string CategoryID, string PlotID, string PlotType)
        {
            return Fn.Data2Json("usp_SearchEstatePlots '" + SchemeID + "' , '" + CategoryID + "', '" + PlotID + "', '" + PlotType + "', '2'");
        }





    }
}