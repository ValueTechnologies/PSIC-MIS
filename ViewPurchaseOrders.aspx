<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="ViewPurchaseOrders.aspx.cs" Inherits="PSIC.ViewPurchaseOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    
<style type="text/css">
    body {
      color: #6a6c6f;
      background-color: #f1f3f6;
      margin-top: 30px;
    }

    .container {
      max-width: 100%;
    }

    .panel-default>.panel-heading {
      color: #333;
      background-color: #fff;
      border-color: #e4e5e7;
      padding: 0;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
    }

    .panel-default>.panel-heading a {
      display: block;
      padding: 10px 15px;
    }

    .panel-default>.panel-heading a:after {
      content: "";
      position: relative;
      top: 1px;
      display: inline-block;
      font-family: 'Glyphicons Halflings';
      font-style: normal;
      font-weight: 400;
      line-height: 1;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      float: right;
      transition: transform .25s linear;
      -webkit-transition: -webkit-transform .25s linear;
    }

    .panel-default>.panel-heading a[aria-expanded="true"] {
      background-color: #eee;
    }

    .panel-default>.panel-heading a[aria-expanded="true"]:after {
      content: "\2212";
      -webkit-transform: rotate(180deg);
      transform: rotate(180deg);
    }

    .panel-default>.panel-heading a[aria-expanded="false"]:after {
      content: "\002b";
      -webkit-transform: rotate(90deg);
      transform: rotate(90deg);
    }

    .accordion-option {
      width: 100%;
      float: left;
      clear: both;
      margin: 15px 0;
    }

    .accordion-option .title {
      font-size: 20px;
      font-weight: bold;
      float: left;
      padding: 0;
      margin: 0;
    }

    .accordion-option .toggle-accordion {
      float: right;
      font-size: 16px;
      color: #6a6c6f;
    }

    .accordion-option .toggle-accordion:before {
      content: "Expand/Collapse All";
    }

    .accordion-option .toggle-accordion.active:before {
      content: "Expand/Collapse All";
    }
</style>

    
    <%--***********************--%>
    <%--*******Scripts*********--%>

<script type="text/javascript">

    $(document).ready(function () {
        $('.heading h3').html('Item Tracking');
        $('#txtTo').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
        $('#txtFrom').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

        $(".toggle-accordion").on("click", function () {
            var accordionId = $(this).attr("accordion-id"),
              numPanelOpen = $(accordionId + ' .collapse.in').length,
              numPanelClosed = $(accordionId + ' .collapse').length;

            $(this).toggleClass("active");

            if (numPanelOpen == 0) {
                openAllPanels(accordionId);
            } else {
                closeAllPanels(accordionId);
            }
        })

        openAllPanels = function (aId) {
            console.log("setAllPanelOpen");
            $(aId + ' .panel-collapse:not(".in")').collapse('show');
        }
        closeAllPanels = function (aId) {
            console.log("setAllPanelclose");
            $(aId + ' .panel-collapse.in').collapse('hide');
        }

        $('#btnSearchPurchaseOrders').bind('click', GetPurchaseOrders);

        function GetPurchaseOrders() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "ViewPurchaseOrders.aspx/SearchPOs",
                data: "{ 'fromDate' : '" + $('#txtFrom').val() + "', 'toDate' : '" + $('#txtTo').val() + "' }",
                success: function (response) {
                    try {
                        debugger;
                        var jData = $.parseJSON(response.d), Out = "", OutDDL = "", pid = 0, first = true;

                        $.each(jData, function (i, item) {
                            debugger;
                            var date = item.OrderDate;

                            if (pid != item.PurchaseOrderID && first) {
                                first = false;
                                Out = Out + '<div class="panel panel-default">';
                                Out = Out + '<div class="panel-heading" role="tab" id="heading' + item.PurchaseOrderID + '">';
                                Out = Out + '<h4 class="panel-title">';
                                Out = Out + '<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse' + item.PurchaseOrderID + '" aria-expanded="true" aria-controls="collapse' + item.PurchaseOrderID + '"> ' + item.PONumber + ' (' + date + ') </a> </h4> </div>';
                                Out = Out + '<div id="collapse' + item.PurchaseOrderID + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading' + item.PurchaseOrderID + '"> <div class="panel-body">';
                                Out = Out + '<table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedItems' + item.PurchaseOrderID + '"> <thead> <tr><th>Product Name</th><th>Remarks</th><th>Supplier Name</th><th>Qty</th><th>Status</th></tr></thead><tbody>';

                                Out = Out + '<tr><td> ' + item.ProductName + ' </td> <td> ' + item.Remaks + ' </td><td> ' + item.SupplierName + ' </td><td> ' + item.Qty + ' </td><td> ' + item.Is_Completed + ' </td></tr>';

                                pid = item.PurchaseOrderID;
                            }
                            else if (pid != item.PurchaseOrderID && !first) {
                                Out = Out + '</tbody></table></div></div></div>';
                                Out = Out + '<div class="panel panel-default">';
                                Out = Out + '<div class="panel-heading" role="tab" id="heading' + item.PurchaseOrderID + '">';
                                Out = Out + '<h4 class="panel-title">';
                                Out = Out + '<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse' + item.PurchaseOrderID + '" aria-expanded="true" aria-controls="collapse' + item.PurchaseOrderID + '"> ' + item.PONumber + ' (' + date + ') </a> </h4> </div>';
                                Out = Out + '<div id="collapse' + item.PurchaseOrderID + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading' + item.PurchaseOrderID + '"> <div class="panel-body">';
                                Out = Out + '<table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedItems' + item.PurchaseOrderID + '"> <thead> <tr><th>Product Name</th><th>Remarks</th><th>Supplier Name</th><th>Qty</th><th>Status</th></tr></thead><tbody>';

                                Out = Out + '<tr><td> ' + item.ProductName + ' </td> <td> ' + item.Remaks + ' </td><td> ' + item.SupplierName + ' </td><td> ' + item.Qty + ' </td><td> ' + item.Is_Completed + ' </td></tr>';

                                pid = item.PurchaseOrderID;
                            }
                            else {
                                Out = Out + '<tr><td> ' + item.ProductName + ' </td> <td> ' + item.Remaks + ' </td><td> ' + item.SupplierName + ' </td><td> ' + item.Qty + ' </td><td> ' + item.Is_Completed + ' </td></tr>';
                            }
                        });
                        $('#accordion').html(Out);

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
                                    <div class="span 6">
                                        <label class="form-label span2" for="normal">From :</label>
                                        <input id="txtFrom" type="text" class="txtcs frmCtrl span4" title="Search PO using date" />
                                    </div>
                                    <div class="span 6">
                                        <label class="form-label span2" for="normal">To :</label>
                                        <input id="txtTo" type="text" class="txtcs frmCtrl span4" title="Search PO using date" />
                                    </div>
                                </div>
                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span5" style="margin-top: 9px;" for="normal"></label>
                                        <button type="button" class="btn btn-info" id="btnSearchPurchaseOrders">Search</button>
                                    </div>
                                </div>
                                </div>
                            </div>
                        </form>

                                <%--***********************--%>

<div class="form-row row-fluid">
    <div class="span12" style="margin-left: 0px;">
        <div class="container">
            <div class="accordion-option">
                <h3 class="title">Purchase Orders</h3>
                <a href="javascript:void(0)" class="toggle-accordion active" accordion-id="#accordion"></a>
            </div>
            <div class="clearfix"></div>
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            </div>
        </div>
    </div>
</div>
                                
                            </div>
                        </div>
                 </div>
            </div>


</asp:Content>
