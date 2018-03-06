<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSDamageProduct.aspx.cs" Inherits="PSIC.POSDamageProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Damage Product');
            $('#txtDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });


            LoadCategories();


            function LoadCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/GetCategories",
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
                    url: "POSReceipt.aspx/GetSubCategories",
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

            $('#btnSearchProduct').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProduct",
                    data: "{ 'CatID' : '" + $('#ddlCategory').val() + "', 'SubCatID' : '" + $('#ddlSubCategory').val() + "','ProductName' : '" + $('#txtSearchName').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td>' + item.Srno + '</td><td style="text-align : left;">' + item.ProductName + ' </td> <td style="text-align : left;">' + item.Features + ' </td>  <td><button tag="' + item.ProductID + '" type="button" class="btn btn-link clsProduct">Select</button>   </td> </tr>';
                            });
                            $('#tbSearchedProducts tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            });


            $('#btnAddProductToCart').bind('click', function (e) {
                e.preventDefault();
                if (parseInt($('#ddlSelectedProductPPU option:selected').attr('qty'), 10) == 0) {
                    alert('Sorry Items not available...');
                    return;
                }


                if ($('#ddlSelectedProductPPU option:selected').val() == "---Select---") {
                    alert('Please select item Tag...');
                    return;
                }



                $('#tbCartProducts').append('<tr><td>' + $('#txtSelectedProduct').val() + ' </td> <td> ' + $('#ddlProductTag').val() + '</td><td> ' + $('#ddlSelectedProductPPU').val() + ' </td><td><img prodid="' + $('#btnAddProductToCart').attr('prodid') + '" UP="' + $('#ddlSelectedProductPPU').val() + '" tag="' + $('#ddlProductTag option:selected').attr('stockid') + '" class="clsCancelCartProduct" src="Images/RowDelete.png" style="width: 20px;">  </td> </tr>');
                //$('#txtSelectedProduct').val('');
                //$('#txtSelectedProductPPU').val('');
                //$('#txtSelectedProductAvailableQty').val('');
                //$('#txtSelectedProductDamageQty').val('');
                //$('#txtSelectedProductAmount').val('');




                var qty = parseInt($('#ddlSelectedProductPPU option:selected').attr('qty'), 10) - 1;
                $('#ddlSelectedProductPPU option:selected').removeAttr('qty');
                $('#ddlSelectedProductPPU option:selected').attr('qty', qty);
                $('#txtSelectedProductAvailableQty').val(qty);


                $('#ddlProductTag option:selected').remove();


            });


            $('#btnSave').bind('click', function () {

                if ($('#txtDate').val() == "") {
                    alert('Please Select Date...');
                    return;
                }


                if ($('#txtNote').val() == "") {
                    alert('Please mension reason...');
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSDamageProduct.aspx/SaveDamageProduct",
                    data: "{ 'Date' : '" + $('#txtDate').val() + "', 'Note' : '" + $('#txtNote').val() + "' }",
                    success: function (response) {
                        try {
                            var DamageID = response.d;
                            var stockID = [], ProductId = [], Qty = [], UnitPrice = [];

                            $('.clsCancelCartProduct').each(function (i, item) {
                                ProductId[i] = $(this).attr('prodid');
                            });


                            $('.clsCancelCartProduct').each(function (i, item) {
                                stockID[i] = $(this).attr('tag');
                            });

                            $('.clsCancelCartProduct').each(function (i, item) {
                                UnitPrice[i] = $(this).attr('UP');
                            });

                            $('.clsCancelCartProduct').each(function (i, item) {
                                Qty[i] = 1;
                            });



                            for (var index = 0; index < ProductId.length ; index++) {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "POSDamageProduct.aspx/SaveDamageDetail",
                                    data: "{    'StockID' : '" + stockID[index] + "', 'DamageID' : '" + DamageID + "', 'ProductID' : '" + ProductId[index] + "',   'Qty' : '" + Qty[index] + "', 'UnitPrice' : '" + UnitPrice[index] + "' }",
                                    success: function (response) {

                                    }
                                });
                                if (index == (ProductId.length - 1)) {
                                    alert('Save Successfully!');
                                    $('#tbCartProducts tbody').html('');

                                    $('#txtDate').val('');
                                    $('#txtNote').val('');


                                }
                            }


                               

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });




            });


        });
        //end Ready

        function LoadProductPriceandQty(ProductID) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "POSReceipt.aspx/SearchProductPriceAndQty",
                data: "{ 'ProductId' : '" + ProductID + "' }",
                success: function (response) {
                    try {
                        var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                        $.each(jData, function (i, item) {
                            Out = Out + '<option qty= ' + item.Qty + '>' + item.SalesPricePerUnit + '</option>';
                        });

                        $('#ddlSelectedProductPPU').html(Out);
                        $('#ddlSelectedProductPPU').removeAttr('disabled');
                        $('#txtSelectedProductAvailableQty').val($('#ddlSelectedProductPPU option:selected').attr('qty'));

                        LoadTags(ProductID);
                    } catch (e) {
                        alert(e.message);
                    }
                }
            });
        }


        function LoadTags(ProductID) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "POSReceipt.aspx/SearchLoadTags",
                data: "{ 'ProductId' : '" + ProductID + "',  'PricePerUnit' : '" + $('#ddlSelectedProductPPU').val() + "'}",
                success: function (response) {
                    try {
                        var jData = $.parseJSON(response.d), Out = "<option StockID= '0'>---Select---</option>", OutDDL = "";
                        $.each(jData, function (i, item) {
                            Out = Out + '<option StockID= ' + item.StockID + '>' + item.Tag + '</option>';
                        });

                        $('#ddlProductTag').html(Out);

                        $('.clsCancelCartProduct').each(function (i, item) {
                            $('#ddlProductTag option[value=' + $(this).parent().prev().prev().html().trim() + ']').remove();
                        });

                        $('#ddlProductTag').removeAttr('disabled');
                    } catch (e) {
                        alert(e.message);
                    }
                }
            });
        }



        $('body').on({
            click: function () {
                var ProductID = $(this).attr('tag');

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProductDetail",
                    data: "{ 'ProductId' : '" + ProductID + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                $('#txtSelectedProduct').val(item.ProductName);
                                $('#txtSelectedProductPPU').val(item.SalesPricePerUnit);
                                $('#txtSelectedProductAvailableQty').val(item.Qty);
                                $('#btnAddProductToCart').attr('tag', item.StockID);
                                $('#btnAddProductToCart').attr('ProdID', ProductID);
                                LoadProductPriceandQty(ProductID)
                            });
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });


            }
        }, '.clsProduct');


        $('body').on({
            change: function (e) {
                e.preventDefault();
                $('#txtSelectedProductAvailableQty').val($('#ddlSelectedProductPPU option:selected').attr('qty'));
                LoadTags($('#btnAddProductToCart').attr('prodid'));
            }
        }, '#ddlSelectedProductPPU');

        $('body').on({
            blur: function () {
                $('#txtSelectedProductAmount').val($('#txtSelectedProductPPU').val() * $('#txtSelectedProductDamageQty').val());
            }
        }, '#txtSelectedProductDamageQty');


        $('body').on({
            click: function () {
                $(this).parent().parent().remove();

            }
        }, '.clsCancelCartProduct');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Product</span>
                    </h4>
                    <a href="dvSearchProduct" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchProduct">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Category : </label>
                                <div class="controls sel span8">
                                    <select class="nostyle frmCtrl " id="ddlCategory">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Sub Category : </label>
                                <div class="controls sel span8">
                                    <select class="nostyle frmCtrl" id="ddlSubCategory">
                                    </select>
                                </div>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Product Name : </label>
                                <input id="txtSearchName" type="text" class="span8 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6" style="margin-left: 0px;">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" id="btnSearchProduct" class="btn btn-primary span2" style="margin-left: 0px;">Search</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbSearchedProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">SrNo
                                            </th>
                                            <th style="width: 35%;">Product 
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
                        <span>Product Detail</span>
                    </h4>
                    <a href="dvProductDetail" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvProductDetail">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Product : </label>
                                <input id="txtSelectedProduct" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Per Unit Perice : </label>
                                <div class="span8 controls sel">
                                    <select id="ddlSelectedProductPPU" class="nostyle frmCtrl">
                                    </select>
                                </div>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Available Qty : </label>
                                <input id="txtSelectedProductAvailableQty" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Product Tag : </label>
                                <div class="span8 controls sel">
                                    <select id="ddlProductTag" class="nostyle frmCtrl">
                                    </select>
                                </div>
                            </div>
                            <div class="span6" style="display: none;">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Sales Qty : </label>
                                <input id="txtSelectedProductSalesQty" type="text" class="span8 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid" style="display: none;">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Total Amount : </label>
                                <input id="txtSelectedProductAmount" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>

                            <div class="span6">
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6" style="margin-left: 0px;">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" id="btnAddProductToCart" class="btn btn-primary span3" style="margin-left: 0px;">Add</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbCartProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 35%;">Product 
                                            </th>
                                            <th>Tag
                                            </th>
                                            <th>Total Price
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
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Damage Date : </label>
                                <input id="txtDate" type="text" class="span8 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Reason : </label>
                                <textarea rows="2" cols="5" class="span8" id="txtNote"></textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal"></label>
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
