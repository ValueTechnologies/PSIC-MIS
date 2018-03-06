<%@ Page Title="" Language="C#" EnableEventValidation="false"  MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSDayBook.aspx.cs" Inherits="PSIC.POSDayBook" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Sales Report');

            $('#ctl00_ContentPlaceHolder1_txtFromDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#ctl00_ContentPlaceHolder1_txtToDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

            

        });


    </script>

    <style type="text/css">
        .button {
            background: #3498db;
            background-image: -webkit-linear-gradient(top, #3498db, #2980b9);
            background-image: -moz-linear-gradient(top, #3498db, #2980b9);
            background-image: -ms-linear-gradient(top, #3498db, #2980b9);
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

        div.button span {
            text-transform: none;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Report</span>
                    </h4>
                    <a href="dvReport" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvReport">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1200" Height="500"></rsweb:ReportViewer>
                            </div>


                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
