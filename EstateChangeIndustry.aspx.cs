using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstateChangeIndustry : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static void SaveNewIndustry(string PlotId, string StartingDate, string IndustrialUnit, string TypeClassification, string Electricity, string Water, string Gas, string IdentifyWastProduct, string ModeOfDisposal)
        {
            Fn.Exec("usp_SaveNewIndustry '"+ PlotId + "', '" + StartingDate + "','" + IndustrialUnit + "','" + TypeClassification + "','" + Electricity + "','" + Water + "','" + Gas + "','" + IdentifyWastProduct + "','" + ModeOfDisposal + "'");
        }
    }
}