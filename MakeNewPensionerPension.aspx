<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="MakeNewPensionerPension.aspx.cs" Inherits="PSIC.MakeNewPensionerPension" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Make Pensioner Pension');

            $('#txtBasicPay').numeric();
            $('#txtCashablePercentage').numeric();
            $('#txtMedicalAllowance').numeric();

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


            //Load Pension Type
            LoadPensionType();
            function LoadPensionType() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "MakeNewPensionerPension.aspx/LoadPensionType",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.PensionTypeID + '> ' + item.PensionType + '</option>';
                        });
                        $('#ddlPensionType').html(out);
                    }
                });
            }



            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "MakeNewPensionerPension.aspx/SearchEmployees",
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

                if ($('#txtDOA').val().trim() == "") {
                    alert('Please enter Date of appointment...');
                    return;
                }

                if ($('#txtDOB').val().trim() == "") {
                    alert('Please enter Date of birth...');
                    return;
                }

                if ($('#txtDOR').val().trim() == "") {
                    alert('Please enter Date of retirement...');
                    return;
                }

                if ($('#txtTotalHolidaysInService').val().trim() == "") {
                    alert('Please enter total holidays in service...');
                    return;
                }


                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });
                ctrlVals += $('#btnSave').attr('tag') + '½';




                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "MakeNewPensionerPension.aspx/SaveData",
                    data: "{ 'Vals' : '" + ctrlVals + "'  }",
                    success: function (response) {

                        alert(response.d);
                        $('.frmCtrl').each(function (index, element) {
                            $(this).val('');
                        });
                    }
                });


            });


            $('#txtBasicPay').live('keyup', function () {
                var serviceYears = 0;
                var basiPay = parseInt($('#txtBasicPay').val(), 10);

                if (parseInt($('#txtNetQualifyingServiceM').val(), 10) >= 6) {
                    serviceYears = parseInt($('#txtNetQualifyingServiceY').val(), 10) + 1;
                }
                else {
                    serviceYears = parseInt($('#txtNetQualifyingServiceY').val(), 10);
                }

                if (serviceYears > 30) {
                    serviceYears = 30;
                }

                var GrossPension = (basiPay * serviceYears * 7) / 300;
                GrossPension = Math.round(GrossPension).toFixed(2);
                $('#txtGrossPension').val(GrossPension);
                $('#txtMonthlyPension').val(Math.round(GrossPension * 0.65).toFixed(2));

                var Commutation = (GrossPension * 0.35);
                var TotalCommutation = Commutation * 12 * $('#txtAgeRate').val();
                Commutation = Math.round(Commutation).toFixed(2);
                TotalCommutation = Math.round(TotalCommutation).toFixed(2);
                $('#txtCommutation').val(Commutation);
                $('#txtTotalCommutation').val(TotalCommutation);
                $('#txtCashablePercentage').val('');
                $('#txtCashableAmount').val('');
            });


            $('#txtCashablePercentage').live('keyup', function () {
                var monthlyPension = parseFloat($('#txtMonthlyPension').val());
                var Percentage = parseFloat($('#txtCashablePercentage').val());

                $('#txtCashableAmount').val(Math.round((monthlyPension * Percentage) / 100).toFixed(2));
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
                LoadEmpPreviousData($(this).attr('tag'));
            }
        }, ".SearchedEmployee");



        function LoadEmpPreviousData(empid) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "MakeNewPensionerPension.aspx/LoadEmpPreviousData",
                data: "{ 'EmpID' : '" + empid + "'}",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        $('#txtDOA').val(item.DOA);
                        $('#txtDOB').val(item.DOB);
                        $('#txtDOR').val(item.DateOfRetirement);
                        $('#txtTotalAgeY').val(item.TotalAgeAtRetirementY);
                        $('#txtTotalAgeM').val(item.TotalAgeAtRetirementM);
                        $('#txtTotalAgeD').val(item.TotalAgeAtRetirementD);
                        $('#txtTotalServicesY').val(item.TotalServiceY);
                        $('#txtTotalServicesM').val(item.TotalServiceM);
                        $('#txtTotalServicesD').val(item.TotalServiceD);
                        $('#txtTotalHolidaysInService').val(item.TotalHolidays);
                        $('#txtNetQualifyingServiceY').val(item.NetQualifyingServiceY);
                        $('#txtNetQualifyingServiceM').val(item.NetQualifyingServiceM);
                        $('#txtNetQualifyingServiceD').val(item.NetQualifyingServiceD);
                        $('#txtAgeNextBirthday').val(item.AgeNextBirthdays);
                        $('#txtAgeNextBirthday').val(item.AgeNextBirthdays);
                        $('#txtAgeRate').val(item.AgeRate);
                        
                    });

                }
            });
        }




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
                    <a href="dvSearchEmployees" class="minimize"></a>
                </div>
                <div class="content" id="dvSearchEmployees">

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
                                <div class="span7 controls sel" style="margin-left: 0px;">
                                    <select id="ddlDept" class="txtcs nostyle">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Designation</label>
                                <div class="span7 controls sel" style="margin-left: 0px;">
                                    <select id="ddlDesignation" class="txtcs nostyle">
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






    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Calculate Pensioner Pension</span>
                    </h4>
                    <a href="dvPensionCalculation" class="minimize"></a>
                </div>
                <div class="content" id="dvPensionCalculation">

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
                                <label class="form-label span5" for="normal">Date Of Appointment</label>
                                <input id="txtDOA" type="text" class="txtcs  span7" disabled="disabled" />
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">Date Of Birth.</label>
                                <input id="txtDOB" type="text" class="txtcs  span7" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Date Of Retirement.</label>
                                <input id="txtDOR" type="text" class="txtcs  span7" disabled="disabled" />
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">Total Age</label>
                                <input id="txtTotalAgeY" type="text" class="txtcs  span2" disabled="disabled" />Y&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtTotalAgeM" type="text" class="txtcs  span2" disabled="disabled" />M&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtTotalAgeD" type="text" class="txtcs  span2" disabled="disabled" />D
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Total Services</label>
                                <input id="txtTotalServicesY" type="text" class="txtcs  span2" disabled="disabled" />Y&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtTotalServicesM" type="text" class="txtcs  span2" disabled="disabled" />M&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtTotalServicesD" type="text" class="txtcs  span2" disabled="disabled" />D
                            </div>

                            <div class="span6">
                                <label class="form-label span5" for="normal">Total Holidays (in Days)</label>
                                <input id="txtTotalHolidaysInService" type="text" class="txtcs  span7" disabled="disabled" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Net Qualifying Service</label>
                                <input id="txtNetQualifyingServiceY" type="text" class="txtcs  span2" disabled="disabled" />Y&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtNetQualifyingServiceM" type="text" class="txtcs  span2" disabled="disabled" />M&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtNetQualifyingServiceD" type="text" class="txtcs  span2" disabled="disabled" />D
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">Age Next Birthday</label>
                                <input id="txtAgeNextBirthday" type="text" class="txtcs  span7" disabled="disabled" />
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Rate Of Commutation</label>
                                <input id="txtAgeRate" type="text" class="txtcs frmCtrl span7" disabled="disabled" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Basic Pay</label>
                                <input id="txtBasicPay" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Gross Pension</label>
                                <input id="txtGrossPension" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                            <div class="span6">
                                <label class="form-label span12" for="normal" style="text-align : left;">Gross Pension = BasicPay x Service Years x 7 / 300</label>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Monthly Pension</label>
                                <input id="txtMonthlyPension" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                            <div class="span6">
                                <label class="form-label span12" for="normal"style="text-align : left;">Monthly Pension = Gross Pension x 65%</label>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Commutation</label>
                                <input id="txtCommutation" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                            <div class="span6">
                                <label class="form-label span12" for="normal"style="text-align : left;">Commutation = Gross Pension x 35%</label>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Total Commutation</label>
                                <input id="txtTotalCommutation" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Pension Type</label>
                                <div class="span7 controls sel">
                                    <select id="ddlPensionType" class="nostyle frmCtrl">

                                    </select>
                                </div>

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Cashable Percentage</label>
                                <input id="txtCashablePercentage" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Cashable Amount</label>
                                <input id="txtCashableAmount" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                            <div class="span6">
                                <label class="form-label span12" for="normal">Cashable Amount = Gross Pension x Cashable Percentage / 100</label>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Medical Allowance</label>
                                <input id="txtMedicalAllowance" type="text" class="txtcs frmCtrl span7"  />
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal"></label>
                                <div style="margin-left: 0px;">
                                    <button type="button" class="btn btn-primary span2" id="btnSave">Save</button>
                                </div>

                            </div>

                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>





</asp:Content>
