using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.IO;


namespace PSIC
{
    /// <summary>
    /// Summary description for EmployeeRegistrationCS
    /// </summary>
    public class EmployeeRegistrationCS : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            MyClass Fn = new MyClass();
            var frmdata = context.Request.Form["vls"];
            string[] d = frmdata.Split('½');
            try
            {
                string id = "";
                if (Convert.ToString(d[13]) == "")
                {
                    id = Fn.ExenID(@"INSERT INTO TblHResources (EmpNo, CNIC, Full_Name, FatherName, DOB, Is_Male, DeptID, DesignationID, UserGroupID, U_Status, ContactNos, PhoneNo, AppointmentDate, ResignationDate, BPS, AppointmentLetterNo, PresentAddress, PermanentAddress, EnteryDate)
                                                VALUES ('" + d[0] + "','" + d[1] + "','" + d[2] + "', '" + d[3] + "','" + Convert.ToDateTime(d[4]) + "', '" + d[5] + "', '" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "', '" + d[10] + "', '" + d[11] + "','" + d[12] + "','" + DBNull.Value + "', '" + d[14] + "','" + d[15] + "', '" + d[16] + "', '" + d[17] + "', getdate()); select SCOPE_IDENTITY();");
                }
                else
                {
                    id = Fn.ExenID(@"INSERT INTO TblHResources (EmpNo, CNIC, Full_Name, FatherName, DOB, Is_Male, DeptID, DesignationID, UserGroupID, U_Status, ContactNos, PhoneNo, AppointmentDate, ResignationDate, BPS, AppointmentLetterNo, PresentAddress, PermanentAddress, EnteryDate)
                                                VALUES ('" + d[0] + "','" + d[1] + "','" + d[2] + "', '" + d[3] + "','" + Convert.ToDateTime(d[4]) + "', '" + d[5] + "', '" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "', '" + d[10] + "', '" + d[11] + "','" + d[12] + "','" + Convert.ToString(d[13]) + "', '" + d[14] + "','" + d[15] + "', '" + d[16] + "', '" + d[17] + "', getdate()); select SCOPE_IDENTITY();");
                }


                int NewEmpID = Convert.ToInt32(id);
                if (context.Request.Files.Count > 0 && NewEmpID > 0)
                {
                    HttpFileCollection SelectedFiles = context.Request.Files;

                    for (int i = 0; i < SelectedFiles.Count; i++)
                    {
                        // Start
                        HttpPostedFile PostedFile = SelectedFiles[i];
                        string FileName = context.Server.MapPath("~/Uploads/EmployeePhoto/" + PostedFile.FileName);
                        string Path = context.Server.MapPath("~/Uploads/EmployeePhoto/");
                        FileInfo fi = new FileInfo(FileName);

                        Fn.Exec("update TblHResources set PhotoExtension = '" + fi.Extension + "' where User_ID = " + NewEmpID);

                        PostedFile.SaveAs(Path + Convert.ToString(NewEmpID) + fi.Extension);
                    }
                }

                if (NewEmpID > 0)
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write(NewEmpID);
                }
            }
            catch (Exception ex)
            {

                context.Response.ContentType = "text/plain";
                context.Response.Write(ex.Message);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}