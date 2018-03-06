<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstatePlotTransfer.aspx.cs" Inherits="PSIC.EstatePlotTransfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        
        $(document).ready(function () {
            $('.heading h3').html('Plot Transfer');
            $('#txtTransferDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            LoadScheme();
            LoadType();
            AllCandidates();



            function LoadScheme() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadScheme",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.SchemeID + '"> ' + item.Scheme + ' </value>';
                        });
                        $('#ddlScheme').html(Out);
                        $('#ddlScheme').prev().html($('#ddlScheme option:selected').text());
                        LoadCategories();
                        LoadPlots();
                    }
                });
            }

            $('#ddlScheme').bind('change', function () {
                LoadCategories();
                LoadPlots();
            });

            function LoadCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadCategories",
                    data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.PlotCategoryID + '"> ' + item.Category + ' </value>';
                        });
                        $('#ddlCategory').html(Out);
                        $('#ddlCategory').prev().html($('#ddlCategory option:selected').text());
                    }
                });
            }


            function LoadPlots() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotBalloting.aspx/LoadPlots",
                    data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.PlotID + '"> ' + item.PlotNo + ' </value>';
                        });
                        $('#ddlPlotNo').html(Out);
                        $('#ddlPlotNo').prev().html($('#ddlPlotNo option:selected').text());


                    }
                });
            }


            function LoadType() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotBalloting.aspx/LoadType",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.PlotTypeID + '"> ' + item.PlotType + ' </value>';
                        });
                        $('#ddlType').html(Out);
                        $('#ddlType').prev().html($('#ddlType option:selected').text());
                    }
                });
            }


            $('#btnSearch').bind('click', SearchPlot);



            function AllCandidates() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotAllocation.aspx/AllCandidates",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.ApplicantID + '"> ' + item.Name + ' </value>';
                        });
                        $('#ddlCandidates').html(Out);
                        $('#ddlCandidates').prev().html($('#ddlCandidates option:selected').text());
                    }
                });
            }


            $('#btnAddCandidate').bind('click', function () {
                if ($('#txtAllocateRelation').val().trim() == "") {
                    alert('Please enter relation to transfer...');
                    return;
                }
                var str = "";
                str = '<tr><td> ' + $('#ddlCandidates').prev().html() + '  </td><td> ' + $('#txtAllocateRelation').val() + '  </td><td>   <img tag="' + $('#ddlCandidates').val() + '" class="clsCandidates" src="Images/cross_circle.png">  </td> </tr>';
                $('#tbCandidates').append(str);
                $('#txtAllocateRelation').val('');
            });





            $('#btnSave').bind('click', function () {
                var Candidates = "", Relation;
                $('.clsCandidates').each(function () {
                    Candidates = Candidates + ( $(this).parent().prev().html() + '§' +   $(this).attr('tag') + ',');
                });
                

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotTransfer.aspx/SaveTransfer",
                    data: "{ 'Candidates' : '" + Candidates + "', 'PlotId' : '" + $('#btnSave').attr('tag') + "', 'TransferDate' : '" + $('#txtTransferDate').val() + "' , 'TransferStatus' : '" + $('#ddlTransferStatus').val() + "', 'Remarks' : '" + $('#txtRemarks').val() + "'}",
                    success: function (response) {
                        alert('Save successfully!');
                        $('#tbCandidates').html('');
                        $('#txtRemarks').val('');
                        $('#txtTransferDate').val('');
                        $('#btnSave').removeAttr('tag');
                    }
                });


            });


        });


        function SearchPlot() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstatePlotTransfer.aspx/SearchPlots",
                data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "', 'CategoryID' : '" + $('#ddlCategory').val() + "','PlotID' : '" + $('#ddlPlotNo').val() + "','PlotType' : '" + $('#ddlType').val() + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td> ' + item.Srno + '</td> <td> ' + item.PlotNo + '</td><td> ' + item.Category + '</td><td> ' + item.KhasraNo + '</td><td> ' + item.PlotType + '</td><td> ' + item.PlotStatus + '</td><td> <button type="button" CID="' + item.PlotCategoryID + '" tag="' + item.PlotID + '" class="clsSelectingPlot btn btn-link">Transfer </button>      </td></tr>';
                    });

                    $('#tbSearchedPlots tbody').html(Out);
                }
            });
        }





        $('body').on({
            click: function () {
                $('#lblPlotNo').html($(this).parent().prev().prev().prev().prev().prev().html());
                $('#lblPlotCategory').html($(this).parent().prev().prev().prev().prev().html());
                $('#lblKhasraNo').html($(this).parent().prev().prev().prev().html());
                $('#lblType').html($(this).parent().prev().prev().html());
                $(this).parent().prev().prev().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $('#btnSave').attr('tag', $(this).attr('tag'));
                $(this).attr('disabled', 'disabled');
                $('#btnSelectCandidate').removeAttr('disabled');

            }
        }, '.clsSelectingPlot');


        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCandidates');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Plot </span>
                    </h4>
                    <a href="dvSearchPlotAllocation" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvSearchPlotAllocation">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Scheme </label>
                                <div class="span8" style="margin-left: 0px;">
                                    <select id="ddlScheme">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">Category </label>
                                <div class="span8" style="margin-left: 0px;">
                                    <select id="ddlCategory">
                                    </select>
                                </div>
                            </div>

                        </div>



                        <div class="form-row row-fluid">
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
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedPlots">
                                    <thead>
                                        <tr>
                                            <th>Sr.No
                                            </th>
                                            <th>Plot #
                                            </th>
                                            <th>Category
                                            </th>
                                            <th>Khasra No
                                            </th>
                                            <th>Type
                                            </th>
                                            <th>Status</th>
                                            <th>Transfer
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










    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Plot Allocate </span>
                    </h4>
                    <a href="dvNewPlotAllocation" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewPlotAllocation">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span6">
                                        <label class="form-label span4" for="normal" style="font-weight: bold;">Plot #</label>
                                        <label class="form-label span6" for="normal" id="lblPlotNo">.................</label>
                                    </div>
                                    <div class="span6">
                                        <label class="form-label span4" for="normal" style="font-weight: bold;">Plot Category</label>
                                        <label class="form-label span6" for="normal" id="lblPlotCategory">.................</label>
                                    </div>
                                </div>

                                <div class="form-row row-fluid">
                                    <div class="span6">
                                        <label class="form-label span4" for="normal" style="font-weight: bold;">Khasra No</label>
                                        <label class="form-label span6" for="normal" id="lblKhasraNo">.................</label>
                                    </div>
                                    <div class="span6">
                                        <label class="form-label span4" for="normal" style="font-weight: bold;">Type</label>
                                        <label class="form-label span6" for="normal" id="lblType">.................</label>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div class="span10" style="background-color: lightgray; padding: 5px; text-align: center; border-radius: 7px; margin-top: 20px; margin-bottom: 30px;">
                                    <h3>Plot Transfer To
                                    </h3>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Transfer Date</label>
                                <input type="text" class="span5" id="txtTransferDate" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Transfer Status</label>
                                <div class="span5" style="margin-left: 0px;">
                                    <select id="ddlTransferStatus">
                                        <option>Full</option>
                                        <option>Partial</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Allocate To</label>
                                <div class="span5" style="margin-left: 0px;">
                                    <select id="ddlCandidates">
                                        <option value="value"></option>
                                    </select>
                                </div>
                            </div>
                            
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Allocate Relation</label>
                                <div class="span5" style="margin-left : 0px; ">
                                    <input type="text"  id="txtAllocateRelation" style="width : 98%;"/> 
                                </div>
                                
                                <button type="button" class="span2 btn btn-info" id="btnAddCandidate">Add</button>
                            </div>
                            
                        </div>

                        <table class="responsive table table-striped table-bordered table-condensed" id="tbCandidates" style="width: 40%; margin-left: 23%;"></table>


                        <div class="form-row row-fluid">
                            
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Remarks</label>
                                
                                <textarea class="span5" id="txtRemarks" rows ="2" cols="5"></textarea>
                            </div>
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" class="btn btn-primary" id="btnSave">Save</button>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>





</asp:Content>
