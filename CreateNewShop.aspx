<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="CreateNewShop.aspx.cs" Inherits="PSIC.CreateNewShop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Create New Shop');

            LoadShops();
            getDistt();
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



            $('#ddDistt').bind('change', getTehsil);

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




            $('#btnSave').bind('click', function () {

                if ($('#txtShopName').val().trim() == "") {
                    alert('Please Enter Shop Name.');
                    return;
                }

                
                if ($('#btnSave').attr('tag') == undefined) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "CreateNewShop.aspx/SaveShop",
                        data: "{ 'Name' : '" + $('#txtShopName').val().trim() + "', 'TehsilId' : '" + $('#ddTeh').val() + "', 'GPS' : '" + $('#txtGPS').val() + "', 'Address' : '" + $('#txtAddress').val() + "' }",
                        success: function (response) {
                            $('#txtShopName').val('');
                            $('#txtGPS').val('');
                            $('#txtAddress').val('');
                            LoadShops();
                            alert('Save Successfully!');
                        }
                    });
                } else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "CreateNewShop.aspx/UpdateShop",
                        data: "{ 'ID' : '" + $(this).attr('tag') + "', 'Name' : '" + $('#txtShopName').val().trim() + "', 'TehsilId' : '" + $('#ddTeh').val() + "', 'GPS' : '" + $('#txtGPS').val() + "', 'Address' : '" + $('#txtAddress').val() + "' }",
                        success: function (response) {
                            $('#txtShopName').val('');
                            $('#txtGPS').val('');
                            $('#txtAddress').val('');
                            $('#btnSave').removeAttr('tag');
                            $('#btnSave').val('Save');
                            LoadShops();
                            alert('Updated Successfully!');
                        }
                    });
                }
            });


            function LoadShops()
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "CreateNewShop.aspx/LoadShops",
                    data: "{}",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.ShopName + ' </td><td  style="text-align : left;"> ' + item.DistrictName + ' </td><td  style="text-align : left;"> ' + item.TehsilName + ' </td><td  style="text-align : left;"> ' + item.ShopAddress + ' </td><td> <img src="Images/EditInfo.png" tehsil="' + item.ShopTehsilID + '" dist="' + item.ShopDistID + '" tag="' + item.ShopID + '" class="EditInfo" style="width:20px; height : 20px;" /> <img src="Images/delete.png" tehsil="' + item.ShopTehsilID + '" dist="' + item.ShopDistID + '" tag="' + item.ShopID + '" class="DeleteDesignation" style="width:20px; height : 20px;" /></td></tr>';
                            });
                            $('#tbShops tbody').html(Out);
                        } catch (e) {
                            alert(e.message);
                        }
                        
                    }
                });

            }

            $('body').on({
                click: function () {
                    $("#txtShopName").val($(this).parent().prev().prev().prev().prev().html());
                    $("#ddDistt").val($(this).parent().prev().prev().prev().html());
                    $("#ddTeh").val($(this).parent().prev().prev().html());
                    $("#txtAddress").val($(this).parent().prev().html());
                    
                    
                    $('#btnSave').attr('tag', $(this).attr('tag'));
                    $('#btnSave').val('Update');
                }
            }, ".EditInfo");



            $('body').on({
                click: function () {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "CreateNewShop.aspx/DeleteShop",
                        data: "{ 'ID' : '" + $(this).attr('tag') + "' }",
                        success: function (responseText) {
                            var jData = $.parseJSON(responseText.d);
                            if (jData[0].Result == 'No') {
                                alert('Cannot delete shop.');
                            }
                            else {
                                alert('Shop deleted successfully.');
                                LoadShops();
                            }
                        }
                    });
                }
            }, ".DeleteDesignation");

        });
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
                            LoadTargetMap(ss);

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
                           LoadTargetMap(ss);
                       }
                       else {
                           ss = "30.3894007, 69.3532207".split(', ');
                           LoadTargetMap(ss);
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
                        <span>Create New Shop</span>
                    </h4>
                    <a href="dvNewShop" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewShop">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Shop Name : </label>
                                <input id="txtShopName" type="text" class="span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Shop In : </label>
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
                                                    <select id="ddTeh" class="vl frmCtrl nostyle"> </select>
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
                                <input id="txtGPS" class="span4" style="width: 295px;" type="text" title="Click on this and get Map" />
                            </div>
                        </div>

                         <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal">Address : </label>
                                <textarea rows="2" cols="5" class="span4" id="txtAddress" style="width : 615px; height : 80px;"></textarea>
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
                        <span>All Shops</span>
                    </h4>
                    <a href="dvAllShops" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvAllShops">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbShops" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 20px;">Sr.No
                                            </th>
                                            <th>Shop Name
                                            </th>
                                            <th>District
                                            </th>
                                            <th>Tehsil
                                            </th>
                                            <th>
                                                Address
                                            </th>
                                            <th>
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
