using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace PSIC
{
    public partial class NewScheme : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();

        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static String getlocRegion()
        {
            return Fn.Data2Json("select ProvinceID as LocID, LocName from TblProvince order by LocName");

        }

        [WebMethod]
        public static String getlocDistrict()
        {
            return Fn.Data2Json("select  DistrictID as LocID, LocName from TblDistrict where RegionID = 7 order by LocName");
        }


        [WebMethod(EnableSession=true)]
        public static string SaveScheme(string schemeName, string districtID, string TehsilID, string startingDate, string GPS, string areaOfEstate) 
        {
            try
            {
                Fn.Exec("usp_NewScheme '" + schemeName + "', '" + districtID + "', '" + startingDate + "',  '" + TehsilID + "','" + Convert.ToString(HttpContext.Current.Session["UserID"]) + "', '" + GPS + "','" + areaOfEstate + "'");
                return "1";
            }
            catch (Exception)
            {
                return "0";
            }             
        }

        [WebMethod(EnableSession = true)]
        public static string UpdateScheme(string schemeName, string districtID, string TehsilID, string startingDate, string GPS, string TotalArea, int SchemeID)
        {
            try
            {
                Fn.Exec("usp_UpdateScheme '" + schemeName + "', '" + districtID + "', '" + startingDate + "',  '" + TehsilID + "','" + GPS + "','" + TotalArea + "','" + SchemeID + "'");
                return "1";
            }
            catch (Exception)
            {
                return "0";
            }
        }



        [WebMethod]
        public static String getlocTehsil(string TypeID)
        {
            int type = 0;
            try
            {
                type = Convert.ToInt32(TypeID);
            }
            catch (Exception)
            {

                return "";
            }
            return Fn.Data2Json("select TehsilID as LocID, LocName from TblTehsil where DistrictID = " + TypeID + " order by LocName");
        }


        [WebMethod]
        public static String getlocUnionConcil(string TypeID)
        {
            int type = 0;
            try
            {
                type = Convert.ToInt32(TypeID);
            }
            catch (Exception)
            {

                return "";
            }
            return Fn.Data2Json("select TblUnionConcil.UnionConcilID as LocID, TblUnionConcil.LocName as LocName  from TblFeildUnit left outer join TblUnionConcil on TblUnionConcil.FeildUnitID = TblFeildUnit.FeildUnitID where TblFeildUnit.TehsilID =  '" + type + "' order by TblUnionConcil.LocName");
        }


        [WebMethod]
        public static string LoadSchemes() 
        {
            return Fn.Data2Json("SELECT  ROW_NUMBER() over(order by tbl_EstateScheme.SchemeID desc) as Srno, tbl_EstateScheme.SchemeID, tbl_EstateScheme.TehsilID, tbl_EstateScheme.DistrictID, tbl_EstateScheme.Scheme,tbl_EstateScheme.GPS, tbl_EstateScheme.TotalAreaOfEstate, Format(tbl_EstateScheme.StartingDate, 'dd - MMM - yyyy') as StartingDate, TblTehsil.LocName as Tehsil, TblDistrict.LocName as District FROM tbl_EstateScheme INNER JOIN TblTehsil ON TblTehsil.TehsilID = tbl_EstateScheme.TehsilID INNER JOIN TblDistrict ON TblDistrict.DistrictID = tbl_EstateScheme.DistrictID");
        }

    }
}