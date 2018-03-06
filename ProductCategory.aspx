<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="ProductCategory.aspx.cs" Inherits="PSIC.ProductCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Categories and Sub Categories');
            LoadCategories();



            $('#btnSaveCategory').bind('click', function () {
                if ($('#txtCategory').val().trim() == "") {
                    alert('Please enter category...');
                    return;
                }

                if ($('#btnSaveCategory').attr('tag') == undefined) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "ProductCategory.aspx/SaveCategory",
                        data: "{ 'Category' : '" + $('#txtCategory').val() + "'}",
                        success: function (response) {
                            alert('Save Sucessfully!');
                            $('#btnSaveCategory').removeAttr('tag');
                            $('#txtCategory').val('');
                            LoadCategories();
                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "ProductCategory.aspx/UpdateCategory",
                        data: "{ 'Category' : '" + $('#txtCategory').val() + "', 'CategoryID' : '" + $('#btnSaveCategory').attr('tag') + "'}",
                        success: function (response) {
                            alert('Save Sucessfully!');
                            $('#btnSaveCategory').removeAttr('tag');
                            $('#txtCategory').val('');
                            LoadCategories();
                        }
                    });
                }


                
            });

            function LoadCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ProductCategory.aspx/GetCategories",
                    data: "{ }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.Category + ' </td><td  style="text-align : left;"> <button tag="' + item.CategoryID + '" type="button" class="btn btn-link clsCategory"> Edit</button>    </td></tr>';
                                OutDDL = OutDDL + '<option value="' + item.CategoryID + '">' + item.Category + '</option>';
                            });
                            $('#tbAllCategories tbody').html(Out);
                            $('#ddlCategories').html(OutDDL);
                            LoadSubCategories();

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }


            $('#btnSaveSubCategory').bind('click', function () {
                if ($('#txtSubCategory').val().trim() == "") {
                    alert('Please enter sub category...');
                    return;
                }

                if ($('#btnSaveSubCategory').attr('tag') == undefined) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "ProductCategory.aspx/SaveSubCategory",
                        data: "{ 'CategoryID' : '" + $('#ddlCategories').val() + "', 'SubCategory' : '" + $('#txtSubCategory').val() + "'}",
                        success: function (response) {
                            alert('Save Sucessfully!');
                            $('#btnSaveSubCategory').removeAttr('tag');
                            $('#txtSubCategory').val('');
                            LoadSubCategories();
                        }
                    });
                }
                else {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "ProductCategory.aspx/UpdateSubCategory",
                        data: "{ 'CategoryID' : '" + $('#ddlCategories').val() + "', 'SubCategory' : '" + $('#txtSubCategory').val() + "', 'SubCategoryID' : '" + $('#btnSaveSubCategory').attr('tag') + "'}",
                        success: function (response) {
                            alert('Save Sucessfully!');
                            $('#btnSaveSubCategory').removeAttr('tag');
                            $('#txtSubCategory').val('');
                            LoadSubCategories();
                        }
                    });
                }



            });

            $('#ddlCategories').bind('change', LoadSubCategories);

            function LoadSubCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "ProductCategory.aspx/GetSubCategories",
                    data: "{ 'CatID' : '" + $('#ddlCategories').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.SubCategory + ' </td><td  style="text-align : left;"> <button tag="' + item.SubCategoryID + '" type="button" class="btn btn-link clsSubCategory"> Edit</button>    </td></tr>';
                               
                            });
                            $('#tbAllSubCategories tbody').html(Out);

                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

        });

        //End ready


        $('body').on({
            click: function () {
                $('#txtCategory').val($(this).parent().prev().html());
                $('#btnSaveCategory').attr('tag', $(this).attr('tag'));
            }
        }, '.clsCategory');

        $('body').on({
            click: function () {
                $('#txtSubCategory').val($(this).parent().prev().html());
                $('#btnSaveSubCategory').attr('tag', $(this).attr('tag'));
            }
        }, '.clsSubCategory');


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create New Category</span>
                    </h4>
                    <a href="dvNewCategory" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewCategory">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Category : </label>
                                <input id="txtCategory" type="text" class="span4" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSaveCategory" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbAllCategories" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo
                                            </th>
                                            <th>Category
                                            </th>
                                            <th style="width: 50px;">Edit
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
                        <span>Create New Sub Category</span>
                    </h4>
                    <a href="dvNewSubCategory" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewSubCategory">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Category : </label>
                                <div class="controls sel span4">
                                    <select class="nostyle" id="ddlCategories">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Sub Category : </label>
                                <input id="txtSubCategory" type="text" class="span4" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSaveSubCategory" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbAllSubCategories" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo
                                            </th>
                                            <th>Sub Category
                                            </th>
                                            <th style="width: 50px;">Edit
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
