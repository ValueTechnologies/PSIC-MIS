<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSReports.aspx.cs" Inherits="PSIC.POSReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Reports');

            $('#StockRegisterReport').bind('click', function () {
                window.location.href = "StockRegisterRpt.aspx";
            });

            $('#VendorListReport').bind('click', function () {
                window.location.href = "VendorListRpt.aspx";
            });

            $('#CustomerListReport').bind('click', function () {
                window.location.href = "CustomerListRpt.aspx";
            });

            $('#SalesReport').bind('click', function () {
                window.location.href = "SalesReportDateWiseRpt.aspx";
            });

            $('#MostSellingProduct').bind('click', function () {
                window.location.href = "MostSellingProductRpt.aspx";
            });

            $('#DamageProductReport').bind('click', function () {
                window.location.href = "DamageProductRpt.aspx";
            });

            $('#InventoryAlertReport').bind('click', function () {
                window.location.href = "POSInventroyAlertReport.aspx";
            });

            $('#DayBook').bind('click', function () {
                window.location.href = "POSDayBook.aspx";
            });


        });
        //end ready

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Reports </span>
                    </h4>
                    <a href="dvReports" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvReports">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <table>
                                    <tr>
                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="StockRegisterReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Stock Register
                                                </p>
                                            </div>
                                        </td>

                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="SalesReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Sales Report
                                                </p>
                                            </div>
                                        </td>

                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="MostSellingProduct">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Most Selling Product
                                                </p>
                                            </div>
                                        </td>

                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="VendorListReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Vendor Report
                                                </p>
                                            </div>
                                        </td>

                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="CustomerListReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Customer Report
                                                </p>
                                            </div>
                                        </td>





                                    </tr>


                                    <tr>
                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="DamageProductReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Damage Product Report
                                                </p>
                                            </div>
                                        </td>
                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="InventoryAlertReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Inventory Alert Report
                                                </p>
                                            </div>
                                        </td>
                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="DayBook">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Day Book
                                                </p>
                                            </div>
                                        </td>
                                    </tr>



                                </table>



                            </div>


                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>





</asp:Content>
