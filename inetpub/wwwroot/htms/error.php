<?php session_start(); 
require_once('functions.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><?php echo($gPageTitle) ?></title>
<link rel="shortcut icon" href="images/company.ico" /> 
<link rel="stylesheet" type="text/css" href="main.css" />
</head>

<body>
<p align="center" class="gStyle3"><?php echo($gCompanyName) ?></p>
<p align="center" class="gStyle1"><?php echo($gAppName) ?></p>
<p>&nbsp;</p>
<table align="center" border="0"><tr><td align="center" class="gStyle4"><?php echo(isset ($_SESSION['errDesc']) ? $_SESSION['errDesc'] : ''); ?></td></tr></table>
</body>
</html>
