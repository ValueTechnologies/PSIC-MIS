<%@ Page Title="" EnableEventValidation="false" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="LedgerRpt.aspx.cs" Inherits="PSIC.LedgerRpt" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Ledger');
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div style="background-color : white;">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1000" Height="1000"></rsweb:ReportViewer>
    </div>



</asp:Content>
