<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AddEmployeeToShop.aspx.cs" Inherits="PSIC.AddEmployeeToShop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Add Employees To Shop');
            LoadShops();


            $('#btnAddManager').bind('click', function () {
                var str = '<tr><td>' + $('#ddlManager option:selected').text() + ' </td><td style="text-align : center;">Manager </td><td>   <img is_Lead="1" tag="' + $('#ddlManager').val() + '" class="clsTeamMember" src="Images/cross_circle.png" />  </td> </tr>'
                $('#tbShopTeam').prepend(str);
            });

            $('#btnAddOtherMembers').bind('click', function () {
                var str = '<tr><td>' + $('#ddlOtherStaff option:selected').text() + ' </td><td style="text-align : center;">Other Staff </td><td>   <img is_Lead="0" tag="' + $('#ddlOtherStaff').val() + '" class="clsTeamMember" src="Images/cross_circle.png" />  </td> </tr>'
                $('#tbShopTeam').append(str);
            });



            function LoadShops() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CreateNewShop.aspx/LoadShops",
                    data: "{}",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<option value="' + item.ShopID + '">' + item.ShopName + '</option>';
                            });
                            $('#ddlShop').html(Out);
                            LoadEmployee();
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            $('#ddlShop').bind('change', LoadEmployee);

            function LoadEmployee() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AddEmployeeToShop.aspx/GetEmployees",
                    data: "{ 'ShopID' : '" + $('#ddlShop').val() + "'}",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<option value="' + item.EmpID + '">' + item.EmployeeName + '</option>';
                            });
                            $('#ddlManager').html(Out);
                            $('#ddlOtherStaff').html(Out);
                            LoadShopStaff();
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }


            $('#btnSaveProjectTeam').bind('click', function () {
                var EmpID = [], IsManager = [];
                $('.clsTeamMember').each(function (i, item) {
                    EmpID[i] = $(this).attr('tag');
                    IsManager[i] = $(this).attr('is_lead');
                });


                for (var index = 0; index < EmpID.length; index++) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "AddEmployeeToShop.aspx/SaveShopStaff",
                        data: "{ 'ShopID' : '" + $('#ddlShop').val() + "',  'EmpID' : '" + EmpID[index] + "', 'IsManager' : '" + IsManager[index] + "'}",
                        success: function (response) {
                            
                        }
                    });

                    if (index == EmpID.length - 1) {
                        alert('Save Successfully');
                        LoadShopStaff();
                    }
                }


            });


            function LoadShopStaff() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AddEmployeeToShop.aspx/GetStaff",
                    data: "{ 'ShopID' : '" + $('#ddlShop').val() + "'}",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.EmpName + '</td><td style="text-align : left;"> ' + item.ContactNos + ' </td><td  style="text-align : left;"> ' + item.Role + ' </td></tr>';
                            });
                            $('#tbShopsMembersConfirmed tbody').html(Out);
                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });

            }


        });
        //end Ready

        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsTeamMember');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">








    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Shop Staff</span>
                    </h4>
                    <a href="#ShopTeam" class="minimize">Minimize</a>
                </div>
                <div class="content" id="ShopTeam">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Shop</label>
                                <div class="span6 controls sel" style="margin-left: 0px;">
                                    <select id="ddlShop" title="Team Lead " class="nostyle">
                                    </select>
                                </div>
                            </div>

                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Manager</label>
                                <div class="span4 controls sel" style="margin-left: 0px;">
                                    <select id="ddlManager" title="Team Lead " class="nostyle">
                                    </select>
                                </div>
                                <button type="button" id="btnAddManager" class="span2 btn btn-info">Add</button>
                            </div>

                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Other Staff</label>
                                <div class="span4 controls sel" style="margin-left: 0px;">
                                    <select id="ddlOtherStaff" title="Project Other members" class="nostyle">
                                    </select>
                                </div>
                                <button type="button" id="btnAddOtherMembers" class="span2 btn btn-info">Add</button>
                            </div>

                        </div>


                        <div class="form-row row-fluid">
                            <label class="form-label span3" for="normal"></label>
                            <div class="span6" style="margin-left: 0px;">
                                <table id="tbShopTeam" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Name
                                            </th>
                                            <th>Role
                                            </th>
                                            <th style="width: 50px;">Cancel
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <div style="margin-left : 0px;">
                                    <button type="button" id="btnSaveProjectTeam" class="span2 btn btn-primary">Save</button>
                                </div>
                                
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbShopsMembersConfirmed" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th colspan="3">Shop Staff
                                            </th>
                                        </tr>
                                        <tr>
                                            <th>Name
                                            </th>
                                            <th>Contact #
                                            </th>
                                            <th>Role
                                            </th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
