<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EmployeeRegistration.aspx.cs" Inherits="PSIC.EmployeeRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvw').attr('src', e.target.result);
                    $('#dvImage').slideDown(2000);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }




        $(document).ready(function () {
            $('.heading h3').html('Employee Registration');

            $(function () {
                $("#txtDOB").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $("#txtAppointmentDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $("#txtResignationDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $("#txtRelationDOB").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });


            $(function () {
                $("#txtContractStartingDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });

            $(function () {
                $("#txtContractEndingDate").datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            });



            //Add Years

            var Years;
            for (var i = new Date().getFullYear() ; i > 1947; i--) {
                Years += '<option> ' + i + ' </option>';
            }

            $('#DegreeYearFrom').html(Years);
            $("#DegreeYearFrom").prev().html($("#DegreeYearFrom option:selected").text());

            $('#DegreeYearTo').html(Years);
            $("#DegreeYearTo").prev().html($("#DegreeYearTo option:selected").text());

            //Load Department
            LoadDepartment();
            function LoadDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeeRegistration.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DepartmentID + '> ' + item.DepartmentName + '</option>';
                        });
                        $('#ddlDept').html(out);
                        $("#ddlDept").prev().html($("#ddlDept option:selected").text());

                        $('#ddDeptFrom').html(out);
                        $("#ddDeptFrom").prev().html($("#ddDeptFrom option:selected").text());
                    }
                });
            }


            //Load Designation
            LoadDesignation();
            function LoadDesignation() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeeRegistration.aspx/AllDesignations",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DesignationID + '> ' + item.Designation + '</option>';
                        });
                        $('#ddlDesignation').html(out);
                        $("#ddlDesignation").prev().html($("#ddlDesignation option:selected").text());


                        $('#ddDesigFrom').html(out);
                        $("#ddDesigFrom").prev().html($("#ddDesigFrom option:selected").text());
                    }
                });
            }


            //Load User Group
            LoadUserGroups();
            function LoadUserGroups() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeeRegistration.aspx/AllUserGroups",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.User_Group_Id + '> ' + item.User_Group_Name + '</option>';
                        });
                        $('#ddlGroup').html(out);
                        $("#ddlGroup").prev().html($("#ddlGroup option:selected").text());
                    }
                });
            }


            ///Posting From 

            getDisttF();
            function getDisttF() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/getlocDistrict",
                    data: "{}",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                        });
                        $('#ddDisttFrom').html(out);
                        $('#ddDisttFrom').prev().html($('#ddDisttFrom option:selected').text());
                        getTehsilF();
                    }
                });
            }
            $("#ddDisttFrom").bind('change', function (e) { getTehsilF(); });
            function getTehsilF() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/getlocTehsil",
                    data: "{'TypeID':'" + $('#ddDisttFrom').val() + "'}",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value="' + item.LocID + '">' + item.LocName + '</option>';
                        });
                        $('#ddTehFrom').html(out);
                        $('#ddTehFrom').prev().html($('#ddTehFrom option:selected').text());

                    }
                });
            }

            //posting From end



            //add new Family Info.
            $('#AddRelation').bind('click', function () {
                var rowNumber = 1;
                $('.clsFamilyInfo').each(function (i, obj) {
                    rowNumber = (i + 2);
                });

                var str;
                str = '<tr><td>' + rowNumber + '</td><td>' + $('#Relations').val() + '</td><td>' + $('#txtRelationName').val() + '</td><td>' + $('#txtRelationDOB').val() + '</td><td> <img class="clsFamilyInfo" src="Images/cross_circle.png" /></td></tr>';
                $('#tbFamilyInfo').append(str);
                $('#txtRelationName').val('');
                $('#txtRelationDOB').val('');


            });


            //add new degree info.
            $('#AddDegree').bind('click', function () {
                var rowNumber = 1;
                $('.clsDegreeInfo').each(function (i, obj) {
                    rowNumber = (i + 2);
                });

                var str;
                str = '<tr><td>' + rowNumber + '</td><td>' + $('#txtDegree').val() + '</td><td>' + $('#txtInstitute').val() + '</td><td>' + $('#DegreeYearFrom').val() + '</td><td>' + $('#DegreeYearTo').val() + '</td><td> <img class="clsDegreeInfo" src="Images/cross_circle.png" /></td></tr>';
                $('#tbDegreeInfo').append(str);
                $('#txtDegree').val('');
                $('#txtInstitute').val('');


            });


            //Save Data

            $('#btnSave').bind('click', function (event) {
                $("*").css("cursor", "wait");
                if ($('#txtName').val().trim() == "") {
                    alert('Please enter Employee Name...');
                    return false;
                }
                if ($('#txtCNIC').val().trim() == "") {
                    alert('Please enter CNIC...');
                    return false;
                }
                if ($('#txtDOB').val().trim() == "") {
                    alert('Please select DOB...');
                    return false;
                }
                if ($('#txtAppointmentDate').val().trim() == "") {
                    alert('Please select Appointment Date ...');
                    return false;
                }



                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });

                var uploadfiles = $("#photoUpload").get(0);
                var uploadedfiles = uploadfiles.files;
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);
                for (var i = 0; i < uploadedfiles.length; i++) {
                    fromdata.append(uploadedfiles[i].name, uploadedfiles[i]);
                }

                var choice = {};
                choice.url = "EmployeeRegistrationCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {
                    
                    //Save Family Info.
                    var  Relation = [], RelationName = [], DOB = [];
                    $('.clsFamilyInfo').each(function (i, obj) {
                        DOB[i] = $(this).parent().prev().html();
                        RelationName[i] = $(this).parent().prev().prev().html();
                        Relation[i] = $(this).parent().prev().prev().prev().html();
                    });

                    for (var i = 0; i < Relation.length ; i++) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            url: "EmployeeRegistration.aspx/SaveFamilyInfo",
                            data: "{ 'Relation' : '" + Relation[i] + "', 'Name' : '" + RelationName[i] + "', 'DOB' : '" + DOB[i] + "', 'EmpID' : '" + result + "'}",
                            success: function (response) {

                            }
                        });
                    }


                    //Save Degree Info.

                    var Degree = [], Institute = [], FromYear = [], ToYear = [];
                    $('.clsDegreeInfo').each(function (i, obj) {
                        ToYear[i] = $(this).parent().prev().html();
                        FromYear[i] = $(this).parent().prev().prev().html();
                        Institute[i] = $(this).parent().prev().prev().prev().html();
                        Degree[i] = $(this).parent().prev().prev().prev().prev().html();
                    });

                    for (var i = 0; i < Degree.length; i++) {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            url: "EmployeeRegistration.aspx/SaveDegreeInfo",
                            data: "{ 'Degree' : '" + Degree[i] + "', 'Institute' : '" + Institute[i] + "', 'FromYear' : '" + FromYear[i] + "' , 'ToYear' : '" + ToYear[i] + "', 'EmpID' : '" + result + "'}",
                            success: function (response) {

                            }
                        });
                    }


                    //Save Appointment Info.
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        url: "EmployeeRegistration.aspx/SaveAppointmentInfo",
                        data: "{ 'Dist' : '" + $('#ddDisttFrom').val() + "', 'Teh' : '" + $('#ddTehFrom').val() + "', 'Dept' : '" + $('#ddDeptFrom').val() + "', 'Desig' : '" + $('#ddDesigFrom').val() + "' , 'EmpID' : '" + result + "', 'AppintmentDate' : '" + $('#txtAppointmentDate').val() + "', 'EmpType' : '" + $('#ddEmpType').val() + "', 'ContractStart' : '" + $('#txtContractStartingDate').val() + "', 'ContractEnd' : '" + $('#txtContractEndingDate').val() + "'   , 'BPS' : '" + $('#ddlPayscaleAppointment').val() + "'  }",
                        success: function (response) {

                        }
                    });



                    $('#txtContractStartingDate').val('');
                    $('#txtContractEndingDate').val('');
                    $('.clsFamilyInfo').each(function (i, obj) {
                        $(this).parent().parent().remove();
                    });

                    $('.clsDegreeInfo').each(function (i, obj) {
                        $(this).parent().parent().remove();
                    });


                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");
                    $('#btnSave').attr('tag', result);


                    
                    $('.frmCtrl').each(function (index, element) {
                        $(this).val('');
                    });
                    
                    
                    $('.filename').html('');
                };
                choice.error = function (err) {
                    alert(err.statusText);
                    event.preventDefault();
                    $("*").css("cursor", "auto");
                };
                $.ajax(choice);
                event.preventDefault();

            });


            //end save Data


            //Employement type
            $('#ddEmpType').bind('change', function () {
                if ($('#ddEmpType').val() == "2")
                {
                    $('#dvContractDetail').show('slow');
                }
                else {
                    $('#dvContractDetail').hide('slow');
                }
            });



        });



        //Cancel Family Info
        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsFamilyInfo');

        //Cancel Degree Info
        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsDegreeInfo');

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <%--Basic Info--%>
    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Basic Info.</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Employee No</label>
                                <input id="txtEmpNo" type="text" class="txtcs frmCtrl span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">CNIC</label>
                                <input id="txtCNIC" type="text" class="txtcs frmCtrl span7" />

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Name</label>
                                <input id="txtName" type="text" class="txtcs frmCtrl span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Father Name</label>
                                <input id="txtFName" type="text" class="txtcs frmCtrl span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">DOB</label>
                                <input id="txtDOB" type="text" class="txtcs frmCtrl span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Gender</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlGender" class="txtcs frmCtrl">
                                        <option value="1">Male</option>
                                        <option value="0">Female</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">

                            <div class="span6">
                                <label class="form-label span4" for="normal">Current Dept.</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlDept" class="txtcs frmCtrl">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Current Desig.</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlDesignation" class="txtcs frmCtrl">
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">

                            <div class="span6">
                                <label class="form-label span4" for="normal">Group</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlGroup" class="txtcs frmCtrl">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Active</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlActive" class="txtcs frmCtrl">
                                        <option value="1">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Cell #</label>
                                <input id="txtCellNo" type="text" class="txtcs frmCtrl span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Phone #</label>
                                <input id="txtPhoneNo" type="text" class="txtcs frmCtrl span7" />
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Appointment Date</label>
                                <input id="txtAppointmentDate" type="text" class="txtcs frmCtrl span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Resignation Date</label>
                                <input id="txtResignationDate" type="text" class="txtcs frmCtrl span7" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">BPS</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddlPayscale" class="frmCtrl">
                                        <option >BPS 1</option>
                                        <option >BPS 2</option>
                                        <option >BPS 3</option>
                                        <option >BPS 4</option>
                                        <option >BPS 5</option>
                                        <option >BPS 6</option>
                                        <option >BPS 7</option>
                                        <option >BPS 8</option>
                                        <option >BPS 9</option>
                                        <option >BPS 10</option>
                                        <option >BPS 11</option>
                                        <option >BPS 12</option>
                                        <option >BPS 13</option>
                                        <option >BPS 14</option>
                                        <option >BPS 15</option>
                                        <option >BPS 16</option>
                                        <option >BPS 17</option>
                                        <option >BPS 18</option>
                                        <option >BPS 19</option>
                                        <option >BPS 20</option>
                                        <option >BPS 21</option>
                                        <option >BPS 22</option>
                                        <option >BPS Special</option>
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Appointment Letter #</label>
                                <input id="txtAppointmentLetterNo" type="text" class="txtcs frmCtrl span7" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Present Address</label>
                                <textarea id="txtPresentAddress" cols="20" rows="2" class="txtcs frmCtrl span7"></textarea>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Permanent Address</label>
                                <textarea id="txtPermanentAddress" cols="20" rows="2" class="txtcs frmCtrl span7"></textarea>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Photo</label>
                                <input id="photoUpload" type="file" onchange="showimagepreview(this);" />
                            </div>
                        </div>

                        <div class="form-row row-fluid" id="dvImage" style="display: none;">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <img alt="" src="" id="imgprvw" style="width: 150px; height: 150px;" />
                            </div>
                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>



    <%--Family Info--%>
    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Family Info.</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Relation</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="Relations">
                                        <option>Father</option>
                                        <option>Mother</option>
                                        <option>Brother</option>
                                        <option>Sister</option>
                                        <option>Son</option>
                                        <option>Daughter</option>
                                        <option>Wife</option>
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Name</label>
                                <input id="txtRelationName" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">DOB</label>
                                <input id="txtRelationDOB" type="text" class="txtcs  span7" />
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" class="btn btn-info" id="AddRelation">Add</button>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbFamilyInfo" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">Sr.No
                                            </th>
                                            <th>Relation
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>DOB
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


    <%--Qualification--%>
    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Qualification Info.</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Degree</label>
                                <input id="txtDegree" type="text" class="txtcs  span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Institute</label>
                                <input id="txtInstitute" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">From (Year)</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="DegreeYearFrom">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">To (Year)</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="DegreeYearTo">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" class="btn btn-info" id="AddDegree">Add</button>
                            </div>

                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbDegreeInfo" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">Sr.No
                                            </th>
                                            <th>Degree
                                            </th>
                                            <th>Institute
                                            </th>
                                            <th>From
                                            </th>
                                            <th>To
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


    <%--Appointment Detail--%>
    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Employee Appointment Info.</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">District</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddDisttFrom">
                                    </select>
                                </div>
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Tehsil</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddTehFrom">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Department</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddDeptFrom">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Designation</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddDesigFrom">
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">BPS</label>
                                <div class="span7" style="margin-left: 0px;">
                                   <select id="ddlPayscaleAppointment" class="frmCtrl">
                                        <option >BPS 1</option>
                                        <option >BPS 2</option>
                                        <option >BPS 3</option>
                                        <option >BPS 4</option>
                                        <option >BPS 5</option>
                                        <option >BPS 6</option>
                                        <option >BPS 7</option>
                                        <option >BPS 8</option>
                                        <option >BPS 9</option>
                                        <option >BPS 10</option>
                                        <option >BPS 11</option>
                                        <option >BPS 12</option>
                                        <option >BPS 13</option>
                                        <option >BPS 14</option>
                                        <option >BPS 15</option>
                                        <option >BPS 16</option>
                                        <option >BPS 17</option>
                                        <option >BPS 18</option>
                                        <option >BPS 19</option>
                                        <option >BPS 20</option>
                                        <option >BPS 21</option>
                                        <option >BPS 22</option>
                                        <option >BPS Special</option>
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Employment Type</label>
                                <div class="span7" style="margin-left: 0px;">
                                    <select id="ddEmpType">
                                        <option value="1">Permanent</option>
                                        <option value="2">Contract</option>
                                    </select>
                                </div>
                            </div>
                            
                        </div>


                        <div class="form-row row-fluid" style="display:none;" id="dvContractDetail">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Starting Date</label>
                                <input id="txtContractStartingDate" type="text" class="txtcs  span7" />
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Ending Date</label>
                                <input id="txtContractEndingDate" type="text" class="txtcs  span7" />
                            </div>
                        </div>



                    </form>
                </div>
            </div>
        </div>
    </div>

    <%--save button--%>
    <div style="float: left; width: 100%; margin-left: 88%;">
        <button id="btnSave" type="button" value="Save" class="btn btn-primary">Save</button>
    </div>




</asp:Content>
