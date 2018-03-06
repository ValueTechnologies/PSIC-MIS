using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;


namespace PSIC
{
    /// <summary>
    /// Summary description for EmployeePostingHistoryCS
    /// </summary>
    public class EmployeePostingHistoryCS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            MyClass Fn = new MyClass();
            var frmdata = context.Request.Form["vls"];
            string[] d = frmdata.Split('½');
            try
            {
                string id = "";

                if (context.Request.Files.Count > 0)
                {
                    HttpFileCollection SelectedFiles = context.Request.Files;
                    HttpPostedFile PostedFile = SelectedFiles[0];
                    string FileName = context.Server.MapPath("~/Uploads/EmployeePostingLetter/" + PostedFile.FileName);
                    string Path = context.Server.MapPath("~/Uploads/EmployeePostingLetter/");
                    FileInfo fi = new FileInfo(FileName);
                    id = Fn.ExenID(@"usp_PostingHistory '" + d[5] + "','" + d[0] + "','" + d[1] + "', '" + d[4] + "','" + d[2] + "', '" + d[3] + "', '" + fi.Extension + "', NULL");
                
                }
                else
                {
                    id = Fn.ExenID(@"usp_PostingHistory '" + d[5] + "','" + d[0] + "','" + d[1] + "', '" + d[4] + "','" + d[2] + "', '" + d[3] + "', '', NULL");
                }
                




                int NewEmpID = Convert.ToInt32(id);
                if (context.Request.Files.Count > 0 && NewEmpID > 0)
                {
                    HttpFileCollection SelectedFiles = context.Request.Files;

                    for (int i = 0; i < SelectedFiles.Count; i++)
                    {
                        // Start
                        HttpPostedFile PostedFile = SelectedFiles[i];
                        string FileName = context.Server.MapPath("~/Uploads/EmployeePostingLetter/" + PostedFile.FileName);
                        string Path = context.Server.MapPath("~/Uploads/EmployeePostingLetter/");
                        FileInfo fi = new FileInfo(FileName);

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