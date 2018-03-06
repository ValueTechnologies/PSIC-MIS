using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class AUM : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //SqlDataSource_Insert.Insert()
            //            TextBox_Name.Text = ""
            //            TextBox_Priority.Text = ""
            //            GridView1.DataBind()

            try
            {
                SqlDataSource_Insert.Insert();
                TextBox_Name.Text = "";
                TextBox_Priority.Text = "";
                GridView1.DataBind();
            }
            catch (Exception ex)
            {

            }
        }

        protected void ImageButton_Edit_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void ImageButton_Delete_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void ImageButton_Cancel_Pannel_Click(object sender, ImageClickEventArgs e)
        {
            Panel_Edit.Visible = false;
        }

        protected void ImageButton_Update_Pannel_Click(object sender, ImageClickEventArgs e)
        {
            SqlDataSource_Insert.Update();
            Panel_Edit.Visible = false;
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Panel_Edit.Visible = true;

            Label mName = (Label)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("Label1"); //GridView1.Rows[GridView1.SelectedIndex].FindControl("Label1")
            TextBox_Panel_Name.Text = mName.Text;

            Label priority = (Label)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("Label2");
            TextBox_Panel_Priority.Text = priority.Text;

            HiddenField_Module_ID.Value =Convert.ToString(GridView1.SelectedValue);
            HiddenField hidd = (HiddenField)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("HiddenField2");
            if (Convert.ToBoolean(hidd.Value) == true)
            {
                RadioButtonList_Panel_ModuleType.SelectedValue = "1";
            }
            else
            {
                RadioButtonList_Panel_ModuleType.SelectedValue = "0";
            }

            HiddenField hidd_Status = (HiddenField)GridView1.Rows[Convert.ToInt32(GridView1.SelectedIndex)].FindControl("HiddenField_Status");
            if (Convert.ToBoolean(hidd_Status.Value))
            { 
                CheckBox_Status.Checked = true; 
            }
            else
            {
                CheckBox_Status.Checked = false;

            }
            //End If



        }
    }
}