using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class CreateUserGroups : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string SaveData(string Values) 
        {
            var frmdata = Values;
            string[] d = frmdata.Split('½');

            return Fn.ExenID("INSERT INTO User_Groups (User_Group_Name, Description) VALUES ('" + d[0] + "', '" + d[1] + "'); select scope_identity();");
        }



        [WebMethod]
        public static string AllGroups()
        {
            return Fn.Data2Json("SELECT  row_number() over(order by Priority) as srno, ISNULL(Priority, '') as Priority, User_Group_Id ,User_Group_Name,  ISNULL(Description, '') as Description FROM User_Groups  ");
        }



        [WebMethod]
        public static string UpdateData(string GroupName, string GroupDesc, string GroupId, string Priority)
        {
            return Fn.ExenID("UPDATE User_Groups SET User_Group_Name = '" + GroupName.Trim() + "', Description = '" + GroupDesc.Trim() + "' where User_Group_Id = " + GroupId + " ; select scope_identity(); ");
        }

    }
}