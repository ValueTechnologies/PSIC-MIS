using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class EstateOwnerwiseSearchReport : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string SearchOwners(string Name, string CNIC, string Contact, string NTN)
        {
            return Fn.Data2Json("SELECT ROW_NUMBER() over(order by name) as Srno, ApplicantID, Name, CNIC, NTN, ContactNo, Address, PhotoExtension  FROM tbl_EstateApplicant  where ApplicantID in (select CandidateID from tbl_OwnershipCandidates) and Name like '%' + '" + Name + "' + '%' and CNIC like '%' + '" + CNIC + "' + '%' and NTN like '%' + '" + NTN + "' + '%' and ContactNo like '%' + '" + Contact + "' + '%';");
        }
    }
}