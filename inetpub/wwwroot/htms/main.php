<?php 
session_start();
$_SESSION['flg'] = '';
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
function empRequired () {
	var elem = document.getElementById('userPost'); 
	//alert (elem.options[elem.selectedIndex].text);
	if (!elem || elem.value == "") {
		alert('Please first select a Post/Employee');
		elem.focus();
		return false;

	} else if (elem.options[elem.selectedIndex].text.indexOf('Vacant Post') >= 0) {
		alert('Post with an employee must be selected for this purpose');
		elem.focus();
		return false;
	}  

	return true;
}

function postRequired () {
	// Exceptions
	var elem = document.getElementById('flg'); 
	if (!elem || elem.value == "Edit Post/Employee") {
		return true;
	}

	elem = document.getElementById('userPost'); 
	//alert (elem.options[elem.selectedIndex].text);
	if (!elem || elem.value == "") {
		alert('Please first select a Post');
		elem.focus();
		return false;

	}  

	return true;
}
</script>
</head>
<body>
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<table align="center" width="750" border="0" bgcolor="#CDFFFF">
<tr><td align="left" class="gStyle4">Welcome <?php echo ($_SESSION['uid']); ?>,</td><td>&nbsp;</td><td align="right"><a href="changePwd.php" class="gStyle4">Change Password</a> | <a href="signout.php" class="gStyle4" onClick="return confirm('Are you sure to sign out?')">Sign out</a></td></tr>
</table>
<br />
  <table border="0" align="center" bgcolor="#669900">
<?php if ($_SESSION['userType'] == 'admin') { ?>
    <tr>
      <td align="center" class="gStyle2">Input Section</td>
      <td align="center" class="gStyle2">Edit Section</td>
      <td align="center" class="gStyle2">Report Section</td>
    </tr>
	<tr>
      <td align="center">&nbsp;</td>
      <td align="center"><form id="form1" name="form1" method="post" action="emp.php" style="margin-bottom:0;" ><input type="submit" name="flg" value="Edit Employee" class="edtBtnStyle"/></form></td>
      <td align="center"><form id="form1" name="form1" method="post" action="empCrit.php" style="margin-bottom:0;"><input type="submit" name="flg" value="Employee Report" class="rptBtnStyle"/></form></td>
	</tr>
	<tr>
      <td align="center">&nbsp;</td>
      <td align="center">&nbsp;</td>
      <td align="center"><form id="form1" name="form1" method="post" action="attendCrit.php" style="margin-bottom:0;"><input type="submit" name="flg" value="Attendance Report" class="rptBtnStyle"/></form></td>
	</tr>
<?php } else { ?>
    <tr>
      <td align="center" class="gStyle2">Report Section</td>
    </tr>
	<tr>
      <td align="center"><form id="form1" name="form1" method="post" action="rptViewer.php" style="margin-bottom:0;"><input type="submit" name="flg" value="Employees Report" class="rptBtnStyle"/></form></td>
	</tr>
	<tr>
      <td align="center"><form id="form1" name="form1" method="post" action="attendCrit.php" style="margin-bottom:0;"><input type="submit" name="flg" value="Attendance Report" class="rptBtnStyle"/></form></td>
	</tr>
<?php } ?>
  </table>
<p>&nbsp; </p>
</body>
</html>
