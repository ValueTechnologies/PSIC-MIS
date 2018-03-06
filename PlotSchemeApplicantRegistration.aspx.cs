using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class PlotSchemeApplicantRegistration : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string AllSchemes() 
        {
            return Fn.Data2Json("SELECT SchemeID, Scheme FROM tbl_EstateScheme order by EntryDate desc");
        }

        [WebMethod]
        public static string CategoriesList(string schemeID) 
        {
            return Fn.Data2Json("SELECT SchemeCategoryID, Category FROM tbl_SchemeCategories where SchemeID = " + schemeID);
        }


        [WebMethod]
        public static string AllCandidates()
        {
            return Fn.Data2Json("SELECT ApplicantID, Name + ' ('  + CNIC + ' )' as Candidate FROM tbl_EstateApplicant order by Name");
        }


    }
}