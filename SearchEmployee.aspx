﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="SearchEmployee.aspx.cs" Inherits="PSIC.SearchEmployee" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Employees List');
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="background-color: white;">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1000" Height="550"></rsweb:ReportViewer>
    </div>

</asp:Content>