<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="CreateLogin.aspx.cs" Inherits="PSIC.CreateLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Create New Login');


            AllDepartment();
            function AllDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "CreateLogin.aspx/AllDepartments",
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
                    url: "CreateLogin.aspx/AllNonCreatedLoginEmployees",
                    data: "{ 'DeptID' : '" + $('#ddlDepartment') .val() + "'}",
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
                    url: "CreateLogin.aspx/EmployeesEmailUsingID",
                    data: "{ 'UseriD' : '" + $('#ddlEmployee').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        if (jData[0] != undefined) {
                            $('#txtEmail').val(jData[0].Email);
                        }
                        
                    }
                });
            }


            $('#btnSave').bind('click', function () {
                $("*").css("cursor", "wait");

                if ($('#txtPassword').val().trim() == "" && $('#txtCPassword').val().trim() == "") {
                    alert("Password can not be blank");
                    return;
                }


                if ($('#txtPassword').val().trim() != $('#txtCPassword').val().trim()) {
                    alert('Passwords Not matched');
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CreateLogin.aspx/CreateNewLogin",
                    data: "{ 'password' : '" + $('#txtPassword').val() + "' , 'userid' : '" + $('#ddlEmployee').val() + "', 'emailAddress' : '" + $('#txtEmail').val() +"'}",
                    success: function (response) {
                        alert('Login Created Successfully!');
                        $("*").css("cursor", "auto");
                        $('#txtPassword').val('');
                        $('#txtCPassword').val('');
                        AllEmployees();
                        
                    }
                });
            });
        });

    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create Login</span>
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
                                 <input class="span4" id="txtEmail" type="text" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Password</label>
                                 <input class="span4" id="txtPassword" type="password" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Confirm Password</label>
                                 <input class="span4" id="txtCPassword" type="password" />
                            </div>
                        </div>



                        
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button id="btnSave" tag="0" type="button" class="btn btn-primary">Save</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>






</asp:Content>
