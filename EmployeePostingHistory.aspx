<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EmployeePostingHistory.aspx.cs" Inherits="PSIC.EmployeePostingHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvw').attr('src', e.target.result);
                    $('#dvImage').slideDown(2000);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }


        $(document).ready(function () {
            $('.heading h3').html('Employee Posting History');

            $(function () {
                $("#txtJoiningDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $("#txtPostingEndOnDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });


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

            //Load Without All Department
            LoadDepartmentWithoutAll();
            function LoadDepartmentWithoutAll() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeeRegistration.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DepartmentID + '> ' + item.DepartmentName + '</option>';
                        });
                        $('#ddDeptTo').html(out);
                        $("#ddDeptTo").prev().html($("#ddDeptTo option:selected").text());
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

            //Load Designation Without all
            LoadDesignationWithoutAll();
            function LoadDesignationWithoutAll() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeeRegistration.aspx/AllDesignations",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DesignationID + '> ' + item.Designation + '</option>';
                        });
                        $('#ddDesigTo').html(out);
                        $("#ddDesigTo").prev().html($("#ddDesigTo option:selected").text());
                    }
                });
            }


            ///Posting To 

            getDisttT();
            function getDisttT() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/getlocDistrict",
                    data: "{}",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                        });
                        $('#ddDisttTo').html(out);
                        $('#ddDisttTo').prev().html($('#ddDisttTo option:selected').text());
                        getTehsilT();
                    }
                });
            }
            $("#ddDisttTo").bind('change', function (e) { getTehsilT(); });
            function getTehsilT() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/getlocTehsil",
                    data: "{'TypeID':'" + $('#ddDisttTo').val() + "'}",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                        });
                        $('#ddTehTo').html(out);
                        $('#ddTehTo').prev().html($('#ddTehTo option:selected').text());

                    }
                });
            }

            //posting To end



            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EmployeePostingHistory.aspx/SearchEmployees",
                    data: "{ 'empno' : '" + $('#txtEmpNo').val() + "', 'name' : '" + $('#txtName').val() + "', 'DepartmentID' : '" + $('#ddlDept').val() + "' , 'DesignationID' : '" + $('#ddlDesignation').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.FatherName + '</td> <td> ' + item.CNIC + '</td> <td> ' + item.DepartmentName + '</td> <td> ' + item.Designation + '</td> <td> <button type="button" class="btn btn-link SearchedEmployee" tag="' + item.User_ID + '">Detail </button></td> <td> <a href="EmployeeHistoryRpt.aspx?ID=' + item.User_ID + '" target="_blank"   >Report</a></td></tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                    }
                });
            });




            //Save Data

            $('#btnSave').bind('click', function (event) {
                $("*").css("cursor", "wait");
                
                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });

                ctrlVals += $('#btnSave').attr('tag') + '½';


                var uploadfiles = $("#photoUpload").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "EmployeePostingHistoryCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {
                    
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");




                    $('.frmCtrl').each(function (index, element) {
                        $(this).val('');
                    });


                    $('.filename').html('');
                };
                choice.error = function (err) {
                    alert(err.statusText);
                    event.preventDefault();
                    $("*").css("cursor", "auto");
                };
                $.ajax(choice);
                event.preventDefault();

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


    <style type="text/css">
        FIELDSET {
            margin: 8px;
            border: 1px solid silver;
            padding: 8px;
            border-radius: 4px;
        }

        LEGEND {
            padding: 2px;
            width: 9%;
            border-bottom: 0px solid #e5e5e5;
            font-size: 15px;
            margin-bottom: 0px;
        }
    </style>

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
                                            <th>Report
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


    <%--Posting history--%>

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Posting</span>
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

                        <%--<div class="form-row row-fluid">
                            <div class="span12">
                                <fieldset>
                                    <legend>Posting From</legend>
                                    <div>
                                        <table style="width: 62%; margin-left: 7%;">
                                            <tr>


                                                <td style="width: 65px;">District</td>
                                                <td>
                                                    <select id="ddDisttFrom" style="width: 167px;" class="vl"></select></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td>Tehsil</td>
                                                <td>
                                                    <select id="ddTehFrom" style="width: 150px;"></select></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 65px;">Department</td>
                                                <td>
                                                    <select id="ddDeptFrom" style="width: 167px;" class="vl"></select></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td>Designation</td>
                                                <td>
                                                    <select id="ddDesigFrom" style="width: 150px;"></select></td>
                                            </tr>

                                            <tr>
                                                <td style="width: 65px;">End On</td>
                                                <td>
                                                    <input id="txtPostingEndOnDate" type="text" class="txtcs  " style="width: 97%;"/></td>

                                            </tr>
                                        </table>


                                    </div>

                                </fieldset>
                            </div>

                        </div>--%>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <fieldset>
                                    <legend>Posting To</legend>
                                    <div>
                                        <table style="width: 62%; margin-left: 7%;">
                                            <tr>
                                                <td>District</td>
                                                <td>
                                                    <select id="ddDisttTo" style="width: 167px;" class="vl frmCtrl"></select></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td>Tehsil</td>
                                                <td>
                                                    <select id="ddTehTo" class="frmCtrl" style="width: 150px;"></select></td>
                                            </tr>
                                            <tr>
                                                <td>Department</td>
                                                <td>
                                                    <select id="ddDeptTo" style="width: 167px;" class="vl frmCtrl"></select></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td>Designation</td>
                                                <td>
                                                    <select id="ddDesigTo" style="width: 150px;" class="frmCtrl"></select></td>
                                            </tr>
                                            <tr>
                                                <td>Joining Date</td>
                                                <td>
                                                    <input id="txtJoiningDate" type="text" class="txtcs frmCtrl" style="width: 97%;" />
                                                </td>
                                            </tr>
                                        </table>


                                    </div>

                                </fieldset>
                            </div>

                        </div>


                        <div class="form-row row-fluid">

                            <div class="span6">
                                <label class="form-label span4" for="normal" style="margin-left : 72px; width: 123px;">Joining Letter</label>
                                <input id="photoUpload" type="file" onchange="showimagepreview(this);" />
                            </div>
                        </div>

                        <div class="form-row row-fluid" id="dvImage" style="display: none;">
                            <div class="span6">
                                <label class="form-label span3" for="normal" style="margin-left : 77px;"></label>
                                <img alt="" src="" id="imgprvw" style="width: 150px; height: 150px;" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal" style="margin-left : 72px;"></label>
                                <button type="button" class="btn btn-primary" id="btnSave">Save</button>
                            </div>

                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
