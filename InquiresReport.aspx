<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="InquiresReport.aspx.cs" Inherits="PSIC.InquiresReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Employee Inquiry Report');

            $(function () {
                $("#txtInquiryDateFrom").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });


            $(function () {
                $("#txtInquiryDateTo").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
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


            //Load Employees Pannel
            InquiryPannelEmployees();
            function InquiryPannelEmployees() {
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
                        $('#ddlInquiryPannel').html(out);
                        $("#ddlInquiryPannel").prev().html($("#ddlInquiryPannel option:selected").text());
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
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.FatherName + '</td> <td> ' + item.CNIC + '</td> <td> ' + item.DepartmentName + '</td> <td> ' + item.Designation + '</td> <td> <button type="button" class="btn btn-link SearchedEmployee" tag="' + item.User_ID + '">Inquiry</button></td> <td> <a href="EmployeeInquiryRpt.aspx?ID=' + item.User_ID + '" target="_blank"   >Report</a></td></tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                    }
                });
            });


            $('#btnAddPannel').bind('click', function () {
                $('#tbInquiryPannel').append('<tr><td> ' + $('#ddlInquiryPannel option:selected').text() + '</td> <td style="width: 50px;">     <img tag="' + $('#ddlInquiryPannel').val() + '" class="clsInquiryPannel" src="Images/cross_circle.png" />     </td> </tr>');
            });


            $('#btnSave').bind('click', function () {
                var InquiryPannel = "";
                $('.clsInquiryPannel').each(function (i, item) {
                    InquiryPannel += $(this).attr('tag') + ',';
                });

                if ($('#txtReason').val() == "") {
                    alert('Please enter reason of inquiry...');
                    return;
                }

                if (InquiryPannel.length == 0) {
                    alert('Please select and add Inquiry Pannel...');
                    return;
                }

                if ($('#txtInquiryDateFrom').val() == "") {
                    alert('Please enter Starting Date of inquiry...');
                    return;
                }

                if ($('#txtInquiryDateTo').val() == "") {
                    alert('Please enter Ending Date of inquiry...');
                    return;
                }


                if ($('#txtResult').val() == "") {
                    alert('Please enter Ending Date of inquiry...');
                    return;
                }



                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "InquiresReport.aspx/SaveData",
                    data: "{'EmpID' : '" + $('#btnSave').attr('tag') + "', 'Reason' : '" + $('#txtReason').val() + "', 'StartingDate' : '" + $('#txtInquiryDateFrom').val() + "', 'EndingDate' : '" + $('#txtInquiryDateTo').val() + "', 'Result': '" + $('#txtResult').val() + "', 'InquiryPannelIDs': '" + InquiryPannel + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#txtReason').val('');
                        $('#txtInquiryDateFrom').val('');
                        $('#txtInquiryDateTo').val('');
                        $('#txtResult').val('');
                        $('.clsInquiryPannel').each(function (i, item) {
                            InquiryPannel += $(this).parent().parent().remove();
                        });
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

        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsInquiryPannel')

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


    <%--Award List--%>

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Inquiry</span>
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
                                <input id="txtReason" type="text" class="txtcs  span4" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Inquiry Date (From)</label>
                                <input id="txtInquiryDateFrom" type="text" class="txtcs  span4" />
                            </div>
                        </div>

                         <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Inquiry Date (To)</label>
                                <input id="txtInquiryDateTo" type="text" class="txtcs  span4" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Result</label>
                                <textarea id="txtResult" cols="20" rows="2" class="span4"></textarea>

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Pannel</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlInquiryPannel" class="txtcs ">
                                    </select>
                                </div>
                                <button type="button" class="btn btn-info span2" id="btnAddPannel">Add</button>
                            </div>
                            <div class="span3" style="margin-left : 0px;"></div>
                            <div class="span4" style="margin-left : 0px;">
                                <table id="tbInquiryPannel" class="responsive table table-striped table-bordered table-condensed">
                                    
                                </table>
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
