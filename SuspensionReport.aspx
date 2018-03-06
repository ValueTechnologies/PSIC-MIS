<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="SuspensionReport.aspx.cs" Inherits="PSIC.SuspensionReport" %>
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
            $('.heading h3').html('Employee Suspension');


            $(function () {
                $("#txtSuspendOn").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });


            $(function () {
                $("#txtContinuanceOn").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
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


            //Suspended by
            SuspendedBy();
            function SuspendedBy() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "InquiresReport.aspx/InquiryPannel",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.User_ID + '> ' + item.Full_Name + '</option>';
                        });
                        $('#ddlSuspendedBy').html(out);
                        $("#ddlSuspendedBy").prev().html($("#ddlSuspendedBy option:selected").text());
                    }
                });
            }



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
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.FatherName + '</td> <td> ' + item.CNIC + '</td> <td> ' + item.DepartmentName + '</td> <td> ' + item.Designation + '</td> <td> <button type="button" class="btn btn-link SearchedEmployee" tag="' + item.User_ID + '">Add Suspension</button></td> <td> <a href="EmployeeSuspensionRpt.aspx?ID=' + item.User_ID + '" target="_blank"   >Report</a></td></tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                    }
                });
            });






            //Save Data

            $('#btnSave').bind('click', function (event) {
                $("*").css("cursor", "wait");
                if ($('#txtReason').val().trim() == "") {
                    alert('Please enter Reason...');
                    return false;
                }
                if ($('#txtSuspendOn').val().trim() == "") {
                    alert('Please enter Suspended Date...');
                    return false;
                }

                if ($('#txtContinuanceOn').val().trim() == "") {
                    alert('Please enter Continuance Date...');
                    return false;
                }

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
                choice.url = "EmployeeSuspensionCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {

                    $('#txtReason').val('');
                    $('#txtSuspendOn').val('');
                    $('#txtContinuanceOn').val('');


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


            //Save Data End






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


    <%--Suspension History--%>

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Suspension</span>
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
                            <div class="span12">
                                <label class="form-label span3" for="normal">Reason</label>
                                <input id="txtReason" type="text" class="txtcs  span4 frmCtrl" />
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Suspended By</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlSuspendedBy" class="frmCtrl">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Suspend On</label>
                                <input id="txtSuspendOn" type="text" class="txtcs  span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Continuance On</label>
                                <input id="txtContinuanceOn" type="text" class="txtcs  span4 frmCtrl" />
                            </div>
                        </div>



                        


                         <div class="form-row row-fluid">

                            <div class="span12">
                                <label class="form-label span3" for="normal">Suspension Letter</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <input id="photoUpload" type="file" onchange="showimagepreview(this);" />
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid" id="dvImage" style="display: none;">
                            <div class="span12">
                                <label class="form-label span3" for="normal" ></label>
                                <img alt="" src="" id="imgprvw" style="width: 150px; height: 150px;" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" class="btn btn-primary" id="btnSave">Save</button>

                            </div>
                        </div>






                    </form>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
