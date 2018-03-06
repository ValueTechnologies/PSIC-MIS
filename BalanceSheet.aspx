<%@ Page Title="" EnableEventValidation="false" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="BalanceSheet.aspx.cs" Inherits="PSIC.BalanceSheet" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Balance Sheet');

            $('#ctl00_ContentPlaceHolder1_txtDateFrom').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#ctl00_ContentPlaceHolder1_txtDateTo').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });



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
                background-image: -ms-linear-gradient(top, #2780b8, #3498db);
                background-image: -o-linear-gradient(top, #2780b8, #3498db);
                background-image: linear-gradient(to bottom, #2780b8, #3498db);
                text-decoration: none;
            }
    </style>




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search</span>
                    </h4>
                    <a href="dvSearch" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearch">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Date (From)</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <asp:TextBox ID="txtDateFrom" runat="server"></asp:TextBox>
                                </div>


                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Date (To)</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <asp:TextBox ID="txtDateTo" runat="server"></asp:TextBox>
                                </div>

                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>

                                <asp:Button type="Button" runat="server" Text="Show Report" ID="btnSearch" OnClick="btnSearch_Click" />
                            </div>

                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>


    <div style="background-color: white;">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1400" Height="1000"></rsweb:ReportViewer>
    </div>

</asp:Content>
