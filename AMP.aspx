<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AMP.aspx.cs" Inherits="PSIC.AMP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/validate.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function check(a) {

            if (document.getElementById("TextBox_Page_Name").value == "") {

                alert("Enter Page Name:");

                return false;

            }
            else if (document.getElementById("TextBoxPage_Url").value == "") {

                alert("Enter Page Url:");

                return false;

            }
            else if (document.getElementById("TextBox_Priority").value == "") {

                alert("Enter Priority:");

                return false;

            }
            else {


                return true;
            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="Label1" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Panel ID="Panel_After_Logina" runat="server">
        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="login" Visible="false"></asp:LinkButton></asp:Panel>

    <asp:Panel ID="Panel_After_Loginb" runat="server" Visible="false">
        <asp:Label ID="LabelName" runat="server" Text="" Visible="false"></asp:Label></asp:Panel>






    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_form">
        <tr>
            <td width="40%" align="right">Module Name :&nbsp;</td>
            <td width="60%">
                <asp:DropDownList ID="DropDownListModuleName" runat="server" AutoPostBack="True"
                    CssClass="input_txt" DataSourceID="SqlDataSourceModuleName" DataTextField="Module_Name"
                    DataValueField="Module_ID" Width="201px" OnSelectedIndexChanged="DropDownListModuleName_SelectedIndexChanged">
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td align="right">Page Name :&nbsp;</td>
            <td>
                <asp:TextBox ID="TextBox_Page_Name" runat="server" CssClass="input_txt" Width="200px"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right">Pages Url :&nbsp;</td>
            <td>
                <asp:TextBox ID="TextBoxPage_Url" runat="server" CssClass="input_txt" Width="200px"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right">Priority :&nbsp;</td>
            <td>
                <asp:TextBox ID="TextBox_Priority" runat="server" CssClass="input_txt" MaxLength="5"></asp:TextBox>

                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="TextBox_Priority"
                    ErrorMessage="Enter Valid Priority" ValidationExpression="(\d)*"></asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="Button1" runat="server" CssClass="btn_l" Text="Save" OnClick="Button1_Click"></asp:Button></td>
        </tr>


    </table>
    <br />
    <asp:SqlDataSource ID="SqlDataSourceModuleName" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        SelectCommand="SELECT [Module_Name], [Module_ID] FROM [Admin_User_Module]
UNION
SELECT 'Individual Pages', 0
 ORDER BY [Module_Id], [Module_Name]"
        InsertCommand="INSERT INTO Admin_User_Module_Pages(Module_ID, Page_Name, Page_URL, Priority) VALUES (@Module_ID, @Page_Name, @Page_URL, @Priority)">
        <InsertParameters>
            <asp:ControlParameter ControlID="DropDownListModuleName" Name="Module_ID" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TextBox_Page_Name" Name="Page_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBoxPage_Url" Name="Page_URL" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_Priority" Name="Priority" PropertyName="Text" />
        </InsertParameters>

        <InsertParameters>
            <asp:ControlParameter ControlID="TextBox_Name" Name="Dept_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_Description" Name="Description" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_abb" Name="Dept_Abb" PropertyName="Text" />
            <asp:ControlParameter ControlID="DropDownList_Dept_Type" Name="Dept_Type_Id" PropertyName="SelectedValue" />
        </InsertParameters>

    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceSave" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        InsertCommand="INSERT INTO Admin_User_Module_Pages(Module_ID, Page_Name, Page_URL, Priority,Status) VALUES (@Module_ID, @Page_Name, @Page_URL, @Priority,1)" SelectCommand="SELECT        'Individual Page' AS Module_Name, Page_Name, Page_URL, Page_ID, Priority, Module_ID, Status
FROM            Admin_User_Module_Pages
WHERE        (Module_ID = @Module_ID)"
        DeleteCommand="Update Admin_User_Module_Pages set Status=0 WHERE (Page_ID = @Page_ID)" UpdateCommand="UPDATE Admin_User_Module_Pages SET Page_Name = @Page_Name, Page_URL = @Page_URL, Priority = @Priority, Module_ID = @Module_ID, Status =@Status WHERE (Page_ID = @Page_ID)&#13;&#10;&#13;&#10;update  Admin_Group_Module_Pages set status=0 where  Admin_Group_Module_Pages.Page_id=@Page_id2 and Admin_Group_Module_Pages.Module_Id=@Module_Id2">
        <InsertParameters>
            <asp:ControlParameter ControlID="DropDownListModuleName" Name="Module_ID" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TextBox_Page_Name" Name="Page_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBoxPage_Url" Name="Page_URL" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_Priority" Name="Priority" PropertyName="Text" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="DropDownListModuleName" Name="Module_ID" PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" Name="Page_ID" PropertyName="SelectedValue" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="Panel_TextBox_Page_Name" Name="Page_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="Panel_TextBoxPage_Url" Name="Page_URL" PropertyName="Text" />
            <asp:ControlParameter ControlID="Panel_TextBox_Priority" Name="Priority" PropertyName="Text" />
            <asp:ControlParameter ControlID="Panel_DropDownList_ModuleName" Name="Module_ID"
                PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="CheckBox_Status" Name="Status" PropertyName="Checked" />
            <asp:ControlParameter ControlID="Panel_HiddenField" Name="Page_ID" PropertyName="Value" />
            <asp:ControlParameter ControlID="Panel_HiddenField" Name="Page_id2" PropertyName="Value" />
            <asp:ControlParameter ControlID="Panel_DropDownList_ModuleName" Name="Module_Id2"
                PropertyName="SelectedValue" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        Width="100%" CssClass="abGrid" DataKeyNames="Page_ID"
        DataSourceID="SqlDataSourceSave" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField HeaderText="Module Name" SortExpression="Module_Name">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Module_Name") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Module_Name") %>'></asp:Label>
                    <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("Module_ID", "{0}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Page Name" SortExpression="Page_Name">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Page_Name") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Page_Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Page URL" SortExpression="Page_URL">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Page_URL") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Page_URL") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Page_ID" HeaderText="Page_ID" InsertVisible="False" ReadOnly="True"
                SortExpression="Page_ID" Visible="False" />
            <asp:TemplateField HeaderText="Priority" SortExpression="Priority">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Priority") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Priority") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Module_ID" HeaderText="Module_ID" SortExpression="Module_ID"
                Visible="False" />
            <asp:TemplateField HeaderText="Status" SortExpression="Status">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Status") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Status") %>' Enabled="false" />
                    <asp:HiddenField ID="HiddenField_status" runat="server" Value='<%# Eval("Status", "{0}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:ImageButton ID="ImageButton_Update" runat="server" CommandName="Update" ImageUrl="~/images/icon_ok.gif" />
                    <asp:ImageButton ID="ImageButton_Cancel" runat="server" CommandName="Cancel" ImageUrl="~/images/icon_err.gif" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton_Edit" runat="server" CommandName="Select" ImageUrl="~/images/icon_edit.gif"
                        OnClientClick="return confirmation_edit(this)" OnClick="ImageButton_Edit_Click" />
                    <asp:ImageButton ID="ImageButton_Delete" runat="server" CommandName="Delete" ImageUrl="~/images/icon_delete.gif"
                        OnClientClick="return confirmation(this)" OnClick="ImageButton_Delete_Click" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <AlternatingRowStyle CssClass="GridAltItem" />
    </asp:GridView>
    <br />
    <asp:Panel ID="Panel_Edit" runat="server" Visible="False" CssClass="lightbox_bg">

        <div class="lightbox">
            <asp:ImageButton ID="Panel_ImageButton_Cancel" runat="server" CommandName="Cancel" CssClass="close_btb" ImageUrl="~/images/icon_cancel.gif" CausesValidation="False" OnClick="Panel_ImageButton_Cancel_Click" />
            <ul class="form_one">
                <li>
                    <label>
                        <asp:Label ID="Label_Panel_ModuleName" runat="server" Text="Module Name : "></asp:Label>
                    </label>
                    <asp:DropDownList ID="Panel_DropDownList_ModuleName" runat="server" AutoPostBack="True"
                        CssClass="dropbox" DataSourceID="SqlDataSourceModuleName" DataTextField="Module_Name"
                        DataValueField="Module_ID" Width="201px">
                    </asp:DropDownList>
                </li>
                <li>
                    <label>
                        <asp:Label ID="Label_Panel_PageName" runat="server" Text="Page Name : "></asp:Label>
                    </label>
                    <asp:TextBox ID="Panel_TextBox_Page_Name" runat="server" CssClass="input_txt" Width="200px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Panel_TextBox_Page_Name"
                        Display="Dynamic" ErrorMessage="Enter Page Name"></asp:RequiredFieldValidator>
                </li>
                <li>
                    <label>
                        <asp:Label ID="Label_Panel_Pages_Url" runat="server" Text="Pages Url : "></asp:Label>
                    </label>
                    <asp:TextBox ID="Panel_TextBoxPage_Url" runat="server" CssClass="input_txt" Width="200px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Panel_TextBoxPage_Url"
                        Display="Dynamic" ErrorMessage="Enter Page Url"></asp:RequiredFieldValidator>
                </li>
                <li>
                    <label>
                        <asp:Label ID="Label_Panel_Priority" runat="server" Text="Priority : "></asp:Label>
                    </label>
                    <asp:TextBox ID="Panel_TextBox_Priority" runat="server" CssClass="input_txt" MaxLength="5"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Panel_TextBox_Priority"
                        Display="Dynamic" ErrorMessage="Enter Priority"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="Panel_TextBox_Priority"
                        ErrorMessage="Enter Valid Priority" ValidationExpression="(\d)*" Display="Dynamic"></asp:RegularExpressionValidator>
                </li>
                <li>
                    <label>
                        <asp:Label ID="Label2" runat="server" Text="Status : "></asp:Label>
                    </label>
                    <asp:CheckBox
                        ID="CheckBox_Status" runat="server" />
                </li>
                <li>
                    <label>&nbsp;</label>
                    <asp:HiddenField ID="Panel_HiddenField" runat="server" />
                    <asp:ImageButton ID="Panel_ImageButton_Update" runat="server" CommandName="Update" ImageUrl="~/images/save_btn.png" OnClick="Panel_ImageButton_Update_Click" />
                </li>
            </ul>

        </div>
    </asp:Panel>
    <br />
    <br />

</asp:Content>
