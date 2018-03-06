<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="BankVoucher.aspx.cs" Inherits="PSIC.BankVoucher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">
        ///variable Declarations
        var AccountHeadSelectBPV, AccountHeadSelectBRV, newEntry;
        //end variable declaration
        $(document).ready(function () {
            $('.heading h3').html('Bank Voucher');
            $('#txtBPVEntryDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtBRVEntryDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtBPVChequeDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtBRVChequeDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });


            NewVoucherNo();
            BankAccountHead();
            EntryDate();
            LoadAccountHead();


            $(".txtBankPaymentAmount").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });

            $(".txtBankReceiptAmount").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });

            $("#txtBPVChequeAmount").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });

            function NewVoucherNo() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "BankVoucher.aspx/BPVVNo",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtBPVVoucherNo').val(jData[0].Voch);
                    }
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "BankVoucher.aspx/BRVVNo",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtBRVVoucherNo').val(jData[0].Voch);
                    }
                });
            }


            function BankAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "BankVoucher.aspx/BankAccountHead",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });

                        $('#ddlBPVBankAccount').html(Out);
                        $('#ddlBPVBankAccount').prev().html($('#ddlBPVBankAccount option:selected').text());

                        $('#ddlBRVBankAccount').html(Out);
                        $('#ddlBRVBankAccount').prev().html($('#ddlBRVBankAccount option:selected').text());
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

                        $('#txtBPVEntryDate').val(jData[0].EntryDate);
                        $('#txtBRVEntryDate').val(jData[0].EntryDate);
                    }
                });
            }


            function LoadAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "BankVoucher.aspx/LoadAccountHeadBPV",
                    data: "{  }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });
                        AccountHeadSelectBPV = Out;
                        $('.clsAccountHeadBPV').html(Out);
                        $('.clsAccountHeadBPV').prev().html($('.clsAccountHeadBPV option:selected').text());
                        $('#extraAccountHeadBPV').html(Out);
                        $('#extraAccountHeadBPV').prev().html($('#extraAccountHeadBPV option:selected').text());
                    }
                });


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "BankVoucher.aspx/LoadAccountHeadBRV",
                    data: "{  }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });
                        AccountHeadSelectBRV = Out;
                        $('.clsAccountHeadBRV').html(Out);
                        $('.clsAccountHeadBRV').prev().html($('.clsAccountHeadBRV option:selected').text());
                        $('#extraAccountHeadBRV').html(Out);
                        $('#extraAccountHeadBRV').prev().html($('#extraAccountHeadBRV option:selected').text());
                    }
                });

            }



            //Bank Payment Voucher Save

            $('#btnSaveBPV').bind('click', function () {
                var VoucherID;
                if ($('#btnSaveBPV').text() == 'Add New Voucher') {
                    window.location.href = 'BankVoucher.aspx';
                    return;
                }
                if ($('#txtBPVEntryDate').val().trim() == "") {
                    alert('Please enter date of entry.....');
                    return;
                }


                //check date validation

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/DateValidation",
                    data: "{ 'ValidationDate' : '" + $('#txtBPVEntryDate').val().trim() + "'}",
                    success: function (response) {
                        var msg = response.d;

                        if (msg == "InvalidDate") {
                            alert('Please enter valid account date....');
                            return;
                        }
                        else {
                            if ($('#txtBPVChequeAmount').val().trim() == "") {
                                alert("Please enter Cheque Amount....");
                                return;
                            }

                            if (newEntry == "Invalid") {
                                window.location.href = 'BankVoucher.aspx';
                            }
                            if (parseInt($('#txtBPVChequeAmount').val().trim()) == parseInt($('#lblBPVTotalAmount').html())) {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "BankVoucher.aspx/SaveHead",
                                    data: "{ 'VNo' : '" + $('#txtBPVVoucherNo').val() + "', 'EntryDate' : '" + $('#txtBPVEntryDate').val() + "',  'chqNo' : '" + $('#txtBPVChequeNo').val() + "', 'chqDate' : '" + $('#txtBPVChequeDate').val() + "', 'chqAmount' : '" + $('#txtBPVChequeAmount').val() + "'}",
                                    success: function (response) {
                                        var VID = $.parseJSON(response.d);
                                        $('#PrintVoucherBPV').attr("href", "BankVoucherRpt.aspx?ID=" + VID);
                                        $.ajax({
                                            type: "POST",
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            url: "BankVoucher.aspx/SaveDetail",
                                            data: "{ 'vID' : '" + VID + "', 'Head' : '" + $('#ddlBPVBankAccount').val() + "', 'Narration' : '', 'Dr' : '0', 'Cr' : '" + $('#txtBPVChequeAmount').val() + "'}",
                                            success: function (response) {

                                            }
                                        });


                                        $('.clsAccountHeadBPV').each(function (i, item) {
                                            $.ajax({
                                                type: "POST",
                                                contentType: "application/json; charset=utf-8",
                                                dataType: "json",
                                                url: "BankVoucher.aspx/SaveDetail",
                                                data: "{ 'vID' : '" + VID + "', 'Head' : '" + $(this).val() + "', 'Narration' : '" + $(this).parent().parent().parent().next().find('.txtNarration').val() + ' Cheque Date : ' + $('#txtBPVChequeDate').val() + ' Chqeue No : ' + $('#txtBPVChequeNo').val() + "', 'Dr' : '" + $(this).parent().parent().parent().next().next().find('.txtBankPaymentAmount').val() + "', 'Cr' : '0'}",
                                                success: function (response) {

                                                }
                                            });
                                        });

                                        newEntry = "Invalid";
                                        $('.text').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('.clsBRVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBRVAddHead');
                                        });

                                        $('.clsBRVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBRVCancelHead');
                                        });

                                        $('.clsBPVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBPVAddHead');
                                        });

                                        $('.clsBPVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBPVCancelHead');
                                        });

                                        $('.clsAccountHeadBRV').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('.clsAccountHeadBPV').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#ddlBPVBankAccount').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#ddlBRVBankAccount').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#clsBRVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#clsBRVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        alert('Save successfully!');
                                        $('#btnSaveBPV').text('Add New Voucher');
                                    }
                                });
                            }
                            else {
                                alert("Cheque amount and disbursement amount should be same.");
                                return;
                            }
                        }
                    }
                });

                //date validation end
            });

            //end Bank payment voucher save



            //Bank Recipt voucher save

            $('#btnSaveBRV').bind('click', function () {
                if ($('#btnSaveBRV').text() == 'Add New Voucher') {
                    window.location.href = 'BankVoucher.aspx';
                }
                if ($('#txtBRVEntryDate').val().trim() == "") {
                    alert('Please enter date of entry.....');
                    return;
                }


                //check date validation

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/DateValidation",
                    data: "{ 'ValidationDate' : '" + $('#txtBRVEntryDate').val().trim() + "'}",
                    success: function (response) {
                        var msg = response.d;

                        if (msg == "InvalidDate") {
                            alert('Please enter valid account date....');
                            return;
                        }
                        else {
                            if ($('#txtBRVChequeAmount').val().trim() == "") {
                                alert("Please enter Cheque Amount....");
                                return;
                            }

                            if (newEntry == "Invalid") {
                                window.location.href = 'BankVoucher.aspx';
                                return;
                            }


                            if (parseInt($('#txtBRVChequeAmount').val().trim()) == parseInt($('#lblBRVTotalAmount').html())) {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "BankVoucher.aspx/SaveHead",
                                    data: "{ 'VNo' : '" + $('#txtBRVVoucherNo').val() + "', 'EntryDate' : '" + $('#txtBRVEntryDate').val() + "' ,  'chqNo' : '" + $('#txtBRVChequeNo').val() + "', 'chqDate' : '" + $('#txtBRVChequeDate').val() + "', 'chqAmount' : '" + $('#txtBRVChequeAmount').val() + "'}",
                                    success: function (response) {
                                        var VID = $.parseJSON(response.d);
                                        $('#PrintVoucherBRV').attr("href", "BankVoucherRpt.aspx?ID=" + VID);

                                        $.ajax({
                                            type: "POST",
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            url: "BankVoucher.aspx/SaveDetail",
                                            data: "{ 'vID' : '" + VID + "', 'Head' : '" + $('#ddlBRVBankAccount').val() + "', 'Narration' : '', 'Dr' : '" + $('#txtBRVChequeAmount').val() + "', 'Cr' : '0'}",
                                            success: function (response) {

                                            }
                                        });


                                        $('.clsAccountHeadBRV').each(function (i, item) {
                                            $.ajax({
                                                type: "POST",
                                                contentType: "application/json; charset=utf-8",
                                                dataType: "json",
                                                url: "BankVoucher.aspx/SaveDetail",
                                                data: "{ 'vID' : '" + VID + "', 'Head' : '" + $(this).val() + "', 'Narration' : '" + $(this).parent().parent().parent().next().find('.txtNarration').val() + ' Cheque Date : ' + $('#txtBRVChequeDate').val() + ' Chqeue No : ' + $('#txtBRVChequeNo').val() + "', 'Dr' : '0', 'Cr' : '" + $(this).parent().parent().parent().next().next().find('.txtBankReceiptAmount').val() + "'}",
                                                success: function (response) {

                                                }
                                            });
                                        });


                                        $('.text').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('.clsBRVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBRVAddHead');
                                        });

                                        $('.clsBRVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBRVCancelHead');
                                        });

                                        $('.clsBPVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBPVAddHead');
                                        });

                                        $('.clsBPVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                            $(this).removeClass('clsBPVCancelHead');
                                        });

                                        $('.clsAccountHeadBRV').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('.clsAccountHeadBPV').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });
                                        $('#ddlBPVBankAccount').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });


                                        ///
                                        $('#ddlBRVBankAccount').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#clsBRVCancelHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });

                                        $('#clsBRVAddHead').each(function () {
                                            $(this).prop('disabled', 'disabled');
                                        });


                                        newEntry = "Invalid";
                                        alert('Save successfully!');
                                        $('#btnSaveBRV').text('Add New Voucher');
                                    }
                                });
                            }
                        }

                    }
                });

                //date validation end
            });

            //end cash recipt voucher save



        });


        //Bank payment voucher
        $('body').on({
            click: function () {
                var strHeadName = $('#extraAccountHeadBPV  option:first').text();
                var str = '<tr><td><div style="width: 90%;"><div class="selector" id="uniform-undefined"><span>' + strHeadName + '</span><select class="clsAccountHeadBPV" style="opacity: 0;">' + AccountHeadSelectBPV + '</select></div></div></td><td><div style="width: 90%;"><input type="text" class="txtNarration text"></div></td><td style="width: 100px;"><div style="width: 90%;"><input type="text" class="txtBankPaymentAmount text"></div></td><td style="width: 40px;"><img class="clsBPVCancelHead" src="Images/RowDelete.png" style="width: 20px;"></td><td style="width: 40px;"><img class="clsBPVAddHead" src="Images/addrecord.png" style="width: 20px;"></td></tr>';
                $('#tbBankPaymentVoucherAccountHead tbody').append(str);

            }
        }, '.clsBPVAddHead');

        $('body').on({
            change: function () {
                $(this).prev().html($('#extraAccountHeadBPV option[value=' + $(this).val() + ']').text());
            }
        }, '.clsAccountHeadBPV');


        $('body').on({
            click: function () {

                $(this).parent().parent().remove();

            }
        }, '.clsBPVCancelHead');


        $('body').on({
            blur: function () {
                CalculateBPVTotalAmount();
            }
        }, '.txtBankPaymentAmount');

        //end Bank payment voucher

        //Bank receipt voucher
        $('body').on({
            click: function () {
                var strHeadName = $('#extraAccountHeadBRV  option:first').text();
                var str = '<tr><td><div style="width: 90%;"><div class="selector" id="uniform-undefined"><span>' + strHeadName + '</span><select class="clsAccountHeadBRV" style="opacity: 0;">' + AccountHeadSelectBRV + '</select></div></div></td><td><div style="width: 90%;"><input type="text" class="txtNarration text"></div></td><td style="width: 100px;"><div style="width: 90%;"><input type="text" class="txtBankReceiptAmount text"></div></td><td style="width: 40px;"><img class="clsBRVCancelHead" src="Images/RowDelete.png" style="width: 20px;"></td><td style="width: 40px;"><img class="clsBRVAddHead" src="Images/addrecord.png" style="width: 20px;"></td></tr>';
                $('#tbBankRecepitVoucherAccountHead tbody').append(str);

            }
        }, '.clsBRVAddHead');


        $('body').on({
            change: function () {
                $(this).prev().html($('#extraAccountHeadBRV option[value=' + $(this).val() + ']').text());
            }
        }, '.clsAccountHeadBRV');


        $('body').on({
            click: function () {

                $(this).parent().parent().remove();

            }
        }, '.clsBRVCancelHead');

        $('body').on({
            blur: function () {
                CalculateBRVTotalAmount();
            }
        }, '.txtBankReceiptAmount');




        //end Bank receipt voucher


        function CalculateBPVTotalAmount() {

            var TotalAmount = 0;
            $('.txtBankPaymentAmount').each(function (i, item) {
                TotalAmount = TotalAmount + parseInt($(this).val());
            });
            $('#lblBPVTotalAmount').html(TotalAmount);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "CashVoucher.aspx/NumericToWord",
                data: "{ 'Value' : '" + TotalAmount + "'}",
                success: function (response) {
                    $('#lblBPVAmountInWord').html(response.d);
                }
            });

        }


        function CalculateBRVTotalAmount() {

            var TotalAmount = 0;
            $('.txtBankReceiptAmount').each(function (i, item) {
                TotalAmount = TotalAmount + parseInt($(this).val());
            });
            $('#lblBRVTotalAmount').html(TotalAmount);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "CashVoucher.aspx/NumericToWord",
                data: "{ 'Value' : '" + TotalAmount + "'}",
                success: function (response) {
                    $('#lblBRVAmountInWord').html(response.d);
                }
            });

        }





    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="form-row row-fluid">
        <div class="span12">
            <div style="margin-bottom: 20px;">
                <ul id="TabAdvInsDep" class="nav nav-tabs pattern">
                    <li class="active"><a href="#dvBankPaymentVoucher" data-toggle="tab">Bank Payment Voucher</a></li>
                    <li class=""><a href="#dvBankReceiptVoucher" data-toggle="tab">Bank Receipt Voucher</a></li>
                </ul>

                <div class="tab-content">
                    <%--start Bank payment Voucher--%>

                    <div class="tab-pane fade active in" id="dvBankPaymentVoucher">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">

                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Voucher No.</label>
                                                <input class="span6" id="txtBPVVoucherNo" type="text" />
                                            </div>
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Entry Date</label>
                                                <input class="span6" id="txtBPVEntryDate" type="text" />
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Bank Account</label>
                                                <div class="span6">
                                                    <select id="ddlBPVBankAccount">
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque No</label>
                                                <input class="span6" id="txtBPVChequeNo" type="text" />
                                            </div>
                                        </div>



                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque Date</label>
                                                <input class="span6" id="txtBPVChequeDate" type="text" />
                                            </div>

                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque Amount</label>
                                                <input class="span6" id="txtBPVChequeAmount" type="text" />
                                            </div>
                                        </div>




                                        <div class="form-row row-fluid" style="display: none;">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Bank Account</label>
                                                <div class="span8">
                                                    <select id="extraAccountHeadBPV">
                                                    </select>

                                                </div>
                                            </div>
                                        </div>



                                    </div>
                                </div>



                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <div class="form-row row-fluid">
                                            <div class="span12">

                                                <table class="responsive table table-bordered" id="tbBankPaymentVoucherAccountHead">
                                                    <thead>
                                                        <tr>
                                                            <th>Account
                                                            </th>
                                                            <th>Narration
                                                            </th>
                                                            <th>Amount
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
                                                                    <select class="clsAccountHeadBPV">
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
                                                                    <input type="text" class="txtBankPaymentAmount" />
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsBPVCancelHead" src="Images/RowDelete.png" style="width: 20px;" />
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsBPVAddHead" src="Images/addrecord.png" style="width: 20px;" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="responsive table table-bordered" id="tbAccountHeadTotal">
                                                    <thead style="background: rgb(250, 250, 250);">
                                                        <tr>
                                                            <td colspan="2">
                                                                <div style="width: 90%;">
                                                                    <label id="lblBPVAmountInWord" style="color: #9C303F; font-weight: bold; font-size: large; font-style: italic;"></label>
                                                                </div>
                                                            </td>

                                                            <td style="width: 100px;">
                                                                <div style="width: 90%;">
                                                                    <label id="lblBPVTotalAmount" style="font-weight: bold; font-size: medium; color: green;"></label>
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;"></td>
                                                            <td style="width: 40px;"></td>
                                                        </tr>
                                                    </thead>
                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>




                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <button id="btnSaveBPV" type="button" class="btn btn-primary" style="margin-left: 70%;">Save</button>
                                        &nbsp;&nbsp;&nbsp;
                                        <a id="PrintVoucherBPV"  target="_blank">Print Voucher</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%--end Bank payment voucher--%>

                    <%--start Bank receipt voucher--%>

                    <div class="tab-pane fade" id="dvBankReceiptVoucher">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">

                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Voucher No.</label>
                                                <input class="span6" id="txtBRVVoucherNo" type="text" />
                                            </div>
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Entry Date</label>
                                                <input class="span6" id="txtBRVEntryDate" type="text" />
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Bank Account</label>
                                                <div class="span6">
                                                    <select id="ddlBRVBankAccount">
                                                    </select>

                                                </div>
                                            </div>
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque No</label>
                                                <input class="span6" id="txtBRVChequeNo" type="text" />
                                            </div>
                                        </div>



                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque Date</label>
                                                <input class="span6" id="txtBRVChequeDate" type="text" />
                                            </div>

                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cheque Amount</label>
                                                <input class="span6" id="txtBRVChequeAmount" type="text" />
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid" style="display: none;">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Bank Account</label>
                                                <div class="span6">
                                                    <select id="extraAccountHeadBRV">
                                                    </select>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>



                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <div class="form-row row-fluid">
                                            <div class="span12">

                                                <table class="responsive table table-bordered" id="tbBankRecepitVoucherAccountHead">
                                                    <thead>
                                                        <tr>
                                                            <th>Account
                                                            </th>
                                                            <th>Narration
                                                            </th>
                                                            <th>Amount
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
                                                                    <select class="clsAccountHeadBRV">
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
                                                                    <input type="text" class="txtBankReceiptAmount" />
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsBRVCancelHead" src="Images/RowDelete.png" style="width: 20px;" />
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsBRVAddHead" src="Images/addrecord.png" style="width: 20px;" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="responsive table table-bordered" id="tbAccountHeadTotalBRV">
                                                    <thead style="background: rgb(250, 250, 250);">
                                                        <tr>
                                                            <td colspan="2">
                                                                <div style="width: 90%;">
                                                                    <label id="lblBRVAmountInWord" style="color: #9C303F; font-weight: bold; font-size: large; font-style: italic;"></label>
                                                                </div>
                                                            </td>

                                                            <td style="width: 100px;">
                                                                <div style="width: 90%;">
                                                                    <label id="lblBRVTotalAmount" style="font-weight: bold; font-size: medium; color: green;"></label>
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;"></td>
                                                            <td style="width: 40px;"></td>
                                                        </tr>
                                                    </thead>
                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <button id="btnSaveBRV" type="button" class="btn btn-primary" style="margin-left: 70%;">Save</button>
                                         &nbsp;&nbsp;&nbsp;
                                        <a id="PrintVoucherBRV" href="BankVoucherRpt.aspx?ID=12" target="_blank">Print Voucher</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%--end Bank receipt voucher--%>
                </div>
            </div>
        </div>
    </div>



</asp:Content>
