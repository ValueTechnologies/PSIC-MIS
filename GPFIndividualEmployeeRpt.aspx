<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="GPFIndividualEmployeeRpt.aspx.cs" Inherits="PSIC.GPFIndividualEmployeeRpt" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;




    <script  type="text/javascript">    
        $(document).ready(function () {
            $('.heading h3').html('Employee GPF Yearly Report');
        });
        $('#ctl00$ContentPlaceHolder1$ddlYearFrom').change(function () {
            var NextYear = parseInt($('#ctl00$ContentPlaceHolder1$ddlYearFrom').val()) + 1;
            $('#ctl00$ContentPlaceHolder1$txtYearTo').val(NextYear);
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">





        <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Employee</span>
                    </h4>
                    <a href="dvSearchEmployees" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchEmployees">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">GPF Year (From)</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <asp:DropDownList ID="ddlYearFrom" runat="server" DataSourceID="SqlDataSourceYearsFrom" DataTextField="year" DataValueField="year" AutoPostBack="True" OnSelectedIndexChanged="ddlYearFrom_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceYearsFrom" runat="server" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>" SelectCommand="with yearlist as (select 1947 as year union all select yl.year + 1 as year from yearlist yl where yl.year + 1 &lt;= YEAR(GetDate()) ) select year from yearlist order by year desc;"></asp:SqlDataSource>
                                </div>
                                

                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">GPF Year (To)</label>
                                <div class="span7" style="margin-left : 0px;">
                                    <asp:TextBox ID="txtYearTo" runat="server" Enabled="False"></asp:TextBox>
                                </div>

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">
                                <asp:HiddenField ID="HiddenField_ID" runat="server" />
                                </label>

                                <asp:Button type="Button" runat="server" Text="Show Report" ID="btnSearch" OnClick="btnSearch_Click"  />
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
                        <span>Employee GPF Detail</span>
                    </h4>
                    <a href="dvReport" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvReport">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1000"></rsweb:ReportViewer>

                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>



</asp:Content>
