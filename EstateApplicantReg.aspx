<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="EstateApplicantReg.aspx.cs" Inherits="PSIC.EstateApplicantReg" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvw').attr('src', e.target.result);
                    $('#imgprvw').slideDown(400);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }


        function Capture() {
            webcam.capture();
            return false;
        }



        $(document).ready(function () {
            $('.heading h3').html('Industrialist Registration');
            $('#txtCNICOfApplicant').mask('99999-9999999-9');
            $('#dvLiveCamera').dialog({ autoOpen: false, width: "45%", modal: true });
            $('#btnSave').attr('tag', 0);



            $('#OpenLiveCamera').bind('click', function () {
                $('#dvLiveCamera').dialog("open");
                $('#imgprvw').removeAttr('src');
            });



            //Web cam

            var pageUrl = '/PSIC/EstateApplicantReg.aspx';
            $(function () {
                jQuery("#webcam").webcam({
                    width: 320,
                    height: 240,
                    mode: "save",
                    swffile: '/PSIC/Images/jscam.swf',
                    debug: function (type, status) {
                        $('#camStatus').append(type + ": " + status + '<br /><br />');
                    },
                    onSave: function (data) {
                        $('*').css('cursor', 'wait');
                        $.ajax({
                            type: "POST",
                            url: pageUrl + "/GetCapturedImage",
                            data: '',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (r) {
                                $("[id*=imgprvw]").css("visibility", "visible");
                                $("[id*=imgprvw]").removeAttr("src");
                                $("[id*=imgprvw]").attr("src", r.d);
                                $('#imgprvw').show();
                                $('#dvLiveCamera').dialog("close");
                                $('*').css('cursor', 'default');
                            },
                            failure: function (response) {
                                alert(response.d);
                            }
                        });
                    },
                    onCapture: function () {
                        webcam.save(pageUrl);
                    }
                });
            });

            //end web cam


        });

        LoadIndustrialist();
        function LoadIndustrialist() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "EstateApplicantReg.aspx/LoadIndustrialist",
                data: "{ }",
                success: function (response) {
                    var jData = $.parseJSON(response.d), Out = "";

                    $.each(jData, function (i, item) {
                        Out = Out + '<tr><td> ' + item.Name + '</td><td>' + item.CNIC + '</td><td>' + item.NTN + '</td>  <td>' + item.ContactNo + '</td> <td>' + item.Address + '</td><td>  <img alt="" src="Uploads/EstateCandidatePhoto/' + item.ApplicantID + "" + item.PhotoExtension + '"  style="width: 185px; height: 150px; " /> </td><td><button type="button" class="btn btn-link clsEditIndustrialist" tag="' + item.ApplicantID + '">Edit </button></td></tr>';
                    });
                    $('#tbRegisteredIndustrialist tbody').html(Out);
                }
            });
        }


        $('body').on({
            click: function () {
                $('#txtNameOfApplicant').val($(this).parent().prev().prev().prev().prev().prev().prev().html());
                $('#txtCNICOfApplicant').val($(this).parent().prev().prev().prev().prev().prev().html());
                $('#txtNTNOfApplicant').val($(this).parent().prev().prev().prev().prev().html());
                $('#txtContactOfApplicant').val($(this).parent().prev().prev().prev().html());
                $('#txtAddressOfApplicant').val($(this).parent().prev().prev().html());

                $('#imgprvw').attr('src', $(this).parent().prev().children().attr('src'));
                $('#imgprvw').show();

                $('#btnSave').attr('tag', $(this).attr('tag'));
                $('#btnSave').text('Update');

            }
        }, ".clsEditIndustrialist");

        $('body').on({
            click: function () {
                $("*").css("cursor", "wait");
                if ($('#txtNameOfApplicant').val() == "") {
                    alert('Please enter Applicant name...');
                    return;
                }

                if ($('#txtCNICOfApplicant').val() == "") {
                    alert('Please enter CNIC...');
                    return;
                }

                if ($('#txtNTNOfApplicant').val() == "") {
                    alert('Please enter NTN...');
                    return;
                }




                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });
                ctrlVals = ctrlVals + $('#btnSave').attr('tag');

                //Pic File Check
                var uploadfilesP = $("#fileUpload").get(0);
                var uploadedfilesP = uploadfilesP.files;


                //Combine data and both file uploader data
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);

                for (var i = 0; i < uploadedfilesP.length; i++) {
                    fromdata.append(uploadedfilesP[i].name, uploadedfilesP[i]);
                }

                var choice = {};
                choice.url = "EstateApplicantRegCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");
                    $('#btnSave').attr('tag', 0);
                    $('#imgprvw').hide();
                    LoadIndustrialist();

                    $('.frmCtrl').each(function (index, element) {
                        $(this).val('');
                    });


                    $('.filename').html('');
                };
                choice.error = function (err) {
                    alert(err.statusText);
                };
                $.ajax(choice);
                event.preventDefault();
            }
        }, "#btnSave");
    </script>

    <style type="text/css">
        .button {
            background: #3498db;
            background-image: -webkit-linear-gradient(top, #3498db, #2980b9);
            background-image: -moz-linear-gradient(top, #3498db, #2980b9);
            background-image: -o-linear-gradient(top, #3498db, #2980b9);
            background-image: linear-gradient(to bottom, #3498db, #2980b9);
            -webkit-border-radius: 7;
            -moz-border-radius: 7;
            border-radius: 7px;
            font-family: Arial;
            color: #ffffff;
            font-size: 14px;
            padding: 0px 5px 0px 5px;
            text-decoration: none;
        }

            .button:hover {
                background: #2780b8;
                background-image: -webkit-linear-gradient(top, #2780b8, #3498db);
                background-image: -moz-linear-gradient(top, #2780b8, #3498db);
                background-image: -o-linear-gradient(top, #2780b8, #3498db);
                background-image: linear-gradient(to bottom, #2780b8, #3498db);
                text-decoration: none;
            }

        div.button span {
            text-transform: none;
        }

        div.button {
            height: 26px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Industrialist Registration </span>
                    </h4>
                    <a href="dvApplicant" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvApplicant">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Name</label>
                                <input type="text" id="txtNameOfApplicant" class="span8 frmCtrl" />
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">CNIC </label>
                                <input type="text" id="txtCNICOfApplicant" class="span8 frmCtrl" />
                            </div>

                        </div>



                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">NTN No </label>
                                <input type="text" id="txtNTNOfApplicant" class="span8 frmCtrl" />
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">Contact No </label>
                                <input type="text" id="txtContactOfApplicant" class="span8 frmCtrl" />
                            </div>
                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6">
                                <label class="form-label span3" for="normal">Address </label>
                                <input type="text" id="txtAddressOfApplicant" class="span8 frmCtrl" />
                            </div>

                            <div class="span6">
                                <label class="form-label span3" for="normal">Photo</label>
                                <input type="file" id="fileUpload" class="span3 FUpload" onchange="showimagepreview(this);" />
                                <br />
                                <img alt="" src="" id="imgprvw" style="width: 150px; height: 150px; display:none;"  />
                                
                                

                            </div>



                        </div>

                        <div class="form-row row-fluid">
                            <div class="span6" style="margin-left: 0px;">
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
                        <span>Registered Industrialist</span>
                    </h4>
                    <a href="http://202.142.164.246/psic1/dvApplicant" class="minimize" style="display: none;">Minimize</a>
                </div>
                <div class="content" id="dvRegisteredApplicant">

                    <form class="form-horizontal" action="http://202.142.164.246/psic1/EstateApplicantReg.aspx#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                
                                <table id="tbRegisteredIndustrialist" class="responsive table table-striped table-bordered table-condensed">
                                    <thead>
                                        <tr>
                                            <th>
                                                Name
                                            </th>
                                            <th>
                                                CNIC
                                            </th>
                                            <th>
                                                NTN #
                                            </th>
                                            <th>
                                                Contact #
                                            </th>
                                            <th>
                                                Address
                                            </th>
                                            <th>
                                                Photo
                                            </th>
                                            <th>
                                                Edit
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
