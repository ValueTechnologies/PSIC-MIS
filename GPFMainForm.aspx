<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="GPFMainForm.aspx.cs" Inherits="PSIC.GPFMainForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        function showimagepreviewAdvance(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvwAdvance').attr('src', e.target.result);
                    $('#dvImageAdvance').slideDown(2000);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }


        function showimagepreviewDeposit(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvwDeposit').attr('src', e.target.result);
                    $('#dvImageDeposit').slideDown(2000);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }

        function showimagepreviewInsurance(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvwInsurance').attr('src', e.target.result);
                    $('#dvImageInsurance').slideDown(2000);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }



        $(document).ready(function () {
            $('.heading h3').html('General Provident Fund');

            $(function () {
                $('#txtAdvanceRequestDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $('#txtDepositDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });


            $(function () {
                $('#txtInstallmentDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
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



            //Record Year
            RecordYearList();
            function RecordYearList() {
                var currentYear = (new Date).getFullYear(), Out = "<option value='0'>Current Year</option>";
                for (var year = currentYear; year >= 1947; year--) {
                    Out = Out + '<option value="' + year + '">' + year + '</option>';
                }

                $('#ddlRecordYear').html(Out);
                $("#ddlRecordYear").prev().html($("#ddlRecordYear option:selected").text());

            }


            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "GPFMainForm.aspx/SearchEmployees",
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


            //Advances 
            $('#btnSaveNewAdvance').bind('click', function () {
                $("*").css("cursor", "wait");
                if ($('#txtAdvanceRequestDate').val().trim() == "") {
                    alert('Please enter Advance Request Date...');
                    return false;
                }
                if ($('#txtRequestForGPFAdvance').val().trim() == "") {
                    alert('Please Enter Advance Request...');
                    return false;
                }

                if ($('#txtGPFOwnContribution').val().trim() == "") {
                    alert('Please enter Own Contribution...');
                    return false;
                }
                if ($('#txtEntitlementOfAdvance').val().trim() == "") {
                    alert('Please enter Entitlement Of Advance...');
                    return false;
                }

                if ($('#txtAdvanceRecommended').val().trim() == "") {
                    alert('Please enter Advance Recommended...');
                    return false;
                }

                var ctrlVals = "";
                $('.frmCtrlAdvance').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });


                ctrlVals += $('#btnSaveNewAdvance').attr('tag') + '½';


                var uploadfiles = $("#photoUploadAdvance").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "GPFAdvanceCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {

                    $('#txtAdvanceRequestDate').val('');
                    $('#txtRequestForGPFAdvance').val('');
                    $('#txtGPFOwnContribution').val('');
                    $('#txtEntitlementOfAdvance').val('');
                    $('#txtAdvanceRecommended').val('');

                    CurruntYearAdvances();
                    SaveProfit();
                    LoadBalanceStatuses();
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");



                    $('#imgprvwAdvance').attr('src', '');
                    $('.frmCtrlAdvance').each(function (index, element) {
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

            //End Advances

            //Deposit
            $('#btnSaveNewDeposit').bind('click', function () {
                $("*").css("cursor", "wait");
                if ($('#txtDepositDate').val().trim() == "") {
                    alert('Please enter Deposit Date...');
                    return false;
                }
                if ($('#txtDeposit').val().trim() == "") {
                    alert('Please Enter Deposit...');
                    return false;
                }

                var ctrlVals = "";
                $('.frmCtrlDeposti').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });


                ctrlVals += $('#btnSaveNewDeposit').attr('tag') + '½';


                var uploadfiles = $("#photoUploadDeposit").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "GPFDepositCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {

                    $('#txtDepositDate').val('');
                    $('#txtDeposit').val('');

                    CurruntYearDeposits();
                    SaveProfit();
                    LoadBalanceStatuses();
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");



                    $('#imgprvwDeposit').attr('src', '');
                    $('.frmCtrlDeposti').each(function (index, element) {
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

            //end Deposit


            //Insurance Installments

            $('#btnSaveNewInsurance').bind('click', function () {
                $("*").css("cursor", "wait");
                if ($('#txtInstallmentDate').val().trim() == "") {
                    alert('Please enter Installment Date...');
                    return false;
                }
                if ($('#txtInsuranceInstallmentAmount').val().trim() == "") {
                    alert('Please Enter Insurance Installments Amount...');
                    return false;
                }

                var ctrlVals = "";
                $('.frmCtrlInsuInstallment').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });


                ctrlVals += $('#btnSaveNewInsurance').attr('tag') + '½';


                var uploadfiles = $("#photoUploadInsurance").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "InsuranceInstallmentCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {

                    $('#txtInstallmentDate').val('');
                    $('#txtInsuranceInstallmentAmount').val('');

                    CurruntYearInsuInstallments();
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");



                    $('#imgprvwInsurance').attr('src', '');
                    $('.frmCtrlInsuInstallment').each(function (index, element) {
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

            //End Insurance Installments




        });




        //Load EmployeeData
        $('body').on({
            click: function () {
                $('#btnSaveNewAdvance').attr('tag', $(this).attr('tag'));
                CurruntYearAdvances();
                $('#btnSaveNewDeposit').attr('tag', $(this).attr('tag'));
                CurruntYearDeposits();
                $('#btnSaveNewInsurance').attr('tag', $(this).attr('tag'));
                CurruntYearInsuInstallments();
                $('#btnSaveContributionRecovery').attr('tag', $(this).attr('tag'));
                LoadPreviousGPFOwnContribution();
                LoadPreviousGPFRecovery();
                LoadBalanceStatuses();



                $('#lblEmpNO').html($(this).parent().prev().prev().prev().prev().prev().prev().html());
                $('#lblSearchedName').html($(this).parent().prev().prev().prev().prev().prev().html());
                $('#lblDepartment').html($(this).parent().prev().prev().html());
                $('#lblDesignation').html($(this).parent().prev().html());

            }
        }, ".SearchedEmployee");



        //Save GPF Monthly Data
        $('body').on({
            click: function () {

                $('.clsContribution').each(function () {
                    var amount = $(this).val();
                    var month = $(this).attr('tag');
                    var id = $('#btnSaveContributionRecovery').attr('tag');

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "GPFMainForm.aspx/GPFOwnContributionSave",
                        data: "{ 'Month' : '" + month + "', 'EmpID' : '" + id + "', 'ContributionAmount' : '" + amount + "'}",
                        success: function (response) {

                        }
                    });
                });

                $('.clsARecovery').each(function () {
                    var amount = $(this).val();
                    var month = $(this).attr('tag');
                    var id = $('#btnSaveContributionRecovery').attr('tag');

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "GPFMainForm.aspx/GPFOwnRecoverySave",
                        data: "{ 'Month' : '" + month + "', 'EmpID' : '" + id + "', 'RecoveryAmount' : '" + amount + "'}",
                        success: function (response) {

                        }
                    });
                });

                alert('Save Successfully!');
                SaveProfit();
                LoadBalanceStatuses();
            }
        }, '#btnSaveContributionRecovery');



        function CurruntYearAdvances() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "GPFMainForm.aspx/ThisYearAdvances",
                data: "{ 'EmpID' : '" + $('#btnSaveNewAdvance').attr('tag') + "' }",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        out = out + '<tr><td>' + item.SrNo + ' </td> <td>' + item.AdvanceDate + ' </td><td>' + item.AdvanceRequest + ' </td><td> ' + item.OwnContribution + '</td><td>' + item.EntitlementOfAdvance + ' </td><td>' + item.AdvanceRecommended + ' </td></tr>';
                    });
                    $('#tbAdvancesCurruntYear tbody').html(out);
                    
                }
            });
        }


        function CurruntYearDeposits() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "GPFMainForm.aspx/ThisYearDeposits",
                data: "{ 'EmpID' : '" + $('#btnSaveNewDeposit').attr('tag') + "' }",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        out = out + '<tr><td>' + item.SrNo + ' </td> <td>' + item.DepostiDate + ' </td><td>' + item.DepositAmount + ' </td></tr>';
                    });
                    $('#tbDepositCurruntYear tbody').html(out);
                    
                }
            });
        }


        function CurruntYearInsuInstallments() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "GPFMainForm.aspx/ThisYearInsuInstallments",
                data: "{ 'EmpID' : '" + $('#btnSaveNewInsurance').attr('tag') + "' }",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        out = out + '<tr><td>' + item.SrNo + ' </td> <td>' + item.InstallmentDate + ' </td><td>' + item.InstallmentAmount + ' </td></tr>';
                    });
                    $('#tbInsuranceCurruntYear tbody').html(out);
                    
                }
            });
        }


        function LoadPreviousGPFOwnContribution() {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "GPFMainForm.aspx/LoadPreviousGPFOwnContribution",
                data: "{ 'EmpID' : '" + $('#btnSaveContributionRecovery').attr('tag') + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d);

                    $.each(jData, function (i, item) {
                        $('.clsContribution').each(function (ii, ctrlItem) {
                            if ($(this).attr('tag') == item.ContributionDate) {
                                $(this).val(item.Amount);

                            }
                        });

                    });
                }
            });


        }


        function LoadPreviousGPFRecovery() {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "GPFMainForm.aspx/LoadPreviousGPFRecovery",
                data: "{ 'EmpID' : '" + $('#btnSaveContributionRecovery').attr('tag') + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d);

                    $.each(jData, function (i, item) {
                        $('.clsARecovery').each(function (ii, ctrlItem) {
                            if ($(this).attr('tag') == item.ContributionDate) {
                                $(this).val(item.Amount);

                            }
                        });

                    });
                }
            });


        }


        function LoadBalanceStatuses() {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "GPFMainForm.aspx/BalanceStatuses",
                data: "{ 'EmpID' : '" + $('#btnSaveContributionRecovery').attr('tag') + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d);
                    $('#lblGPFForTheYear').html(jData[0].CurruntYearGPF);
                    $('#lblOpeningBalance').html(jData[0].PreviousGPF);
                    $('#lblNetGPF').html(jData[0].netGPF);
                    $('#lblTotalRecovery').html(jData[0].CurruntYearRecovery);
                    $('#lblOpeningAdvance').html(jData[0].PreviousAdvanceBalance);
                    $('#lblTotalAdvance').html(jData[0].TotalAdvanceBalance); 
                    $('#lblTotalGPF').html(jData[0].GrandTotalGPF);
                    $('#txtProfitRate').attr('tag', jData[0].netGPF);
                    $('#lblAccountNo').html(jData[0].AccountNo);
                    $('#lblNameOfOffice').html(jData[0].OfficeName);
                    $('#txtProfitRate').val(jData[0].ProfitRate);
                    var valRate = parseFloat($('#txtProfitRate').val()), ValnetGPF = parseFloat($('#txtProfitRate').attr('tag'));

                    $('#lblProfitOfTheYear').html((ValnetGPF / 100) * valRate);
                }
            });
        }

        $('body').on({
            click: function () {

                SaveProfit();


            }
        }, '#btnSaveGPFProfit');


        function SaveProfit() {
            if ($('#txtProfitRate').val().trim() == "") {
                
                return;
            }

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "GPFMainForm.aspx/GPFProfitSave",
                data: "{ 'EmpID' : '" + $('#btnSaveContributionRecovery').attr('tag') + "', 'NetGPF' : '" + $('#txtProfitRate').attr('tag') + "', 'ProfitRate' : '" + $('#txtProfitRate').val() + "'}",
                success: function (response) {
                    alert('Save Successfully!');
                }
            });
        }
        $('body').on({
            change: function () {
                var valRate = parseFloat($('#txtProfitRate').val()), ValnetGPF = parseFloat($('#txtProfitRate').attr('tag'));

                $('#lblProfitOfTheYear').html((ValnetGPF / 100) * valRate);
            }
        }, '#txtProfitRate');



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
                    <a href="dvSearchEmployees" class="minimize">Minimize</a>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#" id="dvSearchEmployees">
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



    <%--GPF Detail--%>


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee General Provident Fund</span>
                    </h4>
                    <a href="dvGPF" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvGPF">
                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Name</label>
                                <label class="form-label span4" for="normal" id="lblSearchedName">.................</label>
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">Emp.No</label>
                                <label class="form-label span4" for="normal" id="lblEmpNO">.................</label>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Department</label>
                                <label class="form-label span4" for="normal" id="lblDepartment">.................</label>
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">Designation</label>
                                <label class="form-label span4" for="normal" id="lblDesignation">.................</label>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Name Of Office</label>
                                <label class="form-label span4" for="normal" id="lblNameOfOffice">.................</label>
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">A/C No.</label>
                                <label class="form-label span4" for="normal" id="lblAccountNo">.................</label>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Opening Balance</label>
                                <label class="form-label span4" for="normal" id="lblOpeningBalance">.................</label>
                            </div>
                            <div class="span6">
                                <label class="form-label span5" for="normal">B/F Advance</label>
                                <label class="form-label span4" for="normal" id="lblOpeningAdvance">.................</label>
                            </div>
                        </div>



                        <%--                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Year</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlRecordYear">
                                    </select>
                                </div>
                            </div>

                        </div>--%>




                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>

                            </div>
                        </div>







                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div style="margin-bottom: 20px;">
                                    <ul id="TabAdvInsDep" class="nav nav-tabs pattern">
                                        <li class="active"><a href="#dvContributionRecovery" data-toggle="tab">GPF Contribution And Recovery</a></li>
                                        <li class=""><a href="#dvAdvance" data-toggle="tab">Advance</a></li>
                                        <li class=""><a href="#dvInsurance" data-toggle="tab">Insurance</a></li>
                                        <li class=""><a href="#dvDeposit" data-toggle="tab">Deposit</a></li>
                                    </ul>

                                    <div class="tab-content">
                                        <div class="tab-pane fade active in" id="dvContributionRecovery">
                                            <div class="form-row row-fluid">
                                                <div class="span12">

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <table class="responsive table table-striped table-bordered table-condensed">
                                                                <thead>
                                                                    <tr>
                                                                        <th colspan="2" style="text-align: center;">GPF OWN CONTRIBUTION
                                                                        </th>
                                                                        <th colspan="2">MONTHLY RECOVERY OF ADVANCE
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <th style="text-align: left;">Month
                                                                        </th>
                                                                        <th>Contribution
                                                                        </th>
                                                                        <th style="text-align: left;">Month
                                                                        </th>
                                                                        <th>Recovery
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: left;">July
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtJulyContribution" type="text" tag="07" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">July
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtJulyARecovery" type="text" tag="07" value="0" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left;">August
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtAugustContribution" type="text" tag="08" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">August
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtAugustARecovery" type="text" tag="08" value="0" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left;">September
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtSeptemberContribution" type="text" tag="09" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">September
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtSeptemberARecovery" type="text" tag="09" value="0" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left;">October
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtOctoberContribution" type="text" tag="10" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">October
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtOctoberARecovery" type="text" tag="10" value="0" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left;">November
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtNovemberContribution" type="text" tag="11" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">November
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtNovemberARecovery" type="text" tag="11" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">December
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtDecemberContribution" type="text" tag="12" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">December
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtDecemberARecovery" type="text" tag="12" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">January
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtJanuaryContribution" type="text" tag="01" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">January
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtJanuaryARecovery" type="text" tag="01" value="0" />
                                                                        </td>
                                                                    </tr>


                                                                    <tr>
                                                                        <td style="text-align: left;">February
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtFebruaryContribution" type="text" tag="02" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">February
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtFebruaryARecovery" type="text" tag="02" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">March
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtMarchContribution" type="text" tag="03" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">March
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtMarchARecovery" type="text" tag="03" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">April
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtAprilContribution" type="text" tag="04" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">April
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtAprilARecovery" type="text" tag="04" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">May
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtMayContribution" type="text" tag="05" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">May
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtMayARecovery" type="text" tag="05" value="0" />
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td style="text-align: left;">June
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsContribution" id="txtJuneContribution" type="text" tag="06" value="0" />
                                                                        </td>
                                                                        <td style="text-align: left;">June
                                                                        </td>
                                                                        <td>
                                                                            <input class="span4 clsARecovery" id="txtJuneARecovery" type="text" tag="06" value="0" />
                                                                        </td>
                                                                    </tr>


                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <button id="btnSaveContributionRecovery" type="button" class="btn btn-primary" style="margin-left: 80%;">Save</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>




                                        <div class="tab-pane fade" id="dvAdvance">
                                            <div class="form-row row-fluid">
                                                <div class="span12">

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Advance Request Date </label>
                                                            <input class="span4 frmCtrlAdvance" id="txtAdvanceRequestDate" type="text" />
                                                        </div>

                                                    </div>


                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Request for GPF Advance</label>
                                                            <input class="span4 frmCtrlAdvance" id="txtRequestForGPFAdvance" type="text" />
                                                        </div>
                                                    </div>
                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">GPF Own Contribution</label>
                                                            <input class="span4 frmCtrlAdvance" id="txtGPFOwnContribution" type="text" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Entitlement of Advance</label>
                                                            <input class="span4 frmCtrlAdvance" id="txtEntitlementOfAdvance" type="text" />
                                                        </div>

                                                    </div>


                                                    <div class="form-row row-fluid">

                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Advance Recommended</label>
                                                            <input class="span4 frmCtrlAdvance" id="txtAdvanceRecommended" type="text" />
                                                        </div>
                                                    </div>



                                                    <div class="form-row row-fluid">

                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Attachment</label>
                                                            <input id="photoUploadAdvance" type="file" onchange="showimagepreviewAdvance(this);" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid" id="dvImageAdvance" style="display: none;">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <img alt="" src="" id="imgprvwAdvance" style="width: 150px; height: 150px;" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <button type="button" class="btn btn-primary" id="btnSaveNewAdvance">Save</button>
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <table id="tbAdvancesCurruntYear" class="responsive table table-striped table-bordered table-condensed">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Sr.No
                                                                        </th>
                                                                        <th>Request Date
                                                                        </th>
                                                                        <th>Request for Advance
                                                                        </th>
                                                                        <th>Own Contribution
                                                                        </th>
                                                                        <th>Entitlement of Advance
                                                                        </th>
                                                                        <th>Recommended
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                </tbody>
                                                            </table>

                                                        </div>
                                                    </div>



                                                </div>

                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="dvInsurance">

                                            <div class="form-row row-fluid">
                                                <div class="span12">

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Insurance Installment Date </label>
                                                            <input class="span4 frmCtrlInsuInstallment" id="txtInstallmentDate" type="text" />
                                                        </div>

                                                    </div>


                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Amount</label>
                                                            <input class="span4 frmCtrlInsuInstallment" id="txtInsuranceInstallmentAmount" type="text" />
                                                        </div>
                                                    </div>


                                                    <div class="form-row row-fluid">

                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Attachment</label>
                                                            <input id="photoUploadInsurance" type="file" onchange="showimagepreviewInsurance(this);" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid" id="dvImageInsurance" style="display: none;">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <img alt="" src="" id="imgprvwInsurance" style="width: 150px; height: 150px;" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <button type="button" class="btn btn-primary" id="btnSaveNewInsurance">Save</button>
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <table id="tbInsuranceCurruntYear" class="responsive table table-striped table-bordered table-condensed">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Sr.No
                                                                        </th>
                                                                        <th>Date
                                                                        </th>
                                                                        <th>Installment Amount
                                                                        </th>

                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                </tbody>
                                                            </table>

                                                        </div>
                                                    </div>



                                                </div>

                                            </div>


                                        </div>
                                        <div class="tab-pane fade" id="dvDeposit">

                                            <div class="form-row row-fluid">
                                                <div class="span12">

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Deposit Date </label>
                                                            <input class="span4 frmCtrlDeposti" id="txtDepositDate" type="text" />
                                                        </div>

                                                    </div>


                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Deposit Amount</label>
                                                            <input class="span4 frmCtrlDeposti" id="txtDeposit" type="text" />
                                                        </div>
                                                    </div>


                                                    <div class="form-row row-fluid">

                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal">Attachment</label>
                                                            <input id="photoUploadDeposit" type="file" onchange="showimagepreviewDeposit(this);" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid" id="dvImageDeposit" style="display: none;">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <img alt="" src="" id="imgprvwDeposit" style="width: 150px; height: 150px;" />
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <label class="form-label span3" for="normal"></label>
                                                            <button type="button" class="btn btn-primary" id="btnSaveNewDeposit">Save</button>
                                                        </div>
                                                    </div>

                                                    <div class="form-row row-fluid">
                                                        <div class="span12">
                                                            <table id="tbDepositCurruntYear" class="responsive table table-striped table-bordered table-condensed">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Sr.No
                                                                        </th>
                                                                        <th>Deposit Date
                                                                        </th>
                                                                        <th>Deposit Amount
                                                                        </th>

                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                </tbody>
                                                            </table>

                                                        </div>
                                                    </div>



                                                </div>

                                            </div>


                                        </div>

                                    </div>
                                </div>
                            </div>

                        </div>



                        <div class="span10" style="background-color: lightgray; padding: 5px; text-align: center; border-radius: 7px;">
                            <h3>Balance Status
                            </h3>
                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table style="width: 100%; margin-left: 5%; margin-top: 5%;">
                                    <tr>
                                        <td style="width: 150px; padding: 20px;">
                                            <b>GPF For The Year</b>
                                        </td>
                                        <td style="width: 300px;">
                                            <label title="GPF For The Year" id="lblGPFForTheYear">...............</label>
                                        </td>

                                        <td style="width: 150px;">
                                            <b>Total Recovery</b>
                                        </td>
                                        <td><label title="Total Recovery" id="lblTotalRecovery">...............</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px; padding: 20px;">
                                            <b>Total GPF</b>
                                        </td>
                                        <td><label title="Total GPF" id="lblTotalGPF">...............</label>
                                        </td>

                                        <td style="width: 150px;">
                                            <b>Advance Balance</b>
                                        </td>
                                        <td><label title="Total Advance" id="lblTotalAdvance">...............</label>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="width: 150px; padding: 20px;">
                                            <b>Net GPF</b>
                                        </td>
                                        <td><label title="Net GPF" id="lblNetGPF">...............</label>
                                        </td>


                                    </tr>


                                    <tr>
                                        <td style="width: 150px; padding: 20px;">
                                            <b>Profit Rate</b>
                                        </td>
                                        <td>
                                            <input id="txtProfitRate" type="text" class="txtcs frmCtrl span4" title="Profit Rate" />
                                        </td>

                                        <td style="width: 150px;">
                                            <b>Profit Of the year</b>
                                        </td>
                                        <td>
                                           <label title="Profit Of the year" id="lblProfitOfTheYear">...............</label>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td style="width: 150px; padding: 20px;">
                                            <b></b>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-primary" id="btnSaveGPFProfit">Save Profit</button>
                                        </td>


                                    </tr>

                                </table>
                            </div>
                        </div>








                    </form>
                </div>
            </div>
            <!-- End .box -->
        </div>
        <!-- End .span6 -->
    </div>




</asp:Content>
