<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="DepartmentRegistration.aspx.cs" Inherits="PSIC.DepartmentRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <script type="text/javascript">
        $(document).ready(function () {
            $('.heading h3').html("Department Registration");

            AllDepartment();

           
            $('#btnSave').bind('click', function () {
                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "DepartmentRegistration.aspx/SaveData",
                    data: "{'Values':'" + ctrlVals + "'}",
                    context: document.body,
                    success: function (responseText) {
                        alert("Save Successfully!");
                        $("#txtDepartment").val('');
                        $("#txtPhone").val('');
                        AllDepartment();
                    }
                });
            });
            
            function AllDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "DepartmentRegistration.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<tr><td  style="text-align:left;"> ' + item.Srno + '</td> <td  style="text-align:left;"> ' + item.DepartmentName + '</td> <td  style="text-align:left;"> ' + item.DepartmentPhoneNo + '</td> <td style="text-align:left;">' + item.CurrentlyWorking + ' </td></tr>';
                        });
                        $('#tbDepartments tbody').html(out);
                        $('#tbDepartments').show();
                    }
                });
            }
        });
    </script>


    <style type="text/css">
        .txtcs {
            width: 200px;
        }

        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Department Registration</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Department</label>
                                        <input id="txtDepartment" type="text" class="txtcs frmCtrl span4" title="New Department name" />
                                    </div>
                                </div>

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Phone #</label>
                                        <input id="txtPhone" type="text" class="txtcs frmCtrl span4" title="Official Phone number" />
                                    </div>
                                </div>


                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal">Currently Working?</label>
                                        <div class="span4" style="margin-left:0px;">
                                            <select id="ddlCurruentlyWorking" class="txtcs frmCtrl" title="Is Currently Working?">
                                                <option value="1">Yes</option>
                                                <option value="0">No</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <label class="form-label span3" for="normal"></label>
                                         <button id="btnSave" type="button" value="Save" class="btn btn-primary">Save</button>
                                        
                                    </div>
                                </div>




                                <%--***********************--%>
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
                        <span>All Registered Department</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <table id="tbDepartments" class="responsive table table-striped table-bordered table-condensed">
                                            <thead>
                                                <tr>
                                                    <th>Sr.No
                                                    </th>
                                                    <th>Department
                                                    </th>
                                                    <th>Phone No
                                                    </th>
                                                    <th>Currently working
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
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
