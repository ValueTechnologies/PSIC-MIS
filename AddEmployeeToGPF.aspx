<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AddEmployeeToGPF.aspx.cs" Inherits="PSIC.AddEmployeeToGPF" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;


    <script type="text/javascript">

        $(document).ready(function () {

            $('.heading h3').html('Add Employee(s) to GPF');
            //Load Department
            LoadDepartment();
            function LoadDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DepartmentID + '> ' + item.DepartmentName + '</option>';
                        });
                        $('#ddlDept').html(out);
                        $("#ddlDept").prev().html($("#ddlDept option:selected").text());
                    }
                });
            }



            //Load Designation
            LoadDesignation();
            function LoadDesignation() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/AllDesignations",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DesignationID + '> ' + item.Designation + '</option>';
                        });
                        $('#ddlDesignation').html(out);
                        $("#ddlDesignation").prev().html($("#ddlDesignation option:selected").text());
                    }
                });
            }



            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AddEmployeeToGPF.aspx/SearchEmployees",
                    data: "{ 'empno' : '" + $('#txtEmpNo').val() + "', 'name' : '" + $('#txtName').val() + "', 'DepartmentID' : '" + $('#ddlDept').val() + "' , 'DesignationID' : '" + $('#ddlDesignation').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.FatherName + '</td> <td> ' + item.CNIC + '</td> <td> ' + item.DepartmentName + '</td> <td> ' + item.Designation + '</td> <td> <button type="button" class="btn btn-link SearchedEmployee" tag="' + item.User_ID + '">Detail </button></td> </tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                    }
                });
            });


            $('#btnSave').bind('click', function () {
                if ($('#txtOfficeName').val().trim() == "") {
                    alert('Please enter office name...');
                    return;
                }

                if ($('#txtAccountNo').val().trim() == "") {
                    alert('Please enter account no...');
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AddEmployeeToGPF.aspx/SaveEmployeeToGPF",
                    data: "{ 'OfficeName' : '" + $('#txtOfficeName').val().trim() + "' , 'AccountNo' : '" + $('#txtAccountNo').val().trim() + "', 'EmpID' : '"+ $('#btnSave').attr('tag') +"' }",
                    success: function (response) {
                        $('#txtOfficeName').val('');
                        $('#txtAccountNo').val('');
                        alert('Save Successfully!');

                    }
                });



            });




        });



        //Load EmployeeData
        $('body').on({
            click: function () {
                $('#btnSave').attr('tag', $(this).attr('tag'));

                $('#lblEmpNo').html($(this).parent().prev().prev().prev().prev().prev().prev().html());
                $('#lblName').html($(this).parent().prev().prev().prev().prev().prev().html());
                $('#lblDepartment').html($(this).parent().prev().prev().html());
                $('#lblDesignation').html($(this).parent().prev().html());

            }
        }, ".SearchedEmployee");




    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Employee</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Emp No</label>
                                <input id="txtEmpNo" type="text" class="txtcs  span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Name</label>
                                <input id="txtName" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Department</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlDept" class="txtcs ">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Designation</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlDesignation" class="txtcs ">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" class="btn btn-info" id="btnSearch">Search</button>
                            </div>

                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSearchedEmployees" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo.
                                            </th>
                                            <th>Emp No.
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>Father Name
                                            </th>
                                            <th>CNIC
                                            </th>
                                            <th>Department
                                            </th>
                                            <th>Designation
                                            </th>
                                            <th>Detail
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


    <%--Add Employee to GPF--%>


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Add Employee To GPF</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div style="border-color: rgb(221, 221, 221); border-width: 1px; border-style: solid;">
                                    <table style="width: 100%; background-color: whitesmoke;">
                                        <tr>
                                            <td style="font-weight: bold;">EmpNo : 
                                            </td>
                                            <td>
                                                <label id="lblEmpNo" for="normal"></label>
                                            </td>
                                            <td style="width: 5%;"></td>
                                            <td style="font-weight: bold;">Name : 
                                            </td>
                                            <td>
                                                <label id="lblName" for="normal"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Department : 
                                            </td>
                                            <td>
                                                <label id="lblDepartment" for="normal"></label>
                                            </td>
                                            <td style="width: 5%;"></td>
                                            <td style="font-weight: bold;">Designation : 
                                            </td>
                                            <td>
                                                <label id="lblDesignation" for="normal"></label>
                                            </td>
                                        </tr>

                                    </table>
                                </div>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal" >Office Name</label>
                                <input id="txtOfficeName" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal" >Account No.</label>
                                <input id="txtAccountNo" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal" ></label>
                                <button type="button" class="btn btn-primary" id="btnSave">Save</button>
                            </div>

                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
