<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstatePlotBalloting.aspx.cs" Inherits="PSIC.EstatePlotBalloting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">
        var ArrApplicants = [];
        $(document).ready(function () {
            $('.heading h3').html('Balloting');
            LoadScheme();
            LoadType();




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




        });
        //end ready

        function SearchPlot() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstatePlotBalloting.aspx/SearchPlots",
                data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "', 'CategoryID' : '" + $('#ddlCategory').val() + "','PlotID' : '" + $('#ddlPlotNo').val() + "','PlotType' : '" + $('#ddlType').val() + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td> ' + item.Srno + '</td> <td> ' + item.PlotNo + '</td><td> ' + item.Category + '</td><td> ' + item.KhasraNo + '</td><td> ' + item.PlotType + '</td><td> ' + item.PlotStatus + '</td><td> <button type="button" CID="' + item.PlotCategoryID + '" tag="' + item.PlotID + '" class="clsSelectingPlot btn btn-link">Allocate </button>      </td></tr>';
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
                SearchCandidates($(this).attr('CID'));
                $('#btnSelectCandidate').attr('tag', $(this).attr('tag'));
                $(this).attr('disabled', 'disabled');
                $('#btnSelectCandidate').removeAttr('disabled');

            }
        }, '.clsSelectingPlot');


        function SearchCandidates(CategoryID) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstatePlotBalloting.aspx/SearchCandidatesForPlotCategory",
                data: "{ 'CategoryID' : '" + CategoryID + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr class="clsApplications" ApplicationID="' + item.ApplicationID + '"><td> ' + item.Srno + '</td> <td style="text-align:left;"> ' + item.ApplicantName + '</td><td style="text-align:left;"> ' + item.CorporateSetup + '</td><td style="text-align:left;"> ' + item.IndustrialUnit + '</td><td style="text-align:left;"> ' + item.Typeclassification + '</td></tr>';
                        ArrApplicants[i] = item.ApplicationID;
                    });

                    $('#tbApplicantsPlot tbody').html(Out);

                }
            });
        }


        $('body').on({
            click: function () {
                var item = ArrApplicants[Math.floor(Math.random() * ArrApplicants.length)];
                alert('Application No is : ' + item);
                $('.clsApplications').each(function () {
                    if ($(this).attr('ApplicationID') == item) {
                        $(this).children().css('background-color', 'rgb(183, 252, 163)');
                        $(this).attr('PlotNo', $('#btnSelectCandidate').attr('tag'));
                        $('#btnSelectCandidate').attr('disabled', 'disabled');
                    }
                });
                ArrApplicants.splice($.inArray(item, ArrApplicants), 1);
            }
        }, '#btnSelectCandidate');




        $('body').on({
            click: function () {
                var is_Save = "";
                try {
                    $('.clsApplications').each(function (i, item) {
                        if ($(this).attr('plotno') != undefined) {
                            $.ajax({
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                url: "EstatePlotBalloting.aspx/SaveSelectedCandidates",
                                data: "{ 'applicationID' : '" + $(this).attr('applicationid') + "', 'plotID' : '" + $(this).attr('plotno') + "'}",
                                success: function (response) {

                                }
                            });
                        }
                    });
                    alert('Save successfully!');
                    $('#tbApplicantsPlot tbody').html('');
                    SearchPlot();
                } catch (e) {
                    alert('Error : ' + e.message);
                }

            }
        }, "#btnSave");


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
                                            <th>Allocate
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
                        <span>Plot Allocation </span>
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
                                <table id="tbApplicantsPlot" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Sr.No
                                            </th>
                                            <th>Applicant(s)
                                            </th>
                                            <th>Corporate set-up
                                            </th>
                                            <th>Industrial Unit
                                            </th>
                                            <th>Type/Classification
                                            </th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>






                        <div class="form-row row-fluid">
                            <div class="span6">
                                <button type="button" class="btn btn-inverse" id="btnSelectCandidate">Select Candidate</button>

                            </div>
                            <div class="span6">
                                <div style="margin-left: 80%;">
                                    <button type="button" class="btn btn-primary" id="btnSave">Save</button>
                                </div>

                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
