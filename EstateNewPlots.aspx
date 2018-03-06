<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstateNewPlots.aspx.cs" Inherits="PSIC.EstateNewPlots" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Plotting Of Estate');

            $('#btnSave').attr('tag', 0);

            LoadScheme();
            LoadType();
            LoadStatus();


            //initialize the pqSelect widget.
            //$("#ddlPlotLocation").pqSelect({
            //    multiplePlaceholder: 'Select Locations',
            //    checkbox: true //adds checkbox to options    
            //}).on("change", function (evt) {
            //    var val = $(this).val();

            //}).pqSelect('open');

            $('#btnAddLocation').live('click', function () {
                $('#tbSelectedLocations tbody').append("<tr><td>" + $('#ddlPlotLocation').val() + "</td><td> <img tag='" + $('#ddlPlotLocation').val() + "' class='clsLocations' src='Images/cross_circle.png' /></td></tr>");
            });


            $('body').on({
                click: function () {
                    $(this).parent().parent().remove();
                }
            }, '.clsLocations');






            $('#dvCategory').dialog({ autoOpen: false, width: "45%", modal: true });
            $('#dvStatus').dialog({ autoOpen: false, width: "45%", modal: true });
            $('#dvType').dialog({ autoOpen: false, width: "45%", modal: true });


            $('#btnAddCategory').bind('click', function () {
                $('#dvCategory').dialog("open");
            });

            $('#btnAddType').bind('click', function () {
                $('#dvType').dialog("open");
            });

            $('#btnAddStatus').bind('click', function () {
                $('#dvStatus').dialog("open");
            });



            //Save New


            $('#btnSaveCategory').bind('click', function () {
                if ($('#txtNewcategory').val().trim() == "") {
                    alert('Please enter category...');
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/SaveCategory",
                    data: "{ 'Category' : '" + $('#txtNewcategory').val().trim() + "', 'PlotSize' : '" + $('#txtPlotSize').val() + "', 'SchemeID' : '" + $('#ddlScheme').val() + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#dvCategory').dialog("close");
                        $('#txtNewcategory').val('');
                        $('#txtPlotSize').val('');
                        LoadCategories();
                    }
                });
            });

            $('#btnSaveType').bind('click', function () {
                if ($('#txtNewType').val().trim() == "") {
                    alert('Please enter Type...');
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/SaveType",
                    data: "{ 'Type' : '" + $('#txtNewType').val().trim() + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#dvType').dialog("close");
                        $('#txtNewType').val('');
                        LoadType();
                    }
                });
            });


            $('#btnSaveStatus').bind('click', function () {
                if ($('#txtNewStatus').val().trim() == "") {
                    alert('Please enter Status...');
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/SaveStatus",
                    data: "{ 'Status' : '" + $('#txtNewStatus').val().trim() + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#dvStatus').dialog("close");
                        $('#txtNewStatus').val('');
                        LoadStatus();
                    }
                });
            });


            //Load ddls

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


            function LoadType() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadType",
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


            function LoadStatus() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadStatus",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.PlotStatusID + '"> ' + item.PlotStatus + ' </value>';
                        });
                        $('#ddlStatus').html(Out);
                        $('#ddlStatus').prev().html($('#ddlStatus option:selected').text());
                    }
                });
            }



            $('#btnSave').bind('click', function () {



                if ($('#txtPlotNo').val().trim() == "") {
                    alert('Please enter Plot no...');
                    return;
                }
                //if ($('#txtKhasraNo').val().trim() == "") {
                //    alert('Please enter khasra no...');
                //    return;
                //}


                var LocationsList = "";
                var b = false;
                $('.clsLocations').each(function (i, obj) {
                    if (b) LocationsList = LocationsList + ",";
                    LocationsList = LocationsList + $(this).attr('tag');
                    b = true;
                });





                if ($('#btnSave').attr('tag') > 0) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "EstateNewPlots.aspx/CheckPlotNumberAlreadyExistsForUpdate",
                        data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "', 'PlotNo' : '" + $('#txtPlotNo').val() + "',  'PlotID' : '" + $('#btnSave').attr('tag') + "' }",
                        success: function (response) {
                            var jData = $.parseJSON(response.d), Out = "";
                            if (jData == null || jData.length == '0') {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "EstateNewPlots.aspx/UpdatePlot",
                                    data: "{ 'PlotID' : '" + $('#btnSave').attr('tag') + "', 'SchemeID' : '" + $('#ddlScheme').val() + "', 'PlotNo' : '" + $('#txtPlotNo').val() + "', 'PlotCategory' : '" + $('#ddlCategory').val() + "', 'KhasraNo' : '" + $('#txtKhasraNo').val() + "', 'PlotType' : '" + $('#ddlType').val() + "', 'PlotStatus' : '" + $('#ddlStatus').val() + "', 'PlotPSICPrice' : '" + $('#txtPrice').val() + "', 'PlotDetail' : '" + $('#txtPlotDetail').val() + "' , 'Locations' : '" + LocationsList + "'   }",
                                    success: function (response) {
                                        alert('Updated Successfully!');
                                        $('#tbSelectedLocations tbody').html('');
                                        $('#txtPlotNo').val('');
                                        //$('#txtKhasraNo').val('');
                                        $('#txtPrice').val('');
                                        $('#txtPlotDetail').val('');
                                        $('#btnSave').attr('tag', 0);
                                        LoadPlots();
                                    }
                                });
                            }
                            else {
                                alert('This plot number already exists.');
                                return;
                            }
                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "EstateNewPlots.aspx/CheckPlotNumberAlreadyExists",
                        data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "', 'PlotNo' : '" + $('#txtPlotNo').val() + "',  'PlotID' : '" + $('#btnSave').attr('tag') + "' }",
                        success: function (response) {
                            var jData = $.parseJSON(response.d), Out = "";
                            if (jData == null || jData.length == '0') {
                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    url: "EstateNewPlots.aspx/SaveNewPlot",
                                    data: "{ 'PlotID' : '" + $('#btnSave').attr('tag') + "', 'SchemeID' : '" + $('#ddlScheme').val() + "', 'PlotNo' : '" + $('#txtPlotNo').val() + "', 'PlotCategory' : '" + $('#ddlCategory').val() + "', 'KhasraNo' : '" + $('#txtKhasraNo').val() + "', 'PlotType' : '" + $('#ddlType').val() + "', 'PlotStatus' : '" + $('#ddlStatus').val() + "', 'PlotPSICPrice' : '" + $('#txtPrice').val() + "', 'PlotDetail' : '" + $('#txtPlotDetail').val() + "' , 'Locations' : '" + LocationsList + "'   }",
                                    success: function (response) {
                                        alert('Saved Successfully!');
                                        $('#tbSelectedLocations tbody').html('');
                                        $('#txtPlotNo').val('');
                                        //$('#txtKhasraNo').val('');
                                        $('#txtPrice').val('');
                                        $('#txtPlotDetail').val('');
                                        $('#btnSave').attr('tag', 0);
                                        LoadPlots();
                                    }
                                });
                            }
                            else {
                                alert('This plot number already exists.');
                                return;
                            }
                        }
                    });
                }
            });



            function LoadPlots() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadPlots",
                    data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<tr><td> ' + item.sno + '</td><td>' + item.PlotNo + '</td><td>' + item.Category + '</td>  <td>' + item.PlotSize + '</td> <td>' + item.PlotStatus + '</td><td> ' + item.PlotType + '</td><td> ' + item.Locations + '</td><td>' + item.PlotPSICPrice + '</td>        <td><button type="button" class="btn btn-link clsEditPlot" tag="' + item.PlotID + '">Edit </button>  </td></tr>';
                        });
                        $('#tbSchemesPlots tbody').html(Out);
                    }
                });
            }
        });


        $('body').on({
            click: function () {
                $('#btnSave').attr('tag', $(this).attr('tag'));

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/GetPlotDetailByID",
                    data: "{ 'PlotID' : '" + $('#btnSave').attr('tag') + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {

                            $('#txtPlotNo').val(item.PlotNo);//
                            $('#ddlCategory').val(item.PlotCategory);//
                            $('#txtKhasraNo').val(item.KhasraNo);//
                            $('#ddlType').val(item.PlotType);//
                            $('#ddlStatus').val(item.PlotStatus);//
                            //$('#ddlFunctionalStatus').val(item.FunctionalStatus);
                            $('#txtPrice').val(item.PlotPSICPrice);//
                            $('#txtPlotDetail').val(item.PlotDetail);//

                            if (item.Locations != null) {
                                var array = item.Locations.split(",");//
                                $('#tbSelectedLocations tbody').html("");
                                for (i = 0; i < array.length; i++) {
                                    $('#tbSelectedLocations tbody').append("<tr><td>" + array[i] + "</td><td> <img tag='" + array[i] + "' class='clsLocations' src='Images/cross_circle.png' /></td></tr>");
                                }
                            }
                            else {
                                $('#tbSelectedLocations tbody').html("");
                            }

                            $('#btnSave').attr('tag', item.PlotID);//
                            $('#btnSave').text('Update');
                        });
                    }
                });

            }
        }, ".clsEditPlot");

    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="dvCategory" title="Add New Category">
        <table>
            <tr>
                <td style="width: 100px;">New Category 
                </td>
                <td>
                    <input id="txtNewcategory" type="text" class="span5" />
                </td>
            </tr>
            <tr>
                <td style="width: 100px;">Plot Size
                </td>
                <td>
                    <input id="txtPlotSize" type="text" class="span5" />
                </td>
            </tr>
            <tr>
                <td style="width: 100px;"></td>
                <td>
                    <button type="button" class="btn btn-primary" id="btnSaveCategory">Save</button>
                </td>
            </tr>
        </table>
    </div>



    <div id="dvType" title="Add New Type">
        <table>
            <tr>
                <td style="width: 100px;">New Type 
                </td>
                <td>
                    <input id="txtNewType" type="text" class="span5" />
                </td>
            </tr>
            <tr>
                <td style="width: 100px;"></td>
                <td>
                    <button type="button" class="btn btn-primary" id="btnSaveType">Save</button>
                </td>
            </tr>
        </table>
    </div>



    <div id="dvStatus" title="Add New Status">
        <table>
            <tr>
                <td style="width: 100px;">New Status 
                </td>
                <td>
                    <input id="txtNewStatus" type="text" class="span5" />
                </td>
            </tr>
            <tr>
                <td style="width: 100px;"></td>
                <td>
                    <button type="button" class="btn btn-primary" id="btnSaveStatus">Save</button>
                </td>
            </tr>
        </table>
    </div>


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>New Plot</span>
                    </h4>
                    <a href="dvNewPlot" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewPlot">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Name Of Estate </label>
                                <div class="span5 controls sel" style="margin-left: 0px;">
                                    <select id="ddlScheme" class="nostyle">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Plot No. </label>
                                <input id="txtPlotNo" type="text" class="span5" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Category </label>
                                <div class="span5 controls sel" style="margin-left: 0px;">
                                    <select id="ddlCategory" class="nostyle">
                                    </select>
                                </div>
                                <button type="button" class="btn btn-info span2" id="btnAddCategory">Add New</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid" hidden>
                            <div class="span12">
                                <label class="form-label span3" for="normal">Khasra No. </label>
                                <input id="txtKhasraNo" type="text" value="0" class="span5" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Type </label>
                                <div class="span5 controls sel" style="margin-left: 0px;">
                                    <select id="ddlType" class="nostyle">
                                    </select>
                                </div>
                                <button type="button" class="btn btn-info span2" id="btnAddType">Add New</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Plot Location </label>

                                <div class="control sel span5" style="margin-left: 0px;">
                                    <select id="ddlPlotLocation" class="nostyle">
                                        <option>Main Road</option>
                                        <option>Link road</option>
                                        <option>Off Road</option>
                                        <option>Corner</option>
                                    </select>
                                </div>
                                <button type="button" id="btnAddLocation" class="span2 btn btn-info">Add</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <div class="span5" style="margin-left: 0px;">
                                    <table id="tbSelectedLocations" class="responsive table table-striped table-bordered table-condensed">
                                        <thead>
                                            <tr>
                                                <th>Selected Location(s)
                                                </th>
                                                <th>Cancel
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>

                                    </table>
                                </div>

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Status </label>
                                <div class="span5 controls sel" style="margin-left: 0px;">
                                    <select id="ddlStatus" class="nostyle">
                                    </select>
                                </div>
                                <button type="button" class="btn btn-info span2" id="btnAddStatus">Add New</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Functional Status </label>
                                <div class="span5 controls sel" style="margin-left: 0px;">
                                    <select id="ddlFunctionalStatus" class="nostyle">
                                        <option>Functional</option>
                                        <option>Non-Functional</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Total Price. </label>
                                <input id="txtPrice" type="text" class="span5" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Plot Detail </label>
                                <textarea id="txtPlotDetail" cols="20" rows="2" class="span5"></textarea>
                            </div>
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSave" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
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
                        <span>All Plots of Scheme</span>
                    </h4>
                    <a href="dvAllScheme" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvAllScheme">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSchemesPlots" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 20px;">Sr.No
                                            </th>
                                            <th>Plot #
                                            </th>
                                            <th>Category
                                            </th>
                                            <th>Size
                                            </th>
                                            <th>Status
                                            </th>
                                            <th>Type
                                            </th>
                                            <th>Locations
                                            </th>
                                            <th>PSIC Price
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
