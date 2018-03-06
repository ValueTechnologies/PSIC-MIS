using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class AMP : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            SqlDataSourceSave.Insert();
            TextBox_Page_Name.Text = "";
            TextBox_Priority.Text = "";
            TextBoxPage_Url.Text = "";
            GridView1.DataBind();
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        Panel_Edit.Visible = true;
        Panel_HiddenField.Value =Convert.ToString(GridView1.SelectedValue);
        HiddenField hidd =(HiddenField)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("HiddenField2");
        Panel_DropDownList_ModuleName.SelectedValue = hidd.Value;
        Label page_Name =(Label)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("Label2");
        Panel_TextBox_Page_Name.Text = page_Name.Text;
        Label page_url =(Label) GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("Label3");
        Panel_TextBoxPage_Url.Text = page_url.Text;


        Label priority =(Label) GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("Label4");
        Panel_TextBox_Priority.Text = priority.Text;
        HiddenField hidd_Status  =(HiddenField)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("HiddenField_Status");

        if(Convert.ToBoolean(hidd_Status.Value))
        {
            CheckBox_Status.Checked = true;
        }
        else
        {
            CheckBox_Status.Checked = true;
        }
        
        }

        protected void ImageButton_Edit_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void ImageButton_Delete_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void Panel_ImageButton_Cancel_Click(object sender, ImageClickEventArgs e)
        {
            Panel_Edit.Visible = false;
        }

        protected void Panel_ImageButton_Update_Click(object sender, ImageClickEventArgs e)
        {
            Panel_Edit.Visible = false;
            SqlDataSourceSave.Update();
        }

        protected void DropDownListModuleName_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropDownListModuleName.SelectedValue=="0")
            {
                SqlDataSourceSave.SelectCommand = @"SELECT        'Individual Page' AS Module_Name, Page_Name, Page_URL, Page_ID, Priority, Module_ID, Status
FROM            Admin_User_Module_Pages
WHERE        (Module_ID = @Module_ID)";
            }
            else
            {
                SqlDataSourceSave.SelectCommand = "SELECT Admin_User_Module.Module_Name, Admin_User_Module_Pages.Page_Name, Admin_User_Module_Pages.Page_URL, Admin_User_Module_Pages.Page_ID, Admin_User_Module_Pages.Priority, Admin_User_Module_Pages.Module_ID, Admin_User_Module_Pages.Status FROM Admin_User_Module INNER JOIN Admin_User_Module_Pages ON Admin_User_Module.Module_Id = Admin_User_Module_Pages.Module_ID WHERE (Admin_User_Module_Pages.Module_ID = @Module_ID)";
            }
        }
    }
}