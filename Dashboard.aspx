<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PSIC.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Dashboard');
            LoadGeneralInformation();


            function LoadGeneralInformation() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "Dashboard.aspx/GetGeneralInfo",
                    data: "",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            $('#lblName').html(item.Full_Name);
                            $('#lblContact').html(item.ContactNos);
                            $('#lblEmail').html(item.Email);
                            $('#lblGroup').html(item.User_Group_Name);
                            $('#lblOffice').html(item.OfficeName);
                            $('#lblDesignation').html(item.Designation);
                            $('#lblDepartment').html(item.DepartmentName);
                            $('#lblEmpNo').html(item.EmpNo);

                        });

                    }
                });
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
                        <span>General Information</span>
                    </h4>
                    <a href="http://192.168.1.209/psic1/dvEmployeeInfo" class="minimize" style="display: none;">Minimize</a>
                </div>
                <div class="content" id="dvEmployeeInfo">

                    
                        <div class="form-row row-fluid">
                            <div class="span4">
                                <label class="form-label span5" for="normal" style="font-weight: bold; font-size: 12px;">Emp No :</label>
                                <label id="lblEmpNo" class="form-label span6" for="normal">Emp-004</label>
                            </div>

                            <div class="span8">
                                <label class="form-label span3" for="normal" style="font-weight: bold; font-size: 12px;">Name :</label>
                                <label id="lblName" class="form-label span6" for="normal">Muhammad Shoaib Anjum</label>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span4">
                                <label class="form-label span5" for="normal" style="font-weight: bold; font-size: 12px;">Contact :</label>
                                <label id="lblContact" class="form-label span6" for="normal">3042851958</label>
                            </div>

                            <div class="span8">
                                <label class="form-label span3" for="normal" style="font-weight: bold; font-size: 12px;">Email :</label>
                                <label id="lblEmail" class="form-label span6" for="normal"></label>
                            </div>

                        </div>


                        <div class="form-row row-fluid">
                            <div class="span4">
                                <label class="form-label span5" for="normal" style="font-weight: bold; font-size: 12px;">Group :</label>
                                <label id="lblGroup" class="form-label span5" for="normal">Super Admin</label>
                            </div>

                            <div class="span8">
                                <label class="form-label span3" for="normal" style="font-weight: bold; font-size: 12px;">Office :</label>
                                <label id="lblOffice" class="form-label span6" for="normal">PSIC Head Office, Lahore</label>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span4">
                                <label class="form-label span5" for="normal" style="font-weight: bold; font-size: 12px;">Designation :</label>
                                <label id="lblDesignation" class="form-label span6" for="normal">Assistant Director </label>
                            </div>
                            <div class="span8">
                                <label class="form-label span3" for="normal" style="font-weight: bold; font-size: 12px;">Department :</label>
                                <label id="lblDepartment" class="form-label span6" for="normal">Administration</label>
                            </div>
                        </div>





                    
                </div>
            </div>
        </div>
    </div>
</asp:Content>
