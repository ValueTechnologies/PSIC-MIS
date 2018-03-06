<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="addEmployeeToPension.aspx.cs" Inherits="PSIC.addEmployeeToPension" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">

        $(document).ready(function () {
            $('.heading h3').html('Add Employee(s) to Pension');


            $('#txtDOA').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtDOB').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });
            $('#txtDOR').datepicker({ dateFormat: 'dd - MM - yy', changeYear: true, changeMonth: true });





            //Load Department
            LoadDepartment();
            function LoadDepartment() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/AllDepartments",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DepartmentID + '> ' + item.DepartmentName + '</option>';
                        });
                        $('#ddlDept').html(out);
                        $("#ddlDept").prev().html($("#ddlDept option:selected").text());
                    }
                });
            }



            //Load Designation
            LoadDesignation();
            function LoadDesignation() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePostingHistory.aspx/AllDesignations",
                    data: "{ }",
                    async: false,
                    success: function (responseText) {
                        var jData = $.parseJSON(responseText.d), out = "";
                        $.each(jData, function (i, item) {
                            out = out + '<option value= ' + item.DesignationID + '> ' + item.Designation + '</option>';
                        });
                        $('#ddlDesignation').html(out);
                        $("#ddlDesignation").prev().html($("#ddlDesignation option:selected").text());
                    }
                });
            }



            //Search
            $('#btnSearch').bind('click', function () {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "addEmployeeToPension.aspx/SearchEmployees",
                    data: "{ 'empno' : '" + $('#txtEmpNo').val() + "', 'name' : '" + $('#txtName').val() + "', 'DepartmentID' : '" + $('#ddlDept').val() + "' , 'DesignationID' : '" + $('#ddlDesignation').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            out = out + '<tr><td> ' + item.sno + '</td> <td> ' + item.EmpNo + '</td>  <td> ' + item.Full_Name + '</td>  <td> ' + item.FatherName + '</td> <td> ' + item.CNIC + '</td> <td> ' + item.DepartmentName + '</td> <td> ' + item.Designation + '</td> <td> <button type="button" class="btn btn-link SearchedEmployee" tag="' + item.User_ID + '">Detail </button></td> </tr>';
                        });
                        $('#tbSearchedEmployees tbody').html(out);
                    }
                });
            });





            function CalculateTotalAge() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "addEmployeeToPension.aspx/ConvertDateToYearMonthDate",
                    data: "{ 'Date1' : '" + $('#txtDOB').val() + "', 'Date2' : '" + $('#txtDOR').val() + "', 'Holidays' : '"+ ""+"'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";
                        

                        $.each(jData, function (i, item) {
                            $('#txtTotalAgeY').val(item.Year);
                            $('#txtTotalAgeM').val(item.Month);
                            $('#txtTotalAgeD').val(item.Day);

                        });
                    }
                });
            }

            function CalculateTotalServices() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "addEmployeeToPension.aspx/ConvertDateToYearMonthDate",
                    data: "{ 'Date1' : '" + $('#txtDOA').val() + "', 'Date2' : '" + $('#txtDOR').val() + "', 'Holidays' : '" + "" + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            $('#txtTotalServicesY').val(item.Year);
                            $('#txtTotalServicesM').val(item.Month);
                            $('#txtTotalServicesD').val(item.Day);

                        });
                    }
                });
            }


            function CalculateNetQualifyingServices() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "addEmployeeToPension.aspx/ConvertDateToYearMonthDate",
                    data: "{ 'Date1' : '" + $('#txtDOA').val() + "', 'Date2' : '" + $('#txtDOR').val() + "', 'Holidays' : '" + $('#txtTotalHolidaysInService').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), out = "";

                        $.each(jData, function (i, item) {
                            $('#txtNetQualifyingServiceY').val(item.Year);
                            $('#txtNetQualifyingServiceM').val(item.Month);
                            $('#txtNetQualifyingServiceD').val(item.Day);

                        });
                    }
                });
            }

            $('#txtDOR').change(function () {
                CalculateTotalAge();
                CalculateTotalServices();
                CalculateNetQualifyingServices();
            });


            $('#txtTotalHolidaysInService').blur(function () {
                CalculateTotalAge();
                CalculateTotalServices();
                CalculateNetQualifyingServices();
            });


            $('#btnSave').bind('click', function () {
                
                if ($('#txtDOA').val().trim() == "") {
                    alert('Please enter Date of appointment...');
                    return;
                }

                if ($('#txtDOB').val().trim() == "") {
                    alert('Please enter Date of birth...');
                    return;
                }

                if ($('#txtDOR').val().trim() == "") {
                    alert('Please enter Date of retirement...');
                    return;
                }

                if ($('#txtTotalHolidaysInService').val().trim() == "") {
                    alert('Please enter total holidays in service...');
                    return;
                }


                if ($('#txtAccountNo').val().trim() == "") {
                    alert('Please enter Account No...');
                    return;
                }


                if ($('#txtFileNo').val().trim() == "") {
                    alert('Please enter File No...');
                    return;
                }

                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });
                ctrlVals += $('#btnSave').attr('tag') + '½';




                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "addEmployeeToPension.aspx/SaveEmployeeToPension",
                    data: "{ 'Vals' : '" + ctrlVals + "'  }",
                    success: function (response) {
                        
                        alert(response.d);
                        $('.frmCtrl').each(function (index, element) {
                            $(this).val('');
                        });
                    }
                });


            });
        });



        //Load EmployeeData
        $('body').on({
            click: function () {
                $('#btnSave').attr('tag', $(this).attr('tag'));

                $('#lblEmpNo').html($(this).parent().prev().prev().prev().prev().prev().prev().html());
                $('#lblName').html($(this).parent().prev().prev().prev().prev().prev().html());
                $('#lblDepartment').html($(this).parent().prev().prev().html());
                $('#lblDesignation').html($(this).parent().prev().html());
                LoadEmpPreviousData($(this).attr('tag'));
            }
        }, ".SearchedEmployee");



        function LoadEmpPreviousData(empid) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "addEmployeeToPension.aspx/LoadEmpPreviousData",
                data: "{ 'EmpID' : '" + empid + "'}",
                async: false,
                success: function (responseText) {
                    var jData = $.parseJSON(responseText.d), out = "";
                    $.each(jData, function (i, item) {
                        $('#txtDOA').val(item.DOA);
                        $('#txtDOB').val(item.DOB);
                    });
                    
                }
            });
        }


    </script>





</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Search Employee</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Emp No</label>
                                <input id="txtEmpNo" type="text" class="txtcs  span7" />
                            </div>

                            <div class="span6">
                                <label class="form-label span4" for="normal">Name</label>
                                <input id="txtName" type="text" class="txtcs  span7" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal">Department</label>
                                <div class="span7 controls sel" style="margin-left: 0px;">
                                    <select id="ddlDept" class="txtcs nostyle">
                                    </select>
                                </div>
                            </div>
                            <div class="span6">
                                <label class="form-label span4" for="normal">Designation</label>
                                <div class="span7 controls sel" style="margin-left: 0px;">
                                    <select id="ddlDesignation" class="txtcs nostyle">
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span4" for="normal"></label>
                                <button type="button" class="btn btn-info" id="btnSearch">Search</button>
                            </div>

                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table id="tbSearchedEmployees" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">SrNo.
                                            </th>
                                            <th>Emp No.
                                            </th>
                                            <th>Name
                                            </th>
                                            <th>Father Name
                                            </th>
                                            <th>CNIC
                                            </th>
                                            <th>Department
                                            </th>
                                            <th>Designation
                                            </th>
                                            <th>Detail
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




    <%--Add Employee to Pension--%>


    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Add Employee To Pension</span>
                    </h4>
                </div>
                <div class="content">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <div style="border-color: rgb(221, 221, 221); border-width: 1px; border-style: solid;">
                                    <table style="width: 100%; background-color: whitesmoke;">
                                        <tr>
                                            <td style="font-weight: bold;">EmpNo : 
                                            </td>
                                            <td>
                                                <label id="lblEmpNo" for="normal"></label>
                                            </td>
                                            <td style="width: 5%;"></td>
                                            <td style="font-weight: bold;">Name : 
                                            </td>
                                            <td>
                                                <label id="lblName" for="normal"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Department : 
                                            </td>
                                            <td>
                                                <label id="lblDepartment" for="normal"></label>
                                            </td>
                                            <td style="width: 5%;"></td>
                                            <td style="font-weight: bold;">Designation : 
                                            </td>
                                            <td>
                                                <label id="lblDesignation" for="normal"></label>
                                            </td>
                                        </tr>

                                    </table>
                                </div>
                            </div>
                        </div>



                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Date Of Appointment</label>
                                <input id="txtDOA" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Date Of Birth.</label>
                                <input id="txtDOB" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Date Of Retirement.</label>
                                <input id="txtDOR" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Total Age</label>
                                <input id="txtTotalAgeY" type="text" class="txtcs frmCtrl span2" />Y&nbsp;&nbsp;
                                <input id="txtTotalAgeM" type="text" class="txtcs frmCtrl span2" />M&nbsp;&nbsp;
                                <input id="txtTotalAgeD" type="text" class="txtcs frmCtrl span2" />D
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Total Services</label>
                                <input id="txtTotalServicesY" type="text" class="txtcs frmCtrl span2" />Y&nbsp;&nbsp;
                                <input id="txtTotalServicesM" type="text" class="txtcs frmCtrl span2" />M&nbsp;&nbsp;
                                <input id="txtTotalServicesD" type="text" class="txtcs frmCtrl span2" />D

                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Total Holidays (in Days)</label>
                                <input id="txtTotalHolidaysInService" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Net Qualifying Service</label>
                                <input id="txtNetQualifyingServiceY" type="text" class="txtcs frmCtrl span2" />Y&nbsp;&nbsp;
                                <input id="txtNetQualifyingServiceM" type="text" class="txtcs frmCtrl span2" />M&nbsp;&nbsp;
                                <input id="txtNetQualifyingServiceD" type="text" class="txtcs frmCtrl span2" />D
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Age Next Birthday</label>
                                <div class="controls sel span6">
                                    <select class="nostyle frmCtrl" id="ddlAgeNextBirthday">
                                        <option>60</option>
                                        <option>59</option>
                                        <option>58</option>
                                        <option>57</option>
                                        <option>56</option>
                                        <option>55</option>
                                        <option>54</option>
                                        <option>53</option>
                                        <option>52</option>
                                        <option>51</option>
                                        <option>50</option>
                                        <option>49</option>
                                        <option>48</option>
                                        <option>47</option>
                                        <option>46</option>
                                        <option>45</option>
                                        <option>44</option>
                                        <option>43</option>
                                        <option>42</option>
                                        <option>41</option>
                                        <option>40</option>
                                        <option>39</option>
                                        <option>38</option>
                                        <option>37</option>
                                        <option>36</option>
                                        <option>35</option>
                                        <option>34</option>
                                        <option>33</option>
                                        <option>32</option>
                                        <option>31</option>
                                        <option>30</option>
                                        <option>29</option>
                                        <option>28</option>
                                        <option>27</option>
                                        <option>26</option>
                                        <option>25</option>
                                        <option>24</option>
                                        <option>23</option>
                                        <option>22</option>
                                        <option>21</option>
                                        <option>20</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">Account No.</label>
                                <input id="txtAccountNo" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal">File No.</label>
                                <input id="txtFileNo" type="text" class="txtcs frmCtrl span6" />
                            </div>
                        </div>


                        <div class="form-row row-fluid">
                            <div class="span12">
                                <label class="form-label span3" for="normal" ></label>
                                <div style="margin-left : 0px;">
                                    <button type="button" class="btn btn-primary span2" id="btnSave">Save</button>
                                </div>
                                
                            </div>

                        </div>


                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
