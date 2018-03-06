<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSGenerateBarcode.aspx.cs" Inherits="PSIC.POSGenerateBarcode" EnableEventValidation="false" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;


    <script type="text/javascript">    
        $(document).ready(function () {
            $('.heading h3').html('Generate Barcode');

            LoadPONumbers();

            function LoadPONumbers() {
                var selected_po = '<%= Session["selected_po"] %>';
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSGenerateBarcode.aspx/LoadPONumbers",
                    data: "",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";
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


        });

    </script>

    <style type="text/css">
        .button {
            background: #3498db;
            background-image: -webkit-linear-gradient(top, #3498db, #2980b9);
            background-image: -moz-linear-gradient(top, #3498db, #2980b9);
            background-image: -o-linear-gradient(top, #3498db, #2980b9);
            background-image: linear-gradient(to bottom, #3498db, #2980b9);
            -webkit-border-radius: 7;
            -moz-border-radius: 7;
            border-radius: 7px;
            font-family: Arial;
            color: #ffffff;
            font-size: 14px;
            padding: 0px 5px 0px 5px;
            text-decoration: none;
        }

            .button:hover {
                background: #2780b8;
                background-image: -webkit-linear-gradient(top, #2780b8, #3498db);
                background-image: -moz-linear-gradient(top, #2780b8, #3498db);
                background-image: -o-linear-gradient(top, #2780b8, #3498db);
                background-image: linear-gradient(to bottom, #2780b8, #3498db);
                text-decoration: none;
            }

        div.button span {
            text-transform: none;
        }

        div.button {
            height: 26px;
        }
    </style>

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
                            <div class="span12" style="display: none;">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Purchase Order # : </label>
                                <div class="span4"  style="margin-left: 0px;">
                                    <asp:TextBox ID="txtSearchPurchaseOrderNo" runat="server" ></asp:TextBox>

                                </div>
                                
                            </div>
                            <div class="span12">
                                <label class="form-label span2" style="margin-top: 0px;" for="normal">Purchase Order # : </label>
                                <div class="span4"  style="margin-left: 0px;">
                                    <select id="ddlPO" class="nostyle frmCtrl" name="ddlPO">
                                        
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span5" style="margin-top: 9px;" for="normal"></label>
                                <asp:Button ID="btnSearchPurchaseOrder" runat="server" Text="Show Report" class="btn btn-info span8" OnClick="btnSearchPurchaseOrder_Click" />

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
                        <span>All Barcodes</span>
                    </h4>
                    <a href="dvReport" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvReport">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            
                            <div class="span12">
                                

                                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1150" Height="650"
                                     ClientIDMode="Static" ProcessingMode="Local" ShowPrintButton="True" 
                                    ShowRefreshButton="True" ShowExportControls="True"></rsweb:ReportViewer>

                                
                            </div>
                        </div>

                        
                    </form>
                </div>
            </div>
        </div>
    </div>



</asp:Content>
