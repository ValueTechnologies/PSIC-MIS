using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;



namespace PSIC
{
    public partial class InquiresReport : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string InquiryPannel() 
        {
            return Fn.Data2Json("SELECT TblHResources.User_ID, TblHResources.Full_Name FROM tbl_Designation inner join TblHResources on TblHResources.DesignationID = tbl_Designation.DesignationID WHERE        (HigherManagment = 1) and (U_Status = 1)");
        }


        [WebMethod]
        public static string SaveData(string EmpID, string Reason, string StartingDate, string EndingDate, string Result, string InquiryPannelIDs)
        {
            string InquiryID =  Fn.ExenID("INSERT INTO tbl_EmployeeInquiryHistory (EmpID, Reason, StartingDate, EndingDate, Result) VALUES ('" + EmpID + "','" + Reason + "','" + StartingDate + "','" + EndingDate + "','" + Result + "'); select scope_identity();");
            return Fn.Exec("insert into tbl_InquiryPannelMembers (InquiryID, PannelMemberID) select '" + InquiryID + "' ,items from SplitString( '" + InquiryPannelIDs + "', ',');");
        }


    }
}