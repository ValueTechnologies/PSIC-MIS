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
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<br />
<form id="form1" name="form1" method="post">
  <table width="350" height="200" border="0" align="center" bgcolor="#00CC00">
    <tr>
      <td colspan="2"><div align="center" class="gStyle2">User Sign In</div></td>
    </tr>
    <tr>
      <td colspan="2" align="center" class="gStyle4">Please enter credentials to continue </td>
    </tr>
    <tr>
      <td align="center">User ID : </td>
      <td><input name="uid" type="text" id="uid" maxlength="10" value="<?php echo(isset($_POST['uid']) ? $_POST['uid'] : '') ?>"/></td>
    </tr>
    <tr>
      <td align="center">Password:</td>
      <td><input name="pwd" type="password" id="pwd" maxlength="10" value="<?php echo(isset($_POST['pwd']) ? $_POST['pwd'] : '') ?>"/></td>
    </tr>
    <tr>
      <td colspan="2" align="center"><input type="submit" name="Submit" value="Login" class="btnStyle" style="background-color:#CCFFCC" /></td>
    </tr>
    <tr>
      <td colspan="2" align="center">
		<?php 	
			$gDatabase = 'HAMS_orignal.mdb';
			require_once('conn.php'); 
		?>
		
		<?php if (isset($_POST['uid'])) { 
			$selSQL=sprintf("SELECT * FROM user WHERE user_id = %s AND InStrB(user_password, %s) = True AND user_status = 1", 
						GetSQLValueString($_POST['uid'], "text"),
						GetSQLValueString($_POST['pwd'], "text"));
			
			$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
			if (odbc_fetch_row($dbRS)) {
				$_SESSION['uid'] = $_POST['uid'];
				$_SESSION['userType'] = odbc_result($dbRS, 'user_type');
				header ("Location: splash.php");
			} else {
				echo ("Invalid User Id and/or Password, please enter again");
			}
		}
		?>
	  </td>
    </tr>
  </table>
</form>
<script type="text/javascript">
 document.form1.uid.focus();
</script>
<p>&nbsp; </p>
</body>
</html>