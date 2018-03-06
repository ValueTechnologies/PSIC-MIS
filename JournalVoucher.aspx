<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="JournalVoucher.aspx.cs" Inherits="PSIC.JournalVoucher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript" src="plugins/forms/stepper/ui.stepper.js"></script>
    <script type="text/javascript">
        var AccountHeadSelect;
        $(document).ready(function () {
            $('.heading h3').html('Journal Voucher');
            $('#txtEntryDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            EntryDate();
            GetVoucherNo();
            LoadAccountHead();



            $('#ddlVoucherType').bind('change', GetVoucherNo);


            function EntryDate() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "JournalVoucher.aspx/Getdate",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);

                        $('#txtEntryDate').val(jData[0].EntryDate);
                    }
                });
            }


            function GetVoucherNo() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "JournalVoucher.aspx/GetVoucherNo",
                    data: "{ 'VType' : '" + $('#ddlVoucherType').val() + "' }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtVoucherNo').val(jData[0].Voch);

                    }
                });
            }

            $(".txtDr").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });

            $(".txtCr").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });



            function LoadAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "JournalVoucher.aspx/LoadAccountHead",
                    data: "{  }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });
                        AccountHeadSelect = Out;
                        $('.clsAccountHead').html(Out);
                        $('.clsAccountHead').prev().html($('.clsAccountHead option:selected').text());
                        $('#extraAccountHead').html(Out);
                        $('#extraAccountHead').prev().html($('#extraAccountHead option:selected').text());
                    }
                });
            }


            $('#btnSaveVoucher').bind('click', function () {
                if ($('#btnSaveVoucher').text().trim() == 'Add New Voucher') {
                    window.location.href = "JournalVoucher.aspx";
                    return;
                }


                var AccountHead = [], Narration = [], DrColumn = [], CrColumn = [];

                $('.clsAccountHead').each(function (i, item) {
                    AccountHead[i] = $(this).val();
                    Narration[i] = $(this).parent().parent().parent().next().find('.txtNarration').val();
                    DrColumn[i] = $(this).parent().parent().parent().next().next().find('.txtDr').val();
                    CrColumn[i] = $(this).parent().parent().parent().next().next().next().find('.txtCr').val();
                });



                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/DateValidation",
                    data: "{ 'ValidationDate' : '" + $('#txtEntryDate').val().trim() + "'}",
                    success: function (response) {
                        var msg = response.d;

                        if (msg == "InvalidDate") {
                            alert('Please enter valid account date....');
                            return;
                        }
                        else {

                            if (parseInt($('#lblDebitTotal').html()) == parseInt($('#lblCreditTotal').html())) {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "JournalVoucher.aspx/SaveHead",
                                    data: "{ 'EntryDate' : '" + $('#txtEntryDate').val() + "', 'VNo' : '" + $('#txtVoucherNo').val() + "'}",
                                    success: function (response) {
                                        var VID = $.parseJSON(response.d);
                                        $('#PrintVoucher').attr('href', 'JCVoucherPrintRpt.aspx?ID=' + VID)
                                        for (var i = 0; i < AccountHead.length; i++) {
                                            $.ajax({
                                                type: "POST",
                                                contentType: "application/json; charset=utf-8",
                                                dataType: "json",
                                                url: "JournalVoucher.aspx/SaveDetail",
                                                data: "{ 'vID' : '" + VID + "', 'Head' : '" + AccountHead[i] + "', 'Narration' : '" + Narration[i] + "', 'Dr' : '" + DrColumn[i] + "', 'Cr' : '" + CrColumn[i] + "'}",
                                                success: function (response) {

                                                }
                                            });
                                        }


                                        $('.text').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#ddlVoucherType').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });
                                        $('.clsAccountHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('.clsCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsCancelHead');
                                        });
                                        $('.clsAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsAddHead');
                                        });


                                        alert('Save Successfully!');
                                        $('#btnSaveVoucher').text('Add New Voucher');
                                    }
                                });
                            }
                            else {
                                alert("Debit and credit amount should be same.");
                                return;
                            }
                        }
                    }
                });
            });
        });


        $('body').on({
            click: function () {
                var strHeadName = $('#extraAccountHead  option:first').text();
                var str = '<tr><td><div style="width: 90%;"><div class="selector" id="uniform-undefined"><span>' + strHeadName + '</span><select class="clsAccountHead" style="opacity: 0;">' + AccountHeadSelect + '</select></div></div></td><td><div style="width: 90%;"><input type="text" class="txtNarration text"></div></td><td style="width: 100px;"><div style="width: 90%;"><input type="text" class="txtDr text"></div></td><td style="width: 100px; margin: 2px;"><div style="width: 90%;"><input type="text" class="txtCr text"></div></td><td style="width: 40px;"><img class="clsCancelHead" src="Images/RowDelete.png" style="width: 20px;"></td><td style="width: 40px;"><img class="clsAddHead" src="Images/addrecord.png" style="width: 20px;"></td></tr>';
                $('#tbAccountHead tbody').append(str);

            }
        }, '.clsAddHead');

        $('body').on({
            change: function () {
                $(this).prev().html($('#extraAccountHead option[value=' + $(this).val() + ']').text());
            }
        }, '.clsAccountHead');


        $('body').on({
            click: function () {

                $(this).parent().parent().remove();

            }
        }, '.clsCancelHead');

        $('body').on({
            blur: function () {
                if ($(this).val().trim() == "0" || $(this).val().trim() == "") {
                    $(this).parent().parent().next().find(".txtCr").removeAttr('disabled');
                    $(this).attr('disabled', 'disabled');
                    $(this).val('0');
                }
                else {
                    $(this).parent().parent().next().find(".txtCr").attr('disabled', 'disabled');
                    $(this).parent().parent().next().find(".txtCr").val('0');
                }
                CalculateDrCrTotal();
            }
        }, '.txtDr');

        $('body').on({
            blur: function () {
                if ($(this).val().trim() == "0" || $(this).val().trim() == "") {
                    $(this).parent().parent().prev().find(".txtDr").removeAttr('disabled');
                    $(this).attr('disabled', 'disabled');
                    $(this).val('0');
                }
                else {
                    $(this).parent().parent().prev().find(".txtDr").attr('disabled', 'disabled');
                    $(this).parent().parent().prev().find(".txtDr").val('0');
                }
                CalculateDrCrTotal();
            }
        }, '.txtCr');




        function CalculateDrCrTotal() {
            var TotalDr = 0, TotalCr = 0;
            $('.txtDr').each(function (i, item) {
                TotalDr = TotalDr + parseInt($(this).val());
            });
            $('#lblDebitTotal').html(TotalDr);


            $('.txtCr').each(function (i, item) {
                TotalCr = TotalCr + parseInt($(this).val());
            });
            $('#lblCreditTotal').html(TotalCr);

            if (TotalDr == TotalCr) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "JournalVoucher.aspx/NumericToWord",
                    data: "{ 'Value' : '" + TotalDr + "'}",
                    success: function (response) {
                        $('#lblAmountInWord').html(response.d);
                    }
                });



            }
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Journal Voucher</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Voucher Type </label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlVoucherType">
                                        <option>Journal Voucher</option>
                                        <option>Grant Payment Voucher</option>
                                        <option>Grant Receipt Voucher</option>
                                        <option>Security Payment Voucher</option>
                                        <option>Security Receipt Voucher</option>
                                        <option>Bank Payment Voucher </option>
                                        <option>Bank Receipt Voucher </option>
                                        <option>Cash Payment Voucher </option>
                                        <option>Cash Receipt Voucher </option>
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Entry Date</label>
                                <input type="text" class="span7" id="txtEntryDate" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Voucher No.</label>
                                <input type="text" class="span7" id="txtVoucherNo" />
                            </div>
                        </div>

                        <div class="form-row row-fluid" style="display: none;">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Opening Balance</label>
                                <input type="text" class="span7" id="txtOpeningBalance" />
                            </div>
                        </div>
                        <div class="form-row row-fluid" style="display: none;">
                            <div class="span6">
                                <select id="extraAccountHead">
                                </select>
                            </div>
                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <table class="responsive table table-bordered" id="tbAccountHead">
                                    <thead>
                                        <tr>
                                            <th>Account
                                            </th>
                                            <th>Narration
                                            </th>
                                            <th>Dr.
                                            </th>
                                            <th>Cr.
                                            </th>
                                            <th>Cancel
                                            </th>
                                            <th>Add
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div style="width: 90%;">
                                                    <select class="clsAccountHead">
                                                    </select>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="width: 90%;">
                                                    <input type="text" class="txtNarration" />
                                                </div>
                                            </td>
                                            <td style="width: 100px;">
                                                <div style="width: 90%;">
                                                    <input type="text" class="txtDr" />
                                                </div>
                                            </td>
                                            <td style="width: 100px; margin: 2px;">
                                                <div style="width: 90%;">
                                                    <input type="text" class="txtCr" />
                                                </div>
                                            </td>
                                            <td style="width: 40px;">
                                                <img class="clsCancelHead" src="Images/RowDelete.png" style="width: 20px;" />
                                            </td>
                                            <td style="width: 40px;">
                                                <img class="clsAddHead" src="Images/addrecord.png" style="width: 20px;" />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <table class="responsive table table-bordered" id="tbAccountHeadTotal">
                                    <thead style="background: rgb(250, 250, 250);">
                                        <tr>
                                            <td colspan="2">
                                                <div style="width: 90%;">
                                                    <label id="lblAmountInWord" style="color: #9C303F; font-weight: bold; font-size: large; font-style: italic;"></label>
                                                </div>
                                            </td>

                                            <td style="width: 100px;">
                                                <div style="width: 90%;">
                                                    <label id="lblDebitTotal" style="font-weight: bold; font-size: medium; color: green;"></label>
                                                </div>
                                            </td>
                                            <td style="width: 100px; margin: 2px;">
                                                <div style="width: 90%;">
                                                    <label id="lblCreditTotal" style="font-weight: bold; font-size: medium; color: green;"></label>
                                                </div>
                                            </td>
                                            <td style="width: 40px;"></td>
                                            <td style="width: 40px;"></td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <button type="button" id="btnSaveVoucher" class="btn btn-primary">Save</button>
                            <a id="PrintVoucher" target="_blank">Print Voucher</a>
                            <button type="button" id="btnPrintVoucher" style="display: none;"></button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
