<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="Designations.aspx.cs" Inherits="PSIC.Designations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript" src="Scripts/jquery.mask.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            $('.heading h3').html("Designations Registration");

            
            AllDesignation();

            $('#btnSave').bind('click', function () {
                if ($('#txtDesignation').val() == "") {
                    alert("Please enter designation...");
                    return false;
                }

                if ($('#btnSave').attr('tag') == undefined) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Designations.aspx/SaveData",
                        data: "{'designation':'" + $('#txtDesignation').val() + "', 'detail':'" + $('#txtDetail').val() + "'   , 'Highermanagement':'" + $('#ddlHighermanagement').val() + "'  }",
                        context: document.body,
                        success: function (responseText) {
                            if (responseText.d != "") {
                                alert("Save Successfully!");
                                $("#txtDesignation").val('');
                                $("#txtDetail").val('');

                                AllDesignation();
                            }

                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Designations.aspx/UpdateData",
                        data: "{'designation':'" + $('#txtDesignation').val() + "', 'detail':'" + $('#txtDetail').val() + "' , 'DesignationID':'" + $('#btnSave').attr('tag') + "'  , 'Highermanagement':'" + $('#ddlHighermanagement').val() + "'}",
                        context: document.body,
                        success: function (responseText) {
                            alert("Save Successfully!");
                            $("#txtDesignation").val('');
                            $("#txtDetail").val('');
                            $('#btnSave').removeAttr('tag');
                            AllDesignation();

                        }
                    });
                }

            });


            function AllDesignation() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Designations.aspx/AllDesignation",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<tr> <td> ' + item.srno + '</td> <td> ' + item.Designation + '</td> <td> ' + item.DesignationDetail + '</td>    <td tag="' + item.HMID + '"> ' + item.HigherManagment + '</td>     <td> <img src="Images/EditInfo.png" tag="' + item.DesignationID + '" class="EditInfo" style="width:20px; height : 20px;" /> <img src="Images/delete.png" tag="' + item.DesignationID + '" class="DeleteDesignation" style="width:20px; height : 20px;" /></td></tr>';
                        });

                        $('#tbDesignation tbody').html(out);
                        $('#tbDesignation').show();
                    }
                });
            }

            $('body').on({
                click: function () {
                    $("#txtDetail").val($(this).parent().prev().prev().html());
                    $("#txtDesignation").val($(this).parent().prev().prev().prev().html());
                    
                    var strHM = "";
                    strHM = $(this).parent().prev().attr('tag');
                    
                    if (strHM == 'true') {
                        $("#ddlHighermanagement").val("1");
                        $("#ddlHighermanagement").prev().html('Yes');
                    }
                    else {
                        $("#ddlHighermanagement").val("0");
                        $("#ddlHighermanagement").prev().html('No');
                    }

                    $('#btnSave').attr('tag', $(this).attr('tag'));
                    $('#btnSave').val('Update');
                }
            }, ".EditInfo");



            $('body').on({
                click: function () {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "Designations.aspx/DeleteDesignation",
                        data: "{ 'ID' : '" + $(this).attr('tag') + "' }",
                        success: function (responseText) {
                            var jData = $.parseJSON(responseText.d);
                            if (jData[0].Result == 'No') {
                                alert('Cannot delete designation.');
                            }
                            else {
                                alert('Designation deleted successfully.');
                                AllDesignation();
                            }
                        }
                    });
                }
            }, ".DeleteDesignation");
        });
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Designation Registration</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Designation</label>
                                <input id="txtDesignation" type="text" class="txtcs frmCtrl span4" title="New Designation Name" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Higher Management</label>
                                <div style="margin-left : 0px;" class="span4">
                                    <select id="ddlHighermanagement">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Detail</label>
                                <textarea id="txtDetail" cols="20" rows="2" style="height: 95px;" class="txtcs frmCtrl span4" title="Detail of designation if any."></textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button id="btnSave" type="button" class="btn btn-primary">Save</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>



    <div class="row-fluid">
        <div class="spdan12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>All Registered Designations</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbDesignation" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Sr No
                                            </th>
                                            <th>Designation
                                            </th>
                                            <th>Detail
                                            </th>
                                            <th>Higher Management
                                            </th>
                                            <th></th>
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
