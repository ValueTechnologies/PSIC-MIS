using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class MakeNewPensionerPension : System.Web.UI.Page
    {
        static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID)
        {
            return Fn.Data2Json("usp_SearchEmployeeBasicDataPensioners '" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }



        [WebMethod]
        public static string LoadEmpPreviousData(string EmpID)
        {
            return Fn.Data2Json("select  Convert(varchar(50), ISNULL(DOB, GETDATE()), 106) as DOB, Convert(varchar(50), ISNULL(DateOfAppointment, GETDATE()), 106) as DOA , Convert(varchar(50), ISNULL(DateOfRetirement, GETDATE()), 106) as DateOfRetirement,  TotalAgeAtRetirementY, TotalAgeAtRetirementM, TotalAgeAtRetirementD,TotalServiceY, TotalServiceM, TotalServiceD, TotalHolidays, NetQualifyingServiceY, NetQualifyingServiceM, NetQualifyingServiceD, AgeNextBirthdays , (SELECT  NoOfYearPurchased FROM tbl_PensionAgeRateTable where AgeNextBirthday = (Select Case when TotalAgeAtRetirementY >= 60 then 60 else case when TotalAgeAtRetirementM >= 6 then TotalAgeAtRetirementY + 1 else TotalAgeAtRetirementY end end as NextAge  from tbl_PensionEmployees where EmpID = '" + EmpID + "')) as AgeRate  from tbl_PensionEmployees where EmpID = " + EmpID);
        }



        [WebMethod]
        public static string LoadPensionType()
        {
            return Fn.Data2Json("SELECT PensionTypeID, PensionType FROM tbl_PensionType order by PensionType");
        }


        [WebMethod]
        public static string SaveData(string Vals)
        {
            string[] d = Vals.Split('½');
            try
            {
                int id = Convert.ToInt32(Fn.ExenID("usp_MakePensionCurruntCalculated '" + d[10] + "', '" + d[0] + "','" + d[1] + "','" + d[2] + "','" + d[3] + "','" + d[4] + "','" + d[5] + "','" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "'"));
                if (id > 0)
                {
                    return "Save Successfully!";
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return string.Empty;
            

        }


    }
}