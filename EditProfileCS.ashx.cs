using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace PSIC
{
    /// <summary>
    /// Summary description for EditProfileCS
    /// </summary>
    public class EditProfileCS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            MyClass Fn = new MyClass();
            try
            {
                var frmdata = context.Request.Form["vls"];
                string[] d = frmdata.Split('½');

                Fn.Exec("UPDATE TblHResources SET Full_Name = '" + d[0] + "', FatherName = '" + d[1] + "', CNIC = '" + d[2] + "', ContactNos = '" + d[3] + "', Email = '" + d[4] + "',  Qualification = '" + d[5] + "', DOB = '" + d[6] + "', Is_Male = '" + d[7] + "'  where User_ID = " + d[8]);

                Fn.Exec("UPDATE dbo.Login SET UserName = '" + d[4] + "' where Emp_Id = " + d[8]);



                if (context.Request.Files.Count > 0)
                {
                    HttpFileCollection SelectedFiles = context.Request.Files;

                    for (int i = 0; i < SelectedFiles.Count; i++)
                    {
                        HttpPostedFile PostedFile = SelectedFiles[i];
                        string FileName = context.Server.MapPath("~/Uploads/EmployeePhoto/" + PostedFile.FileName);
                        string Path = context.Server.MapPath("~/Uploads/EmployeePhoto/");
                        FileInfo fi = new FileInfo(FileName);

                        Fn.Exec("UPDATE TblHResources SET PhotoExtension = '" + fi.Extension + "' where User_ID = " + d[8]);
                        PostedFile.SaveAs(Path + Convert.ToString(d[8]) + fi.Extension);
                    }
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