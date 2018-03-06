<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstateManagementReports.aspx.cs" Inherits="PSIC.EstateManagementReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Reports');

            $('#PlotWiseReport').bind('click', function () {
                window.location.href = "PlotWiseReport.aspx";
            });

            $('#OwnerWiseReport').bind('click', function () {
                window.location.href = "EstateOwnerwiseSearchReport.aspx";
            });


        });
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
                                            <div id="PlotWiseReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Plot Wise Report
                                                </p>
                                            </div>
                                        </td>

                                        <td style="margin-top: 0px; padding: 35px;">
                                            <div id="OwnerWiseReport">
                                                <a class="btn btn-app" style="background-image: url(Images/indicat.png); width: 104px; height: 127px;"></a>
                                                <p style="text-align: center;">
                                                    Owner wise Report
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
