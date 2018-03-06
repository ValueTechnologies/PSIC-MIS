using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;


namespace PSIC
{
    /// <summary>
    /// Summary description for EstateCandidateRegistrationCS
    /// </summary>
    public class EstateCandidateRegistrationCS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            MyClass Fn = new MyClass();
            try
            {
                var frmdata = context.Request.Form["vls"];
                string[] d = frmdata.Split('½');
                string ApplicationID = string.Empty;

                //29 Image
                //30 Signature
                //26 Candidates

                ApplicationID = Fn.ExenID("INSERT INTO tbl_EstateApplicationRegistration (SchemeID, CorporateSetup, IndustrialUnit, ClassificationOfIndustries,  Electricity, Water, Gas, WastProduct, ModeOfDisposal, CategoryID,  ApplicationFeePayOrder, ApplicationFeeAmountF, ApplicationFeeAmountW, ProcessingFeePayOrder, ProcessingFeeBearNo, ProcessingFeeAmountF, ProcessingFeeAmountW, DownPaymentPayOrder, DownPaymentBearNo, DownPaymentAmountF, DownPaymentAmountW, SignatureName, SignatureAddress, SignaturePhone, SignatureFax, SignatureEmail) VALUES ('" + d[0] + "' ,'" + d[1] + "','" + d[2] + "','" + d[3] + "','" + d[4] + "','" + d[5] + "','" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "','" + d[10] + "','" + d[11] + "','" + d[12] + "','" + d[13] + "','" + d[14] + "','" + d[15] + "','" + d[16] + "','" + d[17] + "','" + d[18] + "','" + d[19] + "','" + d[20] + "','" + d[21] + "','" + d[22] + "','" + d[23] + "','" + d[24] + "','" + d[25] + "'); Select SCOPE_IDENTITY();");

                Fn.Exec("Insert Into tbl_ApplicationApplicant(ApplicantId, ApplicationID) Select items, '" + ApplicationID + "' from SplitString( '" + d[26] + "', ',');");


                if (context.Request.Files.Count > 0 && Convert.ToInt32(ApplicationID) > 0)
                {
                    HttpFileCollection SelectedFiles = context.Request.Files;

                    for (int i = 0; i < SelectedFiles.Count; i++)
                    {
                        HttpPostedFile PostedFile = SelectedFiles[i];
                        string FileName = context.Server.MapPath("~/Uploads/EstateCandidateSignature/" + PostedFile.FileName);
                        string Path = context.Server.MapPath("~/Uploads/EstateCandidateSignature/");
                        FileInfo fi = new FileInfo(FileName);

                        Fn.Exec("UPDATE tbl_EstateApplicationRegistration SET SignatureExtension = '" + fi.Extension + "' where ApplicationID = " + ApplicationID);

                        PostedFile.SaveAs(Path + Convert.ToString(ApplicationID) + fi.Extension);
                        
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