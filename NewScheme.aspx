<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="NewScheme.aspx.cs" Inherits="PSIC.NewScheme" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;

    <script type="text/javascript">


        $(document).ready(function () {
            $('.heading h3').html('Estate Registration');


            $(function () {
                $("#txtStartingDate").datepicker({ dateFormat: 'dd - MM - yy' });
            });

            LoadSchemes();
            $('#btnAddCategory').bind('click', function () {
                var str = "";
                str += '<tr><td> ' + $('#txtPlotCategories').val() + ' </td> <td><img class="clsCancelPlotCategory" src="Images/cross_circle.png" /> </td> </tr>';
                $('#tbPlotCategories tbody').append(str);
                $('#txtPlotCategories').val('');
                $('#txtPlotCategories').focus();
            });





            getDistt();




            $('#ddDistt').bind('change', getTehsil);



        });
        //End Ready

        function getDistt() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "NewScheme.aspx/getlocDistrict",
                data: "{}",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                    });
                    $('#ddDistt').html(out);
                    $('#ddDistt').prev().html($('#ddDistt option:selected').text());
                    getTehsil();
                }
            });
        }

        function getTehsil() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "NewScheme.aspx/getlocTehsil",
                data: "{'TypeID':'" + $('#ddDistt').val() + "'}",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                    });
                    $('#ddTeh').html(out);
                    $('#ddTeh').prev().html($('#ddTeh option:selected').text());


                }
            });
        }


        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCancelPlotCategory')



        $('body').on({
            click: function () {

                if ($('#txtSchemeName').val().trim() == "") {
                    alert('Please Enter Scheme Name.');
                    return;
                }


                if ($('#txtStartingDate').val().trim() == "") {
                    alert('Please Enter Starting Date of Scheme.');
                    return;
                }


                if ($('#btnSave').html().trim() == "Save") {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "NewScheme.aspx/SaveScheme",
                        data: "{ 'schemeName' : '" + $('#txtSchemeName').val().trim() + "', 'districtID' : '" + $('#ddDistt').val() + "', 'TehsilID' : '" + $('#ddTeh').val() + "', 'startingDate' : '" + $('#txtStartingDate').val() + "'  , 'GPS' : '" + $('#txtGPS').val() + "'    , 'areaOfEstate' : '" + $('#txtTotalAreaOfEstate').val() + "' }",
                        success: function (response) {
                            if (response.d == "1") {
                                $('#tbPlotCategories tbody').html('');
                                $('#txtSchemeName').val('');
                                $('#txtStartingDate').val('');
                                $('#txtEndingDate').val('');
                                $('#txtPlotCategories').val('');
                                $('#txtGPS').val('');
                                $('#txtTotalAreaOfEstate').val('');
                            }
                            LoadSchemes();
                            alert('Save Successfully!');
                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "NewScheme.aspx/UpdateScheme",
                        data: "{ 'SchemeID' : '" + $('#btnSave').attr('tag') + "', 'schemeName' : '" + $('#txtSchemeName').val().trim() + "', 'districtID' : '" + $('#ddDistt').val() + "', 'TehsilID' : '" + $('#ddTeh').val() + "', 'startingDate' : '" + $('#txtStartingDate').val() + "'  , 'GPS' : '" + $('#txtGPS').val() + "' , 'TotalArea' : '" + $('#txtTotalAreaOfEstate').val() + "' }",
                        success: function (response) {
                            if (response.d == "1") {
                                $('#tbPlotCategories tbody').html('');
                                $('#txtSchemeName').val('');
                                $('#txtStartingDate').val('');
                                $('#txtEndingDate').val('');
                                $('#txtPlotCategories').val('');
                                $('#txtGPS').val('');
                                $('#txtTotalAreaOfEstate').val('');
                                $('#btnSave').html('Save');
                                $('#btnSave').removeAttr('tag');
                            }
                            LoadSchemes();
                            alert('Save Successfully!');
                        }
                    });
                }


            }
        }, '#btnSave');




        function LoadSchemes() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "NewScheme.aspx/LoadSchemes",
                data: "{}",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td> ' + item.Srno + '</td>   <td style="text-align : left;"> ' + item.Scheme + ' </td><td style="text-align : left;"> ' + item.TotalAreaOfEstate + ' </td> <td> ' + item.StartingDate + ' </td><td> ' + item.Tehsil + ' </td>       <td> <img src="Images/EditInfo.png" tag="' + item.SchemeID + '"  TID="' + item.TehsilID + '"  DID="' + item.DistrictID + '" GPS="' + item.GPS + '" class="EditInfo" style="width:20px; height : 20px;" /></td></tr>';
                    });
                    $('#tbSchemes tbody').html(Out);
                }
            });
        }



        function ClearSelection() {
            $('.EditInfo').each(function () {
                $(this).parent().removeClass('SeletionClass');
                $(this).parent().prev().removeClass('SeletionClass');
                $(this).parent().prev().prev().removeClass('SeletionClass');
                $(this).parent().prev().prev().prev().removeClass('SeletionClass');
                $(this).parent().prev().prev().prev().prev().removeClass('SeletionClass');
                $(this).parent().prev().prev().prev().prev().prev().removeClass('SeletionClass');
            });
        }

        $('body').on({
            click: function () {
                $('#txtStartingDate').val($(this).parent().prev().prev().html().trim());
                $('#txtGPS').val($(this).attr('GPS'));
                $('#ddDistt').val($(this).attr('DID'));
                getTehsil();
                $('#ddTeh').val($(this).attr('TID'));
                $('#txtSchemeName').val($(this).parent().prev().prev().prev().prev().html().trim());
                $('#txtTotalAreaOfEstate').val($(this).parent().prev().prev().prev().html().trim());
                $('#btnSave').attr('tag', $(this).attr('tag'));
                $('#btnSave').html('Update');
            }
        }, ".EditInfo");



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--==================--%>

    <div id="BE" class="modal hide fade" style="display: none;">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span class="icon12 minia-icon-close"></span></button>
            <h3 id="BEtitle">GPS MAP</h3>
        </div>
        <div class="modal-body">
            <div id="BEbody" class="paddingT15 paddingB15">
                <%--///////////////--%>

                <div id="dvlMap" title="MAP">
                    <div class="inner" style="margin: 0; background: #808080; padding: 10px; border: 0; zoom: 1; width: 501px; border-radius: 15px;">
                        <div id="mapCanvas" style="border-radius: 15px; width: 500px; height: 400px;"></div>
                    </div>
                    <div id="infoPanel">
                        <table style="line-height: 12px; border-width: thin; font-size: smaller; border-spacing: 0px; width: 501px; margin-left: 9px;">
                            <tr>
                                <td>Marker status:</td>
                                <td style="text-align: right;">
                                    <div id="markerStatus"><i>Click and drag the marker.</i></div>
                                </td>
                            </tr>
                            <tr>
                                <td>Current position:</td>
                                <td style="text-align: right;">
                                    <div id="infoll"></div>
                                </td>
                            </tr>
                            <tr>
                                <td>Closest address:</td>
                                <td style="text-align: right;">
                                    <div id="address"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%--/////////////////--%>
            </div>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" data-dismiss="modal">Close</a>
        </div>
    </div>

    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript">

        $(document).keypress(function (e) {
            if (e.keyCode === 13) {
                e.preventDefault();
                return false;
            }
        });
        var geocoder = new google.maps.Geocoder();

        $(document).ready(function () {


            //$().mask("a*@a*.a*");

            $('#txtGPS').bind('click', function () {
                //alert("Getting GPS...");
                if ($.trim($(this).val()) == "") {
                    $('#BE').modal("toggle");
                    initialize();
                }
            });







            //////////////////////////GET GPS
            //////////////////////////GET GPS
            function geocodePosition(pos) {
                geocoder.geocode({
                    latLng: pos
                }, function (responses) {
                    if (responses && responses.length > 0) {
                        updateMarkerAddress(responses[0].formatted_address);
                    } else {
                        updateMarkerAddress('Cannot determine address at this location.');
                    }
                });
            }

            function updateMarkerStatus(str) {
                $('#markerStatus').html(str);
            }

            function updateMarkerPosition(latLng) {
                var posi = [latLng.lat(), latLng.lng()].join(', ');
                $('#txtGPS').val(posi);
                $('#infoll').html(posi);
                //UploaderVisibility();
            }

            function updateMarkerAddress(str) {
                $('#address').html(str);
                //   $(".gmnoprint[title]").attr('title', str);
            }


            function LoadTargetMap(obj) {

                var latLng = new google.maps.LatLng(obj[0], obj[1]);
                //var latLng = new google.maps.LatLng(33.6686934, 72.9986465);
                var map = new google.maps.Map($('#mapCanvas')[0], {
                    zoom: 16,
                    center: latLng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                });
                var marker = new google.maps.Marker({
                    position: latLng,
                    title: 'Click the marker and drag it to exact position to get actual GPS',
                    map: map,
                    draggable: true,
                    icon: 'Images/gmap-markerPSIC.png'
                });

                // Update current position info.
                updateMarkerPosition(latLng);
                geocodePosition(latLng);

                // Add dragging event listeners.
                google.maps.event.addListener(marker, 'dragstart', function () {
                    updateMarkerAddress('Dragging...');
                });

                google.maps.event.addListener(marker, 'drag', function () {
                    updateMarkerStatus('Dragging...');
                    updateMarkerPosition(marker.getPosition());
                });

                google.maps.event.addListener(marker, 'dragend', function () {
                    updateMarkerStatus('Drag ended');
                    geocodePosition(marker.getPosition());
                });
            }

            function initialize() {

                //alert('1');
                var ss = "30.3894007, 69.3532207".split(', ');

                //----------------------------------


                geocoder.geocode({
                    address: 'Punjab' + ' ' + $("#ddDistt option:selected").text() + ' ' + $("#ddTeh option:selected").text() + ' Pakistan',

                    region: 'no'
                },
                    function (results, status) {
                        //alert($("#ddlGeoUnionConcil option:selected").text() + ' Pakistan');

                        if (status.toLowerCase() == 'ok') {
                            ss = [];
                            var coords = new google.maps.LatLng(
                                results[0]['geometry']['location'].lat(),
                                results[0]['geometry']['location'].lng()
                            );


                            ss.push(coords.lat());
                            ss.push(coords.lng());
                            LoadTargetMap(ss)
                            ;

                        }
                        else {
                            //******************************
                            geocoder.geocode({
                                address: 'Punjab' + ' ' + $("#ddDistt option:selected").text() + ' ' + $("#ddTeh option:selected").text() + ' Pakistan',
                                region: 'no'
                            },
                   function (results, status) {
                       if (status.toLowerCase() == 'ok') {
                           ss = [];
                           var coords = new google.maps.LatLng(
                               results[0]['geometry']['location'].lat(),
                               results[0]['geometry']['location'].lng()
                           );


                           ss.push(coords.lat());
                           ss.push(coords.lng());
                           LoadTargetMap(ss)
                           ;
                       }
                       else {
                           ss = "30.3894007, 69.3532207".split(', ');
                           LoadTargetMap(ss)
                           ;
                       }
                   });
                            //******************************
                        }
                    });
            }
            ///////////////////////////////////////////////////////////End Get GPS
            //////////////////////////GET GPS END






        });//END OF READY FUNCTION

    </script>




    <%--*******************************************************--%>
    <%--*******************************************************--%>







    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>New Scheme</span>
                    </h4>
                    <a href="dvNewScheme" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewScheme">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Name Of State: </label>
                                <input id="txtSchemeName" type="text" class="span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Location : </label>
                                <div class="span8" style="margin-left: 0px;">
                                    <table>
                                        <tr>
                                            <td>District</td>
                                            <td style="width: 250px;">
                                                <div class="controls sel">
                                                    <select id="ddDistt" class="vl frmCtrl nostyle" name="D1"></select>
                                                </div>
                                            </td>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                            <td>Tehsil</td>
                                            <td style="width: 250px;">
                                                <div class="controls sel">
                                                    <select id="ddTeh" class="vl frmCtrl nostyle">
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">GPS : </label>
                                <input  id="txtGPS" class="span4" style="width: 295px;" type="text" title="Click on this and get Map" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Date Of Establishment : </label>
                                <input id="txtStartingDate" type="text" class="span4" style="width: 295px;" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Total Area Of Estate: </label>
                                <input id="txtTotalAreaOfEstate" type="text" class="span4" style="width: 295px;"/>
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
                        <span>All Registered Estates</span>
                    </h4>
                    <a href="dvAllScheme" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvAllScheme">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSchemes" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 20px;">Sr.No</th>
                                            <th>Name Of Estate
                                            </th>
                                            <th>Total Area Of Estate</th>
                                            <th style="width: 200px;">Date Of Establishment
                                            </th>
                                            <th>Estate Tehsil
                                            </th>
                                            <th>Edit</th>
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
