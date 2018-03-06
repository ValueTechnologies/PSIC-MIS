<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="LedgerSearch.aspx.cs" Inherits="PSIC.LedgerSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Search Ledger');
            SearchLedgersAccount();
            EntryDate();



            $('#txtStartDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtEndDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            $('#btnSearch').bind('click', SearchLedgersAccount);

            function SearchLedgersAccount() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "LedgerSearch.aspx/SearchLedger",
                    data: "{ 'strAccountName' : '" + $('#txtAccountName').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<tr><td>' + item.HeadName + '</td><td><input name="LedgerShow" type="radio" class="clsLedgerCheck" tag="' + item.AccountID + '" /></td></tr>';
                        });

                        $('#tbSearchedLedger tbody').html(Out);
                    }
                });
            }


            function EntryDate() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/Getdate",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);

                        $('#txtStartDate').val(jData[0].EntryDate);
                        $('#txtEndDate').val(jData[0].EntryDate);
                    }
                });
            }


            $('#txtStartDate').bind('blur', MakeQueryString);

            $('#txtEndDate').bind('blur', MakeQueryString);

            function MakeQueryString() {
                $('.clsLedgerCheck').each(function (i, item) {
                    if ($(this).is(':checked')) {
                        $('#lnkPrintVoucher').attr('href', 'LedgerRpt.aspx?ID="' + $(this).attr('tag') + '"&StartDate="' + $('#txtStartDate').val() + '"&EndDate="' + $('#txtEndDate').val() + '"');
                    }
                });
            }
            

        });
        //end ready

        $('body').on({
            change: function () {
                $('#lnkPrintVoucher').attr('href', 'LedgerRpt.aspx?ID=' + $(this).attr('tag') + '&StartDate="' + $('#txtStartDate').val() + '"&EndDate="' + $('#txtEndDate').val() + '"');
            }
        }, '.clsLedgerCheck');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Between Date</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Start Date</label>
                                <input id="txtStartDate" type="text" class="txtcs  span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">End Date</label>
                                <input id="txtEndDate" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Account Name</label>
                                <input id="txtAccountName" type="text" class="txtcs  span7" />
                            </div>


                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" class="btn btn-info" id="btnSearch">Search</button>
                                &nbsp;&nbsp;&nbsp;
                                <a id="lnkPrintVoucher" target="_blank">Print Ledger</a>
                            </div>

                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSearchedLedger" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Ledger
                                            </th>
                                            <th style="width: 100px;">Select
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
