<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageD.master" AutoEventWireup="true" CodeBehind="AccountsSettings.aspx.cs" Inherits="PSIC.AccountsSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    &nbsp;
    <script type="text/javascript">
        $(document).ready(function () {

            $('.heading h3').html('Accounts setting');
            

            $(function () {
                for (var i = 2010; i < 2050; i++) {
                    $('#ddlStartingYear').append('<option >' + i + ' </option>');
                    $('#ddlActiveYear').append('<option >' + i + ' </option>');
                }

                $('#ddlStartingYear').val(2010);
                $('#ddlStartingYear').prev().html($('#ddlStartingYear option:selected').val());
                $('#ddlActiveYear').val(2010);
                $('#ddlActiveYear').prev().html($('#ddlActiveYear option:selected').val());
                EndingMonth();
            });

            GetPreviousMonthYear();

            $('#ddlStartingMonth').bind('change', EndingMonth);
            $('#ddlStartingYear').bind('change', EndingMonth);

            function EndingMonth() {
                $('#ddlActiveYear').val($('#ddlStartingYear').val());
                $('#ddlActiveYear').prev().html($('#ddlActiveYear option:selected').val());
                $('#ddlActiveMonth').val($('#ddlStartingMonth').val());
                $('#ddlActiveMonth').prev().html($('#ddlActiveMonth option:selected').text());

                var str, valueOfMonth;
                valueOfMonth = parseInt($('#ddlStartingMonth').val()) - 1;

                str = $('#ddlStartingMonth option[value=' + valueOfMonth + ']').text();

                str = str + ' ' + (parseInt( $('#ddlStartingYear').val()) + 1);
                $('#txtActiveYearEndOn').val(str);
            }



            $('#btnSaveActiveYear').bind('click', SaveActiveYearData);


            function SaveActiveYearData() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AccountsSettings.aspx/CurruntYearSaveData",
                    data: "{ 'StartingMonth' : '" + $('#ddlStartingMonth').val() + "', 'StartingYear' : '" + $('#ddlStartingYear').val() + "', 'ActiveMonth' : '" + $('#ddlActiveMonth').val() + "', 'ActiveYear' : '" + $('#ddlActiveYear').val() + "'}",
                    success: function (response) {
                        alert('Save successfully!');
                    }
                });
            }



            function GetPreviousMonthYear() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    url: "AccountsSettings.aspx/GetAccountYearAndMonth",
                    data: "{}",
                    success: function (response) {
                        var jData = $.parseJSON(response.d);
                        $('#ddlStartingMonth').val(jData[0].AccountYearMonth);
                        $('#ddlStartingMonth').prev().html($('#ddlStartingMonth option:selected').text());
                        $('#ddlStartingYear').val(jData[0].AccountYearYear);
                        $('#ddlStartingYear').prev().html($('#ddlStartingYear option:selected').text());
                        $('#ddlActiveMonth').val(jData[0].ActiveMonth);
                        $('#ddlActiveMonth').prev().html($('#ddlActiveMonth option:selected').text());
                        $('#ddlActiveYear').val(jData[0].ActiveYear);
                        $('#ddlActiveYear').prev().html($('#ddlActiveYear option:selected').text());


                        var str, valueOfMonth, StrValueOfMonth;
                        valueOfMonth = parseInt($('#ddlStartingMonth').val()) - 1;
                        if (valueOfMonth < 10) {
                            StrValueOfMonth = '0' + valueOfMonth;
                        }
                        else {
                            StrValueOfMonth = valueOfMonth;
                        }
                        str = $('#ddlStartingMonth option[value=' + StrValueOfMonth + ']').text();
                        str = str + ' ' + (parseInt($('#ddlStartingYear').val()) + 1);
                        $('#txtActiveYearEndOn').val(str);
                    }
                });
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="form-row row-fluid">
        <div class="span12">
            <div style="margin-bottom: 20px;">
                <ul id="TabAccountsSettings" class="nav nav-tabs pattern">
                    <li class="active"><a href="#dvAccountingYear" data-toggle="tab">Active accounting Year</a></li>

                </ul>

                <div class="tab-content">
                    <div class="tab-pane fade active in" id="dvAccountingYear">
                        <div class="form-row row-fluid">
                            <div class="span12">

                                <div class="form-row row-fluid">
                                    <div class="span12">
                                        <table>
                                            <tr>
                                                <td style="width : 130px;">Starting From
                                                </td>
                                                <td>
                                                    <div>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div style="width : 120px;"    >
                                                                        <select id="ddlStartingMonth" >
                                                                        <option value="01">January</option>
                                                                        <option value="02">February</option>
                                                                        <option value="03">March</option>
                                                                        <option value="04">April</option>
                                                                        <option value="05">May</option>
                                                                        <option value="06">June</option>
                                                                        <option value="07">July</option>
                                                                        <option value="08">August</option>
                                                                        <option value="09">September</option>
                                                                        <option value="10">October</option>
                                                                        <option value="11">November</option>
                                                                        <option value="12">December</option>
                                                                        <option value="13">January</option>
                                                                    </select>
                                                                    </div>
                                                                    
                                                                </td>
                                                                <td>
                                                                    <div style="width: 100px;">
                                                                        <select id="ddlStartingYear" >
                                                                        
                                                                    </select>
                                                                    </div>
                                                                    
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>End On
                                                </td>
                                                <td>
                                                    <input type="text" id="txtActiveYearEndOn" disabled="disabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Active Month
                                                </td>
                                                <td>
                                                    <div>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div style="width : 120px;"    >
                                                                        <select id="ddlActiveMonth" >
                                                                        <option value="01">January</option>
                                                                        <option value="02">February</option>
                                                                        <option value="03">March</option>
                                                                        <option value="04">April</option>
                                                                        <option value="05">May</option>
                                                                        <option value="06">June</option>
                                                                        <option value="07">July</option>
                                                                        <option value="08">August</option>
                                                                        <option value="09">September</option>
                                                                        <option value="10">October</option>
                                                                        <option value="11">November</option>
                                                                        <option value="12">December</option>
                                                                        <option value="13">January</option>
                                                                    </select>
                                                                    </div>
                                                                    
                                                                </td>
                                                                <td>
                                                                    <div style="width: 100px;">
                                                                        <select id="ddlActiveYear" >
                                                                        
                                                                    </select>
                                                                    </div>
                                                                    
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td>
                                                    <button id="btnSaveActiveYear" type="button" class="btn btn-primary">Save</button>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                </div>
            </div>
        </div>

    </div>
</asp:Content>
