using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;



namespace PSIC
{
    public partial class EstatePlotBalloting : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string LoadPlots(string SchemeID)
        {
            return Fn.Data2Json("Select 0 PlotID, ' ---All---' as PlotNo  union Select PlotID, PlotNo from tbl_EstateSchemePlots where SchemeID = " + SchemeID);
        }


        [WebMethod]
        public static string LoadType()
        {
            return Fn.Data2Json("Select 0 as PlotTypeID, ' ---All---' PlotType union Select PlotTypeID, PlotType from tbl_EstatePlotType order by PlotType");
        }



        [WebMethod]
        public static string SearchPlots(string SchemeID, string CategoryID, string PlotID, string PlotType)
        {
            return Fn.Data2Json("usp_SearchEstatePlots '"+ SchemeID + "' , '"+ CategoryID + "', '"+ PlotID + "', '"+ PlotType + "', '1'");
        }




        [WebMethod]
        public static string SearchCandidatesForPlotCategory(string CategoryID)
        {
            return Fn.Data2Json("usp_SearchCandidatesOfPlotCategory '"+ CategoryID + "'");
        }


        [WebMethod]
        public static string SaveSelectedCandidates(string applicationID, string plotID)
        {
            return Fn.Exec("usp_EstatePlotBallotingAllocation '"+ applicationID + "', '"+ plotID + "'");
        }





    }
}