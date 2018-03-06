<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSStockIn.aspx.cs" Inherits="PSIC.POSStockIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Stock In');
            $('#txtSearchPurchaseOrderDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtPurchasingDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            LoadCategories();
            GetSPP();
            LoadPONumbers();

            function LoadPONumbers() {
                var selected_po = '<%= Session["selected_po"] %>';
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSStockIn.aspx/LoadPONumbers",
                    data: "",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";
                            Out = Out + '<option value="0"> -- ALL -- </option>';
                            $.each(jData, function (i, item) {
                                if (item.PONumber == selected_po) {
                                    Out = Out + '<option selected>' + item.PONumber + '</option>';
                                } else {
                                    Out = Out + '<option>' + item.PONumber + '</option>';
                                }

                            });
                            $('#ddlPO').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });

            }

            function LoadCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ProductCategory.aspx/GetCategories",
                    data: "{ }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                OutDDL = OutDDL + '<option value="' + item.CategoryID + '">' + item.Category + '</option>';
                            });
                            $('#ddlCategory').html(OutDDL);
                            LoadSubCategories();

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            $('#ddlCategory').bind('change', LoadSubCategories);

            function LoadSubCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ProductCategory.aspx/GetSubCategories",
                    data: "{ 'CatID' : '" + $('#ddlCategory').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {

                                OutDDL = OutDDL + '<option value="' + item.SubCategoryID + '">' + item.SubCategory + '</option>';
                            });
                            $('#ddlSubCategory').html(OutDDL);
                            LoadProducts();

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

            $('#ddlSubCategory').bind('change', LoadProducts);

            function LoadProducts() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSProductRegistration.aspx/GetProducts",
                    data: "{ 'SubCatID' : '" + $('#ddlSubCategory').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                OutDDL = OutDDL + '<option value="' + item.ProductID + '">' + item.ProductName + '</option>';

                            });
                            $('#ddlProduct').html(OutDDL);

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

            function GetSPP() {
                $.ajax({
                    type: "POST",
                    url: "POSStockIn.aspx/GetSalesProfitPercent",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var SalePP = $.parseJSON(response.d);
                         SalesProfitPercent = SalePP[0]["SalesProfitPercent"];
                    }
                });
            }

            $('#btnSearchPurchaseOrder').bind('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSStockIn.aspx/GetPurchaseOrder",
                    data: "{ 'PurchaseOrderNo' : '" + $('#ddlPO').val() + "', 'PurchasingDate' : '" + $('#txtSearchPurchaseOrderDate').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + ' </td> <td> ' + item.PONumber + ' </td> <td> ' + item.SupplierName + ' </td><td> ' + item.Remaks + ' </td><td> <button tag="' + item.PurchaseOrderID + '" type="button" class="btn btn-link clsPurchaseOrder">Select </button> </td></tr>';

                            });
                            $('#tbSearchedPurchaseOrder tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            });

            $('#btnAddProduct').bind('click', function () {
                var ProductTotalAmount = 0;
                if ($('#txtProductQty').val() != "" && $('#txtPurchaseProductPricePerUnit').val() != "") {
                    ProductTotalAmount = $('#txtProductQty').val() * $('#txtPurchaseProductPricePerUnit').val();
                }
                $('#tbStock tbody').append('<tr><td> ' + $('#ddlProduct option:selected').text() + ' </td> <td> <textarea cols="20" rows="4"  class="span10 frmCtrl txtPurchaseOrderSpecifications" >' + $('#txtPurchaseOrderSpecifications').val() + '</textarea> </td> <td> <input type="text" class="clsQty span6" value="' + $('#txtProductQty').val() + '" /> </td><td> <input type="text" class="clsPurchasePricePerUnit span6" value="' + $('#txtPurchaseProductPricePerUnit').val() + '"  /> </td><td> <input type="text" class="clsSalesProfitPercent span6" value="' + parseInt(SalesProfitPercent) + '"  /> </td><td> <input type="text" class="clsSalesPricePerUnit span6" value="' + $('#txtSalesProductPricePerUnit').val() + '"  /> </td><td> <input type="text" class="clsTotalPurchasingAmount span6" value="' + ProductTotalAmount + '" disabled="disabled"  /> </td><td> <img tag="' + $('#ddlProduct').val() + '" class="clsCancelProduct" src="Images/RowDelete.png" style="width: 20px;"> </td></tr>');
                $('#txtPurchaseOrderSpecifications').val('');
                $('#txtProductQty').val('');
                $('#txtPurchaseProductPricePerUnit').val('');
                $('#txtSalesProductPricePerUnit').val('');
                CalculateTotalPurchaseAmount();

            });

            $('#btnSaveStock').bind('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSStockIn.aspx/SavePurchasing",
                    data: "{  'PurchasingDate' : '" + $('#txtPurchasingDate').val() + "', 'PurchasingAmount' : '" + $('#txtPurchasingAmount').val() + "', 'PurchaseOrder' : '" + $('#btnSaveStock').attr('tag') + "'}",
                    success: function (response) {
                        var PurchasingID = response.d;
                        var ProductId = [], Specification = [], Qty = [], PPPU = [], SPPU = [];

                        $('#lnkPrint').attr('href', 'POSPurchaseBillRpt.aspx?ID=' + PurchasingID);
                        $('#lnkPrint').show();

                        $('.clsCancelProduct').each(function (i, item) {
                            ProductId[i] = $(this).attr('tag');
                        });

                        $('.txtPurchaseOrderSpecifications').each(function (i, item) {
                            Specification[i] = $(this).val();
                        });

                        $('.clsQty').each(function (i, item) {
                            Qty[i] = $(this).val();
                        });

                        $('.clsPurchasePricePerUnit').each(function (i, item) {
                            PPPU[i] = $(this).val();
                        });

                        $('.clsSalesPricePerUnit').each(function (i, item) {
                            SPPU[i] = $(this).val();
                        });


                        for (var index = 0; index < ProductId.length ; index++) {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "POSStockIn.aspx/SavePurchasingDetail",
                                data: "{ 'POID' : '" + $('#btnSaveStock').attr('tag') + "', 'PurchasingID' : '" + PurchasingID + "',   'ProductId' : '" + ProductId[index] + "',      'Specification' : '" + Specification[index] + "' ,'Qty' : '" + Qty[index] + "', 'PPPU' : '" + PPPU[index] + "', 'SPPU' : '" + SPPU[index] + "'    }",
                                success: function (response) {

                                }
                            });
                            if (index == (ProductId.length - 1)) {
                                alert('Stock In Successfully!');
                                $('#tbStock tbody').html('');
                                $('#txtPurchasingDate').val('');
                                $('#txtPurchasingAmount').val('');
                            }
                        }

                    }
                });
            });

           


        });
        //end ready

        $('body').on({
            click: function () {
                var PurchaseOrderID = $(this).attr('tag');

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSStockIn.aspx/GetPurchaseOrderDetail",
                    data: "{ 'PurchaseID' : '" + $(this).attr('tag') + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.ProductName + ' </td> <td> <textarea cols="20" rows="4"  class="span10 frmCtrl txtPurchaseOrderSpecifications" >' + item.Features + '</textarea> </td> <td> <input type="text" class="clsQty span6" value="' + item.Qty + '" /> </td><td> <input type="text" class="clsPurchasePricePerUnit span6"  /> </td> <td> <input type="text" class="clsSalesProfitPercent span6" value="' + parseInt(SalesProfitPercent) + '"  /> </td> <td> <input type="text" class="clsSalesPricePerUnit span6"  /> </td><td> <input type="text" class="clsTotalPurchasingAmount span6" disabled="disabled"  /> </td><td> <img tag="' + item.ProductId + '" class="clsCancelProduct" src="Images/RowDelete.png" style="width: 20px;"> </td></tr>';

                            });
                            $('#tbStock tbody').html(Out);
                            $('#btnSaveStock').attr('tag', PurchaseOrderID);


                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }
        }, '.clsPurchaseOrder');

        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCancelProduct');

        $('body').on({
            blur: function () {

                var ProductAmount = $(this).val() * $(this).parent().prev().find('.clsQty').val();
                var SalesProfitPercent = ($(this).val() * $(this).parent().next().find('.clsSalesProfitPercent').val()) / 100;
                var SalesProfitPercentPerItem = parseInt($(this).val()) + parseInt(SalesProfitPercent);
                $(this).parent().next().next().next().find('.clsTotalPurchasingAmount').val(ProductAmount);
                $(this).parent().next().next().find('.clsSalesPricePerUnit').val(SalesProfitPercentPerItem);
                CalculateTotalPurchaseAmount();
            }
        }, '.clsPurchasePricePerUnit');

        $('body').on({
            blur: function () {

                var SalesProfitPercent = ($(this).val() * $(this).parent().prev().find('.clsPurchasePricePerUnit').val()) / 100;
                var SalesProfitPercentPerItem = parseInt($(this).parent().prev().find('.clsPurchasePricePerUnit').val()) + parseInt(SalesProfitPercent);
                $(this).parent().next().find('.clsSalesPricePerUnit').val(SalesProfitPercentPerItem);
            }
        }, '.clsSalesProfitPercent');

        function CalculateTotalPurchaseAmount() {
            var TotalAmount = 0;
            $('.clsTotalPurchasingAmount').each(function (i, item) {
                TotalAmount += parseInt($(this).val());

            });
            $('#txtPurchasingAmount').val(TotalAmount);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Purchase Order</span>
                    </h4>
                    <a href="dvSearchPurchaseOrder" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchPurchaseOrder">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Date Purchase Order : </label>
                                <input id="txtSearchPurchaseOrderDate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Purchase Order # : </label>
                                <div class="span4"  style="margin-left: 0px;">
                                    <select id="ddlPO" class="nostyle frmCtrl" name="ddlPO">
                                        
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal"></label>
                                <button type="button" class="btn btn-info" id="btnSearchPurchaseOrder">Search</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSearchedPurchaseOrder" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Sr #
                                            </th>
                                            <th>Order No
                                            </th>
                                            <th>Supplier
                                            </th>
                                            <th>Remaks 
                                            </th>
                                            <th>Select
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
                        <span>Stock</span>
                    </h4>
                    <a href="dvStockIn" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvStockIn">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Category : </label>
                                <div class="controls sel">
                                    <select class="nostyle frmCtrl span4" id="ddlCategory">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Sub Category : </label>
                                <div class="controls sel">
                                    <select class="nostyle frmCtrl span4" id="ddlSubCategory">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Product : </label>
                                <div class="controls sel">
                                    <select class="nostyle frmCtrl span4" id="ddlProduct">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Specifications : </label>
                                <textarea cols="5" rows="4" id="txtPurchaseOrderSpecifications" class="span4 frmCtrl"></textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Qty : </label>
                                <input id="txtProductQty" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Purchase Price Per Unit : </label>
                                <input id="txtPurchaseProductPricePerUnit" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Sales Price Per Unit : </label>
                                <input id="txtSalesProductPricePerUnit" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal"></label>
                                <button type="button" class="btn btn-info" id="btnAddProduct">Add</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbStock" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Product
                                            </th>
                                            <th>Specifications
                                            </th>
                                            <th>Qty
                                            </th>
                                            <th>Purchase Price Per Unit
                                            </th>
                                            <th>Sales Profit %
                                            </th>
                                            <th>Sales Price Per Unit
                                            </th>
                                            <th>Purchasing Total Amount
                                            </th>
                                            <th>Cancel
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Purchasing Date : </label>
                                <input id="txtPurchasingDate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Total Purchase Amount : </label>
                                <input id="txtPurchasingAmount" type="text" class="span4 frmCtrl" disabled="disabled" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal"></label>
                                <div style="margin-left: 0px;">
                                    <button type="button" class="btn btn-primary span2" id="btnSaveStock">Save</button>
                                    <a class="btn btn-link" id="lnkPrint" target="_blank" style="display: none;">Print Purchase Bill</a>
                                </div>

                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
