using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstatePlotAllocation : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchPlots(string SchemeID, string CategoryID, string PlotID, string PlotType)
        {
            return Fn.Data2Json("usp_SearchEstatePlots '" + SchemeID + "' , '" + CategoryID + "', '" + PlotID + "', '" + PlotType + "', '0'");
        }


        [WebMethod]
        public static string AllCandidates()
        {
            return Fn.Data2Json("Select ApplicantID, Name + ' (' + CNIC  + ' )' as Name from tbl_EstateApplicant order by Name");
        }

        [WebMethod]
        public static string LoadOwnersOfPlot(string PlotiD)
        {
            return Fn.Data2Json("usp_PlotAllocation " + PlotiD);
        }

        [WebMethod]
        public static string SaveAllocation(string PlotOwnershipCandidateID, string AllocationPercentage, string Candidates, string PurchasingDate, string AllocateThrough)
        {
            return Fn.Exec("usp_PlotAllocation '" + PlotOwnershipCandidateID + "', '" + PurchasingDate + "', '" + Candidates + "', '" + AllocateThrough + "', '" + AllocationPercentage + "'");
        }

        [WebMethod]
        public static string UpdateAllocation(string PlotOwnershipCandidateID, string AllocationPercentage, string Candidates, string PurchasingDate, string AllocateThrough)
        {
            return Fn.Exec("usp_PlotAllocation '" + PlotOwnershipCandidateID + "', '" + PurchasingDate + "', '" + Candidates + "', '" + AllocateThrough + "', '" + AllocationPercentage + "'");
        }


    }
}