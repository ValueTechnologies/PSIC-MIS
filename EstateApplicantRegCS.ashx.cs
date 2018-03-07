using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace PSIC
{
    /// <summary>
    /// Summary description for EstateApplicantRegCS
    /// </summary>
    public class EstateApplicantRegCS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            MyClass Fn = new MyClass();
            var frmdata = context.Request.Form["vls"];
            string[] d = frmdata.Split('½');
            int ID = Convert.ToInt32(d[5]);
            try
            {
                if (ID > 0)
                {
                    int NewEmpID = ID;
                    if (context.Request.Files.Count > 0 && NewEmpID > 0)
                    {
                        HttpFileCollection SelectedFiles = context.Request.Files;

                        for (int i = 0; i < SelectedFiles.Count; i++)
                        {
                            // Start
                            HttpPostedFile PostedFile = SelectedFiles[i];
                            string FileName = context.Server.MapPath("~/Uploads/EstateCandidatePhoto/" + PostedFile.FileName);
                            string Path = context.Server.MapPath("~/Uploads/EstateCandidatePhoto/");
                            FileInfo fi = new FileInfo(FileName);

                            var x = "update tbl_EstateApplicant set Name = '" + d[0] + "', CNIC = '" + d[1] + "', NTN = '" + d[2] + "', ContactNo = '" + d[3] + "', Address = '" + d[4] + "', PhotoExtension = '" + fi.Extension + "' where ApplicantID = " + NewEmpID;
                            Fn.Exec(x);

                            PostedFile.SaveAs(Path + Convert.ToString(NewEmpID) + fi.Extension);
                        }
                    }

                    if (NewEmpID > 0)
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write(NewEmpID);
                    }
                }
                else
                {
                    string id = "";
                    id = Fn.ExenID(@"INSERT INTO tbl_EstateApplicant (Name, CNIC, NTN, ContactNo, Address) VALUES ('" + d[0] + "', '" + d[1] + "','" + d[2] + "', '" + d[3] + "', '" + d[4] + "'); Select Scope_Identity();");



                    int NewEmpID = Convert.ToInt32(id);
                    if (context.Request.Files.Count > 0 && NewEmpID > 0)
                    {
                        HttpFileCollection SelectedFiles = context.Request.Files;

                        for (int i = 0; i < SelectedFiles.Count; i++)
                        {
                            // Start
                            HttpPostedFile PostedFile = SelectedFiles[i];
                            string FileName = context.Server.MapPath("~/Uploads/EstateCandidatePhoto/" + PostedFile.FileName);
                            string Path = context.Server.MapPath("~/Uploads/EstateCandidatePhoto/");
                            FileInfo fi = new FileInfo(FileName);

                            Fn.Exec("update tbl_EstateApplicant set PhotoExtension = '" + fi.Extension + "' where ApplicantID = " + NewEmpID);

                            PostedFile.SaveAs(Path + Convert.ToString(NewEmpID) + fi.Extension);
                        }
                    }

                    if (NewEmpID > 0)
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write(NewEmpID);
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