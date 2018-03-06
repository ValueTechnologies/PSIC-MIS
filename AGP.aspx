<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AGP.aspx.cs" Inherits="PSIC.AGP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Assign Pages');

        });
    </script>

    <style type="text/css">
        .button {
            background: #3498db;
            background-image: -webkit-linear-gradient(top, #3498db, #2980b9);
            background-image: -moz-linear-gradient(top, #3498db, #2980b9);
            background-image: -o-linear-gradient(top, #3498db, #2980b9);
            background-image: linear-gradient(to bottom, #3498db, #2980b9);
            -webkit-border-radius: 5;
            -moz-border-radius: 5;
            border-radius: 5px;
            font-family: Arial;
            color: #ffffff;
            font-size: 10px;
            padding: 0px 0px 0px 0px;
            text-decoration: none;
        }

            .button:hover {
                background: #2780b8;
                background-image: -webkit-linear-gradient(top, #2780b8, #3498db);
                background-image: -moz-linear-gradient(top, #2780b8, #3498db);
                background-image: -o-linear-gradient(top, #2780b8, #3498db);
                background-image: linear-gradient(to bottom, #2780b8, #3498db);
                text-decoration: none;
            }

        div.button span {
            text-transform: none;
        }

        div.button {
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="Label1" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Panel ID="Panel_After_Logina" runat="server" Visible="false">
        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="login" Visible="false">Logout</asp:LinkButton>
    </asp:Panel>
    <asp:Panel ID="Panel_After_Loginb" runat="server" Visible="false">
        <strong>
            <asp:Label ID="LabelName" runat="server" Text="" Visible="false"></asp:Label></strong>
    </asp:Panel>










    <table width="100%" border="0" cellspacing="0" cellpadding="0">

        <tr>
            <td>Group Name :&nbsp;</td>
            <td>
                <div class="controls sel" style="width : 300px;">
                    <asp:DropDownList ID="DropDownLisGroupName" runat="server" AutoPostBack="True"
                        CssClass="dropbox" DataSourceID="SqlDataSourceGroupName" DataTextField="User_Group_Name"
                        DataValueField="User_Group_Id" Width="301px">
                    </asp:DropDownList>
                </div>


            </td>
        </tr>
        <tr>
            <td>Module Name :&nbsp;</td>
            <td>
                <div class="controls sel" style="width : 300px;">
                    <asp:DropDownList ID="DropDownListModuleName" runat="server" AutoPostBack="True"
                        CssClass="dropbox" DataSourceID="SqlDataSourceModuleName" DataTextField="Module_Name"
                        DataValueField="Module_ID" Width="301px">
                    </asp:DropDownList>
                </div>
            </td>
        </tr>
        <tr>
            <td>Pages :&nbsp;</td>
            <td>
                <div class="controls sel">
                    <asp:CheckBoxList ID="CheckBoxListPage" runat="server" CssClass="chklist" Style="font-weight: normal;" DataSourceID="SqlDataSourcePageName"
                        DataTextField="Page_Name" DataValueField="Page_ID" RepeatColumns="2" RepeatDirection="Horizontal">
                    </asp:CheckBoxList>
                </div>
            </td>
        </tr>
        <tr>
            <td align="left">&nbsp;</td>
            <td>
                <asp:Button ID="ButtonCheckall" runat="server" CssClass="btn_l" Text="CheckAll" OnClick="ButtonCheckall_Click" />
                <asp:Button ID="ButtonUnCheck" runat="server" CssClass="btn_l" Text="UnCheckAll" OnClick="ButtonUnCheck_Click" />
                <asp:Button ID="Button1" runat="server" CssClass="btn_l" Text="Save" OnClick="Button1_Click"></asp:Button></td>
        </tr>
    </table>






    <br />
    <asp:SqlDataSource ID="SqlDataSourceGroupName" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        SelectCommand="SELECT User_Group_Name, User_Group_Id FROM User_Groups  order by Group_level "></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceModuleName" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        SelectCommand="SELECT [Module_Name], [Module_ID] FROM [Admin_User_Module]
UNION
SELECT 'Individual Pages', 0
 ORDER BY [Module_Id], [Module_Name]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourcePageName" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        SelectCommand="SELECT Page_Name, Page_ID FROM Admin_User_Module_Pages WHERE (Module_ID = @Module_ID)">
        <SelectParameters>
            <asp:ControlParameter ControlID="DropDownListModuleName" Name="Module_ID" PropertyName="SelectedValue" />
        </SelectParameters>

    </asp:SqlDataSource>
    <asp:HiddenField ID="HiddenFieldPageID" runat="server" />
    <asp:SqlDataSource ID="SqlDataSourceDeletePage" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        DeleteCommand="DELETE FROM Admin_Group_Module_Pages WHERE (User_Group_Id = @User_Group_Id) AND (Page_ID = @Page_ID)"
        ProviderName="<%$ ConnectionStrings:PSIC_DBConnectionString.ProviderName %>">
        <DeleteParameters>
            <asp:ControlParameter ControlID="HiddenFieldPageID" Name="Page_ID" PropertyName="Value" />
            <asp:ControlParameter ControlID="DropDownLisGroupName" Name="User_Group_Id" PropertyName="SelectedValue" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceSave" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>"
        InsertCommand="INSERT INTO Admin_Group_Module_Pages(User_Group_Id, Module_ID, Page_ID,Status) VALUES (@User_Group_Id, @Module_ID, @Page_ID,1)"
        ProviderName="<%$ ConnectionStrings:PSIC_DBConnectionString.ProviderName %>" SelectCommand="SELECT Admin_User_Module.Module_Name, Admin_User_Module_Pages.Page_Name, Admin_User_Module_Pages.Page_URL, User_Groups.User_Group_Name, Admin_Group_Module_Pages.ID, Admin_Group_Module_Pages.Page_ID, Admin_Group_Module_Pages.Module_ID, Admin_Group_Module_Pages.User_Group_Id FROM Admin_Group_Module_Pages INNER JOIN Admin_User_Module ON Admin_Group_Module_Pages.Module_ID = Admin_User_Module.Module_Id INNER JOIN Admin_User_Module_Pages ON Admin_Group_Module_Pages.Page_ID = Admin_User_Module_Pages.Page_ID INNER JOIN User_Groups ON Admin_Group_Module_Pages.User_Group_Id = User_Groups.User_Group_Id WHERE (Admin_Group_Module_Pages.User_Group_Id = @User_Group_Id) and (Admin_Group_Module_Pages.Status=1)" DeleteCommand="update Admin_Group_Module_Pages set status=0 WHERE (ID = @ID)">
        <InsertParameters>
            <asp:ControlParameter ControlID="DropDownListModuleName" Name="Module_ID" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="HiddenFieldPageID" Name="Page_ID" PropertyName="Value" />
            <asp:ControlParameter ControlID="DropDownLisGroupName" Name="User_Group_Id" PropertyName="SelectedValue" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="DropDownLisGroupName" Name="User_Group_Id" PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" Name="ID" PropertyName="SelectedValue" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <br />

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        Width="100%" CssClass="abGrid" DataKeyNames="ID"
        DataSourceID="SqlDataSourceSave">
        <Columns>
            <asp:BoundField DataField="Module_Name" HeaderText="Module Name" SortExpression="Module_Name" />
            <asp:BoundField DataField="Page_Name" HeaderText="Page Name" SortExpression="Page_Name" />
            <asp:BoundField DataField="Page_URL" HeaderText="Page URL" SortExpression="Page_URL" />
            <asp:BoundField DataField="User_Group_Name" HeaderText="User Group Name" SortExpression="User_Group_Name" />
            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                SortExpression="ID" Visible="False" />
            <asp:BoundField DataField="Page_ID" HeaderText="Page_ID" SortExpression="Page_ID"
                Visible="False" />
            <asp:BoundField DataField="Module_ID" HeaderText="Module_ID" SortExpression="Module_ID"
                Visible="False" />
            <asp:BoundField DataField="User_Group_Id" HeaderText="User_Group_Id" SortExpression="User_Group_Id"
                Visible="False" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton_Delete" runat="server" CommandName="Delete" ImageUrl="~/images/icon_delete.gif"
                        OnClientClick="return confirmation(this)" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <AlternatingRowStyle CssClass="GridAltItem" />
    </asp:GridView>
    <br />
    <br />
</asp:Content>
