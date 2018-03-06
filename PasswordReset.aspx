<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="PasswordReset.aspx.cs" Inherits="PSIC.PasswordReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">    
        $(document).ready(function () {
            $('.heading h3').html('Reset Password');

            AllDepartment();
            function AllDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PasswordReset.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.DepartmentID + '">' + item.DepartmentName + '</option>';
                        });
                        $('#ddlDepartment').html(out);
                        $('#ddlDepartment').prev().html($('#ddlDepartment option:selected').text());
                        AllEmployees();
                    }
                });
            }

            $('#ddlDepartment').bind('change', function () {
                AllEmployees();
            });


            function AllEmployees() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PasswordReset.aspx/AllEmployees",
                    data: "{ 'DeptID' : '" + $('#ddlDepartment').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.User_ID + '">' + item.Full_Name + '</option>';
                        });
                        $('#ddlEmployee').html(out);
                        $('#ddlEmployee').prev().html($('#ddlEmployee option:selected').text());
                        EmployeeEmailByID();
                    }
                });
            }

            $('#ddlEmployee').bind('change', function () {
                EmployeeEmailByID();
            });


            function EmployeeEmailByID() {
                $('#txtEmail').val('');
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PasswordReset.aspx/EmployeesEmailUsingID",
                    data: "{ 'UseriD' : '" + $('#ddlEmployee').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        if (jData[0] != undefined) {
                            $('#txtEmail').val(jData[0].UserName);
                        }

                    }
                });
            }


            $('#btnSave').bind('click', function () {
                $("*").css("cursor", "wait");

                if ($('#txtEmail').val() == '') {
                    alert('Username Required!');
                    return false;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PasswordReset.aspx/ForgotPassword",
                    data: "{  'userid' : '" + $('#ddlEmployee').val() + "', 'emailAddress' : '" + $('#txtEmail').val() + "', 'password' : '" + $('#txtPassword').val() + "' s}",
                    success: function (response) {
                        alert('Password changed successfully!');
                        $("*").css("cursor", "auto");

                    }
                });
            });

            $('#txtCPassword').bind('keyup', MatchPasswords);
            $('#txtCPassword').on('focus', MatchPasswords);

            function MatchPasswords() {
                if ($('#txtCPassword').val() != $('#txtPassword').val()) {
                    $('#errMPass').html('* Both passwords should be identical.');
                    $('#btnSave').attr('disabled', 'disabled');
                }
                else {
                    $('#errMPass').html('');
                    $('#btnSave').removeAttr('disabled');
                }
            }

        });
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Reset User Password</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                                                
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Department</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlDepartment" class="frmCtrl">
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Employee</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlEmployee" class="frmCtrl">
                                    </select>
                                </div>
                            </div>
                        </div>
                        

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Username</label>
                                 <input class="span4" id="txtEmail" type="text" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">New Password</label>
                                 <input class="span4" id="txtPassword" type="password" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Confirm Password</label>
                                 <input class="span4" id="txtCPassword" type="password" /><p id="errMPass" style="color:red;"></p>
                            </div>
                        </div>
                                              
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button id="btnSave" tag="0" type="button" class="btn btn-primary">Reset Password</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
