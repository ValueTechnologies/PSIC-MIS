using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


namespace PSIC
{
    public partial class Login : System.Web.UI.Page
    {
        private static MyClass fn = new MyClass();

        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
        }

        [WebMethod(EnableSession = true)]
        //[System.Web.Services.WebMethod(EnableSession = true)]
        public static String LoginInfo(string username, string Password)
        {
            string ok = "";
            try
            {
                string strPass = Encryptor.Encrypt(Password);
                
                DataTable DT = fn.FillDSet("sp_Login '" + username + "','" + strPass + "'").Tables[0];

                if (Password == Encryptor.Decrypt(DT.Rows[0][0].ToString()))
                {
                    HttpContext.Current.Session.Add("UserID", DT.Rows[0][1]);
                    HttpContext.Current.Session.Add("theme", DT.Rows[0][3]);
                    HttpContext.Current.Session.Add("username", DT.Rows[0][2]);
                    HttpContext.Current.Session.Add("GroupID", DT.Rows[0][4]);
                    HttpContext.Current.Session.Add("Amonth", DT.Rows[0]["Amonth"]);
                    HttpContext.Current.Session.Add("ShopID", DT.Rows[0]["ShopID"]);
                    var x = HttpContext.Current.Session["ShopID"];
                    HttpContext.Current.Session.Add("OfficeId", DT.Rows[0]["AppointedOfficeId"]);
                    HttpContext.Current.Response.Cookies["UserID"].Value = DT.Rows[0][1].ToString();
                    HttpContext.Current.Response.Cookies["UserID"].Expires = DateTime.Now.AddDays(1);

                    HttpContext.Current.Response.Cookies["theme"].Value = DT.Rows[0][3].ToString();
                    HttpContext.Current.Response.Cookies["theme"].Expires = DateTime.Now.AddDays(1);

                    HttpContext.Current.Response.Cookies["username"].Value = DT.Rows[0][2].ToString();
                    HttpContext.Current.Response.Cookies["username"].Expires = DateTime.Now.AddDays(1);
                    HttpContext.Current.Response.Cookies["Designation"].Value = DT.Rows[0][4].ToString();

                    HttpContext.Current.Response.Cookies["GroupID"].Value = DT.Rows[0][3].ToString();
                    HttpContext.Current.Response.Cookies["GroupID"].Expires = DateTime.Now.AddDays(1);


                    HttpContext.Current.Session.Add("Designation", DT.Rows[0][4]);
                    HttpContext.Current.Session.Add("PhotoURL", DT.Rows[0][5]);
                    ok = "okLogin";
                }
                else
                {
                    ok = "NotokLogin";
                }
            }
            catch(Exception ex)
            {
                ok = "NotokLogin";
            }

            return ok;
        }



    }
}