using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace PSIC
{
    public partial class MasterPageD : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {

                if (Convert.ToString(Session["UserID"]) == "")
                {
                    Response.Redirect("login.aspx");
                }
                
                if (Convert.ToString(Session["cssmenue"]) == "")
                {
                    string em = Convert.ToString(Session["UserID"]);
                    cssMenu cssmenue = new cssMenu(Convert.ToInt32(Session["UserID"]));
                    Session.Add("cssmenue", cssmenue.main());
                    string ssssssssssss = Convert.ToString(Session["cssmenue"]);

                }
            }

        }

        protected void Page_Unload(object sender, EventArgs e)
        {

        }
    }
}