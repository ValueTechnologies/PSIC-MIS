<?php 
session_start();
if (!isset($_SESSION['uid']) || $_SESSION['uid'] == '') {
	$_SESSION['errDesc'] = "Invalid user or the session is expired, please login <a href='index.php'>here</a>";
	header ("Location: error.php");
}

require_once('functions.php');
?>
<!DOCTYPE html>
<html id="home" lang="en">
<head>
<meta charset=utf-8 />
<title><?php echo($gPageTitle) ?></title>
<link rel="shortcut icon" href="images/company.ico" /> 
<link rel="stylesheet" type="text/css" href="main.css" />

<script src="ajax.js" type="text/javascript"></script>
<script type="text/javascript">
function drawszlider(ossz, meik) {
	var szazalek=Math.round((meik*100)/ossz);
	document.getElementById("szliderbar").style.width=szazalek+'%';
	//document.getElementById("szazalek").innerHTML=szazalek+'%';
}

var countdown;
var countdown_number;
var waitTimer;

function countdown_init() {
    countdown_number = 101;
    countdown_trigger();
	waitTrigger();
}

function countdown_trigger() {
    if(countdown_number > 0) {
        countdown_number--;
        //document.getElementById('countdown_text').innerHTML = countdown_number;
		drawszlider(100, 100-countdown_number);
        if(countdown_number > 0) {
            countdown = setTimeout('countdown_trigger()', 25);
        } else {
			countdown_clear ();
			window.location = 'main.php';
		}
    }
}

function waitTrigger() {
	if (document.getElementById('waitDiv').innerHTML == "")
		document.getElementById('waitDiv').innerHTML = "Please wait...";
	else
		document.getElementById('waitDiv').innerHTML = "";
		
	waitTimer = setTimeout ('waitTrigger()', 1000);
}

function countdown_clear() {
    clearTimeout(countdown);
	clearTimeout(waitTimer);
}
</script>
</head>
<body onload="countdown_init()"> <!--drawszlider(121, 56)-->
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
&nbsp;<br />
&nbsp;<br />
<table width="500" align="center">
<tr><td align="center"><h1 style="color:#990000">Powered by PSIC - IT Section</h1>
</td></tr>
</table>
&nbsp;<br />
&nbsp;<br />
&nbsp;<br />
&nbsp;<br />
&nbsp;<br />
&nbsp;<br />
&nbsp;<br />
<table width="210" align="center">
<tr><td align="center">
<div id="szlider" align="left">
	<div id="szliderbar"></div>
	<div id="szazalek"></div>
</div>
</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><div id="waitDiv" class="gStyle6" style="font-size:18px"></div>
</td></tr>
</table>
</body>
</html>