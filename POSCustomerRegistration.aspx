<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="POSCustomerRegistration.aspx.cs" Inherits="PSIC.POSCustomerRegistration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html('Customer Registration');
            $('.clsMembership').hide();

            $('#txtStartingDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtEndingDate').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            LoadCustomer();


            $('#ddlHasMembership').change(function () {
                if ($('#ddlHasMembership').val() == "1") {
                    $('.clsMembership').show();
                }
                else {
                    $('.clsMembership').hide();
                }
            });



            $('#btnSaveCustomer').bind('click', function () {
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
                    url: "POSCustomerRegistration.aspx/SaveCustomer",
                    data: "{ 'vals' : '" + vals + "'}",
                    success: function (response) {
                        alert('Save Sucessfully!');
                        $('.frmCtrl').each(function (i, item) {
                            $(this).val('');
                        });
                        LoadCustomer();
                    }
                });


            });



            function LoadCustomer() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "POSCustomerRegistration.aspx/GetCustomer",
                    data: "{ }",
                    success: function (response) {
                        try {
                            var jData = $.parseJSON(response.d), Out = "", OutDDL = "";

                            $.each(jData, function (i, item) {
                                Out = Out + '<tr><td> ' + item.Srno + '</td><td style="text-align : left;"> ' + item.Name + ' </td>  <td style="text-align : left;"> ' + item.CellNo + ' </td><td style="text-align : left;"> ' + item.Address + ' </td><td> ' + item.HasMembership + ' </td><td> ' + item.MembershipType + ' </td><td> ' + item.Amount + ' </td><td> ' + item.StartingDate + ' </td>   <td> ' + item.EndingDate + ' </td> </tr>';
                                
                            });
                            $('#tbAllCustomers tbody').html(Out);
                            

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

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Create New Customer</span>
                    </h4>
                    <a href="dvNewCustomer" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewCustomer">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Name : </label>
                                <input id="txtName" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Cell# : </label>
                                <input id="txtCell" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Address : </label>
                                <input id="txtAddress" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                       <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Membership : </label>
                                <div class="controls sel">
                                    <select class="nostyle span4 frmCtrl" id="ddlHasMembership">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Membership Type : </label>
                                <div class="controls sel">
                                    <select class="nostyle span4 frmCtrl" id="ddlMembershipType">
                                        <option value="Public">Public</option>
                                        <option value="Employee">Employee</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Membership Amount : </label>
                                <input id="txtAmount" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Starting Date : </label>
                                <input id="txtStartingDate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid clsMembership">
                            <div class="span12">
                                <label class="form-label span3" style="margin-top: 9px;" for="normal">Ending Date : </label>
                                <input id="txtEndingDate" type="text" class="span4 frmCtrl" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <label class="form-label span3" for="normal"></label>
                                <button type="button" id="btnSaveCustomer" class="btn btn-primary span2" style="margin-left: 0px;">Save</button>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12" style="margin-left: 0px;">
                                <table id="tbAllCustomers" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>Cell #
                                            </th>
                                            <th>Address
                                            </th>
                                            <th>Has Membership
                                            </th>
                                            <th>Type
                                            </th>
                                            <th>Amount
                                            </th>
                                            <th>Starting Date
                                            </th>
                                            <th>Ending Date
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
