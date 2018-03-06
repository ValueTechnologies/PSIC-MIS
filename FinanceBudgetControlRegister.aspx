<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="FinanceBudgetControlRegister.aspx.cs" Inherits="PSIC.FinanceBudgetControlRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Budget Control Register');
            $("#txtBudgetIssueDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            LoadAccountHead();
            LoadBudgetList();


            function LoadAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "FinanceBudgetControlRegister.aspx/LoadAccountHead",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '"> ' + item.HeadName + ' </value>';
                        });
                        $('#ddlAccountHead').html(Out);
                        $('#ddlAccountHead').prev().html($('#ddlAccountHead option:selected').text());
                    }
                });
            }


            $('#btnSave').bind('click', function () {
                if ($('#txtBudgetIssueDate').val().trim() == "") {
                    alert("Please enter Date...");
                    return;
                }

                if ($('#txtBudgetAmount').val().trim() == "") {
                    alert("Please enter Amount...");
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "FinanceBudgetControlRegister.aspx/SaveNewBudget",
                    data: "{ 'Head' : '" + $('#ddlAccountHead').val() + "', 'DateOfBudget' : '" + $('#txtBudgetIssueDate').val() + "', 'Amount' : '" + $('#txtBudgetAmount').val() + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#txtBudgetIssueDate').val('');
                        $('#txtBudgetAmount').val('');
                        LoadBudgetList();
                    }
                });
            });



            function LoadBudgetList() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "FinanceBudgetControlRegister.aspx/BudgetList",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<tr><td>' + item.srno + ' </td> <td>' + item.HeadName + ' </td> <td>' + item.Amount + ' </td></tr>';
                        });
                        $('#tbBudgetBalance tbody').html(Out);
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
                        <span>Define Budget</span>
                    </h4>
                    <a href="dvDefineBudget" class="minimize">Minimize</a>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#" id="dvDefineBudget">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Head Name</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlAccountHead" class="txtcs ">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Budget Issue Date</label>
                                <input id="txtBudgetIssueDate" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Amount</label>
                                <input id="txtBudgetAmount" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
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


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Budget Balance</span>
                    </h4>
                    <a href="dvBudgetDetail" class="minimize">Minimize</a>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#" id="dvBudgetDetail">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <table id="tbBudgetBalance" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo.
                                            </th>
                                            <th>Head name
                                            </th>
                                            <th>Total Balance
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
