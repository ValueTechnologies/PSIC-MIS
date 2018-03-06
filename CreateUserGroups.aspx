<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="CreateUserGroups.aspx.cs" Inherits="PSIC.CreateUserGroups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Create User Groups');


            AllGroups();
            
            $('#btnSave').bind('click', function () {

                if ($('#btnSave').attr('tag') == 0) {
                    var ctrlVals = "";
                    $('.frmCtrl').each(function (index, element) {
                        ctrlVals += $(this).val() + '½';
                    });

                    if ($("#txtGroupName").val('') == "") {
                        return false;
                    }
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "CreateUserGroups.aspx/SaveData",
                        data: "{'Values':'" + ctrlVals + "'}",
                        context: document.body,
                        success: function (responseText) {
                            alert("Save Successfully!");
                            $("#txtGroupName").val('');
                            $("#txtGroupDescription").val('');
                            $("#txtPriority").val('');
                            $('#btnSave').attr('tag', '0');
                            AllGroups();
                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "CreateUserGroups.aspx/UpdateData",
                        data: "{'GroupName':'" + $("#txtGroupName").val() + "', 'GroupDesc':'" + $("#txtGroupDescription").val() + "', 'GroupId' : '" + $('#btnSave').attr('tag') + "', 'Priority':'" + $("#txtPriority").val() + "'}",
                        context: document.body,
                        success: function (responseText) {
                            alert("Save Successfully!");
                            $("#txtGroupName").val('');
                            $("#txtGroupDescription").val('');
                            $("#txtPriority").val('');
                            $('#btnSave').attr('tag', '0');
                            AllGroups();
                        }
                    });
                }
            });



            function AllGroups() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "CreateUserGroups.aspx/AllGroups",
                    data: " {}",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<tr> <td  style="text-align:left;"> ' + item.srno + '</td> <td  style="text-align:left;"> ' + item.User_Group_Name + '</td>  <td  style="text-align:left;"> ' + item.Description + '</td>       <td> <button tag = "' + item.User_Group_Id + '" type="button" class="btn btn-link EditGroup"> Edit</button> </td></tr>';
                        });
                        $('#tbUserGroups tbody').html(out);
                    }
                });
            }

            $('#ddlCompany').bind('change', function () {

                AllGroups();
            });

            $('body').on({
                click: function () {
                    $('#txtGroupName').val($(this).parent().prev().prev().html());
                    $('#txtGroupDescription').val($(this).parent().prev().html());
                    $('#btnSave').attr('tag', $(this).attr('tag'));
                }
            }, ".EditGroup");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create Groups</span>
                    </h4>
                    <a href="dvCreateGroups" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvCreateGroups">

                    <form class="form-horizontal" action="#">


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Group Name</label>
                                <input id="txtGroupName" type="text" class="frmCtrl span4" title="New Group name" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Group Description</label>
                                <input id="txtGroupDescription" type="text" class="frmCtrl span4" title="New Group Description" />
                            </div>
                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal"></label>
                                <button id="btnSave" tag="0" type="button" class="btn btn-primary">Save</button>
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
                        <span>All Groups</span>
                    </h4>
                    <a href="dvAllGroups" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvAllGroups">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbUserGroups" class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Sr.#
                                            </th>
                                            <th>Group Name
                                            </th>
                                            <th>Discription
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
