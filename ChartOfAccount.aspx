<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="ChartOfAccount.aspx.cs" Inherits="PSIC.ChartOfAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    
    <script type="text/javascript" src="js/jquery.treeview.js"></script>
    <link href="css/jquery.treeview.css" rel="stylesheet" />
    <link href="css/screen.css" rel="stylesheet" />


    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Chart Of Account');
            $('#dvAddNewHead').dialog({ autoOpen: false, width: "45%", modal: true });
            $('#dvEditHead').dialog({ autoOpen: false, width: "45%", modal: true });

            LoadChartOfAccount();
            function LoadChartOfAccount() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChartOfAccount.aspx/DisplayChartOfAccount",
                    data: "{}",
                    success: function (response) {
                        $('#tree').html(response.d);
                        $("#tree").treeview({
                            collapsed: true,
                            animated: "medium",
                            control: "#sidetreecontrol",
                            persist: "location"
                        });
                    }
                });
            }


            $('#btnSaveNewHead').bind('click', function () {
                if ($('#txtNewHeadCode').val().trim() == "") {
                    alert('Please enter code...');
                    return;
                }
                if ($('#txtNewHeadName').val().trim() == "") {
                    alert('Please enter head name...');
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChartOfAccount.aspx/SaveNewHead",
                    data: "{ 'ParentID' : '" + $('#btnSaveNewHead').attr('tag') + "', 'Code' : '" + $('#txtNewHeadCode').val().trim() + "', 'Name' : '" + $('#txtNewHeadName').val().trim() + "', 'Level' : '" + $('#txtNewHeadCode').attr('tag').trim() + "', 'HeadType' : '" + $('#ddlNewHeadType').val() + "'}",
                    success: function (response) {
                        LoadChartOfAccount();
                        $('#dvAddNewHead').dialog('close');
                        $('#btnSaveNewHead').removeAttr('tag');
                        $('#txtNewHeadCode').removeAttr('tag');
                        $('#txtNewHeadCode').val('');
                        $('#txtNewHeadName').val('');

                    }
                });
            });


            $('#btnUpdateHead').bind('click', function () {
                if ($('#txtEditHeadName').val().trim() == "") {
                    alert('Please enter Head Name...');
                    return;
                }


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChartOfAccount.aspx/UpdateHead",
                    data: "{ 'AccountID' : '" + $('#btnUpdateHead').attr('tag') + "', 'HeadName' : '" + $('#txtEditHeadName').val().trim() + "', 'HeadType' : '" + $('#ddlEditHeadType').val() + "'}",
                    success: function (response) {
                        LoadChartOfAccount();
                        $('#dvEditHead').dialog('close');
                        $('#txtEditHeadName').val('');

                    }
                });
            });




        });
        //end ready

        $('body').on({
            click: function () {
                $('#dvAddNewHead').dialog('open');
                $('#btnSaveNewHead').attr('tag', $(this).attr('tag'));
                $('#txtNewHeadCode').attr('tag', $(this).attr('level'));

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChartOfAccount.aspx/GetNewCode",
                    data: "{ 'parentID' : '" + $(this).attr('tag') + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#txtNewHeadCode').val(jData[0].NewCode);
                    }
                });
            }
        }, '.clsAddNewNode');




        $('body').on({
            click: function () {
                $('#dvEditHead').dialog('open');
                $('#btnUpdateHead').attr('tag', $(this).attr('tag'));



                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ChartOfAccount.aspx/GetHeadType",
                    data: "{ 'AccountID' : '" + $(this).attr('tag') + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#ddlEditHeadType').val(jData[0].ISEntryLevel);
                        $("#ddlEditHeadType").prev().html($("#ddlEditHeadType option:selected").text());
                        $('#txtEditHeadCode').val(jData[0].AccountCode);
                        $('#txtEditHeadName').val(jData[0].HeadName);
                    }
                });
            }
        }, '.clsEditNode');




    </script>

    <style type="text/css">
        .clsAddNewNode {
            width: 15px;
        }

        .clsEditNode {
            width: 15px;
            margin-left: 15px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="dvAddNewHead" title="Add New Account Head">
        <table>
            <tr>
                <td style="width: 70px;">Head Code
                </td>
                <td>
                    <input type="text" id="txtNewHeadCode" disabled="disabled" />
                </td>
            </tr>
            <tr>
                <td>Head name
                </td>
                <td>
                    <input type="text" id="txtNewHeadName" />
                </td>
            </tr>
            <tr>
                <td>Head Type
                </td>
                <td>
                    <div>
                        <select id="ddlNewHeadType">
                            <option value="0">Head Level</option>
                            <option value="1">Entry Level</option>
                        </select>

                    </div>

                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <div style="margin-top: 10px;">
                        <button type="button" class="btn btn-primary" id="btnSaveNewHead">Save</button>
                    </div>

                </td>
            </tr>
        </table>
    </div>


    <div id="dvEditHead" title="Edit Account Head">
        <table>
            <tr>
                <td style="width: 70px;">Head Code
                </td>
                <td>
                    <input type="text" id="txtEditHeadCode" disabled="disabled" />
                </td>
            </tr>
            <tr>
                <td>Head name
                </td>
                <td>
                    <input type="text" id="txtEditHeadName" />
                </td>
            </tr>
            <tr>
                <td>Head Type
                </td>
                <td>
                    <div>
                        <select id="ddlEditHeadType">
                            <option value="0">Head Level</option>
                            <option value="1">Entry Level</option>
                        </select>

                    </div>

                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <div style="margin-top: 10px;">
                        <button type="button" class="btn btn-primary" id="btnUpdateHead">Save</button>
                    </div>

                </td>
            </tr>
        </table>
    </div>



    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Chart Of Account</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div style="margin-left: 2%;">
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 70%;">
                                        <div id="sidetree">
                                            <div class="treeheader">&nbsp;</div>
                                            <div id="sidetreecontrol"><a href="?#">Collapse All</a> | <a href="?#">Expand All</a></div>
                                            <ul id="tree">
                                            </ul>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
