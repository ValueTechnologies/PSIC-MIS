<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AUM.aspx.cs" Inherits="PSIC.AUM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="js/validate.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function check(a) {

            if (document.getElementById("TextBox_Name").value == "") {

                alert("Enter Module Name:");

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
        function grid_onclick() {

        }

        function TABLE1_onclick() {

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_form">
        <tr>
            <td width="40%" align="right">Module Name :&nbsp;</td>
            <td width="60%">
                <asp:TextBox ID="TextBox_Name" runat="server" CssClass="input_txt"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right">Priority :&nbsp;</td>
            <td>
                <asp:TextBox ID="TextBox_Priority" runat="server" CssClass="input_txt" MaxLength="5"></asp:TextBox>

                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="TextBox_Priority"
                    ErrorMessage="Enter Valid Priority" ValidationExpression="(\d)*"></asp:RegularExpressionValidator></td>
        </tr>

        <tr>
            <td align="right">&nbsp;</td>
            <td>
                <asp:Button ID="Button1" runat="server" CssClass="btn_l" Text="Save" OnClick="Button1_Click"></asp:Button></td>
        </tr>
    </table>

    <br />


    <asp:SqlDataSource ID="SqlDataSource_Insert" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>" DeleteCommand="UPDATE Admin_User_Module SET Status = 0 WHERE (Module_Id = @Module_Id)" InsertCommand="INSERT INTO Admin_User_Module(Module_Name, Priority, Moudle_Type, Status) VALUES (@Module_Name, @Priority, @Moudle_Type, @Status)" SelectCommand="SELECT Module_Name, Module_Id, Priority, Moudle_Type,Status FROM Admin_User_Module " UpdateCommand="UPDATE Admin_User_Module SET Module_Name = @Module_Name, Priority = @Priority, Moudle_Type = @Moudle_Type, Status =@Status WHERE (Module_Id = @Module_ID)">
        <DeleteParameters>
            <asp:Parameter Name="Module_Id" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="TextBox_Name" Name="Module_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_Priority" Name="Priority" PropertyName="Text" />
            <asp:ControlParameter ControlID="RadioButtonList1" Name="Moudle_Type" PropertyName="SelectedValue" />
            <asp:Parameter DefaultValue="1" Name="Status" />
        </InsertParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="TextBox_Panel_Name" Name="Module_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="TextBox_Panel_Priority" Name="Priority" PropertyName="Text" />
            <asp:ControlParameter ControlID="RadioButtonList_Panel_ModuleType" Name="Moudle_Type"
                PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="CheckBox_Status" Name="Status" PropertyName="Checked" />
            <asp:ControlParameter ControlID="HiddenField_Module_ID" Name="Module_ID" PropertyName="Value" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        Width="100%" CssClass="abGrid" DataKeyNames="Module_Id"
        DataSourceID="SqlDataSource_Insert" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField HeaderText="Module Name" SortExpression="Module_Name">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Module_Name") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Module_Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Priority" SortExpression="Priority">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Priority") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Priority") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Module_Id" HeaderText="Module_Id" InsertVisible="False"
                ReadOnly="True" SortExpression="Module_Id" Visible="False" />
            <asp:TemplateField HeaderText="Status" SortExpression="Status">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Status") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Status") %>' Enabled="false" />
                    <asp:HiddenField ID="HiddenField_Status" runat="server" Value='<%# Eval("Status", "{0}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <EditItemTemplate>
                    <asp:ImageButton ID="ImageButton_Update" runat="server" CommandName="Update" ImageUrl="~/images/icon_ok.gif" />
                    <asp:ImageButton
                        ID="ImageButton_Cancel" runat="server" CommandName="Cancel" ImageUrl="~/images/icon_err.gif" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton_Edit" runat="server" CommandName="Select" ImageUrl="images/icon_edit.gif"
                        OnClientClick="return confirmation_edit(this)" OnClick="ImageButton_Edit_Click" />

                    <asp:ImageButton ID="ImageButton_Delete"
                        runat="server" CommandName="Delete" ImageUrl="images/icon_delete.gif" OnClientClick="return confirmation(this)" OnClick="ImageButton_Delete_Click" />
                    <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("Moudle_Type", "{0}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <AlternatingRowStyle CssClass="GridAltItem" />
    </asp:GridView>

    <br />

    <asp:Panel ID="Panel_Edit" runat="server" Visible="False" CssClass="lightbox_bg">
        <div class="lightbox">
            <asp:ImageButton ID="ImageButton_Cancel_Pannel" runat="server" CommandName="Cancel" CssClass="close_btb" ImageUrl="~/images/icon_close.gif" CausesValidation="False" OnClick="ImageButton_Cancel_Pannel_Click" />
            <table width="100%" border="0" cellspacing="3" cellpadding="3" id="TABLE1" onclick="return TABLE1_onclick()">
                <tr>
                    <td width="22%" align="right"><strong>
                        <asp:Label ID="Label_Panel_ModuleName" runat="server" Text="Module Name : "></asp:Label>
                    </strong></td>
                    <td width="78%">
                        <asp:TextBox ID="TextBox_Panel_Name" runat="server" CssClass="input_txt"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox_Panel_Name"
                            Display="Dynamic" ErrorMessage="Enter Module Name"></asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <td align="right"><strong>
                        <asp:Label ID="Label_Panel_Priority" runat="server" Text="Priority : "></asp:Label>
                    </strong></td>
                    <td>
                        <asp:TextBox ID="TextBox_Panel_Priority" runat="server" CssClass="input_txt" MaxLength="5"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox_Panel_Priority"
                            Display="Dynamic" ErrorMessage="Enter Priority"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="TextBox_Panel_Priority"
                            ErrorMessage="Enter Valid Priority" ValidationExpression="(\d)*" Display="Dynamic"></asp:RegularExpressionValidator></td>
                </tr>
                <tr>
                    <td align="right"><strong>Status :&nbsp;</strong></td>
                    <td>
                        <asp:CheckBox ID="CheckBox_Status" runat="server" /></td>
                </tr>
                <tr>
                    <td align="right" style="height: 13px">&nbsp;</td>
                    <td style="height: 13px">
                        <asp:ImageButton ID="ImageButton_Update_Pannel" runat="server" CommandName="Update" ImageUrl="images/save_btn.png" OnClick="ImageButton_Update_Pannel_Click" />
                        <asp:Button ID="Button2" runat="server" Text="Button" CausesValidation="False" Visible="false" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                </tr>
            </table>
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:RadioButtonList ID="RadioButtonList_Panel_ModuleType" runat="server" RepeatDirection="Horizontal" Style="font-weight: normal;"
                RepeatLayout="Flow" Visible="False">
                <asp:ListItem Selected="True" Value="0">BeforeLogin</asp:ListItem>
                <asp:ListItem Value="1">AfterLogin</asp:ListItem>
            </asp:RadioButtonList>
            <asp:HiddenField ID="HiddenField_Module_ID" runat="server" />

        </div>
    </asp:Panel>








    <asp:Panel ID="Panel_After_Logina" Visible="false" runat="server">
        <asp:LinkButton ID="LinkButton1" Visible="false" runat="server"></asp:LinkButton></asp:Panel>

    <asp:Label ID="Label1" runat="server" Text="" Visible="false"></asp:Label>

    <asp:Panel ID="Panel_After_Loginb" Visible="false" runat="server">
        <asp:Label ID="LabelName" runat="server" Text="" Visible="false"></asp:Label></asp:Panel>



    <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" Style="font-weight: normal;"
        RepeatLayout="Flow" Visible="False">
        <asp:ListItem Selected="True" Value="0">BeforeLogin</asp:ListItem>
        <asp:ListItem Value="1">AfterLogin</asp:ListItem>
    </asp:RadioButtonList>
    <br />
    <br />
</asp:Content>
