<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSReceipt.aspx.cs" Inherits="PSIC.POSReceipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        $(document).ready(function () {
            var tagInputField = $('#txtTag');
            $('.heading h3').html('Receipt');
            $('#dvCustomer').dialog({ autoOpen: false, width: '70%', modal: true });
            $('#txtDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            function GetPrice() {
                var pid;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/GetPrice",
                    data: "{ 'Tag' : '" + $('#txtTag').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d);
                            $.each(jData, function (i, item) {
                                //debugger;
                                var attr = $('#PRICE').attr('qty');
                                if (typeof attr == typeof undefined || attr == false) {
                                    $('#PRICE').attr('qty', item.Qty);
                                    $('#PRICE').val(item.SalesPricePerUnit);
                                }
                                else {
                                    if (parseInt($('#PRICE').val(), 10) != item.SalesPricePerUnit) {
                                        var myselect = $("#ddlSelectedProductPPU option").filter(function () {
                                            return this.text == parseInt($('#PRICE').val(), 10);
                                        });
                                        $('#PRICE').attr('prevQty', myselect.attr('qty'));
                                        $('#PRICE').val(item.SalesPricePerUnit);
                                        myselect = $("#ddlSelectedProductPPU option").filter(function () {
                                            return this.text == parseInt($('#PRICE').val(), 10);
                                        });
                                        var q = parseInt(myselect.attr('qty'), 10);
                                        $('#PRICE').attr('qty', q);
                                    }
                                }
                            });

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
                return true;
            }

            $('#txtTag').keydown(function (event) {
                if (event.keyCode == 13) {
                    setTimeout(GetPrice, 10);
                    setTimeout(SearchProduct1, 10);
                    setTimeout(resetTag, 10);

                    //GetPrice(SearchProduct1(resetTag()));

                    //if (GetPrice()) {
                    //    debugger;
                    //    SearchProduct1();
                    //    resetTag();
                    //}
                    //else {
                    //    debugger;
                    //    if (GetPrice()) {
                    //        SearchProduct1();
                    //        resetTag();
                    //    }
                    //}
                    return false;
                }
            });

            function resetTag() {
                tagInputField.select();
            }

            $('#ddlProductTag').keypress(function (event) {
                if (event.keyCode == 13) {
                    AddToCart(event);
                    return false;
                }
            });

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

            function SearchProduct() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProduct",
                    data: "{ 'CatID' : '" + $('#ddlCategory').val() + "', 'SubCatID' : '" + $('#ddlSubCategory').val() + "','ProductName' : '" + $('#txtSearchName').val() + "','Tag' : '" + $('#txtTag').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td>' + item.Srno + '</td><td style="text-align : left;">' + item.ProductName + ' </td> <td style="text-align : left;">' + item.Features + ' </td> <td style="text-align : right;">' + item.Qty + ' </td> <td style="text-align : right;">' + item.Price + ' </td>  <td><button tag="' + item.ProductID + '" type="button" class="btn btn-link clsProduct">Select</button>   </td> </tr>';
                            });
                            $('#tbSearchedProducts tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            function SearchProduct1() {
                var pid;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProduct",
                    data: "{ 'CatID' : '" + $('#ddlCategory').val() + "', 'SubCatID' : '" + $('#ddlSubCategory').val() + "','ProductName' : '" + $('#txtSearchName').val() + "','Tag' : '" + $('#txtTag').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                pid = item.ProductID;
                                Out = Out + '<tr><td>' + item.Srno + '</td><td style="text-align : left;">' + item.ProductName + ' </td> <td style="text-align : left;">' + item.Features + ' </td> <td style="text-align : right;">' + item.Qty + ' </td> <td style="text-align : right;">' + item.Price + ' </td> <td><button tag="' + pid + '" type="button" class="btn btn-link clsProduct">Select</button>   </td> </tr>';
                                SearchProductDetail1(pid);
                            });
                            $('#tbSearchedProducts tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            $('#btnSearchProduct').bind('click', SearchProduct);
            //$('#btnSearchProduct').bind('click', SearchProductDetail1);
            
            $('#btnAddProductToCart').bind('click', AddToCart);
            function AddToCart(e) {
                e.preventDefault();
                if (parseInt($('#ddlSelectedProductPPU option:selected').attr('qty'), 10) == 0) {
                    alert('Sorry Items not available...');
                    return;
                }


                if ($('#ddlSelectedProductPPU option:selected').val() == "---Select---") {
                    alert('Please select item Tag...');
                    return;
                }

                $('#tbCartProducts').append('<tr><td>' + $('#txtSelectedProduct').val() + ' </td><td qty="' + $('#txtSelectedProductAvailableQty').val() + '">' + (parseInt($('#txtSelectedProductAvailableQty').val())-1) + '</td> <td> <input type="text" class="clsQty span6" value="1" /> </td><td> ' + $('#ddlProductTag').val() + ' </td><td> ' + $('#ddlSelectedProductPPU').val() + ' </td><td> ' + $('#ddlSelectedProductPPU').val() + ' </td><td> <input type="text" class="form-label span4 clsDiscountRate" for="normal" style="width : 100px;" value="0">% </td> <td class="clsNetPriceOfItem">  </td><td><img prodid="' + $('#btnAddProductToCart').attr('prodid') + '" UP="' + $('#ddlSelectedProductPPU').val() + '" StockID="' + $('#ddlProductTag option:selected').attr('stockid') + '" class="clsCancelCartProduct" src="Images/RowDelete.png" style="width: 20px;">  </td> </tr>');
                CalculateItemPrice();

                var qty = parseInt($('#ddlSelectedProductPPU option:selected').attr('qty'), 10) - 1;
                $('#ddlSelectedProductPPU option:selected').removeAttr('qty');
                $('#ddlSelectedProductPPU option:selected').attr('qty', qty);
                //$('#txtSelectedProductAvailableQty').val(qty);


                $('#ddlProductTag option:selected').remove();
                //$("#ddlProductTag option[value='" + $('#ddlProductTag option:selected').val() + "']").remove();

                CalculateSubTotal();
            }

            function LoadProductPriceandQty1(ProductID, Tag) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProductPriceAndQty1",
                    data: "{ 'ProductId' : '" + ProductID + "', 'Tag' : '" + Tag + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                //debugger;
                                $('#PRICE').val(item.SalesPricePerUnit);
                                $('#PRICE').attr('qty', item.Qty);
                            });
                            LoadProductPriceandQty(ProductID);
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            function LoadTags1(ProductID, Tag) {
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
                                //Out = Out + "{StockID:'" + item.StockID + "',Tag:'" + item.Tag + "'},";
                            });




                            $('#ddlProductTag').html(Out);

                            //$('.clsCancelCartProduct').each(function (i, item) {
                            //    $('#ddlProductTag option[value=' + $(this).parent().prev().prev().html().trim() + ']').remove();
                            //});

                            $('#ddlProductTag option:selected').val(Tag);
                            $('#ddlProductTag').removeAttr('disabled');
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            }

            function AddToCart1() {
                //e.preventDefault();
                if (parseInt($('#ddlSelectedProductPPU option:selected').attr('qty'), 10) == 0) {
                    alert('Sorry Items not available...');
                    return;
                }

                if ($('#ddlSelectedProductPPU option:selected').val() == "---Select---") {
                    alert('Please select item Tag...');
                    return;
                }

                $('#tbCartProducts').append('<tr><td>' + $('#txtSelectedProduct').val() + ' </td><td qty="' + $('#PRICE').attr('qty') + '">' + $('#PRICE').attr('qty') + '</td> <td> <input type="text" class="clsQty span6" value="1" /> </td><td> ' + $('#txtTag').val() + ' </td><td> ' + $('#PRICE').val() + ' </td><td> ' + $('#PRICE').val() + ' </td><td> <input type="text" class="form-label span4 clsDiscountRate" for="normal" style="width : 100px;" value="0">% </td> <td class="clsNetPriceOfItem">  </td><td><img prodid="' + $('#btnAddProductToCart').attr('prodid') + '" UP="' + $('#ddlSelectedProductPPU').val() + '" StockID="' + $('#ddlProductTag option:selected').attr('stockid') + '" class="clsCancelCartProduct" src="Images/RowDelete.png" style="width: 20px;">  </td> </tr>');
                CalculateItemPrice();
                //debugger;
                var price = parseInt($('#PRICE').val(), 10);
                var qty = parseInt($('#PRICE').attr('qty'), 10);

                var myselect = $("#ddlSelectedProductPPU option").filter(function () {
                    return this.text == price;
                });
                $("#ddlSelectedProductPPU option:selected").removeAttr('selected');
                myselect.removeAttr('qty');
                myselect.attr('qty', qty);
                myselect.attr('selected', 'selected');
                $('#PRICE').removeAttr('qty');
                $('#PRICE').attr('qty', qty);
                $('#txtSelectedProductAvailableQty').val(qty);

                var myselect1 = $("#ddlProductTag option").filter(function () {
                    return this.text == $('#txtTag').val();
                });
                myselect1.attr('selected', 'selected');
                $('ddlProductTag option:selected').remove();
                //$("#ddlProductTag option[value='" + $('#ddlProductTag option:selected').val() + "']").remove();

                CalculateSubTotal();
            }

            function SearchProductDetail1(id) {
                var ProductID = id;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProductDetail1",
                    data: "{ 'ProductId' : '" + ProductID + "', 'tag' : '" + $('#txtTag').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "", TotalQty;
                            $.each(jData, function (i, item) {
                                $('#txtSelectedProduct').val(item.ProductName);
                                //$('#txtSelectedProductPPU').val(item.SalesPricePerUnit);
                                //$('#txtSelectedProductAvailableQty').val(item.Qty);
                                //$('#btnAddProductToCart').attr('tag', item.StockID);
                                $('#btnAddProductToCart').attr('ProdID', ProductID);
                                $('#ddlSelectedProductPPU').attr('disabled', 'disabled');
                                $('#ddlProductTag').attr('disabled', 'disabled');
                                LoadProductPriceandQty1(ProductID);
                            });
                        } catch (e) {
                            alert(e.message);
                        }
                        AddToCart1();
                    }
                });
            }

            $('.clsDiscountRate').live('keyup', CalculateItemPrice);

            

            $('#txtTotalPayment').bind('blur', function () {
                $('#txtDuePayment').val($('#txtGrandTotal').val() - $('#txtTotalPayment').val());
            });


            $('#txtTaxPercentage').blur(function (i, item) {
                if ($('#txtTaxPercentage').val() != "") {
                    var amount = $('#txtTaxPercentage').val() * ($('#txtSubTotal').val() - $('#txtDiscountAmount').val());
                    $('#txtTaxAmount').val(Math.round(amount / 100));
                    CalculateGrandTotal();
                }
            });

            $('#txtDiscountPercentage').blur(function (i, item) {
                if ($('#txtDiscountPercentage').val() != "") {
                    var amount = $('#txtDiscountPercentage').val() * $('#txtSubTotal').val();
                    $('#txtDiscountAmount').val(Math.round(amount / 100));
                    CalculateGrandTotal();
                }
            });

            $('#btnSearchCustomer').bind('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchCustomer",
                    data: "{ 'Name' : '" + $('#txtSearchCustomerName').val() + "', 'CellNo' : '" + $('#txtSearchCustomerCell').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td>' + item.Srno + '</td><td style="text-align : left;">' + item.Name + ' </td> <td style="text-align : left;">' + item.CellNo + ' </td> <td style="text-align : left;">' + item.Address + ' </td> <td style="text-align : left;">' + item.Membership + ' </td> <td> <input tag="' + item.CustomerID + '" name="SelectedMember" type="radio" class="chkCustomer" >  </td> </tr>';
                            });
                            $('#tbSearchedCustomers tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
            });

            $('#btnSelectCustomer').bind('click', function () {
                $('#dvCustomer').dialog('open');
            });

            //Save Recipt


            $('#btnokSave').bind('click', save);
            $('#btnSave').bind('click', save);

            function save () {
                var CustomerID = 1;
                if ($('#txtGrandTotal').val() == "") {
                    return;
                }

                $('.chkCustomer').each(function () {
                    if ($(this).is(':checked')) {
                        CustomerID = $(this).attr('tag');
                    }
                });

                if (CustomerID == 0) {
                    alert('Please select Customer...');
                    return;
                }

                var DiscountAmount = 0;
                var TaxAmount = 0;
                if ($('#txtDiscountAmount').val() != "") {
                    DiscountAmount = $('#txtDiscountAmount').val();
                }


                if ($('#txtTaxAmount').val() != "") {
                    TaxAmount = $('#txtTaxAmount').val();
                }



                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SaveRecipt",
                    data: "{  'CustomerID' : '" + CustomerID + "' , 'SubTotal' : '" + $('#txtSubTotal').val() + "' , 'DiscountAmount' : '" + DiscountAmount + "', 'TaxAmount' : '" + TaxAmount + "', 'GrandTotalAmount' : '" + $('#txtGrandTotal').val() + "', 'TotalPayment' : '" + $('#txtTotalPayment').val() + "', 'DuePayment' : '" + $('#txtDuePayment').val() + "', 'PaymentType' : '" + $('#ddlPaymentType').val() + "' , 'PurchasingDate' : '" + $('#txtDate').val() + "' , 'Remaks' : '" + $('#txtNote').val() + "'}",
                    success: function (response) {
                        var SalesID = response.d;
                        var stockID = [], ProductId = [], Qty = [], UnitPrice = [], Tag = [];

                        $('.clsCancelCartProduct').each(function (i, item) {
                            ProductId[i] = parseInt($(this).attr('prodid'), 10);
                        });


                        $('.clsCancelCartProduct').each(function (i, item) {
                            stockID[i] = parseInt($(this).attr('stockid'), 10);
                        });

                        $('.clsQty').each(function (i, item) {
                            UnitPrice[i] = parseInt($(this).parent().next().next().html(), 10);
                        });

                        $('.clsQty').each(function (i, item) {
                            Qty[i] = parseInt($(this).val(), 10);
                        });

                        $('.clsQty').each(function (i, item) {
                            Tag[i] = parseInt($(this).parent().next().html(), 10);
                        });


                        for (var index = 0; index < ProductId.length ; index++) {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "POSReceipt.aspx/SaveReceiptDetail",
                                //data: "{    'StockID' : '" + stockID[index] + "', 'ReciptID' : '" + SalesID + "', 'ProductID' : '" + ProductId[index] + "',   'Qty' : '" + Qty[index] + "', 'UnitPrice' : '" + UnitPrice[index] + "' }",
                                data: "{    'ReciptID' : '" + SalesID + "', 'ProductID' : '" + ProductId[index] + "',   'Qty' : '" + Qty[index] + "', 'UnitPrice' : '" + UnitPrice[index] + "', 'Tag' : '" + Tag[index] + "' }",
                                success: function (response) {

                                }
                            });
                            if (index == (ProductId.length - 1)) {
                                alert('Save Successfully!');
                                $('#tbCartProducts tbody').html('');
                                $('#txtSubTotal').val('');
                                $('#txtDiscountPercentage').val('');
                                $('#txtDiscountAmount').val('');
                                $('#txtTaxPercentage').val('');
                                $('#txtTaxAmount').val('');
                                $('#txtGrandTotal').val('');
                                $('#txtTotalPayment').val('');
                                $('#txtDuePayment').val('');
                                $('#txtNote').val('Thank you for shopping with us!');
                                $('#dvCustomer').dialog('close');
                                $('#lnkPrint').attr('href', 'SalesReciptRpt.aspx?ID=' + SalesID);
                                $('#lnkPrint').show();
                            }
                        }
                    }
                });
            }

            $('body').on({
                blur: function (e) {
                    setTimeout(getQty(), 10);
                    setTimeout(CalculateItemPrice(), 10);
                }
            }, '.clsQty');

            function getQty() {
                try {
                    $('.clsQty').each(function (i, item) {
                        //debugger;
                        var qty = parseInt($(this).val(), 10);
                        //var aQty = parseInt($('#PRICE').attr('qty'), 10);
                        var aQty = $(this).parent().prev().attr('qty');
                        if (qty > aQty)
                            qty = aQty;
                        $(this).val(qty);
                        var nQty = aQty - qty;
                        $(this).parent().prev().html(nQty);
                    });
                } catch (e) {
                    return;
                }
            }

            function CalculateItemPrice() {
                try {
                    $('.clsQty').each(function (i, item) {
                        //debugger;
                        var qty = parseInt($(this).val(), 10);
                        
                        var price = $(this).parent().next().next().html();
                        $(this).parent().next().next().next().html(qty * price);
                    });

                    $('.clsDiscountRate').each(function (i, item) {
                        //debugger;
                        var price = $(this).parent().prev().html();

                        $(this).parent().next().html($(this).parent().prev().html() * ((100.00 - parseFloat($(this).val())) / 100));

                    });
                } catch (e) {
                    return;
                }

                CalculateSubTotal();
            }

            function CalculateSubTotal() {
                var SubTotal = 0;
                $('.clsCancelCartProduct').each(function () {
                    var Amount = $(this).parent().prev().html();
                    SubTotal = SubTotal + parseInt(Amount);
                });
                $('#txtSubTotal').val(SubTotal);
                CalculateGrandTotal();
            }

            $('#txtDiscountAmount').blur(CalculateGrandTotal);

            function CalculateGrandTotal() {
                var SubTotal = 0, Tax = 0, Discount = 0;
                if ($('#txtSubTotal').val() != "") {
                    SubTotal = parseFloat($('#txtSubTotal').val());
                }
                if ($('#txtTaxAmount').val() != "") {
                    Tax = parseFloat($('#txtTaxAmount').val())
                }
                if ($('#txtDiscountAmount').val() != "") {
                    Discount = parseFloat($('#txtDiscountAmount').val())
                }

                var GTotal = SubTotal + Tax - Discount;
                $('#txtGrandTotal').val(GTotal);
                $('#txtDuePayment').val(GTotal);


            }


        });
        //end ready


        function LoadProductPriceandQty(ProductID) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "POSReceipt.aspx/SearchProductPriceAndQty",
                data: "{ 'ProductId' : '" + ProductID + "' }",
                success: function (response) {
                    try {
                        var jData = $.parseJSON(response.d), Out = "", OutDDL = "", qty;
                        $.each(jData, function (i, item) {
                            //var attr = $('#PRICE').attr('prevQty');
                            //if(typeof attr == typeof undefined || attr == false)
                                Out = Out + '<option qty= ' + item.Qty + '>' + item.SalesPricePerUnit + '</option>';
                            //else
                            //    Out = Out + '<option qty= ' + parseInt($('#PRICE').attr('prevQty'), 10) + '>' + item.SalesPricePerUnit + '</option>';
                        });

                        $('#ddlSelectedProductPPU').html(Out);
                        $('#ddlSelectedProductPPU').removeAttr('disabled');
                        //var price = parseInt($('#PRICE').val(), 10);
                        //qty = parseInt($('#PRICE').attr('qty'), 10);
                        //var myselect = $("#ddlSelectedProductPPU option").filter(function () {
                        //    return this.text == price;
                        //});
                        //myselect.removeAttr('qty');
                        //myselect.attr('qty', qty);
                        $('#ddlSelectedProductPPU option:selected').attr('qty', $('#ddlSelectedProductPPU option:selected').attr('qty'));
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
                            //Out = Out + "{StockID:'" + item.StockID + "',Tag:'" + item.Tag + "'},";
                        });
                        



                        $('#ddlProductTag').html(Out);

                        //$('.clsCancelCartProduct').each(function (i, item) {
                        //    $('#ddlProductTag option[value=' + $(this).parent().prev().prev().html().trim() + ']').remove();
                        //});

                        
                        $('#ddlProductTag').removeAttr('disabled');
                    } catch (e) {
                        alert(e.message);
                    }
                }
            });
        }


        $('body').on({
            change: function (e) {
                e.preventDefault();
                $('#txtSelectedProductAvailableQty').val($('#ddlSelectedProductPPU option:selected').attr('qty'));
                LoadTags($('#btnAddProductToCart').attr('prodid'));
            }
        }, '#ddlSelectedProductPPU');

        $('body').on({ click: SearchProductDetail }, '.clsProduct');

        function SearchProductDetail() {
            //debugger;
                var ProductID = $(this).attr('tag');

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSReceipt.aspx/SearchProductDetail",
                    data: "{ 'ProductId' : '" + ProductID + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "", TotalQty;
                            $.each(jData, function (i, item) {
                                //debugger;
                                $('#txtSelectedProduct').val(item.ProductName);
                                //$('#txtSelectedProductPPU').val(item.SalesPricePerUnit);
                                //$('#txtSelectedProductAvailableQty').val(item.Qty);
                                //$('#btnAddProductToCart').attr('tag', item.StockID);
                                $('#btnAddProductToCart').attr('ProdID', ProductID);
                                $('#ddlSelectedProductPPU').attr('disabled', 'disabled');
                                $('#ddlProductTag').attr('disabled', 'disabled');
                                LoadProductPriceandQty(ProductID);
                            });
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
        }


        //$('body').on({
        //    blur: function () {

        //        $('#txtSelectedProductAmount').val($('#ddlSelectedProductPPU').val() * $('#txtSelectedProductSalesQty').val());
        //    }
        //}, '#txtSelectedProductSalesQty');


        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCancelCartProduct');

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div id="dvCustomer" title="Customer">
        <div class="row-fluid">
            <div class="span12">
                <div class="box">
                    <div class="title">
                        <h4>
                            <span>Search Customer</span>
                        </h4>
                        <a href="dvSearchCustomer" class="minimize">Minimize</a>
                    </div>
                    <div class="content" id="dvSearchCustomer">

                        <form class="form-horizontal" action="#">

                            <div class="form-row row-fluid">
                                <div class="span6">
                                    <label class="form-label span4" style="margin-top: 9px;" for="normal">Name : </label>
                                    <input id="txtSearchCustomerName" type="text" class="span8 frmCtrl" />
                                </div>

                                <div class="span6">
                                    <label class="form-label span4" style="margin-top: 9px;" for="normal">Cell # : </label>
                                    <input id="txtSearchCustomerCell" type="text" class="span8 frmCtrl" />
                                </div>
                            </div>


                            <div class="form-row row-fluid">
                                <div class="span6" style="margin-left: 0px;">
                                    <label class="form-label span4" for="normal"></label>
                                    <button type="button" id="btnSearchCustomer" class="btn btn-info span2" style="margin-left: 0px;">Search</button>
                                </div>
                            </div>


                            <div class="form-row row-fluid">
                                <div class="span12" style="margin-left: 0px;">
                                    <table id="tbSearchedCustomers" class="responsive table table-striped table-bordered table-condensed">
                                        <thead>
                                            <tr>
                                                <th style="width: 50px;">Sr.No
                                                </th>
                                                <th>Name
                                                </th>
                                                <th>Contact #
                                                </th>
                                                <th>Address
                                                </th>
                                                <th>Membership
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


                            <div class="form-row row-fluid">
                                <div class="span6" style="margin-left: 0px;">
                                    <label class="form-label span4" for="normal"></label>
                                    <button type="button" id="btnokSave" class="btn btn-primary span2" style="margin-left: 0px;">OK</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>





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

                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Tag : </label>
                                <input id="txtTag" type="text" class="span8 frmCtrl" autofocus />
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
                                            <th>Qty
                                            </th>
                                            <th>Price
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
                                    <input type="hidden" id="PRICE"/>
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
                                <div  class="span8 controls sel"  >
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
                                <button type="button" id="btnAddProductToCart" class="btn btn-primary span3" style="margin-left: 0px;">Add to cart</button>
                            </div>
                        </div>

                        <div id="#prodId" class="hidden"></div>
                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbCartProducts" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 30%;">Product 
                                            </th>
                                            <th>Available Qty
                                            </th>
                                            <th>Qty
                                            </th>
                                            <th>Tag
                                            </th>
                                            <th>Unit Price
                                            </th>
                                            <th>Price
                                            </th>
                                            <th>Discount On item
                                            </th>
                                            <th>Item Sale Price
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
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Sub Total : </label>
                                <input id="txtSubTotal" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Discount : </label>
                                <input id="txtDiscountPercentage" type="text" class="span3 frmCtrl" value="0" />%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtDiscountAmount" type="text" class="span4 frmCtrl" value="0"/>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Tax : </label>
                                <input id="txtTaxPercentage" type="text" class="span3 frmCtrl" value="0"/>%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="txtTaxAmount" type="text" class="span4 frmCtrl" value="0"/>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Grand Total : </label>
                                <input id="txtGrandTotal" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Total Payment : </label>
                                <input id="txtTotalPayment" type="text" class="span8 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Due Payment : </label>
                                <input id="txtDuePayment" type="text" class="span8 frmCtrl" disabled="disabled" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Payment Type : </label>
                                <div class="controls sel">
                                    <select class="nostyle span8" id="ddlPaymentType">
                                        <option>Cash</option>
                                        <option>Debit Card</option>
                                        <option>Credit Card</option>
                                        <option>Bank Cheque</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Selling Date : </label>
                                <input id="txtDate" type="text" class="span8 frmCtrl" value="<%= DateTime.Now.ToString("dd - MMMM - yyyy") %>"/>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal">Note : </label>
                                <textarea rows="2" cols="5" class="span8" id="txtNote">Thank you for shopping with us!</textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" style="margin-top: 9px;" for="normal"></label>
                                <div style="margin-left: 0px;">
                                    <button type="button" class="btn btn-primary span2" id="btnSave">Save</button>
                                    <button type="button" class="btn btn-primary span3" id="btnSelectCustomer">Select Customer</button>
                                    <a class="btn btn-link" id="lnkPrint" target="_blank" style="display: none;">Print Recipt</a>
                                </div>

                            </div>
                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>
    
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtTag").focus();
        $("#txtTag").select();
    });
</script>
</asp:Content>

