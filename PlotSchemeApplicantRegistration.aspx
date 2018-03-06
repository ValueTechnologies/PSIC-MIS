<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="PlotSchemeApplicantRegistration.aspx.cs" Inherits="PSIC.PlotSchemeApplicantRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript" src="Scripts/jquery.mask.js"></script>


    <script type="text/javascript">
        function showimagepreview(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#imgprvw').attr('src', e.target.result);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }

        function showimagepreview1(input) {
            if (input.files && input.files[0]) {
                var filerdr = new FileReader();
                filerdr.onload = function (e) {
                    $('#Simgprvw').attr('src', e.target.result);
                }
                filerdr.readAsDataURL(input.files[0]);
            }
        }

        $(document).ready(function () {
            $('.heading h3').html('Applicant Registration');
            $('#txtApplicantCNIC').mask('99999-9999999-9');
            AllCandidates();

            $('#ddlCorporateSetupType').bind('change', function () {
                if ($('#ddlCorporateSetupType').val() != 1) {
                    $('#btnAddCandidate').show();
                }
                else {
                    $('#btnAddCandidate').hide();
                }
            });




            $('#btnAddCandidate').bind('click', function () {
                var str = '<tr><td>' + $('#ddlCandidates').prev().html() + ' </td><td>   <img tag="' + $('#ddlCandidates').val() + '" class="clsCandidates" src="Images/cross_circle.png">  </td> </tr>';
                $('#tbApplicant').append(str);
            });


            function AllCandidates() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PlotSchemeApplicantRegistration.aspx/AllCandidates",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";
                        $.each(jData, function (i, item) {
                            Out += '<option value="' + item.ApplicantID + '"> ' + item.Candidate + ' </option>';
                        });
                        $('#ddlCandidates').html(Out);
                        $('#ddlCandidates').prev().html($('#ddlCandidates option:selected').text());
                    }
                });
            }


            function LoadCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "EstateNewPlots.aspx/LoadCategories",
                    data: "{ 'SchemeID' : '" + $('#ddlScheme').val() + "'}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";

                        $.each(jData, function (i, item) {
                            Out = Out + '<option value="' + item.PlotCategoryID + '"> ' + item.Category + ' </value>';
                        });
                        $('#ddlCategoriesOfPlot').html(Out);
                        $('#ddlCategoriesOfPlot').prev().html($('#ddlCategoriesOfPlot option:selected').text());
                    }
                });
            }


            $(function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "PlotSchemeApplicantRegistration.aspx/AllSchemes",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d), Out = "";
                        $.each(jData, function (i, item) {
                            Out += '<option value="' + item.SchemeID + '"> ' + item.Scheme + ' </option>';
                        });
                        $('#ddlScheme').html(Out);
                        $('#ddlScheme').prev().html($('#ddlScheme option:selected').text());
                        LoadCategories();
                    }
                });
            });


            $('#ddlScheme').bind('change', LoadCategories);




        });


        $('body').on({
            click: function () {
                $(this).parent().parent().remove();
            }
        }, '.clsCandidates')





        $('body').on({
            click: function () {

                //Field Check



                var ctrlVals = "";
                $('.frmCtrl').each(function (index, element) {
                    ctrlVals += $(this).val() + '½';
                });
                var Candidates = "";
                if ($('#ddlCorporateSetupType').val() != 1) {
                    $('.clsCandidates').each(function (index, element) {
                        Candidates = Candidates + $(this).attr('tag') + ',';
                    });
                    ctrlVals += Candidates + '½';
                }
                else {
                    ctrlVals += $('#ddlCandidates').val() + '½';
                }





                //Signature File Check
                var uploadfilesS = $("#fileUpload1").get(0);
                var uploadedfilesS = uploadfilesS.files;

                if (uploadedfilesS.length > "0") {
                    ctrlVals += 'YesSignatureFileExists' + '½';
                }


                //Combine data and both file uploader data
                var fromdata = new FormData();
                fromdata.append("vls", ctrlVals);

                for (var i = 0; i < uploadedfilesS.length; i++) {
                    fromdata.append(uploadedfilesS[i].name, uploadedfilesS[i]);
                }

                var choice = {};
                choice.url = "EstateCandidateRegistrationCS.ashx";
                choice.type = "POST";
                choice.data = fromdata;
                choice.contentType = false;
                choice.processData = false;
                choice.success = function (result) {
                    alert('Save Successfully!');
                    $("*").css("cursor", "auto");
                    $('#btnSave').attr('tag', result);

                    $('#tbApplicant').html('');
                    $('#btnAddCandidate').hide();
                    $('#ddlCorporateSetupType').val('1');

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row-fluid">
        <div class="span12">
            <div class="box">
                <div class="title">
                    <h4>
                        <span>Applicant Registration</span>
                    </h4>
                    <a href="dvNewApplicantRegistration" class="minimize">Minimize</a>
                </div>
                <div class="content" id="dvNewApplicantRegistration">

                    <form class="form-horizontal" action="#">
                        <div class="form-row row-fluid">
                            <div class="span12">
                                <table style="margin-left: 50px;">
                                    <tr>
                                        <td style="width: 210px;">Scheme Name :
                                        </td>
                                        <td style="">
                                            <div style="margin-left: 0px; width: 410px;">
                                                <select id="ddlScheme" class="frmCtrl">
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h4 style="text-align: center;">Applicant Basic Info.</h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Corporate set-up of industrial unit
                                        </td>
                                        <td>
                                            <div style="width: 410px;">
                                                <select id="ddlCorporateSetupType" class="frmCtrl">
                                                    <option value="1">Sole </option>
                                                    <option value="2">Partnership </option>
                                                    <option value="3">Private Limited Company </option>
                                                    <option value="4">Public Ltd Company </option>
                                                </select>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>


                                    <tr>
                                        <td>Applicant(s) : 
                                        </td>
                                        <td style="width: 500px;">
                                            <div style="width: 410px;">
                                                <select id="ddlCandidates"></select>
                                            </div>

                                            <button type="button" id="btnAddCandidate" class="btn btn-info" style="display: none;">Add</button>


                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="width: 200px;"></td>
                                        <td>
                                            <table id="tbApplicant" class="responsive table table-striped table-bordered table-condensed" style="width: 410px;">
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Industrial Unit :
                                        </td>
                                        <td>
                                            <input id="txtIndustrialUnit" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                        <td></td>
                                    </tr>


                                    <tr>
                                        <td>Type/Classification Of Industry
                                        </td>
                                        <td>
                                            <input id="txtTypeOfIndustry" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                        <td></td>
                                    </tr>


                                    <tr>

                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h4 style="text-align: center;">Estimated Demand of Utilities</h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Electricity : 
                                        </td>
                                        <td>
                                            <input id="txtElectricity" type="text" style="width: 400px;" class="frmCtrl" />
                                            &nbsp;&nbsp; KVA
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Water :
                                        </td>
                                        <td>
                                            <input id="txtWater" type="text" style="width: 400px;" class="frmCtrl" />
                                            &nbsp;&nbsp; Liters / Day
                                        </td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>Gas :
                                        </td>
                                        <td>
                                            <input id="txtGas" type="text" style="width: 400px;" class="frmCtrl" />
                                            &nbsp;&nbsp; Hm<sup>3</sup>
                                        </td>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h4 style="text-align: center;">Environmental Details</h4>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Identify the waste products (effluents) that will be generated by the unit
                                        </td>
                                        <td>
                                            <textarea id="txtWasteProduct" cols="20" rows="2" style="width: 400px;" class="frmCtrl"></textarea>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Mode Of Disposal :
                                        </td>
                                        <td>
                                            <textarea id="txtModeOfDisposal" cols="20" rows="2" style="width: 400px;" class="frmCtrl"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h4 style="text-align: center;">Plot Information</h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Category Of Plot :
                                        </td>
                                        <td>
                                            <div style="width: 407px;">
                                                <select id="ddlCategoriesOfPlot" class="frmCtrl">
                                                </select>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h5 style="text-align: left; text-decoration: underline;">Application Fee</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Pay Order / Bank Draft / Receipt No. :
                                        </td>
                                        <td>
                                            <input id="txtPayOrder" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Amount (In Figures) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInFiguresReceipt" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Amount (In Words) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInWordsReceipt" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h5 style="text-align: left; text-decoration: underline;">Processing Fee</h5>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Pay Order / Demand Draft, Drawn on (Bank name) :
                                        </td>
                                        <td>
                                            <input id="txtBankName" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Bearing No :
                                        </td>
                                        <td>
                                            <input id="txtBearingNo" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Amount (In Figures) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInFiguresDemandDraft" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Amount (In Words) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInWordsDemandDraft" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h5 style="text-align: left; text-decoration: underline;">Down Payment</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Pay Order / Demand Draft, Drawn on (Bank name) :
                                        </td>
                                        <td>
                                            <input id="txtBankNameDP" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Bearing No :
                                        </td>
                                        <td>
                                            <input id="txtBearingNoDP" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Amount (In Figures) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInFiguresDemandDraftDP" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Amount (In Words) :
                                        </td>
                                        <td>
                                            <input id="txtAmountInWordsDemandDraftDP" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br />
                                            <br />
                                            <h5 style="text-align: left; text-decoration: underline;">Signature</h5>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Signature :
                                        </td>
                                        <td>
                                            <img alt="" src="" id="Simgprvw" style="width: 150px; height: 100px;" />
                                            <br />
                                            <input type="file" id="fileUpload1" class="span3 FUpload" onchange="showimagepreview1(this);" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Name :
                                        </td>
                                        <td>
                                            <input id="txtSName" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Address :
                                        </td>
                                        <td>
                                            <textarea id="txtAddress" cols="20" rows="2" style="width: 400px;" class="frmCtrl"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Phone :
                                        </td>
                                        <td>
                                            <input id="txtSPhone" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Fax :
                                        </td>
                                        <td>
                                            <input id="txtSFax" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Email :
                                        </td>
                                        <td>
                                            <input id="txtSEmail" type="text" style="width: 400px;" class="frmCtrl" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <button type="button" id="btnSave" class="btn btn-primary">Save</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>




                    </form>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
