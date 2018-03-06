<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSSupplierRegistration.aspx.cs" Inherits="PSIC.POSSupplierRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Supplier Registration');
            $('#dvSupplierCompany').dialog({ autoOpen: false, width: "45%", modal: true });
            LoadSupplierCompany();
            


            $('#btnAddNewCompany').bind('click', function (e) {
                e.preventDefault();
                $('#dvSupplierCompany').dialog("open");
            });


            $('#btnSaveCompany').bind('click', function () {
                if ($('#txtNewCompanyName').val().trim() == "") {
                    alert('Please enter Company Name...');
                    return;
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSupplierRegistration.aspx/SaveCompany",
                    data: "{ 'CompanyName' : '" + $('#txtNewCompanyName').val().trim() + "'}",
                    success: function (response) {
                        alert('Save Successfully!');
                        $('#dvSupplierCompany').dialog("close");
                        $('#txtNewCompanyName').val('');
                        LoadSupplierCompany();
                    }
                });
            });


            $('#btnSaveSupplier').bind('click', function () {
                var vals = "";
                if ($('#txtName').val() == "") {
                    alert("Please enter name....");
                    return;
                }


                if ($('#txtCell').val() == "") {
                    alert("Please enter Cell #....");
                    return;
                }


                $('.frmCtrl').each(function (i, item) {
                    vals = vals + $(this).val() + '§';
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSupplierRegistration.aspx/SaveSupplier",
                    data: "{ 'Vals' : '" + vals + "'}",
                    success: function (response) {
                        alert('Save Sucessfully!');
                        $('.frmCtrl').each(function (i, item) {
                            $(this).val('');
                        });
                        LoadSupplier();
                    }
                });
            });

            function LoadSupplierCompany() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSupplierRegistration.aspx/GetSupplierCompanyList",
                    data: "{ }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                Out = Out + '<option value="' + item.SupplierCompanyID + '"> ' + item.SupplierCompanyName + '</option>';
                            });
                            $('#ddlSupplierCompany').html(Out);
                            LoadSupplier();
                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

            $('#ddlSupplierCompany').change(LoadSupplier);
            function LoadSupplier() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSSupplierRegistration.aspx/GetSuppliersFromCompany",
                    data: "{ 'CompanyID' : '" + $('#ddlSupplierCompany').val() + "' }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";
                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td> ' + item.TypeOfSupplier + '</td><td style="text-align : left;"> ' + item.Name + ' </td>  <td style="text-align : left;"> ' + item.CellNo + ' </td><td style="text-align : left;"> ' + item.AlternateContact + ' </td><td> ' + item.EmailID + ' </td><td> ' + item.NTN + ' </td><td> ' + item.CNIC + ' </td><td> ' + item.GST + ' </td><td> ' + item.Address + ' </td><td> ' + item.Remaks + ' </td></tr>';
                            });
                            $('#tbAllSuppliers tbody').html(Out);
                        } catch (e) {
                            alert(e.message);
                        }

                    }
                });
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="dvSupplierCompany" title="Add New Company">
        <table>
            <tr>
                <td style="width: 100px;">Company 
                </td>
                <td>
                    <input id="txtNewCompanyName" type="text" class="span5" />
                </td>
            </tr>

            <tr>
                <td style="width: 100px;"></td>
                <td>
                    <button type="button" class="btn btn-primary" id="btnSaveCompany">Save</button>
                </td>
            </tr>
        </table>
    </div>



    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create New Supplier</span>
                    </h4>
                    <a href="dvNewSupplier" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewSupplier">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Company : </label>
                                <div class="span4 controls sel">
                                    <select class="nostyle frmCtrl" id="ddlSupplierCompany">
                                    </select>
                                </div>

                                <button class="btn btn-info span2" id="btnAddNewCompany">Add New</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Type of Supplier : </label>
                                <div class="span4 controls sel">
                                    <select class="nostyle frmCtrl" id="ddlTypeOfSupplier">
                                        <option >Supplier</option>
                                        <option >Manufacturer</option>
                                    </select>
                                </div>

                            </div>
                        </div>




                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Name : </label>
                                <input id="txtName" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Cell # : </label>
                                <input id="txtCell" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Alternate Contact # : </label>
                                <input id="txtCellAlternate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Email ID : </label>
                                <input id="txtEmailID" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">NTN : </label>
                                <input id="txtNTN" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">CNIC : </label>
                                <input id="txtCNIC" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">GST : </label>
                                <input id="txtGST" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Address : </label>
                                <input id="txtAddress" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Remaks : </label>
                                <input id="txtAmount" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSaveSupplier" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbAllSuppliers" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo
                                            </th>
                                            <th>Type Of Supplier
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>Cell #
                                            </th>
                                            <th>Alternate Contact
                                            </th>
                                            <th>Email
                                            </th>
                                            <th>NTN
                                            </th>
                                            <th>CNIC
                                            </th>
                                            <th>GST
                                            </th>
                                            <th>Address
                                            </th>
                                            <th>Remaks
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
