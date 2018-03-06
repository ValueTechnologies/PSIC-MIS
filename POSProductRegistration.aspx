<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSProductRegistration.aspx.cs" Inherits="PSIC.POSProductRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Product Registration');
            LoadCategories();

            $('#btnSaveProduct').bind('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSProductRegistration.aspx/SaveProduct",
                    data: "{  'PID' : '" + $('#btnSaveProduct').attr('tag') + "' , 'SubCateID' : '" + $('#ddlSubCategory').val() + "', 'ProductName' : '" + $('#txtName').val() + "', 'Features' : '" + $('#txtFeatures').val() + "' , 'MinimumInventory' : '" + $('#txtMinimumInventoryLevel').val() + "'}",
                    success: function (response) {
                        alert(response.d);
                        $('#txtName').val('');
                        $('#txtFeatures').val('');
                        $('#txtMinimumInventoryLevel').val('');
                        $('#btnSaveProduct').attr('tag', 0);
                        LoadProducts();
                    }
                });
            });

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
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.ProductName + ' </td><td style="text-align : left;"> ' + item.Features + ' </td> <td style="text-align : left;"> ' + item.MinimumInventory + ' </td><td  style="text-align : left;"> <button tag="' + item.ProductID + '" type="button" class="btn btn-link clsProducts"> Edit</button>    </td></tr>';

                            });
                            $('#tbAllProducts tbody').html(Out);

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
            $('#ddlSubCategory').bind('change', LoadProducts);

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

        });

        //end ready



        $('body').on({
            click: function () {

                $('#txtMinimumInventoryLevel').val($(this).parent().prev().html());
                $('#txtFeatures').val($(this).parent().prev().prev().html());
                $('#txtName').val($(this).parent().prev().prev().prev().html());
                $('#btnSaveProduct').attr('tag', $(this).attr('tag'));
            }
        }, '.clsProducts');





    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create New Product</span>
                    </h4>
                    <a href="dvNewProduct" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewProduct">

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
                                <input id="txtName" type="text" class="span4 frmCtrl" />
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
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Minimum Inventory : </label>
                                <input id="txtMinimumInventoryLevel" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSaveProduct" tag="0" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbAllProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo
                                            </th>
                                            <th>Product 
                                            </th>
                                            <th>Features
                                            </th>
                                            <th>Minimum Inventory Level
                                            </th>
                                            <th>Edit
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
