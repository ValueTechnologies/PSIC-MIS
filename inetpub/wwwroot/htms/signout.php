<?php session_start(); 
	session_destroy();
require_once('functions.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><?php echo($gPageTitle) ?></title>
<link rel="shortcut icon" href="images/company.ico" /> 
<link rel="stylesheet" type="text/css" href="main.css" />

<script type="text/javascript">
<!--
var tmr;
function initTimer() {
	callTimer(0);
}
function callTimer(flg) {
	if (flg == 0)
		tmr = setTimeout('callTimer(1)', 2000);
	else
		window.location = "index.php";
}
function clearTimer(itm) {
	clearTimeout(itm);
}
-->
</script>
</head>

<body onload="initTimer()">
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<br />
<table align="center" border="0"><tr><td align="center" class="gStyle4">You are successfully signed out. To sign in again, please wait or click <a href="index.php">here</a></td></tr></table>
</body>
</html>
