<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstateChangeIndustry.aspx.cs" Inherits="PSIC.EstateChangeIndustry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Change Industry');
            $('#txtStartingDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
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
                
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateChangeIndustry.aspx/SaveNewIndustry",
                    data: "{ 'PlotId' : '" + $('#btnSave').attr('tag') + "', 'StartingDate' : '" + $('#txtStartingDate').val() + "' , 'IndustrialUnit' : '" + $('#txtIndustrialUnit').val() + "', 'TypeClassification' : '" + $('#txtTypeClassification').val() + "'    , 'Electricity' : '" + $('#txtElectricity').val() + "'   , 'Water' : '" + $('#txtWater').val() + "' , 'Gas' : '" + $('#txtGas').val() + "' , 'IdentifyWastProduct' : '" + $('#txtIdentifyWastProduct').val() + "'   , 'ModeOfDisposal' : '" + $('#txtModeOfDisposal').val() + "'}",
                    success: function (response) {
                        alert('Save successfully!');                        
                        $('#btnSave').removeAttr('tag');
                        $('#txtStartingDate').val('');
                        $('#txtIndustrialUnit').val('');
                        $('#txtTypeClassification').val('');
                        $('#txtElectricity').val('');
                        $('#txtWater').val('');
                        $('#txtGas').val('');
                        $('#txtIdentifyWastProduct').val('');
                        $('#txtModeOfDisposal').val('');

                    }
                });
            });
        });


        function SearchPlot() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstatePlotAllocation.aspx/SearchPlots",
                data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "', 'CategoryID' : '" + $('#ddlCategory').val() + "','PlotID' : '" + $('#ddlPlotNo').val() + "','PlotType' : '" + $('#ddlType').val() + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td> ' + item.Srno + '</td> <td> ' + item.PlotNo + '</td><td> ' + item.Category + '</td><td> ' + item.KhasraNo + '</td><td> ' + item.PlotType + '</td><td> ' + item.PlotStatus + '</td><td> <button type="button" CID="' + item.PlotCategoryID + '" tag="' + item.PlotID + '" class="clsSelectingPlot btn btn-link">Change Industry </button>      </td></tr>';
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
                                            <th>Change Industry
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
                        <span>New Industry Detail </span>
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
                                    <h3>New Industry
                                    </h3>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Starting Date</label>
                                <input type="text" class="span5" id="txtStartingDate" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Industrial Unit</label>
                                <input type="text" class="span5" id="txtIndustrialUnit" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Type/Classification Of Industry</label>
                                <input type="text" class="span5" id="txtTypeClassification" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Electricity</label>
                                <input type="text" class="span5" id="txtElectricity" />&nbsp;&nbsp;KVA
                            </div>

                        </div>




                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Water</label>
                                <input class="span5" type="text" id="txtWater" />&nbsp;&nbsp;Liters / Day
                            </div>

                        </div>




                        <div class="form-row row-fluid">

                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Gas</label>

                                <input type="text" id="txtGas" class="span5" />&nbsp;&nbsp;Hm<sup>3</sup>
                            </div>
                        </div>


                        <div class="form-row row-fluid">

                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Identify wast product</label>
                                <input type="text" id="txtIdentifyWastProduct"  class="span5"/>
                            </div>
                        </div>




                        <div class="form-row row-fluid">

                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Mode of disposal</label>
                                <input type="text" id="txtModeOfDisposal"  class="span5"/>
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
