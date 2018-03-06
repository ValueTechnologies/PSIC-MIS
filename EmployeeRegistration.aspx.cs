using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EmployeeRegistration : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string AllDepartments() 
        {
            return Fn.Data2Json("SELECT DepartmentID, DepartmentName FROM tbl_Departments order by DepartmentName");
        }


        [WebMethod]
        public static string AllDesignations()
        {
            return Fn.Data2Json("SELECT DesignationID, Designation FROM tbl_Designation order by Designation");
        }

        [WebMethod]
        public static string AllUserGroups()
        {
            return Fn.Data2Json("SELECT User_Group_Id,  User_Group_Name FROM User_Groups order by Priority");
        }


        [WebMethod]
        public static string SaveFamilyInfo(string Relation, string Name, string DOB, string EmpID) 
        {
            return Fn.Exec("INSERT INTO tbl_FamilyMembers (Relation, MemberName, MemberDOB, EmployeeID) VALUES ('" + Relation + "', '" + Name + "', '" + DOB + "', '"+ EmpID +"')");
        }


        [WebMethod]
        public static string SaveDegreeInfo(string Degree, string Institute, string FromYear, string ToYear, string EmpID) 
        {
            return Fn.Exec("INSERT INTO tbl_EmployeeDegree (Degree, Insititute, FromYear, ToYear, EmployeeID) VALUES ( '" + Degree + "', '" + Institute + "', '" + FromYear + "', '"+ ToYear +"', '"+ EmpID +"')");
        }



        [WebMethod]
        public static void SaveAppointmentInfo(string Dist, string Teh, string Dept, string Desig, string EmpID, string AppintmentDate, string EmpType, string ContractStart, string ContractEnd, string BPS)
        {
            Fn.Exec("INSERT INTO tbl_EmployeePostingHistory (EmpID, PostingDistrict, PostingTehsil, PostingStartDate, PostingDeptID, PostingDesigID) VALUES ('" + EmpID + "', '" + Dist + "', '" + Teh + "', '" + AppintmentDate + "', '" + Dept + "', '" + Desig + "')");
            Fn.Exec("INSERT INTO tbl_EmployeePromotionHistory (EmpID, promotionDate, DeptID, DesigID, BPS) VALUES        ('" + EmpID + "', '" + AppintmentDate + "','" + Dept + "','" + Desig + "', '" + BPS + "')");

            if (EmpType == "2")
            {
                Fn.Exec("INSERT INTO tbl_EmployeeContractInfo (EmpID, ContractStartDate, ContractEndDate, IsExtended, IsCurrentContract) VALUES ('" + EmpID + "', '" + ContractStart + "', '" + ContractEnd + "', '0', '1')");
                Fn.Exec("update TblHResources set IsContractEmployee = 1 where User_ID = " + EmpID);
            }
            else
            {
                Fn.Exec("update TblHResources set IsContractEmployee = 0 where User_ID = " + EmpID);
            }
        }


    }
}