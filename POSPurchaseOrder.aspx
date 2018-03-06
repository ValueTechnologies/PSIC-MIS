<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSPurchaseOrder.aspx.cs" Inherits="PSIC.POSPurchaseOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Purchase Order');
            $('#txtOrderDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            LoadCategories();
            LoadSupplier();


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

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

            function LoadSupplier() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSupplierRegistration.aspx/GetSuppliers",
                    data: "{ }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {

                                OutDDL = OutDDL + '<option value="' + item.SupplierID + '">' + item.Name + '</option>';
                            });
                            $('#ddlSupplier').html(OutDDL);
                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }


            //Search Product
            $('#btnSearchProduct').bind('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSPurchaseOrder.aspx/GetProducts",
                    data: "{ 'SubCatID' : '" + $('#ddlSubCategory').val() + "' , 'ProductName' : '" + $('#txtSearchProductName').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.ProductName + ' </td><td style="text-align : left;"> ' + item.Features + ' </td><td  style="text-align : left;"> <button tag="' + item.ProductID + '" type="button" class="btn btn-link clsProducts"> Select</button>    </td></tr>';
                            });
                            $('#tbAllProducts tbody').html(Out);
                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            });
            //end Search product


            //Add to cart
            $('#btnAddToCart').bind('click', function () {
                $('#tbSelectedProducts tbody').append('<tr><td>' + $('#txtProductName').val() + '</td> <td>' + $('#txtFeatures').val() + '</td><td>' + $('#txtProductQty').val() + '</td> <td><img tag="' + $('#btnAddToCart').attr('tag') + '" class="clsCancelCart" src="Images/RowDelete.png" style="width: 20px;"></td></tr>');
                $('#txtProductName').val('');
                $('#txtFeatures').val('');
                $('#txtProductQty').val('');
            });
            //end add to cart


            //Purchase Order Save
            $('#btnSavePurchaseOrder').bind('click', function () {

                if ($('#tbSelectedProducts tbody').html() == "") {
                    alert('No Product in cart');
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSPurchaseOrder.aspx/SavePurchaseOrder",
                    data: "{ 'OrderDate' : '" + $('#txtOrderDate').val() + "', 'SupplierID' : '" + $('#ddlSupplier').val() + "', 'Note' : '" + $('#txtPurchaseOrderNote').val() + "' }",
                    success: function (response) {

                        var PurchseId = $.parseJSON(response.d);
                        var P_ID = [], Features = [], QTY = [];
                        $('.clsCancelCart').each(function (i, item) {
                            P_ID[i] = $(this).attr('tag');
                            Features[i] = $(this).parent().prev().prev().html();
                            QTY[i] = $(this).parent().prev().html();
                        });


                        for (var index = 0; index < P_ID.length; index++) {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "POSPurchaseOrder.aspx/SavePurchaseOrderDetail",
                                data: "{ 'PurchseId' : '" + PurchseId + "', 'ProductID' : '" + P_ID[index] + "', 'Features' : '" + Features[index] + "' , 'Qty' : '" + QTY[index] + "'}",
                                success: function (response) {

                                }
                            });
                            if (index == (P_ID.length - 1)) {
                                alert("Purchase Order Save Successfully!");
                                $('#tbSelectedProducts tbody').html('');
                                $('#txtOrderDate').val('');
                                $('#txtPurchaseOrderNote').val('');
                                $('#lnkPrint').attr('href', "PurchaseOrderReport.aspx?ID=" + PurchseId);
                                $('#lnkPrint').show();
                            }
                        }






                    }
                });



            });
            //End Purchase Order Save


        });

        $('body').on({
            click: function () {
                $('#txtProductName').val($(this).parent().prev().prev().html());
                $('#txtFeatures').val($(this).parent().prev().html());
                $('#btnAddToCart').attr('tag', $(this).attr('tag'));
            }
        }, '.clsProducts');

        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCancelCart');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>New Purchase Order</span>
                    </h4>
                    <a href="dvNewPurchaseOrder" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewPurchaseOrder">

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
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Product Name : </label>
                                <input id="txtSearchProductName" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal"></label>
                                <button type="button" id="btnSearchProduct" class="btn btn-info">Search</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbAllProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">Sr No
                                            </th>
                                            <th style="width: 35%">Product Name
                                            </th>
                                            <th>Features
                                            </th>
                                            <th style="width: 50px;">Select
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
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Product Name : </label>
                                <input id="txtProductName" type="text" class="span4 frmCtrl" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Features : </label>
                                <textarea cols="5" rows="4" id="txtFeatures" class="span4 frmCtrl"></textarea>
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
                                <label class="form-label span3" style="margin-top: 9px;" for="normal"></label>
                                <button type="button" id="btnAddToCart" class="btn btn-info">Add To Cart</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSelectedProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 35%">Product Name
                                            </th>
                                            <th>Features
                                            </th>
                                            <th>QTY
                                            </th>
                                            <th style="width: 50px;">Cancel
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
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Order Date : </label>
                                <input id="txtOrderDate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Supplier : </label>
                                <div class="controls sel">
                                    <select class="nostyle span4" id="ddlSupplier">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Remaks : </label>
                                <textarea cols="5" rows="4" id="txtPurchaseOrderNote" class="span4 frmCtrl"></textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSavePurchaseOrder" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                                <a class="btn btn-link" id="lnkPrint" target="_blank" style="display: none;">Print Purchase Order</a>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
