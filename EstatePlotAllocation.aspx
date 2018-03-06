<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstatePlotAllocation.aspx.cs" Inherits="PSIC.EstatePlotAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Plot Allocation');
            $('#txtPurchasingDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtPurchasingDateEdit').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });


            $(function () {
                $('#dvEditOwnerDetail').dialog({ autoOpen: false, width: "45%", modal: true });
            });



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

                        $('#ddlCandidatesEdit').html(Out);
                        $('#ddlCandidatesEdit').prev().html($('#ddlCandidatesEdit option:selected').text());

                    }
                });
            }


            $('#AddTransferTo').bind('click', function () {
                var str = "";
                str = '<tr><td> ' + $('#ddlCandidates option:selected').text() + '  </td>  <td> ' + $('#txtPercentage').val().replace('%', '') + " %" + '  </td>  <td>   <img tag="' + $('#ddlCandidates').val() + "↕" + $('#txtPercentage').val().replace('%', '') + '" class="clsCandidates" src="Images/cross_circle.png">  </td> </tr>';
                $('#tbCandidates').append(str);
                $('#txtPercentage').val('');
            });





            $('#btnSave').bind('click', function () {

                var PlotiD = $('#btnSave').attr('tag');
                var PlotOwnershipCandidateID = $('#btnSave').attr('PlotOwnershipCandidateID');
                var Candidates = "";

                Candidates = $('#ddlCandidates').val();

                //if (Ownershipcandidateid == 0) {
                //    alert("Please select Owner who sale the ownership.");
                //    return;
                //}


                if ($('#txtPercentage').val().trim() == "") {
                    alert("Please enter percentage of allocation.");
                    return;
                }




                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotAllocation.aspx/SaveAllocation",
                    data: "{ 'PlotOwnershipCandidateID' : '" + PlotOwnershipCandidateID + "', 'AllocationPercentage' : '" + $('#txtPercentage').val() + "' , 'Candidates' : '" + Candidates + "', 'PurchasingDate' : '" + $('#txtPurchasingDate').val() + "', 'AllocateThrough' : '" + $('#ddlAllocateThrough').val() + "'}",
                    success: function (response) {
                        alert('Save successfully!');
                        $('#tbCandidates').html('');
                        LoadPlotOwners(PlotiD);
                    }
                });


            });



            $('#btnEdit').bind('click', function () {
                var PlotiD = $('#btnSave').attr('tag');
                if ($('#txtPurchasingDateEdit').val() == "") {
                    alert("Please enter purchasing date..");
                    return;
                }


                if ($('#txtPercentageEdit').val() == "") {
                    alert("Please enter contribution..");
                    return;
                }




                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstatePlotAllocation.aspx/UpdateAllocation",
                    data: "{ 'PlotOwnershipCandidateID' : '" + $('#btnEdit').attr('PlotOwnershipCandidateID') + "', 'AllocationPercentage' : '" + $('#txtPercentageEdit').val() + "' , 'Candidates' : '" + $('#ddlCandidatesEdit').val() + "', 'PurchasingDate' : '" + $('#txtPurchasingDateEdit').val() + "', 'AllocateThrough' : '" + $('#ddlAllocateThroughEdit').val() + "'}",
                    success: function (response) {
                        alert('Save successfully!');
                        $('#tbCandidates').html('');

                        LoadPlotOwners(PlotiD);
                        $('#dvEditOwnerDetail').dialog('close');
                    }
                });
            });







        });
        //end ready

        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCandidates');



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
                $('#btnSave').attr('tag', $(this).attr('tag'));
                $(this).attr('disabled', 'disabled');
                $('#btnSelectCandidate').removeAttr('disabled');





                //Load Plot Owners


                LoadPlotOwners($(this).attr('tag'));




            }
        }, '.clsSelectingPlot');




        function LoadPlotOwners(plotid) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstatePlotAllocation.aspx/LoadOwnersOfPlot",
                data: "{ 'PlotiD' : '" + plotid + "'}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "", OutOwners = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td style="display:none;"> ' + item.PlotOwnershipCandidateID + '</td> <td> ' + item.Owner_Name + '</td><td> ' + item.ContactNo + '</td><td> ' + item.Address + '</td><td> ' + item.ContributionPercentage + '</td><td> <button tag="' + item.PlotOwnershipCandidateID + '" type="button" class="clsSelectingPlotOwner btn btn-link">Allocate </button>      </td></tr>';
                        OutOwners = OutOwners + '<tr><td style="display:none;"> ' + item.PlotOwnershipCandidateID + '</td> <td> ' + item.Owner_Name + '</td><td> ' + item.ContributionPercentage + '</td><td> ' + item.OwnerShipStart + '</td><td> ' + item.TransferThrough + '</td><td> <button PlotOwnershipCandidateID="' + item.PlotOwnershipCandidateID + '"   CandidateID="' + item.CandidateID + '"    type="button" class="clsPlotOwnerEdit btn btn-link">Edit </button>      </td></tr>';

                    });

                    $('#tbSearchedPlotOwners tbody').html(Out);
                    $('#tbPlotOwners tbody').html(OutOwners);
                }
            });
        }




        $('body').on({
            click: function () {
                var transferThroug = "";
                $('#ddlCandidatesEdit').val($(this).attr('CandidateID'));
                $('#txtPurchasingDateEdit').val($(this).parent().prev().prev().html());

                transferThroug = $(this).parent().prev().html()

                $('#ddlAllocateThroughEdit option').filter(function () {
                    if (this.Text == transferThroug) {
                        return this.Text = transferThroug;
                    }

                }).attr('selected', true);

                //$('#ddlAllocateThroughEdit option:contains(' + $(this).parent().prev().html() + ')').select();



                $('#txtPercentageEdit').val($(this).parent().prev().prev().prev().html());

                $('#btnEdit').attr('PlotOwnershipCandidateID', $(this).attr('PlotOwnershipCandidateID'));
                $('#dvEditOwnerDetail').dialog('open');
            }
        }, '.clsPlotOwnerEdit');




        $('body').on({
            click: function () {

                $(this).parent().prev().prev().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().prev().css('background-color', 'rgba(40, 239, 15, 0.35)');
                $(this).parent().css('background-color', 'rgba(40, 239, 15, 0.35)');

                $('#btnSave').attr('PlotOwnershipCandidateID', $(this).attr('tag'));
                $(this).attr('disabled', 'disabled');
            }
        }, '.clsSelectingPlotOwner');






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

                    
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Name Of Estate </label>
                                <div class="span8 controls sel" style="margin-left: 0px;">
                                    <select id="ddlScheme" class="nostyle">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">Category </label>
                                <div class="span8 controls sel" style="margin-left: 0px;">
                                    <select id="ddlCategory" class="nostyle">
                                    </select>
                                </div>
                            </div>

                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Plot No. </label>
                                <div class="span8 controls sel" style="margin-left: 0px;">
                                    <select id="ddlPlotNo" class="nostyle">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span3" for="normal">Type </label>
                                <div class="span8 controls sel" style="margin-left: 0px;">
                                    <select id="ddlType" class="nostyle">
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
                        <br/>
                        <br/>

                        <h3 style="text-align: center; background-color: lightgray;">Plot Owners
                        </h3>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table class="responsive table table-striped table-bordered table-condensed" id="tbSearchedPlotOwners">
                                    <thead>
                                        <tr>
                                            <th style="display: none;">PlotOwnershipCandidateID
                                            </th>
                                            <th>Owner_Name
                                            </th>
                                            <th>ContactNo
                                            </th>
                                            <th>Address
                                            </th>
                                            <th>ContributionPercentage
                                            </th>
                                            <th>Allocate
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div class="span10" style="background-color: lightgray; padding: 5px; text-align: center; border-radius: 7px; margin-top: 20px; margin-bottom: 30px;">
                                    <h3>Plot Allocate To
                                    </h3>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Purchasing Date</label>
                                <input type="text" class="span4" id="txtPurchasingDate" />
                            </div>

                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Allocate Through</label>
                                <div class="span4 controls sel" style="margin-left: 0px;">
                                    <select id="ddlAllocateThrough" class="txtcs nostyle">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Buyer</label>
                                <div class="span4" style="margin-left: 0px;">
                                    <select id="ddlCandidates">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Contribution (%)</label>
                                <div class="span4 controls sel">
                                    <input type="text" id="txtPercentage" class="text"/>
                                </div>


                                <button style="display: none;" type="button" class="btn btn-info span2" id="AddTransferTo">Add</button>
                            </div>
                        </div>

                        <table class="responsive table table-striped table-bordered table-condensed" id="tbCandidates" style="width: 32%; margin-left: 23%;"></table>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" class="btn btn-primary" id="btnSave">Save</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table class="responsive table table-striped table-bordered table-condensed" id="tbPlotOwners">
                                    <thead>
                                        <tr>
                                            <th style="display: none;">PlotOwnershipCandidateID
                                            </th>
                                            <th>Owner_Name
                                            </th>
                                            <th>Contribution Percentage
                                            </th>
                                            <th>Purchasing Date
                                            </th>
                                            <th>Allocate Through
                                            </th>
                                            <th>Edit
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
