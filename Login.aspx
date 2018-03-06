<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PSIC.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%--<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />--%>
    <title>PSIC - MIS</title>
    <%--<meta name="author" content="SuggeElson" />--%>
    <meta name="description" content="Supr admin template - new premium responsive admin template. This template is designed to help you build the site administration without losing valuable time.Template contains all the important functions which must have one backend system.Build on great twitter boostrap framework" />
    <meta name="keywords" content="admin, admin template, admin theme, responsive, responsive admin, responsive admin template, responsive theme, themeforest, 960 grid system, grid, grid theme, liquid, masonry, jquery, administration, administration template, administration theme, mobile, touch , responsive layout, boostrap, twitter boostrap" />
    <meta name="application-name" content="Supr admin template" />

    <!-- Mobile Specific Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Le styles -->
    <link href="css/bootstrap/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap/bootstrap-responsive.css" rel="stylesheet" />
    <link href="css/supr-theme/jquery.ui.supr.css" rel="stylesheet" type="text/css" />
    <link href="css/icons.css" rel="stylesheet" type="text/css" />
    <link href="plugins/forms/uniform/uniform.default.css" type="text/css" rel="stylesheet" />

    <!-- Main stylesheets -->
    <link href="css/main.css" rel="stylesheet" type="text/css" />

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <%--<link rel="shortcut icon" href="images/favicon.ico" />--%>
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="images/apple-touch-icon-144-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/apple-touch-icon-114-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="images/apple-touch-icon-72-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" href="images/apple-touch-icon-57-precomposed.png" />



</head>




<body class="loginPage">


    <div class="container-fluid">


        <div id="header">

            <div class="row-fluid">

                <div class="navbar">
                    <div class="navbar-inner">
                        <div class="container">
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 10%;">
                                        <img src="Images/PSICLogo.png" alt="" style="height: 76px; margin-top: -6px; width: 130px;" />
                                    </td>
                                    <td style="text-align: left;">
                                        <a class="brand" href="#" style="text-align: left; font-family: 'Arial Rounded MT Bold'; font-weight: lighter; color: #25764C;">Punjab Small Industries Corporation (PSIC)<span class="slogan"></span></a>
                                    </td>
                                    <td style="width: 28%;">
                                        <label></label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End .container-fluid -->

    <div class="container-fluid">



        <div class="loginContainer">

            <form class="form-horizontal" action="Login.aspx" id="loginForm">


                <div class="form-row row-fluid">
                    <div class="span12">
                        <div class="row-fluid">
                            <label class="form-label span12" for="username">
                                Username:
                                <span class="icon16 icomoon-icon-user-3 right gray marginR10"></span>
                            </label>
                            <input class="span12" id="username" type="text" name="username" value="shoaib.anjum@valueresources.org" placeholder="Username" />
                        </div>
                    </div>
                </div>

                <div class="form-row row-fluid">
                    <div class="span12">
                        <div class="row-fluid">
                            <label class="form-label span12" for="password">
                                Password:
                                <span class="icon16 icomoon-icon-locked right gray marginR10"></span>

                            </label>
                            <input class="span12" id="password" type="password" name="password" value="0523" placeholder="Password" />
                        </div>
                    </div>
                </div>
                <div class="form-row row-fluid">
                    <div class="span12">
                        <div class="row-fluid">
                            <div class="form-actions">
                                <div class="span12 controls">

                                    <button type="button" class="btn btn-success right" id="btnLogin">Login</button>
                                    <label id="lblMsg" style="color: red; text-decoration: underline;"></label>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </form>


        </div>

    </div>


    <div style="height: 100%; width: 100%;">
        <img src="Images/PSICLogo.png" style="position: absolute; margin-top: 1%; margin-left: 15%; z-index: -100; width: 70%; opacity: 0.219;">
    </div>

    <div style="height: 100%; width: 100%;">
        <img src="Images/vt.png" style="position: absolute; float: right; right: 130px; bottom: 60px; z-index: 22; width: 100px;">
        <p style="position: absolute; float: right; right: 75px; bottom: 20px; z-index: 22; color: #898992;">Developed & Design by Value Resources Pvt Ltd.</p>
    </div>


    <!-- End .container-fluid -->

    <!-- Le javascript
    ================================================== -->

    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/jquery.cookie.js"></script>



    <script type="text/javascript">
        $(document).ready(function () {

            $.cookie("newCurruntMenu", null);
            $.cookie("newCurruntTitle", null);

            $(document).keypress(function (e) {
                if (e.which == 13) {
                    $("#btnLogin").click();
                }
            });

            $('#btnLogin').bind('click', function () {
                $("*").css("cursor", "wait");
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Login.aspx/LoginInfo",
                    data: "{'username':'" + $('#username').val() + "', 'Password':'" + $('#password').val() + "'}",
                    context: document.body,
                    success: function (responseText) {
                        if (responseText.d == "okLogin") {
                            window.location.href = "Dashboard.aspx";
                            $("*").css("cursor", "auto");
                        }
                        else {
                            $('#lblMsg').text('Username or password is incorrect!');
                            $('#lblMsg').show();
                            $("*").css("cursor", "auto");
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>
