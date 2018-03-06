<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="PSIC.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Change Password');
            $(function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChangePassword.aspx/LoadMyData",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtEmail').val(jData[0].UserName);
                    }
                });
            });




            $('#btnSave').bind('click', function () {
                if ($('#txtOldPassword').val().trim() == "") {
                    alert("Please enter old password");
                    return;
                }

                if ($('#txtNewPassword').val().trim() == "") {
                    alert("Please enter new password");
                    return;
                }

                if ($('#txtConfirmPassword').val().trim() == "") {
                    alert("Please enter confirm password");
                    return;
                }

                if ($('#txtConfirmPassword').val().trim() != $('#txtNewPassword').val().trim()) {
                    alert("New password and confirm password not matched");
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChangePassword.aspx/ChangeMyPassword",
                    data: "{ 'OldPassword' : '" + $('#txtOldPassword').val().trim() + "', 'NewPassword' : '" + $('#txtNewPassword').val().trim() + "', 'Email' : '" + $('#txtEmail').val().trim() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        if (jData > 0) {
                            alert("Password Change Successfully!");
                            $('#txtOldPassword').val('');
                            $('#txtNewPassword').val('');
                            $('#txtConfirmPassword').val('');
                        }

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
                        <span>Change Password</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">User Name</label>
                                <input class="span4" id="txtEmail" type="text"  disabled="disabled" />
                            </div>
                        </div>

                        
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">OldPassword</label>
                                <input class="span4" id="txtOldPassword" type="password"   />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">New Password</label>
                                <input class="span4" id="txtNewPassword" type="password"   />
                            </div>
                        </div>
                        

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Confirm New password</label>
                                 <input class="span4" id="txtConfirmPassword" type="password"   />
                            </div>
                        </div>

                                              
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button id="btnSave" tag="0" type="button" class="btn btn-primary">Change Password</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
