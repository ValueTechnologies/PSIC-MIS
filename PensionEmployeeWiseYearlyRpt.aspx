<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="PensionEmployeeWiseYearlyRpt.aspx.cs" Inherits="PSIC.PensionEmployeeWiseYearlyRpt" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Employee wise Yearly Report');
        });
    </script>


    <style type="text/css">
        .button {
            background: #3498db;
            background-image: -webkit-linear-gradient(top, #3498db, #2980b9);
            background-image: -moz-linear-gradient(top, #3498db, #2980b9);
            background-image: -o-linear-gradient(top, #3498db, #2980b9);
            background-image: linear-gradient(to bottom, #3498db, #2980b9);
            -webkit-border-radius: 5;
            -moz-border-radius: 5;
            border-radius: 5px;
            font-family: Arial;
            color: #ffffff;
            font-size: 10px;
            padding: 0px 0px 0px 0px;
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
                        <span>Employee Year</span>
                    </h4>
                    <a href="dvSearchEmployees" class="minimize"></a>
                </div>
                <div class="content" id="dvSearchEmployees">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">From Year</label>
                                <div class="controls sel span7">
                                    <asp:DropDownList class="nostyle" ID="ddlYearFrom" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlYearFrom_SelectedIndexChanged"></asp:DropDownList>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">To Year</label>
                                <asp:TextBox ID="txtToYear" runat="server" class="txtcs  span7" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>

                        

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <asp:Button ID="btnShowReport" runat="server" CssClass="btn_l" Text="Show Report" OnClick="btnShowReport_Click" />

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
                        <span>Report</span>
                    </h4>
                    <a href="dvReport" class="minimize"></a>
                </div>
                <div class="content" id="dvReport">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                
                                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1200" Height="600"></rsweb:ReportViewer>

                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
