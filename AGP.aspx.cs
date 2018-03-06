using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PSIC
{
    public partial class AGP : System.Web.UI.Page
    {
        String constr = Convert.ToString(ConfigurationManager.ConnectionStrings["PSIC_DBConnectionString"].ConnectionString);
        SqlConnection con = new SqlConnection();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DropDownLisGroupName.DataBind();
                DropDownListModuleName.DataBind();
                GridView1.DataBind();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            try
            {
                for (int i = 0; i <= CheckBoxListPage.Items.Count - 1; i++)
                {
                    if (CheckBoxListPage.Items[i].Selected == true)
                    {
                        HiddenFieldPageID.Value = CheckBoxListPage.Items[i].Value;
                        if (checkAlreadyValue(Convert.ToInt32(CheckBoxListPage.Items[i].Value), Convert.ToInt32(DropDownLisGroupName.SelectedValue)) >= 1)
                        {
                            SqlDataSourceDeletePage.Delete();
                        }
                        SqlDataSourceSave.Insert();
                    }

                    else
                    {
                        HiddenFieldPageID.Value = CheckBoxListPage.Items[i].Value;
                        if (checkAlreadyValue(Convert.ToInt32(CheckBoxListPage.Items[i].Value), Convert.ToInt32(DropDownLisGroupName.SelectedValue)) >= 1)
                        {
                            SqlDataSourceDeletePage.Delete();
                        }
                    }

                }
                GridView1.DataBind();
            }
            catch (Exception ex)
            {

                Response.Write(ex.Message);
            }
        }

        private int checkAlreadyValue(int page_id, int Group_ID)
        {
            try
            {
                con.ConnectionString = constr;
                SqlCommand command = new SqlCommand("SELECT ID FROM Admin_Group_Module_Pages WHERE (Page_ID = @Page_ID) AND (User_Group_Id = @User_Group_Id)", con);
                con.Open();
                command.Parameters.AddWithValue("@Page_ID", page_id);
                command.Parameters.AddWithValue("@User_Group_Id", Group_ID);
                int count = Convert.ToInt32(command.ExecuteScalar());
                con.Close();
                return count;
            }
            catch (Exception ex)
            {

                Response.Write(ex.Message);
                return 0;
            }
        }

        protected void ButtonCheckall_Click(object sender, EventArgs e)
        {
            //    Try
            //    For i As Integer = 0 To CheckBoxListPage.Items.Count - 1
            //        If CheckBoxListPage.Items(i).Selected = False Then
            //            CheckBoxListPage.Items(i).Selected = True
            //        End If
            //    Next
            //Catch ex As Exception

            //End Try
            try
            {
                for (int i = 0; i <= CheckBoxListPage.Items.Count - 1; i++)
                {
                    if (!Convert.ToBoolean(CheckBoxListPage.Items[i].Selected))
                    {
                        CheckBoxListPage.Items[i].Selected = true;
                    }
                }
            }
            catch (Exception ex)
            {

                Response.Write(ex.Message);
            }
        }

        protected void ButtonUnCheck_Click(object sender, EventArgs e)
        {
            try
            {
                for (int i = 0; i < CheckBoxListPage.Items.Count; i++)
                {
                    if (Convert.ToBoolean(CheckBoxListPage.Items[i].Selected))
                    {
                        CheckBoxListPage.Items[i].Selected = false;
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }
        
    }
}