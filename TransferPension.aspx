<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="TransferPension.aspx.cs" Inherits="PSIC.TransferPension" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Transfer Pension');
            Years();
            

            $('.clsMedicalAllowance').live('keyup', CalculateNetPaid);
            $('.clsArrears').live('keyup', CalculateNetPaid);
            $('.clsDeductions').live('keyup', CalculateNetPaid);
            $('.clsNetPaid').live('keyup', CalculateNetPaid);
            $('.clsCashablePension').live('keyup', CalculateNetPaid);


            function Years() {
                for (var i = 1947; i <= (new Date).getFullYear() + 1; i++)
                {
                    $('#ddlPensionYear').prepend('<option>' + i + '</option>');
                }
            }


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
                    url: "TransferPension.aspx/SearchEmployees",
                    data: "{ 'empno' : '" + $('#txtEmpNo').val() + "', 'name' : '" + $('#txtName').val() + "', 'DepartmentID' : '" + $('#ddlDept').val() + "' , 'DesignationID' : '" + $('#ddlDesignation').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> <input type="text" class="clsCashablePension" tag=' + item.User_ID + ' style="width : 50px;" value="' + item.CashableAmount + '" /></td> <td> <input type="text" class="clsMedicalAllowance" style="width : 50px;" value="' + item.MedicalAllowance + '" /> </td> <td> <input type="text" class="form-label span4 clsArrears" for="normal" style="width : 100px;" /></td><td>  <input type="text" class="form-label span4 clsDeductions" for="normal" style="width : 100px;" /></td> <td>  <input type="text" class="form-label span4 clsNetPaid" for="normal" style="width : 100px;" /></td><td>  <input type="text" class="form-label span4 clsRemarks" for="normal" style="width : 300px;" /></td> </tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                        CalculateNetPaid();
                    }
                });
            });


            function CalculateNetPaid() {
                $('.clsCashablePension').each(function () {
                    var CashablePension = 0, Medical = 0, Arrears = 0, Deductions = 0;

                    if ($(this).val().trim() != "") {
                        CashablePension = parseInt($(this).val());
                    }
                    if ($(this).parent().next().find('.clsMedicalAllowance').val().trim() != "") {
                        Medical = parseInt($(this).parent().next().find('.clsMedicalAllowance').val());
                    }
                    if ($(this).parent().next().next().find('.clsArrears').val().trim() != "") {
                        Arrears = parseInt($(this).parent().next().next().find('.clsArrears').val());
                    }
                    if ($(this).parent().next().next().next().find('.clsDeductions').val().trim() != "") {
                        Deductions = parseInt($(this).parent().next().next().next().find('.clsDeductions').val());
                    }

                    var NetPaidAmount = CashablePension + Medical + Arrears - Deductions;
                    $(this).parent().next().next().next().next().find('.clsNetPaid').val(NetPaidAmount);

                });
            }


            $('#btnSave').bind('click', function () {

                $('.clsCashablePension').each(function () {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "TransferPension.aspx/SaveData",
                        data: "{ 'EmpId' : '" + $(this).attr('tag') + "', 'PensionMonth' : '" + $('#ddlPensionMonth').val() + "','PensionYear' : '" + $('#ddlPensionYear').val() + "','Bank' : '" + $('#txtBank').val() + "','MonthlyPension' : '" + $(this).val().trim() + "','MedicalAllowance' : '" + $(this).parent().next().find('.clsMedicalAllowance').val().trim() + "','Arrears' : '" + $(this).parent().next().next().find('.clsArrears').val().trim() + "','Deductions' : '" + $(this).parent().next().next().next().find('.clsDeductions').val().trim() + "','NetPaid' : '" + $(this).parent().next().next().next().next().find('.clsNetPaid').val().trim() + "','Remarks' : '" + $(this).parent().next().next().next().next().next().find('.clsRemarks').val().trim() + "'  }",
                        success: function (response) {

                            
                            
                        }
                    });
                });
                alert('Save Successfully!');
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
                        <span>Transfer Pension</span>
                    </h4>
                    <a href="dvPensionCalculation" class="minimize"></a>
                </div>
                <div class="content" id="dvPensionCalculation">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <table id="tbSearchedEmployees" class="responsive table table-striped table-bordered table-condensed">
                                            <thead>
                                                <tr>
                                                    <th style="width: 40px;">SrNo.</th>
                                                    <th>Emp No.</th>
                                                    <th>Name</th>
                                                    <th>Monthly</th>
                                                    <th>Medical Allownace</th>
                                                    <th>Arrears</th>
                                                    <th>Deductions</th>
                                                    <th>Net Paid</th>
                                                    <th>Remarks</th>

                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Transfer Month</label>
                                <div class="span7 controls sel">
                                    <select class="nostyle" id="ddlPensionMonth">
                                        <option value="1" >January</option>
                                        <option value="2" >February</option>
                                        <option value="3" >March</option>
                                        <option value="4" >April</option>
                                        <option value="5" >May</option>
                                        <option value="6" >June</option>
                                        <option value="7" >July</option>
                                        <option value="8" >August</option>
                                        <option value="9" >September</option>
                                        <option value="10" >October</option>
                                        <option value="11" >November</option>
                                        <option value="12" >December</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Transfer Year</label>
                                <div class="span7 controls sel">
                                    <select class="nostyle" id="ddlPensionYear">
                                        
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span5" for="normal">Transfer Bank</label>
                                <input id="txtBank" type="text" class="txtcs frmCtrl span7"  />
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
