<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="PSIC.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvw').attr('src', e.target.result);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }


        $(document).ready(function () {
            $('.heading h3').html('Edit Profile');
            $(function () {
                $("#txtDOB").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            LoadData();
            function LoadData() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EditProfile.aspx/LoadData",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            $('#txtName').val(item.Full_Name);
                            $('#txtFName').val(item.FatherName);
                            $('#txtCNIC').val(item.CNIC);
                            $('#txtContactNo').val(item.ContactNos);
                            $('#txtEmail').val(item.Email);
                            $('#txtQualification').val(item.Qualification);
                            $('#txtDOB').val(item.DOB);
                            $('#ddlGender').val(item.Is_Male);
                            $('#btnSave').attr('tag', item.User_ID);
                        });
                    }
                });
            }



            $('#btnSave').bind('click', function () {

                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });
                ctrlVals += $('#btnSave').attr('tag') + '½';

                var uploadfiles = $("#fileUpload").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "EditProfileCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");
                    $('#btnSave').attr('tag', result);


                    $('.frmCtrl').each(function (index, element) {
                        $(this).val('');
                    });

                    $('.filename').html('');
                };
                choice.error = function (err) {
                    alert(err.statusText);
                };
                $.ajax(choice);
                event.preventDefault();
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
                        <span>Edit Profile</span>
                    </h4>
                </div>
                <div class="content">
                    <form class="form-horizontal" action="#">


                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal" style="margin-top: 8%;">Profile Picture</label>

                                <img alt="" src="<%= HttpContext.Current.Session["PhotoURL"].ToString()%>" id="imgprvw" style="width: 150px; height: 150px;" />
                                <input type="file" id="fileUpload" class="span3" onchange="showimagepreview(this);" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Name</label>
                                <input id="txtName" type="text" class="txtcs frmCtrl span8" />

                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Father Name</label>
                                <input id="txtFName" type="text" class="txtcs frmCtrl span8" />

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">CNIC</label>
                                <input id="txtCNIC" type="text" class="txtcs frmCtrl span8" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Contact #</label>
                                <input id="txtContactNo" type="text" class="txtcs frmCtrl span8" />

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Email</label>
                                <input id="txtEmail" type="text" class="txtcs frmCtrl span8" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Qualification</label>
                                <input id="txtQualification" type="text" class="txtcs frmCtrl span8" />
                            </div>
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Date Of Birth</label>
                                <input id="txtDOB" type="text" class="txtcs frmCtrl span8" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label class="form-label span3" for="normal">Gender</label>
                                <div class="span8" style="margin-left: 0px;">
                                    <select class="frmCtrl" id="ddlGender">
                                        <option value="1">Male</option>
                                        <option value="0">Female</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span8">
                                <label id="lblT" class="span3"></label>
                                <button id="btnSave" class="btn btn-primary"><span class="icon16 icomoon-icon-checkmark white"></span>Save</button>

                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>






</asp:Content>
