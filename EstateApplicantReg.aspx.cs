using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstateApplicantReg : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string LoadIndustrialist()
        {
             return Fn.Data2Json("Select * from tbl_EstateApplicant");
        }

        [WebMethod]
        public static void SaveData(string Name, string CNIC, string NTN, string ContactNo, string Address)
        {
            Fn.ExenID("INSERT INTO tbl_EstateApplicant (Name, CNIC, NTN, ContactNo, Address) VALUES ('"+ Name + "', '"+ CNIC + "','"+ NTN + "', '"+ ContactNo + "', '"+ Address + "'); Select Scope_Identity();");
        }

    }
}