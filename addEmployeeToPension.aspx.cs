using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class addEmployeeToPension : System.Web.UI.Page
    {
        static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string SearchEmployees(string empno, string name, string DepartmentID, string DesignationID)
        {
            return Fn.Data2Json("usp_SearchEmployeeBasicDataPension '" + empno + "', '" + name + "', '" + DepartmentID + "', '" + DesignationID + "'");
        }


        [WebMethod]
        public static string ConvertDateToYearMonthDate(string Date1, string Date2, string Holidays)
        {
            DateTime dt1 = Convert.ToDateTime(Date1);
            DateTime dt2 = Convert.ToDateTime(Date2);

            if (Holidays != string.Empty)
            {
                dt1 = dt1.AddDays(Convert.ToDouble(Holidays));
            }
            
            //var dateSpan = DateTimeSpan.CompareDates(dt1, dt2);
            var dateSpan = DateTime.Compare(dt1, dt2);
            var years = 2017;
            var months = 12;
            var days = 6;
            return Fn.Data2Json("select '" + years + "' as Year, '"+ months + "'  as Month, '" + days + "' as Day");
        }


        [WebMethod]
        public static string SaveEmployeeToPension(string Vals)
        {
            try
            {
                string[] d = Vals.Split('½');
                int id = Convert.ToInt32(Fn.ExenID(@"INSERT INTO tbl_PensionEmployees (EmpID, DateOfAppointment, DOB, DateOfRetirement, TotalAgeAtRetirementY, TotalAgeAtRetirementM, TotalAgeAtRetirementD, TotalServiceY, TotalServiceM, TotalServiceD, TotalHolidays, NetQualifyingServiceY, NetQualifyingServiceM, NetQualifyingServiceD, AgeNextBirthdays, AccountNo, FileNo)  VALUES ('" + d[16] + "','" + d[0] + "','" + d[1] + "','" + d[2] + "','" + d[3] + "','" + d[4] + "','" + d[5] + "','" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "','" + d[10] + "','" + d[11] + "','" + d[12] + "','" + d[13] + "','" + d[14] + "','" + d[15] + "'); Select Scope_Identity();"));
                if (id > 0)
                {
                    return "Save successfully";
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return string.Empty;
            
        }


        [WebMethod]
        public static string LoadEmpPreviousData(string EmpID)
        {
            return Fn.Data2Json("select Convert(varchar(50), ISNULL(DOB, GETDATE()), 106) as DOB, Convert(varchar(50), ISNULL(AppointmentDate, GETDATE()), 106) as DOA from TblHResources where User_ID = " + EmpID);
        }


    } 
}