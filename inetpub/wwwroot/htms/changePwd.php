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

<script language="javascript">
function validateForm () {
	var op = document.getElementById('oldp');
	var np = document.getElementById('newp');
	var npc = document.getElementById('newpc');
	var m = document.getElementById('msg');
	var cap = /[A-Z]+/g;
	var nbr = /[0-9]+/g;
	
	m.innerHTML = 'New Password is valid, please continue to Save';
	if (op.value == "") {
		m.innerHTML = 'Old Password is required';
		op.focus();
		return false;

	} else if (np.value == "") {
		m.innerHTML = 'New Password is required';
		np.focus();
		return false;

	} else if (np.value.length < 6 || np.value.length > 12) {
		m.innerHTML = 'New Password length must be between 6 - 12 characters';
		np.focus();
		return false;

	} else if (cap.test(np.value) == false || nbr.test(np.value) == false) {
		m.innerHTML = 'New Password must contain at least one Capital alphabet and a digit';
		np.focus();
		return false;

	} else if (npc.value == "") {
		m.innerHTML = 'Confirm Password is required';
		npc.focus();
		return false;

	} else if (np.value != npc.value) {
		m.innerHTML = 'Confirm Password does not match New Password';
		npc.focus();
		return false;

	}  
	return true;
}
</script>
</head>

<body>
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<p>&nbsp;</p>

<?php 
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 

if (isset($_POST['save']) && $_POST['save'] != '') { 

	// OLD PASSWORD CHECK
	$selSQL=sprintf("SELECT * FROM user WHERE user_id = %s AND InStrB(user_password, %s) = True AND user_status = 1", 
				GetSQLValueString($_SESSION['uid'], "text"),
				GetSQLValueString($_POST['oldp'], "text"));
	
	$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
		   
	if (odbc_fetch_row($dbRS)) { // CORRECT OLD P
		// SAVE THE CHANGES		
		$updateSQL = sprintf("UPDATE user SET user_password = %s WHERE user_id = %s",
				  GetSQLValueString($_POST['newp'], "text"), GetSQLValueString($_SESSION['uid'], "text"));
	
		$dbRS = odbc_exec($gDBConn, $updateSQL) or die('SQL Error: ' . odbc_error());
		$msg = "alert('Password Updated Successfully');";

	} else {
		$msg = "alert('Old Password is not correct. Please try again or contact IT team');";
	}
}

$pageFor = '';
$pageItem = 'Profile';
$tabTitle = 'Please edit the ' . $pageItem . ':';
$pageFor = 'Edit';
?>

<form id="form1" name="form1" method="post">
  <table width="500" height="250" border="0" align="center" bgcolor="#CDFFFF" class="gStyle4">
<tr>
<td colspan="2" align="center" class="gStyle5"><?php echo($pageItem . ' - ' . $pageFor); ?></td>
</tr>
<tr>
<td colspan="2"><?php echo($tabTitle); ?></td>
 </tr>
  <tr>
    <td width="40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User ID: </td>
    <td width="60%"><input size="7" name="aid" type="text" id="aid" value="<?php echo($_SESSION['uid']) ?>" disabled="disabled"></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" align="center" style="color:#FF0000">Note: New Password length must be between 6 - 12 characters and must contain at least one Capital alphabet and a digit (e.g. A12345, 123Abc) </td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Old Password:</td>
    <td> <input name="oldp" type="password" id="oldp" value="<?php echo(isset($_POST['oldp'])? $_POST['oldp'] : '') ?>" size="20" onChange="validateForm()" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;New Password:</td>
    <td> <input name="newp" type="password" id="newp" value="<?php echo(isset($_POST['newp'])? $_POST['newp'] : '') ?>" size="20" onChange="validateForm()" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Confirm New Password:</td>
    <td> <input name="newpc" type="password" id="newpc" value="<?php echo(isset($_POST['newpc'])? $_POST['newpc'] : '') ?>" size="20" onChange="validateForm()" /></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td colspan="2" align="center" style="color:#FF0000"><div id="msg">&nbsp;</div></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
  <td colspan="2" align="center" bgcolor="#669900">
		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="save" value="Save" class="btnStyle" style="background-color:#6F3" onClick="return validateForm()" tabindex="90"/>	
  </td>
  </tr>
</table>
</form>

<script type="text/javascript">
	document.getElementById('oldp').focus();
</script>

<?php if (isset($msg)) { ?>
<script type="text/javascript"> 
	<?php echo($msg); ?> 
</script>
<?php } ?>

</body>
</html>
