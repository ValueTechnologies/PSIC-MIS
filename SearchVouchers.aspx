<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="SearchVouchers.aspx.cs" Inherits="PSIC.SearchVouchers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Search Voucher');
            $('#txtSearchDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });

        });


    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span3">
            <div class="email-nav well">

                <table>
                    <tr>
                        <td>
                            Date
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <input type="text" id="txtSearchDate" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button type="button" class="btn btn-info">Search</button>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>

                        </td>
                    </tr>
                </table>



    <%--             <div class="form-row row-fluid">
                    <div class="span6">
                        <label class="form-label span3" for="normal">Plot No. </label>
                        <div class="span8" style="margin-left: 0px;">
                            <select id="ddlPlotNo">
                            </select>
                        </div>
                    </div>
                    <div class="span6">
                        <label class="form-label span3" for="normal">Type </label>
                        <div class="span8" style="margin-left: 0px;">
                            <select id="ddlType">
                            </select>
                        </div>
                    </div>
                </div>




                <div class="form-row row-fluid">
                    <div class="span6" style="margin-left: 0px;">
                        <label class="form-label span3" for="normal"></label>
                        <button type="button" id="btnSearch" class="btn btn-primary span2" style="margin-left: 0px;">Search</button>
                    </div>
                </div>--%>



            </div>
        </div>
    </div>

</asp:Content>
