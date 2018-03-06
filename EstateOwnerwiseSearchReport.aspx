<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstateOwnerwiseSearchReport.aspx.cs" Inherits="PSIC.EstateOwnerwiseSearchReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Owner wise Plot History');
            $('#txtCNIC').mask('99999-9999999-9');

            $('#btnSearch').bind('click', SearchPlot);

            function SearchPlot() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateOwnerwiseSearchReport.aspx/SearchOwners",
                    data: "{ 'Name' : '" + $('#txtName').val() + "', 'CNIC' : '" + $('#txtCNIC').val() + "','Contact' : '" + $('#txtContactNo').val() + "','NTN' : '" + $('#txtNTN').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<tr><td style="text-align : left;"> ' + item.Srno + '</td> <td style="text-align : left;"> ' + item.Name + '</td><td style="text-align : left;"> ' + item.CNIC + '</td><td style="text-align : left;"> ' + item.ContactNo + '</td><td style="text-align : left;"> ' + item.NTN + '</td><td style="text-align : left;"> ' + item.Address + '</td><td><a href="EstateOwnerwiseRpt.aspx?ID=' + item.ApplicantID + '" target="_blank"   >Report</a>     </td></tr>';
                        });

                        $('#tbSearchedPlots tbody').html(Out);
                    }
                });
            }

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Owner </span>
                    </h4>
                    <a href="dvSearchPlotOwner" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchPlotOwner">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Name </label>
                                <input id="txtName" type="text" class="span5" />
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">CNIC </label>
                                <input id="txtCNIC" type="text" class="span5" />
                            </div>

                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">NTN</label>
                                <input id="txtNTN" type="text" class="span5" />
                            </div>
                            <div class="span6">
                                <label class="form-label span3" for="normal">Contact No. </label>
                                <input id="txtContactNo" type="text" class="span5" />
                            </div>
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span6" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSearch" class="btn btn-primary span2" style="margin-left: 0px;">Search</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedPlots">
                                    <thead>
                                        <tr>
                                            <th>Sr.No
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>CNIC
                                            </th>
                                            <th>Contact
                                            </th>
                                            <th>NTN
                                            </th>
                                            <th>Address
                                            </th>
                                            <th>Report
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>





</asp:Content>
