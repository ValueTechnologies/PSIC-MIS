<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSSearchItem.aspx.cs" Inherits="PSIC.POSSearchItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Item</span>
                    </h4>
                    <a href="dvSearchItem" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchItem">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span2" for="normal">Tag #</label>
                                        <input id="txtTagNo" type="text" class="txtcs frmCtrl span4" title="Search item using item tag #" />
                                        <button type="button" class="btn btn-primary" style="margin-top:-10px;" id="btnSrchByTag">Search</button>
                                    </div>
                                    <div class="span12">
                                        <label class="form-label span2" for="normal">Product Name</label>
                                        <input id="txtProduct" type="text" class="txtcs frmCtrl span4" title="Search item using item Product Name" />
                                        <button type="button" class="btn btn-primary" style="margin-top:-10px;" id="btnSrchByProduct">Search</button>
                                    </div>
                                </div>

                                <%--***********************--%>

                                <div class="form-row row-fluid">
                                    <div class="span12" style="margin-left: 0px;">
                                        <table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedItems">
                                            <thead>
                                                <tr>
                                                    <th>Tag #
                                                    </th>
                                                    <th>Product
                                                    </th>
                                                    <th>Category
                                                    </th>
                                                    <th>Sub Category
                                                    </th>                                                    
                                                    <th>Features
                                                    </th>
                                                    <th>Own
                                                    </th>
                                                    <th>Contact
                                                    </th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>



    <div class="row-fluid" style="display: none;">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Product Detail</span>
                    </h4>
                    <a href="dvProductDetail" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvProductDetail">

                    <form class="form-horizontal" action="#" id="frmStockIn">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Product</label>
                                        <input id="txtSearchedStockInProduct" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>


                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Shop</label>
                                        <input id="txtSearchedStockInShopName" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>


                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Sale Price</label>
                                        <input id="txtSearchedStockInSalePrice" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>



                                <%--***********************--%>
                            </div>
                        </div>
                    </form>

                    <form class="form-horizontal" action="#" id="frmSoled" style="display: none;">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Product</label>
                                        <input id="txtSearchedSoledProduct" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>


                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Customer Name</label>
                                        <input id="txtSearchedSoledCustomerName" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>


                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Customer Contact #</label>
                                        <input id="txtSearchedSoledCustomerContact" type="text" class="txtcs frmCtrl span4" disabled="disabled" />
                                    </div>
                                </div>



                                <%--***********************--%>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>




    <%--***********************--%>
    <%--*******Scripts*********--%>

    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Item Tracking');


            //$('#txtTagNo').live('keyup', search);
            $('#btnSrchByTag').on('click', searchByTag);
            $('#btnSrchByProduct').on('click', searchByProduct);


            function searchByTag() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSearchItem.aspx/SearchFromTag",
                    data: '{ "tag" : "' + $('#txtTagNo').val() + '" }',
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                OutDDL = OutDDL + '<tr><td>' + item.Tag + '</td> <td>' + item.ProductName + '</td><td>' + item.Category + '</td><td>' + item.SubCategory + '</td><td>' + item.Features + '</td><td>' + item.Own + '</td><td>' + item.Contact + '</td><td>' + item.ProductStatus + '</td></tr>';
                            });
                            
                            $('#tbSearchedItems tbody').html(OutDDL);
                            $('#txtProduct').val('');
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }
            function searchByProduct() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSearchItem.aspx/SearchFromProduct",
                    data: '{ "product" : "' + $('#txtProduct').val() + '" }',
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                OutDDL = OutDDL + '<tr><td>' + item.Tag + '</td> <td>' + item.ProductName + '</td><td>' + item.Category + '</td><td>' + item.SubCategory + '</td><td>' + item.Features + '</td><td>' + item.Own + '</td><td>' + item.Contact + '</td><td>' + item.ProductStatus + '</td></tr>';
                            });

                            $('#tbSearchedItems tbody').html(OutDDL);
                            $('#txtTagNo').val('');
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }


        });


    </script>


    <%--***********************--%>
    <%--***********************--%>
</asp:Content>
