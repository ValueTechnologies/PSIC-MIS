<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="PensionIncrements.aspx.cs" Inherits="PSIC.PensionIncrements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Pension Increase');
            $('#txtIncreasesDateAll').datepicker({ dateFormat: 'dd-MM-yy', changeYear: true, changeMonth: true });


            $('#txtIncreaseAll').live('keyup', function () {
                $('.clsIncreaseGrossPension').each(function (i, item) {
                    $(this).val($('#txtIncreaseAll').val());

                    var PrevGross = $(this).parent().prev().html();
                    var GrossPension = $(this).parent().prev().html();

                    GrossPension = GrossPension * (parseFloat($(this).val()) / 100.00);
                    GrossPension = parseInt(PrevGross) + parseInt(GrossPension);
                    $(this).parent().next().next().html(GrossPension);
                    var MonthlyPension = parseFloat(GrossPension * 0.65).toFixed(0)
                    $(this).parent().next().next().next().html(MonthlyPension);
                    $(this).parent().next().next().next().next().html(GrossPension - MonthlyPension);
                });

            });

            $('#txtIncreasesDateAll').change(function () {
                $('.clsDateOfIncrement').each(function (i, item) {
                    $(this).val($('#txtIncreasesDateAll').val());
                });

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


            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PensionIncrements.aspx/SearchEmployees",
                    data: "{ 'empno' : '" + $('#txtEmpNo').val() + "', 'name' : '" + $('#txtName').val() + "', 'DepartmentID' : '" + $('#ddlDept').val() + "' , 'DesignationID' : '" + $('#ddlDesignation').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.GrossPension + '</td> <td> <input type="text" tag=' + item.User_ID + ' class="clsIncreaseGrossPension" style="width : 50px;" /> </td> <td> <input type="text" class="form-label span4 clsDateOfIncrement" for="normal" style="width : 155px;" /></td><td> <label class="form-label span4 clsIncreaseGrossPension" for="normal"></label></td> <td> <label class="form-label span4 clsIncreaseMonthlyPension" for="normal"></label></td><td> <label class="form-label span4 clsIncreaseCommutationPension" for="normal"></label></td> </tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                        $('.clsDateOfIncrement').datepicker({ dateFormat: 'dd-MM-yy', changeYear: true, changeMonth: true });

                    }
                });
            });


            $('#btnSave').bind('click', function () {

                $('.clsIncreaseGrossPension').each(function (i, item) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "PensionIncrements.aspx/SaveData",
                        data: "{ 'EmpId' : '" + $(this).attr('tag') + "' , 'preGPension' : '" + $(this).parent().prev().html() + "', 'IncPrecentage' : '" + $(this).val() + "' , 'IncDate' : '" + $(this).parent().next().find('.clsDateOfIncrement').val() + "' , 'IncGross' : '" + $(this).parent().next().next().html() + "' , 'IncMonthlyPension' : '" + $(this).parent().next().next().next().html() + "' , 'IncCommutation' : '" + $(this).parent().next().next().next().next().html() + "'}",
                        success: function (response) {
                                                        
                        }
                    });
                });
                alert('Save Successfully!');
            });


        });


        $('body').on({
            change: function () {
                var PrevGross = $(this).parent().prev().html();
                var GrossPension = $(this).parent().prev().html();

                GrossPension = GrossPension * (parseFloat($(this).val()) / 100.00);
                GrossPension = parseInt(PrevGross) + parseInt(GrossPension);
                $(this).parent().next().next().html(GrossPension);
                $(this).parent().next().next().next().html(GrossPension * 0.65);
                var Commutation = (GrossPension * 0.35);
                Commutation = Math.round(Commutation).toFixed(2);
                $(this).parent().next().next().next().next().html(Commutation);
            }
        }, '.clsIncreaseGrossPension')



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
                        <span>Increment Pension</span>
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
                                                    <th>Current Gross Pension</th>
                                                    <th>Inrease %<input type="text" style="width: 50px;" id="txtIncreaseAll" /></th>
                                                    <th>Increase Date<br />
                                                        <input type="text" style="width: 155px;" id="txtIncreasesDateAll" /></th>
                                                    <th>Increase Gross Pension</th>
                                                    <th>Increase Monthly Pension</th>
                                                    <th>Increase Commutation</th>

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
                                <label class="form-label span3" for="normal"></label>
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
