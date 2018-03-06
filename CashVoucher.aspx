<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="CashVoucher.aspx.cs" Inherits="PSIC.CashVoucher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        ///variable Declarations
        var AccountHeadSelectCPV, AccountHeadSelectCRV;
        //end variable declaration
        $(document).ready(function () {
            $('.heading h3').html('Cash Voucher');
            $('#txtCPVEntryDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtCRVEntryDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            

            NewVoucherNo();
            CashAccountHead();
            EntryDate();
            LoadAccountHead();

            $(".txtCashPaymentAmount").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    $("#errmsg").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });

            $(".txtCashReceiptAmount").keypress(function (e) {
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
                    url: "CashVoucher.aspx/CPVVNo",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtCPVVoucherNo').val(jData[0].Voch);
                    }
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/CRVVNo",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtCRVVoucherNo').val(jData[0].Voch);
                    }
                });
            }


            function CashAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/CashAccountHead",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });

                        $('#ddlCPVCashAccount').html(Out);
                        $('#ddlCPVCashAccount').prev().html($('#ddlCPVCashAccount option:selected').text());

                        $('#ddlCRVCashAccount').html(Out);
                        $('#ddlCRVCashAccount').prev().html($('#ddlCRVCashAccount option:selected').text());
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

                        $('#txtCPVEntryDate').val(jData[0].EntryDate);
                        $('#txtCRVEntryDate').val(jData[0].EntryDate);
                    }
                });
            }


            function LoadAccountHead() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/LoadAccountHeadCPV",
                    data: "{  }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });
                        AccountHeadSelectCPV = Out;
                        $('.clsAccountHeadCPV').html(Out);
                        $('.clsAccountHeadCPV').prev().html($('.clsAccountHeadCPV option:selected').text());
                        $('#extraAccountHeadCPV').html(Out);
                        $('#extraAccountHeadCPV').prev().html($('#extraAccountHeadCPV option:selected').text());
                    }
                });


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/LoadAccountHeadCRV",
                    data: "{  }",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out;

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.AccountID + '">' + item.HeadName + '</option>';
                        });
                        AccountHeadSelectCRV = Out;
                        $('.clsAccountHeadCRV').html(Out);
                        $('.clsAccountHeadCRV').prev().html($('.clsAccountHeadCRV option:selected').text());
                        $('#extraAccountHeadCRV').html(Out);
                        $('#extraAccountHeadCRV').prev().html($('#extraAccountHeadCRV option:selected').text());
                    }
                });

            }


            //Cash Payment Voucher Save

            $('#btnSaveCPV').bind('click', function () {
                if ($('#btnSaveCPV').text() == 'Add New Voucher') {
                    window.location.href = 'CashVoucher.aspx';
                }
                if ($('#txtCPVEntryDate').val().trim() == "") {
                    alert('Please enter date of entry.....');
                    return;
                }


                //check date validation

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/DateValidation",
                    data: "{ 'ValidationDate' : '" + $('#txtCPVEntryDate').val().trim() + "'}",
                    success: function (response) {
                        var msg = response.d;

                        if (msg == "InvalidDate") {
                            alert('Please enter valid account date....');
                            return;
                        }
                        else {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "CashVoucher.aspx/SaveHead",
                                data: "{ 'VNo' : '" + $('#txtCPVVoucherNo').val() + "', 'EntryDate' : '" + $('#txtCPVEntryDate').val() + "'}",
                                success: function (response) {
                                    var VID = $.parseJSON(response.d);
                                    $('#PrintVoucherCPV').attr('href', 'JCVoucherPrintRpt.aspx?ID=' + VID);
                                    $.ajax({
                                        type: "POST",
                                        contentType: "application/json; charset=utf-8",
                                        dataType: "json",
                                        url: "CashVoucher.aspx/SaveDetail",
                                        data: "{ 'vID' : '" + VID + "', 'Head' : '" + $('#ddlCPVCashAccount').val() + "', 'Narration' : '', 'Dr' : '0', 'Cr' : '" + $('#lblCPVTotalAmount').html() + "'}",
                                        success: function (response) {

                                        }
                                    });


                                    $('.clsAccountHeadCPV').each(function (i, item) {
                                        $.ajax({
                                            type: "POST",
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            url: "CashVoucher.aspx/SaveDetail",
                                            data: "{ 'vID' : '" + VID + "', 'Head' : '" + $(this).val() + "', 'Narration' : '" + $(this).parent().parent().parent().next().find('.txtNarration').val() + "', 'Dr' : '" + $(this).parent().parent().parent().next().next().find('.txtCashPaymentAmount').val() + "', 'Cr' : '0'}",
                                            success: function (response) {

                                            }
                                        });
                                    });

                                    $('.text').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsAccountHeadCRV').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsAccountHeadCPV').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsCPVCancelHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCPVCancelHead');
                                    });

                                    $('.clsCPVAddHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCPVAddHead');
                                    });

                                    $('#ddlCPVCashAccount').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });


                                    $('#ddlCRVCashAccount').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsCRVCancelHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCRVCancelHead');
                                    });

                                    $('.clsCRVAddHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCRVAddHead');
                                    });



                                    alert('Save successfully!');
                                    $('#btnSaveCPV').text('Add New Voucher');
                                }
                            });
                        }

                    }
                });

                //date validation end
            });
            //end cash payment voucher save




            //cash Recipt voucher save

            $('#btnSaveCRV').bind('click', function () {
                if ($('#btnSaveCRV').text() == 'Add New Voucher') {
                    window.location.href = 'CashVoucher.aspx';
                }
                if ($('#txtCRVEntryDate').val().trim() == "") {
                    alert('Please enter date of entry.....');
                    return;
                }


                //check date validation

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CashVoucher.aspx/DateValidation",
                    data: "{ 'ValidationDate' : '" + $('#txtCRVEntryDate').val().trim() + "'}",
                    success: function (response) {
                        var msg = response.d;

                        if (msg == "InvalidDate") {
                            alert('Please enter valid account date....');
                            return;
                        }
                        else {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "CashVoucher.aspx/SaveHead",
                                data: "{ 'VNo' : '" + $('#txtCRVVoucherNo').val() + "', 'EntryDate' : '" + $('#txtCRVEntryDate').val() + "'}",
                                success: function (response) {
                                    var VID = $.parseJSON(response.d);
                                    $('#PrintVoucherCRV').attr('href', 'JCVoucherPrintRpt.aspx?ID=' + VID);
                                    $.ajax({
                                        type: "POST",
                                        contentType: "application/json; charset=utf-8",
                                        dataType: "json",
                                        url: "CashVoucher.aspx/SaveDetail",
                                        data: "{ 'vID' : '" + VID + "', 'Head' : '" + $('#ddlCRVCashAccount').val() + "', 'Narration' : '', 'Dr' : '" + $('#lblCRVTotalAmount').html() + "', 'Cr' : '0'}",
                                        success: function (response) {

                                        }
                                    });


                                    $('.clsAccountHeadCRV').each(function (i, item) {
                                        $.ajax({
                                            type: "POST",
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            url: "CashVoucher.aspx/SaveDetail",
                                            data: "{ 'vID' : '" + VID + "', 'Head' : '" + $(this).val() + "', 'Narration' : '" + $(this).parent().parent().parent().next().find('.txtNarration').val() + "', 'Dr' : '0', 'Cr' : '" + $(this).parent().parent().parent().next().next().find('.txtCashReceiptAmount').val() + "'}",
                                            success: function (response) {

                                            }
                                        });
                                    });



                                    $('.text').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsAccountHeadCRV').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsAccountHeadCPV').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsCPVCancelHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCPVCancelHead');
                                    });

                                    $('.clsCPVAddHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCPVAddHead');
                                    });

                                    $('#ddlCPVCashAccount').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });


                                    $('#ddlCRVCashAccount').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                    });

                                    $('.clsCRVCancelHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCRVCancelHead');
                                    });

                                    $('.clsCRVAddHead').each(function () {
                                        $(this).prop('disabled', 'disabled');
                                        $(this).removeClass('clsCRVAddHead');
                                    });


                                    alert('Save successfully!');
                                    $('#btnSaveCRV').text('Add New Voucher');
                                }
                            });
                        }

                    }
                });

                //date validation end
            });

            //end cash recipt voucher save

        });

        //end ready


        //cash payment voucher
        $('body').on({
            click: function () {
                var strHeadName = $('#extraAccountHeadCPV  option:first').text();
                var str = '<tr><td><div style="width: 90%;"><div class="selector" id="uniform-undefined"><span>' + strHeadName + '</span><select class="clsAccountHeadCPV" style="opacity: 0;">' + AccountHeadSelectCPV + '</select></div></div></td><td><div style="width: 90%;"><input type="text" class="txtNarration text"></div></td><td style="width: 100px;"><div style="width: 90%;"><input type="text" class="txtCashPaymentAmount text"></div></td><td style="width: 40px;"><img class="clsCPVCancelHead" src="Images/RowDelete.png" style="width: 20px;"></td><td style="width: 40px;"><img class="clsCPVAddHead" src="Images/addrecord.png" style="width: 20px;"></td></tr>';
                $('#tbCashPaymentVoucherAccountHead tbody').append(str);

            }
        }, '.clsCPVAddHead');

        $('body').on({
            change: function () {
                $(this).prev().html($('#extraAccountHeadCPV option[value=' + $(this).val() + ']').text());
            }
        }, '.clsAccountHeadCPV');


        $('body').on({
            click: function () {

                $(this).parent().parent().remove();

            }
        }, '.clsCPVCancelHead');


        $('body').on({
            blur: function () {
                CalculateCPVTotalAmount();
            }
        }, '.txtCashPaymentAmount');

        //end cash payment voucher

        //cash receipt voucher
        $('body').on({
            click: function () {
                var strHeadName = $('#extraAccountHeadCRV  option:first').text();
                var str = '<tr><td><div style="width: 90%;"><div class="selector" id="uniform-undefined"><span>' + strHeadName + '</span><select class="clsAccountHeadCRV" style="opacity: 0;">' + AccountHeadSelectCRV + '</select></div></div></td><td><div style="width: 90%;"><input type="text" class="txtNarration text"></div></td><td style="width: 100px;"><div style="width: 90%;"><input type="text" class="txtCashReceiptAmount text"></div></td><td style="width: 40px;"><img class="clsCRVCancelHead" src="Images/RowDelete.png" style="width: 20px;"></td><td style="width: 40px;"><img class="clsCRVAddHead" src="Images/addrecord.png" style="width: 20px;"></td></tr>';
                $('#tbCashRecepitVoucherAccountHead tbody').append(str);

            }
        }, '.clsCRVAddHead');


        $('body').on({
            change: function () {
                $(this).prev().html($('#extraAccountHeadCRV option[value=' + $(this).val() + ']').text());
            }
        }, '.clsAccountHeadCRV');


        $('body').on({
            click: function () {

                $(this).parent().parent().remove();

            }
        }, '.clsCRVCancelHead');

        $('body').on({
            blur: function () {
                CalculateCRVTotalAmount();
            }
        }, '.txtCashReceiptAmount');




        //end cash receipt voucher

        function CalculateCPVTotalAmount() {
            
            var TotalAmount = 0;
            $('.txtCashPaymentAmount').each(function (i, item) {
                TotalAmount = TotalAmount + parseInt($(this).val());
            });
            $('#lblCPVTotalAmount').html(TotalAmount);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "CashVoucher.aspx/NumericToWord",
                data: "{ 'Value' : '" + TotalAmount + "'}",
                success: function (response) {
                    $('#lblCPVAmountInWord').html(response.d);
                }
            });

        }


        function CalculateCRVTotalAmount() {

            var TotalAmount = 0;
            $('.txtCashReceiptAmount').each(function (i, item) {
                TotalAmount = TotalAmount + parseInt($(this).val());
            });
            $('#lblCRVTotalAmount').html(TotalAmount);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "CashVoucher.aspx/NumericToWord",
                data: "{ 'Value' : '" + TotalAmount + "'}",
                success: function (response) {
                    $('#lblCRVAmountInWord').html(response.d);
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
                    <li class="active"><a href="#dvCashPaymentVoucher" data-toggle="tab">Cash Payment Voucher</a></li>
                    <li class=""><a href="#dvCashReceiptVoucher" data-toggle="tab">Cash Receipt Voucher</a></li>
                </ul>

                <div class="tab-content">
                    <%--start cash payment Voucher--%>
                    <div class="tab-pane fade active in" id="dvCashPaymentVoucher">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">

                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Voucher No.</label>
                                                <input class="span8" id="txtCPVVoucherNo" type="text" />
                                            </div>
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Entry Date</label>
                                                <input class="span6" id="txtCPVEntryDate" type="text" />
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cash Account</label>
                                                <div class="span8">
                                                    <select id="ddlCPVCashAccount">
                                                    </select>

                                                </div>
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid" style="display:none;">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cash Account</label>
                                                <div class="span8">
                                                    <select id="extraAccountHeadCPV">
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

                                                <table class="responsive table table-bordered" id="tbCashPaymentVoucherAccountHead">
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
                                                                    <select class="clsAccountHeadCPV">
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
                                                                    <input type="text" class="txtCashPaymentAmount" />
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsCPVCancelHead" src="Images/RowDelete.png" style="width: 20px;" />
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsCPVAddHead" src="Images/addrecord.png" style="width: 20px;" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="responsive table table-bordered" id="tbAccountHeadTotal">
                                                    <thead style="background: rgb(250, 250, 250);">
                                                        <tr>
                                                            <td colspan="2">
                                                                <div style="width: 90%;">
                                                                    <label id="lblCPVAmountInWord" style="color: #9C303F; font-weight: bold; font-size: large; font-style: italic;"></label>
                                                                </div>
                                                            </td>

                                                            <td style="width: 100px;">
                                                                <div style="width: 90%;">
                                                                    <label id="lblCPVTotalAmount" style="font-weight: bold; font-size: medium; color: green;"></label>
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
                                        <button id="btnSaveCPV" type="button" class="btn btn-primary" style="margin-left: 70%;">Save</button>
                                        <a id="PrintVoucherCPV"  target="_blank">Print Voucher</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <%--end cash payment voucher--%>
                    <%--start cash receipt voucher--%>
                    <div class="tab-pane fade" id="dvCashReceiptVoucher">
                        
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">

                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Voucher No.</label>
                                                <input class="span8" id="txtCRVVoucherNo" type="text" />
                                            </div>
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Entry Date</label>
                                                <input class="span6" id="txtCRVEntryDate" type="text" />
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cash Account</label>
                                                <div class="span8">
                                                    <select id="ddlCRVCashAccount">
                                                    </select>

                                                </div>
                                            </div>
                                        </div>


                                        <div class="form-row row-fluid" style="display:none;">
                                            <div class="span6">
                                                <label class="form-label span4" for="normal">Cash Account</label>
                                                <div class="span8">
                                                    <select id="extraAccountHeadCRV">
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

                                                <table class="responsive table table-bordered" id="tbCashRecepitVoucherAccountHead">
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
                                                                    <select class="clsAccountHeadCRV">
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
                                                                    <input type="text" class="txtCashReceiptAmount" />
                                                                </div>
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsCRVCancelHead" src="Images/RowDelete.png" style="width: 20px;" />
                                                            </td>
                                                            <td style="width: 40px;">
                                                                <img class="clsCRVAddHead" src="Images/addrecord.png" style="width: 20px;" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="responsive table table-bordered" id="tbAccountHeadTotalCRV">
                                                    <thead style="background: rgb(250, 250, 250);">
                                                        <tr>
                                                            <td colspan="2">
                                                                <div style="width: 90%;">
                                                                    <label id="lblCRVAmountInWord" style="color: #9C303F; font-weight: bold; font-size: large; font-style: italic;"></label>
                                                                </div>
                                                            </td>

                                                            <td style="width: 100px;">
                                                                <div style="width: 90%;">
                                                                    <label id="lblCRVTotalAmount" style="font-weight: bold; font-size: medium; color: green;"></label>
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
                                        <button id="btnSaveCRV" type="button" class="btn btn-primary" style="margin-left: 70%;">Save</button>
                                        <a id="PrintVoucherCRV"  target="_blank">Print Voucher</a>
                                    </div>
                                </div>
                            </div>
                        </div>





                    </div>

                    <%--end cash receipt voucher--%>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
