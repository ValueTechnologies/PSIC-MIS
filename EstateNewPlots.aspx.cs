using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstateNewPlots : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string LoadScheme() 
        {
            return Fn.Data2Json("SELECT SchemeID, Scheme FROM tbl_EstateScheme order by Scheme");
        }


        [WebMethod]
        public static string LoadCategories(string SchemeID) 
        {
            return Fn.Data2Json("SELECT PlotCategoryID, Category FROM tbl_EstatePlotCategory where SchemeID = '" + SchemeID + "' order by Category");
        }

        [WebMethod]
        public static string LoadType()
        {
            return Fn.Data2Json("SELECT PlotTypeID, PlotType FROM tbl_EstatePlotType order by PlotType");
        }


        [WebMethod]
        public static string LoadStatus()
        {
            return Fn.Data2Json("SELECT PlotStatusID, PlotStatus FROM tbl_EstatePlotStatus order by PlotStatus");
        }


        [WebMethod]
        public static string SaveCategory(string Category, string PlotSize, string SchemeID)
        {
            return Fn.Exec("INSERT INTO tbl_EstatePlotCategory (Category, PlotSize, SchemeID) VALUES ('" + Category + "', '" + PlotSize + "', '" +SchemeID + "')");
        }


        [WebMethod]
        public static string SaveType(string Type)
        {
            return Fn.Exec("INSERT INTO tbl_EstatePlotType (PlotType) VALUES ('" + Type + "')");
        }

        [WebMethod]
        public static string SaveStatus(string Status)
        {
            return Fn.Exec("INSERT INTO tbl_EstatePlotStatus (PlotStatus) VALUES ('" + Status + "')");
        }
        
        [WebMethod]
        public static string SaveNewPlot(string PlotID, string SchemeID, string PlotNo, string PlotCategory, string KhasraNo, string PlotType, string PlotStatus, string PlotPSICPrice, string PlotDetail, string Locations) 
        {
            return Fn.Exec("INSERT INTO tbl_EstateSchemePlots (SchemeID, PlotNo, PlotCategory, KhasraNo, PlotType, PlotStatus, PlotPSICPrice, PlotDetail, Locations) VALUES        ('" + SchemeID + "', '" + PlotNo + "', '" + PlotCategory + "', '" + KhasraNo + "', '" + PlotType + "', '" + PlotStatus + "', '" + PlotPSICPrice + "', '" + PlotDetail + "', '" + Locations + "');");
        }

        [WebMethod]
        public static string UpdatePlot(string PlotID, string SchemeID, string PlotNo, string PlotCategory, string KhasraNo, string PlotType, string PlotStatus, string PlotPSICPrice, string PlotDetail, string Locations)
        {
            return Fn.Exec("Update tbl_EstateSchemePlots set SchemeID = '" + SchemeID + "', PlotNo = '" + PlotNo + "', PlotCategory = '" + PlotCategory + "', PlotType = '" + PlotType + "', PlotStatus = '" + PlotStatus + "', PlotPSICPrice = '" + PlotPSICPrice + "', PlotDetail = '" + PlotDetail + "', Locations = '" + Locations + "' WHERE PlotID = '" + PlotID + "'");
        }

        [WebMethod]
        public static string CheckPlotNumberAlreadyExists(string SchemeID, string PlotNo, string PlotID)
        {
            return Fn.Data2Json("SELECT * from tbl_EstateSchemePlots where tbl_EstateSchemePlots.SchemeID = '" + SchemeID + "' and tbl_EstateSchemePlots.PlotNo = '" + PlotNo + "'");
        }

        [WebMethod]
        public static string CheckPlotNumberAlreadyExistsForUpdate(string SchemeID, string PlotNo, string PlotID)
        {
            return Fn.Data2Json("SELECT * from tbl_EstateSchemePlots where (tbl_EstateSchemePlots.SchemeID = '" + SchemeID + "' and tbl_EstateSchemePlots.PlotNo = '" + PlotNo + "') and (tbl_EstateSchemePlots.PlotID != '" + PlotID + "')");
        }

        [WebMethod]
        public static string LoadPlots(string SchemeID)
        {
            return Fn.Data2Json("SELECT row_number() over(order by tbl_EstateSchemePlots.PlotNo) as sno, tbl_EstateSchemePlots.PlotID,   tbl_EstateSchemePlots.PlotNo, tbl_EstatePlotCategory.PlotSize, tbl_EstateSchemePlots.PlotPSICPrice, tbl_EstateSchemePlots.PlotDetail, tbl_EstatePlotType.PlotType, tbl_EstatePlotCategory.Category, tbl_EstatePlotStatus.PlotStatus, tbl_EstateSchemePlots.Locations FROM tbl_EstateSchemePlots INNER JOIN tbl_EstatePlotCategory ON tbl_EstatePlotCategory.PlotCategoryID = tbl_EstateSchemePlots.PlotCategory INNER JOIN tbl_EstatePlotType ON tbl_EstatePlotType.PlotTypeID = tbl_EstateSchemePlots.PlotType INNER JOIN tbl_EstatePlotStatus ON tbl_EstatePlotStatus.PlotStatusID = tbl_EstateSchemePlots.PlotStatus where tbl_EstateSchemePlots.SchemeID = " + SchemeID);
        }

        [WebMethod]
        public static string GetPlotDetailByID(string PlotID)
        {
            return Fn.Data2Json("SELECT tbl_EstateSchemePlots.PlotID,   tbl_EstateSchemePlots.PlotNo, tbl_EstateSchemePlots.PlotPSICPrice, tbl_EstateSchemePlots.PlotDetail, tbl_EstateSchemePlots.PlotType, tbl_EstateSchemePlots.PlotCategory, tbl_EstateSchemePlots.PlotStatus, tbl_EstateSchemePlots.Locations, tbl_EstateSchemePlots.KhasraNo FROM tbl_EstateSchemePlots where tbl_EstateSchemePlots.PlotID = " + PlotID);
        }
    }
}