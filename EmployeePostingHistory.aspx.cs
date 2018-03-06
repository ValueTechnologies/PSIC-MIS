using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EmployeePostingHistory : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string AllDepartments()
        {
            return Fn.Data2Json("Select DepartmentID, DepartmentName from(Select 0 as DepartmentID, ' ---All---' as DepartmentName union SELECT DepartmentID, DepartmentName FROM tbl_Departments) as tab order by DepartmentName");
        }


        [WebMethod]
        public static string AllDesignations()
        {
            return Fn.Data2Json("Select DesignationID, Designation from( Select 0 as DesignationID, ' ---All---' as Designation union SELECT DesignationID, Designation FROM tbl_Designation) as tab order by Designation");
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
        public static String getlocFeildUnit(string TypeID)
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
            return Fn.Data2Json("select TblFeildUnit.FeildUnitID as LocID,  (case when Rtrim(Ltrim(TblFeildUnit.LocName)) = '' then  TblTehsil.LocName else TblFeildUnit.LocName end) as LocName from  TblFeildUnit inner join TblTehsil on TblTehsil.TehsilID = TblFeildUnit.TehsilID where TblFeildUnit.TehsilID = " + TypeID + " order by TblFeildUnit.LocName");
        }




        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID) 
        {
            return Fn.Data2Json("usp_SearchEmployeeBasicData '" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }


    }
}