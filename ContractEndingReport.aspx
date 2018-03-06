<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="ContractEndingReport.aspx.cs" Inherits="PSIC.ContractEndingReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Contract Ending Report');



            $(function () {
                
                $("#ctl00_ContentPlaceHolder1_txtDateFrom").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true, showon: "button" });
            });

            $(function () {
                $("#ctl00_ContentPlaceHolder1_txtDateTo").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });
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
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Date From</label>
                                <asp:textbox runat="server" ID="txtDateFrom" class="span7"></asp:textbox>
                                
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Date To</label>
                                <asp:textbox runat="server" ID="txtDateTo" class="span7"></asp:textbox>

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Department</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <asp:dropdownlist runat="server" ID="ddlDept" DataSourceID="SqlDSDept" DataTextField="DepartmentName" DataValueField="DepartmentID"></asp:dropdownlist>
                                    <asp:sqldatasource runat="server" ID="SqlDSDept" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>" SelectCommand="Select 0 as DepartmentID, ' ---All---' as DepartmentName
union
SELECT        DepartmentID, DepartmentName
FROM            tbl_Departments"></asp:sqldatasource>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Designation</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <asp:dropdownlist runat="server" ID="ddlDesignation" DataSourceID="SqlDSDesignation" DataTextField="Designation" DataValueField="DesignationID"></asp:dropdownlist>
                                    <asp:sqldatasource runat="server" ID="SqlDSDesignation" ConnectionString="<%$ ConnectionStrings:PSIC_DBConnectionString %>" SelectCommand="Select 0 as DesignationID, ' ---All---' as Designation
union
SELECT        DesignationID, Designation
FROM            tbl_Designation"></asp:sqldatasource>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                
                                <asp:button type="Button" runat="server" text="Show Report" ID="btnSearch" OnClick="btnSearch_Click"  />
                            </div>

                        </div>

                        




                    </form>
                </div>
            </div>
        </div>
    </div>


    <%--Report--%>

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Contract Ending Report</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                
                                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1100" Height="550"></rsweb:ReportViewer>

                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>






</asp:Content>
